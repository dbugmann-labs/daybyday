## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5): a rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written
as a test without changing its title, a new test that passes before the code it names is written, a
fix that reaches outside `LookBack.swift`, `LookBackWords.swift`, `CommitmentsScreen.swift`,
`CommitmentsView.swift` and `LookBackView.swift`, or any other test in the suite turning red.

Rule 3 governs §§ 3–9: take the next unticked box, write the one test named for it, watch it fail,
make it pass, then the next. Every test in §§ 3–9 goes in
`src/DayByDayKit/Tests/DayByDayKitTests/LookBackTests.swift`, new.

## 2. The seam

- [ ] 2.1 Every member in `design.md` § *The seam* exists with that signature, and 3.1 is red before any of them does anything but compile
- [ ] 2.2 `Roster`, `Commitment`, `CalendarDate` and `History` are unchanged, and every shipped test still passes untouched

## 3. The door — one test each

- [ ] 3.1 a commitments screen answers a look-back at a commitment it keeps — catches a look-back answered only for the kept list's first entry
- [ ] 3.2 a commitments screen answers a look-back at a commitment it has stopped, saying the day it was kept until — catches a stopped commitment read off the kept list's `keptUntil` of `nil`
- [ ] 3.3 a commitments screen answers no look-back at a commitment on neither of its lists — catches a removed commitment reachable by asking for it directly
- [ ] 3.4 a commitments screen that cannot read its roster or its record answers no look-back — catches a record place checked only when a fraction is wanted
- [ ] 3.5 asking a commitments screen for a look-back changes nothing and writes nothing — catches a read that refreshes the lists or touches a place

## 4. The months — one test each

- [ ] 4.1 a look-back says a month's kept days out of the days that month was due — catches due days counted as days in the month
- [ ] 4.2 a look-back says its months newest first, and leaves none between out — catches oldest first, or a month emitted only where a day is due
- [ ] 4.3 a look-back says a month the commitment was due on no day with nothing due — catches the month dropped from the list
- [ ] 4.4 a look-back counts the month in progress through today and no further — catches the whole month's due days counted
- [ ] 4.5 a stopped commitment's look-back counts through the day it was kept until — catches counting through today for every commitment
- [ ] 4.6 a look-back counts no day after the day a commitment was kept until — catches a kept day counted past the last day counted
- [ ] 4.7 a look-back counts no day before the day a commitment is kept from — catches the month walked from its first day
- [ ] 4.8 a look-back at a commitment kept from a day after today says no month at all — catches a month list run backwards from today

## 5. The whole — one test each

- [ ] 5.1 a look-back's whole counts every kept day out of every due day since the day it is kept from — catches a whole counted over the newest era alone
- [ ] 5.2 a look-back's whole is the sum of the months it says — catches a whole counted by a second rule that can disagree
- [ ] 5.3 a look-back that counts no due day at all says a whole of nothing out of nothing — catches no whole at all, or a division

## 6. The chain — one test each

- [ ] 6.1 a look-back counts the era behind the one it was asked about — catches a month counted against one era for all of its days
- [ ] 6.2 a look-back says the newest era's rhythm and the earliest era's day kept from — catches the head read off the commitment asked about alone
- [ ] 6.3 a look-back chains every era behind the one it was asked about — catches one step back and no further
- [ ] 6.4 a removed commitment of another name or another kind is not an earlier era — catches resemblance tested on the day alone
- [ ] 6.5 a removed commitment kept until any day but the day before is not an earlier era — catches an off-by-one on either side of the boundary
- [ ] 6.6 a look-back takes the nearest of two removed commitments that both answer — catches the first match in the roster's order rather than the nearest
- [ ] 6.7 an era the roster has taken up again is kept rather than removed and ends a chain — catches a chain read off `keptUntil` without `isRemoved`

## 7. Where the rhythm changed — one test each

- [ ] 7.1 a look-back says where the rhythm changed, above the month the newer era is kept from — catches the line below that month, or at the older era's last month
- [ ] 7.2 a look-back of one era says no line where the rhythm changed — catches a line emitted for the newest era's own start
- [ ] 7.3 a look-back of three eras says one line where the rhythm changed for each boundary — catches one line for the whole chain
- [ ] 7.4 a look-back says where an interval commitment's count began again — catches a line drawn only where the rhythm in words differs

## 8. What says nothing yet — one test each

- [ ] 8.1 a look-back at a commitment whose days take a number, a note or a total says no line and no whole — catches a head left empty too, or a total counted by its target
- [ ] 8.2 a look-back at a weekly quota says its months with no fraction and no whole — catches a quota's days counted as due every day
- [ ] 8.3 a look-back says no fraction on a month a weekly-quota era counts a day of — catches the straddling month counting its non-quota days

## 9. The words — one test each

- [ ] 9.1 a look-back says a month as that month's name and its year — catches a locale-formatted month, and a name missing from the table
- [ ] 9.2 a look-back says a day as the day of the month, that month's name and the year — catches a zero-padded day or a locale's order

## 10. The shell (ADR-1019: this Story's immediate consumer, no behaviour the kit does not specify)

- [ ] 10.1 `CommitmentsView.swift` makes each entry on both lists a `NavigationLink` to `LookBackView`, leaving the leading and trailing swipes exactly as they are, and `pnpm run verify` passes and the app target builds
- [ ] 10.2 `LookBackView.swift` draws the name, the rhythm, the two days, the whole and the lines in the order the look-back says them, decides nothing and offers no control, and the app target builds again after it

## 11. The records

**The ADR and the `CONTEXT.md` entries are written by this Story's proposal commit, not by the
implementation.** These boxes confirm rather than write.

- [ ] 11.1 Confirm `CONTEXT.md` § *Era*, § *Look-back* and § *Commitments screen* still describe what shipped; a sentence that turns out wrong is a **stop and a G4 question**, never an edit slipped in
- [ ] 11.2 Confirm `docs/adr/1055-*.md` and ADR-1045's 2026-09-15 amendment still describe what shipped, and that `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 12. The gates

- [ ] 12.1 `openspec validate look-back-at-a-tick --strict` exits 0 and `pnpm run check:scenarios` exits 0
- [ ] 12.2 `git diff --stat origin/main` lists only this change folder, `CONTEXT.md`, `docs/adr/`, the two new kit sources, `CommitmentsScreen.swift`, the new test file and the two shell files
- [ ] 12.3 `pnpm run check:budgets` warns about nothing in this folder, or each warning is named here with why it stands
- [ ] 12.4 `swift test` in `src/DayByDayKit` passes, and the count it reports is thirty-two more than a run on `main` reports — both read off runs, neither derived
- [ ] 12.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–12.4 and the walk below are ticked and that the instruction here is written for the janitor to carry out. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff it produced: `openspec/specs/look-back/spec.md` is created with this delta's seven requirements and thirty-two scenarios and its `## Purpose`, carrying no `TBD`; nothing else in any spec moves. `pnpm run checks` runs after the archive commit exists, and the archive commit is pushed. **Any other drift is a stop and a report, never a hand-edit** — rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.

## The walk

- [ ] W.1 The commitments screen with a kept tick commitment, a stopped one and a number one on it — the picture shows the entries as the door, with the swipes undisturbed
- [ ] W.2 The kept tick commitment's look-back, opened by tapping its entry — the picture shows the head, the whole, and several months newest first with the month in progress at the top
- [ ] W.3 The stopped tick commitment's look-back — the picture shows the day kept until in the head, and no month after it
- [ ] W.4 The number commitment's look-back — the picture shows the head and no month and no whole under it
- [ ] W.5 A tick commitment's look-back whose roster holds its earlier era removed — the picture shows the line where the rhythm changed between the months
- [ ] W.6 **The handover** — the implementer posts W.1 through W.5 to the PR with `gh pr comment --attach` before hand-back, and ticks this box on that comment's URL
