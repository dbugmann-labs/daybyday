A command that fails or does something unexplained is a stop and a report, not a thing to work
around (`AGENTS.md` rule 5). Rule 3 throughout: one scenario, one acceptance test named identically
to it, one red-green cycle.

## 1. Before a line is written

- [x] 1.1 Confirm the starting point and report rather than work around a different one. From
  `src/DayByDayKit`, record what `swift test` reports as the number of tests passing, measured on
  this branch as it stands at G4. From the repo root, `pnpm run check:scenarios` reports
  `335/433 scenario(s) covered` for this change and names *"two commitments formed alike in every
  part are two different commitments"* as next. **Those 335 are the scenarios this delta carries
  verbatim from the current specs.**
- [x] 1.2 Read § 1.3 before touching a carried test. Of the **329** scenarios this delta still
  carries verbatim, **seventy-seven are named in § 1.3** and their tests change with them; **six more
  carried tests are renamed**, named in § 1.3 under the acts that replace theirs, and their
  scenarios are no longer among the 329; and **two more are retired rather than edited**, named in
  § 1.3 at the end. Every other carried test must come through this change
  with its name, its fixture and its assertions untouched. A carried test that has to be edited and
  is not named in § 1.3 is the design being wrong: stop and report it.
- [x] 1.3 The thirteen carried scenarios whose bodies this delta edits, each edited to say an era
  where it said a removed commitment, or to assert the record place untouched where it asserted a
  carry-over: *a mixed chain's whole sums its months' due days and its weeks' quotas alike*; *a
  look-back says a weekday era's months and a quota era's weeks, each in its own unit*; *a week two
  quota eras share says its kept days out of the newer era's quota*; *a number commitment's
  look-back says the number the era holding a day kept*; *a number commitment's graph widens to hold a value
  outside its newest era's range*; *a look-back says nothing between the lines either
  side of a boundary*; *a number commitment's graph says nothing where one era gives way to the
  next*; *an interval commitment's day kept from moved earlier by a whole number of intervals leaves
  every recorded day due*; *a change a commitments screen could not keep leaves both places as they
  were*; *changing the rhythm or the day kept from of a stopped commitment is refused*; *a change
  refuses a range that is not a range and a target that is not a target*; *an interval commitment
  whose start differs from the day it is kept from is renamed and every day recorded on stays due*;
  *a refusal that a roster could not be written is about the whole change and no field*.
  **And these carried tests, whose fixture or assertion this delta edits although their scenario
  names do not change.** **Three rest on value equality between commitments formed on their own** —
  *a commitment taken up again can be stopped again, on a new day*, *taking a commitment up
  again puts it back in the answer for the dates between* and *a commitment moved and then stopped
  is taken up again in the place it was moved to* (`RosterTests`): each fixture offers the roster
  the original commitment again rather than forming a second one alike to it. **Three form an earlier
  era on its own and supersede it in** — *a look-back counts the era behind the one it was asked
  about*, *a look-back says the newest era's rhythm and the earliest era's day kept from* and *a
  look-back chains an era whose range or target differs behind the one it was asked about*: each
  fixture forms the newer era of the commitment it follows and puts that era on. **One asserts the
  equality itself** — *a commitment formed without a kind is of the plain kind*: the assertion
  compares the two kinds rather than the two commitments. **One reads the record place where the
  delta now reads a look-back** — *a rhythm changed through a commitments screen leaves every record
  already made standing*. **And eleven name `Refusal.alreadyKept`, which goes** — *a commitments
  screen that could not keep a new commitment says the roster could not be written*, *a commitments
  screen holds a refused change against the commitment it was asked to change*, *what a commitments
  screen holds about a refused change ends when a change to a commitment is kept*, *what a
  commitments screen holds about a refused change stands when a change names what is already there*,
  *what a commitments screen tells at the foot of its sheet stands when a field is edited*, *what a
  commitments screen tells on its sheet ends when the sheet is closed*, *a folder refused is held
  apart from a refused change, and ends when the app is shown again*, *a call that keeps nothing
  writes no copy at the copy place*, *a copy that could not be made is not held as a refused
  change*, *a take-out made leaves a refused change standing and says nothing of its own* and *a
  take-out refused replaces the refused change a commitments screen held*: each assertion names the
  name refusal in its place, but for *what a commitments screen tells at the foot of its sheet stands
  when a field is edited*, whose whole-change refusal is now a roster place that could not be
  written. **And seven more the name rule reaches, whose bodies this delta edits as well.** **Four
  reach two commitments of one name the one way a roster can now hold them, through the fold** — *a
  stopped entry says the rhythm its commitment runs on, as a kept entry does*, *two commitments alike
  in name and not in rhythm are told apart by the rhythm their entries say*, *two commitments alike
  in name and in rhythm are two entries that say the same thing* and *removing one of two entries
  alike in name removes the one it was asked about*: each opens on a roster stored in the form before
  identities rather than taking two commitments on. **Two offer the same commitment again where they
  formed a second alike to it** — *a commitment taken up again through a roster store is read back
  kept, in the place it was taken on in* and *a commitment taken up again through a roster store
  after being removed is read back kept*. **And one holds an era twice where it held a commitment
  twice by value** — *a roster store holding what could not be a roster is refused*: its third place
  holds one identity, kept from one day, twice.
  **And thirty-eight more, every one red only because equality is the identity, each with the edit
  it takes.** **Eleven in `RosterStoreTests` whose scenario says the commitments are taken on
  *through a roster store* while the test hand-writes a document in a form before identities** —
  *a move that leaves a roster as it was keeps nothing at its place*, *a category change that leaves
  a roster as it was keeps nothing at its place*, *a group move that leaves a group where it is keeps
  nothing at a roster store's place*, *a change of a commitment for itself keeps nothing at a roster
  store's place*, *a stop a roster store refuses for a removed commitment is reported and nothing at
  its place changes*, *a move a roster store refuses for a stopped commitment is reported and nothing
  at its place changes*, *a move a roster store refuses for a removed commitment is reported and
  nothing at its place changes*, *a move a roster store refuses for an offset it does not have is
  reported and nothing at its place changes*, *a category change a roster store refuses for a
  commitment it does not hold is reported and nothing at its place changes*, *a category change a
  roster store refuses for a removed commitment is reported and nothing at its place changes* and
  *a change a roster store refuses for a commitment it does not hold is reported and nothing at its
  place changes*: each seeds its place through the store, as its scenario says, so the identities its
  assertions name are the ones on disk. The four no-op tests among them lay their bytes out by hand
  on purpose, to prove the no-op check is no byte comparison — keep that, in the form this app writes
  and carrying the identity each assertion reuses.
  **Seven in `RosterStoreTests` whose scenario does name an earlier form** — *a roster kept before a
  commitment carried a kind is read with every commitment of the plain kind*, *a commitment of another
  kind taken on over a roster kept in an earlier form is read back with its kind*, *a roster kept
  before a commitment could be removed is read with every commitment not removed*, *a commitment
  removed over a roster kept before removal existed is read back removed*, *a roster kept before a
  commitment could be put under a category is read with every commitment under none*, *a commitment
  put under a category over a roster kept before categories existed is read back under it* and *a
  change kept over a roster in an earlier form keeps every day a commitment was kept until*: each
  reads the commitment back out of the store and builds what it expects from that, in place of one
  formed alike to it.
  **Nine in `RecordStoreTests`, the same edit against the history** — *a history kept before a
  commitment carried a kind is read with every commitment of the plain kind*, *a tick added over a
  history kept in an earlier form is read back beside the ticks already there*, *a history kept before
  a day could hold a number is read, and no day in it holds a number*, *a number added over a history
  kept before a day could hold a number is read back beside the ticks already there*, *a history kept
  before a day could hold a note is read, and no day in it holds a note*, *a note added over a history
  kept before a day could hold a note is read back beside the records already there*, *a history kept
  before a day could hold an addition is read, and no day in it holds one* and *an addition made over
  a history kept before a day could hold an addition is read back beside the records already there*:
  each asks about the commitment the history read back rather than one formed alike to it, which is
  what makes *a history kept before a record carried an identity is read with every record carrying
  none* true at the same time; reaching it needs `@testable import DayByDayKit` on that file. The
  ninth, *a store holding a day whose additions sum past what can be kept exactly is read rather than
  refused*, is the exception: its scenario names the form this app writes, so its fixture declares
  that form and carries an identity.
  **Two in `DayScreenTests`** — *a commitment renamed at a day screen's places is drawn under its new
  name and still kept when the screen is returned to* renames through the roster store and carries
  nothing over, because a record now follows the identity; *a day screen draws a removed commitment
  under a category exactly as it draws a stopped one* takes one commitment on at both places, which
  is what lets the two day views be the same day view.
  **Three across `RestoreTests`, `CopyTests` and `CopyPlaceTests`** — *a commitments screen asked to
  restore says the copy's moment and what the copy and the phone keep, have stopped and hold as
  one-offs* reads the commitments it stops and removes back off the screen's own list; *a copy of a
  place kept in an earlier form is written in the form that store writes now* asks the copy's ticks
  by name and date, and compares both places' bytes against what they were immediately after the
  screen was opened, as its scenario already says; *a change reaching the record place and the roster
  place writes exactly one copy holding both* asks the copy's history about the renamed commitment
  read back, and waits on § 11 for the rename itself.
  **And six in `CommitmentsScreenTests` that define and nothing more** — *a commitment defined on each
  of the four rhythms is read back on the schedule that rhythm names*, *a commitment of each of the
  four kinds is defined through a commitments screen and kept with that kind*, *a category is kept
  exactly as it was typed on the form*, *a commitment defined under a category is drawn in that
  category's group and kept under it*, *a commitment defined under a category of nothing but blank
  space is under none and is not refused* and *a commitment defined under a category differing only in
  case from one in use is a group of its own*: each reads what the screen and the store hold back and
  judges it by name, category and kind, in place of a whole roster or group built from commitments
  formed alike. These wait on nothing in §§ 10–13; they are named here so that round does not stop.
  **And six carried tests this delta renames, because the act each drives is gone.** **Five drive
  superseding or changing one commitment for another** — *a commitment changed through a roster store
  is read back changed by a store opened afterwards* becomes *an era changed through a roster store is
  read back changed by a store opened afterwards*; *a change and a supersession a roster refuses keep
  nothing at a roster store's place* becomes *a change and a new era a roster refuses keep nothing at a
  roster store's place*; *a change of one commitment for another that cannot be kept is refused and the
  roster a store reports does not move* becomes *a change of an era that cannot be kept is refused and
  the roster a store reports does not move*; *a supersession that cannot be kept is refused and the
  roster a store reports does not move* becomes *a new era that cannot be kept is refused and the
  roster a store reports does not move*; and *a supersession a roster store refuses for a stopped
  commitment is reported and nothing at its place changes* becomes *a new era a roster store refuses to
  put on a stopped commitment is reported and nothing at its place changes*. Each drives putting a new
  era on, or changing an era for another of that commitment, in place of the act it drove.
  **And one the name rule answers the other way** — *a commitment alike in every way but the kind it
  takes is not one a commitments screen already keeps* becomes *a commitment alike in every way but
  the kind it takes is refused for the name it shares*, and its assertions reverse with it.
  **And two this delta retires rather than edits**, because the act each drives is gone and its
  scenario is in no requirement this delta keeps — *a supersession a roster store refuses for a
  removed commitment is reported and nothing at its place changes* and *a supersession a roster store
  refuses for a commitment it already holds is reported and nothing at its place changes*
  (`RosterStoreTests`), which §§ 7.3 and 7.4 already replace. A test of a REMOVED requirement is
  deleted, as § 6.17 says: passing is not a reason to keep one.
- [x] 1.4 Confirm the three facts `design.md` § *Context* rests on, and stop if any is false:
  `RosterDocument.currentVersion` is **4** and `RecordDocument.currentVersion` is **5**;
  `CopyDocument.currentVersion` is **1** and carries the other two by reference, so it does not
  move; and `RecordedDay(commitment:date:)` in `History.swift` keys numbers, notes and additions by
  the whole commitment, with `Set<Tick>` holding ticks — which is what makes equality-on-identity
  re-key every record with no change of its own.
- [x] 1.5 Declare the seam whole before the next cycle. Every member `design.md` § *The seam* names
  that `src/DayByDayKit` does not carry yet — as this is written, `Roster.rename`,
  `Roster.put(era:on:keptUntil:under:)`, `RosterDocument.Fold`, `RosterDocument.folded()`,
  `RosterStore.fold`, `RosterStore.rename`, `RosterStore.put`, `RecordStore.settle`,
  `History.settle`, `CommitmentsScreen.Refusal.nameAlreadyInUse` and
  `CommitmentsScreen.stoppedRefusal` — goes in with that section's signature and a body that only
  traps, so the package builds and anything that reaches one fails loudly. **Declaring them is not
  starting the sections that drive them**: no behaviour is written here, nothing is made to pass,
  and every box below is still taken one at a time with its test red first. The **implementer**
  ticks this once those declarations compile. A box that needs a member § *The seam* does not name
  is a stop and a report.

## 2. `Commitment` — the identity, and equality on it alone

- [x] 2.1 *two commitments formed alike in every part are two different commitments* — catches equality still reading the other four parts.
- [x] 2.2 *a commitment formed as a further era of another is the same commitment* — the era initialiser, and the one that mints.

## 3. `Roster` — a commitment's eras are the entries carrying its identity

- [x] 3.1 *a roster holding two eras of one commitment reads back one commitment it is keeping*
- [x] 3.2 *a roster says a commitment's day kept from as its earliest era's and its rhythm as its newest era's*
- [x] 3.3 *a roster answers a date with the era of a commitment that holds that day*
- [x] 3.4 *an earlier era of a stopped commitment is in neither what a roster keeps nor what it has stopped*
- [x] 3.5 *a roster holding eras of two commitments keeps each commitment's eras together*
- [x] 3.6 *a new era put on a commitment lands in that commitment's place rather than after every commitment already there*
- [x] 3.7 *stopping a commitment with two eras records the day against its newest*

## 4. `Roster` — the name refusal

- [x] 4.1 *adding a commitment whose name a roster already keeps says it was not added and leaves the roster as it was*
- [x] 4.2 *a commitment whose name a roster already keeps is refused whatever else differs*
- [x] 4.3 *a commitment whose name a roster has stopped keeping already has is refused*
- [x] 4.4 *a name a roster has only removed a commitment under is free* — catches the refusal counting removed entries.
- [x] 4.5 *two names differing only in the case of a letter are one name and the second is refused*
- [x] 4.6 *two names differing by blank space inside them are two names and both are held*
- [x] 4.7 *a commitment offered again as itself where the roster has stopped keeping it takes it up again*
- [x] 4.8 *a commitment offered again as itself is taken up again in the place it was taken on in*
- [x] 4.9 *taking a stopped commitment up again is refused where a commitment the roster keeps already has its name* — the resume path, not the add path.
- [x] 4.10 *a commitment offered again as itself where the roster has removed it takes it up again*

## 5. `Roster` — renaming through every era

- [x] 5.1 *renaming a commitment writes the new name on every era of it*
- [x] 5.2 *a renamed commitment keeps its place, its category and its state*
- [x] 5.3 *renaming a commitment a roster does not hold is refused and leaves the roster as it was*
- [x] 5.4 *renaming a commitment to a name another commitment already has is refused*
- [x] 5.5 *renaming a commitment to the name it already has changes nothing and is not refused* — catches a commitment colliding with itself.
- [x] 5.6 *renaming a commitment on a copy of a roster leaves the roster it was copied from unchanged*

## 6. `Roster` — putting a new era on, and changing one

- [x] 6.1 *a new era takes the place the commitment held and becomes its newest*
- [x] 6.2 *the era a new one gives way to carries the day it was kept until and sits behind it*
- [x] 6.3 *a commitment a new era is put on is put under the category it was offered under*
- [x] 6.4 *putting an era on a commitment a roster is not keeping is refused*
- [x] 6.5 *putting an era that is not of that commitment on it is refused* — identity, name and kind sort, each on its own.
- [x] 6.6 *an era put on as of a day before the day the era it gives way to is kept from leaves it holding no day* — no era is dropped here; #305 is where that lands.
- [x] 6.7 *an era put on as of the first supported date and one as of the last are both accepted*
- [x] 6.8 *a third era put on a commitment leaves it one commitment with three eras*
- [x] 6.9 *putting an era on a copy of a roster leaves the roster it was copied from unchanged*
- [x] 6.10 *changing an era puts the result in the place the one it replaced held*
- [x] 6.11 *changing the earliest era of a commitment with two leaves the newer one alone*
- [x] 6.12 *changing an era for one of another commitment is refused*
- [x] 6.13 *changing an era a roster does not hold is refused and leaves the roster as it was*
- [x] 6.14 *changing an era of a stopped commitment leaves it stopped, on the day it was kept until*
- [x] 6.15 *changing an era for itself under a different category puts its commitment under that category*
- [x] 6.16 *changing an era on a copy of a roster leaves the roster it was copied from unchanged*
- [x] 6.17 Retire the tests of the two requirements this section replaces. `RosterTests` still
  carries all twenty-one of them, and a test of a REMOVED requirement is deleted — never kept red,
  never weakened, never renamed onto a title above, which §§ 2–6 have already taken. Nothing else
  in this file retires one: § 1.3 governs carried tests only, and § 17.1 reaches just the eight
  already red, because `Roster.supersede(_:with:keptUntil:under:)` is still there and the rest
  still drive `Roster.change(_:to:under:)` — whose old meaning goes with them, as `design.md`
  § *The seam* says. Passing is not a reason to keep one. **The nine of *A roster changes a
  commitment it holds for another, in the place it holds it*** — *changing a commitment a roster
  holds puts the result in the place the one it replaced held*, *a changed commitment is put under
  the category the change was offered under*, *changing a commitment a roster has stopped keeping
  leaves it stopped, on the day it was kept until*, *changing a commitment a roster has removed
  leaves it removed*, *changing a commitment a roster does not hold is refused and leaves the
  roster as it was*, *changing a commitment into one the roster already holds is refused, whichever
  state it holds it in*, *changing a commitment for itself changes nothing and is not refused*,
  *changing a commitment on a copy of a roster leaves the roster it was copied from unchanged* and
  *changing a commitment for itself under a different category puts it under that category and
  changes nothing else*. **And the twelve of *A roster supersedes a commitment it is keeping with
  another, from a day*** — *superseding a commitment takes the other one on in the place the
  superseded one held*, *a superseded commitment is held removed, on the day it was kept until*,
  *the commitment that supersedes another is put under the category it was offered under*,
  *superseding a commitment a roster is not keeping is refused*, *superseding a commitment with one
  the roster already holds is refused*, *a commitment superseded as of a day before the day it is
  kept from was kept on no date*, *a superseded commitment stays where it was for every date the
  roster answers about*, *superseding on a copy of a roster leaves the roster it was copied from
  unchanged*, *a commitment superseded as of the first supported date and one as of the last are
  both accepted*, *a roster supersedes a commitment with one on a schedule due on no day*,
  *superseding a commitment with one the roster has stopped keeping is refused* and *superseding a
  commitment with one the roster has removed is refused*. The **implementer** ticks this once
  `RosterTests` carries none of the twenty-one.

## 7. The forms on disk

- [x] 7.1 *a commitment with two eras kept through a roster store is read back as one commitment with two eras*
- [x] 7.2 *a roster store read back holds the same commitments rather than commitments alike to them* — catches an identity reissued on a write.
- [x] 7.3 *an era a roster store refuses to put on a removed commitment is reported and nothing at its place changes*
- [x] 7.4 *an era a roster store refuses to put on because it is not that commitment's is reported and nothing at its place changes*
- [x] 7.5 *a roster store declaring a form written before identities and saying something about one is refused*
- [x] 7.6 *a roster store declaring the form this app writes and saying nothing about an identity is refused*
- [x] 7.7 *a record is read back as a record of the same commitment rather than one alike to it*
- [x] 7.8 *a record of an era is read back under the commitment whose era it is*
- [x] 7.9 *a store whose shape and declared form disagree about identities is refused*
- [x] 7.10 *a history kept before a record carried an identity is read with every record carrying none* — reading form 5, before any screen settles it.
- [x] 7.11 *an era changed through a roster store is read back changed by a store opened afterwards* — rename the carried test named in § 1.3, do not write a second.
- [x] 7.12 *a change and a new era a roster refuses keep nothing at a roster store's place* — rename the carried test named in § 1.3.
- [x] 7.13 *a change of an era that cannot be kept is refused and the roster a store reports does not move* — rename the carried test named in § 1.3.
- [x] 7.14 *a new era that cannot be kept is refused and the roster a store reports does not move* — rename the carried test named in § 1.3.
- [x] 7.15 *a new era a roster store refuses to put on a stopped commitment is reported and nothing at its place changes* — the stopped twin of 7.3; rename the carried test named in § 1.3.
- [x] 7.16 Edit the carried tests § 1.3 names in `RosterStoreTests`, `RecordStoreTests`,
  `DayScreenTests`, `RestoreTests`, `CopyTests` and `CopyPlaceTests`, each to the edit named there
  and nothing else in it, and retire the two `RosterStoreTests` tests § 1.3 names as retired. Those
  six files and no others; a test that has to be edited and is not named in § 1.3 is a stop and a
  report, as § 1.2 says, never a test quietly weakened. Then run the full `swift test` from
  `src/DayByDayKit`. The **implementer** ticks this in the commit that makes it true, when every test
  outside `CommitmentsScreenTests` and `LookBackTests` is green but the one that turns on work this
  box does not do: *a change reaching the record place and the roster place writes exactly one copy
  holding both*, which waits on § 11's rename. *A roster store holding a commitment again after
  holding it stopped or removed is refused* is § 8.9's, not this box's — do not edit it here.

## 8. The fold, at the roster place

- [x] 8.1 *a chain of removed entries folds into the eras of the commitment in front of it*
- [x] 8.2 *a removed entry nothing kept or stopped resembles is dropped by the fold* — the erasure the owner chose; drive it from a document, never a file.
- [x] 8.3 *a removed entry that resembles a live commitment but chains to nothing becomes a stopped commitment*
- [x] 8.4 *the fold takes the nearest of two removed entries that both chain* — roster order decides, not the day.
- [x] 8.5 *a removed entry of another kind sort does not fold as an era*
- [x] 8.6 *an era whose range differs folds behind the commitment in front of it*
- [x] 8.7 *the fold leaves two commitments holding one name where the stored roster held two*
- [x] 8.8 *folding a roster changes nothing at its place, and the next change is written in the form this app writes*
- [x] 8.9 Make the fold refuse a roster kept before identities that holds two entries whose
  commitments are alike in every part, which *A roster store that cannot be read is refused rather
  than emptied* now states and `RosterDocument.folded()` does not meet: `formRoster()` carries the
  guard for the form this app writes, one identity kept from one day twice; `folded()` mints an
  identity per entry, so nothing there can ever see the same era held twice, and two such entries
  collide silently in the mapping it hands back. **Write no new test** — two carried tests already
  assert it and are red: *a roster store holding a commitment again after holding it stopped or
  removed is refused* (`RosterStoreTests`) and *a commitments screen whose roster holds what could
  not be a roster says it is not keeping one* (`CommitmentsScreenTests`), each opening a place
  holding one commitment record twice. Neither is a carried test § 1.3 edits: they are this box's
  tests and their fixtures and assertions stand as they are. The **implementer** ticks this when
  both are green.

## 9. The fold, at the record place

- [x] 9.1 *a record kept against an era that folded is read back under the commitment it folded into*
- [x] 9.2 *a record kept against an entry the fold dropped is dropped with it*
- [x] 9.3 *a record whose commitment the folded roster never held is left as an orphan* — carries no identity, and the shipped carry-back rule takes it.
- [x] 9.4 *a day screen opened on a folded roster carries the records too*
- [x] 9.5 *a screen that cannot read its record place leaves a folded roster's records alone*
- [x] 9.6 *a record of an era a roster holds is not an orphan*

## 10. `CommitmentsScreen` — defining, and the name refusal

- [x] 10.1 *a commitments screen refuses a name a commitment its roster is already keeping has*
- [x] 10.2 *a commitments screen refuses a name that differs only in case or in blank space at its ends*
- [x] 10.3 *a commitments screen refuses a name a commitment its roster has stopped keeping has*
- [x] 10.4 *a commitments screen takes on a name only a commitment its roster has removed has*
- [x] 10.5 *a commitment a commitments screen refuses for its name is not taken on a second time*
- [x] 10.6 *a commitment defined through a commitments screen carries an identity of its own*
- [x] 10.7 *a commitment defined under the name a removed commitment has is taken on last, under the category the form carried*
- [x] 10.8 *taking a commitment up again is refused where a commitment the screen keeps already has its name*
- [x] 10.9 *an earlier era of a commitment is in neither of a commitments screen's lists*
- [x] 10.10 *a refusal that a name is already in use is about the name field*
- [x] 10.11 *a commitment alike in every way but the kind it takes is refused for the name it shares* — rename the carried test named in § 1.3 and reverse its assertions; the name rule reads no kind.

## 11. `CommitmentsScreen` — the three acts a change needs

- [x] 11.1 *a renamed commitment keeps every record already made, and the record place is not written*
- [x] 11.2 *a rename through a commitments screen reaches every era of the commitment*
- [x] 11.3 *a commitment whose rhythm is changed through a commitments screen is given a new era from today*
- [x] 11.4 *a name and a rhythm changed in one save put the new name on every era*
- [x] 11.5 *the day a commitment is kept from is moved onto a later era and the eras it leaves no day for are dropped* — grill § Settled 2.
- [x] 11.6 *a rhythm changed on the first date the calendar supports puts the new era on as of that day itself*
- [x] 11.7 *a name, an earlier day kept from and a rhythm changed in one save reach every era*
- [x] 11.8 *a change writes nothing at the record place, whatever it changes* — the one box that proves the carry-over is gone.
- [x] 11.9 *a change of rhythm through a commitments screen puts the commitment under the category it was given*
- [x] 11.10 *a commitment whose range is changed through a commitments screen is given a new era from today*
- [x] 11.11 *a target changed through a commitments screen puts a new era on and leaves every record standing*
- [x] 11.12 *a range added to a number commitment carrying none, and one taken off, each put a new era on*
- [x] 11.13 *a commitments screen says a commitment's earliest era's day kept from and its newest era's rhythm*
- [x] 11.14 *an interval commitment whose start differs from the day it is kept from is renamed on a new rhythm and the era it gives way to keeps its start*

## 12. `CommitmentsScreen` — the refusals, and the restart

- [x] 12.1 *a change to a name another commitment already has is refused, kept or stopped alike*
- [x] 12.2 *a name and a rhythm changed in one save onto a name another commitment has are refused*
- [x] 12.3 *a change naming the name the commitment already has is not refused for it*
- [x] 12.4 *a change to a name only a removed commitment has is not refused* — the removed state holds no name.
- [x] 12.5 *restarting an interval commitment moves no record and writes nothing at the record place*
- [x] 12.6 *a restart is refused for no name and for no record already kept*
- [x] 12.7 *a restart refused for a day already recorded on is about the restart day field*

## 13. `look-back` — eras read off the identity

- [x] 13.1 *a look-back chains every era of the commitment it was asked about*
- [x] 13.2 *a look-back reaches no era of another commitment however alike it is* — catches resemblance surviving anywhere in the chain.
- [x] 13.3 Retire the tests of the requirement this section replaces. `LookBackTests` still carries
  all eight of *A look-back reads a commitment's earlier eras off the roster by resemblance*, and a
  test of a REMOVED requirement is deleted — never kept red, never weakened, never renamed onto a
  title above, which 13.1 and 13.2 have already taken. **Three of the eight are not retired**:
  *a look-back counts the era behind the one it was asked about*, *a look-back says the newest era's
  rhythm and the earliest era's day kept from* and *a look-back chains an era whose range or target
  differs behind the one it was asked about* carry into the requirement this section adds and are
  carried tests § 1.3 edits. **The five that go** — *a look-back chains every era behind the one it
  was asked about*, *a removed commitment of another name or another kind is not an earlier era*, *a
  removed commitment kept until any day but the day before is not an earlier era*, *a look-back takes
  the nearest of two removed commitments that both answer* and *an era the roster has taken up again
  is kept rather than removed and ends a chain*. Four of the five pass today, because resemblance
  still answers where an identity has not been asked for: passing is not a reason to keep one. The
  **implementer** ticks this once `LookBackTests` carries none of the five.

## 14. The shell

- [x] 14.1 Draw the name refusal under the name field of the sheet in `CommitmentsView.swift`, in
  the slot #261 gave every field refusal, as the sentence the seam hands over already said. It
  wraps and is never truncated (ADR-1022); the shell must not build the sentence or quote the name
  itself.
- [x] 14.2 Replace the `Text("Already being kept.")` at the foot of the sheet with nothing: the
  refusal it stood for is gone, and the name refusal is the field caption above.
- [x] 14.3 Draw the resume refusal in the stopped row's existing footer, from the same seam, as the
  sentence that names the commitment already kept.

## 15. The documents

- [x] 15.1 Amend ADR-1023, ADR-1030, ADR-1035 and ADR-1055 in place, one dated line each, newest
  first where an amendment list already exists; do not rewrite the decision each records.
- [x] 15.2 Write the ADR for a commitment's identity — what it is, why equality is it alone, and why
  an era is an entry rather than a list the commitment owns — and add its line to `docs/adr/README.md`.
- [x] 15.3 Correct the stale "nothing reads a chain" sentence under `CONTEXT.md` § *Superseding*,
  and the line it left behind in `docs/open-questions.md`, in the same commit as § 15.2.
  **The terms are already landed** — **Identity**, **Era** and the **Removed** amendment went in
  with the change folder — so this box is that one sentence and that one line, nothing else in
  `CONTEXT.md`.

## 16. The walk

- [ ] 16.1 The sheet with a second "Gym" typed in and saved — the refusal naming "Gym" under the
  name field, and the first "Gym" still the only row on the kept list.
- [ ] 16.2 The sheet reopened on "Gym" after its rhythm was changed through it — the rhythm now the
  new one and *Kept from* still the day the commitment was first kept from.
- [ ] 16.3 The look-back at "Gym" renamed "Lifting" — the head reading "Lifting", the day kept from
  the original one, and month lines running across the day the rhythm changed with nothing between.
- [ ] 16.4 The day screen a few days back, before the rhythm changed — the row drawn under
  "Lifting".
- [ ] 16.5 `phone:` the fold on the owner's own roster, after this build installs over the last —
  the stopped list showing what survived, and one tangled commitment's look-back reading as one.
  The simulator cannot show it: the walk starts from a fresh install and nothing seeds an old
  roster.
- [ ] 16.6 Post the pictures to the PR with `pnpm run walk -- --post-only <pr>` before hand-back,
  and tick this on the comment's URL. Never `gh pr comment --attach`, which posts at full width.

## 17. Gates and the archive handover

- [ ] 17.1 `pnpm run verify` green, and `swift test` from `src/DayByDayKit` reporting every test
  passing, the count read off the run and not derived.
- [ ] 17.2 `openspec validate give-a-commitment-an-identity --strict` exits 0 and
  `pnpm run checks` is clean but for what it is expected to warn.
- [ ] 17.3 **G7** — the reviewer's findings answered, and the PR rebased onto current `main`.
- [ ] 17.4 The **implementer** ticks this box in its last commit before the archive, on the evidence
  that everything the janitor needs is in place: the change folder is committed, `tasks.md` has no
  unticked box left, and the walk comment's URL is in § 16.6. The janitor then runs
  `/opsx:archive`, and checks afterwards that `openspec/specs/commitment/spec.md`,
  `openspec/specs/look-back/spec.md` and `openspec/specs/record/spec.md` each carry every ADDED
  requirement, no REMOVED one, and the MODIFIED ones whole. **Any drift there is a stop and a
  report, never a hand-edit** — `openspec/changes/archive/**` is denied to every agent.
