## 1. Before a line is written

- [x] 1.1 Confirm the starting point, and report rather than work around a different one (rule 5).
  From `src/DayByDayKit`, `swift test` reports **544 tests passing** — measured 2026-09-07 with this
  branch cut from `main` at `00a8f23`, which includes `add-roster-removal` (#145). From the repo
  root, `pnpm run check:scenarios` reports `scenario coverage — 112/147 scenario(s) covered` for this
  change and names `"a commitment moved and then stopped is taken up again in the place it was moved
  to"` as next. Those 112 are the scenarios this delta carries verbatim from the current spec; **no
  test behind any of them may be renamed, moved, or have an assertion changed by a box below.**

- [x] 1.2 Confirm the two facts the whole design rests on, before writing the first test, and stop
  and report if either is false (`design.md` § *Context*, § *Nothing on disk moves*):

  **The order is carried by array position and by nothing else.** `grep -n 'position\|index\|rank\|
  order' src/DayByDayKit/Sources/DayByDayKit/RosterDocument.swift` finds no stored ordering field,
  and `RosterDocument(_:)` writes `roster.entries.map { … }` in sequence while `formRoster()` replays
  in file order. **If any box below makes you reach for `RosterDocument.currentVersion`, stop**:
  that means the order was not carried by position after all, and it is an ADR-1031 conversation
  rather than a version bump.

  **`Array.move(fromOffsets:toOffset:)` counts its destination in the pre-move collection.** Measured
  2026-09-07: on `["A","B","C"]`, `0 → 3` gives `["B","C","A"]`, `0 → 2` gives `["B","A","C"]`,
  `1 → 1` and `1 → 2` both leave it untouched. `Roster.move` takes the same convention, so § 6's
  `.onMove` passes its `Int` through with no arithmetic. Re-run it if you doubt it; do not implement
  a conversion.

**The order below is not the order the delta reads in.** The roster comes first because everything
else asks it something, the store second because the screen writes through it, the screen third, and
`day-screen` last because it reads a roster that by then already moves.

## 2. `commitment` — a roster moves a commitment among the ones it keeps

Eleven scenarios from `specs/commitment/spec.md` § *A roster moves a commitment among the ones it
keeps*, all in `Tests/DayByDayKitTests/RosterTests.swift`. Each task takes exactly one
`#### Scenario:` and writes one acceptance test whose `@Test("...")` display name is that scenario
title **verbatim**, then makes it pass with the smallest change that does. Never write two before
the first is green (`AGENTS.md` rule 3). Verify each with `cd src/DayByDayKit && swift test`: the
named test green, every earlier test still green.

- [x] 2.1 `moving a commitment to the front puts it before every commitment the roster is keeping` —
  the first test in this change, and the one that adds
  `public mutating func move(_ commitment: Commitment, toOffset offset: Int) -> Bool` to `Roster`.
  `design.md` § *The seam* fixes the signature and the offset's meaning; `Roster.Entry` gains
  nothing.
- [x] 2.2 `moving a commitment to the end puts it after every commitment the roster is keeping` — the
  past-the-end offset, which is the one `Array.move` would get wrong under a final-position reading.
- [x] 2.3 `an offset is counted over the commitments the roster is keeping as they stand before the
  move` — the scenario that pins the convention itself. Both halves in one test.
- [x] 2.4 `a stopped commitment between the two places is passed rather than pushed` — where "only
  the moved commitment moves" stops being a slogan. A stopped "Gym" starts second and ends first
  without being named, and a removed one does the same.
- [x] 2.5 `an offset of nothing at all puts a commitment before the first one kept and not before a
  stopped one` — the one result a reader would not guess, and the reason the offset is counted over
  the kept commitments alone (`design.md` § *One order over three states*).
- [x] 2.6 `two offsets leave a commitment where it already is, and both are accepted` — settled
  answer 5 plus the arithmetic § 1.2 measured. Accepted, reported as moved, roster unchanged.
- [x] 2.7 `a roster keeping one commitment accepts both the offsets it has` — the degenerate list,
  where the two no-op offsets are the only two there are, and offset 2 is refused.
- [x] 2.8 `moving a commitment the roster is not keeping says it was not moved and leaves the roster
  as it was` — all three of not-held, stopped and removed, in one test as the scenario's clauses
  read.
- [x] 2.9 `an offset below zero and one above the number of commitments kept are both refused` —
  refused, never clamped. `design.md` § *An offset outside the range* is why.
- [x] 2.10 `moving a commitment moves no day and changes no commitment` — the scenario that proves a
  move is dated by nothing. If it needs `Roster` to consult anything, stop and report it.
- [x] 2.11 `moving a commitment on a copy of a roster leaves the roster it was copied from unchanged`
  — the value half, as `add`, `retire` and `remove` each have.

## 3. `commitment` — the roster's other rules meet a moved order

Three scenarios, all in `Tests/DayByDayKitTests/RosterTests.swift`, same one-scenario-one-test rule
as § 2. All three should be green the moment `move` exists, because each asserts that an existing
rule reads the roster's own order rather than a remembered one. **Write them anyway** — they are what
turns "the place it was taken on in" becoming "the place it has" from a wording change into a fact.

- [x] 3.1 `a commitment moved and then stopped is taken up again in the place it was moved to`
- [x] 3.2 `a roster answers about a date in the order it was moved into`
- [x] 3.3 `removing a commitment that has been moved keeps it in the place it was moved to`

## 4. `commitment` — a roster store keeps a move

Four scenarios in `Tests/DayByDayKitTests/RosterStoreTests.swift`. `design.md` § *A store writes
what a change made, and a no-op made nothing* fixes the one place this does not mirror `retire` and
`remove` exactly. **No form moves**: `RosterDocument` is not edited by any box here, and reaching for
it is the stop § 1.2 names.

- [x] 4.1 `a commitment moved through a roster store is read back in the place it was moved to` — adds
  `public func move(_ commitment: Commitment, toOffset offset: Int) throws -> Bool`, the same shape
  as `remove`, writing before it reports.
- [x] 4.2 `a move a roster store refuses is reported and nothing at its place changes`
- [x] 4.3 `a move that leaves a roster as it was keeps nothing at its place` — the one comparison the
  design calls for: report what the roster reports, write only when the roster changed. Asserted
  byte-for-byte on the file.
- [x] 4.4 `a move that cannot be kept is refused and the roster a store reports does not move`

## 5. `commitment` — a commitments screen moves a commitment

Seventeen scenarios in `Tests/DayByDayKitTests/CommitmentsScreenTests.swift`. `design.md` § *The
seam* fixes the surface: `move(_ commitment: Commitment, toOffset offset: Int) -> Refusal?`, the
same shape as `keepAgain`, and `RefusedChange` gains a fifth case, `moving(Commitment, Refusal)`.

- [x] 5.1 `a commitment moved through a commitments screen is where it was dropped, and is kept there`
  — the first screen test and the one that adds `move`.
- [x] 5.2 `an offset a commitments screen is given is counted over what it keeps before the move`
- [x] 5.3 `a commitments screen asked to move a commitment it has stopped does nothing and says
  nothing` — the guard is `kept.contains(commitment)` alone, not `kept || stopped` as `askToRemove`
  has it. Getting this wrong is the likeliest defect in the change.
- [x] 5.4 `a commitments screen asked to move a commitment on neither of its lists does nothing and
  says nothing`
- [x] 5.5 `a commitments screen given an offset the list it keeps does not have does nothing and says
  nothing` — both ends, and neither is a refusal. `design.md` § *An offset outside the range* says
  why the screen answers this differently from the roster.
- [ ] 5.6 `a move that drops a commitment where it already is changes nothing and refuses nothing` —
  and writes nothing, asserted on the file's bytes.
- [ ] 5.7 `a move a commitments screen could not keep leaves both its lists as they were`
- [ ] 5.8 `a commitments screen shown again lists what it keeps in the order it was moved into`
- [ ] 5.9 `a commitment moved and then stopped through a commitments screen keeps the place it was
  moved to`
- [x] 5.10 `what a commitments screen has stopped is in the order its roster holds them` — the stopped
  list is computed from `roster.entries`, so this is green off § 2 alone; it is the test that says
  the second list reads the roster's order and not a taken-on order it remembers.
- [x] 5.11 `moving a commitment leaves a stop awaiting confirmation exactly as it was` — a move takes
  neither confirmation slot. Do not touch `awaitingConfirmation` or `awaitingRemoval` in `move`.
- [x] 5.12 `a commitments screen that cannot read its roster does nothing when it is asked to move a
  commitment`
- [x] 5.13 `a commitments screen holds a refused move against the commitment it was asked to move` —
  the fifth `RefusedChange` case.
- [x] 5.14 `a commitments screen holds nothing against a move that asks for no change at all`
- [x] 5.15 `what a commitments screen holds about a refused change ends when a move is kept`
- [x] 5.16 `what a commitments screen holds about a refused change stands when a move drops a
  commitment where it already is` — settled answer 13, and the one that decides where `refusedChange
  = nil` may be written in `move`. It may only be written where the store actually kept something.

## 6. `day-screen` — the order a day screen inherits

One scenario from `specs/day-screen/spec.md`, in `Tests/DayByDayKitTests/DayScreenTests.swift`.

- [ ] 6.1 `a day screen draws its rows in the order its roster was moved into` — **this should pass
  without a line changing in `DayScreen.swift` or `DayView.swift`; that is the claim, and this is the
  test that turns it into a fact.** If either needs a change, **stop and report it**: it would mean
  the day screen was reordering the roster's answer after all, which `day-screen/spec.md:1642`
  already forbids, and that is a defect rather than this Story's work.

## 7. The app shell

Under ADR-1019's 2026-09-04 amendment, whose three conditions `design.md` § *The shell rides this
Story* checks off one by one. Every decision is behind the seam; the shell converts nothing, refuses
nothing and orders nothing. Only `src/DayByDay/DayByDay/CommitmentsView.swift` changes.

- [ ] 7.1 Add `.onMove(perform:)` to the **kept** `ForEach` only, and the `EditButton` in the
  navigation bar that reaches it. The closure resolves the `IndexSet`'s single element to
  `screen.kept[index]` and passes the `Int` destination through **untouched** — `design.md` § *The
  seam* and § 1.2's measurement are why there is no arithmetic here. Leave the stopped `ForEach`
  without one: that is what makes "the move is offered on the kept list alone" true on a phone.
- [ ] 7.2 Add the fifth `RefusedChange` case to the shell's existing refusal rendering, beside
  `.stopping`, `.keepingAgain` and `.removing`, using `refusalText` unchanged and drawing under the
  kept list, where a moved commitment always is. No new sentence is invented here.
- [ ] 7.3 Confirm the swipe actions `add-roster-removal` shipped still work while the list is in edit
  mode and out of it, and that a row's own tap still does nothing. A reorder handle and a swipe share
  a row; this is the box that says someone looked.
- [ ] 7.4 Run it. `pnpm run phone`, or the simulator per `docs/running-the-app.md`, and check by
  hand: tap Edit, drag a commitment to the top and to the bottom, leave the screen and come back and
  find the order kept, and open the day screen and find the same order there. Drag a row and drop it
  where it started, and confirm nothing is said. Note what was seen in the PR. **This is the box the
  ADR-1019 exception exists for**, and § 8 of `design.md` § *Risks* names the thing to judge: whether
  a reorder hidden behind Edit is discoverable enough. If it is not, that is a want in
  `docs/backlog.md`, not a change to this delta.

## 8. The records

- [ ] 8.1 Write `docs/adr/1037-a-rosters-order-is-the-persons.md` — the decision that a roster's
  order stops being the order things were taken on and becomes the one its owner set, the
  alternative it beat (an arrangement held on the commitments screen, which the day screen would
  then have to read and apply and could disagree with), and the consequences: the order runs over
  all three states, a stopped commitment keeps its place and loses its old neighbour, taken-on order
  survives as the initial value, and moving is the only thing that changes it. **1037 and not 1036**:
  `docs/adr/README.md` on `main` ends at 1035, and `origin/story/139-add-number-entry` already holds
  `1036-a-notice-names-a-cause-a-person-can-act-on.md`. Re-confirm with `git ls-tree -r --name-only
  <branch> -- docs/adr` over every remote branch before writing, as `add-rhythm-in-words` had to.
- [ ] 8.2 Add the ADR-1037 row to `docs/adr/README.md`'s DayByDay table.
- [ ] 8.3 Leave `docs/adr/1031-a-store-reads-the-form-before-it.md` alone, and confirm before the
  review that leaving it alone is still right: no form moves in this change, so its trigger — *"a
  fourth form, or a form that differs by more than a field"* — does not fire. If the implementation
  needed a version bump, **stop**: that is § 1.2's finding, not an ADR amendment to slip in.
- [ ] 8.4 Move the want off `docs/backlog.md` § *Wants* if it is still listed there, and check its
  § *Decided* line for `add-roster-order` still describes what shipped — it says "a stopped
  commitment's place in it is its grill's", which settled answer 3 answered.

## 9. Before the review, and what the janitor does at the archive

- [ ] 9.1 `cd src/DayByDayKit && swift test` — every test green, and the count is 544 plus the 35
  scenarios above. From the repo root, `pnpm run verify` green and `pnpm run checks` reporting
  `147/147 scenario(s) covered`.
- [ ] 9.2 `openspec validate add-roster-order --strict` exits 0, and `openspec validate --all
  --strict --no-interactive` exits 0.
- [ ] 9.3 Rebase onto current `main` and push with `--force-with-lease`. A conflict inside
  `openspec/changes/add-roster-order/` or anywhere under `openspec/specs/` is a **stop**, not a merge
  to resolve: it means another Story landed on `commitment` or `day-screen` while this one was being
  written, which is the owner's call (rule 5). `add-number-entry` (#139) is open on `day-screen` and
  is the likeliest source — `design.md` § *Risks* names it.
- [ ] 9.4 Ask for the review (**G7**) with `mattpocock-skills:code-review`, and fix what it finds on
  this branch before the archive.
- [ ] 9.5 Write the archive handover for the janitor, into the PR or the handover message, saying
  what it must check **after** `/opsx:archive` has run. This box is ticked when the instruction has
  been written, which is before the archive; the checking itself is the janitor's step and has no box
  of its own, deliberately — `add-roster-store` (#103) shipped a box that could only be ticked after
  the archive and stalled the Story between review and merge.

  **Archive handover, for the janitor.** This delta's `specs/commitment/spec.md` carries thirteen
  `## MODIFIED Requirements` — four roster requirements (hold-order, refusal, answer-on-a-date, and
  remove), one roster-store requirement (keep-across-restart), and eight commitments-screen
  requirements (stopped-list, define, tells-apart, confirm-a-stop, take-up-again, cannot-read,
  holds-a-refused-change, and what it holds lasting until the app is shown again or a change is
  kept) — plus two `## ADDED Requirements` (*A roster moves a commitment among the ones it keeps*
  and *A commitments screen moves a commitment among the ones it keeps*).
  `specs/day-screen/spec.md` carries one `## MODIFIED Requirement` (*A day screen draws the
  commitments its roster had not stopped keeping on the day it is showing*). **None of these
  fourteen MODIFIED requirements is renamed anywhere in this delta** — only prose inside each
  changes, and no scenario is dropped or retitled. So after `/opsx:archive` runs, read the
  recomposed `openspec/specs/commitment/spec.md` and `openspec/specs/day-screen/spec.md` and confirm
  that each of those fourteen still sits at the same place in requirement order it held before this
  archive, that both ADDED requirements landed in `commitment` and nowhere else, and that
  `openspec validate --archived` exits 0. Any drift — a requirement moved, dropped, or reworded
  beyond this delta's own MODIFIED text — is **a stop and a report, never a hand-edit** (rule 2):
  `openspec/specs/` is written by `/opsx:archive` and by nothing else, and the archived folder is
  denied to every editor.
