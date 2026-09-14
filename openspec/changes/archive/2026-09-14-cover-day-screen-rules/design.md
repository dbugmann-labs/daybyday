## Context

`proposal.md` § *Why* says what this is for; `grill.md`'s settled answers are what the delta is
written on. `openspec/specs/day-screen/spec.md` holds 51 requirements; the delta carries 16 of them
whole, every sentence and existing scenario verbatim but the one sentence § *Reworded after
`cover-record-rules`* names, with 21 new scenarios. Spec line numbers below are as of `6078297`.

Every new scenario drives `DayScreen` through members that already ship. Read in source, all 21 are
expected green on arrival, on these measured facts: a record or roster place that is a directory makes
`Data(contentsOf:)` throw "Is a directory", which `DayScreen` answers as `.unreadable` and `.notKept`;
`RecordStore.removeNumber` writes only where the day holds a number (a return before writing since
`3d7688f`), so a place that cannot be written refuses only that; `Decimal(string:)` gives `nil` for a one followed by two hundred zeros and holds a
one followed by fifty zeros, a one at the fifty-first decimal place, and thirty-eight nines followed by
ten zeros exactly; `Roster.remove` keeps the category a commitment is under.

## Goals / Non-Goals

**Goals:** each testable uncovered `day-screen` rule gets exactly one scenario that would fail were the
rule broken, plus the test named for it; the rules nothing can prove are recorded under *Known gaps*.

**Non-Goals:** no rule reworded but the one `main` made false, no scenario dropped or edited, no heading changed, no other
capability, no condensing of a carried requirement already over budget (grill answer 5). No mutation
run. No change to `src/` unless a new test is red on arrival.

## Decisions

### The seam

No member is new or changed. Every new scenario is driven at shipped members of `DayScreen`:

```swift
init(startingFrom dayOne: [Commitment], asOf today: CalendarDate, keepingRecordAt recordPlace: URL, keepingRosterAt rosterPlace: URL)
func tick(_ row: DayView.Row) throws
func enter(_ text: String, on row: DayView.Row) throws
func showPreviousDay()
func showNextDay()
func showToday()
func showDay(_ day: CalendarDate)
func shown(asOf today: CalendarDate)
func returnedTo()
var dayView: DayView { get }; var previousDayView: DayView? { get }; var nextDayView: DayView? { get }
var dayPickerReach: Reach { get }; var recordState: RecordState { get }; var rosterState: RosterState { get }; var notice: Notice? { get }
```

### One scenario per rule, each built to fail against a named wrong implementation

Grill answers 2, 6 and 10. One line per covered rule (grill answer 4), which is why this decision runs
to 34 lines against 12, as § *The seam* runs to 17 at one line per member: splitting either would only
move the same lines.

| Rule (spec lines) | New scenario catches |
|---|---|
| a screen not keeping its roster moves and says so (211) | a screen that does not move, or a move that resets the roster's state or its reason |
| a move forms from the record with every change kept since (208–210) | a move, return or pick formed from the record as first read |
| going back to today reads neither store again and leaves what it says of either alone (291–293); the record half is covered at 333 and 4109 | a return to today that reads the roster again, or resets what it says of a roster it is not keeping |
| today's view is formed on the roster's answer for that today (290–291, 547–548) | a return formed on the answer for the day left |
| a refused tick is not held to be kept later (474) | a tick queued and written once the record reads, or with the next change that is kept |
| every refusal to open is answered one way (476) | a file-system read error answered other than as unreadable |
| a removed commitment is drawn as a stopped one, group included (551–552) | a removed commitment lifted out of its category |
| no later version is named for another refusal (763–765) | a roster read error named a later version |
| significant digits run from first to last non-zero (982–983) | a count that takes in leading or trailing zeros |
| too large a number is not fitted (983–984) | a magnitude past what can be held rounded or clamped |
| spaces among the digits are not a number (986) | spaces stripped from inside the text before reading |
| the absence at an end is about the calendar alone (1912–1915) | an absence keyed to rows, places or today |
| every change on a neighbour row changes and tells nothing (1948–1955) | a note, addition, take-back or refused value reaching a neighbour row, or moving what is told |
| the reach is not narrowed to commitments due (2157–2158) | a reach over commitments due on the day shown, or from a first due date |
| the reach is read again whenever the roster is (2241) | a reach read again on a return and not on a showing again |
| saying a neighbour keeps nothing at either place (2344–2345) | a neighbour read that writes the record |
| a tick does not change what is said of the roster (2807–2808) | a tick that reads the roster again |
| a showing again carries no reason over (2887–2889) | a later-version reason kept once the place reads as garbage |
| a screen not keeping a record tells nothing, whatever was committed (3379–3381) | a value checked before the record's state |
| a return where the roster cannot be read says so and draws no rows (3498–3499) | a return that keeps the old state or the old rows |
| a take-back reaches the place only where the day holds a number (3599–3601, reworded) | a take-back written, and so refused, where the day holds none; or skipped where it holds one |

The roster half of 291–293 is proven by extending *going back to today does not read the roster
again* rather than by adding a scenario. Both halves are one rule, so a second scenario would break
one scenario per rule. Its title stays true, because a later-version roster whose place is emptied
after the move tells apart a return that leaves the state alone from one that reads the roster again
or resets the state to kept.

### Re-verified: covered already, reclassified, or pointers

Grill answer 3. **Covered by the existing scenario at the spec line given**, so no scenario: 648–649 and
762 (685); 827–828 (880); 978 (1026); 2005–2006 (2073); 2803 (2818); 3378 (3430); 475 (533); C6 and C8a
as grill answer 7 names. **Reclassified unprovable:** 1717, a total row's take-back not widening
*offers anything* — a take-back is offered only where a total entry is, so no widening changes the
answer (meaning, same answer). **Pointer sentences skipped** (ADR-1047 decision 7.3): 553, 1953–1954,
2236–2237, 3377–3378 "apart from the four causes named above", 3496–3497, and 3766–3767, whose target
is 3599–3601. One rule is reworded, below; every carried block is otherwise byte-identical but for its
added scenarios.

### Reworded after `cover-record-rules`, because `main` made the sentence false

The human's answer to a rule-5 stop, 2026-09-14, overriding grill answer 6's wording of C5. `3d7688f`
(#230) made every `RecordStore` change return without writing where the history would not change, so
a take-back on a day holding no number no longer reaches the place, and is never refused. ADR-1047
decision 7.5: the least rewording that is true against the code on `main`, within the carried
requirement *A day screen enters the number…*, and nothing else in that block moves.

- *Before:* "Taking one back SHALL reach the place whether or not the day holds a number, and SHALL be
  refused only by the place."
- *After:* "Taking one back SHALL reach the place only where the day holds a number, and SHALL be
  refused only by the place."

The note twin at 3766–3767, "Entering a note and taking one back SHALL answer as entering a number and
taking one back do, behaviour for behaviour", still reads true: it points at this sentence, and
`RecordStore.removeNote` returns before writing on the same terms. It stays a pointer with no scenario.

### The unprovable rules and the *Known gaps* entry

Grill answers 8, 9 and 11, and 1717 above. The bullet `tasks.md` § 4 writes holds exactly those, in
the grill's groups — bind a meaning or a caller, compiler, no seam, time zone and locale, universal over
inputs, meaning with the same answer — with C3 recorded as unreachable at the seam. None moved to
testable: no seam reaches any of them.

### Carried requirements over budget before this Story

Grill answer 5. Seven carried requirements were already over 150 words and are carried as shipped:
*…moves the day it is showing…* (213), *…cannot read its record…* (205), *…draws the commitments its
roster had not stopped keeping…* (169), *…reads what an entry is committed with…* (288), *…makes and
takes back the tick…* (205), *…re-reads its day and its places…* (249), *…enters the number…* (257 since the reword below).

### A red test is fixed here, and only that

ADR-1047 decision 7.4. A new test failing on arrival is rule 3's red: the least code in
`src/DayByDayKit/Sources/` that makes that one scenario pass, named in the PR body. The Story stays a
covering Story.

## Risks / Trade-offs

- **A scenario that only visits its case** passes as cover. → Each table row names the wrong
  implementation it catches, and `reviewer` reads each test against that row at G7.
- **A fixture for a later-form document, a directory or an unwritable place built wrong** makes a test
  red for the wrong reason. → A red arrival is diagnosed against § *Context* before any `src/` edit.
- **The neighbour-change scenario is long**, and one step's no-op can hide another's. → Every step
  lands on a row whose change a correct screen would otherwise keep, and the end state is asserted whole.
- **A carried block drifting from the current spec** changes a rule silently. → `tasks.md` 2.1.

## Open Questions

None. `grill.md` § *Left open* is "None.", and writing the delta raised no residual round: every rule
re-verified to covered, testable or unprovable on facts read in source and the spec. The one question
`main` raised later, reword or not, is settled: reworded, as above.
