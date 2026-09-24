A command that fails or does something unexplained is a stop and a report, not a thing to work
around (`AGENTS.md` rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario
that cannot be written as a test without changing its title, a test that passes before the code it
names is written, a fix that reaches a shipped Kit file, or any other test in the suite turning red.
Rule 3 throughout: one scenario, one acceptance test named identically to it, one red-green cycle.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` names this change's uncovered scenarios; they
  are exactly the twelve titles boxed in § 3. Any other uncovered title is a stop.
- [x] 1.2 The tests go in a new `src/DayByDayKit/Tests/DayByDayKitTests/BirthdaySwitchTests.swift`,
  with a fake phone whose access a test sets, whose answer to an ask a test sets, and which counts
  its asks; each place is a fresh directory, as `CopyPlaceTests` makes one.

## 2. The seam

- [x] 2.1 `CalendarAccess` and `BirthdaySwitch` exist with the signatures in `design.md` § *The
  seam*, and 3.1 is red before either does more than compile
- [x] 2.2 `isOn` and `isRefused` change only in `init`, `shown()`, `turnOn()` and `turnOff()`; the
  verdict that write-only, denied and restricted refuse lives in the Kit, and no Kit file imports
  `EventKit`
- [x] 2.3 The form on disk is `design.md` § *The form on disk, version 1*; anything unreadable opens
  off, as `CopyPlace`'s own state does, and `BirthdaySwitch.place` is its own file under
  `ApplicationSupport/DayByDay/`

## 3. The twelve scenarios — one test each

- [x] 3.1 a birthday switch opened where nothing has been kept is off — catches a switch that opens on, or asks at opening
- [x] 3.2 a birthday switch opened again is on or off as it was left — catches a switch held only in memory
- [x] 3.3 a birthday switch opened where what is kept cannot be read is off — catches an unreadable file refused, or read as on
- [x] 3.4 a restore confirmed leaves the birthday switch as it was before the restore — catches the switch carried in a copy
- [x] 3.5 birthdays turned on where the phone has never been asked are on once it gives full access — catches on before the answer is read
- [x] 3.6 birthdays turned on and refused at the prompt turn themselves back off — catches a switch left on over a refusal
- [x] 3.7 birthdays turned on where the phone already gives full access are on without asking — catches an ask on every turn
- [x] 3.8 birthdays turned on where the phone gives less than full access ask again, and are on only if it then gives it — catches asking only when never asked
- [x] 3.9 birthdays turned off are off and kept off, and ask nothing — catches a turn-off that never reaches the disk
- [x] 3.10 birthdays kept on are off when opened where the phone no longer gives full access — catches on computed from access alone
- [x] 3.11 birthdays on are off when shown again after access is withdrawn, and stay off when it is given back — catches a switch that reads access only at opening
- [x] 3.12 a birthday switch says it is refused where the phone refuses, though it was never turned on — catches a refusal remembered as an event

## 4. The shell

- [x] 4.1 `src/DayByDay/Info.plist` carries `NSCalendarsFullAccessUsageDescription` with the sentence
  in `design.md` § *The shell*, verbatim
- [x] 4.2 The adapter maps every `EKAuthorizationStatus` onto the `CalendarAccess` of the same meaning
  and `@unknown default` onto `.denied`, and asks through `requestFullAccessToEvents()`, ignoring its
  error; it lives in `src/DayByDay/DayByDay/` and nowhere in the Kit
- [x] 4.3 `ContentView` builds one `BirthdaySwitch` beside `copyPlace`, hands it to `CommitmentsView`,
  and calls `shown()` when the app becomes active and when *Commitments* is tapped
- [x] 4.4 `CommitmentsView` draws the section in `design.md` § *What the shell draws*, just above
  *Copy*, with the words in § *The shell* verbatim; *Open Settings* opens `openSettingsURLString`
- [x] 4.5 The app target builds for the simulator, and `CommitmentsScreen` and `CopyPlace` are
  untouched: `git diff origin/main -- src/DayByDayKit/Sources` lists `BirthdaySwitch.swift` alone

## 5. The records

- [x] 5.1 Confirm `CONTEXT.md` § *Birthday*'s 2026-09-24 amendment for #327 still describes what
  shipped; a sentence that turns out wrong is a stop and a G4 question, never an edit
- [x] 5.2 Confirm `openspec/specs/` was not hand-edited on this branch (rule 2):
  `git diff --stat origin/main... -- openspec/specs/` reports nothing

## 6. The walk

- [x] 6.1 The commitments screen on a first visit, scrolled to its foot — the *Birthdays* switch off above *Copy*, the explaining line under it, no refused line.
- [x] 6.2 The switch just turned on — the system's calendar prompt over the screen, carrying the usage sentence.
- [x] 6.3 The prompt allowed — the switch on, the explaining line under it, no refused line.
- [x] 6.4 Calendar access reset, the switch turned on and the prompt refused — the switch off, the refused line and *Open Settings* under the explaining line.
- [ ] 6.5 phone: with birthdays on, calendar access turned off for DayByDay in Settings and the app returned to — the switch off and the refused line shown.
- [ ] 6.6 phone: *Open Settings* tapped — Settings open on DayByDay's page, with Calendars on it.
- [x] 6.7 Post the pictures to the PR with `pnpm run walk -- --post-only <pr>` before hand-back, and
  tick this on the comment's URL — that command and never `gh pr comment --attach`. The walk's
  throwaway test resets calendar access itself; a change to `scripts/walk.ts` is a stop. The two
  `phone:` boxes are the human's at G7, and the conductor ticks them on the G7 approval.

## 7. Gates and the archive handover

- [ ] 7.1 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` reporting every test
  passing and twelve more than a run on `main` reports — both counts read off runs.
- [ ] 7.2 `openspec validate turn-birthdays-on --strict` exits 0 and `pnpm run checks` is clean but
  for what it is expected to warn.
- [ ] 7.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`.
- [ ] 7.4 The **implementer** ticks this box in its last commit before the archive, on the evidence
  that the change folder is committed, `tasks.md` has no other unticked box and the walk comment's
  URL is in § 6.7. The janitor then runs `/opsx:archive` itself and checks afterwards that
  `openspec/specs/birthday/spec.md` gained this delta's four requirements and twelve scenarios and
  no other spec file moved. **Any drift there is a stop and a report, never a hand-edit.**
