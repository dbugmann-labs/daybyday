## 1. Before a line is written

- [x] 1.1 Confirm the starting point, and report rather than work around a different one (rule 5).
  From `src/DayByDayKit`, `swift test` reports **580 tests passing** — measured 2026-09-08 with this
  branch cut from `main` at `f8236be`, which includes `add-roster-order` (#161). From the repo root,
  `pnpm run check:scenarios` reports `scenario coverage — 129/206 scenario(s) covered` for this
  change and names `"two rosters differing only in the category one commitment is under are
  different rosters"` as next. Those 129 are the scenarios this delta carries verbatim from the
  current specs; **no test behind any of them may be renamed, moved, or have an assertion changed by
  a box below.** Three kinds of edit to a carried test *are* expected and are not that: adding
  `under: nil` to a `Roster.move` call, adding a category argument to a `CommitmentsScreen.define`
  call, and adding `under: nil` to a `CommitmentsScreen.move` call — all three because those
  signatures change (`design.md` § *The seam*). Every carried move scenario describes a roster with
  nothing under a category, so the group it means is the one under none and `nil` is what it passes.

- [x] 1.2 Confirm the two facts the form-4 guard rests on, before writing any store test, and stop
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

- [x] 1.3 **Check whether `add-number-entry` (#139, PR #158) has merged, before writing a single
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

- [x] 1.4 **This delta was rewritten after it was first implemented, and § 7 and § 9 are where.**
  On 2026-09-08 the owner ran the § 9.5 walkthrough on the phone and reversed the seam rule of
  `design.md` § *Open Questions* 1 (`grill.md` § *Settled* 24): a drop now carries the group it
  landed in, and `CommitmentsScreen.move` takes that group as well as an offset counted inside it.
  Before starting, read `design.md` § *The offset a screen takes is over the group it was dropped
  in*, § *What the mark was for, and what draws it now* and § *The shell rides this Story*, and note
  that **`CommitmentsScreen.landing(dropping:at:)` and its `Landing` enum come out of the kit
  altogether**, tests and all. Tick this box once those three sections have been read; every
  unticked box below is one this rewrite reopened.

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

- [x] 2.1 `a commitment a roster is keeping is put under the category it was given` — the first test
  in this change, and the one that adds `category: String?` to `Roster.Entry` and
  `public mutating func put(_ commitment: Commitment, under category: String?) -> Bool` to `Roster`.
  It also needs `Roster.groups` to assert on, so § 3.1 lands with it; write § 3.1's test first if
  that reads more naturally, but do not write a third before both are green.
- [x] 2.2 `a category of nothing but blank space puts a commitment under none, and is not refused` —
  the one place a category and a name part company. Both a run of spaces and an empty string, in one
  test as the scenario's clauses read.
- [x] 2.3 `a category is held exactly as it was given, blank space at its ends and all` — no
  trimming and no folding. If this needs a `trimmingCharacters` call anywhere, the rule has been
  read backwards: § 2.2 is the *only* normalisation there is.
- [x] 2.4 `putting a commitment under the category it is already under is accepted and changes
  nothing` — accepted, reported, and the same roster.
- [x] 2.5 `putting a commitment the roster is not keeping under a category is refused` — all three
  of not-held, stopped and removed, in one test as the scenario's clauses read.
- [x] 2.6 `a commitment the roster has stopped keeping is still under the category it was under` —
  a category cuts across the three states rather than adding one.
- [x] 2.7 `putting a commitment under a category changes no day, no commitment and no order` — the
  scenario that proves a category is the roster's. **Only a move changes the order**; if this needs
  `entries` reordered, stop and report it.
- [x] 2.8 `putting a commitment under a category on a copy of a roster leaves the roster it was
  copied from unchanged` — the value half, as `add`, `retire`, `remove` and `move` each have.
- [x] 2.9 `two rosters differing only in the category one commitment is under are different rosters`
  — the category joins what a roster's equality is made of. Should be green off § 2.1 alone if
  `Entry` is `Hashable`; write it anyway, because it is what makes "the roster holds it" a fact.

## 3. `commitment` — a roster reads its commitments back in groups

Eight scenarios from § *A roster reads the commitments it is keeping in groups, one per category*,
in `Tests/DayByDayKitTests/RosterTests.swift`. `design.md` § *Where the grouping is worked out*
fixes why this rule lives here; `§ The seam` fixes `Roster.Group` and the two reads.

- [x] 3.1 `a roster none of whose commitments is under a category reads back one group` — adds
  `public struct Roster.Group` and `public var groups: [Group]`. The degenerate case first, because
  it is the one every existing caller is in.
- [x] 3.2 `a roster that has been given no commitment reads back no groups at all` — no groups, not
  one empty group. Both halves of the scenario in one test.
- [x] 3.3 `a group sits where its first commitment sits in the order the roster holds them` — the
  placement rule itself, and the assertion that the groups are not alphabetical.
- [x] 3.4 `the commitments under no category come last however early the first of them sits` — the
  one rule that is not "walk the order", and the reason a roster nobody has categorised looks
  exactly as it did before categories existed.
- [x] 3.5 `a category whose last commitment is put under another is no longer a group` — there is no
  list of categories, so there is nothing to delete. If anything has to be removed from a collection
  here, a second list of categories has been built and that is a stop.
- [x] 3.6 `reading in groups and reading flat answer with the same commitments in different orders`
  — `Roster.commitments` must be untouched by this change. If it needs a line, stop and report it.
- [x] 3.7 `a roster answers about a date in groups, with what it had not stopped keeping on it` —
  adds `public func groups(on date: CalendarDate) -> [Group]`.
- [x] 3.8 `a removed commitment is in the groups a roster answers a date with, under its category` —
  removed and stopped are answered alike about a date, categories included.

## 4. `commitment` — the offer and the move carry a category

Eight scenarios in `Tests/DayByDayKitTests/RosterTests.swift`. `design.md` § *A commitment is
offered with a category or without one* fixes why `add` has two forms, and § *The seam* fixes the
new `move`.

- [x] 4.1 `a commitment a roster does not hold is added under the category it was offered under` —
  adds `Roster.add(_ commitment: Commitment, under category: String?) -> Bool` beside the existing
  one-argument `add`. All three clauses — with a category, under no category, and with no category
  said — in one test as the scenario reads.
- [x] 4.2 `a commitment taken up again is put under the category it was offered under` — settled
  answer 19. The offered category wins, including when it is none.
- [x] 4.3 `a commitment offered again with no category said keeps the category it was under` — the
  one-argument `add`, which is what a commitments screen's one tap uses. **This is the box that
  stops every stopped commitment coming back uncategorised**; if it is green only because the
  one-argument `add` forwards to the two-argument one with `nil`, it is not green.
- [x] 4.4 `a commitment a roster is already keeping is refused whatever category it is offered under`
  — settled answer 20. A refusal changes nothing, the category included.
- [x] 4.5 `a move puts a commitment under the category it was moved under` — changes
  `Roster.move(_:toOffset:)` to `Roster.move(_:toOffset:under:)`. **This is where the twelve carried
  move tests gain `under: nil`** and nothing else; any carried move test whose assertions have to
  change is a stop (§ 1.1).
- [x] 4.6 `a move under no category takes a commitment's category off` — the other direction, and
  what makes the drag into the uncategorised rows work.
- [x] 4.7 `a move to the place a commitment already has still puts it under the category it was moved
  under` — the carve-out is about the sequence and not about the category. `design.md` § *The offset
  a screen takes is over the group it was dropped in* is why the screen answers this differently.
- [x] 4.8 `a refused move puts a commitment under no category at all` — a refusal leaves the roster
  exactly as it was, categories included. Both clauses in one test.

## 5. `commitment` — a roster store keeps a category, at a fourth form

Ten scenarios in `Tests/DayByDayKitTests/RosterStoreTests.swift`. **`RosterDocument.currentVersion`
moves to `4`** and `RosterEntryRecord` gains `category: String?`, written on every entry at form 4
and on none before it. `design.md` § *The form on disk moves to form 4, and ADR-1031 is amended*
fixes the shape; § 1.2 measured what it rests on.

**Write the two refusal scenarios before the happy path.** The shape-against-form guard is the part
that fails silently if the `null`-versus-absent measurement stops holding, so it is tested first.

- [x] 5.1 `a roster store declaring a form written before categories and saying something about one
  is refused` — extends the existing shape-against-form guard with
  `RosterDocument.categoryIntroducedInVersion = 4`, kept apart from `currentVersion` for the reason
  `removalIntroducedInVersion`'s own comment gives.
- [x] 5.2 `a roster store declaring the form this app writes and saying nothing about a category is
  refused` — the other direction, and the one that needs the hand-written `encode(to:)`.
- [x] 5.3 `a roster kept before a commitment could be put under a category is read with every
  commitment under none` — the third earlier form. Also asserts the file is untouched by being read,
  which is ADR-1031's rule and not a new one.
- [x] 5.4 `a commitment put under a category over a roster kept before categories existed is read
  back under it` — the first change kept there writes the whole document at form 4, and everything
  the earlier form held is still in it.
- [x] 5.5 `a commitment put under a category through a roster store is read back under it` — adds
  `public func put(_ commitment: Commitment, under category: String?) throws -> Bool`, the same
  shape as `remove`, writing before it reports.
- [x] 5.6 `a category is read back out of a roster store exactly, blank space and all` — two
  categories differing only by surrounding blank space stay two groups through the file.
- [x] 5.7 `a category change a roster store refuses is reported and nothing at its place changes` —
  the store reports what the roster reported and does not turn it into an error.
- [x] 5.8 `a category change that leaves a roster as it was keeps nothing at its place` — the same
  comparison `move` already makes: report what the roster reports, write only when the roster
  changed. Asserted byte-for-byte on the file.
- [x] 5.9 `a category change that cannot be kept is refused and the roster a store reports does not
  move`
- [x] 5.10 `a commitment moved under a category through a roster store is read back moved and under
  it` — adds the category to `RosterStore.move`. **One write, not two**: if this needs the store to
  call the roster twice and write twice, the move's category has been split off and a failure would
  leave half a drag kept.

## 6. `commitment` — a commitments screen draws groups, offers categories, and files a commitment

Twenty-two scenarios in `Tests/DayByDayKitTests/CommitmentsScreenTests.swift`. `design.md` § *The
seam* fixes the surface: `keptGroups`, `categoriesInUse`, `put(_:under:)`, a fourth argument on
`define`, and a sixth `RefusedChange` case, `categorising(Commitment, Refusal)`. **`kept` stays and
becomes the entries read across the groups, in the order they are drawn** — that is what keeps the
carried scenarios saying "what it keeps is three entries" true.

- [x] 6.1 `a commitments screen draws what it keeps in groups, one per category` — adds
  `keptGroups`, read off `roster.groups` and nothing else. Both clauses: the groups, and what it
  keeps read across them.
- [x] 6.2 `a group sits where its first commitment sits in the order the person set` — green off
  § 3.3 if the screen reads the roster's groups; write it anyway, because it is what says this screen
  works out no placement of its own.
- [x] 6.3 `a commitments screen whose commitments are none of them under a category draws one group`
- [x] 6.4 `a commitment given a category is drawn in that group and returns when the category is
  taken off` — settled answer 17, and the one scenario that shows the roster's order untouched
  underneath a screen that redraws.
- [x] 6.5 `what a commitments screen has stopped is one flat list whatever categories its commitments
  are under` — settled answer 13. `stopped` gains nothing.
- [x] 6.6 `a stopped commitment taken up again is drawn in the group of the category it was under` —
  the one tap, and the screen-level half of § 4.3. `keepAgain` must call the **one-argument** `add`.
- [x] 6.7 `a commitment is put under a category through a commitments screen and kept at the roster
  place` — adds `put(_ commitment: Commitment, under category: String?) -> Refusal?`, the same shape
  as `keepAgain`. Kept before the lists say so, and read back by a screen opened afterwards.
- [x] 6.8 `a category taken off through a commitments screen draws its commitment among the ones
  under none`
- [x] 6.9 `a commitments screen asked to put a commitment it does not keep under a category does
  nothing and says nothing` — the guard is `kept.contains(commitment)` alone, not `kept || stopped`
  as `askToRemove` has it. Getting this wrong is the likeliest defect in this section.
- [x] 6.10 `a category change a commitments screen could not keep leaves both its lists as they were`
  — the sixth `RefusedChange` case.
- [x] 6.11 `a commitments screen offers the categories the commitments it keeps are under, each once`
  — adds `categoriesInUse`, read off `keptGroups` and in that order.
- [x] 6.12 `a commitments screen keeping nothing under a category offers none`
- [x] 6.13 `a commitments screen offers no category that only a commitment it has stopped is under` —
  the recommended answer to the first residual round's second question, settled at `design.md`
  § *Open Questions* 2. **If that answer is ever taken the other way, this box and § 6.11's and § 6.14's scenarios are the ones that change.**
- [x] 6.14 `a category no longer under any commitment kept is no longer offered` — there is nothing
  to delete, because there was never a list.
- [x] 6.15 `a commitments screen does not fold the case of a category it is given` — settled answer
  5's whole point read from the other side: offering the words in use is what removes the problem,
  and folding case is what the screen must never do instead.
- [x] 6.16 `a commitment defined under a category is drawn in that category's group and kept under
  it` — adds the fourth argument to `define`. **Every carried `define` call in the suite gains it
  here** (§ 1.1); no carried assertion changes.
- [x] 6.17 `a commitment defined under a category of nothing but blank space is under none and is not
  refused` — both an empty field and a run of spaces.
- [x] 6.18 `a commitment defined again after being removed takes the category the form carried` —
  settled answer 19 at the screen. Both clauses: a category typed, and none typed.
- [x] 6.19 `a category is kept exactly as it was typed on the form` — the screen passes the word
  through untouched, exactly as it passes a name through.
- [x] 6.20 `a commitments screen holds a refused category change against the commitment it was asked
  about` — the sixth case named against the commitment.
- [x] 6.21 `a commitments screen holds nothing against a category change that asks for no change at
  all` — and it does not answer a notice already standing.
- [x] 6.22 `a commitments screen that cannot read its roster does nothing when it is asked to put a
  commitment under a category` — and offers no categories at all.

## 7. `commitment` — the drop carries the group it landed in

Seven scenarios, all in `Tests/DayByDayKitTests/CommitmentsScreenTests.swift`, and the sharpest part
of the change. `design.md` § *The offset a screen takes is over the group it was dropped in* fixes
the conversion. **`CommitmentsScreen.move` gains a third argument and its offset changes meaning**:
it becomes `move(_ commitment: Commitment, toOffset offset: Int, under category: String?)`, the
offset is counted over the entries drawn **in the group named by `category`**, and there is no
default — a defaulted `nil` would read as "leave the category alone" and mean "take it off".

**§ 7.0 first, then the rest.** The boxes below were all ticked once against the reversed rule and
have been unticked; what was written for them is a starting point and not an answer.

- [x] 7.0 **Take `landing(dropping:at:)` and the `Landing` enum out of `CommitmentsScreen`, and
  delete the nine tests that drove them** — the ones named in `design.md` § *What the mark was for,
  and what draws it now*. The requirement they belonged to is out of the delta, so a test carrying
  one of those names is a test with no scenario behind it and `pnpm run checks` will say so. Delete
  rather than adapt: the rule they read is the rule that was reversed.
- [x] 7.1 `an offset a commitments screen is given is counted over the group a drop landed in and not
  over the roster's own order` — **the scenario that pins the conversion, and a rename**: it was
  `… counted over what it draws and not over the roster's own order` and the test behind it must be
  renamed with it. Write it first; the two other orderings a reader might assume both fail it. Its
  last clause is the boundary that most needs pinning — an offset the whole drawn list has and the
  group does not is an offset the screen does not have.
- [x] 7.2 `a commitment dropped among another group's entries is put under that group's category` —
  settled answer 14. One drag, two changes, one write. Title unchanged; the call gains its group.
- [x] 7.3 `a commitment dropped among the entries under no category has its category taken off` —
  settled answer 15, and the only drag that undoes a drag. Title unchanged, and the offset is now
  counted over the group under no category rather than over the whole list.
- [x] 7.4 `a commitment dropped after the last entry of a group is drawn at the end of that group` —
  **the reversal's own scenario, and a rename**: it was `a commitment dropped past the last entry
  drawn takes the last group's category`, and the test behind it must be renamed with it. This is
  the slot the old rule made unreachable and the defect the owner reported. Assert both halves: the
  row lands at the end of the group it was dropped in, **and** it is not under the group drawn
  immediately after it.
- [x] 7.5 `a drop where a commitment is already drawn changes neither its place nor its category` —
  the carve-out, now entirely inside the row's own group. Asserted byte-for-byte on the file, because
  nothing may be written. Title unchanged.
- [x] 7.6 `a commitments screen asked to move a commitment into a group it draws none of does nothing
  and says nothing` — **new**, and the case the third argument creates: a category nothing kept is
  under, and no category at all where everything kept is under one. Byte-for-byte on the file again.
  It must not answer by making the group.
- [x] 7.7 `dragging a group's only entry into another group leaves one heading fewer` — the
  consequence named in the requirement: a group whose first commitment leaves is drawn somewhere
  else, and a group with nothing left in it is not drawn at all. Title unchanged.
- [x] 7.8 Re-run the twelve carried scenarios under § *A commitments screen moves a commitment among
  the ones it keeps* and confirm each is still green with **no assertion and no title changed** —
  only `under: nil` added to each `move` call. They all describe a roster with nothing under a
  category, where the one group is the whole drawn list, so they should be. **A carried move scenario
  that goes red is a stop and a report**: it would mean the conversion is wrong in the case where
  there is nothing to convert.
- [x] 7.9 Confirm by reading `CommitmentsScreen.move` that `refusedChange = nil` is still written
  only where the store actually kept something. The comparison moves in this change — the roster it
  is compared against now differs in a category as well as in an order — and the two carried
  scenarios that pin it (*what a commitments screen holds about a refused change ends when a move is
  kept* and *… stands when a move drops a commitment where it already is*) are checked by § 7.8,
  which cannot see whether the line is right for the *reason* it is right.

## 8. `day-screen` — a day view is handed its groups

Eleven scenarios: seven from the ADDED requirement and two from each MODIFIED one, in
`Tests/DayByDayKitTests/DayViewTests.swift` and `Tests/DayByDayKitTests/DayScreenTests.swift`.

**Before any box here, re-read § 1.3.** If `add-number-entry` merged in the meantime, stop.

- [x] 8.1 `a day view handed commitments with no grouping holds one group with no category` — adds
  `DayView.Group` and `DayView.groups`, and keeps `DayView.init(of commitments:on:in:)` working as
  the "nothing to say about categories" form. Written first because every existing day-view test is
  in this shape and all of them must stay green.
- [x] 8.2 `a day view holds one group for each group it was handed that has something due` — adds
  `DayView.init(of groups: [Roster.Group], on:in:)`. `rows` is every row read across the groups, in
  drawing order.
- [x] 8.3 `a day view draws no group whose commitments are none of them due on the date` — settled
  answer 12, and the day view's own rule rather than the roster's.
- [x] 8.4 `a day view handed only groups with nothing due holds no groups at all` — and is the same
  day view as one formed of nothing at all.
- [x] 8.5 `a day view drops the commitments that are not due and keeps the group its due ones are in`
- [x] 8.6 `a day view does not combine two groups under the same category` — the day view works out
  no grouping of its own, which is what this scenario is for; it draws what it was handed.
- [x] 8.7 `a row in a group says whether its commitment is kept, exactly as a row under no category
  does` — a `Row` gains nothing at all. If `Row` needs a category, stop and report it.
- [x] 8.8 `two day views differing only in how their commitments were grouped are different day
  views` — the groups join what a day view is.
- [x] 8.9 `two day views differing only in a group none of whose commitments is due are the same day
  view` — the third way a difference in what was handed over does not reach the answer.
- [x] 8.10 `a day screen draws its rows in the groups its roster puts them in` — moves `DayScreen`'s
  three `roster.commitments(on:)` call sites to `roster.groups(on:)`. `previousDay` and `nextDay`
  gain group-taking forms.
- [x] 8.11 `a day screen draws a group again after a category is changed at its roster place` — the
  screen asks its roster again when the app is shown, exactly as it already does for the order. If
  this needs a new rule in `DayScreen`, stop and report it.

## 9. The app shell

Under ADR-1019's 2026-09-04 amendment, whose three conditions `design.md` § *The shell rides this
Story* checks off one by one. Every decision is behind the seam; the shell converts nothing, refuses
nothing, orders nothing and groups nothing.

**§ 9.0 and § 9.1 grew on 2026-09-08**, when settled answer 26 kept the cross-group drag that a
`Section` per group costs `.onMove`. The measurement that answer required was made before this was
written and is in `design.md` § *Context*: **ADR-1019 stands untouched and no record is owed**,
because `dropDestination` hands the shell an index and the shell already holds the group. Nothing
below computes anything, and § 9.1's stop says what to do if that stops being true.

- [x] 9.0 `CommitmentsView.swift` — add the drag payload, a shell-local
  `struct DraggedRow: Codable, Transferable` holding **the source section's `category: String?` and
  the row's `offset: Int` within that section's `ForEach`** — two values the shell is handed when it
  draws the row, and no third. A `Commitment` cannot be the payload: `.draggable` needs
  `Transferable`, `CommitmentRecord` is internal to the kit, and this change opens neither
  (`design.md` § *Context*). Give it a `CodableRepresentation`; the probe in `design.md` § *Context*
  used `UTType.content` and a narrower exported type is equally fine and changes nothing across the
  seam. Add the one resolver beside it —
  `screen.keptGroups.first { $0.category == dragged.category }?.commitments[dragged.offset]`,
  **guarded against an offset the group no longer has**, returning nothing rather than clamping.
  A lookup that finds nothing does nothing and says nothing.
- [x] 9.1 `CommitmentsView.swift` — draw the kept list as **a `Section` per group over
  `screen.keptGroups`**: the category as the section's header, no header on the group with none, and
  one `ForEach` per section over that group's commitments carrying **three** things — `.draggable`
  on each row with § 9.0's payload, and `.onMove` and `.dropDestination(for: DraggedRow.self)` on
  the `ForEach`. **This reverses what this box said before 2026-09-08** — `design.md` § *The shell
  rides this Story* and § *Open Questions* 1 and 6 are why. Both closures pass two things and compute
  nothing: the section's own `group.category`, and the destination `Int` untouched, into
  `screen.move(_:toOffset:under:)`. **Delete `keptGroupHeadings`** — the offset map is what a
  section makes unnecessary, and a shell that counts nothing is what ADR-1019's guard is asking for.
  The stopped list keeps its own single section and wants a header saying so, since it is now one
  section among several.

  **The stop.** If either closure turns out to need a line that adds, subtracts, counts rows or asks
  where a finger is — in particular if you reach for `dropDestination`'s `CGPoint` overload, which is
  `unavailable` on `DynamicViewContent` by name — **stop and report it**. That is arithmetic in the
  shell, it is what ADR-1019's guard forbids, and it would mean the measurement `design.md`
  § *Context* rests on was wrong. It is a G4 question and an ADR-1019 amendment, not a line to write.
- [x] 9.2 `CommitmentsView.swift` — add the category field to the define form, offering
  `screen.categoriesInUse` alongside free text, and pass whatever is in it to `screen.define` as the
  fourth argument. The field starts empty, and is cleared on a definition that is not refused,
  exactly as the name field already is.
- [x] 9.3 `CommitmentsView.swift` — add a way to change a kept commitment's category, calling
  `screen.put(_:under:)`, and add the sixth `RefusedChange` case to the existing refusal rendering
  beside `.stopping`, `.keepingAgain`, `.removing` and `.moving`, using `refusalText` unchanged. No
  new sentence is invented here.
- [x] 9.4 `ContentView.swift` — draw the day view's `groups` as **a `Section` each**, the category as
  the header and no header on the group with none, and **delete `groupHeadings`** for the same
  reason § 9.1 deletes its twin. The tick behaviour on a row does not change, and neither does the
  reason its `ForEach` is keyed on position rather than on the row's value: the offset within its own
  group's `ForEach` is stable across a tap exactly as the flat offset was. This is where the day
  screen's half of the missing boundary comes from (`grill.md` § *Settled* 25).
- [ ] 9.5 **Run it again.** `pnpm run phone`, or the simulator per `docs/running-the-app.md`, and
  check by hand: type a category on the form and find the group appear; pick an offered category
  rather than typing it; empty the field and find the row rejoin the ungrouped rows; drag a row — in Edit mode or by a
  long-press lift, § 9.5's own watch-item below — to the **bottom of its own group** and find it
  stay in that group — that is the defect
  this rewrite exists for, so check it before anything else; drag a row from one group into another
  and find it refiled where it was dropped; drag a row into the ungrouped rows and find its category
  gone; drop a row where it started and find nothing said; and open the day screen and find the same
  groups in the same places. Note what was seen in the PR.

  **Three things to look at that are not requirements**, and none of them is a change to the delta:
  whether the heading now stays put while its row is dragged, and whether the boundary before the
  ungrouped rows is visible on **both** screens (`grill.md` § *Settled* 25 — a `Section` per group
  should give all three for nothing, and if it does not, say so rather than inventing a heading,
  because settled answer 11 stands); and whether a group whose first row is dragged away moving on
  screen reads as a bug (`design.md` § *Risks*).

  **And one thing to watch that no header file settles.** With rows `.draggable` and each section's
  `ForEach` carrying both `.onMove` and `.dropDestination`, which of the two delivers a drag that
  starts and ends **inside one group** is behaviour rather than API (`design.md` § *The shell rides
  this Story*). Either is fine — both call `screen.move` with the same three arguments, and the
  requirement makes a drop where a row already sits change nothing. **A drop delivered twice is a
  stop**: report it rather than suppressing one of the two, because which one to drop is a shell
  decision worth reading in a diff. Say in the PR which one fired.

  Anything else that reads badly is a want in `docs/backlog.md` or a question for the owner, **not**
  a change to this delta without a further G4.

## 10. The records

**Four of them were written at G4 and are in the diff the owner signed**, because `docs/adr/**` and
`CONTEXT.md` are `spec-author`'s to write and not `implementer`'s (`AGENTS.md` § *Agent roles*). The
boxes below confirm rather than write, and each is tickable while reading what is already there:

- [x] 10.1 Confirm `docs/adr/1038-a-category-is-the-rosters.md` still describes what shipped — a
  category held by the roster against a commitment rather than as a fifth part of one, and the
  grouping rule on the roster with it — and that its ADR-1023 and ADR-1030 reading is the one the
  implementation bore out. **Its number was checked against every remote branch, not against `main`
  alone**: `main` ends at 1037 and `origin/story/139-add-number-entry` holds
  `1036-a-notice-names-a-cause-a-person-can-act-on.md`. Re-confirm with
  `git ls-tree -r --name-only <branch> -- docs/adr` over every remote before the review, and report
  a collision rather than renumbering silently.
- [x] 10.2 Confirm the ADR-1038 row is in `docs/adr/README.md`'s DayByDay table and reads true.
- [x] 10.3 Confirm `docs/adr/1031-a-store-reads-the-form-before-it.md` § *A fourth form, and a field
  that has to be written* matches what was built: `categoryIntroducedInVersion = 4`, one comparison
  rather than a decode path per form, and `category` written as an explicit `null` on every form-4
  entry. **If the implementation needed a second decode path after all, stop and report it** — that
  is a different amendment and the owner's call, not an edit to slip in here.
- [x] 10.4 Confirm `CONTEXT.md` § *Day view*'s **Corrected 2026-09-08** paragraph is still true of
  the code: the day view is handed its groups and makes no ordering of its own. If `DayView` ended
  up working out a placement, that is a stop — it would mean `day-screen`'s oldest requirement needed
  carrying after all, which is a G4 question (`design.md` § *Where the grouping is worked out*).
- [x] 10.5 Leave `docs/adr/1030-the-kind-is-a-commitments-fourth-part.md` and
  `docs/adr/1037-a-rosters-order-is-the-persons.md` alone, and confirm before the review that
  leaving them alone is still right: the kind is still the commitment's fourth part and still never
  changes, and a move is still the only thing that changes a roster's order. If either stopped being
  true during the implementation, that is a stop rather than an ADR edit to slip in.
- [x] 10.6 Leave `docs/backlog.md` alone. B-029 and B-030 are both answered by this Story, and moving
  a want from § *Wants* to § *Decided* is a grooming pass's act rather than a Story branch's
  (`grill.md` § *Left open* 1). Confirm that neither has been moved by this branch before the review.

## 11. Before the review, and what the janitor does at the archive

- [x] 11.1 `cd src/DayByDayKit && swift test` — every test green, and the count is 705: the 628
  `85ca63b` carries — § 11.3's rebase moved the base there from `f8236be`'s 580 — plus the 77
  scenarios above. **That is eight fewer than the 713 this box asked for before 2026-09-08**: nine
  mark tests are deleted at § 7.0 and one is added at § 7.6. From the repo root, `pnpm run verify`
  green and `pnpm run checks` reporting `206/206 scenario(s) covered`.
- [x] 11.2 `openspec validate add-commitment-category --strict` exits 0, and `openspec validate --all
  --strict --no-interactive` exits 0.
- [ ] 11.3 Rebase onto current `main` and push with `--force-with-lease`. A conflict inside
  `openspec/changes/add-commitment-category/` or anywhere under `openspec/specs/` is a **stop**, not
  a merge to resolve (rule 5). **And so is a clean rebase that then fails § 11.2** — that is another
  Story having landed on `day-screen`, which § 1.3 warned about and which needs a further G4 rather
  than a quiet refresh of the delta.

  **This rebase is already owed and it is yours.** `add-note-record` (#169) merged on 2026-09-08,
  after this branch's base, and changed `DayView.swift`, `DayScreen.swift`, `ContentView.swift`,
  `DayScreenTests.swift`, `DayViewTests.swift` and `CommitmentsScreenTests.swift` — all of which
  this branch's implementation commits also changed. `docs/adr/README.md` conflicts too, on the ADR
  table: `main` now holds **1039** and this branch **1038**, both rows are wanted, and numeric order
  is the resolution. None of that is the stop above: nothing in `openspec/` conflicts, and the delta
  was validated against `main`'s specs on 2026-09-08 with all fourteen MODIFIED requirements intact
  (`design.md` § *Risks*). It is ordinary merge work, it is `implementer`'s and not
  `spec-author`'s, and it is why the branch handed over at G4 sits two commits behind `main`.
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
  is shown again or a change is kept, and cannot-read) — plus three `## ADDED Requirements`
  (*A roster puts a commitment under a category*, *A roster reads the commitments it is keeping in
  groups, one per category*, and *A commitments screen puts a commitment under a category, and
  offers the categories in use*). `specs/day-screen/spec.md` carries two `## MODIFIED Requirements`
  (*A day view is a value* and *A day screen draws the commitments its roster had not stopped keeping
  on the day it is showing*) and one `## ADDED Requirement` (*A day view draws its rows in the groups
  it was handed, and draws no group with nothing due*). **None of these fourteen MODIFIED
  requirements is renamed anywhere in this delta** — only prose inside each changes, and no scenario
  is dropped or retitled. So after `/opsx:archive` runs, read the recomposed
  `openspec/specs/commitment/spec.md` and `openspec/specs/day-screen/spec.md` and confirm that each
  of those fourteen still sits at the same place in requirement order it held before this archive,
  that the three ADDED `commitment` requirements landed in `commitment` and nowhere else and the one
  ADDED `day-screen` requirement in `day-screen`, and that `openspec validate --archived` exits 0.
  Any drift — a requirement moved, dropped, or reworded beyond this delta's own MODIFIED text — is
  **a stop and a report, never a hand-edit** (rule 2): `openspec/specs/` is written by
  `/opsx:archive` and by nothing else, and the archived folder is denied to every editor.
