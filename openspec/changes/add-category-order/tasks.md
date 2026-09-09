## 1. Before a line is written

- [x] 1.1 Confirm the starting point, and report rather than work around a different one (rule 5).
  From `src/DayByDayKit`, `swift test` reports **885 tests passing** — measured 2026-09-08 twice: once
  with this branch cut from `main` at `264c5a7`, and again after it was rebased onto `fe540d5`, which
  is where it sits at G4 and which carries the day-swipe chore (#177) and B-041 (#178). The chore
  touched the shell and not the kit, so the count did not move. From the repo root,
  `pnpm run check:scenarios` reports `scenario coverage — 93/121 scenario(s) covered` for this change
  and names *"a group moved through a roster store is read back in the order it was moved into"* as
  next. Those 93 are the scenarios this delta carries verbatim from the current specs, and
  **no test behind any of them may be renamed, moved, or have an assertion changed by a box below.**

  **Unlike `add-commitment-category` (#147), there is no exception to that.** Every seam member this
  change adds is a new overload — `Roster.move(group:toOffset:)`, `RosterStore.move(group:toOffset:)`,
  `CommitmentsScreen.move(group:toOffset:)` — and **no existing signature changes**, so not one
  carried test needs so much as an added argument. A carried test that has to be edited at all is a
  sign the design was not followed: stop and report it.

- [x] 1.2 Confirm the two facts the delta rests on, before writing any test, and stop and report if
  either is false (`design.md` § *Context*, § *The seam*):

  **The category is already on the roster's entry and the form on disk already carries it.**
  `grep -n 'category' src/DayByDayKit/Sources/DayByDayKit/Roster.swift` finds `category: String?` on
  `Entry`, and `grep -n 'categoryIntroducedInVersion\|currentVersion'
  src/DayByDayKit/Sources/DayByDayKit/RosterDocument.swift` finds form 4 already carrying it. **No
  box below touches `RosterDocument`, `CommitmentCoding` or the form on disk**, and a box that finds
  it needs to is the design being wrong rather than a file to edit: a group move rearranges entries
  that already carry everything it needs.

  **`CommitmentsScreen.categoriesInUse` is exactly the list the offset is counted over.**
  `grep -n 'categoriesInUse' src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift` finds
  `keptGroups.compactMap(\.category)` — the categories of the groups the screen keeps, in the order
  it draws them, already public. The screen's group move is guarded on that list and converts no
  offset; if it needs its own count, § *The offset is the screen's own count and the roster's alike*
  is wrong and that is a stop.

## 2. `commitment` — a roster moves a group among the groups it is keeping

Rule 3 throughout: one scenario, one acceptance test named identically to it, one red-green cycle.
Every box in this section is driven at `Roster.move(group:toOffset:)` and lands in
`src/DayByDayKit/Tests/DayByDayKitTests/RosterTests.swift`.

- [x] 2.1 *moving a group to the front draws it before every other group under a category* — the
  first cycle, and the one that introduces `Roster.move(group category: String?, toOffset offset: Int)
  -> Bool`.
- [x] 2.2 *moving a group to the end draws it after every other group under a category and before the
  commitments under none* — the `offset == count` branch.
- [x] 2.3 *an offset for a group is counted over the groups the roster is keeping that are under a
  category* — the count excludes the group under none, and no offset lands after it.
- [x] 2.4 *a group's stopped and removed commitments travel with it* — the block is every entry under
  the category, whatever its state, and the dated group read is what proves it. This is the scenario
  ADR-1043 exists for.
- [x] 2.5 *a group's commitments are gathered into one block, keeping their order against each other*
  — a scattered group comes back contiguous, and what lay between it lands on one side.
- [x] 2.6 *two offsets leave a group where it is, and both are accepted* — nothing is taken out of the
  sequence, so a scattered group asked for its own place stays scattered. Check this **before**
  computing any destination, exactly as `Roster.move(_:toOffset:under:)` does: computing one from a
  post-removal position is what would gather it.
- [x] 2.7 *moving the group of the commitments under no category is refused* — including a category
  of nothing but blank space, which normalises to none through the same `Blank` test (ADR-1039).
- [x] 2.8 *moving a group no commitment the roster is keeping is under is refused* — one nothing has
  ever been under, and one only a stopped or removed commitment is under.
- [x] 2.9 *an offset below zero and one above the number of groups under a category are both refused
  for a group* — not clamped.
- [x] 2.10 *moving a group moves no day and changes no commitment* — no category is put under
  anything, no kept-until day moves, no state changes.
- [x] 2.11 *moving a group on a copy of a roster leaves the roster it was copied from unchanged*.
- [x] 2.12 *a roster keeping one group under a category accepts both the offsets it has*.

## 3. `commitment` — a roster store keeps a group move at its place

Driven at `RosterStore.move(group:toOffset:)`, in
`src/DayByDayKit/Tests/DayByDayKitTests/RosterStoreTests.swift`. The shape is
`move(_:toOffset:under:)`'s: write before reporting, report what the roster reports, write nothing
when the roster came back unchanged.

- [x] 3.1 *a group moved through a roster store is read back in the order it was moved into*.
- [x] 3.2 *a group move a roster store refuses keeps nothing at its place* — both of the roster's
  refusals pass through as `false`, without an error and without a write.
- [x] 3.3 *a group move that leaves a group where it is keeps nothing at a roster store's place* —
  `true`, and the file byte-for-byte what it was.

## 4. `commitment` — a commitments screen moves a group among the groups it draws

Driven at `CommitmentsScreen.move(group:toOffset:)`, in
`src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenTests.swift`.

- [x] 4.1 *a group moved through a commitments screen is drawn where it was moved to, and is kept
  there* — the first cycle, introducing the member and its `categoriesInUse` guards.
- [x] 4.2 *an offset a commitments screen is given for a group is counted over the groups it draws
  that are under a category* — the offset goes to the roster untouched; the screen converts nothing.
- [x] 4.3 *a group moved through a commitments screen carries the commitments it has stopped with it*
  — the stopped list is drawn in the roster's new order afterwards, and a stopped member anchors
  where the block is placed.
- [x] 4.4 *a commitments screen asked to move the group of the commitments under no category does
  nothing and says nothing*.
- [x] 4.5 *a commitments screen asked to move a group it draws none of does nothing and says nothing*.
- [x] 4.6 *a commitments screen given an offset the groups it draws do not have does nothing and says
  nothing*.
- [x] 4.7 *a group move a commitments screen could not keep leaves both its lists as they were* — the
  cycle that adds `RefusedChange.movingGroup(String, Refusal)`, naming the category.
- [x] 4.8 *a group move that leaves a group where it is drawn changes nothing and refuses nothing* —
  compared against the roster itself and not against the boolean the store answers, exactly as
  `move` and `put` already do.
- [x] 4.9 *a commitments screen shown again draws its groups in the order they were moved into*.

## 5. `commitment` — the six requirements this change makes newly true

Nothing here adds a member. Each box is a carried requirement whose prose this delta corrected, and
each is verified by the new scenario named in it plus the carried tests staying untouched.

- [x] 5.1 *a commitments screen holds a refused group move against the category it was asked to move*
  — the seventh kind, held and named.
- [x] 5.2 *a commitments screen holds nothing against a group move that asks for no change at all* —
  all three no-change asks in one test: a group it draws none of, the group under none, and an offset
  that is not there.
- [x] 5.3 *what a commitments screen holds about a refused change ends when a group move is kept*.
- [x] 5.4 *what a commitments screen holds about a refused change stands when a group move leaves a
  group where it is*.
- [x] 5.5 Read the four requirements this delta corrected only in prose — *A roster holds the
  commitments a person keeps*, *A roster store keeps a roster at a place*, *A commitments screen
  holds the change it refused* and *What a commitments screen holds about a refused change lasts* —
  against the code as it then stands, and confirm each corrected sentence is true of it: moving is
  the only thing that changes the order and it takes a commitment or a group; the store keeps a group
  move and passes its two refusals through; there are seven changes a person can ask for and a
  refused group move names a category. **No new test is owed by this box** — the four are carried
  requirements whose scenarios are already green — and any sentence that is *not* true of the code is
  a stop, not a sentence to edit (a delta edited after G4 costs a second approval, rule 1).

## 6. The app shell

ADR-1019's 2026-09-04 exception, and `design.md` § *The shell rides this Story*. **No requirement is
attached to any box here**, and none may be added by one: a box that finds itself needing a scenario
is a stop.

- [x] 6.1 Draw `Move up` and `Move down` on each categorised section of the kept list with
  `sectionActions(content:)`, in Edit mode only, calling `screen.move(group:toOffset:)` with the
  section's own category and an offset computed from its index in `screen.categoriesInUse` — up is
  `index - 1`, down is `index + 2`. Draw an action only where its offset is one the screen has, so no
  tap can reach a refusal. The shell counts no rows and computes nothing else. Verify by building:
  `xcodebuild -project src/DayByDay/DayByDay.xcodeproj -scheme DayByDay -destination
  'platform=iOS Simulator,name=iPhone 16' build` succeeds.
- [x] 6.2 Walk it on the phone with `pnpm run phone`: move a group up, down, to the top and to the
  bottom; confirm the group under no category draws no actions and stays last; confirm a group's
  stopped commitments follow it by opening a past day. **If the action rows read badly in the hand,
  try a control on the heading instead** — `grill.md` § *Settled* 5 chose the walk over the gamble,
  and whichever wins, **no requirement moves and no second G4 is owed**. Record what was walked and
  which of the two shipped in the PR.
- [x] 6.3 In the same pass, look at the ~1s reorder settle lag `docs/open-questions.md` parks on this
  Story. The un-excluded candidate is `CommitmentsView.swift:79`'s `id: \.offset`; this change moves
  whole blocks through that line. If keying the kept list's rows on the commitment's own value fixes
  it, that is a shell fix on this branch and the open question closes with a note saying what it was.
  **If it does not, leave the entry standing and say so** — no fix is owed by this Story, and none may
  be invented to close a box.

## 7. The ADRs and `CONTEXT.md`

`docs/adr/**` and `CONTEXT.md` are `spec-author`'s to write, so all three land in the diff G4 signs
and these boxes **confirm rather than write**.

- [x] 7.1 Confirm `docs/adr/1043-a-group-move-carries-the-whole-group.md` is present, is in
  `docs/adr/README.md`'s table in numeric order, and says what `design.md` § *A group move is a block
  move* says.
- [x] 7.2 Confirm ADR-1037 is amended in place and stamped — a move is still the only thing that
  changes a roster's order, and it now takes a group as well as a commitment — and that **ADR-1038 is
  untouched**. A diff touching 1038 is a stop: its rule surviving the block move intact is why the
  block move was chosen.
- [x] 7.3 Confirm `CONTEXT.md` § *Move* and § *Commitments screen* carry this Story's amendments, and
  that § *Move*'s 2026-09-08 clause saying a group move "is a Story of its own" has been rewritten
  rather than left standing beside its own answer.

## 8. Before the review, and what the janitor does at the archive

- [x] 8.1 From `src/DayByDayKit`, `swift test` — every test green, and the count is **913**: the 885
  measured at § 1.1 plus the 28 scenarios § 2 to § 5 add. From the repo root, `pnpm run verify` green
  and `pnpm run checks` reporting `121/121 scenario(s) covered`. **A number that comes back different
  is a stop** (rule 5), not a number to write down.
- [x] 8.2 `openspec validate add-category-order --strict` exits 0, and `openspec validate --all
  --strict --no-interactive` exits 0.
- [x] 8.3 Rebase onto current `main` and push with `--force-with-lease`. A conflict inside
  `openspec/changes/add-category-order/` or anywhere under `openspec/specs/` is a **stop**, not a
  merge to resolve (rule 5) — it means another Story landed on `commitment` while this one was being
  written, and the six MODIFIED requirements were extracted verbatim from the `commitment` spec as it
  stood at `fe540d5`, the commit this branch was rebased onto at G4. **A clean rebase that then fails
  § 8.2 is the same stop**, and it needs a further G4 rather than a quiet refresh of the delta.
- [x] 8.4 Hand back for the review (**G7**). The conductor spawns `reviewer`; do not run
  `mattpocock-skills:code-review` on your own diff and do not act on findings until they come back
  through the conductor. This box is ticked when the hand-back is written.
- [x] 8.5 Write the archive handover for the janitor, into the PR or the handover message, saying what
  it must check **after** `/opsx:archive` has run. **The `implementer` ticks this box, in its last
  commit before the archive, on the instruction having been written** — the checking itself is the
  janitor's step and has no box of its own, deliberately: `add-roster-store` (#103) shipped a box that
  could only be ticked after the archive and stalled the Story between review and merge, and
  `add-number-entry` (#139) shipped this box in the right shape and stalled anyway because nothing in
  it said whose tick it was.

  **Archive handover, for the janitor.** This delta's `specs/commitment/spec.md` carries six
  `## MODIFIED Requirements` — *A roster holds the commitments a person keeps, in the order they were
  taken on*, *A roster store keeps a roster at a place, across the app being closed and opened again*,
  *A commitments screen holds the change it refused and why, one at a time*, *What a commitments
  screen holds about a refused change lasts until the app is shown again or a change is kept*, *A
  roster moves a commitment among the ones it keeps* and *A commitments screen moves a commitment
  among the ones it keeps* — and two `## ADDED Requirements`, *A roster moves a group among the groups
  it is keeping* and *A commitments screen moves a group among the groups it draws*. **None of the six
  MODIFIED requirements is renamed anywhere in this delta**: only prose inside each changes, no
  scenario is dropped or retitled, and the new scenarios are additions at the end of each
  requirement's own list. **No other capability is touched — `day-screen` carries no delta at all.**

  So after `/opsx:archive` runs, read the recomposed `openspec/specs/commitment/spec.md` and confirm
  that each of those six still sits at the same place in requirement order it held before this
  archive, that the two ADDED requirements landed in `commitment` and nowhere else, that
  `openspec/specs/day-screen/spec.md` is unchanged by this archive, and that `openspec validate
  --archived` exits 0. Any drift — a requirement moved, dropped, or reworded beyond this delta's own
  MODIFIED text — is **a stop and a report, never a hand-edit** (rule 2): `openspec/specs/` is written
  by `/opsx:archive` and by nothing else, and the archived folder is denied to every editor.
