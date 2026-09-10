## Why

The day-title row on the day screen holds four controls — chevron, title, day picker, chevron — and
since `add-day-picker` (#176) put the fourth one there the title no longer fits beside them:
"Today · Wednesday 9 September 2026" wraps onto a second line. That was recorded at #176's close and
handed to this Story by name rather than patched, because the shell-only fixes available there are
an ellipsis or shrunk text, and both make the row worse rather than shorter.

The Story grill declined the shell fix and settled something larger. The row already says the date
twice: the picker renders "9 Sep 2026" an inch from a title spelling the same day out in full. So
**the day title stops saying the date at all** and becomes the weekday alone — "Wed" — and the
picker beside it is what says which day that is.

## What Changes

- **A day title becomes the three-letter name of its weekday and nothing else.** No day of the
  month, no month, no year, and no *Today* in front of it. The names are "Mon", "Tue", "Wed", "Thu",
  "Fri", "Sat" and "Sun" — the ones `schedule` already says a rhythm's weekdays in, so the app
  carries one abbreviation rule rather than two.
- **The word *Today* leaves the title entirely**, retiring a preference #92's grill settled on
  2026-09-03. Nothing is lost: the *Today* button is drawn only where the screen offers the way back
  (`ContentView.swift:162` guards it on `offersGoingBackToToday`, hiding rather than disabling it),
  so the row already tells the two states apart without a word inside the date.
- **BREAKING: a day title is no longer asked *as of* a day.** It was read off the date and off the
  day the question was asked as of; the second of those decided one word — *Today* — and that word
  is gone, so nothing is left for the argument to decide. `DayView.title(asOf:)` becomes
  `DayView.title`. Keeping an argument no answer depends on would put a lie in the seam and would
  force a requirement stating that a parameter decides nothing.
- **Two requirements are replaced rather than amended**, because their names and six of their
  scenario names assert the form that is going away. *A day view says its day as a weekday and a
  date, and says Today on the day it is asked as of* and *A day screen says the day it is showing,
  as of the day it was handed* are REMOVED, and *A day view says its day as a weekday* and *A day
  screen says the day it is showing* are ADDED in their place.
- **Ten further requirements are modified, and none of them changes behaviour.** They quote a day
  title in a scenario — 64 quotes across the capability — purely as a witness of which day a screen
  is showing or of whether that day is the today. A weekday can witness neither: seven days of any
  week share it, and there is no longer a *Today* to mark. Each such clause is replaced by the
  answer that can still carry it — *A day screen says the reach of its day picker* for which day,
  *A day screen says whether it offers the way back to today* for whether it is the today — both
  shipped, both unchanged here. Six scenarios would otherwise have asserted nothing their names
  claim; § *What this costs* in `design.md` names them.
- **Five scenarios are re-homed.** They sit under the day-view title requirement being removed but
  are about a *day screen* keeping or moving its day when the app is shown again. They move to *A
  day screen re-reads its day and its record when the app is shown again*, which is the requirement
  that decides which day is then shown, keeping their names and so their tests.
- **The date is now said in the device's words, and that is accepted with its cost named.** The
  picker renders the date through the platform, so after this nothing the app owns can state which
  date is on screen, and no scenario, test or screenshot asserts it. A compact `DatePicker` cannot
  be made to say the weekday itself — `DatePickerComponents` offers only `date` and `hourAndMinute`
  on iOS, no initializer takes a format, and `DatePickerStyleConfiguration` exposes no text hook —
  which is why something in the kit still has to say it. ADR-1022 is amended in place for this.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `day-screen`: **two requirements removed and two added in their place** — what a day title says,
  and what a day screen says its day is. **Ten requirements modified**, none of them in what it
  requires: each restates scenarios whose day-title clause is replaced by the day the picker opens
  on or by whether the way back to today is offered, and one of the ten takes in five scenarios
  re-homed from a requirement being removed. **Nothing else in the capability moves** — § *What
  Changes* names the three shipped requirements this delta leans on and leaves standing.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/DayView.swift` — `title(asOf:)` becomes `title`, and its body
  becomes a lookup of one weekday name. The `date == today` comparison and the "Today · " prefix go.
- `src/DayByDayKit/Sources/DayByDayKit/DayTitle.swift` — `monthNames` loses its only caller and is
  deleted with it; `weekdayNames` becomes the three-letter names. **Not merged into
  `ScheduleWords.weekdayOrder`**: that table is ordered for joining a set into "Mon, Wed, Sat" and
  is `schedule`'s, and `design.md` § *Why the two tables stay apart* says why sharing it would
  couple two display rules that are only coincidentally alike today.
- `src/DayByDayKit/Sources/DayByDayKit/DayScreen.swift` — `title` drops the `asOf: today` argument
  it passes on. No stored state, no other signature.
- `src/DayByDayKit/Tests/DayByDayKitTests/DayViewTests.swift` and `DayScreenTests.swift` — 79
  literal day-title assertions between them. Seven scenarios are new and need new tests, nine are
  retired with the requirements that held them, and the rest keep their names while their
  assertions change.
- `src/DayByDay/DayByDay/ContentView.swift` — under ADR-1019's 2026-09-04 exception, the day-title
  row is rearranged so the picker sits between the chevrons and says the date, with the short title
  beside it. It reads `screen.title` exactly as it does today and formats nothing.
- `src/DayByDay/DayByDayUITests/WalkthroughUITests.swift` — **nothing.** It asserts the *Today*
  button and that some row was drawn, and never the day title.
- `docs/adr/1022-the-day-is-said-in-the-apps-own-words.md` — **amended in place**, per
  `docs/adr/README.md`. The decision that words are the app's own stands and now covers seven
  weekday names rather than nineteen names and a form; what changes is that the *date* is no longer
  the app's to say, and the ADR's own reasoning for why is folded in.
- `CONTEXT.md` — three entries are made wrong by this change and are amended with it: **Day title**,
  **Today** and **Day picker**. No new term is coined.
- **Not touched:** the `commitment`, `record` and `schedule` capabilities; `CalendarDate`,
  `Weekday`, `ScheduleWords`, `Roster`, `History`, `RecordStore` and every record already kept;
  `showPreviousDay()`, `showNextDay()`, `showToday()`, `showDay(_:)`, `dayPickerReach`,
  `offersGoingBackToToday`, `shown(asOf:)` and `returnedTo()`.
