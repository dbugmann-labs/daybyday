## Why

Everything a person keeps is decided at compile time. `dayOneCommitments` in
`src/DayByDay/DayByDay/ContentView.swift` is a literal of nine commitments, and
`add-roster-store` (#103) made it a *seed* rather than the list — the roster is now read from
disk, taken on once and kept — but nothing in the product can add a ninth, and nothing can stop
keeping one. `Roster.add`, `Roster.retire`, `RosterStore.add` and `RosterStore.retire` all ship,
all pass, and have exactly one caller between them: day one, writing the same nine commitments
that were already there.

So the commitment the owner takes on next month has nowhere to go, and the one they gave up in
October is still asking to be ticked every morning. This is the fourth and last Story of
`FEAT: commitment` (#26), and it is the one that puts a person in front of what the other three
built.

## What Changes

- **Adds a commitments screen to the `commitment` capability**: two lists — what the roster is
  keeping and what it has stopped — a way to define a commitment from a name, a rhythm and the day
  it is kept from, a way to stop keeping one, and a way to take a stopped one up again. It is the
  second thing in the product that is not a value, and it lives behind the `DayByDayKit` seam
  beside `DayScreen` for the reason `CONTEXT.md` § *Day screen* already gives: an order, a
  refusal, a default and a place a change is kept are all things that can be wrong in a way a test
  would catch.
- **Offers all four rhythms** — a weekday set, a day of the month, every N days, a weekly quota —
  rather than a deep version of one. `CONTEXT.md` § *Five percent of seven things*, and day one
  already contains an every-N-days commitment the app would otherwise list and be unable to
  create. The four arrive as a new **`Rhythm`** value: a schedule shape with nothing in it the
  calendar does not supply, which is what makes the next point a type rather than a rule.
- **Makes the day a commitment is kept from the start date of an every-N-days rhythm.** One date
  on the form, not two. `CONTEXT.md` § *Start date* keeps them distinct in the model and says they
  can disagree; two date pickers on a phone form, differing in a way nobody intended, buys less
  than it costs. `Rhythm.everyNDays` carries an interval and no date, and the screen supplies the
  date it was given.
- **Refuses a weekday set with no days in it, which the rule engine accepts.** This is the first
  place in the product where a screen refuses a value the engine calls legal, and it is recorded
  as `docs/adr/1028-a-screen-may-refuse-what-the-engine-accepts.md`. `Schedule` is untouched and
  so is every rule in `openspec/specs/schedule/spec.md`: a commitment due on no day is one a
  person would never see again, which is a rule about what a screen should offer to make, not
  about what a schedule value may be.
- **Says out loud when a rhythm's number is one the calendar will not take** — a day of the month
  that is not one of the thirty-one, an interval of fewer than one day, a quota outside one to
  seven. This is the mirror of the point above rather than more of it: those three numbers are
  refused by the *value*, and ADR-1028 already records that "every screen simply reports what the
  value said". The form did not. A rhythm therefore carries the number a person gave rather than
  a number already judged, `CommitmentsScreen.Refusal` gains the case that reports it, and the
  shell stops both silently rewriting a `0` to a `1` and silently doing nothing when a number it
  cannot use is typed. Found at the second review pass of this Story.
- **Makes a calendar date give back the year, the month and the day it names**, as one requirement
  **ADDED** to `schedule`. ADR-1004 put calendar dates in the rule engine and instants at the
  edge, and an edge converts both ways; the way back was never specified and could not be
  performed, because the three components were readable only inside `DayByDayKit`. The commitments
  screen's date picker is the first thing that needs it — it speaks instants and has no other way
  to be told which day the screen is offering — and this is the Story that finally needed the
  three members `docs/open-questions.md` § *Known gaps* has recorded as owed since
  `add-day-navigation` (#72). Found at the second review pass, where the widening had already
  shipped without a requirement authorising it.
- **Tells a duplicate apart from a roster that could not be written**, in different words. This
  deliberately breaks the pattern ADR-1021 set for the day screen, where every refused tick is
  told the same way. That argument was that a refusal a person cannot act on differently should
  not be told apart; here they can — a commitment you already keep is your own doing and you can
  change the name or the rhythm, while a disk that will not write leaves you nothing to do.
- **Asks you to confirm before stopping.** A stop writes to the roster, and the owner wants to be
  asked. Taking a stopped commitment up again asks nothing: it is one tap, and it is the only way
  the roster's take-up-again rule can be reached from a phone at all.
- **Adds one requirement to `day-screen`: a day screen reads its roster again when it is returned
  to**, and modifies the one requirement whose prose said the roster it holds is the one read
  "when the app was last shown". Without this, a commitment defined on the new screen would not
  reach the day screen until the app had been backgrounded and brought back —
  `add-roster-store`'s own design predicted the bug would "land in #104 as a mystery", and this
  is where it is closed. **This is what makes the Story touch two capabilities.**
- **Wires the two screens together in the app shell, on this branch.** ADR-1019 makes the shell a
  chore with no G4 precisely so that a change carrying no requirement does not sit inside a signed
  change folder. This deviates from that knowingly, so that the Story is usable at G7 rather than
  after a second branch, and ADR-1019 is amended to record the exception and what returns it to
  the rule.
- **Not in this change:** editing a commitment already taken on — that is B-014, still a want,
  and G1 left it out because changing a name or a rhythm makes a *different* commitment, a
  commitment carrying no identifier; saying a rhythm in words on a row — B-021, a rule about how a
  **schedule** is said, which belongs to `openspec/specs/schedule/spec.md` and which G1 also put
  out of this Feature; searching, sorting or grouping either list; carrying either store to a new
  phone (B-009); and any change to what day one is or when it is written (ADR-1027 stands
  untouched).

## Capabilities

### New Capabilities

None. A commitments screen is where a person manages a **roster**, and `CONTEXT.md`
§ *Commitments screen* defines it in exactly those terms; putting it in a capability of its own
would separate the roster's rules from the only thing that exercises them. `day-screen` and
`schedule` already exist too, and `add-screen-date` (#92) and `add-roster-store` (#103) both set
the precedent that one change may claim more than one.

### Modified Capabilities

- `commitment`: ten requirements **ADDED**, with forty-five scenarios between them — the two
  lists, defining a commitment, the two refusals the form makes about its own contents, the
  refusal it reports on behalf of a rhythm's own value, telling a duplicate apart from a roster
  that could not be written, stopping with a confirmation first, taking one up again, the place it
  keeps its roster and being shown again, and a commitments screen that cannot read its roster at
  all. **No existing requirement moves.** Nothing here changes what a commitment is, what a roster
  does, or what a roster store keeps: the screen is a caller of all three and adds no rule to any
  of them.
- `day-screen`: one requirement **ADDED** — *A day screen reads its roster again when it is
  returned to* — with seven scenarios, and one **MODIFIED**: *A day screen draws the commitments
  its roster had not stopped keeping on the day it is showing*, whose third paragraph says the
  roster a day screen asks is "the one read at that place when the app was last shown". That
  sentence becomes false the moment there is a second moment at which the place is read, and it is
  the only sentence in the delta that moves. Its four scenarios are **restated verbatim** and no
  test written for one of them may be renamed or have an assertion changed.

- `schedule`: one requirement **ADDED** — *A calendar date gives back the year, the month and the
  day it names* — with four scenarios, and **no existing requirement moves**. This is a read-back
  and nothing else: which dates exist, which years are supported and when a schedule is due are
  every one of them unchanged, and the requirement's own prose says that a day of the month, an
  interval and a weekly quota still give their numbers back to nothing outside the module. The
  first implementation pass of this Story shipped that widening in `CalendarDate.swift` with no
  requirement behind it; the owner's decision at the second review is to keep it and authorise it
  here rather than reverse it.

`record` is untouched. Nothing here asks a new question about a tick, a history or due-ness, and in
particular the weekday set with no days in it goes on being a schedule the engine accepts — one
scenario in this delta exists to pin that, and the day of the month of 32 that another refuses is
refused by the value the `schedule` capability already defines, not by a new rule about schedules.

## Impact

- **`src/DayByDayKit`** — three new files: `Sources/DayByDayKit/CommitmentsScreen.swift`
  (public), `Sources/DayByDayKit/Rhythm.swift` (public) and `Sources/DayByDayKit/RosterState.swift`
  (public, holding the enum lifted out of `DayScreen`). Two existing files are edited:
  `DayScreen.swift` loses its nested `RosterState` and gains `returnedTo()`; `Roster.swift` is
  untouched — the commitments screen reads `entries` directly, which #103 already widened to
  module-internal. `DayScreen`'s `private var rosterStore` is **left exactly as it is, still
  unread**: `design.md` § *The store `DayScreen` holds is still not read* explains why this design
  does not reach it and why deleting it is the human's call rather than this Story's. A third
  existing file is edited, and it is the one the second review pass found had already been edited
  without authority: `CalendarDate.swift`'s `year`, `month` and `day` become `public let`s, which
  is the whole of the `schedule` requirement above and nothing more — no method moves, no
  initializer changes, and no other type's payload is widened. `Package.swift` is
  untouched: no `platforms:` line, no dependency.
- **`src/DayByDay`** — `ContentView.swift` gains navigation to a commitments screen and calls
  `returnedTo()` on the way back, and a new `CommitmentsView.swift` draws the two lists and the
  form. Both ride this branch under the ADR-1019 amendment below; `tasks.md` § 4.3 closes them by
  driving the built app, the only way this repo has while `docs/open-questions.md` § *No UI smoke
  layer* stands. Neither file may decide anything, and the second review pass found two lines in
  `CommitmentsView.swift` that did — a `max(1, …)` rewriting a typed day count and three `guard`s
  turning a number the kit refuses into silence. Both go, and the requirement that replaces them
  is the rhythm-number refusal above.
- **Tests** — fifty-six new acceptance tests, one per new scenario: forty-five in a new
  `Tests/DayByDayKitTests/CommitmentsScreenTests.swift`, seven at the end of the existing
  `DayScreenTests.swift`, and four at the end of the existing `ScheduleTests.swift`, which is
  where every `CalendarDate` scenario in this repo already lives. Measured on this machine on
  2026-09-04, on Apple Swift 6.3.3, from `566297e` — the `main` this branch is rebased onto:
  `cd src/DayByDayKit && swift test` reported **300 tests passing**. Measured again on 2026-09-06,
  on the branch as the second review pass left it, it reports **348** — the 300, plus the 47 the
  first pass wrote, plus one unit test the pass added for a guard no scenario reached. The nine
  scenarios added here take it to **357**. `openspec` is 1.10.0 and `node --version` is v24.19.0.
- **`openspec/specs/`** — `commitment/spec.md`, `day-screen/spec.md` and `schedule/spec.md` are
  rewritten at archive time by `/opsx:archive` and nothing else. Three capabilities are claimed
  and all three are edited, so CI check 2 stays green.
- **ADRs** — one new, `docs/adr/1028-a-screen-may-refuse-what-the-engine-accepts.md`, and one
  amended in place under ADR-1020, `docs/adr/1019-the-app-shell-runs-in-the-simulator.md`. 1028 is
  the lowest number no file and no branch has used: `git log --all --name-only -- docs/adr` on
  2026-09-04 tops out at 1027. `docs/adr/README.md` gains one row.
- **`CONTEXT.md`** — the grill already landed **Commitments screen** in the working tree. This
  change adds one more term the delta turned up, **Rhythm**, and stamps a 2026-09-04 amendment on
  **Day screen**, which until now named being shown as the only moment its roster is read.
  **Rhythm** then takes a 2026-09-06 amendment of its own: it carries the number a person gave
  rather than a number already judged, which is what lets the screen report the refusal.
- **`docs/open-questions.md`** — one entry is edited here rather than named, on the owner's
  instruction with their decision to authorise the `CalendarDate` widening: § *Known gaps*'s
  read-back entry has assigned `CalendarDate`'s `year`, `month` and `day` to "a Story of its own
  against a second capability" since #72, and that sentence becomes false the moment this delta
  lands. It is corrected to say which face of the gap this Story closes and which four remain —
  `Comparable`, and the `DayOfMonth`, `DayInterval`, `WeeklyQuota`, `History` and `Tick`
  read-backs. It rides its own commit on this branch so it can be dropped on its own. The file's
  two *other* owed entries stay owed and `tasks.md` § 5.5 still names them for a chore commit
  alongside the merge, exactly as #92, #93 and #103 handled theirs.
- **`docs/backlog.md`** — untouched, and it needs no edit. The three wants this Story serves —
  B-013 *stop keeping a commitment*, B-015 *define a commitment from the phone* and B-020 *see
  every commitment I keep in one place* — all left *Wants* at the 2026-09-03 grooming pass that
  reopened `FEAT: commitment` (#26), and their lines are already in § *Decided*. B-014 and B-021
  are still wants and stay exactly where they are; a want leaves only through `/atlas backlog`,
  never through a change folder.
- **No new dependency, no platform floor change and no CI change.**
