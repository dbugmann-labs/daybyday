## 1. Before a line is written

- [ ] 1.1 Confirm the starting point, and report rather than work around a different one (rule 5).
  From `src/DayByDayKit`, `swift test` reports **580 tests passing** — measured 2026-09-08 with this
  branch cut from `main` at `f8236be`, which includes `add-roster-order` (#161). From the repo root,
  `pnpm run check:scenarios` reports `scenario coverage — 129/214 scenario(s) covered` for this
  change and names `"two rosters differing only in the category one commitment is under are
  different rosters"` as next. Those 129 are the scenarios this delta carries verbatim from the
  current specs; **no test behind any of them may be renamed, moved, or have an assertion changed by
  a box below.** Two kinds of edit to a carried test *are* expected and are not that: adding
  `under: nil` to a `Roster.move` call, and adding a category argument to a
  `CommitmentsScreen.define` call, both because those signatures change (`design.md` § *The seam*).

- [ ] 1.2 Confirm the two facts the form-4 guard rests on, before writing any store test, and stop
  and report if either is false (`design.md` § *Context*, § *The form on disk moves to form 4*):

  **The roster document is at form 3 and carries no category.** `grep -n 'currentVersion\|removalIntroducedInVersion\|category'
  src/DayByDayKit/Sources/DayByDayKit/RosterDocument.swift` finds `currentVersion = 3`,
  `removalIntroducedInVersion = 3` and no category anywhere.

  **An explicit `null` is distinguishable from an absent key.** Measured 2026-09-08 by compiling a
  probe: a hand-written `encode(to:)` calling `container.encode(optional, forKey:)` writes
  `{"category":null,…}` for `nil`, and `container.contains(.category)` answers `true` for an
  explicit `null` and `false` for an absent key. **If that does not reproduce, stop**: the whole
  shape-against-form guard for `category` rests on it and there is no second way to write it that
  ADR-1031 would accept.

- [ ] 1.3 **Check whether `add-number-entry` (#139, PR #158) has merged, before writing a single
  `day-screen` box.** It is out of draft and holds 810 added lines in
  `openspec/specs/day-screen/spec.md`, including modifications to *A day view is a value*, which
  this delta also modifies. Run `git fetch origin && git log --oneline origin/main -5` and
  `git diff --stat origin/main -- openspec/specs/day-screen/spec.md`.

  **If it has merged**, rebase now and re-run `openspec validate add-commitment-category --strict`
  before anything else. A MODIFIED requirement may not drop a scenario the current spec has, so
  `specs/day-screen/spec.md` in this folder will need its carried scenarios refreshed from the new
  spec — that is an edit to the change folder after G4 and therefore **a second G4 approval**
  (rule 1). **Stop and report it**; do not refresh the delta and carry on. It is not a git conflict
  and the rebase will look clean, which is exactly why this box exists.

**The order below is not the order the delta reads in.** The roster comes first because everything
else asks it something, the store second because the screen writes through it, the commitments
screen third, the day view fourth because it is handed what the roster answers, and the day screen
last.

## 2. `commitment` — a roster holds a category, and puts a commitment under one

Nine scenarios in `Tests/DayByDayKitTests/RosterTests.swift` — eight from § *A roster puts a
commitment under a category* and one from § *A roster holds the commitments a person keeps*. Each
task takes exactly one `#### Scenario:` and writes one acceptance test whose `@Test("...")` display
name is that scenario title **verbatim**, then makes it pass with the smallest change that does.
Never write two before the first is green (`AGENTS.md` rule 3). Verify each with
`cd src/DayByDayKit && swift test`: the named test green, every earlier test still green.

- [ ] 2.1 `a commitment a roster is keeping is put under the category it was given` — the first test
  in this change, and the one that adds `category: String?` to `Roster.Entry` and
  `public mutating func put(_ commitment: Commitment, under category: String?) -> Bool` to `Roster`.
  It also needs `Roster.groups` to assert on, so § 3.1 lands with it; write § 3.1's test first if
  that reads more naturally, but do not write a third before both are green.
- [ ] 2.2 `a category of nothing but blank space puts a commitment under none, and is not refused` —
  the one place a category and a name part company. Both a run of spaces and an empty string, in one
  test as the scenario's clauses read.
- [ ] 2.3 `a category is held exactly as it was given, blank space at its ends and all` — no
  trimming and no folding. If this needs a `trimmingCharacters` call anywhere, the rule has been
  read backwards: § 2.2 is the *only* normalisation there is.
- [ ] 2.4 `putting a commitment under the category it is already under is accepted and changes
  nothing` — accepted, reported, and the same roster.
- [ ] 2.5 `putting a commitment the roster is not keeping under a category is refused` — all three
  of not-held, stopped and removed, in one test as the scenario's clauses read.
- [ ] 2.6 `a commitment the roster has stopped keeping is still under the category it was under` —
  a category cuts across the three states rather than adding one.
- [ ] 2.7 `putting a commitment under a category changes no day, no commitment and no order` — the
  scenario that proves a category is the roster's. **Only a move changes the order**; if this needs
  `entries` reordered, stop and report it.
- [ ] 2.8 `putting a commitment under a category on a copy of a roster leaves the roster it was
  copied from unchanged` — the value half, as `add`, `retire`, `remove` and `move` each have.
- [ ] 2.9 `two rosters differing only in the category one commitment is under are different rosters`
  — the category joins what a roster's equality is made of. Should be green off § 2.1 alone if
  `Entry` is `Hashable`; write it anyway, because it is what makes "the roster holds it" a fact.

## 3. `commitment` — a roster reads its commitments back in groups

Eight scenarios from § *A roster reads the commitments it is keeping in groups, one per category*,
in `Tests/DayByDayKitTests/RosterTests.swift`. `design.md` § *Where the grouping is worked out*
fixes why this rule lives here; `§ The seam` fixes `Roster.Group` and the two reads.

- [ ] 3.1 `a roster none of whose commitments is under a category reads back one group` — adds
  `public struct Roster.Group` and `public var groups: [Group]`. The degenerate case first, because
  it is the one every existing caller is in.
- [ ] 3.2 `a roster that has been given no commitment reads back no groups at all` — no groups, not
  one empty group. Both halves of the scenario in one test.
- [ ] 3.3 `a group sits where its first commitment sits in the order the roster holds them` — the
  placement rule itself, and the assertion that the groups are not alphabetical.
- [ ] 3.4 `the commitments under no category come last however early the first of them sits` — the
  one rule that is not "walk the order", and the reason a roster nobody has categorised looks
  exactly as it did before categories existed.
- [ ] 3.5 `a category whose last commitment is put under another is no longer a group` — there is no
  list of categories, so there is nothing to delete. If anything has to be removed from a collection
  here, a second list of categories has been built and that is a stop.
- [ ] 3.6 `reading in groups and reading flat answer with the same commitments in different orders`
  — `Roster.commitments` must be untouched by this change. If it needs a line, stop and report it.
- [ ] 3.7 `a roster answers about a date in groups, with what it had not stopped keeping on it` —
  adds `public func groups(on date: CalendarDate) -> [Group]`.
- [ ] 3.8 `a removed commitment is in the groups a roster answers a date with, under its category` —
  removed and stopped are answered alike about a date, categories included.

## 4. `commitment` — the offer and the move carry a category

Eight scenarios in `Tests/DayByDayKitTests/RosterTests.swift`. `design.md` § *A commitment is
offered with a category or without one* fixes why `add` has two forms, and § *The seam* fixes the
new `move`.

- [ ] 4.1 `a commitment a roster does not hold is added under the category it was offered under` —
  adds `Roster.add(_ commitment: Commitment, under category: String?) -> Bool` beside the existing
  one-argument `add`. All three clauses — with a category, under no category, and with no category
  said — in one test as the scenario reads.
- [ ] 4.2 `a commitment taken up again is put under the category it was offered under` — settled
  answer 19. The offered category wins, including when it is none.
- [ ] 4.3 `a commitment offered again with no category said keeps the category it was under` — the
  one-argument `add`, which is what a commitments screen's one tap uses. **This is the box that
  stops every stopped commitment coming back uncategorised**; if it is green only because the
  one-argument `add` forwards to the two-argument one with `nil`, it is not green.
- [ ] 4.4 `a commitment a roster is already keeping is refused whatever category it is offered under`
  — settled answer 20. A refusal changes nothing, the category included.
- [ ] 4.5 `a move puts a commitment under the category it was moved under` — changes
  `Roster.move(_:toOffset:)` to `Roster.move(_:toOffset:under:)`. **This is where the twelve carried
  move tests gain `under: nil`** and nothing else; any carried move test whose assertions have to
  change is a stop (§ 1.1).
- [ ] 4.6 `a move under no category takes a commitment's category off` — the other direction, and
  what makes the drag into the uncategorised rows work.
- [ ] 4.7 `a move to the place a commitment already has still puts it under the category it was moved
  under` — the carve-out is about the sequence and not about the category. `design.md` § *The offset
  a screen takes is over what it draws* is why the screen answers this differently.
- [ ] 4.8 `a refused move puts a commitment under no category at all` — a refusal leaves the roster
  exactly as it was, categories included. Both clauses in one test.

## 5. `commitment` — a roster store keeps a category, at a fourth form

Ten scenarios in `Tests/DayByDayKitTests/RosterStoreTests.swift`. **`RosterDocument.currentVersion`
moves to `4`** and `RosterEntryRecord` gains `category: String?`, written on every entry at form 4
and on none before it. `design.md` § *The form on disk moves to form 4, and ADR-1031 is amended*
fixes the shape; § 1.2 measured what it rests on.

**Write the two refusal scenarios before the happy path.** The shape-against-form guard is the part
that fails silently if the `null`-versus-absent measurement stops holding, so it is tested first.

- [ ] 5.1 `a roster store declaring a form written before categories and saying something about one
  is refused` — extends the existing shape-against-form guard with
  `RosterDocument.categoryIntroducedInVersion = 4`, kept apart from `currentVersion` for the reason
  `removalIntroducedInVersion`'s own comment gives.
- [ ] 5.2 `a roster store declaring the form this app writes and saying nothing about a category is
  refused` — the other direction, and the one that needs the hand-written `encode(to:)`.
- [ ] 5.3 `a roster kept before a commitment could be put under a category is read with every
  commitment under none` — the third earlier form. Also asserts the file is untouched by being read,
  which is ADR-1031's rule and not a new one.
- [ ] 5.4 `a commitment put under a category over a roster kept before categories existed is read
  back under it` — the first change kept there writes the whole document at form 4, and everything
  the earlier form held is still in it.
- [ ] 5.5 `a commitment put under a category through a roster store is read back under it` — adds
  `public func put(_ commitment: Commitment, under category: String?) throws -> Bool`, the same
  shape as `remove`, writing before it reports.
- [ ] 5.6 `a category is read back out of a roster store exactly, blank space and all` — two
  categories differing only by surrounding blank space stay two groups through the file.
- [ ] 5.7 `a category change a roster store refuses is reported and nothing at its place changes` —
  the store reports what the roster reported and does not turn it into an error.
- [ ] 5.8 `a category change that leaves a roster as it was keeps nothing at its place` — the same
  comparison `move` already makes: report what the roster reports, write only when the roster
  changed. Asserted byte-for-byte on the file.
- [ ] 5.9 `a category change that cannot be kept is refused and the roster a store reports does not
  move`
- [ ] 5.10 `a commitment moved under a category through a roster store is read back moved and under
  it` — adds the category to `RosterStore.move`. **One write, not two**: if this needs the store to
  call the roster twice and write twice, the move's category has been split off and a failure would
  leave half a drag kept.

## 6. `commitment` — a commitments screen draws groups, offers categories, and files a commitment

Twenty-two scenarios in `Tests/DayByDayKitTests/CommitmentsScreenTests.swift`. `design.md` § *The
seam* fixes the surface: `keptGroups`, `categoriesInUse`, `put(_:under:)`, a fourth argument on
`define`, and a sixth `RefusedChange` case, `categorising(Commitment, Refusal)`. **`kept` stays and
becomes the entries read across the groups, in the order they are drawn** — that is what keeps the
carried scenarios saying "what it keeps is three entries" true.

- [ ] 6.1 `a commitments screen draws what it keeps in groups, one per category` — adds
  `keptGroups`, read off `roster.groups` and nothing else. Both clauses: the groups, and what it
  keeps read across them.
- [ ] 6.2 `a group sits where its first commitment sits in the order the person set` — green off
  § 3.3 if the screen reads the roster's groups; write it anyway, because it is what says this screen
  works out no placement of its own.
- [ ] 6.3 `a commitments screen whose commitments are none of them under a category draws one group`
- [ ] 6.4 `a commitment given a category is drawn in that group and returns when the category is
  taken off` — settled answer 17, and the one scenario that shows the roster's order untouched
  underneath a screen that redraws.
- [ ] 6.5 `what a commitments screen has stopped is one flat list whatever categories its commitments
  are under` — settled answer 13. `stopped` gains nothing.
- [ ] 6.6 `a stopped commitment taken up again is drawn in the group of the category it was under` —
  the one tap, and the screen-level half of § 4.3. `keepAgain` must call the **one-argument** `add`.
- [ ] 6.7 `a commitment is put under a category through a commitments screen and kept at the roster
  place` — adds `put(_ commitment: Commitment, under category: String?) -> Refusal?`, the same shape
  as `keepAgain`. Kept before the lists say so, and read back by a screen opened afterwards.
- [ ] 6.8 `a category taken off through a commitments screen draws its commitment among the ones
  under none`
- [ ] 6.9 `a commitments screen asked to put a commitment it does not keep under a category does
  nothing and says nothing` — the guard is `kept.contains(commitment)` alone, not `kept || stopped`
  as `askToRemove` has it. Getting this wrong is the likeliest defect in this section.
- [ ] 6.10 `a category change a commitments screen could not keep leaves both its lists as they were`
  — the sixth `RefusedChange` case.
- [ ] 6.11 `a commitments screen offers the categories the commitments it keeps are under, each once`
  — adds `categoriesInUse`, read off `keptGroups` and in that order.
- [ ] 6.12 `a commitments screen keeping nothing under a category offers none`
- [ ] 6.13 `a commitments screen offers no category that only a commitment it has stopped is under` —
  the recommended answer to `design.md` § *Questions for you* 2. **If the owner answers that
  question the other way, this box and § 6.11's and § 6.14's scenarios are the ones that change.**
- [ ] 6.14 `a category no longer under any commitment kept is no longer offered` — there is nothing
  to delete, because there was never a list.
- [ ] 6.15 `a commitments screen does not fold the case of a category it is given` — settled answer
  5's whole point read from the other side: offering the words in use is what removes the problem,
  and folding case is what the screen must never do instead.
- [ ] 6.16 `a commitment defined under a category is drawn in that category's group and kept under
  it` — adds the fourth argument to `define`. **Every carried `define` call in the suite gains it
  here** (§ 1.1); no carried assertion changes.
- [ ] 6.17 `a commitment defined under a category of nothing but blank space is under none and is not
  refused` — both an empty field and a run of spaces.
- [ ] 6.18 `a commitment defined again after being removed takes the category the form carried` —
  settled answer 19 at the screen. Both clauses: a category typed, and none typed.
- [ ] 6.19 `a category is kept exactly as it was typed on the form` — the screen passes the word
  through untouched, exactly as it passes a name through.
- [ ] 6.20 `a commitments screen holds a refused category change against the commitment it was asked
  about` — the sixth case named against the commitment.
- [ ] 6.21 `a commitments screen holds nothing against a category change that asks for no change at
  all` — and it does not answer a notice already standing.
- [ ] 6.22 `a commitments screen that cannot read its roster does nothing when it is asked to put a
  commitment under a category` — and offers no categories at all.

## 7. `commitment` — the drag carries a category, and says where it would land

Six scenarios for the drag and nine for the mark, all in
`Tests/DayByDayKitTests/CommitmentsScreenTests.swift`, and the sharpest part of
the change. `design.md` § *The offset a screen takes is over what it draws* fixes the conversion, and
**`CommitmentsScreen.move`'s signature does not change while its offset's meaning does** — read that
section before writing 7.1.

- [ ] 7.1 `an offset a commitments screen is given is counted over what it draws and not over the
  roster's own order` — the scenario that pins the conversion. Write it first: the two other
  orderings a reader might assume both fail it. **Count the offset from zero and check it against
  the carve-out before you start** — this scenario and § 7.4's were both written with an offset that
  was one of the dragged row's two no-op offsets, and both were corrected while the drag mark was
  being written (`design.md` § *The offset a screen takes is over what it draws*).
- [ ] 7.2 `a commitment dropped among another group's entries is put under that group's category` —
  settled answer 14. One drag, two changes, one write.
- [ ] 7.3 `a commitment dropped among the entries under no category has its category taken off` —
  settled answer 15, and the only drag that undoes a drag.
- [ ] 7.4 `a commitment dropped past the last entry drawn takes the last group's category` — the
  past-the-end offset, where there is no entry at the offset to read a category off.
- [ ] 7.5 `a drop where a commitment is already drawn changes neither its place nor its category` —
  the carve-out, and the settled answer at `design.md` § *Open Questions* 1. Asserted
  byte-for-byte on the file, because nothing may be written.
- [ ] 7.6 `dragging a group's only entry into another group leaves one heading fewer` — the
  consequence named in the requirement: a group whose first commitment leaves is drawn somewhere
  else, and a group with nothing left in it is not drawn at all.
- [ ] 7.7 Re-run the twelve carried scenarios under § *A commitments screen moves a commitment among
  the ones it keeps* and confirm each is still green with no assertion changed. They all describe a
  roster with no categories, where the drawn order and the roster's order are the same sequence, so
  they should be. **A carried move scenario that goes red is a stop and a report**: it would mean the
  conversion is wrong in the case where there is nothing to convert.
- [ ] 7.8 Confirm by reading `CommitmentsScreen.move` that `refusedChange = nil` is still written
  only where the store actually kept something. The comparison moves in this change — the roster it
  is compared against now differs in a category as well as in an order — and the two carried
  scenarios that pin it (*what a commitments screen holds about a refused change ends when a move is
  kept* and *… stands when a move drops a commitment where it already is*) are checked by § 7.7,
  which cannot see whether the line is right for the *reason* it is right.

- [ ] 7.9 `a commitments screen says which group a drop at an offset would join` — the first test of
  `landing(dropping:at:)`, and red until the seam exists. `design.md` § *The mark a live drag leaves*
  says what it is for; **write it against the same helper `move` uses**, because one rule read twice
  is the whole requirement.
- [ ] 7.10 `a drop past the last entry drawn would join the last group drawn` — the past-the-end
  offset, on a row that is not itself drawn last, so the offset is not one of its carve-outs.
- [ ] 7.11 `a drop among the entries under no category would join no category, which is not no group`
  — the case the return type exists for. Assert the two answers are told apart; a seam that returned
  an optional category could not do it.
- [ ] 7.12 `the two offsets that leave a commitment where it is drawn would join the group it is
  already in` — the carve-out read rather than acted, and the answer that stops the mark promising a
  refiling that will not happen.
- [ ] 7.13 `a commitments screen says no group where the offset is one the list it draws does not
  have` — both ends, past the end and below zero.
- [ ] 7.14 `a commitments screen says no group for a commitment it does not keep` — a stopped one and
  one neither list holds.
- [ ] 7.15 `a commitments screen that cannot read its roster says no group a drop would join` — it
  keeps nothing, so there is no group to name, and it must not be reached by way of an empty list
  crashing.
- [ ] 7.16 `the group a commitments screen says a drop would join is the group the drop puts the
  commitment in` — **the load-bearing one.** Ask, then move, at four offsets including both
  carve-outs, and assert the answer and the result agree each time. A mark that can disagree with the
  drop is worse than no mark, and this is the test that stops it.
- [ ] 7.17 `asking which group a drop would join changes nothing at the roster place` — asserted
  byte-for-byte on the file and on the refused change the screen holds. Asking is a question, not an
  act.

## 8. `day-screen` — a day view is handed its groups

Eleven scenarios: seven from the ADDED requirement and two from each MODIFIED one, in
`Tests/DayByDayKitTests/DayViewTests.swift` and `Tests/DayByDayKitTests/DayScreenTests.swift`.

**Before any box here, re-read § 1.3.** If `add-number-entry` merged in the meantime, stop.

- [ ] 8.1 `a day view handed commitments with no grouping holds one group with no category` — adds
  `DayView.Group` and `DayView.groups`, and keeps `DayView.init(of commitments:on:in:)` working as
  the "nothing to say about categories" form. Written first because every existing day-view test is
  in this shape and all of them must stay green.
- [ ] 8.2 `a day view holds one group for each group it was handed that has something due` — adds
  `DayView.init(of groups: [Roster.Group], on:in:)`. `rows` is every row read across the groups, in
  drawing order.
- [ ] 8.3 `a day view draws no group whose commitments are none of them due on the date` — settled
  answer 12, and the day view's own rule rather than the roster's.
- [ ] 8.4 `a day view handed only groups with nothing due holds no groups at all` — and is the same
  day view as one formed of nothing at all.
- [ ] 8.5 `a day view drops the commitments that are not due and keeps the group its due ones are in`
- [ ] 8.6 `a day view does not combine two groups under the same category` — the day view works out
  no grouping of its own, which is what this scenario is for; it draws what it was handed.
- [ ] 8.7 `a row in a group says whether its commitment is kept, exactly as a row under no category
  does` — a `Row` gains nothing at all. If `Row` needs a category, stop and report it.
- [ ] 8.8 `two day views differing only in how their commitments were grouped are different day
  views` — the groups join what a day view is.
- [ ] 8.9 `two day views differing only in a group none of whose commitments is due are the same day
  view` — the third way a difference in what was handed over does not reach the answer.
- [ ] 8.10 `a day screen draws its rows in the groups its roster puts them in` — moves `DayScreen`'s
  three `roster.commitments(on:)` call sites to `roster.groups(on:)`. `previousDay` and `nextDay`
  gain group-taking forms.
- [ ] 8.11 `a day screen draws a group again after a category is changed at its roster place` — the
  screen asks its roster again when the app is shown, exactly as it already does for the order. If
  this needs a new rule in `DayScreen`, stop and report it.

## 9. The app shell

Under ADR-1019's 2026-09-04 amendment, whose three conditions `design.md` § *The shell rides this
Story* checks off one by one. Every decision is behind the seam; the shell converts nothing, refuses
nothing, orders nothing and groups nothing.

- [ ] 9.1 `CommitmentsView.swift` — draw the kept list as **one flat `ForEach` over `screen.kept`**
  inside `Section("Kept")`, with the group's category drawn as a header row where an entry is the
  first of its group, read off `screen.keptGroups`. **Not a `Section` per group**: `design.md`
  § *The shell rides this Story* is why, and a per-section `.onMove` offset would be arithmetic in
  the shell. `.onMove` stays exactly as it is and still passes its `Int` through untouched.
- [ ] 9.2 `CommitmentsView.swift` — add the category field to the define form, offering
  `screen.categoriesInUse` alongside free text, and pass whatever is in it to `screen.define` as the
  fourth argument. The field starts empty, and is cleared on a definition that is not refused,
  exactly as the name field already is.
- [ ] 9.3 `CommitmentsView.swift` — add a way to change a kept commitment's category, calling
  `screen.put(_:under:)`, and add the sixth `RefusedChange` case to the existing refusal rendering
  beside `.stopping`, `.keepingAgain`, `.removing` and `.moving`, using `refusalText` unchanged. No
  new sentence is invented here.
- [ ] 9.4 `ContentView.swift` — draw the day view's `groups` with a heading per category and no
  heading for the group with none. The tick behaviour on a row does not change.
- [ ] 9.5 Run it. `pnpm run phone`, or the simulator per `docs/running-the-app.md`, and check by
  hand: type a category on the form and find the group appear; pick an offered category rather than
  typing it; empty the field and find the row rejoin the ungrouped rows; tap Edit and drag a row
  from one group into another and find it refiled where it was dropped; drag a row into the
  ungrouped rows and find its category gone; drop a row where it started and find nothing said; and
  open the day screen and find the same groups in the same places. Note what was seen in the PR.
  **This is the box the ADR-1019 exception exists for**, and `design.md` § *Risks* names the two
  things to judge: whether a group whose first row is dragged away moving on screen reads as a bug,
  and whether the drop-on-the-seam answer in § *Open Questions* 1 feels right in the hand. If
  either reads badly, that is a want in `docs/backlog.md` or a question for the owner, **not** a
  change to this delta without a second G4.
- [ ] 9.6 **Find out whether the shell can draw the drag mark, and report either way.** The kit
  answers `landing(dropping:at:)` whatever happens here; this box is about whether a person can see
  it. Read `design.md` § *The mark a live drag leaves* first — measured on 2026-09-08 against
  `iPhoneOS26.5.sdk`, SwiftUI's `onMove(perform:)` is the whole of the reorder surface and publishes
  **no in-flight destination**, and `DragSession` carries a `CGPoint` and no offset.

  So: re-read that interface for the SDK actually installed, and if something now hands a live
  destination offset to a `List` reorder, draw the mark — the heading of the group
  `screen.landing(dropping:at:)` names, and nothing on the dragged row — and note in the PR what the
  API was. **If nothing does, draw nothing and say so in the PR.** Do **not** replace `.onMove` with
  a `draggable`/`dropDestination` drag to get there: that puts "which row am I over" in
  `CommitmentsView.swift`, which is arithmetic in the shell and the one thing ADR-1019's guard
  forbids (`design.md` § *The shell rides this Story*). A shell rewrite to reach the mark is a Story
  of its own with its own G4, and the box is ticked by the report, not by the mark.

## 10. The records

**Four of them were written at G4 and are in the diff the owner signed**, because `docs/adr/**` and
`CONTEXT.md` are `spec-author`'s to write and not `implementer`'s (`AGENTS.md` § *Agent roles*). The
boxes below confirm rather than write, and each is tickable while reading what is already there:

- [ ] 10.1 Confirm `docs/adr/1038-a-category-is-the-rosters.md` still describes what shipped — a
  category held by the roster against a commitment rather than as a fifth part of one, and the
  grouping rule on the roster with it — and that its ADR-1023 and ADR-1030 reading is the one the
  implementation bore out. **Its number was checked against every remote branch, not against `main`
  alone**: `main` ends at 1037 and `origin/story/139-add-number-entry` holds
  `1036-a-notice-names-a-cause-a-person-can-act-on.md`. Re-confirm with
  `git ls-tree -r --name-only <branch> -- docs/adr` over every remote before the review, and report
  a collision rather than renumbering silently.
- [ ] 10.2 Confirm the ADR-1038 row is in `docs/adr/README.md`'s DayByDay table and reads true.
- [ ] 10.3 Confirm `docs/adr/1031-a-store-reads-the-form-before-it.md` § *A fourth form, and a field
  that has to be written* matches what was built: `categoryIntroducedInVersion = 4`, one comparison
  rather than a decode path per form, and `category` written as an explicit `null` on every form-4
  entry. **If the implementation needed a second decode path after all, stop and report it** — that
  is a different amendment and the owner's call, not an edit to slip in here.
- [ ] 10.4 Confirm `CONTEXT.md` § *Day view*'s **Corrected 2026-09-08** paragraph is still true of
  the code: the day view is handed its groups and makes no ordering of its own. If `DayView` ended
  up working out a placement, that is a stop — it would mean `day-screen`'s oldest requirement needed
  carrying after all, which is a G4 question (`design.md` § *Where the grouping is worked out*).
- [ ] 10.5 Leave `docs/adr/1030-the-kind-is-a-commitments-fourth-part.md` and
  `docs/adr/1037-a-rosters-order-is-the-persons.md` alone, and confirm before the review that
  leaving them alone is still right: the kind is still the commitment's fourth part and still never
  changes, and a move is still the only thing that changes a roster's order. If either stopped being
  true during the implementation, that is a stop rather than an ADR edit to slip in.
- [ ] 10.6 Leave `docs/backlog.md` alone. B-029 and B-030 are both answered by this Story, and moving
  a want from § *Wants* to § *Decided* is a grooming pass's act rather than a Story branch's
  (`grill.md` § *Left open* 1). Confirm that neither has been moved by this branch before the review.

## 11. Before the review, and what the janitor does at the archive

- [ ] 11.1 `cd src/DayByDayKit && swift test` — every test green, and the count is 580 plus the 85
  scenarios above. From the repo root, `pnpm run verify` green and `pnpm run checks` reporting
  `214/214 scenario(s) covered`.
- [ ] 11.2 `openspec validate add-commitment-category --strict` exits 0, and `openspec validate --all
  --strict --no-interactive` exits 0.
- [ ] 11.3 Rebase onto current `main` and push with `--force-with-lease`. A conflict inside
  `openspec/changes/add-commitment-category/` or anywhere under `openspec/specs/` is a **stop**, not
  a merge to resolve (rule 5). **And so is a clean rebase that then fails § 11.2** — that is
  `add-number-entry` (#139) having landed on `day-screen`, which § 1.3 warned about and which needs
  a second G4 rather than a quiet refresh of the delta.
- [ ] 11.4 Ask for the review (**G7**) with `mattpocock-skills:code-review`, and fix what it finds on
  this branch before the archive.
- [ ] 11.5 Write the archive handover for the janitor, into the PR or the handover message, saying
  what it must check **after** `/opsx:archive` has run. This box is ticked when the instruction has
  been written, which is before the archive; the checking itself is the janitor's step and has no box
  of its own, deliberately — `add-roster-store` (#103) shipped a box that could only be ticked after
  the archive and stalled the Story between review and merge.

  **Archive handover, for the janitor.** This delta's `specs/commitment/spec.md` carries twelve
  `## MODIFIED Requirements` — five about the roster and its store (hold-order, refusal, move,
  keep-across-restart, and reading an earlier form) and seven about the commitments screen
  (kept-list, stopped-list, define, move, holds-a-refused-change, what it holds lasting until the app
  is shown again or a change is kept, and cannot-read) — plus four `## ADDED Requirements`
  (*A roster puts a commitment under a category*, *A roster reads the commitments it is keeping in
  groups, one per category*, *A commitments screen puts a commitment under a category, and offers
  the categories in use*, and *A commitments screen says which group a drop would join, while a drag
  is live*). `specs/day-screen/spec.md` carries two `## MODIFIED Requirements`
  (*A day view is a value* and *A day screen draws the commitments its roster had not stopped keeping
  on the day it is showing*) and one `## ADDED Requirement` (*A day view draws its rows in the groups
  it was handed, and draws no group with nothing due*). **None of these fourteen MODIFIED
  requirements is renamed anywhere in this delta** — only prose inside each changes, and no scenario
  is dropped or retitled. So after `/opsx:archive` runs, read the recomposed
  `openspec/specs/commitment/spec.md` and `openspec/specs/day-screen/spec.md` and confirm that each
  of those fourteen still sits at the same place in requirement order it held before this archive,
  that the four ADDED `commitment` requirements landed in `commitment` and nowhere else and the one
  ADDED `day-screen` requirement in `day-screen`, and that `openspec validate --archived` exits 0.
  Any drift — a requirement moved, dropped, or reworded beyond this delta's own MODIFIED text — is
  **a stop and a report, never a hand-edit** (rule 2): `openspec/specs/` is written by
  `/opsx:archive` and by nothing else, and the archived folder is denied to every editor.
