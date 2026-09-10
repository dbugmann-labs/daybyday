## Context

`proposal.md` § *Why* says what this is for; `grill.md`'s four settled answers are what the delta is
written on, and `docs/research/2026-09-09-concise-specs/` holds the three surveys it is written from.

Measured on this branch:

- `openspec/specs/day-screen/spec.md` is 5,562 lines — 48 requirements and 399 scenarios — and every
  one of the 48 is over the 150-word prose budget.
- No scenario in the file carries prose: all 399 are `WHEN`/`THEN`/`AND` bullets, so the whole
  saving is in requirement prose.
- The surveys trace that prose to twenty-five ADRs already in the register, to eleven pieces of
  rationale with no home at all, and to change history that belongs nowhere.
- `survey-day-screen-A.md` covers requirements 1–20 here, `survey-day-screen-B.md` 21–41, and
  `survey-2026-09-10-day-screen.md` the fifteen blocks changed since — the third supersedes the
  other two wherever they overlap.
- Every scenario title in the file is an acceptance test that passes today, named identically.

## Goals / Non-Goals

**Goals:** every rule the surveys list under *Rules at risk* stated once, as a SHALL/MUST sentence,
in the one requirement it belongs to; every requirement inside the 40–150 word budget, or split
until it is; every piece of rationale with no ADR home homed before the sentence carrying it goes.

**Non-Goals:** no scenario added, renamed, merged or dropped and no scenario body touched; no
behaviour change, no test change, nothing under `src/`; no other capability — `commitment`,
`record` and `schedule` are surveyed and are their own Stories.

## Decisions

### The seam

**None, and that is what this Story is.** ADR-1047 decision 2: an editorial Story's delta is a
rewrite of prose, changes no behaviour and changes no test, so there is no new or changed member for
an acceptance test to attach to and rule 3's red-green loop is moot. `docs/process.md` § 9's DoR
asks for a seam **or** for `design.md` to state that no test changes and why, which is this
paragraph. Every scenario in the delta is already driven at a seam that ships — `DayScreen`,
`DayView` and `Roster` — by a test carrying its title verbatim, and every one of those tests goes on
passing untouched. Fidelity is judged instead against the surveys' *Rules at risk* lists, which is
what `tasks.md` gives a box per requirement and what `reviewer` reads at G7.

### Every rule survives as a sentence, and this Story adds no scenario

Grill answer 1. The nineteen rules the surveys find with no scenario are kept as bare SHALL/MUST
sentences rather than deleted or tested: deleting one changes behaviour by omission, and writing a
scenario for one adds a test, which an editorial Story may not do. The eight the surveys judge
testable today are listed under § *Open Questions* as knowingly untested and captured as one
backlog want.

### Rationale is homed before the prose carrying it is deleted

Grill answer 2. Rationale an ADR already records is simply deleted. Of the eleven pieces with no
home, four are dropped, the range hint's en dash stays in its requirement as a normative sentence,
and six are written down before the sentence carrying them goes. Four amendments are one paragraph
each: every row says its rhythm always → **ADR-1034**; the total entry's field is not prefilled →
**ADR-1041**; a comma and a full stop are read alike because of the iPhone decimal keypad →
**ADR-1032**; the way back to today is the screen's own answer because it gives out neither day →
**ADR-1045**. The day picker's floor, its clamp, its refusal below the floor and its always being
offered get **ADR-1048**, a new record written from the archived `add-day-picker` design and
`CONTEXT.md` § *Reach* — an archived change folder is not where a cold reader looks, and that
folder's own judgement that no ADR was owed rested on prose this Story deletes.

**A day view is a value, not a window → ADR-1026**, which the grill left to this file. It is the
nearest of the twenty-five because its decision turns on a day screen holding a day and forming its
day view again — "it needs no state of its own" — which is sound only because a day view is an
answer from a history as that history stood rather than a live view onto one. ADR-1043 is the
runner-up: paging the neighbouring days needs three day views held at once, and that is the same
property one step on. The four dropped outright are the three arguments against proposals nobody
made and the change history in the requirement on being returned to.

### Three requirements split, and REMOVED plus ADDED is the mechanism

Grill answer 3. *A row is a commitment's line on a date*, *A day screen says the reach of its day
picker* and *A day screen says the day view of the day before the one it is showing and of the day
after* each carry five or six separable rules and reach 170 words at best. Each becomes one
`## REMOVED Requirements` heading with a Reason and a Migration, and two `## ADDED Requirements`,
with every scenario title carried verbatim to the half it belongs to. **Verified on a scratch
OpenSpec root rather than assumed**, which ADR-1047 asks for by name: `openspec validate --strict`
and `openspec archive` both accept the shape, and the added requirements land at the end of the
spec file rather than in the removed one's place. ADR-1047's editorial-Story definition and
`CONTEXT.md`'s term are widened to say so, having read MODIFIED-only until now.

The two rules the surveys find struck three times over — *a row offers at most one of a tick, a
number entry, a note entry and a total entry* and the eight behaviours the three entry kinds share
— are stated once in the first requirement of each family and cross-referenced in one clause
elsewhere, because a per-requirement trim that strikes each as a restatement loses it entirely. The
twin the third survey found takes the same treatment: the pair about a move with nowhere to go, and
a caller not standing a move down on it, is stated in *A move with nowhere to go leaves a day screen
exactly as it was* and cross-referenced from the requirement on the ends of the calendar.

### Every scenario title stands, including the one that is false

Grill answer 4. Titles are contracts a CI check reads, so none changes here. That keeps *a day
screen returned to does not read its record again*, which `add-commitment-editing` (#148) made
wrong: its test asserts that a screen which could not read its record still says so after being
returned to, not that no read happens. The prose that admits this is rationale this delta deletes,
so the fact moves to ADR-1047's list of knowingly-false titles, which grows from two to three.

### Overruns the budget, and why each one is over

The rewrite takes this capability's requirement prose from 24,847 words to 8,390. Sixteen
requirements are still over 150, because the first rule — every *Rules at risk* sentence present as
its own SHALL/MUST — outranks the word cap where the two collide. **Treat one as a finding only
where a sentence in it is rationale rather than a rule**; this list is what puts Decisions over 80.

- *A day view is the commitments due on a date, each with whether it is kept* — 171; the formation rule plus survey A's three at-risk sentences.
- *A row offers the tick that keeps its commitment, and refuses one for a day that has not arrived* — 214; four at-risk sentences and the tick round-trip contract.
- *A day view is a value* — 192; holds the group-with-nothing-due rule the roster requirement defers back to.
- *A day view moves to the day before it and the day after it* — 177; three at-risk sentences, including the tick rule labelled "not restated here".
- *A day screen moves the day it is showing one calendar day either way* — 213; four at-risk sentences, one of them the day picker's counterweight.
- *A move with nowhere to go leaves a day screen exactly as it was* — 205; the twin pair stated once here, plus four independences.
- *A day screen holds the day view of the day it was handed, formed from the record kept at its place* — 227; the two-days rule four other requirements rest on.
- *A day screen makes and takes back the tick a row offers, and keeps it before the day view says so* — 205; three at-risk sentences and the refusal-reporting contract.
- *A day screen that cannot read its record draws the day and keeps nothing* — 205; three at-risk sentences, including both refusal reasons kept apart.
- *A day screen re-reads its day and its record when the app is shown again* — 249; four at-risk sentences, and the one to split first if a split is ever authorised.
- *A day screen tells on the row that was tapped that a change could not be kept* — 256; four causes quoted verbatim and three at-risk sentences.
- *What a day screen tells on a row lasts until the app is shown again, a change is kept, or the day it is showing changes* — 167; three ends and the four things that are not one.
- *A day screen enters the number a row's entry takes, and keeps it before the day view says so* — 257; states the family's eight shared behaviours in full.
- *A day screen reads what an entry is committed with as a number, as a take-back, or as neither* — 283; the whole number grammar the total's reading defers to.
- *A row is its commitment, its date and what that day holds* — 153; a split half three words over, carrying identity and per-kind contents.
- *A row gives back what a screen draws and what a tap makes* — 172; the other half, four give-backs and the rhythm rules.

## Risks / Trade-offs

- **A dropped rule is invisible to every check.** The tests all pass whatever the prose says, so
  nothing but a reader catches a rule that went out with its paragraph. → One `tasks.md` box per
  requirement, ticked against that requirement's *Rules at risk* list, and the same list is the
  reviewer's fidelity axis at G7.
- **Two requirements point their shared rule at each other** — a group with nothing due produces no
  group is stated in *A day view is a value* and deferred back to it from *A day screen draws the
  commitments its roster had not stopped keeping* — so two people trimming in parallel can each
  delete it as the other's. → Named in both boxes; the rule lives in the first.
- **Splitting moves three requirements to the end of the spec at archive time**, so the archived
  file's order is not this delta's. Nothing reads that order and no scenario title moves.

## Open Questions

**Eight entries stay knowingly untested**, each a rule with no scenario kept as a SHALL/MUST sentence; `tasks.md` and the surveys hold the detail.

- a non-total row's sum is zero rather than nothing
- a total entry's field is not prefilled
- two rows that are the same row are both told on
- closing an entry uncommitted is not a fourth end
- a take-back writes to the place on a day holding no number
- the day views either side stay unchanged in name, shape and every answer
- that answer holds whatever the roster, the record, the rows and the today are
- the day picker's four reach rules

**One want captures all eight**, for the conductor to file: *cover the eight day-screen rules the condensing surveys found testable but untested, with a scenario each, so that no rule in that spec rests on prose alone.* Nothing else is open: `grill.md` § *Left open* is "None." and no residual round came out of writing these artifacts.
