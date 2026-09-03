## Why

DayByDay records nothing. Five capabilities have shipped and closed — the four schedule shapes, the
commitment, the tick and its history, the store, and the day view that brings them together — and
the app on the phone still draws a list of names with no tap in it. `src/DayByDay/ContentView.swift`
builds a `DayView` from `History()`, a history that has taken no tick and never will, and throws it
away when the app is quit. Every Story so far stopped at the `DayByDayKit` seam; this is the one
that crosses it.

That is Epic #1's own outcome sentence, and it is what the third grooming pass found missing on
2026-09-03: B-022, *tick a commitment from the day I am looking at and have it still be there
tomorrow*, sat behind a `record` capability that had shipped both halves of the answer and a
`day-screen` capability that could form the question. Nothing owned the thing in between — the day a
person is actually looking at, the store it reads and writes, and the today it was handed.

`CONTEXT.md` § *Day screen* names that thing, and it is the first thing in this product that is not
a value. A day view is what it holds; a day screen *holds* one. It is also the first thing that can
fail: a store that will not open, a change that cannot be kept, a day that turns over while the app
is in someone's pocket. Every one of those could be got wrong in a way a test would catch, which is
exactly the line `CONTEXT.md` § *App shell* draws — so they belong behind the seam and not in a
SwiftUI body.

## What Changes

- **A day screen holds the day view a person is looking at, formed from the record kept at its
  place.** It is opened with commitments, the day it is being opened on, and a place; it reads the
  store there and hands back the day view unchanged. It never asks what day it is: the day arrives
  as an argument, exactly as it has for every question in the package since ADR-1004.
- **A tap makes or takes back a tick, and the tick is kept before the day view says so.** Which of
  the two a tap means is read off the row — `day-screen` settled that at #71 — and the screen adds
  nothing to `record`'s answer about what a tick is or where it is held. A change that cannot be
  kept is refused and reported, and the day view is left exactly as it was, so what a person reads
  is never ahead of what is on the disk.
- **The record is kept at a place the screen names, not one the shell picks.** Under
  `Application Support`, in a directory of the app's own, in one file. This closes
  `docs/open-questions.md` § *Known gaps*, "The store must be opened under
  `Library/Application Support/`", which #56 owed and which that entry assigns to the first Story
  that persists a tick from inside the app. `Caches/` is emptied by the system and `tmp/` is not
  backed up; `RecordStore` keeps the record at whatever place it is given and cannot refuse a bad
  one from where it sits, so something above it has to choose, and the shell may not.
- **A day screen that cannot read its record still draws the day, and keeps nothing.** It shows what
  the day asks of a person and takes no tick at all, rather than accepting one into memory that it
  cannot keep. Settled by the owner at the Feature grill on 2026-09-03 and recorded here as
  `docs/adr/1021-a-day-screen-without-its-record-draws-the-day.md`, because a future reader will
  otherwise ask why the app draws a record it does not have.
- **It says the reason for one refusal and no other: a record written by a later version of
  DayByDay.** Settled by the owner on 2026-09-03 on this change's question round. The refusals are
  answered identically — the day is drawn, no tick is taken, the file is left byte for byte as it
  was — but they are not alike to the person holding the phone. A record from a later version is
  whole and the app is what is behind, so the right response is to update the app and leave the file
  alone; a screen that says only "something is wrong with your record" invites the one action that
  loses it. No other reason carries an action of its own, so no other reason is told apart.
  `RecordStoreError.laterForm` already exists, so this needs nothing from `record`.
- **The day is re-read when the app is shown, and at no other moment.** A day screen is handed a
  today when the app comes in front of a person and holds it until the app is shown again, so the
  morning visit lands on the morning and a screen someone is reading cannot move onto a different
  day underneath them. Showing the app again also opens the store again, which is what lets a screen
  that opened before the device was first unlocked start keeping a record without being restarted.
- **`CONTEXT.md`** gains **record place** and **shown**, and § *Day screen* is sharpened with the
  four things this Story settles about it: where it keeps its record, that it keeps a change before
  its day view says so, what it is when it has no record at all, and which single reason for having
  none it names.

Nothing is drawn by this delta. `src/DayByDay` is rewired to hold a `DayScreen` and draw its rows
with a tap, but that is a SwiftUI body and a clock reading with no judgement left in it — the
judgement is all behind the seam, which is the point.

## Capabilities

### New Capabilities

None. `day-screen` already exists, anchored by `openspec/specs/day-screen/spec.md`.

### Modified Capabilities

- `day-screen`: five requirements ADDED — what a day screen holds, what a tick made on one does,
  where it keeps its record, what it is when it cannot read one, and what showing the app again
  does. The six requirements #70, #71 and #72 left are untouched and none is restated: a day view is
  still formed from three things, a row still offers one tick and refuses a day that has not
  arrived, a row is still a commitment's line on a date, a day view is still in the order it was
  handed and is still a value, and a move is still one calendar day bounded at both ends.

`record` and `schedule` are **not** modified. Everything this Story needs is public already —
`RecordStore.init(at:)`, `RecordStore.history`, `RecordStore.add(_:)`, `RecordStore.remove(_:)`,
`RecordStoreError` and its `laterForm` case, `History`, `DayView.init(of:on:in:)`,
`DayView.Row.isKept` and `DayView.Row.tick(asOf:)` — and this delta adds no requirement to either
capability and takes none away. Reading a date back out of a `CalendarDate` is `add-screen-date`'s (#92) and is a `schedule`
delta, which is why this Story does not touch one.

## Impact

- **`src/DayByDayKit`** — one source file added, `Sources/DayByDayKit/DayScreen.swift`; one test
  file added, `Tests/DayByDayKitTests/DayScreenTests.swift`. No existing source file is edited.
  Measured on this machine on 2026-09-03, on Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target
  `arm64-apple-macosx26.0`: `cd src/DayByDayKit && swift test` reports **164 tests passing** at
  `c05e500`; this change takes it to 192. `openspec` is 1.10.0 and `node --version` is v24.19.0.
- **`Package.swift` gains a platform floor**, `platforms: [.iOS(.v17), .macOS(.v14)]`. `DayScreen`
  is `@Observable` so that SwiftUI redraws when its day view changes without the shell holding a
  copy and re-reading it, and `Observation` is unavailable below those versions. Measured rather
  than assumed on 2026-09-03: the same probe package compiles with the floor and fails without it
  with `'Observable()' is only available in macOS 14.0 or newer`. The app's
  `IPHONEOS_DEPLOYMENT_TARGET` is 26.0 (ADR-1019), so nothing loses a platform it had; the kit
  previously declared none and compiled at its default iOS 12 floor. `design.md` § *Observation
  crosses the seam, and the platform floor comes with it* argues the alternative that avoids it.
- **`src/DayByDay`** — `ContentView.swift` is rewired: `dayOneCommitments` and `today()` stay
  exactly where ADR-1019 put them, and the body becomes a `DayScreen` in `@State`, a `List` of rows
  with a tap calling `tick(_:)`, a `switch` over the screen's three record states drawing what each
  one has to say, and a `.onChange(of: scenePhase)` that calls `shown(asOf: today())`. No requirement lives there and no
  scenario covers it — `docs/open-questions.md` § *No UI smoke layer* is unchanged and still open.
  This Story makes it matter more than it did, because the shell now writes to disk; the mitigation
  is that every judgement is inside the seam and the body has none.
- **`docs/open-questions.md` § *Known gaps*: "The store must be opened under `Library/Application
  Support/`" is closed by this change** and owes a line under *Settled* naming this Story. This
  change folder does not edit that file — `spec-author` may not write it (`AGENTS.md` § *Agent roles
  and model routing*) — so the move is a chore commit alongside the merge, exactly as `d1f99dc` was
  for #71 and #72.
- **`docs/open-questions.md` § *Known gaps*: "`RecordStore.init` can throw outside
  `RecordStoreError`" is met by this change and deliberately not closed.** It survived the question
  round: the one refusal the screen tells apart is `laterForm`, which is a declared case already, and
  everything the gap describes — a directory at the place, a file with no read permission, a store
  still protected before first unlock — lands in the same one case as content that is not a record,
  because a person can do nothing different about any of them. So the screen needs no fourth case to
  behave correctly, catching every error is the honest reading of "refused rather than emptied", and
  the gap stays owed to whichever Story first wants to tell those apart. A line saying so is one of
  the two documentation moves `tasks.md` names.
- **`docs/open-questions.md` § *Known gaps*: "The shell identifies rows by equality, and two rows
  may be equal" is unchanged and still cannot bite.** The day-one week holds no duplicate, and this
  Story adds no way to create one. It gets closer to biting, because a duplicate row would now also
  swallow a tap rather than merely misdraw, and the fix is still the shell's.
- **`docs/backlog.md`** — B-022, B-023 and B-024 are already *Decided* against `FEAT: day-screen`
  (#27) and its second decomposition. B-022 is this Story; B-023 is #92 and B-024 is #93. This
  change does not edit the file.
- **One ADR**, `docs/adr/1021-a-day-screen-without-its-record-draws-the-day.md`. 1021 is the next
  free number and `docs/adr/README.md` gains its row.
- **`openspec/specs/day-screen/spec.md`** is rewritten at archive time, by `/opsx:archive` and
  nothing else. Exactly one capability is claimed, so CI check 2 stays green.
- **No new dependency and no CI change.** The `swift` job discovers work with
  `find . -name Package.swift` and reads `@Test("...")` display names out of the source; a platform
  floor changes neither, and GitHub's `macos-26` runner is far above both bounds.
