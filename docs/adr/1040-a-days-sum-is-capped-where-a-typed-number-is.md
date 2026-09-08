# 1040. A day's sum is capped at thirty-eight significant digits, and the cap lives where a typed number's already does

- Status: accepted — the cap was the owner's decision at the Story grill of `add-total-record`
  (#141) on 2026-09-08 (answer 11); where it lives, and how it is detected, are this change's
- Date: 2026-09-08
- Deciders: Diego Bugmann

## Context

A **total** is the one record in this product that accumulates. `CONTEXT.md` § *Total*: the record
is the additions, in the order they were made, and the day's total is their sum, derived and never
stored. Every other record is one value a day holds; a total's day holds many, and what a person
reads is arithmetic over them.

`add-number-entry` (#139) already fixed what one typed number may be. *A day screen reads what an
entry is committed with as a number, as a take-back, or as neither* says: "Up to **thirty-eight
significant digits** SHALL be kept — counted from the first digit that is not a zero to the last
that is not a zero — at every magnitude this system holds", and text saying more is refused rather
than rounded, because "a number nobody typed, kept under a person's name and never mentioned, is
exactly the false record this product exists to remove". `Number.init?` carries no digit bound at
all: the record accepts any `Decimal`, and the bound is on what a *person may commit*.

A sum reopens the question, because a sum can leave the bound that neither of its parts left.
Measured at #141's grill and again while writing its delta, on Apple Swift 6.3.3
(swiftlang-6.3.3.1.3), `arm64-apple-macosx26.0`:

- `Decimal` addition never traps. It yields `Decimal.nan` on true overflow, which needs on the order
  of **10^127 additions** of the largest admissible amount — so a rule that guards only `NaN` guards
  nothing at all.
- A sum stays exact only while its significand fits 128 bits. Past that `Decimal` **truncates toward
  zero**, and `.plain`, `.down`, `.up` and `.bankers` all produce the identical truncated answer.
  `NSDecimalAdd` reports `noError` while digits are being dropped, so the platform offers no
  precision-loss signal to read.
- The truncation is **invisible in its own result**. A day holding a whole number of thirty-eight
  nines, given 0.5, answers thirty-eight nines: a value with thirty-eight significant digits, well
  inside any digit bound, and not the sum. The exact answer needed thirty-nine.
- And the reverse trap: that same day given **1** answers 10^38, which has **one** significant digit
  and is held exactly. A rule written on magnitude would refuse a sum that is perfectly good.

So a day's sum can quietly stop being the sum, and nothing about the sum says so. That is the
failure this product exists to remove, one level of arithmetic up from where #139 met it.

## Decision

**An addition that would take its day's sum past thirty-eight significant digits is refused, the
day's additions stand, and the person is told "Too large to add".** Significant digits are counted
the way #139 counts them — from the first digit that is not a zero to the last that is not a zero —
and they are counted **on the sum arithmetic gives, never on the sum the system would then hold**.

**The cap lives in `day-screen`, not in `record`.** It is judged at the row, in
`DayView.Row.totalRecord(_:asOf:)`, which is the one thing holding both the amount offered and the
day's sum. `Addition` refuses a commitment of the wrong kind, a date it is not due on and an amount
that is not above zero, and nothing else; `History` holds whatever it is given.

**Thirty-eight, not thirty-nine.** `Decimal` holds thirty-nine significant digits only below
2^128−1; admitting thirty-nine would make the answer depend on magnitude rather than on digits, and
would put a second number in a package that has one.

**One place decides.** An internal `Digits` holds both the counting and the test — what a
significant digit is, and whether a day may take an amount — the way `Blank` holds the one answer
to "does this text say anything" (ADR-1039). Nothing else in `DayByDayKit` decides what a
significant digit is. That is deliberately a statement about where the *rule* lives and not about
how many callers it has: `day-screen` asks it twice, once for the bound on a number a person typed
and once for the cap on a day's sum, and those two must agree or the same value is a number when
typed and not a number when summed. Which members the type ends up with moves with the code; that
the counting has one home does not.

## Consequences

- **`record` will accept a day whose sum is not the sum, and the specs say so.** A store file
  hand-written with additions summing past the cap is **read**, and its day answers whatever the
  arithmetic comes to. That is stated in *A store that cannot be read is refused rather than
  emptied* and given a scenario, rather than left as a silence. The grill settled it directly
  (answer 12): refusing the whole store, and dropping the additions past the cap, were both offered
  and declined — the first costs a person every record to protect them from one they cannot have
  made, and the second is silent data loss on read.
- **A reader of `record` alone cannot see the rule.** That is the real price, and it is why this
  record exists: someone meeting a thirty-eight in `day-screen` and none in `record` would otherwise
  assume the record forgot it.
- **Detecting it takes more than a digit count.** The shape the delta was measured against is a
  digit count *and* two subtractions — `(sum − amount) == soFar && (sum − soFar) == amount` — because
  the digit count alone cannot see a truncation that already happened. `add-total-record`'s
  `design.md` § *Measured, not recalled* carries the ten cases it was checked against, and its
  `tasks.md` § 15.2 requires the check re-run through `DayByDayKit` rather than beside it.
- **A third cause joins the notice, and a fourth with it.** ADR-1036's set goes from two to four:
  "Too large to add" is this record's, and "Must be more than 0" arrives beside it. Both pass 1036's
  own test — a person told either does something different, and "try again" is false for both.
- **The bound is unreachable by typing.** A day would have to be added to with a pasted
  thirty-eight-digit amount to meet it. That is the same claim #139 made about one typed number and
  it is true here for the same reason: the rule exists so that no sum is ever quietly wrong, not
  because anyone will meet it.
- **A future kind that accumulates inherits this.** There is no fifth kind, so in practice this is
  the last time the question is asked — but if the product ever holds a running total across days,
  the rule and its detection are in one place to move.

## Alternatives considered

**Put the cap in `Addition.init?`, judged against the day it joins.** `grill.md` § *Notes for
`spec-author`* named it. Rejected on a measured consequence: `record`'s own store re-forms each
addition on its own and applies no rule across a day, so `RecordDocument` would have to call that
initializer with an **empty** history, where the extra argument does nothing. An argument that is a
lie at one of its two call sites is worse than no argument.

**Put the cap in `History.add(_:)`.** The grill's other candidate. Rejected because a store reading
a file whose day sums past the cap would then drop the additions past it while its own mirrored copy
still held them — so the store's history and the bytes it will write next disagree, and the next
change kept at that place writes back records the history never had. A store that reads back
differently from what it holds is the one failure `record`'s store requirements exist to prevent.

**Guard `Decimal.nan` and nothing else.** Rejected on measurement: `NaN` is roughly 137 orders of
magnitude past the point where the sum stops being exact, so the guard would fire for no reachable
input and never for a wrong one.

**Let the sum truncate and say nothing.** Cheapest, and no rule to write. Rejected: it is a false
record with nothing to tell a person it happened, which is the failure named in `CONTEXT.md`
§ *Product principles* and the reason #139 refused a shortened number rather than rounding one.

**Cap the number of additions a day may hold instead.** Simpler to state and to test. Rejected: it
bounds the wrong thing. Ten additions of a pasted thirty-eight-digit amount break the sum, and ten
thousand additions of 0.5 do not; a count would refuse the second and admit the first.

**Say the headroom in the message — "at most N more".** Rejected on ADR-1036's test: the headroom is
a thirty-eight-digit number, so the message would tell a person something they cannot act on, which
is what teaches them to ignore the next one.
