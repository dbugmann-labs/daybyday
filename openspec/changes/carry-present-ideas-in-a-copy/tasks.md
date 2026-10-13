Anything that fails or surprises is a stop and a report, never a workaround (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a new test that passes before the code it names is written, any carried
test turning red or needing an edit § 9 does not name, or a fix reaching outside the files
`proposal.md` § *Impact* names. Rule 3 throughout: take the next unticked scenario box, write the one
test named for it, watch it fail, make it pass, then the next.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` names this change's uncovered scenarios; they are exactly the nineteen titles boxed in §§ 3–8. Any other uncovered title is a stop.
- [ ] 1.2 New tests go in a new `src/DayByDayKit/Tests/DayByDayKitTests/PresentIdeaCopyTests.swift`; every place is a fresh directory, and a present-idea place a test does not name is left to the default beside its record place.

## 2. The seam

- [ ] 2.1 The members in `design.md` § *The seam* exist with those signatures, and 3.1 is red before `Copy` holds any present idea
- [ ] 2.2 `CopyDocument.currentVersion` is 4, and every hand-built form-1, form-2 and form-3 fixture in the carried tests still reads
- [ ] 2.3 `PresentIdeaStore.init(at:)` and `CopyDocument.read` refuse through the one `PresentIdeaStore.formed(from:)`

## 3. `restore`: a copy's present ideas

- [ ] 3.1 a copy holds every present idea the present-idea place holds, given or not, and none where nothing has been kept there — catches given ideas dropped, or the switch consulted
- [ ] 3.2 a copy is refused whole where the present ideas cannot be read, naming them only where the other five stores read — catches the present ideas named before the happenings
- [ ] 3.3 a change kept where the present ideas cannot be read is kept, and the stop names the present ideas — catches `StopRecord` reading `presentIdeas` back as the record
- [ ] 3.4 a copy place given no present-idea place copies the present ideas kept beside its record place — catches a copy place defaulting to the real file

## 4. `restore`: reading a copy

- [ ] 4.1 a copy made before copies held present ideas is read as holding none, and restoring it leaves the present-idea place holding none — catches a form-3 copy read as damaged
- [ ] 4.2 a copy holding present ideas the app never writes is refused as a damaged copy, and one whose present ideas are of a later form as a copy from a later version — catches the present ideas left out of the envelope pre-check

## 5. `restore`: a restore

- [ ] 5.1 a commitments screen asked to restore says how many present ideas the copy and the phone hold, given and not given together — catches given ideas left out of the count
- [ ] 5.2 a commitments screen asked to restore where the present-idea place cannot be read says the present ideas cannot be read in place of their count
- [ ] 5.3 a restore confirmed makes the present-idea place hold the copy's present ideas, and the ideas there are gone — catches a merge
- [ ] 5.4 a restore refused where the present-idea place cannot be written leaves the six places as they were — catches a rollback of five
- [ ] 5.5 a restore stopped before it was whole is undone at the present-idea place when the places are next opened — catches a day screen undoing five places

## 6. `restore`: a present-idea change's copy

- [ ] 6.1 an idea added, changed, marked given, unmarked and deleted through a Birthdays screen each write a copy at the copy place
- [ ] 6.2 a present-idea change refused, or a mark already so, writes no copy at the copy place — catches `keptAChange()` after a store answering `false`
- [ ] 6.3 an idea added where the copy place cannot be written is kept and is not refused

## 7. `restore`: the take-out

- [ ] 7.1 a take-out hands out the file at the present-idea place byte-for-byte under the name it lies under
- [ ] 7.2 a commitments screen offers a take-out over present ideas that cannot be read, naming them after the happenings — catches `Copy.Store.allCases` in the undo guard
- [ ] 7.3 a commitments screen asked for a take-out answers the present ideas' file after the happenings' and before a save in progress
- [ ] 7.4 a take-out refused over the present-idea place names the present ideas and hands out none of the others

## 8. `restore`: the Birthdays screen's restore line

- [ ] 8.1 a Birthdays screen that cannot read its present ideas says a copy can be restored, and says nothing of it where they were written by a later version — catches the line gated on the switch

## 9. The carried scenarios

- [ ] 9.1 Every scenario the four MODIFIED `restore` requirements carry passes with its test unedited, and so does every other test in the suite, but the `laterFormBytes` helpers in `CopyTests.swift` and `TakeOutTests.swift`, which each gain the `case .presentIdeas:` arm the enum now needs

## 10. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 10.1 `SettingsView.swift` and `BirthdaysView.swift` say the lines `design.md` § *The shell's words* gives, words verbatim, each in the slot `grill.md` § *Layout* names
- [ ] 10.2 `ContentView.swift` hands its one copy place to the Birthdays screen and changes nothing else; `PresentIdeasView.swift` is unchanged; the app target builds for the simulator

## 11. The records

- [ ] 11.1 Confirm `CONTEXT.md` § *Present-idea place*, *Present-idea store*, *Copy*, *Restore* and *Take-out* still describe what shipped; a sentence that turns out wrong is a stop and a G4 question, never an edit
- [ ] 11.2 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## The walk

- [ ] W.1 Settings with `present-ideas.json` replaced by a run of bytes, after *Make a copy* is tapped — *Your present ideas could not be read.* under it, and *Take out the files* with *Your present ideas could not be read.* as its caption.
- [ ] W.2 Settings' restore sheet for a copy made while `present-ideas.json` held two ideas, opened after a third was planted — *The copy* ends *2 present idea(s)*, *Your phone* ends *3 present idea(s)*.
- [ ] W.3 phone: add an idea on a person's page, make a copy, delete the idea, restore that copy — the idea is back on the Birthdays screen, its count on its line.
- [ ] W.4 **The handover** — W.1 and W.2, taken on the final build, are posted to the PR with `pnpm run walk -- --post-only <pr>`, never `gh pr comment --attach`, before hand-back, and this box is ticked on that comment's URL:

## 12. Gates and the archive handover

- [ ] 12.1 `openspec validate carry-present-ideas-in-a-copy --strict` exits 0, and `pnpm run checks` is clean
- [ ] 12.2 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` passing, its count read off the run
- [ ] 12.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 12.4 **The implementer ticks this box in its last commit before the archive**, on the evidence that every other box but W.3 is ticked and the walk comment's URL is in W.4; W.3 is the conductor's, ticked on the owner's G7 reply. The janitor then runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, and checks afterwards that `openspec/specs/restore/spec.md` gained eight requirements, renamed one, and holds its four MODIFIED ones whole, and that no other spec file moved. **Any drift is a stop and a report, never a hand-edit.**
