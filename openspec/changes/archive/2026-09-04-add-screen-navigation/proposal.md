## Why

The app draws a day, says which day it is and keeps what you tick on it, and there is exactly one
day you can ever reach: the one the phone's clock handed it when the app came to the front.
`src/DayByDay/ContentView.swift` calls `DayScreen(of:asOf: today())` and never calls anything that
moves it; `DayScreen` holds one `private var today: CalendarDate`, replaced by `shown(asOf:)` and by
nothing else. So the one thing a person actually needs an app like this for — filling in the evening
you forgot, on the morning after — cannot be done at all.

That is the want recorded on 2026-09-03 as *move between days on the phone*, taken to
`FEAT: day-screen` (#27) at its second decomposition and now Story #93. `DayByDayKit` has answered
the underlying question since #72: `DayView.previousDay(of:in:)` and `nextDay(of:in:)` step one
calendar day either way, refuse at 1 January 1583 and 31 December 9999, and are covered by fourteen
scenarios. Nothing calls them. What is missing is not the arithmetic; it is a screen that can be on
a day other than the one it was handed.

**Which is why this change is mostly about one word.** A day screen today holds a single day and
calls it *today*, and that word is doing two jobs at once: it is the day being displayed, and it is
the day every question the screen asks is asked *as of* — which tick a row offers, and whether the
day title says "Today". They coincided only while a screen could be on no day but today. Move the
screen by writing that one field and both jobs move together, so two taps forward and a tap on a row
would write a tick for a day that has not arrived — the exact confusion `CONTEXT.md` § *Today* names
as "what would let a screen offer a tick for a day that has not happened". So the field splits in
two, and four requirements that were written when there was only one have to say which they meant.

## What Changes

- **A day screen holds two days, not one.** The **today** it was handed when the app was shown, and
  the **day it is showing**, which starts as that same today and is what navigation moves. Every
  question asked *as of* a day is asked as of the today; the day view is formed on the day being
  shown. `CONTEXT.md` was amended at the grill — four existing terms rather than a fifth added,
  because both days already had names.
- **A day screen steps one calendar day back and one forward**, as far as the calendar goes and with
  no bound of its own. Not stopped at today: a day that has not arrived already refuses its ticks
  row by row, and a second bound would restate a refusal the record is already protected by. Not
  stopped in the past either: the settled record question — *the past is writable back to the day a
  commitment is kept from, and no further* — left "whether a screen offers all of it" to this
  capability, and this is the answer. A day before anything was kept from has no rows, which is an
  answer rather than a gap.
- **A day screen goes straight back to today in one step**, and to today only. Settled at the grill
  against the recommendation, in the same breath as the one below: once the past is unbounded,
  stepping home costs a tap a day. Today only, because reaching an arbitrary date needs a screen to
  pick one with and that screen does not exist.
- **Being shown again keeps the day being shown — except on today, where it follows.** A screen
  showing the day it was last handed as today moves onto the new day; a screen showing any other day
  keeps it. Settled at the grill against the recommendation: being shown includes every app-switch,
  and losing the evening you are filling in to a glance at another app is what decided it. The
  exception is what the existing shown-again requirement exists for — put the phone down on Monday
  night, pick it up on Tuesday morning, land on Tuesday — and it needs no extra state, being a
  comparison of the two days the screen now holds. Recorded as
  `docs/adr/1026-a-day-screen-keeps-the-day-you-moved-to.md`, because one rule producing two
  opposite behaviours is surprising on a first reading.
- **A move with nowhere to go leaves the screen exactly as it was**, and the screen says nothing
  about whether it can move either way. A day view *gives nothing* at the ends of the calendar
  precisely so a caller holding a value can tell; a screen is stateful, so staying put is an answer
  where for a value it was not. The ends are 1 January 1583 and 31 December 9999, so an answer about
  whether either arrow is live would be permanently the same.
- **A move does not read the record again.** It forms the day view from the record the screen
  already holds, exactly as making a tick does. Being shown is still the only moment the record is
  read again, and it stays unconditional — a screen sitting on last Tuesday reads the record afresh
  when the app comes back, whether or not it moves.
- **The controls are the shell's and carry no requirement.** Two arrows and a way home in
  `ContentView.swift`, drawn under ADR-1019 and covered by `tasks.md` § 3 rather than by a scenario,
  exactly as `add-screen-date` (#92) handled its own title.

## Capabilities

### New Capabilities

None. `day-screen` already exists, anchored by `openspec/specs/day-screen/spec.md`.

### Modified Capabilities

- `day-screen`: three requirements **ADDED** — a day screen moving one day either way, going
  straight back to today, and being left as it is by a move with nowhere to go — and four
  **MODIFIED**, every one of them because it was written when a day screen held one day:
  - *A day screen holds the day view of the day it was handed…* — it now holds two days, and the day
    it is showing is held until it is moved **or** the app is shown again, rather than being moved
    "by nothing else".
  - *A day screen makes and takes back the tick a row offers…* — the tick is asked as of the
    **today**, not "the day the screen holds", and the day view is formed again on the day being
    shown. This is the sentence that would write a tick for a day that has not arrived if it were
    read the other way, and it is the reason the split is not cosmetic.
  - *A day screen re-reads its day and its record when the app is shown again* — it is no longer
    true that this "SHALL be the only moment a day screen changes day", and being shown now moves
    the day being displayed only when the screen is on today.
  - *A day screen says the day it is showing, as of the day it was handed* — the title is asked as
    of the today, so a screen moved off today says a bare date and one back on today says "Today ·"
    again; and it no longer says the same day "until the app is shown again".

Every requirement restated under MODIFIED keeps its scenarios verbatim, and **no test written for
one of them may be rewritten**: those twenty-four scenarios are the evidence that this change moves
what a day screen holds and not what it already did.

The eight requirements #70, #71, #72 and #92 left about a **day view** are untouched and none is
restated. In particular *A day view moves to the day before it and the day after it*, *A move is one
calendar day, and never more* and *There is no day before the first supported date and none after
the last* are exactly the arithmetic this change needs and they already say it; a screen's move is
defined as what moving the day view it holds gives, so leap days, month ends and the two ends of the
calendar are inherited rather than restated.

`record`, `commitment` and `schedule` are untouched: nothing here reads or writes a tick that #71
did not already, nothing asks a new question about due-ness, and nothing needs a `CalendarDate`'s
parts — the same finding #92 recorded, for the same reason.

## Impact

- **`src/DayByDayKit`** — one source file is edited, `Sources/DayByDayKit/DayScreen.swift`. It gains
  one stored property and three methods; `DayView.swift` is not touched, because `previousDay` and
  `nextDay` already do the work. Measured on this machine on 2026-09-04, on Apple Swift 6.3.3
  (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`: `cd src/DayByDayKit && swift test` reports
  **238 tests passing** at `d22633a`; this change takes it to 263. `openspec` is 1.10.0 and
  `node --version` is v24.19.0.
- **`src/DayByDay`** — `ContentView.swift` draws three controls that call the three new methods and
  nothing else. No branch of its own, no date arithmetic, no wording: whether a control is drawn does
  not depend on whether a move would do anything, because the screen says nothing about that and
  designing a disabled state would be inventing a requirement. `docs/open-questions.md` § *No UI
  smoke layer* is unchanged and still open, so `tasks.md` § 3 closes the hole the only way this repo
  has — the simulator, and a written record of what was seen.
- **`CONTEXT.md`** — **already amended, by the grill, in `d22633a`.** Four terms — *Today*, *Day
  screen*, *Shown* and *Day navigation* — carry a **2026-09-04** amendment each. No new term: the two
  days a day screen now holds already had names, and adding a fifth entry for "the day it is
  showing" would be a second name for *the date a day view is of*. This change adds nothing further
  to that file.
- **One ADR**, `docs/adr/1026-a-day-screen-keeps-the-day-you-moved-to.md`. 1026 is the lowest number
  no file and no open branch has used — 1025 is taken by `chore/on-the-phone`, checked against every
  ref on 2026-09-04 with `git log --all --name-only` — and `docs/adr/README.md` gains its row.
- **`docs/open-questions.md` § *Settled*: the 2026-09-02 entry on how far back the past stays
  writable owes its last line.** It settled the record's half and left "whether a screen offers all
  of it" to `day-screen` (#27, B-016); this Story is that screen and the answer is *all of it, and
  forward too*. `spec-author` may not write that file (`AGENTS.md` § *Agent roles and model
  routing*), so `tasks.md` names it as a chore commit alongside the merge, exactly as #92 named its
  own.
- **`docs/backlog.md`** — the want is already *Decided* against `FEAT: day-screen` (#27). This change
  does not edit the file.
- **`openspec/specs/day-screen/spec.md`** is rewritten at archive time, by `/opsx:archive` and
  nothing else. Exactly one capability is claimed, so CI check 2 stays green.
- **No new dependency, no platform floor change and no CI change.**
