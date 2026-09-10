## Context

See `proposal.md` § *Why* for the motivation and `grill.md` § *Settled* for the ten answers this
delta is written on. What follows is only what shapes the code.

Four facts about the branch as it stands, each measured on 2026-09-10 at `5252fde`, sitting on
`a04e151` (`origin/main`):

1. **`CommitmentsScreen.define(name:on:keptFrom:under:)`** is the whole of how a commitment is
   defined. It forms a `Commitment` through the memberwise initialiser, which has taken a `kind:`
   parameter since #137 and defaults it to `.tick`. Nothing above the seam has ever named one.
2. **`Commitment.Kind`, `Commitment.Range` and `Commitment.Target` are already public and already
   refuse everything this Story surfaces.** `Range.init?` refuses a NaN end and a lowest above its
   highest; `Target.init?` refuses anything not above zero. There is no value work to do below the
   seam — this delta is about reaching those refusals from a form and saying which one fired.
3. **`DayScreen.read(_:)` and `DayScreen.writtenOut(_:)` are `private static`** and are the only
   reading of a typed decimal in the package. They were written for the **number entry** at #139 and
   are called from two places today, the number entry and the total entry. They consult no locale and
   deliberately never hand `Decimal(string:)` the text a person typed, because that initialiser is a
   prefix parser rather than a validator — #139's `design.md` § *Context* measures five ways it reads
   a value nobody typed.
4. **`Blank.saysNothing(_:)`** is the one test this package asks about blank space (ADR-1039), and
   `Digits` is the one place it counts significant digits. Both are package-internal enums sitting
   beside the types that use them; both got there the same way, by a second caller appearing.

The `commitment` capability is the busiest in the repo and this delta restates 56 scenarios it does
not change. That is the price of `MODIFIED`, and § *Why the delta restates so much* below says why it
is paid rather than worked around.

## Goals / Non-Goals

**Goals:**

- One form defines a commitment of any of the four kinds, and the shell decides nothing about what a
  person typed.
- One answer in this system to "is that text a number", shared by the commitments screen and a day
  screen's row rather than written twice.
- The two debt scenarios from #137's second review land as scenarios, with no production change
  expected.

**Non-Goals:**

- **Changing a range or a target.** A range is part of what a commitment *is*, so changing one would
  have to supersede exactly as a rhythm change does, with its own refusal set and a widened change
  sheet. `grill.md` § *Settled* 10 makes it a want, captured as **B-043** on `chore/backlog`.
- **Anything about how a range or a target is drawn.** No number pad, no keyboard type, no inline
  validation as a person types, no placeholder text. Those are the shell's and carry no requirement,
  exactly as the rhythm fields' do not.
- **Any change to what a number entry does.** § *One reading of a typed number* moves code and moves
  nothing else; if a `day-screen` test goes red, that is a stop, not a fix.

## Decisions

### The seam

**`CommitmentsScreen`**, `src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift` — the seam
this capability's screen requirements already attach at, and the one every acceptance test in this
delta drives. No new seam. Four additions and nothing else moves:

```swift
extension CommitmentsScreen {
    /// Which of the four kinds a form is offering. Deliberately not `Commitment.Kind`, which
    /// carries the range or the target as a formed value: this is the picker, and what a person
    /// typed for the other two arrives beside it as text.
    public enum KindChoice: Hashable, Sendable, CaseIterable { case tick, number, note, total }
}

/// The kind to offer for a new commitment. Always the tick.
public var kindToOffer: KindChoice { .tick }

public func define(
    name: String, on rhythm: Rhythm, keptFrom: CalendarDate, under category: String?,
    kind: KindChoice = .tick, lowest: String = "", highest: String = "", target: String = ""
) -> Refusal?

public enum Refusal { /* … */ case rangeIsNotARange, targetIsNotATarget }

public struct Change { /* … */ public let kind: Commitment.Kind }
```

**Why four flat parameters rather than one bundled value.** They are exactly the four fields the
form has, and a bundle would have to be constructed by the shell — which is the moment the shell
starts deciding, since it would have to choose what to put in a `.note` case's absent range. The
requirement *A range or a target left in a field the chosen kind has no room for SHALL be ignored*
is only testable if the leftover text reaches the screen, so the shape has to let it. Defaults on
all four keep the 63 existing `define` call sites compiling and, more importantly, keep the 11
restated scenarios true word for word: a commitment defined through a screen with no kind named is a
tick, which is what those scenarios have always meant.

**Why `kindToOffer` is a property and not a constant on the shell.** It is the same answer
`dayToKeepFrom` gives, for the same reason: a form that chose its own starting kind would be
deciding, in a layer nothing regresses, which kind is the ordinary one.

**`Change` gains the kind although a change cannot ask for one.** That is not an inconsistency; it is
the split the requirement states — *A commitments screen says what a commitment it is asked to change
is made of* is the reading surface, and `change(_:toName:on:keptFrom:under:)` is the writing one.
The sheet fills itself from the first and saves through the second, and the kind reaches it only
through the first. `change`'s signature does not move.

### One reading of a typed number

**`DayScreen.read(_:)` and `writtenOut(_:)` move out to a package-internal `TypedNumber`**, beside
`Blank` and `Digits`, and both screens call it. The commitments screen needs the same three answers
the number entry needs — blank, a number, not a number — and writing a second reader is how two
surfaces come to disagree about whether `1e2` or `0,5` is a number.

The alternative was `Decimal(string:)` at the commitments screen, which is what a reader reaches for
first. It is wrong for the reason #139 measured and wrote down: it is a **prefix** parser, so
`Decimal(string: "40kg")` is 40 and `Decimal(string: "1e2")` is 100. A range end read that way is a
bound a person did not type, kept for the life of the commitment and met months later on a day they
cannot enter a weight on. Refusing to duplicate that decision is the whole of this section.

Two things the move must not do: change any behaviour a number entry has, and change any name a test
asserts on. It is a pure extraction — the same code, `internal` rather than `private`, called from
three places instead of two. `CommittedText`'s `.takeBack` case is the number entry's word for blank
and the commitments screen reads it as "this field is empty"; renaming it is out of scope and would
touch `day-screen`.

### Blank is asked before the reading

A field of blank space is not a number that failed to parse; it is a field nobody filled in. So each
of the three texts is put to `Blank.saysNothing` first, and only then to the reading. It matters
because the two answers go different ways: both range fields blank is *no range* and is kept, while a
range end of `"one"` is a refusal — and a zero-width space, which ADR-1039 fixed as a character
rather than blank space, has to land on the refusal side. That is the same trap `add-note-record`'s
residual round found in a number entry, where a pasted invisible character deleted the day's number.

### Two refusals, not six

`Refusal` gains exactly two cases. The three ways a range fails share one, and the three ways a
target fails share the other, because a notice names a cause a person can act on (ADR-1036) and the
act is identical within each group: put something else in the fields you are looking at. The
existing `rhythmOutOfRange` is precedent, not analogy — it collapses three rhythm failures for the
same reason, in the same enum.

The two are **not** collapsed into one another, because the fields differ: a range sends a person to
two fields under Number and a target to one under Total, and no form shows both at once.

### The kinds of refused change stay at seven

`RefusedChange` is untouched. Adding a *reason* is not adding a *kind of change a person can ask
for* — both new refusals are held as `.defining(…)`, which already exists. *A commitments screen
holds the change it refused and why, one at a time* is deliberately not in this delta, and its
sentence that the kinds "are counted here and numbered nowhere else" needs no help from this Story.

### Where the refusals sit in `define`'s order

`define` answers one refusal, and the existing order — a weekday set with no days, then a rhythm
number, then a name — is not stated by any requirement and is not stated by this one either. The kind
checks go **after** the name check and before the roster is touched, so that a form with two things
wrong reports the same one it reports today. Every scenario in this delta has exactly one thing wrong
with it, deliberately, so nothing here pins an order that nothing else pins.

### Why the delta restates so much

Five of the six requirements are `MODIFIED`, and `MODIFIED` in OpenSpec replaces a requirement whole
— every scenario it keeps has to be written out again. 56 of the 78 scenarios in this delta are
restated verbatim and already have passing, name-matched tests. Two consequences for the
implementer, both in `tasks.md`: only 22 tests are written, and `pnpm run check:scenarios` will
report a high number before a line is written, which is not progress.

The requirement **header** of the define requirement still names three things. It is left exactly as
it is because `openspec` matches a `MODIFIED` requirement by its header text: renaming it would
archive a second requirement beside the first rather than replacing it. It understated before this
Story too — the first line of the requirement is where the count lives.

### `CONTEXT.md`, the ADR, and the open question

**All but the last of these landed in the propose commit and are part of what G4 signs**, which is
this repo's convention: an amendment to shared vocabulary is a decision the human reads at the gate,
not a chore the implementer discovers.

- **`CONTEXT.md` § *Commitments screen*** carries an amendment dated 2026-09-10: the screen defines a commitment from
  five things rather than four, and the 2026-09-09 amendment's reasoning that they are "four rather
  than five" is withdrawn — one form still serves both acts, and the fifth field is shown by a change
  rather than asked for. What the screen says a commitment is made of now includes the kind.
- **`CONTEXT.md` § *Kind*** carries an amendment of one paragraph: a row has read it since #137, and a commitments
  screen now writes it.
- **No new terms.** **Kind**, **Range**, **Target**, **Number**, **Note** and **Total** were all
  agreed at `FEAT: record`'s Feature grill on 2026-09-06 and are unchanged (`grill.md` § *Terms
  landed in CONTEXT.md*).
- **`docs/adr/1046-a-screen-judges-what-was-typed.md`** is written with this delta, and its row is
  the last in `docs/adr/README.md`, because
  answer 2 is a departure a reader will trip over: the interval rhythm's number reaches `define` as
  an `Int` the shell already made, and the range end beside it reaches it as a `String`. That is
  "surprising" in the Definition of Done's sense, and the grill left the call here.
- **`docs/open-questions.md`**'s entry *Two of #137's tests do not match their scenarios clause for
  clause* closes with the two scenarios this delta adds — at the **end** of the work rather than now,
  because closing it claims two tests exist. It is owed to "whichever Story next touches
  `commitment`'s roster or store requirements", which this one does.

## Risks / Trade-offs

- **Moving `read(_:)` out of `DayScreen` touches a shipped capability's code without touching its
  requirements.** → A pure extraction, done in its own commit, with the whole suite run before and
  after. A red `day-screen` test is a stop and a report, not a fix (rule 5).
- **A person can now define a commitment whose kind the app cannot record on.** → It cannot: #141
  closed that hazard by name. Every one of the four kinds has a row that offers something, so there
  is no kind this form can produce that lands on a dead row. `docs/open-questions.md`, 2026-09-08.
- **Two commitments alike but for their kind are two commitments, and a person may not expect it.**
  → It is the roster's shipped rule, and the delta says it out loud rather than softening it: the way
  to "switch Gym to a number" is to define a new commitment, and the old one keeps its history. The
  alternative — a kind that can be changed — re-keys every record ever made against the commitment,
  which is what ADR-1030 refused.
- **The thirty-eight-digit ceiling now refuses a range end the value itself would accept.** →
  Accepted, and it is a reading rule rather than a new refusal: a number this system cannot keep
  exactly is not a number here (ADR-1040), and keeping a bound truncated is a bound the person did
  not type. A number that long is not a mood, a weight or a dose.
- **The form grows to eight fields on one sheet.** → Four of them are shown only under the kind that
  owns them, which is the shell's job and no requirement's. The trade is named because it is the
  second time this sheet has grown in a fortnight.

## Migration Plan

None. No stored form changes: a `Commitment` has carried its kind since #137, `RosterStore` has read
and written it since then, and a roster written before kinds existed already reads back as ticks
(*A roster store reads a roster kept before a commitment carried a kind*). Nothing on anyone's phone
is re-keyed, re-read or rewritten by this Story, and a build without it opens a store a build with it
wrote.

## Open Questions

**None.** The grill closed with `## Left open` empty and said so; every question this delta raised
while it was being written was answerable from the shipped spec or from measured code, which is where
they were answered:

- *Does the screen refuse a range end of more than thirty-eight significant digits, which
  `Commitment.Range` would accept?* Yes — settled from ADR-1040 and #139's reading rather than put to
  the owner, because it is a fact about what this system can keep exactly and not a preference. §
  *Risks* names the trade.
- *Does one reading serve both screens, or two?* One — settled from #139's measurement of
  `Decimal(string:)`, above.
- *Does the define requirement's header change to say five things?* No — settled from how `openspec`
  matches a `MODIFIED` requirement, above.

No residual round is outstanding, so there is no `## Questions for you` section on this document.
