# Grill — turn-birthdays-on

*14 questions over 4 rounds, the last the layout round, 2026-09-24, one fact agent, no fact sent to the owner. The Feature
grill settled the boundary (`docs/backlog.md` § Decided, 2026-09-24, B-059) and `add-birthday`'s
grill settled the store; this file does not repeat either.*

## Settled

1. **Turned on and refused, the switch turns itself back off**, and the refused line says why.
   *The owner's call against the recommendation to leave it on: the switch shows what is actually
   happening, and turning it on again after fixing Settings is the person's own act.*
2. **One refused line for every way access falls short of full** — refused at the prompt,
   withdrawn in Settings, restricted by Screen Time, and write-only. *The fix is the same place in
   every case.*
3. **The refused line ends in a button that opens DayByDay's page in Settings.** *Once refused,
   iOS never asks again; Settings is the only way back.*
4. **This Story asks for access and reads nothing.** The switch, the prompt and the refused line
   only; reading the Birthdays calendar is #328's, where a birthday is first drawn. *It is seen to
   work where it is built.*
5. **The prompt's sentence** (`NSCalendarsFullAccessUsageDescription`): "DayByDay reads your
   Birthdays calendar to show each birthday on its day. It adds nothing to your calendars and
   changes nothing in them." *What iOS grants is all calendars, so the sentence promises what the
   app does with them rather than what it can reach.*
6. **The switch carries one line saying what it does**, shown on or off — for example "Birthdays
   from your phone's calendar, on the day they fall." *Turning it on raises a system prompt, which
   the person should expect before it appears.*
7. **The switch's state is the app's second setting**, after the copy place: kept across the app
   being closed, at a place of its own, never in the birthday store, never in a copy, never
   replaced by a restore. A new phone starts off. *"Never kept" in `CONTEXT.md` meant never in the
   store or a copy; settlement 1 needs the switch remembered.*
8. **Access withdrawn while the switch is on turns it off**, with the refused line, the same as
   a refusal at the prompt. Access given back in Settings brings nothing back until the person
   turns the switch on. *Consistent with 1.*
9. **The refused line shows whenever the phone refuses**, visit after visit, and not only after
   an attempt. *One rule from the phone's state, with nothing remembered about the event; someone
   who refused on purpose sees it too, and it tells them why the switch will not stay on.*
10. **The refused line's words**: "Calendar access is off for DayByDay, so birthdays can't be
    read.", then the Open Settings button. *True whoever refused, including Screen Time, where an
    instruction would be wrong.*
11. **The walk** — on the simulator: the switch off with its explaining line on a first visit;
    the system prompt after turning it on; the switch on after *Allow*; the switch back off with
    the refused line and Open Settings after *Don't Allow*. `phone:` withdraw access in Settings
    and come back — the switch is off and the line shows. `phone:` Open Settings lands on
    DayByDay's page, with Calendars on it.

## Facts carried to spec-author

- The commitments screen is `CommitmentsView` (`src/DayByDay/DayByDay/CommitmentsView.swift`), one
  plain `List`: kept groups, *Stopped*, loose trouble lines, and *Copy* last. Its toolbar holds the
  reorder toggle and `+`. No switch-style control exists anywhere in the app.
- Nothing uses `UserDefaults` or `@AppStorage`. The Kit resolves every place under
  `ApplicationSupport/DayByDay/` (`DayScreen.swift:50-74`, `CopyPlace.swift:15-21`); ADR-1017
  rejected `UserDefaults` for the record because it is not a place a test can point at.
- No calendar usage key and no `EventKit` import. The project is a hand-kept `.xcodeproj` with
  `GENERATE_INFOPLIST_FILE = YES` plus `Info.plist`; the app targets iOS 26.0, the Kit `.iOS(.v17)`
  and imports Foundation only.
- `EKAuthorizationStatus` on iOS 17+: `.notDetermined`, `.fullAccess`, `.writeOnly`, `.denied`,
  `.restricted` (`.authorized` deprecated). `requestFullAccessToEvents` prompts only the first time.
  Without `NSCalendarsFullAccessUsageDescription`, iOS denies every request.
- Apple documents nothing on termination; a forum thread and `simctl help privacy` say a
  permission change in Settings may terminate the running app. Unverified for calendar, in either
  direction, so the app cannot rely on either being terminated or being told.
- `UIApplication.openSettingsURLString` opens the app's page in Settings.
- Simulator: `xcrun simctl privacy <device> grant|revoke|reset calendar <bundle>`;
  `XCUIApplication.resetAuthorizationStatus(for: .calendar)` exists; the system alert is tapped
  through springboard (labels unverified). `scripts/walk.ts` uninstalls the app before the walk and
  has no privacy step; whether the uninstall clears a calendar grant is unverified.

## Terms landed in CONTEXT.md

- **Birthday**, amended: the switch's state is the app's second setting; the switch is on only
  while access is full and turns itself off otherwise; the **refused line**.
- **Copy place**'s *setting* paragraph, amended: the birthday switch is the second setting.

## Layout

Option A, *Before Copy*, chosen from three at https://claude.ai/artifact/Ts3g76gSodzVvuwaDZNrD1 —
*it puts the app's two settings side by side at the foot of the screen, below the commitments the
screen is for, and its lines go in the footer as Copy's already do.* The switch's label is
"Birthdays" and the section has no heading, so the word is not said twice; the explaining line is
"Birthdays from your phone's calendar, on the day they fall." The refused line is drawn in the
footer's grey, not the refusal red, because it stays on screen on every visit. A button in a
section footer is new to the app. The wireframe follows, verbatim from the designer.

```
A · Before Copy
┌──────────────────────────────────────┐
│ ‹  Commitments               ⇅   +   │
├──────────────────────────────────────┤
│ Creatine - Every day               › │
│ Nails - Every 4 days               › │
│ Finances - The 25th                › │
│ Stopped                              │
│ Nothing has been stopped.            │
│                                      │
│ Birthdays                    [ ○  ]  │   ← switch, its own section, no header
│  Birthdays from your phone's         │   ← footer: explaining line
│  calendar, on the day they fall.     │
│  Calendar access is off for          │   ← footer, only while refused
│  DayByDay, so birthdays can't be     │
│  read.                               │
│  Open Settings                       │   ← link-styled button
│ Copy                                 │
│ Copy place            Pick a folder ›│
│ Make a copy                          │
│ Restore from a copy                  │
│  Pick a folder to keep a copy there. │
└──────────────────────────────────────┘
```

## Left open

None. Every question the frontier raised was answered; the unverified facts above (termination on
a permission change, the alert's labels, whether uninstall clears the grant) are the
implementer's to settle and change no decision.
