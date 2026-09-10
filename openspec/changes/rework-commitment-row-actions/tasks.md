## 1. Before a line is written

- [x] 1.1 Confirm the starting point, and report rather than work around a different one (rule 5).
  From `src/DayByDayKit`, `swift test` reports **1015 tests passing** — measured 2026-09-10 on this
  branch, whose commits are the propose commit and two documentation corrections to it, sitting on
  `84dfa5c` — `origin/main` as of 2026-09-10. Re-measure it rather than trusting that sentence; a
  different number is a stop. From the repo root, `pnpm run check:scenarios` reports
  **`86/88 scenario(s) covered`** before a line is written — measured, not predicted — and names `a
  category set through a commitments screen's change is kept at the roster place` as next.

  **That 86 is not progress and it is not a safety net.** Seventy-eight of this delta's eighty-eight
  scenarios are restated unchanged by `MODIFIED` and already have passing tests, and **eight more of
  them keep their titles while changing underneath**, so the check counts those eight as covered
  before anything has been rewritten and will go on counting them if one is forgotten. Only the two
  genuinely new scenarios of § 2 show as missing. § 3 names all eight by hand, and § 4.2 is what
  turns a forgotten one into a compile error.

- [x] 1.2 Confirm the four facts the shape rests on, before writing any test, and stop and report if
  any is false (`design.md` § *Context*): `CommitmentsScreen.put(_:under:)` is still declared at
  `CommitmentsScreen.swift:567` and `RefusedChange.categorising` at `:143`; `change(_:toName:on:
  keptFrom:under:)` at `:253` still passes its `category` through to `rosterStore.change(_:to:
  under:)` at `:341` untrimmed and unfolded; `Roster.change(_:to:under:)` still normalises a
  blank-space category to none (`Roster.swift:395`); and `RosterDocument.swift:59` still calls
  `Roster.put(_:under:)` when a roster is read back off disk. If that last one has gone, stop: the
  roster's own `put` would then be as orphaned as the screen's, and `design.md` § *The kit below the
  seam keeps its `put`* is written on it being there.

- [x] 1.3 Re-read this box before § 2 and again before § 5. `commitment` is the busiest capability in
  the repo and this delta touches seven of its requirements. If another Story delta-ing it merges to
  `main` while this branch is open, a clean rebase can still leave this delta describing a spec that
  has moved. Check with `git fetch origin && git log --oneline origin/main --
  openspec/specs/commitment/spec.md`. A change there is a **stop** (rule 5), not a delta to refresh
  quietly: refreshing it needs a further G4. `add-kind-to-commitments-screen` (#142) deltas this
  capability and is deliberately serialised behind this Story — it should not appear.

## 2. The two scenarios that are new

Two red-green cycles, in `src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenTests.swift`, one
each, taking the scenario verbatim as the `@Test` display name (rule 3). Both belong to *A
commitments screen changes a commitment on either of its lists*, so put them beside that
requirement's existing tests rather than beside the category ones.

**Expect both to go green with no change to `src/`.** `change(_:toName:on:keptFrom:under:)` already
writes a category and already normalises a blank one through the roster; these two scenarios exist
because nothing at the screen asserted it, not because anything is missing. A red that does not
appear is the honest outcome here — **do not invent a production change to manufacture one**, and do
not skip writing the test because it would pass. If either goes red, that is a finding: report what
it says before changing anything.

- [x] 2.1 `a category set through a commitments screen's change is kept at the roster place` — the
  category reaches the roster place, and a screen opened afterwards at that place draws the same two
  groups.
- [x] 2.2 `a category taken off through a commitments screen's change draws its commitment among the ones under none`
  — a category of three spaces takes one off. If this goes red, the normalisation in 1.2 has moved.

## 3. The eight scenarios that keep their titles and change underneath

Each of these has a passing test today whose body calls `screen.put`. **Rewrite exactly one test per
box** so its body matches the scenario in
`openspec/changes/rework-commitment-row-actions/specs/commitment/spec.md` verbatim, driving
`screen.change(_:toName:on:keptFrom:under:)` with the name, rhythm and day the commitment already
has. **Do not rename any of them** — the title is the contract and it is unchanged; and do not
change what a box asserts beyond swapping the act, because every `THEN` in these eight is expected
to hold exactly as it does now.

The line numbers are where each sits on this branch today; find it by its `@Test` title rather than
by the number if the file has moved under you.

- [x] 3.1 `a category no longer under any commitment kept is no longer offered` — `:3199`.
- [x] 3.2 `a commitments screen does not fold the case of a category it is given` — `:3223`. Two
  calls to swap, "Supplements" and "supplements", and the point of the test is that they stay two.
- [x] 3.3 `a commitments screen holds a refused category change against the commitment it was asked about`
  — `:3381`. The refusal is now held as `.changing(gym, .notKept)`, **not** `.categorising`.
- [x] 3.4 `a commitments screen holds nothing against a category change that asks for no change at all`
  — `:3407`. Rebuilt around a change naming the category the commitment is **already** under, which
  is what "no change at all" means once the act is a change.
- [x] 3.5 `a commitment given a category is drawn in that group and returns when the category is taken off`
  — `:2895`, under *A commitments screen lists the commitments its roster keeps*. Two calls: one
  setting "Supplements", one clearing it.
- [x] 3.6 `a commitments screen that cannot read its roster does nothing when it is asked to put a commitment under a category`
  — `:3437`. **The title stays exactly as it is**, and `design.md` § *Every scenario that reaches a
  category through the withdrawn act* says why: it names the person's ask, the body names the act,
  and renaming the requirement to drop it is the worse trade. Do not "fix" it.
- [x] 3.7 `what a commitments screen holds about a refused change ends when a category change is kept`
  — `:3736`.
- [x] 3.8 `what a commitments screen holds about a refused change stands when a category change puts a commitment under the category it is already under`
  — `:3763`. The change names the category already there, so it reaches nothing and ends no standing
  refusal.

- [x] 3.9 `swift test` from `src/DayByDayKit` — still **1015** passing, because nothing has been
  deleted or added since § 2. Then, from the repo root:

  ```bash
  grep -c 'screen\.put(' src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenTests.swift
  ```

  It reports **15** on this branch today and must report **5** here — the five calls inside the four
  tests § 4.1 deletes, and nowhere else. Any other number means a box in § 3 was missed or one went
  further than swapping the act.

## 4. Take `put` off the seam

- [x] 4.1 Delete these four tests, whole. Each names an act that no longer exists, and each is listed
  in the delta's `## REMOVED Requirements` block with where its guarantee went:
  - `a commitment is put under a category through a commitments screen and kept at the roster place`
    (`:2992`) — re-landed as 2.1.
  - `a category taken off through a commitments screen draws its commitment among the ones under none`
    (`:3029`) — re-landed as 2.2.
  - `a commitments screen asked to put a commitment it does not keep under a category does nothing and says nothing`
    (`:3054`) — answered by `a commitments screen asked to change a commitment on neither of its
    lists does nothing and says nothing`, which already passes.
  - `a category change a commitments screen could not keep leaves both its lists as they were`
    (`:3090`) — answered by `a change a commitments screen could not keep leaves both places as they
    were` and by 3.3.

- [x] 4.2 Remove `put(_:under:)` (`CommitmentsScreen.swift:567`) and the `categorising` case from
  `RefusedChange` (`:143`) from the seam, and fix the two doc comments that count what is left: the
  `RefusedChange` comment at `:134`–`:136`, whose "the four changes … rather than in one place for
  all five" was already one short before this Story and is two short after it, and the `changing`
  case's own "The eighth kind" at `:144`, which by the delta is no longer a position anything
  states. **The compiler is the proof this Story is finished**: nothing outside
  the four tests § 4.1 deleted may still call `screen.put`, so a build error here means a box in § 3
  was skipped. Fix the box, never the call site.
  `Roster.put`, `RosterStore.put` and `RosterDocument`'s use of the first are **not** touched —
  `design.md` § *The kit below the seam keeps its `put`*.

- [x] 4.3 `swift test` from `src/DayByDayKit` — **1013** passing: 1015, less the four of § 4.1, plus
  the two of § 2. A different number is a stop, not a number to write down. From the repo root,
  `pnpm run check:scenarios` reports `88/88`.

## 5. The shell — no requirement, walked on the phone

None of this is specified (`design.md` § *The shell rides this Story*), all of it is in
`src/DayByDay/DayByDay/CommitmentsView.swift`, and none of it may change anything behind the seam. A
box here that seems to need a kit change is a stop.

- [x] 5.1 Take out the category sheet — the `categorising` and `categoryTyped` state (`:95`,
  `:96`), the `.sheet` that draws it (`:364`–`:405`, the third of the three `.sheet` modifiers, the
  one whose binding reads `categorising != nil`), and the `if case .categorising` refusal line
  (`:234`). The `screen.categoriesInUse` reads at `:535` and `:537`, inside `CommitmentSheet`, stay:
  they are what the `ADDED` requirement is about. The two at `:205` and in the comments above it are
  the group-move arithmetic and stay too.
- [x] 5.2 Take the row tap off **both** lists — `.contentShape(Rectangle())` and `.onTapGesture`
  (`:143`–`:146` on the kept list, `:250`–`:253` on the stopped one). After this the swipe is the
  only way to the change sheet, which is the owner's decision against the recommendation
  (`grill.md` § *Settled* 4).
- [x] 5.3 Give both lists a leading edge carrying one action: *Edit*, `Image(systemName: "pencil")`,
  `.tint(.accentColor)`, opening `sheetTarget = .changing(commitment)`. One action, so a full swipe
  opens the sheet.
- [x] 5.4 Redraw the trailing edge on both lists as icons with tints, keeping today's declaration
  order: kept list *Stop* (`stop.circle`, `.tint(.orange)`) then *Remove* (`trash`, `role:
  .destructive`, `.tint(.red)`); stopped list *Resume* (`play.circle`, `.tint(.green)`) then
  *Remove*. Every button keeps an `.accessibilityLabel` carrying the word it used to draw. **Whether
  the first-declared button is the outermost one, and so the one a full swipe performs, is a fact
  about `swipeActions` rather than about this document** — the expectation is that the order does not
  move and a full swipe already stops rather than removes. Confirm it in 5.6 and report a difference
  rather than reordering around it.
- [x] 5.5 Replace `EditButton()` in the toolbar (`:294`) with a toggle drawing
  `Image(systemName: "arrow.up.arrow.down")`, shown as selected while editing, driving the same
  `editMode` binding so the drag handles and the `.sectionActions` *Move up* / *Move down* buttons
  both keep working unchanged. Its `.accessibilityLabel` carries *Reorder* and its state. The word
  *Edit* leaves the screen.
- [ ] 5.6 `pnpm run phone`, then walk it: on a kept row swipe right and get the pencil, swipe left
  and get stop-then-trash, full-swipe left and confirm it **stops** rather than removes; on a stopped
  row the same with play; tap a row and confirm nothing happens; enter reorder mode and confirm the
  drag handles and both group buttons are there and the icon reads as selected; set a category on the
  change sheet and confirm *Already in use* offers what it should. Record what you saw in this box.
  A simulator is not this box (see #186's G7): it is the phone.

## 6. The documentation that already landed

**All of § 6 was written into the propose commit and is part of what G4 signed.** These boxes are
not work to do; they are a re-read after § 5, because § 5 is where a phone walk can make a written
sentence false. Tick each when you have confirmed it still says the truth, and **report a difference
rather than editing quietly** — a change to either file after G4 is a finding the reviewer should
see, not a tidy-up (rule 5).

- [x] 6.1 `CONTEXT.md` § *Move* carries **Corrected 2026-09-09**, withdrawing the clause that named
  the row's *Category* action as the way to refile across groups and putting the change sheet's
  category field in its place. Confirm it still matches what § 5 built.
- [x] 6.2 `CONTEXT.md` § *Commitments screen* carries **Amended 2026-09-09**, withdrawing the same
  clause a second time and withdrawing the two ordinals that entry states — the group move as the
  seventh kind of refused change, a change as the eighth. Confirm the seven kinds it names are the
  seven the archived spec ends up with.
- [x] 6.3 `docs/adr/1042-the-horizontal-swipe-belongs-to-the-day.md` carries an
  `- Amended: 2026-09-09 — …` line under `Deciders` and reads as one coherent decision (ADR-1020):
  depiction is decided per screen, the commitments screen's row swipe is undepicted, the day
  screen's chevrons stay, and the frequency argument is why. **If the phone walk in 5.6 changed any
  of that — a hint added, an edge left unclaimed, the tap put back — this ADR is wrong and that is a
  stop**, because it is the one decision in this Story that closes a door for later requirements.
  No second ADR is written and this one is not superseded (`grill.md` § *Settled* 12).
- [x] 6.4 No new term was landed and none should be. If § 5 turned one up, that is a finding to
  report, not a term to add (`grill.md` § *Terms landed in CONTEXT.md*).
- [x] 6.5 `docs/backlog.md` is **not** touched, deliberately: B-042 is delivered by this Story and
  B-041's *Principle* line is weakened by it, but that file lives on `chore/backlog` and editing it
  from a Story branch invites the rebase conflict rule 5 calls a stop. Both are the next grooming
  pass's (`grill.md` § *Settled* 13, 14). Tick this by confirming `git status` shows
  `docs/backlog.md` unchanged.

## 7. Before the review, and what the janitor does at the archive

- [x] 7.1 `swift test` from `src/DayByDayKit` — **1013** green, the number § 4.3 landed on. From the
  repo root, `pnpm run verify` green and `pnpm run checks` reporting `88/88 scenario(s) covered`.
  `xcodebuild build` for the `DayByDay` scheme against an iPhone 17 simulator succeeds, because § 5
  touched the app target and nothing in `swift test` compiles it.
- [x] 7.2 `openspec validate rework-commitment-row-actions --strict` exits 0, and `openspec validate
  --all --strict --no-interactive` exits 0.
- [x] 7.3 Rebase onto current `main` and push with `--force-with-lease`. A conflict inside
  `openspec/changes/rework-commitment-row-actions/` or anywhere under `openspec/specs/` is a **stop**,
  not a merge to resolve (rule 5) — and so is a clean rebase that then fails 7.2, which is § 1.3's
  hazard arriving late.
- [x] 7.4 Hand back for the review (**G7**). The conductor spawns `reviewer`; do not run
  `mattpocock-skills:code-review` on your own diff and do not act on findings until they come back
  through the conductor. This box is ticked when the hand-back is written.
- [x] 7.5 Write the archive handover for the janitor, into the PR or the hand-back message. **The
  `implementer` ticks this box, in its last commit before the archive**, on the evidence that the
  instruction has been written — the checking itself is the janitor's step and has no box of its own,
  deliberately: a box whose tick depends on the archive having run cannot be reached afterwards,
  because `/opsx:archive` moves this folder under `openspec/changes/archive/` and every editor is
  denied there.

  **Archive handover, for the janitor.** This change carries **one delta file**,
  `specs/commitment/spec.md`, with three sections and no other capability touched. After
  `/opsx:archive` runs, read `openspec/specs/commitment/spec.md` and confirm all five of these:

  1. *A commitments screen puts a commitment under a category, and offers the categories in use* is
     **gone**, with all nine of its scenarios.
  2. *A commitments screen offers the categories in use* is **present**, with exactly five
     scenarios.
  3. The five modified requirements — *holds the change it refused and why, one at a time*, *moves a
     group among the groups it draws*, *changes a commitment on either of its lists*, *lists the
     commitments its roster keeps, in the order they were taken on*, and *What a commitments screen
     holds about a refused change lasts until the app is shown again or a change is kept* — hold 16,
     10, 21, 12 and 17 scenarios respectively, and **the word "seventh" and the word "eighth" appear
     nowhere in the file** alongside "kind of refused change".
  4. **No other requirement moved, was reworded, or lost or gained a scenario** — in particular *A
     roster puts a commitment under a category*, *A roster store keeps a roster at a place, across
     the app being closed and opened again* and *A commitments screen moves a commitment among the
     ones it keeps*, all three of which this delta deliberately leaves alone, the last one still
     calling its refusal the **fifth** kind, which stays true.
  5. `openspec validate --archived` exits 0, and nothing landed in `day-screen`, `record`,
     `schedule` or `cli-version`.

  Any drift is **a stop and a report, never a hand-edit** (rule 2): `openspec/specs/` is written by
  `/opsx:archive` and by nothing else, and the archived folder is denied to every editor.
