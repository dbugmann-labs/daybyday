## Why

Reaching a day weeks back on the day screen costs one tap per day between. The chevrons move one
calendar day and the *Today* button jumps to one particular day; there is nothing that goes to an
arbitrary day, and **B-040** — *"get to a day weeks back without stepping through every day
between"* — is the want. The sixth grooming pass took it to `FEAT: day-screen` (#27) as a Story of
its own, and named it **the only one in that cluster needing new kit surface**: the *Today* button
and the row-tap rule shipped as `add-offered-today-control` (#174) off answers the screen already
held, and the swipe shipped as a chore because `showPreviousDay()` and `showNextDay()` were already
public. Nothing on the seam today can say what a person may pick, and nothing accepts a picked day.

The Story grill settled the shape in ten answers, and the two it turned on are **what bounds the
control** and **who says so**. The picker is floored at the earliest day anything on the roster has
been kept from — the day before it there is nothing anyone kept, so a picker that offered it would
be offering a year of empty days. That floor **bounds the control and never the screen**: the
chevrons, the swipe and the *Today* button go on reaching as far as the calendar does, because
`add-screen-navigation` (#93) refused a bound on navigation in as many words and this Story does not
reopen it.

## What Changes

- **A roster answers the earliest day anything it holds has been kept from**, counting every
  commitment it holds — the ones it has stopped keeping and the ones it has removed included. Their
  days still hold records that were kept, and a floor that rose when a commitment was retired would
  put a day a person actually kept out of reach. A roster holding nothing answers that there is
  none. **This is where the answer has to live**: a commitment reads back its name and its kind and
  deliberately not the day it is kept from (`commitment`'s own first requirement), so a day screen
  computing the floor itself would have to reach for a part this domain does not give out.
- **A day screen says the reach of its day picker**, as one answer carrying two days: the day the
  picker opens on, which is the day being shown, and the earliest day it reaches. The earliest is
  the earlier of the roster's answer and the day being shown — so a person who stepped below the
  floor with the chevrons can always get back to where they were — and where the roster answers
  none, the today the screen was handed stands in its place.
- **The picker is always drawn, and the reach names no far end.** Forward it reaches to the last
  supported date, so there is always another day to pick. A *whether it is offered* answer would be
  yes on every day anyone will ever look at, which is the ground #93 refused `canShowPreviousDay` on
  and #174 restated.
- **A day screen shows a day picked on its day picker**, forming its day view for that day from the
  roster and the record it already holds, exactly as a move does — and **leaves the screen exactly
  as it was** where the day picked is earlier than the reach. Not clamped to the earliest day:
  clamping shows a day nobody asked for, and silence is the answer the calendar's two ends already
  give.
- **The today does not move on a pick**, and every question a day screen asks as of a today is
  still asked as of it. A pick that changes the day ends what is being told on a row; a pick that
  does not — the day already being shown, or one the reach refuses — ends nothing.
- **Three shipped requirements are read against this delta and none of them moves.** *A day screen
  moves the day it is showing one calendar day either way* already says a screen adds no bound of
  its own and must not stop at the earliest day a commitment its roster answers with is kept from;
  that sentence is what settled 1 preserves rather than amends. *What a day screen tells on a row
  lasts until the app is shown again, a change is kept, or the day it is showing changes* already
  keys on the day **changing** rather than on the act made, so a pick needs no case added to it. *A
  day screen says whether it offers the way back to today* is unchanged and stays the only answer
  about that button. **There is no MODIFIED requirement in this delta.**
- **The shell rides this branch**, in its own `tasks.md` section, under ADR-1019's 2026-09-04
  exception: a reach nobody can see and a pick nobody can make would leave B-040 unserved.
  `ContentView.swift` draws a `DatePicker` beside the *Today* button, bounded by the reach it reads
  off the screen and selecting through the screen. It computes neither the bound nor the day.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: **one requirement added** — a roster answers the earliest day anything it holds has
  been kept from, the stopped and the removed included. Nothing existing moves; `Roster`'s order,
  its groups, its stop, its removal and its `commitments(on:)` answer are all untouched.
- `day-screen`: **two requirements added** — a day screen says the reach of its day picker, and a
  day screen shows a day picked on it. Nothing existing moves, and § *What Changes* names the three
  shipped requirements that were read against this delta and stand.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/Roster.swift` — one member, `earliestKeptFrom`, over the
  entries it already holds. No stored state, no new type, no signature changed.
- `src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift` — one nested value type, `DayScreen.Reach`;
  one computed property, `dayPickerReach`, over the roster and the day being shown; and one method,
  `showDay(_:)`, alongside `showPreviousDay()`, `showNextDay()` and `showToday()`. No stored state
  and no existing signature changed.
- `src/DayByDay/DayByDay/ContentView.swift` — a `DatePicker` in the day-title row, its range and
  its selection both read off `DayScreen.Reach` and its selection written through `showDay(_:)`,
  under ADR-1019's exception. The `Date` ↔ `CalendarDate` conversion at that edge is the one
  `CommitmentsView.date(from:)` and `ContentView.today()` already do, per ADR-1004.
- `src/DayByDay/DayByDayUITests/WalkthroughUITests.swift` — **nothing.** The smoke layer proves the
  shell drew and says nothing about what; it already asserts the day title and the *Today* button,
  and a `DatePicker` adds no assertion ADR-1029 wants there.
- `docs/adr/` — **nothing.** The bound, its reason and the line between the control and the screen
  are all in `CONTEXT.md` § *Reach*, landed at this Story's grill. An ADR would restate a durable
  record in a second place that can drift.
- `CONTEXT.md` — **nothing further.** **Day picker** and **reach** were both landed by the grill;
  writing the delta coined nothing.
- **Not touched:** the `record` and `schedule` capabilities; `Commitment`, `History`, `RecordStore`,
  `RosterStore`, `RosterDocument`, `CommitmentsScreen` and every record already kept;
  `showPreviousDay()`, `showNextDay()`, `showToday()`, `shown(asOf:)` and `returnedTo()`, all of
  which go on doing exactly what they do today.
