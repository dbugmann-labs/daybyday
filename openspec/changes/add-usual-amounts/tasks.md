Anything that fails or surprises is a stop and a report, never a workaround (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a new test that passes before the code it names is written, a carried
test turning red beyond box 1.2, or a change to `scripts/walk.ts`. Rule 3 throughout: take the next
unticked scenario box, write the one test named for it, watch it fail, make it pass.

## 1. Before a line is written

- [x] 1.1 From the repo root, `pnpm run check:scenarios` names this change's uncovered scenarios; they are exactly the forty-three titles boxed in §§ 3–7. Any other uncovered title is a stop.
- [x] 1.2 Once the roster form is 7, the carried `RosterStoreTests` and `RestoreTests` fixtures that declare form 6 as "the form this app writes" move to form 7 with a `usualAmounts` key on each entry, and nothing else in them changes; each still asserts what its title says. Tick when the suite is green but for §§ 3–7's new tests.

## 2. The seam

- [x] 2.1 Every member in `design.md` § *The seam* exists with that signature, `usualAmounts` held on `Roster.Entry` and written by `RosterEntryRecord`, and no other public signature in the Kit changes; `CommitmentRecord` is untouched.

## 3. `Commitment.UsualAmount`

- [x] 3.1 a usual amount is formed from an amount above zero and reads back its amount and its name
- [x] 3.2 an amount of zero or below forms no usual amount
- [x] 3.3 a usual amount named only blank space has no name, and any other name is kept as given — catches a trimmed name

## 4. `Roster`

- [x] 4.1 a roster declares usual amounts on a total commitment and reads them back
- [x] 4.2 declaring usual amounts puts no era on and leaves everything else about the commitment as it was — catches `declare` routed through `put(era:)`
- [x] 4.3 a commitment's usual amounts stay through a new era, a rename, a stop and a take-up again — catches an act that forms an entry without them
- [x] 4.4 a stopped commitment's usual amounts are declared and it stays stopped
- [x] 4.5 declaring usual amounts on a commitment that is not a total is refused
- [x] 4.6 declaring more than five usual amounts is refused
- [x] 4.7 declaring two usual amounts alike is refused — catches names compared as typed
- [x] 4.8 declaring usual amounts on a commitment a roster does not hold is refused
- [x] 4.9 a roster answers usual amounts smallest first, an unnamed one before a named one of the same amount — catches a case-sensitive name order

## 5. `RosterStore`

- [x] 5.1 usual amounts declared through a commitments screen are held by a roster store opened afterwards at the same place — catches an era written without them
- [x] 5.2 a roster store holding usual amounts no total could declare is refused
- [x] 5.3 a roster store holding eras of one commitment declaring different usual amounts is refused
- [x] 5.4 a roster kept before a commitment could declare usual amounts is read with every commitment declaring none — catches a read that rewrites the place
- [x] 5.5 a roster store declaring a form written before usual amounts and saying something about them is refused
- [x] 5.6 a roster store declaring the form this app writes and saying nothing about usual amounts is refused
- [x] 5.7 usual amounts declared over a roster kept before they existed are read back

## 6. `CommitmentsScreen`

- [x] 6.1 a total commitment defined with usual amounts through a commitments screen declares them
- [x] 6.2 a usual amount's amount is read as a target is read — catches `Decimal(string:)` in place of `TypedNumber`
- [x] 6.3 a usual amount typed with both its fields blank is no usual amount and is not refused — catches a blank row counted towards five
- [x] 6.4 a usual amount that is not an amount is refused under its row
- [x] 6.5 a usual amount alike with one typed before it is refused under its row
- [x] 6.6 a sixth usual amount is refused under its row — catches an index counting blank rows out
- [x] 6.7 usual amounts typed on a kind that is not a total are ignored rather than refused
- [x] 6.8 a usual amount is refused only where nothing else typed on the sheet is, and before the roster is asked
- [x] 6.9 what a commitments screen tells about a usual amount ends when its usual amounts are edited
- [x] 6.10 a commitments screen says the usual amounts a total commitment declares, smallest first, and none for another kind
- [x] 6.11 a total commitment's usual amounts changed through a commitments screen put no era on it and leave the record place as it was — catches a list change taken for a new era
- [x] 6.12 a target and the usual amounts changed in one save put one era on, and every era declares the new usual amounts
- [x] 6.13 a stopped total commitment's usual amounts changed through a commitments screen are declared, and it stays stopped — catches the stopped guard counting them
- [x] 6.14 a change naming the usual amounts a total commitment already declares, in another order, changes nothing — catches a write on a reordered list
- [x] 6.15 a commitments screen offers another usual amount while fewer than five are on its sheet, blank ones counted — catches blank rows counted out

## 7. `DayView` and `DayScreen`

- [x] 7.1 a total entry says the usual amounts its commitment declares, smallest first and as declared
- [x] 7.2 a total entry on a day of an earlier era says the usual amounts its commitment declares now — catches a list read off the era
- [x] 7.3 two total rows alike but for the usual amounts their commitment declares are different rows — catches a row equal under identity
- [x] 7.4 a usual amount tapped in a total entry is added to the day, and kept before the day view says so
- [x] 7.5 an addition made by a usual amount is taken back as the day's last
- [x] 7.6 a usual amount whose addition cannot be kept is refused and leaves the day view as it was
- [x] 7.7 a day screen returned to from a commitments screen offers the usual amounts declared there
- [x] 7.8 a usual amount that would take the day's sum past what can be kept exactly is refused and told on the row
- [x] 7.9 a usual amount a day screen cannot add on a row changes nothing and tells nothing — catches `add` trusting the amount it is handed

## 8. The shell (ADR-1019: no rule the Kit does not state)

- [x] 8.1 `CommitmentsView`'s sheet draws the usual amounts card as `design.md` § *The shell* says: on Total only, filled from `Change.usualAmounts`, *Add usual amount* last and offered only where `offersAnotherUsualAmount(after:)` says of the rows on the sheet, blank ones included, a row swiped away, every edit telling `.usualAmounts` edited, each refusal under the row its `Int` names in the words given there, and the stopped refusal's words amended
- [x] 8.2 `ContentView`'s total entry is the half-height sheet of § *What the shell draws*, the alert gone: the field focused as it opens and the keyboard up, the usual amounts under it, a tap calling `add(_:on:)` and closing, Save through `enter(_:on:)`, *Take back last* only where offered
- [x] 8.3 The app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 9. The records

- [x] 9.1 Confirm `CONTEXT.md` § *Total entry*'s 2026-09-30 amendment describes what shipped; a sentence that turns out wrong is a stop and a G4 question, never an edit
- [x] 9.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 10. Gates and the archive handover

- [x] 10.1 `openspec validate add-usual-amounts --strict` exits 0, and `pnpm run checks` is clean
- [x] 10.2 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` passing, its count read off the run
- [ ] 10.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 10.4 **The implementer ticks this box in its last commit before the archive**, on the evidence that every other box is ticked — W.5 and W.6 by the conductor — and the walk comment's URL is in W.7. The janitor then runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, and checks afterwards that `commitment/spec.md` gained the six ADDED requirements, carries the renamed change requirement and not the old heading, and that `day-screen/spec.md` gained its two and carries the renamed total entry requirement, with the six MODIFIED requirements whole and no other spec file moved. **Any drift is a stop and a report, never a hand-edit.**

## The walk

A fresh install, with a total named "Protein", target 120, defined through the commitments screen.

- [x] W.1 The commitment sheet changing "Protein", the usual amounts card under the first holding 20 with no name and 35 "Müesli", *Add usual amount* last.
- [x] W.2 The total entry sheet for "Protein" opened again after W.3, over the dimmed day, "35 of 120" under the name, the keyboard up, and all five usual amounts smallest first under the field with nothing scrolled; the hand-back says whether *Take back last* shows above the keyboard or sits under it, read off the picture.
- [x] W.3 After 35 "Müesli" is tapped, the entry closed and the day showing, the "Protein" row reading "35 of 120" under its name — the shell draws the entry's words there, as it does on `main`.
- [x] W.4 The commitment sheet with five rows on it, the fifth typed as a second 35 "Müesli", *Add usual amount* not offered, and after Save "You already have that one." in red under the fifth row.
- [ ] W.5 phone: a usual amount tapped on the phone adds it and closes the entry, and *Take back last* then undoes it.
- [ ] W.6 phone: the entry opens with the keyboard already up.
- [x] W.7 **The handover** — W.1–W.4, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL. W.5 and W.6 are the human's at G7; the conductor ticks them on the G7 approval. https://github.com/dbugmann-labs/daybyday/pull/366#issuecomment-5911762001
