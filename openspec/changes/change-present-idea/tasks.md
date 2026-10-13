**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md` rule 5): a
rebase conflict in this folder or in `openspec/specs/`, a scenario that cannot be written as a test
without changing its title, a test that passes before the code it names is written, a carried test
that has to be edited beyond what 2.2 allows or turns red, or a Kit signature that has to differ from
`design.md` § *The seam*.

Rule 3 governs § 3: take the next unticked box, write the one test named for it — the scenario title
verbatim, which `pnpm run check:scenarios` checks — watch it fail, make it pass, then the next. Store
tests go in `PresentIdeaStoreTests.swift` and screen tests in `BirthdaysScreenTests.swift`, every
place a temporary one of the test's own.

## 1. Before a line is written

- [ ] 1.1 From the repo root, `pnpm run check:scenarios` reports exactly this change's fifteen new `present-idea` scenarios uncovered and no other

## 2. The seam

- [ ] 2.1 `PresentIdea.isGiven` and the `PresentIdeaStore` and `BirthdaysScreen` members exist with the signatures in `design.md` § *The seam*, and 3.1 is red before any of them does more than compile
- [ ] 2.2 The only edits to carried tests are the two later-form fixtures, in `PresentIdeaStoreTests` and `BirthdaysScreenTests`, moved from `"version":2` to `"version":3` with their expected version; every other carried test passes unedited
- [ ] 2.3 `BirthdaysScreen` writes its present-idea place only in `addIdea`, `changeIdea`, `markIdea` and `confirmDeletingIdea`, and touches no birthday tick

## 3. The fifteen new scenarios of `present-idea` — one test each

- [ ] 3.1 a present-idea store opened again holds each idea as changed, deleted and marked — catches a change that drops the mark, or a deletion that reorders
- [ ] 3.2 a change, deletion or mark the present-idea store cannot keep is refused and not held — catches the held list replaced before the write
- [ ] 3.3 a change, deletion or mark naming no idea, or a mark already so, is refused without an error and leaves the place untouched — catches an out-of-range offset that traps, or a no-op rewrite
- [ ] 3.4 a present-idea store in its first form is read as holding no idea given — catches form 1 refused once form 2 ships, or rewritten on opening
- [ ] 3.5 an idea changed through a Birthdays screen is kept where it stands, its mark with it — catches a change appended last, or a given idea un-given by a typo fix
- [ ] 3.6 a change whose text and link both say nothing, or whose link is not a web address, is refused and leaves the idea as it was — catches a blank change read as a delete
- [ ] 3.7 asking to delete an idea changes nothing until it is confirmed, and a cancel changes nothing — catches a delete on the ask
- [ ] 3.8 a confirmed deletion removes the idea where it stood, and its line's count drops at once — catches the count left until the next showing
- [ ] 3.9 an idea marked given through a Birthdays screen is kept given past its contact's birthday, and its line's count drops at once — catches a mark cleared at the birthday
- [ ] 3.10 taking back an idea's mark through a Birthdays screen returns it where it was added, and its line's count rises at once — catches the screen's offset handed straight to the store
- [ ] 3.11 a change, deletion or mark a Birthdays screen cannot keep is refused as not kept and not held — catches a failed mark drawn as given
- [ ] 3.12 a change or mark naming no idea of a line is refused as not kept and writes nothing — catches an unreadable place offering a mark
- [ ] 3.13 a Birthdays screen line counts only its contact's ideas not given — catches "0 ideas" for a person whose ideas are all given
- [ ] 3.14 a Birthdays screen gives back a line's ideas not given in the order added, then those given — catches given ideas sorted by when they were marked
- [ ] 3.15 what a Birthdays screen tells about a refused change, deletion or mark ends with the next one not refused — catches a page refusal that outlives the next swipe

## 4. The shell (ADR-1019: no rule the Kit does not state)

- [ ] 4.1 `PresentIdeasView` draws the swipes, the given row, the "Delete this idea?" alert, the "Change idea" sheet and the page's refusal exactly as `design.md` § *The shell* and § *What the shell draws* say, composing no string but those they name, and decides nothing
- [ ] 4.2 `git diff --stat origin/main... -- src/DayByDay/` lists `PresentIdeasView.swift` alone; the app target builds for the simulator, and `WalkthroughUITests` passes unedited

## 5. The records

- [ ] 5.1 `git diff --stat origin/main... -- openspec/specs/` reports nothing (rule 2)

## 6. The gates and the archive handover

- [ ] 6.1 `openspec validate change-present-idea --strict` exits 0, and `pnpm run checks` is clean
- [ ] 6.2 `pnpm run verify` green, and `swift test` in `src/DayByDayKit` passing with fifteen more tests than a run on `origin/main` reports, both read off runs
- [ ] 6.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`
- [ ] 6.4 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that every other box is ticked — W.1–W.4 by the conductor at G7 — and W.5 holds its commit. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff: `openspec/specs/present-idea/spec.md` gains five requirements and fifteen scenarios, five change in place, two of them renamed — which `/opsx:archive` places after the rest — and no other spec file moves. **Any other drift is a stop and a report, never a hand-edit** — the archive path is denied to every edit, so a box left unticked here cannot be reached afterwards.

## The walk

Every step needs birthdays on, so every step is the phone's (`docs/open-questions.md`: no simulator here gets calendar access). Birthdays are turned on in Settings, and one real contact is given three text ideas first.

- [ ] W.1 phone: an idea swiped right — "Change idea" opens with Idea and Link filled in; its link typed as "amazon.de/xyz" and saved — the row shows "https://amazon.de/xyz"; then both fields cleared and *Save* — "Type an idea or a link." under the fields, and back on the page the idea unchanged.
- [ ] W.2 phone: one of the three ideas swiped left and marked given — it moves to the foot of the card, struck through, the text grey; back on the Birthdays screen the line says "2 ideas"; the mark taken back — it returns to its place and the line says "3 ideas".
- [ ] W.3 phone: an idea not given swiped left and *Delete* tapped — "Delete this idea?" shows; *Cancel* keeps the idea; asked again, *Delete* removes it and the line's count drops by one.
- [ ] W.4 phone: an idea marked given, then the app closed from the switcher and opened again — the change from W.1, the mark and the order are all still there.
- [ ] W.5 **The handover** — no step is the simulator's, so `pnpm run walk` is not run and nothing is posted; before hand-back the implementer ticks this on naming, here, the commit the human installs with `cd <this worktree> && pnpm run phone` to walk W.1–W.4 at G7. The conductor ticks W.1–W.4 on the G7 approval.
