## Why

The commitments screen is the last thing in the product that does not know about **kinds**. A
commitment has carried one since `add-commitment-kind` (#137); the record, the store and every
kind's row shipped with #138–#141; and the form a person actually defines a commitment on still
offers a name, a rhythm, a day and a category, so every commitment anyone can create is a tick.
`docs/open-questions.md` records the consequence in one line: a **total** commitment is a state
nothing in the shipped app can reach. This Story spends the last of that.

Two of the things a kind carries — a **range** and a **target** — are the first numbers a person
types on this screen that the app shell does not form for them, so this Story also has to say what
"that is not a number" means here and who says it.

## What Changes

- **A commitments screen defines a commitment from five things**, not four: the fifth is the kind its
  days take. All four kinds are offered, and the **tick** is what a new commitment starts on — the
  same default the value has and the same kind every commitment written before kinds existed reads
  back as.
- **A range and a target arrive as the person typed them, and the screen judges them.** That is a
  deliberate departure from the rhythm numbers, which the app shell forms before the screen sees them,
  and a deliberate match to the **number entry** a day screen's row offers. **ADR-1046** records it.
  One reading of a typed number serves both surfaces: no locale, an optional minus, at most one
  separator which may be a full stop or a comma, and at most thirty-eight significant digits.
- **Two new refusals and no new kind of refused change.** *A range that is not a range* covers a
  lowest above its highest, an end that is not a number, and one end typed with the other blank; *a
  target that is not a target* covers one that is not a number, one not above zero, and a total with
  its target field empty. Three ways to fail are one refusal in each case, for ADR-1021's reason —
  what a person does about any of them is the same thing. The kinds of change a person can ask for
  stay as they are and are still counted in one place.
- **Both range fields blank is no range; one filled and one blank is refused.** Clearing a range is
  not a delete-every-character operation, and a typed floor is not "no range at all".
- **A range or a target left in a field the chosen kind has no room for is ignored, not refused.**
  Someone who typed a range and then chose Note is not asking for a range.
- **A change still takes four things, and the kind carries forward.** The kind is not editable, so a
  fifth argument there would create a refusal for a state the form cannot produce. What changes is a
  sentence: "the same four things it defines one from" is no longer true and now names them.
- **The change sheet is told what kind a commitment is.** *A commitments screen says what a
  commitment it is asked to change is made of* said the kind "is not said here"; it now says it, with
  the range or target that kind carries, so a sheet opened on "Mood" shows Number, 1 to 10 rather
  than having quietly shed two fields. Showing it is not asking for it, and letting a thumb into it
  is the drawing's business, which is to say: it does not.
- **The debt from #137's second review is paid here** (`docs/open-questions.md`), against the owner's
  decision at the grill's second round and against the recommendation, since this Story does touch
  `commitment`'s roster and store requirements. Two scenarios: the roster store's refusal of a
  half-written range, which has been implemented and tested since #137 with no scenario of its own,
  and a roster scenario for two commitments alike but for what their kind *carries*, which the
  existing one cannot catch because it offers the same range twice.
- **The app shell rides this Story and carries no requirement.** A kind picker, two range fields and
  a target field on the sheet, shown-not-editable when the sheet is changing rather than defining, and
  two more refusal lines. It is walked on the phone before the review.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`, six requirements — one **ADDED** and five **MODIFIED**:
  - **ADDED** *A commitments screen refuses a range that is not a range, and a target that is not a
    target* — the two new refusals, what falls under each, and why they are two rather than six or
    one. **11 scenarios.**
  - **MODIFIED** *A commitments screen defines a commitment from a name, a rhythm and the day it is
    kept from* — five things rather than four; the four kinds offered and the tick offered for a new
    commitment; a range and a target taken as typed and read by the number entry's reading; both ends
    blank meaning no range; a leftover range or target ignored; and the kind being one of the things
    that decide which commitment was named. **7 new scenarios**, 11 restated unchanged.
  - **MODIFIED** *A commitments screen says what a commitment it is asked to change is made of* — the
    kind is said, with its range or target, where it used to be explicitly not said. **2 new
    scenarios**, 4 restated unchanged.
  - **MODIFIED** *A commitments screen changes a commitment on either of its lists* — "the same four
    things it defines one from" is rewritten to name them, and the kind's payload is said to travel
    with it. No new scenarios; 21 restated unchanged.
  - **MODIFIED** *A roster refuses a commitment it already holds* — equality is over the whole of a
    kind and not merely which of the four it is. **1 new scenario** (the #137 debt), 16 restated
    unchanged.
  - **MODIFIED** *A roster store that cannot be read is refused rather than emptied* — a commitment
    carrying half a range is named among the things that could not be a roster. **1 new scenario**
    (the #137 debt), 4 restated unchanged.

**The requirement header of the define requirement is left exactly as it is**, naming three of the
five things. Changing it would make `openspec` read the delta as a new requirement beside the old
one rather than as a replacement; it already understated before this Story, and the first line of the
requirement is what says how many there are.

## Impact

- **Seam** — `CommitmentsScreen` (`src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift`),
  which already exists. `define` gains a kind and three typed texts, all defaulted so that the 63
  call sites that name no kind go on meaning a tick; `Change` gains the kind; `kindToOffer` is new;
  `Refusal` gains two cases. Nothing else on the seam moves. `design.md` § *The seam*.
- **One reading of a typed number, in one place.** `DayScreen`'s private `read(_:)`/`writtenOut(_:)`
  move to a package-internal type both screens call, beside `Blank` and `Digits`. No behaviour of a
  number entry changes and no `day-screen` requirement is touched — this is the same move `Blank`
  made at #140 and `Digits` at #141. `design.md` § *One reading of a typed number*.
- **Kit below the seam is untouched.** `Commitment.Kind`, `Range`, `Target`, `Roster`, `RosterStore`
  and `CommitmentCoding` already do everything this delta needs; the two debt scenarios assert
  behaviour that is already there and are expected to go green without a production change.
- **Tests** — the suite stands at **1036** on this branch, measured. **22 acceptance tests are
  added**, one per new scenario, and none is deleted or renamed. The delta declares **78** scenarios,
  of which 56 are restated unchanged and already have passing, name-matched tests that must not be
  touched.
- **App shell** — `src/DayByDay/DayByDay/CommitmentsView.swift`: the sheet's kind picker and three
  fields, the two new refusal lines, and the kind shown without a thumb in it when changing.
- **Docs** — `CONTEXT.md` § *Commitments screen* and § *Kind* are amended; `docs/adr/1046-*.md` is
  new; `docs/open-questions.md`'s #137 entry closes. `docs/backlog.md` is on `chore/backlog` and is
  deliberately not touched here — changing a range or a target is a want (`grill.md` § *Settled* 10)
  and is already captured as **B-043** on `chore/backlog` ("change a number's range or a total's
  target without starting the commitment over", 2026-09-10).
