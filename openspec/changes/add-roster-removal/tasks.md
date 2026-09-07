## 1. Before a line is written

- [x] 1.1 Confirm the starting point, and report rather than work around a different one (rule 5).
  From `src/DayByDayKit`, `swift test` reports **489 tests passing** — measured 2026-09-07 with this
  branch rebased onto `main` at `62ffe83`, which includes `add-number-record` (#151). From the repo
  root, `pnpm run check:scenarios` reports `scenario coverage — 107/161 scenario(s) covered` for this
  change and names `"offering a commitment the roster has removed takes it up again, in the place it
  was taken on in"` as next. Those 107 are the scenarios this delta carries verbatim from the
  current spec; **no test behind any of them may be renamed or moved by a box below**, and only the
  two named in § 5 may have an assertion changed at all.

**The order below is not the order the delta reads in.** The roster comes first because everything
else asks it something, the store second because the screen writes through it, and the screen's
day-before change comes before the screen's removal because two of the removal scenarios assert the
day the screen hands. `day-screen` comes last because it reads a roster that by then already
removes.

## 2. `commitment` — a roster removes a commitment, and never lets it go

Ten scenarios from `specs/commitment/spec.md` § *A roster removes a commitment it holds, and never
lets it go*, all in `Tests/DayByDayKitTests/RosterTests.swift`. Each task takes exactly one
`#### Scenario:` and writes one acceptance test whose `@Test("...")` display name is that scenario
title **verbatim**, then makes it pass with the smallest change that does. Never write two before
the first is green (`AGENTS.md` rule 3). Verify each with `cd src/DayByDayKit && swift test`: the
named test green, every earlier test still green.

- [x] 2.1 `removing a commitment a roster keeps says so and records the day it was kept until` — the
  first test in this change, and the one that adds `isRemoved: Bool` to `Roster.Entry` and
  `public mutating func remove(_:keptUntil:) -> Bool` to `Roster`. `design.md` § *The seam* fixes
  both: the entry's third part is stored and internal, and `remove` is one method taking a date that
  is used only where the roster holds no kept-until day for that commitment yet.
- [x] 2.2 `removing a commitment a roster has stopped keeping keeps the day it was already kept until`
  — the half of `remove` that ignores the date it is handed.
- [x] 2.3 `removing one commitment leaves every other where it was`
- [x] 2.4 `removing a commitment a roster does not hold says it was not removed and leaves the roster as it was`
- [x] 2.5 `removing a commitment already removed says it was not removed and keeps the day first given`
- [x] 2.6 `a commitment removed as of the first supported date and one as of the last are both accepted`
- [x] 2.7 `a removed commitment answers whether it is due on a date exactly as it did before` — the
  scenario that proves `Commitment` gained nothing, which is ADR-1023's argument and ADR-1035's.
- [x] 2.8 `removing a commitment on a copy of a roster leaves the roster it was copied from unchanged`
- [x] 2.9 `two rosters differing only in whether a commitment has been removed are different rosters`
- [x] 2.10 `a roster that has removed every commitment it holds is not a roster holding nothing` —
  the roster half of ADR-1027's obligation; § 8 has the day screen half.

## 3. `commitment` — the roster's other rules meet the third state

Five scenarios, all in `Tests/DayByDayKitTests/RosterTests.swift`, same one-scenario-one-test rule
as § 2.

- [x] 3.1 `offering a commitment the roster has removed takes it up again, in the place it was taken on in`
  — `add` clears `isRemoved` as well as the kept-until day.
- [x] 3.2 `a commitment taken up again after being removed is kept on every date again`
- [x] 3.3 `stopping a commitment a roster has removed says it was not stopped and keeps the day it was kept until`
  — `retire`'s third refusal case.
- [x] 3.4 `a removed commitment is in the answer on the day it was kept until and out of it on the next day`
  — this one may well be green the moment `remove` exists, because `commitments(on:)` already reads
  the kept-until day and nothing else. Write it anyway and say so in the PR: it is the scenario that
  makes the invisibility of removal to a past date a fact rather than a coincidence.
- [x] 3.5 `removing a commitment leaves every earlier date answering as it did`

## 4. `commitment` — a roster store keeps a removal and reads the two forms before it

Nine scenarios in `Tests/DayByDayKitTests/RosterStoreTests.swift`. `design.md` § *The form on disk*
fixes what changes, and it is a copy of what `RecordDocument`/`RecordStore` already do since
`add-number-record` (#138): `RosterDocument.currentVersion` becomes 3, a second constant
`removalIntroducedInVersion` is added beside it, `RosterEntryRecord` gains `removed`, the version
guard stays the closed range `1...currentVersion`, one new guard checks that every entry's `removed`
is present exactly when the declared version is at or above `removalIntroducedInVersion`, and there
is no migration pass and no rewrite on open. **Read `RecordStore.init(at:)` before writing any of
this** — the comment above its own guard says why the second constant exists, and this one exists for
the same reason.

- [x] 4.1 `a commitment removed through a roster store is read back removed, on the day it was kept until`
  — the task that moves the form. `RosterDocument.formRoster()` replays through `Roster.add`,
  `Roster.retire` and now `Roster.remove`, so a document that could not be a roster is still refused
  rather than trusted.
- [x] 4.2 `a removal a roster store refuses is reported and nothing at its place changes`
- [x] 4.3 `a commitment taken up again through a roster store after being removed is read back kept`
- [x] 4.4 `a removal that cannot be kept is refused and the roster a store reports does not move`
- [x] 4.5 `a roster kept before a commitment could be removed is read with every commitment not removed`
  — the form-2 read. Build the fixture by hand, as the form-1 fixtures in this file already are;
  do not build it by writing with an older binary.
- [x] 4.6 `a roster store declaring a form written before removal and saying something about removal is refused`
  — one half of the shape-against-form guard.
- [x] 4.7 `a roster store declaring the form this app writes and saying nothing about removal is refused`
  — the other half. Both fixtures are written by hand, as the form-1 fixtures in this file are.
- [x] 4.8 `a commitment removed over a roster kept before removal existed is read back removed` — the
  form-2-in, form-3-out path.
- [x] 4.9 `a roster store holding a commitment removed with no day it was kept until is refused` — the
  one new way a *roster* can fail to be formed, as against the two above, which are ways a *form* can
  fail to be the shape it declares. This is the reason `remove` is replayed through `Roster` rather
  than the field being read straight into an entry.

## 5. `commitment` — the day a commitments screen hands moves back one

Settled answer 3, ADR-1023 amended. Two existing tests change what they assert and **keep their
names**; two new scenarios follow. All in `Tests/DayByDayKitTests/CommitmentsScreenTests.swift`.

- [x] 5.1 Rewrite the assertions of `a commitment stopped through a commitments screen is kept until
  the day the screen was handed` (line 699–700 as it stands) to the delta's — "Gym" answered on
  Sunday 30 August 2026, nothing on Monday 31 August 2026, nothing on Tuesday 1 September 2026 —
  watch it go red, then make it green by having `confirmStopKeeping` retire as of the day **before**
  `dayToKeepFrom`, falling back to `dayToKeepFrom` itself where the calendar has no day before it.
  **Do not rename this test.** Its title is wrong from here on and `design.md` § *Three scenario
  titles that are now wrong* holds the measured reason it cannot be dropped.
- [x] 5.2 Rewrite the assertions of `a commitments screen shown again on a later day stops a
  commitment as of that later day` (line 1099 as it stands) to name Monday 31 August 2026 rather
  than Tuesday 1 September 2026, and confirm it is green off 5.1's change alone. If any **other**
  test in the package goes red at this point, stop and report it: `design.md` names these two as the
  only ones whose assertions move, measured 2026-09-07.
- [ ] 5.3 `a commitment defined and stopped on one day through a commitments screen is kept on no day at all`
- [x] 5.4 `a commitments screen handed the first supported date stops a commitment as of that day` —
  the calendar floor, and the one place `CalendarDate.adding(days: -1)` answers `nil`.

## 6. `commitment` — a commitments screen removes a commitment on a typed-back name

Eighteen scenarios, all in `Tests/DayByDayKitTests/CommitmentsScreenTests.swift`. `design.md`
§ *The seam* and § *The screen holds what has been typed* fix the surface: `askToRemove(_:)`,
`cancelRemoving()`, `confirmRemoving() -> Refusal?`, `awaitingRemoval: Commitment?` (private set),
`nameTypedBack: String` (settable, so the shell binds to it) and `nameTypedBackMatches: Bool`
(computed). `RefusedChange` gains a fourth case, `removing(Commitment, Refusal)`.

- [x] 6.1 `asking a commitments screen to remove a commitment changes nothing until it is confirmed`
- [x] 6.2 `a commitments screen says a name typed back matches only when it is the commitment's name`
- [x] 6.3 `a name typed back with blank space at either end matches, and one differing in case does not`
- [x] 6.4 `a name typed back differing in blank space inside the name does not match`
- [x] 6.5 `a commitment whose name ends in a space is removed by typing the name without it` — the
  scenario `design.md` § *Blank space is trimmed from both sides of the comparison* exists for. Trim
  both the typed name and the commitment's name; trimming only the typed one makes this commitment
  unremovable.
- [x] 6.6 `a removal confirmed on a name that does not match changes nothing and refuses nothing`
- [x] 6.7 `a removal confirmed with nothing awaiting removal changes nothing`
- [x] 6.8 `a kept commitment removed through a commitments screen is kept until the day before the one the screen was handed`
  — the same day-before helper § 5 introduced; do not write a second one.
- [x] 6.9 `a stopped commitment removed through a commitments screen keeps the day it was already kept until`
- [x] 6.10 `a commitment removed through a commitments screen is in neither of its lists`
- [x] 6.11 `a removal a commitments screen has been asked for and then cancelled changes nothing`
- [x] 6.12 `a commitments screen asked to remove a second commitment awaits removal of that one only`
- [x] 6.13 `a commitments screen asked to remove a commitment on neither of its lists does nothing`
- [x] 6.14 `a removal a commitments screen could not keep leaves both its lists as they were`
- [x] 6.15 `asking a commitments screen to remove a commitment leaves no stop awaiting confirmation`
- [x] 6.16 `asking a commitments screen to stop keeping a commitment leaves nothing awaiting removal`
  — the other half of 6.15. Two slots, mutually exclusive by rule; `design.md` § *Two confirmation
  slots* says why not one slot with a discriminator.
- [x] 6.17 `a commitments screen shown again leaves nothing awaiting removal and nothing typed back`
- [x] 6.18 `a commitments screen handed the first supported date removes a kept commitment as of that day`

## 7. `commitment` — the screen's other rules meet removal

Eight scenarios in `Tests/DayByDayKitTests/CommitmentsScreenTests.swift`.

- [x] 7.1 `a commitments screen lists a commitment its roster has removed in neither of its lists` —
  the stopped list is computed from `roster.entries`, so this is where that computation learns about
  the third state.
- [x] 7.2 `removing one of two entries alike in name removes the one it was asked about`
- [x] 7.3 `a commitment defined again after being removed is taken up again in the place it was taken on in`
- [x] 7.4 `a commitments screen that cannot read its roster does nothing when it is asked to remove a commitment`
- [x] 7.5 `a commitments screen holds a refused removal against the commitment it was asked to remove`
- [x] 7.6 `a commitments screen holds nothing against a removal confirmed on a name that does not match`
- [x] 7.7 `what a commitments screen holds about a refused change ends when a removal is kept`
- [x] 7.8 `what a commitments screen holds about a refused change stands when a removal is asked for and cancelled`

## 8. `day-screen` — a removed commitment's rows, and day one

Two scenarios from `specs/day-screen/spec.md`, in `Tests/DayByDayKitTests/DayScreenTests.swift`.
Both should pass without a line changing in `DayScreen.swift`; that is the claim, and these are the
tests that turn it into a fact.

- [x] 8.1 `a day screen draws a removed commitment on the day it was kept until and not on the day after it`
  — carries a tick made before the removal, so it asserts the whole promise: the row is drawn and it
  still says kept.
- [x] 8.2 `a day screen opened on a roster whose commitments have all been removed takes nothing on`
  — ADR-1027's obligation, discharged without a marker. If `DayScreen` needs a change to pass this,
  stop and report it: `design.md` says it should not, and a change here would mean the day-one
  condition was not what it was believed to be.

## 9. The app shell

Under ADR-1019's 2026-09-04 amendment, whose three conditions `design.md` § *The shell rides this
Story* checks off one by one. Every string drawn arrives whole from `DayByDayKit`; the shell decides
no day, no match and no refusal. Only `src/DayByDay/DayByDay/CommitmentsView.swift` changes.

- [x] 9.1 Move both lists' actions into swipe actions: a kept row swipes to **Stop** or **Remove**, a
  stopped row to **Resume** or **Remove**. Delete the `Button` wrapper that makes the whole row
  tappable in each list — settled answer 8, and the row's own tap does nothing afterwards.
- [x] 9.2 Draw the removal confirmation: the commitment's name shown, a text field bound to
  `screen.nameTypedBack`, a destructive confirm button disabled while `screen.nameTypedBackMatches`
  is `false`, and a cancel that calls `cancelRemoving()`. No message under the field when the name
  does not match — settled answer 6, and § *A name that does not match is not a refusal*.
- [x] 9.3 Add the fourth `RefusedChange` case to the shell's existing refusal rendering, beside
  `.stopping` and `.keepingAgain`, using `refusalText` unchanged. No new sentence is invented here.
- [ ] 9.4 Run it. `pnpm run phone`, or the simulator per `docs/running-the-app.md`, and check by
  hand: stop a commitment and watch its row leave today's list at once; remove a kept one and a
  stopped one; type the name wrong and confirm the button stays dead; remove a commitment that has a
  tick and confirm the day screen still draws its row on the day it was kept until. Note what was
  seen in the PR. This is the box the exception exists for.

## 10. The records

- [x] 10.1 Write `docs/adr/1035-a-roster-never-lets-a-commitment-go.md` — the decision that removal
  is a last state rather than a departure, the two alternatives it beat (drop the entry; refuse
  removal where records exist), and the consequences: past days keep their rows, day one stays
  unreachable without a marker, the file gains a state, and the way back is defining the commitment
  again. **Confirm 1035 is still the lowest free number before writing**, against `docs/adr/` on
  `main` and against every open branch — `origin/story/138-add-number-record` holds `1033` and
  `add-rhythm-in-words` renumbered to `1034` for exactly this reason. `git ls-tree -r --name-only
  <branch> -- docs/adr` per branch answers it.
- [x] 10.2 Amend `docs/adr/1023-a-commitment-is-kept-until-a-day-the-roster-holds.md` in place, with
  an `- Amended: 2026-09-07 — ...` line under `Deciders` (ADR-1020). The kept-until day stays
  inclusive and stays the roster's to judge; what changes is that a commitments screen hands the day
  *before* the one it was handed, and the price — a tick made this morning is not drawn on a
  commitment stopped this afternoon — is stated as taken knowingly. Leave one coherent decision
  behind, not a decision with a rebuttal stapled to it.
- [x] 10.3 Leave `docs/adr/1031-a-store-reads-the-form-before-it.md` alone, and confirm before the
  review that leaving it alone is still right. It was amended on 2026-09-06 at `add-number-record`
  (#138) and its trigger now reads *"a fourth form, or a form that differs by more than a field"*;
  the roster's form 3 differs from its form 2 by one field under one comparison, so nothing here is
  new to it. If the implementation ends up needing more than that one comparison, **stop**: that is
  the trigger firing, and it is an ADR amendment rather than a wider guard.
- [x] 10.4 Add the ADR-1035 row to `docs/adr/README.md`'s DayByDay table, and update ADR-1023's row
  there if its one-line summary no longer describes the decision as it stands.
- [x] 10.5 Move the want off `docs/backlog.md` § *Wants* if it is still listed there, and check its
  § *Decided* line for `add-roster-removal` still describes what shipped — it says the Story "owes
  ADR-1027's test for a place nothing has ever been taken on at", which § 8.2 is.

## 11. Before the review, and what the janitor does at the archive

- [ ] 11.1 `cd src/DayByDayKit && swift test` — every test green, and the count is 489 plus the 54
  scenarios above. From the repo root, `pnpm run verify` green and `pnpm run checks` reporting
  `161/161 scenario(s) covered`.
- [ ] 11.2 `openspec validate add-roster-removal --strict` exits 0, and `openspec validate --all
  --strict --no-interactive` exits 0.
- [ ] 11.3 Rebase onto current `main` and push with `--force-with-lease`. A conflict inside
  `openspec/changes/add-roster-removal/` or anywhere under `openspec/specs/` is a **stop**, not a
  merge to resolve: it means another Story landed on `commitment` or `day-screen` while this one was
  being written, which is the owner's call (rule 5).
- [ ] 11.4 Ask for the review (**G7**) with `mattpocock-skills:code-review`, and fix what it finds on
  this branch before the archive.
- [ ] 11.5 Tell the janitor, in the archive handover, that after `/opsx:archive` has run it must read
  the recomposed `openspec/specs/commitment/spec.md` and `openspec/specs/day-screen/spec.md` and
  confirm that each MODIFIED requirement sits where it sat before — this delta renames nothing, so
  nothing may have moved to the bottom of either file — and that `openspec validate --archived`
  exits 0. **Any drift is a stop and a report, never a hand-edit**: `openspec/specs/` is written by
  `/opsx:archive` and by nothing else (rule 2), and the archived folder is denied to every editor.
  This box is ticked when the instruction has been written into the handover, which is before the
  archive runs; the checking itself is the janitor's step and has no box, deliberately —
  `add-roster-store` (#103) shipped a box that could only be ticked after the archive and stalled
  the Story between review and merge.
