## Context

See `proposal.md` § *Why*. What matters here is the shape of what is already on disk and in the type
system, because this change is the first one in this repo to move a file's form while a real file
exists on a real phone.

`Commitment` is three stored parts and a failable initializer that refuses only a blank name.
`Tick.init?` refuses a commitment on a date it is not due on, and `DayView.Row.tick(asOf:)` returns
whatever that initializer gives it. `RosterDocument` and `RecordDocument` each carry
`static let currentVersion = 1` and each write it into a `version` field; both share one hand-written
coding of a commitment in `CommitmentCoding.swift` — `CommitmentRecord`, `DateRecord`,
`ScheduleRecord` — which was lifted there by `add-roster-store` (#103) so that a fifth schedule shape
would be one compile error rather than two.

Two facts the grill measured and this design turns on:

- **Both stores refuse an *earlier* form as "not a store", and no requirement says so.** Both
  initializers read a `version`-only envelope, throw `.laterForm` when it is above `currentVersion`
  and `.notAStore` when it is below. Nothing in `openspec/specs/commitment/spec.md` or
  `openspec/specs/record/spec.md` asks for the second half of that, which is why this change can fix
  it: the requirement it would contradict does not exist.
- **A store writes nothing on opening.** Both write only inside `add`, `retire` and `remove`. So a
  file in an earlier form stays in that form until the next change is kept there, and this design
  does not have to add a migration step to make that true — it has to not break it.

`CONTEXT.md` § *Kind* through § *Target* fix the vocabulary; the Feature grill landed those six terms
on 2026-09-06, before this Story existed, and this change adds no new one.

## Goals / Non-Goals

**Goals:**

- One place decides what kinds exist, and a fifth kind is a compile error in that place rather than a
  silent gap — the same property `ScheduleRecord`'s exhaustive `switch` already gives schedules.
- Every commitment already on the owner's phone survives, reading back exactly as it did, with no
  step a person has to take and no moment at which the app rewrites a file it was only asked to read.
- The kind's parameters cannot be attached to the wrong kind. A range on a note and a target on a
  tick are not values this change refuses at run time — they are values that cannot be constructed.
- No new seam. Everything new is reachable through `Commitment`, which tests already drive.

**Non-Goals:**

- Recording anything but a tick. A number, a note and a total have no record here: #138, #140 and
  #141 add them, and a commitment of those kinds simply has no record until they land.
- Any screen change. #142 puts the kind on the commitments screen and #139 puts it in the row; the
  shell is untouched by this change and its day-one seed stays nine ticks.
- Changing a commitment's kind after it is defined. That is B-014, and as things stand it would be a
  different commitment.
- A general migration framework. Exactly one step back is supported, from the form before this one,
  and § *Migration Plan* says what a second step would cost.

## Decisions

### The seam

**No new seam.** Every scenario in this delta is driven through boundaries that already exist and are
already named by earlier changes:

- `Commitment.init?(name:schedule:keptFrom:kind:)` and `Commitment.kind` — the kind, its default, and
  identity across all four parts.
- `Commitment.Range.init?(lowest:highest:)` and `Commitment.Target.init?(_:)` — the two parameter
  types' own validity rules, in the same shape `DayOfMonth(day:)`, `DayInterval(days:)` and
  `WeeklyQuota(timesPerWeek:)` already have in `schedule`.
- `Roster.add(_:)` — the duplicate refusal now judging four parts.
- `RosterStore.init(at:)` / `.add(_:)` and `RecordStore.init(at:)` / `.add(_:)` — persistence, and
  reading the form before this one.
- `Tick.init?(_:on:)` and `History.isKept(_:on:)` — the tick's new refusal and what a history answers.
- `DayView.Row.tick(asOf:)` — the row that offers nothing.

`Commitment.Kind`, `Commitment.Range` and `Commitment.Target` are new *types*, not new seams: nothing
drives them except through `Commitment`, and no test spawns a process or captures a stream to reach
one. That is deliberate — `AGENTS.md` says an existing seam beats a new one, and adding a seam for a
value type that only ever travels inside a commitment would buy nothing.

### The kind is an enum with associated values, nested on `Commitment`

```swift
extension Commitment {
    public enum Kind: Hashable, Sendable {
        case tick
        case number(range: Range?)
        case note
        case total(target: Target)
    }

    public struct Range: Hashable, Sendable {
        public let lowest: Decimal
        public let highest: Decimal
        public init?(lowest: Decimal, highest: Decimal)
    }

    public struct Target: Hashable, Sendable {
        public let amount: Decimal
        public init?(_ amount: Decimal)
    }
}
```

An enum with associated values is what makes "a range belongs to a number and a target to a total" a
fact about the type rather than a rule someone has to remember: there is no way to write a note with
a target, and no way to write a total without one. The alternative — a `kind` string beside optional
`range` and `target` properties — was rejected for exactly that: it makes four illegal states
representable and moves the check to run time, where the spec would have to describe refusals that
this shape does not need.

`Range` and `Target` are nested on `Commitment` rather than declared at module scope, and that is not
style. **A module-scope `Range` would shadow `Swift.Range` throughout `DayByDayKit`**, silently
changing what every unqualified `Range` in the module means. Nested, the name is spelled
`Commitment.Range` at every use site and `Swift.Range` keeps its meaning everywhere else. `Target` is
nested beside it for symmetry rather than out of necessity.

Both are failable and both own their own rule, which is why the delta gives each its own requirement:
this is the pattern `schedule` already uses three times, and it keeps `Commitment.init?` doing one
thing — refusing a blank name — rather than growing a second and third guard.

### A number is a `Decimal`, not a `Double`

Recorded as `docs/adr/1032-a-recorded-number-is-a-decimal.md`. Measured on this machine on
2026-09-06, Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`:

| | `Double` | `Decimal` |
|---|---|---|
| ten additions of `0.1` | `0.9999999999999999` | `1` exactly |
| `82.4` through `JSONEncoder`/`JSONDecoder` | exact | exact, and so are `0.0000001` and 28 significant digits |
| `1.10 == 1.1`, and equal hashes | yes | yes |
| infinity | representable; `JSONEncoder` throws on it | not representable |
| not-a-number | representable | representable |

The first row is the decision. #141's total is *the additions made across a day, whose sum is the
day's total*, and a target of 120 grams reached in tenths must actually be reached; in binary
floating point it is not, and the bug would surface as a day that refuses to go green with no visible
cause. The last two rows are why the delta pins a value that is not a number: `Decimal` has no
infinity, so that edge disappears, but it does have a not-a-number value, and **its comparisons are
not symmetric** — measured, `Decimal.nan <= Decimal(5)` is `true` while `Decimal(5) <= Decimal.nan`
is `false`. A range implemented as `guard lowest <= highest` therefore *accepts* a lowest that is not
a number. That is why *A range is a lowest and a highest…* states the refusal outright rather than
leaving it to the comparison, and why one of its scenarios is a range end that is not a number.
`Target` is luckier — `Decimal.nan > 0` is `false`, so `guard amount > 0` refuses it — but the
scenario is written anyway, because the next person to reword that guard should be told.

`Decimal` is `Hashable`, `Sendable`, `Codable` and `Comparable`, all four checked by compiling against
them rather than remembered, so `Commitment` keeps every conformance it has. It comes from
`Foundation`, which `CalendarDate.swift` already imports, so there is no new dependency and no
change to `Package.swift`.

### The default kind is a defaulted parameter, and it is in the spec

`public init?(name: String, schedule: Schedule, keptFrom: CalendarDate, kind: Kind = .tick)`. Every
one of the nine day-one constructions in `ContentView.swift`, the one in `CommitmentsScreen.define`,
the one in `CommitmentRecord.commitment()` and roughly two hundred in the test suite stay valid and
keep meaning what they meant. The alternative — a second initializer, or a mechanical edit adding
`kind: .tick` at every site — would have put a two-hundred-line diff between the reviewer and the
behaviour change.

The default is stated as a requirement rather than left as a Swift detail, because it is the rule
that makes a form-1 file readable and the shell's untouched call correct. A default nobody wrote down
is a default the next change can move by accident.

### The form on disk

`CommitmentRecord` gains one optional field, `kind`, and both documents move to `currentVersion = 2`.
The kind's wire shape follows `ScheduleRecord`'s: **one key per case, and the key's value is that
case's payload.**

```json
{"name": "Gym",     "keptFrom": {…}, "schedule": {…}, "kind": {"tick": {}}}
{"name": "Weight",  "keptFrom": {…}, "schedule": {…}, "kind": {"number": {}}}
{"name": "Mood",    "keptFrom": {…}, "schedule": {…}, "kind": {"number": {"lowest": 1, "highest": 10}}}
{"name": "Journal", "keptFrom": {…}, "schedule": {…}, "kind": {"note": {}}}
{"name": "Protein", "keptFrom": {…}, "schedule": {…}, "kind": {"total": {"target": 120}}}
```

An empty object for a kind that carries nothing is honest rather than elegant: it says *this kind, no
parameters* in one shape that a fifth kind with parameters would not have to break. A bare string
discriminator (`"kind": "number"`) was rejected because the range would then have to sit beside it and
a note could be written with one.

`kind` is **optional in the decoded shape and absent means a tick**. That is the whole of reading form
1: a form-1 document has no `kind` on any commitment, so it decodes into the same type with every kind
absent, and absent is the plain kind. One document type reads both forms, rather than a v1 type and a
v2 type with a conversion between them, because the two shapes differ by one optional field and a
second type would be two places to keep a schedule change in step.

**Nothing sorts by kind.** `RecordDocument` orders its ticks by commitment name, then kept-from day,
then date, then schedule as the last tiebreaker, so that two equal sets of ticks write byte-identical
files. Two commitments differing only in kind cannot both appear there, because only a commitment of
the tick kind forms a tick at all, so the existing tiebreaker is still total and `KindRecord` needs no
`Comparable`. `RosterDocument` is not sorted at all — order is one of the things a roster is.

### The record document moves to form 2 as well, and its ticks are still all ticks

The two documents share `CommitmentRecord` byte for byte, so a record file's bytes change whether or
not a record file can ever hold a non-tick commitment. Keeping the record at form 1 while its
commitments carried a new field would leave the version number saying *nothing changed* about a file
whose shape had; both move, and the shared coding stays one type. The visible consequence is small
and deliberate: every tick a record store holds is of a commitment of the plain kind, so form 2 of the
record file always writes `"kind": {"tick": {}}` and reads it back as the tick it was.

### A store reads the form before it, and rewrites it only when something is kept

Recorded as `docs/adr/1031-a-store-reads-the-form-before-it.md`. Both initializers change one guard.
Today it is `version == currentVersion`, with above throwing `.laterForm` and everything else
`.notAStore`; it becomes **`1...currentVersion`** — the forms this app has actually written — with
above still `.laterForm` and below still `.notAStore`. Nothing else in either initializer moves.

The lower bound is not decoration. `RecordStoreTests.swift` already carries a test writing
`{"version": 0, "ticks": []}` and expecting `.notAStore`; it is an orphan, in that no scenario in
`openspec/specs/record/spec.md` asks for it, and a guard written as "anything below the current form
is decoded" would turn it red. Version 0 is a number no build of this app ever wrote, so it says
nothing about the shape of what follows it and refusing it is right. Both ADDED requirements pin that
now, and `tasks.md` § 6 adopts the orphan test by renaming it onto the scenario that claims it.

There is deliberately no migration pass, no rewrite-on-open and no separate upgrade step. A store
writes when a change is kept and at no other moment (`CONTEXT.md` § *Store*), so a person who opens
the app and changes nothing leaves the file exactly as it was, in the form it was in — which is also
what makes the "changes nothing at its place" scenarios assertable byte-for-byte. The first change
kept there writes the whole document in form 2, as both stores already write the whole document on
every change (ADR-1017).

The asymmetry with a *later* form is the point and is kept: a later form is one this app cannot know
the shape of, so refusing it is the only safe answer; an earlier form is one this app wrote itself.

### Two titles that lag their bodies

*A commitment is a name, a schedule, and the day it is kept from* now covers four things, and *A tick
is of a commitment on a calendar date it is due on* now covers a kind as well. Both were written as
`RENAMED` first, and both renames were taken out after measuring what they do.

**`openspec` 1.10.0 relocates a renamed requirement to the bottom of the spec.** In
`dist/core/specs-apply.js`, the recomposition walks the original spec's blocks and looks each up in a
map keyed by requirement name; a rename deletes the old key and inserts the new one, so the original
block matches nothing during that walk and the renamed block falls through to the "append anything
not in the original order" loop at the end. Measured on 2026-09-06 by copying `openspec/` to a
throwaway directory and archiving this change into it twice:

```bash
cp -R openspec /tmp/sim/openspec && cd /tmp/sim && openspec archive add-commitment-kind -y --json
grep -n '^### Requirement' openspec/specs/commitment/spec.md
```

With the renames, *A commitment is a name, a schedule, the day it is kept from, and the kind its days
take* landed at line 1584 of 1855 — below all fourteen commitments-screen requirements — and *A tick
is of a commitment whose kind is a tick…* fell from the first requirement in `record/spec.md` to the
fifth of six. Without them, both specs keep their reading order, `openspec archive` reports
`added: 5, modified: 7, renamed: 0`, and `openspec validate --all --strict` passes on the result.

A title that undercounts its body is a blemish, and one line of `RENAMED` fixes it the day the tool
preserves position. A spec whose defining requirement sits at the bottom is not recoverable, because
`openspec/specs/` may not be hand-edited (`AGENTS.md` rule 2) and a second rename would only move it
again. So the titles stay and the bodies carry the truth — each opens by saying how many things it is
now about, so nobody reads past the header and is misled. This is a defect in the tool, not a
convention of this repo: it is worth reporting upstream, and `openspec feedback` is how, but that is
the human's call to make rather than an agent's.

### A row for a commitment whose kind is not a tick offers nothing

This is the one consequence the grill did not trace, and it is what makes the Story reach
`day-screen`. `DayView.Row.tick(asOf:)` returns `Tick(commitment, on: date)`, so the new refusal
arrives at the row with no code change at all — but `day-screen`'s requirement says in as many words
that "being due on the date is the whole of what makes a tick formable, so the only row that offers
nothing is one asked as of a day earlier than its own", and that sentence stops being true. A spec
left contradicting itself is worse than a spec that names an interim state.

Two answers were weighed. **The row stays and offers nothing** — chosen. **The day view holds no row
for a commitment whose kind cannot be recorded** — rejected: it contradicts *a day view holds one row
for each of those commitments that is due on that date*, which has passed G4, and #139 would have to
undo it. A due commitment does not leave the day; what it offers is what changes.

The requirement's *title* is not renamed either, and here that is a choice rather than the tool: #139
turns the row into something that offers a number, and naming an interim state in a title that #139
must rewrite would be two renames where one will do.

## Risks / Trade-offs

- **A commitment of a kind nothing can record yet is a row that does nothing when tapped.** → Nothing
  in the shipped app can reach that state today: day one is nine ticks and `CommitmentsScreen.define`
  forms a commitment of the plain kind. #142 makes it reachable and #139 removes it, and the two are
  in different lanes, so the ordering matters. `tasks.md` § 6 records it in
  `docs/open-questions.md` rather than fixing it here, because the fix belongs to whichever of the
  two lands first and is not this Story's to choose.
- **A form-2 file on a phone whose app is rolled back to a form-1 build reads as `.laterForm` and
  refuses to open.** → That is the existing, correct behaviour and this change does not weaken it; the
  file is left untouched for a forward build to read. It is worth knowing before rolling back a build
  on a phone that has kept anything, which is what § *Migration Plan* is for.
- **`Decimal` is heavier than `Double` and slower to compare.** → Irrelevant at this size: the largest
  thing either store holds is one person's roster and one person's history, both written whole on
  every change already. Exactness is what is being bought and it is worth more here than speed.
- **One optional field distinguishing two forms is easy to widen by accident.** → A form-2 document
  with no `kind` on a commitment reads as a tick, exactly as form 1 does. Nothing writes such a
  document, and reading one leniently is the safe direction; but a third form must not lean on the
  same trick twice, and `docs/adr/1031` says so.
- **Sixty-four scenarios are restated verbatim across seven MODIFIED requirements**, which is a large
  diff for a reviewer to read as "unchanged". → `tasks.md` § 1 keeps every existing test's name and
  assertions frozen and verifies against the measured 391-passing baseline before a single new test
  is written, so a changed answer inside the restatement shows up as a red test rather than as a line
  in a diff.

## Migration Plan

There is no deployment step and nothing for a person to do.

1. The owner's phone holds a roster file and a record file, both at form 1 (verified by reading the
   code that wrote them; both `currentVersion` constants are `1` on `main`).
2. The new build opens each, sees a version below the one it writes, decodes it, and reads every
   commitment as of the plain kind — which is what every one of them is.
3. Nothing is written. Both files stay at form 1, byte for byte, until the first tick or the first
   commitment taken on after the upgrade, at which point that file alone is written whole at form 2.
4. **Rolling back** to a build that writes form 1 is safe for any file still at form 1, and refuses to
   open any file that has reached form 2 — refuses, rather than emptying, so nothing is lost and a
   forward build recovers it. There is no downgrade path and none is wanted: the way back is forward.

A *second* step back — a future form 3 having to read form 1 as well as form 2 — is not designed for
here. One optional field is what makes this step free, and a form 3 that needs more should say what
each earlier form means rather than adding a second optional field. `docs/adr/1031` carries that as
the reversal trigger.

## Open Questions

**None.** The grill's `## Left open` says "None." and gives its reason, and writing the delta turned
up nothing that has to be answered before the code is written:

- The one edge the grill did not reach — what a row does for a commitment whose kind is not a tick —
  is settled above rather than deferred, because one of the two answers contradicts a requirement
  that has already passed G4 and the other does not. That makes it a fact about the existing spec
  rather than a preference, and `AGENTS.md` § *Grilling* puts finding facts on this side of the line.
- The two floating-point edges, the wire shape and the `Decimal` choice were all measured on this
  machine rather than assumed, and the measurements are in § *Decisions*.
- What a number, a note and a total commitment's days actually take is genuinely unanswered, and is
  genuinely not this Story's: #138, #140 and #141 each carry one of them, and none of their answers
  changes a requirement here. That is a scope boundary rather than an open question.
