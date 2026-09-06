## Context

See `proposal.md` § *Why*. What matters here is what `record` is made of today, because this change
adds a second kind of record to a capability that has only ever had one, and moves a file's form for
the second time in a week.

`Tick` is two stored parts and a failable initializer with two guards — due on the date, and the
commitment's kind is a tick. `History` holds `private var ticks: Set<Tick>` and answers exactly one
question, `isKept(_:on:)`, by re-forming the tick and asking `contains`; `RecordDocument.swift:8–11`
calls reading a record back out "the direction that has no public way through". `RecordStore` mirrors
the set it holds, because `History` will not give it back, and writes the whole document on every
change. `RecordDocument.currentVersion` is `2`, and `RecordStore.init(at:)` already guards
`(1...RecordDocument.currentVersion).contains(envelope.version)`, so moving the constant to `3` reads
forms 1, 2 and 3 without a line changing.

Four facts the grill measured and one this design re-measured on this machine on 2026-09-06, Apple
Swift 6.3.3 (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`:

| measured | result |
|---|---|
| `Decimal.nan == Decimal.nan` | `true` — unlike IEEE-754 |
| `Decimal.nan < Decimal(5)`, `Decimal.nan < Decimal(-5)` | `true`, `true` |
| `Decimal(5) <= Decimal.nan` | `false` |
| `Decimal(40) <= .nan && .nan <= Decimal(150)` | `false`; `.nan <= Decimal(150)` alone is `true` |
| `Decimal.nan.isNaN` / `.isFinite` | `true` / `false`, and `Decimal.infinity` does not compile |
| `JSONEncoder().encode(Decimal.nan)` | writes `{"value":NaN}`, which `JSONDecoder` then refuses as `dataCorrupted` |
| `70.5`, `0.1`, `1.10` and a 28-digit value through `JSONEncoder`/`JSONDecoder` | exact, with no binary-float artifacts |
| `struct Number` at module scope | compiles; nothing in `Swift` or `Foundation` claims that name |

`CONTEXT.md` § *Number*, § *Range* and § *Taking back* fix the vocabulary; the Feature grill landed
those on 2026-09-06, before this Story existed, and this change adds no new term. It does correct two
entries that writing the delta made wrong — see § *Two entries in `CONTEXT.md` go stale*.

## Goals / Non-Goals

**Goals:**

- "At most one number per commitment per day" is **structural** — a shape in which a second number
  for a day cannot coexist with the first — rather than a rule an `add` remembers to enforce.
- A number that is not a number cannot reach a file. The one place a number is made refuses it, so
  no `Decimal` that `JSONEncoder` cannot write ever gets near a store.
- A number read back is the number that was entered, digit for digit, with no place in the path where
  a `Double` could be substituted for a `Decimal` without a test going red.
- No new seam. Everything new attaches where `record`'s tests already attach.
- The record file's three forms each have a stated shape, so the version number decides what may be
  in the file rather than describing it after the fact.

**Non-Goals:**

- A general record. `History` gains a number-shaped reader and a number-shaped take-back, not the
  shape all four kinds will eventually share. Settled at the grill: two of the four kinds do not
  exist yet, and fixing the general shape now would fix it around records nobody has grilled.
- Anything a screen does with a number: entering one, drawing one, the mood slider, or a row that
  offers more than a tick. All #139's.
- A migration framework. There are three forms, they differ by absence, and § *The form on disk* says
  what a fourth would cost.
- Any change to `Tick`, `Commitment`, `Commitment.Range`, `CommitmentCoding.swift`, the roster or the
  app shell.

## Decisions

### The seam

**No new seam.** Every scenario in this delta is driven through `record`'s two existing boundaries —
the record types and the store — and no test spawns a process or captures a stream to reach one:

- `Number.init?(_ number: Decimal, for commitment: Commitment, on date: CalendarDate)` — formation
  and all four refusals. This is a new *entry point* and not a new seam: it sits exactly where
  `Tick.init?(_:on:)` sits, in the same module, driven the same way by the same test file.
- `History.add(_ number: Number)`, `History.number(for:on:)`, `History.removeNumber(for:on:)` — what
  a history holds, answers and lets go of. `History.isKept(_:on:)` is unchanged in signature and
  widened in meaning.
- `RecordStore.init(at:)`, `.add(_ number: Number)`, `.removeNumber(for:on:)` and `.history` —
  persistence, the third form, and the two earlier ones.

`RecordedDay` (below) is internal and is driven by nothing; it is a shape, not a boundary.

### `Number` is its own type, and the reader is number-shaped

```swift
public struct Number: Hashable, Sendable {
    let commitment: Commitment
    let date: CalendarDate
    let number: Decimal

    public init?(_ number: Decimal, for commitment: Commitment, on date: CalendarDate)
}

/// A commitment on a day. Internal: it is how a history and a store each hold at most one number
/// per commitment per day, without either of them enforcing it.
struct RecordedDay: Hashable, Sendable {
    let commitment: Commitment
    let date: CalendarDate
}
```

Three properties, all internal, exactly as `Tick`'s two are. The initializer's guards, in order:
the commitment is due on the date; its kind is `.number`; the value `!isNaN`; and, where the kind
carries a range, `range.lowest <= number && number <= range.highest`.

**The NaN guard is written out rather than left to the range**, and the order matters. Measured
above: `Decimal.nan <= Decimal(150)` is `true` and `Decimal(40) <= Decimal.nan` is `false`, so the
two-sided range check happens to refuse a NaN — but a number commitment **with no range** runs no
check at all, and that is the common case (a weight). Leaving it there would let a NaN into a
`History` where, because `Decimal.nan == Decimal.nan` is `true`, it would compare and dedupe as an
ordinary value; and into a file, where `JSONEncoder` writes the bare token `NaN`, `JSONDecoder`
refuses the result as `dataCorrupted`, and `RecordStore.init` turns any decode failure into
`.notAStore(at:)` — **every record in that file refused, not the one**. One guard at formation is
what makes that unreachable, and it is why the delta states the refusal outright.

The alternative — one `Record` enum with a `tick` and a `number` case, and one general reader —
was rejected on the grill's Settled 5. A general shape is worth fixing when the things it has to
generalise over exist; a note is text and a total is a list of additions whose sum is compared to a
target, and neither has been grilled. Fixing the shape now would fix it around two records nobody has
described, and unfixing it would cost `record`'s whole public surface. Two more Stories is a cheap
wait. The cost accepted in exchange is named under § *Risks*.

**`Number` at module scope, not `Commitment.Number`.** `Commitment.Range` is nested because a
module-scope `Range` would shadow `Swift.Range` throughout `DayByDayKit` (ADR from #137's
`design.md`); `Number` shadows nothing — checked by compiling `struct Number` against `Foundation`
rather than remembered — and it belongs beside `Tick`, which is what it is a sibling of. `Number`
next to `Commitment.Kind.number` is exactly the pair `Tick` and `Commitment.Kind.tick` already are.

### A history holds numbers in a map keyed by the day

```swift
private var ticks: Set<Tick>                    // unchanged
private var numbers: [RecordedDay: Decimal]     // new

public mutating func add(_ number: Number)
public mutating func removeNumber(for commitment: Commitment, on date: CalendarDate)
public func number(for commitment: Commitment, on date: CalendarDate) -> Decimal?
public func isKept(_ commitment: Commitment, on date: CalendarDate) -> Bool   // widened
```

A dictionary keyed by the day rather than a `Set<Number>` is the whole of "entered again it is
replaced": a subscript assignment *is* the replacement, and there is no shape in which two numbers
for one day both exist. A `Set<Number>` would hold both — `Number` is `Hashable` on three parts,
including the value — and `add` would have to find and remove the old one first, which is a rule
someone can drop. `History` stays `Hashable` by synthesis: `Dictionary` is `Hashable` where its key
and value are, and both are, checked by compiling rather than remembered.

`number(for:on:)` returns the `Decimal` and not the `Number`, because a `Number`'s parts are internal
and the caller already holds the commitment and the date it asked with — the only thing it does not
have is the value. `isKept` becomes `ticks.contains(tick) || numbers[day] != nil`, evaluated against
whichever of the two the commitment's kind can produce.

`removeNumber(for:on:)` deliberately does **not** mirror `remove(_ tick:)`. Recorded as
`docs/adr/1033-a-number-is-taken-back-by-naming-the-day.md`: a tick is nothing but its commitment and
its date, so handing one back names the day anyway; a number has a third part, and requiring it would
make clearing a mistyped 300 depend on first reading back the 300. The name says `Number` because
`remove(_:)` is already taken by a different-shaped operation and an overload set where one member
takes a value and another takes two coordinates reads as a mistake.

### The form on disk

`RecordDocument.currentVersion` moves to `3` and the document gains one field:

```json
{
  "version": 3,
  "ticks":   [ {"commitment": {…}, "date": {"year": 2026, "month": 8, "day": 31}} ],
  "numbers": [ {"commitment": {…}, "date": {"year": 2026, "month": 8, "day": 31}, "number": 70.5} ]
}
```

`NumberRecord` is the wire shape, beside `TickRecord`, in `RecordDocument.swift`. `Decimal` encodes
as a JSON number and round-trips exactly (measured above), so the number is written as a number and
not as a string; the one `Decimal` that would break that is a NaN, and no `Number` can carry one.
`CommitmentRecord` is reused unchanged, so `CommitmentCoding.swift` is not edited and the roster
store — which shares that file — stays at form 2.

`numbers` is sorted by the same key `ticks` already uses: commitment name, then kept-from day, then
date, then schedule. Two numbers cannot tie on all four, because a day holds at most one, so the
existing tiebreaker is still total and the file stays byte-stable.

### Each form is read as the shape that form has

`RecordStore.init(at:)` already reads the envelope's `version` before the body, and already accepts
`1...currentVersion`. What this change adds is one check in the other direction: **the `numbers`
field is present exactly at the form that writes it.** A document declaring form 1 or form 2 that
carries `numbers` is refused as `.notAStore`, and so is one declaring form 3 that does not.

This is `docs/adr/1031`'s own reversal trigger firing, and it is answered the way that ADR asked
rather than the way that is one line cheaper. 1031 says a third form "should say what each earlier
form means — a decode path per form, chosen off the version — rather than adding a second optional
field and inferring", because a document read leniently on N optional fields is a document whose
shape nobody can state. The lenient reading would be free here: JSON decoding ignores unknown keys,
and an optional `numbers` absent-means-none would read all three forms with no guard at all. It is
rejected because it would make the version number decorative — every form would accept every other
form's shape — and because the failure that follows is silent: a file this app never wrote would be
read as though it had, and the next write would launder it into a form-3 file.

**The guard is one comparison rather than three decode functions**, and that is a deliberate reading
of 1031 rather than a departure from it. What 1031 wanted was that each form's shape is *stated and
enforced*; three forms differing only by the presence of one array get that from one check against a
version already in hand. Three decode paths would be scaffolding around it.

**The `kind` field's absence-means-tick rule is left exactly as it is**, and is not tightened the
same way. It could be — form 1 has no `kind` and forms 2 and 3 always write one — but `kind` lives in
`CommitmentRecord`, which `RosterDocument` shares and whose own version is 2 and not moving. Reaching
into the shared coding to thread a version through it would edit the roster's path to protect against
a hand-edited file nobody has seen. That line is drawn here so the next person does not have to
re-derive it, and `docs/adr/1031`'s amendment says the same.

`docs/adr/1031` is **amended in place** rather than superseded, per ADR-1020: it is the decision in
force, the amendment is what its own trigger asked for, and a `- Amended: 2026-09-06` stamp goes in
its header block. The new reversal trigger it carries: a **fourth** form, or any form that differs
from an earlier one by something other than a field being present or absent — at which point the
shape can no longer be checked with a comparison and the decode path per form is owed for real.

### Three titles that lag their bodies

*A history answers whether a commitment was kept on a day from the **ticks** it holds* answers from
numbers too; *A store reads a history kept **before a commitment carried a kind*** reads two earlier
forms; and *A tick is of a commitment on a calendar date it is due on* now describes what a history
holds beside ticks. All three were written as `RENAMED` first and all three renames were taken out.

**`openspec` 1.10.0 relocates a renamed requirement to the bottom of the recomposed spec.** #137
diagnosed it in `dist/core/specs-apply.js` — the recomposition walks the original spec's blocks and
looks each up by its *old* name, so a renamed block matches nothing and falls through to the
append-what-is-left loop at the end — and this branch re-measured the effect on this delta rather
than inheriting the claim, by archiving into a throwaway copy of `openspec/` twice:

```bash
cp -R openspec /tmp/renamesim/openspec && cd /tmp/renamesim
openspec archive add-number-record -y --json
grep -n '^### Requirement' openspec/specs/record/spec.md
```

Without renames, `record/spec.md` keeps its reading order exactly: *A store reads a history kept
before a commitment carried a kind* stays first and *A tick is of a commitment on a calendar date it
is due on* stays second, with the three new requirements appended after the six that were there.
`openspec archive` reports `added: 3, modified: 5, renamed: 0`, and
`openspec validate --all --strict --no-interactive` passes on the result — five specs, none failing.

The same run with the three requirements renamed reports `renamed: 3` and moves all three below every
requirement they used to precede: the spec then **opens on *A tick can be taken back***, and which
forms a store reads, what a tick is, and what a history answers about being kept fall to fourth,
fifth and sixth of nine — every one of them below *A store that cannot be read is refused rather than
emptied*, which exists to qualify them.

A title that undercounts its body is a blemish that one line of `RENAMED` fixes the day the tool
preserves position. A spec whose defining requirements sit at the bottom is not recoverable, because
`openspec/specs/` may not be hand-edited (`AGENTS.md` rule 2) and a second rename only moves it
again. So the titles stay and the bodies carry the truth. This is a defect in the tool rather than a
convention of this repo; `openspec feedback` is how it would be reported, and that is the human's
call to make rather than an agent's.

### Two entries in `CONTEXT.md` go stale

Writing the delta made two vocabulary entries wrong rather than merely incomplete, so both are
amended in this folder and ship in the G4 diff:

- **§ Store** says a store "reads exactly the forms this app has written: the one it writes now and
  the one before it". It reads every form it has written, and there are three.
- **§ Record store** says it keeps "every tick added and not since taken back". It keeps every tick
  and every number.

No term is added. **Number**, **Range** and **Taking back** were landed by the Feature grill on
2026-09-06, and `grill.md` § *Terms landed in `CONTEXT.md`* records that this Story's grill added
none either.

## Risks / Trade-offs

- **A number-shaped reader now, a general one later, means `History`'s public surface changes again
  when #140 and #141 land.** → Accepted deliberately and settled with the owner at the grill. The
  cost is a rename and a re-shape inside one module with no persisted form depending on it; the cost
  of guessing the general shape now is a wire format and a spec written around a note and a total
  nobody has described. `record`'s file on disk does not depend on the reader's shape either way.
- **`isKept` now means two things and reads one of them per commitment kind.** → It is one question
  with one answer, and `day-screen` asks it without knowing which kind produced the answer — which is
  exactly why a number commitment's row goes green through a requirement that has already passed G4
  and needs no change. The risk is that a fifth kind is added and `isKept` is not extended; the
  exhaustive `switch` over `Commitment.Kind` that `KindRecord` already carries is what makes a fifth
  kind a compile error, and `Number.init?`'s kind guard is a second.
- **Two files at three forms between them, on a phone that may sit at any of them.** → The record
  file can be at 1, 2 or 3 and the roster file at 1 or 2, independently, and every combination opens.
  § *Migration Plan* walks it. The combination nothing handles is a *later* form, which is refused
  and left untouched, as it always was.
- **The shape-against-form check refuses a file no user can produce.** → True, and it is one
  comparison and one scenario. It buys that "the forms this app has written" is a statement with
  teeth rather than a comment, which is what `docs/adr/1031` asked for in exchange for a third form.
  The same objection applies to the already-shipped refusal of version 0, which nothing can produce
  either.
- **Thirty-seven scenarios are restated verbatim across five MODIFIED requirements**, which is a
  large diff for a reviewer to read as "unchanged". → `tasks.md` § 1 verifies the measured
  418-passing baseline before a single new test is written and freezes every existing test's name and
  assertions, so a changed answer inside a restatement shows up as a red test rather than as a line
  in a diff. The one existing edit — eleven fixtures that say `3` to mean *a later form* becoming
  `4` — is listed by file and line there.

## Migration Plan

There is no deployment step and nothing for a person to do.

1. The owner's phone holds a record file at form 1 or form 2 — form 1 if nothing has been ticked
   since #137 shipped, form 2 if something has — and a roster file at form 1 or form 2 by the same
   rule. Both are read by the code that wrote them.
2. The new build opens the record file, reads a version at or below the one it writes, checks that
   the shape matches that version, and decodes it: every commitment in a form-1 file is of the plain
   kind, and no day in a form-1 or form-2 file holds a number.
3. Nothing is written. The file stays in the form it was in, byte for byte, until the first tick or
   the first number kept after the upgrade, at which point it is written whole at form 3.
4. The roster file is not touched by this change at all and stays at whatever form it is in.
5. **Rolling back** to a build that writes form 2 is safe for any record file still at form 1 or 2,
   and refuses to open one that has reached form 3 — refuses rather than emptying, so nothing is lost
   and a forward build recovers it. There is no downgrade path and none is wanted.

A **fourth** form is where the cheap answer runs out: three forms differ from one another only by a
field being present or absent, which is what lets one document type read all three under one
comparison. `docs/adr/1031`'s amended reversal trigger says so.

## Open Questions

**None.** `grill.md` § *Left open* says "None." and gives its reason, and writing the delta turned up
nothing that has to be answered before the code is written. Four things it did turn up, and why each
is settled here rather than asked:

- **How strictly the three forms are told apart.** A real fork, and it changes one clause and one
  scenario in the delta — but `docs/adr/1031` is an accepted decision that names this exact trigger
  and says what to do at it. Following a signed decision is execution, not a preference, so it is
  settled in § *Each form is read as the shape that form has* and the ADR is amended to say what was
  actually done.
- **Where a value that is not a number is refused.** Settled 7 chose the explicit refusal; the three
  measurements in § *Context* are why it cannot be left to the range, and they are facts rather than
  preferences.
- **Whether taking back a number that was never there is an error.** It is not, and that follows from
  *Untick* in `CONTEXT.md` — "taking back a tick that was never there is nothing rather than an
  error" — rather than being a new choice.
- **What a note and a total commitment's days take.** Genuinely unanswered and genuinely not this
  Story's: #140 and #141 carry one each, the delta says they are *not kept* until then, and neither
  answer changes a requirement here. A scope boundary rather than an open question.
