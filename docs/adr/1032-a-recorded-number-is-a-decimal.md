# 1032. A number a person records is a `Decimal`, not a `Double`

- Status: accepted
- Date: 2026-09-06
- Deciders: Diego Bugmann
- Amended: 2026-09-10 — why a comma and a full stop are read alike is recorded here, as a
  consequence of this choice rather than a rule of one screen's; `condense-day-screen-spec` (#201)
  deletes the requirement prose that carried the argument.

## Context

`add-commitment-kind` (#137) introduces the first number this product stores that a person typed:
the two ends of a **range** on a number commitment, and the **target** on a total commitment. Two
more follow in the same Feature — the number a day holds (#138) and each addition to a total (#141) —
and all four are the same kind of number, so the type chosen here is the type all of them get.

The reach for `Double` is automatic and it is wrong here for one specific reason. `CONTEXT.md`
§ *Total* defines a total as *the additions made across a day, in the order they were made, whose sum
is the day's total*, kept when that sum **reaches** the commitment's target. Protein after each meal;
a supplement taken twice. So the product asks a sum of typed decimals to hit a typed decimal exactly.

## Decision

**Every number a person records or declares is a Foundation `Decimal`.**

Measured on this machine on 2026-09-06, Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target
`arm64-apple-macosx26.0`:

| | `Double` | `Decimal` |
|---|---|---|
| ten additions of `0.1` | `0.9999999999999999` | `1` exactly |
| `82.4` through `JSONEncoder` and back | exact | exact, and so are `0.0000001` and 28 significant digits |
| `1.10 == 1.1`, with equal hashes | yes | yes |
| infinity | representable; `JSONEncoder` throws when asked to write one | not representable |
| not-a-number | representable | representable |

The first row is the decision. A target of 120 grams reached in tenths must actually be reached, and
in binary floating point it is not; the bug would arrive as a day that refuses to go green with
nothing on screen to explain it, which is the hardest kind of bug this product could have.

`Decimal` is `Hashable`, `Sendable`, `Codable` and `Comparable` — all four checked by compiling
against them rather than remembered — so `Commitment` keeps every conformance it has and both
documents keep deriving theirs. It comes from `Foundation`, which `CalendarDate.swift` already
imports, so this adds no dependency and does not touch `Package.swift`.

**One trap comes with it and is written down here because it is not visible at the call site.**
`Decimal`'s comparisons against its not-a-number value are **not symmetric**: measured,
`Decimal.nan <= Decimal(5)` is `true` while `Decimal(5) <= Decimal.nan` is `false`. A range validated
as `guard lowest <= highest` therefore *accepts* a lowest that is not a number. Every rule about
these numbers must refuse a value that is not a number **outright**, rather than relying on a
comparison to do it. `openspec/specs/commitment/spec.md` says so in *A range is a lowest and a
highest…* and in *A target is a number above zero*, and each carries a scenario that fails an
implementation that leans on the comparison.

**A second thing comes with it and is not visible at the call site either: a comma and a full stop
are the same separator.** An iPhone's decimal keypad prints whichever one the region the phone is
set to says, so a field that refuses the key on its own keyboard is broken. Every place in this
product that reads a decimal a person typed therefore takes either and reads both the same way, so
the number kept is the same number whichever key the keypad drew. That belongs here rather than on
a screen, because it follows from a person typing the number this record chose the
type for: the day screen's entries, the commitments screen's range and target, and anything later
that reads a typed decimal all inherit it. A requirement states the rule; the reason is this line.

## Alternatives considered

**`Double`.** Rejected on the first row of the table. It also brings infinity, which `Decimal` does
not have and which `JSONEncoder` refuses to write — so a target of infinity would form, be
unreachable for ever, and then fail on the way to disk rather than at the moment it was made.

**`Int`, in the smallest unit — grams, tenths of a kilogram, mood points.** Genuinely tempting, and
what a currency-shaped domain would use. Rejected because there is no single smallest unit here: a
weight wants a tenth of a kilogram, a supplement wants a half dose, a mood wants a whole number, and
`CONTEXT.md` § *Number* is explicit that the value carries **no unit** — the commitment's name says
kilograms. A scale factor the type does not carry is a scale factor someone eventually gets wrong.

**A decimal stored as a string, parsed at the edges.** Rejected as `Decimal` with extra steps: it
was the fallback if `Decimal` had lost precision through JSON, and the second row of the table says
it does not.

## Consequences

- **`Commitment.Range.lowest`, `Commitment.Range.highest` and `Commitment.Target.amount` are
  `Decimal`**, and so is every number `record` gains in #138, #140 and #141. A Story that reaches for
  `Double` is a review finding.
- **The on-disk form writes them as JSON numbers**, exactly, both ways. Anything that puts one
  through a `Double` on the way to or from the file loses that, which is what the scenario *a range
  and a target are read back exactly, decimal fractions and all* exists to catch.
- **`Decimal` is slower and larger than `Double`.** Irrelevant at this size: the biggest thing either
  store holds is one person's roster and one person's history, and both are written whole on every
  change already.
- **The reversal trigger is a number this product needs that `Decimal` cannot hold** — something
  beyond 38 significant digits, or a genuine need for infinity. Neither is imaginable from the
  owner's week, and if one arrives this ADR is amended in place (ADR-1020).
