## Why

The app now draws a day and keeps what you tick on it, and it will not say which day that is.
`src/DayByDay/ContentView.swift` hands `DayScreen` the device's date, draws the rows that come back
and prints no date anywhere; `DayScreen` holds the day it was handed and offers no way to ask what
it is. On the day this Story was written that is survivable, because the screen is always on today
and a person knows what day it is. It stops being survivable at the very next Story: #93 lets a
person move off today, and a screen that has moved and will not say where it has moved to is
unreadable.

That is B-023, *see which day the screen is showing*, captured by the third grooming sweep on
2026-09-03 and taken to `FEAT: day-screen` (#27) at its second decomposition. `docs/open-questions.md`
§ *Known gaps* had already pointed at it from the other side, as the fifth face of the payload
read-back gap: **the shell can move between days and cannot name one**, because a `CalendarDate`
keeps its year, month and day to itself.

Saying a day back in words is not a job any capability does today, and it is not a job the shell may
take. `CONTEXT.md` § *App shell* draws the line at whether a thing could be wrong in a way a test
would catch, and names a formatting rule as one of the four things that fail that test. A screen
that says "Thursday 3 September 2026" on one phone and "jeudi 3 septembre 2026" on the next has a
rule in it, and the rule belongs behind the seam with the rest of them.

## What Changes

- **A day view says its day in words, asked as of a day.** The weekday, the day of the month, the
  month and the year — "Monday 31 August 2026" — with "Today · " said in front of it on the one day
  the question is asked as of, and on no other. It is read off the day view's date and the day it is
  asked as of, and off nothing else: a day view holding no rows says its day exactly as one holding
  seven does. `CONTEXT.md` gains that as **day title**. Two halves of the form were the owner's to
  choose and were **settled by them on 2026-09-03, on this change's question round**: "Today" goes
  in front of the date rather than in place of it, separated by a middle dot, and the year is always
  said. `design.md` § *Open Questions* records both, and what each would have moved had it gone the
  other way.
- **A day screen says the day it is showing**, which is its day view's day title asked as of the day
  the screen was handed. The screen contributes exactly one thing to the answer — the day the
  question is asked as of — because that is the one thing it holds that the day view does not. It
  says its day whether or not it is keeping a record, which is ADR-1021 applied to a second
  question: what a date asks of a person needs no record to answer.
- **The words are the app's own, fixed, and not the device's.** Measured on this machine on
  2026-09-03 rather than recalled: `DateFormatter` with `dateStyle = .full` gives "Thursday,
  September 3, 2026" under `en_US`, "Donnerstag, 3. September 2026" under `de_CH`, "jeudi,
  3 septembre 2026" under `fr_CH`, and "2026年9月3日 木曜日" under `ja_JP` — five answers to one
  question, chosen by the phone. A day title that moves with the phone is a rule no scenario can
  state, so this one does not move. Recorded as
  `docs/adr/1022-the-day-is-said-in-the-apps-own-words.md`, because the next reader will otherwise
  ask why twelve month names are written out where Foundation would have supplied them.

## Capabilities

### New Capabilities

None. `day-screen` already exists, anchored by `openspec/specs/day-screen/spec.md`.

### Modified Capabilities

- `day-screen`: two requirements ADDED — what a day view says its day is, and what a day screen says
  the day it is showing is. The eleven requirements #70, #71, #72 and #91 left are untouched and
  none is restated.

**`schedule` is deliberately not modified, and that is a change of plan worth naming.** `docs/backlog.md`
records at B-023's promotion that this Story "carries a delta against `openspec/specs/schedule/spec.md`
as well, to read a `CalendarDate` back", and `docs/open-questions.md` says the same. Grilling it
says otherwise, and the reason is ADR-1004: a calendar date in this system is "a struct of three
integers with a validating initializer, not a date library: no formatting, no parsing", and that ADR
names convenience API growing on it as *the signal that something belonging at the edge has leaked
into the engine*. The prediction assumed the shell would assemble the words out of a year, a month
and a day; the shell may not, because assembling them is the formatting rule. Once the words are
formed behind the seam, nothing needs a `CalendarDate`'s parts in public, and widening `schedule` to
expose parts no requirement asks for would be adding surface for its own sake. The gap stays open
and stays owed by whatever first genuinely needs a date's parts outside the package — rendering a
rule in a row is still the likeliest — and `design.md` § *Why this is one capability and not two*
carries the argument in full.

`record` is untouched for the older reason: nothing here reads or writes a tick.

## Impact

- **`src/DayByDayKit`** — two existing source files are edited and one is added: `DayView.swift`
  gains `title(asOf:)`, `DayScreen.swift` gains `title`, and the twelve month names and seven
  weekday names land in a new internal `DayTitle.swift` rather than on `Weekday`, so `schedule`'s
  types stay rule-only. Sixteen tests are added, ten to `Tests/DayByDayKitTests/DayViewTests.swift`
  and six to `DayScreenTests.swift`. Measured on this machine on 2026-09-03, on Apple Swift 6.3.3
  (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`: `cd src/DayByDayKit && swift test` reports
  **192 tests passing** at `125da39`; this change takes it to 208. `openspec` is 1.10.0 and
  `node --version` is v24.19.0.
- **`src/DayByDay`** — `ContentView.swift` draws `screen.title` above the rows. One `Text`, no
  branch, no arithmetic and no wording of its own: every judgement is inside the seam, which is what
  `CONTEXT.md` § *App shell* asks for. No scenario covers it — `docs/open-questions.md` § *No UI
  smoke layer* is unchanged and still open — so `tasks.md` closes that hole the only way this repo
  has, by running it in the simulator and writing down what was seen.
- **`CONTEXT.md`** gains one term, **day title**. Nothing already there is amended: § *Day view*
  still says what a day view holds, and a day title is read off that rather than added to it, so
  two day views a reader could not tell apart still say the same day.
- **One ADR**, `docs/adr/1022-the-day-is-said-in-the-apps-own-words.md`. 1022 is the lowest number
  no file and no open branch has used — checked against `origin/main` and against
  `origin/story/101-add-commitment-roster`, the only other open story branch, on 2026-09-03 — and
  `docs/adr/README.md` gains its row.
- **`docs/open-questions.md` § *Known gaps*: the payload read-back gap is met by this change and
  deliberately not closed.** Its fifth face is this Story by name, and the answer turned out to be
  that the shell never needs the parts. A line saying so is owed, and `spec-author` may not write
  that file (`AGENTS.md` § *Agent roles and model routing*), so `tasks.md` names it as a chore
  commit alongside the merge, exactly as `d1f99dc` was for #71 and #72.
- **`docs/backlog.md`** — B-023 is already *Decided* against `FEAT: day-screen` (#27). This change
  does not edit the file.
- **`openspec/specs/day-screen/spec.md`** is rewritten at archive time, by `/opsx:archive` and
  nothing else. Exactly one capability is claimed, so CI check 2 stays green.
- **No new dependency, no platform floor change and no CI change.** Nothing here is `@Observable`
  that was not already, and the `swift` job discovers work with `find . -name Package.swift` and
  reads `@Test("...")` display names out of the source.
