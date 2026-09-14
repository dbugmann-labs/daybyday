## 1. Before a box is ticked

**Anything that fails or surprises is a stop and a report, never a workaround** (`AGENTS.md`
rule 5). That includes a carried block that is not byte-for-byte today's spec, a rebase conflict in
this folder, in `docs/adr/` or in `openspec/specs/`, a red whose fix reaches beyond its scenario, and
a `src/` change beyond `design.md` § *The seam* and § *Three reds*.

This is a covering Story. Each box in § 3 is one red-green cycle: write the one test named for the
scenario, then run it. Green on arrival is accepted. A red is fixed with the least change that turns
that test green, named in the PR body. A byte check in a store-refusal or record-place test uses
`design.md`'s route 1. Never run the `DayByDayUITests` bundle.

## 2. The carried requirements

- [ ] 2.1 `git diff --no-index` of each carried block against the current spec shows only its appended scenarios and the rewordings `design.md` lists

## 3. The ninety-six scenarios — one test each

`RosterTests.swift`:

- [x] 3.1 two total commitments alike in every way but the target their kind carries are both held — catches a target left out of sameness
- [x] 3.2 a roster takes on a commitment on a schedule due on no day — catches a roster judging a schedule
- [x] 3.3 a roster takes on a commitment offered under a category of nothing but blank space, under none — catches a blank category refused on add
- [x] 3.4 a superseded commitment is still under the category it was under — catches a supersession dropping the old category
- [x] 3.5 a roster that had stopped keeping or removed everything it holds before a date reads back no groups on that date — catches an empty group for a date after every stop
- [x] 3.6 a roster answers in groups about a date before the day a commitment it holds is kept from — catches the kept-from day applied
- [x] 3.7 a group moved to the end is put after the last commitment under the last group, one the roster has stopped keeping included — catches the end anchor counted over kept commitments only
- [x] 3.8 an offset for a group counts no category only a commitment the roster has stopped keeping is under — catches stopped-only categories counted
- [x] 3.9 taking a commitment up again leaves the earliest day anything a roster holds is kept from as it was — catches a take-up moving the answer
- [x] 3.10 a roster answers the earliest day whatever kind the commitment kept from it takes — catches a kind filter
- [x] 3.11 a roster answers the earliest day whatever category the commitment kept from it is under — catches a category filter
- [x] 3.12 changing a commitment for itself under a different category puts it under that category and changes nothing else — catches a self-change ignoring its category
- [x] 3.13 a commitment superseded as of the first supported date and one as of the last are both accepted — catches a date bound on superseding
- [x] 3.14 a roster supersedes a commitment with one on a schedule due on no day — catches a supersession judging either schedule
- [x] 3.15 superseding a commitment with one the roster has stopped keeping is refused — catches the duplicate check over kept commitments only
- [x] 3.16 superseding a commitment with one the roster has removed is refused — catches the duplicate check skipping removed ones
- [x] 3.17 a commitment kept until the first supported date is accepted — catches a stop refusing the first date

`CommitmentTests.swift`:

- [ ] 3.18 a commitment on a weekly-quota schedule is due on every date on and after the day it is kept from — catches the quota shape not delegated
- [ ] 3.19 a commitment on a weekly-quota schedule is not due on a date before the day it is kept from — catches the floor skipped for quotas
- [ ] 3.20 a commitment reads back the rhythm it runs on in words beside its name and its kind — catches the rhythm not read back

`RosterStoreTests.swift`:

- [ ] 3.21 a name of ten thousand characters is a commitment and is read back out of a roster store whole — catches a length cap
- [ ] 3.22 a roster store given a thousand commitments holds every one of them, in the order they were given — catches a count cap or a sort by name
- [ ] 3.23 a stop that cannot be kept is refused and the roster a store reports does not move — catches the roster held before the write
- [ ] 3.24 a group move that cannot be kept is refused and the roster a store reports does not move — catches the roster held before the write
- [ ] 3.25 a change of one commitment for another that cannot be kept is refused and the roster a store reports does not move — catches the roster held before the write
- [ ] 3.26 a supersession that cannot be kept is refused and the roster a store reports does not move — catches the roster held before the write
- [ ] 3.27 a take-up-again that cannot be kept is refused and the roster a store reports does not move — catches the roster held before the write
- [ ] 3.28 a stop a roster store refuses for a removed commitment is reported and nothing at its place changes — catches a refusal thrown or written
- [ ] 3.29 a move a roster store refuses for a stopped commitment is reported and nothing at its place changes — catches a refusal thrown or written
- [ ] 3.30 a move a roster store refuses for a removed commitment is reported and nothing at its place changes — catches a refusal thrown or written
- [ ] 3.31 a move a roster store refuses for an offset it does not have is reported and nothing at its place changes — catches a refusal thrown or written
- [ ] 3.32 a category change a roster store refuses for a commitment it does not hold is reported and nothing at its place changes — catches a refusal thrown or written
- [ ] 3.33 a category change a roster store refuses for a removed commitment is reported and nothing at its place changes — catches a refusal thrown or written
- [ ] 3.34 a change a roster store refuses for a commitment it does not hold is reported and nothing at its place changes — catches a refusal thrown or written
- [ ] 3.35 a supersession a roster store refuses for a stopped commitment is reported and nothing at its place changes — catches a refusal thrown or written
- [ ] 3.36 a supersession a roster store refuses for a removed commitment is reported and nothing at its place changes — catches a refusal thrown or written
- [ ] 3.37 a supersession a roster store refuses for a commitment it already holds is reported and nothing at its place changes — catches a refusal thrown or written
- [ ] 3.38 categories differing only in case are read back out of a roster store as two categories — catches case folding
- [ ] 3.39 a roster store and a record store kept beside it change nothing at each other's place — catches one store writing the other's place
- [ ] 3.40 a change kept over a roster in an earlier form keeps every day a commitment was kept until — catches kept-until days lost on the upgrade write
- [ ] 3.41 a roster store declaring a later form whose body this app cannot read is refused as a later form — catches the body read before the form
- [ ] 3.42 a roster store holding a commitment again after holding it stopped or removed is refused — red on arrival: `formRoster` takes the second copy up again
- [ ] 3.43 a roster store holding a day kept until that names no day is refused — catches an unformed kept-until day read as kept
- [ ] 3.44 a roster store holding a commitment whose range has its lowest above its highest is refused — catches an unchecked stored range
- [ ] 3.45 a roster store holding a commitment whose target is not above zero is refused — catches an unchecked stored target
- [ ] 3.46 a roster store holding a commitment on a day of the month outside the thirty-one is refused — catches an unchecked stored day of the month
- [ ] 3.47 a roster store holding an every-N-days schedule whose start date names no day is refused — catches an unchecked stored start date
- [ ] 3.48 a category of a thousand characters is held and read back out of a roster store whole — catches a length cap
- [ ] 3.49 a category written in a script other than Latin is held and read back out of a roster store exactly — catches a script restriction

`CommitmentsScreenTests.swift`:

- [ ] 3.50 a target typed on the tick or the note kind is ignored rather than refused — catches a target read for a kind with no room
- [ ] 3.51 a range whose two ends each hold a zero-width space alone is refused as not a number rather than taken as blank — catches blank decided by a trim that drops it
- [ ] 3.52 a range end holding no digit is refused as not a number — catches no digits read as zero
- [ ] 3.53 a range end holding more than one separator is refused as not a number — catches a second separator ignored
- [ ] 3.54 a commitment defined again after being stopped takes the category the form carried — catches the old category kept
- [ ] 3.55 a commitments screen refuses a commitment whose name is empty — catches only blank space refused
- [ ] 3.56 a commitments screen accepts a name of ten thousand characters — catches a length cap at the screen
- [ ] 3.57 a stop confirmed with nothing awaiting confirmation changes nothing — catches a write with nothing awaiting
- [ ] 3.58 moving a commitment leaves a removal awaiting confirmation and what has been typed back exactly as they were — catches a move clearing the removal slot
- [ ] 3.59 a commitments screen shown again lists what has been stopped at its place since it was opened — catches only the kept list re-read
- [ ] 3.60 a commitments screen that cannot read its roster does nothing when it is asked to take a commitment up again — catches a take-up refused or written there
- [ ] 3.61 a commitments screen whose roster holds what could not be a roster says it is not keeping one — catches a second read failure told differently
- [ ] 3.62 what a commitments screen holds about a refused change ends when a change of rhythm is kept — catches the supersede branch not clearing
- [ ] 3.63 what a commitments screen holds about a refused change ends when a name and a rhythm changed in one save are kept — catches the one-save branch not clearing
- [ ] 3.64 what a commitments screen holds about a refused change ends when a change kept at both places is kept — catches a two-place change not clearing
- [ ] 3.65 a commitments screen opened has nothing awaiting removal and nothing typed back — catches a slot seeded at opening
- [ ] 3.66 a commitments screen says what a commitment it has stopped is made of — catches the four things read from kept commitments only
- [ ] 3.67 a commitment defined under a category differing only in case from one in use is a group of its own — catches case matched on define
- [ ] 3.68 a commitments screen does not drop a commitment into a group whose category differs only in case — catches case matched on a drop
- [ ] 3.69 a commitment of the total kind whose rhythm is changed through a commitments screen keeps its kind and its target — catches a supersession forming the plain kind
- [ ] 3.70 the day a commitment is kept from moved earlier through a commitments screen carries every record over, each day still due — catches a widening refused or records left behind
- [ ] 3.71 a stopped commitment put under a category through a commitments screen's change stays stopped under it — catches the category ignored on a stopped commitment
- [ ] 3.72 a name, an earlier day kept from and a rhythm changed in one save put the corrected day on the superseded commitment — catches the old day kept on the superseded one
- [ ] 3.73 a change that carries nothing over writes nothing at the record place — catches a carry-over run for a category-only change
- [ ] 3.74 a change of rhythm through a commitments screen puts the new commitment under the category it was given — catches the old category carried
- [ ] 3.75 a name and a rhythm changed in one save through a commitments screen put the new commitment under the category given — catches the old category carried
- [ ] 3.76 a change a commitments screen could not carry over at the record place is refused as a place that could not be written — catches that failure told apart
- [ ] 3.77 a change a commitments screen could not carry over at the record place leaves the roster place as it was — catches the roster place written first
- [ ] 3.78 a change refused at the roster place after its records were carried over leaves the record place as it was — red on arrival: records stay moved
- [ ] 3.79 a name and a rhythm changed in one save and refused at the roster place leave the record place as it was — red on arrival: records stay moved
- [ ] 3.80 a change of rhythm whose result the roster already holds is refused as a commitment already kept — catches the supersede branch's duplicate check
- [ ] 3.81 a name and a rhythm changed in one save whose result the roster already holds are refused as a commitment already kept — catches the one-save branch's duplicate check
- [ ] 3.82 a name, a later day kept from and a rhythm changed in one save past a day recorded on is refused — catches a one-save carry-over not simulated
- [ ] 3.83 a change of rhythm a commitments screen could not keep leaves both its lists as they were — catches lists refreshed on the supersede failure
- [ ] 3.84 a take-up-again a commitments screen could not keep leaves both its lists as they were — catches lists refreshed on failure
- [ ] 3.85 what a commitments screen holds about a refused change stands when a stop is asked about a commitment it does not keep — catches that call clearing it
- [ ] 3.86 what a commitments screen holds about a refused change stands when a removal is asked about a commitment on neither of its lists — catches that call clearing it
- [ ] 3.87 what a commitments screen holds about a refused change stands when a removal is confirmed with nothing awaiting removal — catches that call clearing it
- [ ] 3.88 what a commitments screen holds about a refused change stands when a move is asked about a commitment it does not keep — catches that call clearing it
- [ ] 3.89 what a commitments screen holds about a refused change stands when a commitment is dropped in a group it draws none of — catches that call clearing it
- [ ] 3.90 what a commitments screen holds about a refused change stands when a commitment is dropped at an offset its group does not have — catches that call clearing it
- [ ] 3.91 what a commitments screen holds about a refused change stands when a group it draws none of is moved — catches that call clearing it
- [ ] 3.92 what a commitments screen holds about a refused change stands when a group is moved to an offset its groups do not have — catches that call clearing it
- [ ] 3.93 what a commitments screen holds about a refused change stands when a change is asked about a commitment on neither of its lists — catches that call clearing it
- [ ] 3.94 a group whose first commitment is moved into another group is drawn where its next commitment sits — catches a heading kept at the old place
- [ ] 3.95 a commitments screen does not list a commitment its roster has stopped keeping as of a day after the one the screen was handed — catches the list read on the screen's day
- [ ] 3.96 a move a commitments screen could not keep leaves the commitment under the category it was already under — catches the category applied before the write

## 4. Strengthened in place, no mutation

- [ ] 4.1 a stopped commitment renamed through a commitments screen stays stopped, on the day it was kept until — asserts the kept-until day through a later store
- [ ] 4.2 a change that names what is already there changes nothing and refuses nothing — keeps a tick at a record place and asserts both places
- [ ] 4.3 a commitments screen opened on a roster that holds nothing lists nothing and takes nothing on — asserts no groups
- [ ] 4.4 a commitment whose rhythm is changed through a commitments screen is kept until yesterday and the new one is taken on today — asserts nothing stopped
- [ ] 4.5 a commitments screen keeps its roster at the place a day screen keeps its — asserts, through the internal `place`, that a screen opened with no place keeps its roster there
- [ ] 4.6 a roster store declaring the form this app writes and saying nothing about removal is refused — fixture at the form this app writes, with a category said
- [ ] 4.7 a commitment changed through a roster store is read back changed by a store opened afterwards — builds the scenario's three commitments and "Sport"; asserts order and group
- [ ] 4.8 a roster kept from the first supported date and stopped on the last is read back unchanged — asserts what the stop reported
- [ ] 4.9 Any other test whose scenario names a read its body does not make is strengthened the same way, each named in the PR body

## 5. Proven by mutation — each reddens in a `git archive` tree, with the diff and red run in the PR body

- [ ] 5.1 a move that leaves a roster as it was keeps nothing at its place — reddens with the four no-op guards removed
- [ ] 5.2 a category change that leaves a roster as it was keeps nothing at its place — reddens with the four no-op guards removed
- [ ] 5.3 a group move that leaves a group where it is keeps nothing at a roster store's place — reddens with the four no-op guards removed
- [ ] 5.4 a change of a commitment for itself keeps nothing at a roster store's place — reddens with the four no-op guards removed; the PR body says route 1 or 2
- [ ] 5.5 stopping a commitment leaves every earlier date answering as it did — reddens with `retire` a no-op answering `true`
- [ ] 5.6 removing a commitment leaves every earlier date answering as it did — reddens with `remove` a no-op answering `true`
- [ ] 5.7 a commitment taken up again through a commitments screen moves from what it has stopped to what it keeps — rewritten on the reworded fixture ("Journaling" first), it reddens with `Roster.addTakingUpAgain` removing the entry and inserting it at index 0

## 6. The record

- [ ] 6.1 The test for the corrected title is renamed to it, and `grep -rn "kept until the day the screen was handed" src/` finds nothing
- [ ] 6.2 `docs/open-questions.md` § *Known gaps* gains one new bullet for `commitment` holding every rule in `design.md` § *The unprovable rules*, none dropped and none added

## 7. The gates

- [ ] 7.1 `openspec validate cover-commitment-rules --strict` exits 0, and `pnpm run check:scenarios` exits 0
- [ ] 7.2 `git diff --stat origin/main -- src/` lists the four test files, `RosterDocument.swift` and `CommitmentsScreen.swift` for the reds and the widened `place`, and `RosterStore.swift` only if route 2 was taken, all named in the PR body
- [ ] 7.3 `pnpm run check:budgets` warns about nothing in this folder beyond the pre-budget prose `design.md` names, and `pnpm run verify` passes
- [ ] 7.4 `swift test` in `src/DayByDayKit` passes, and its count is ninety-six more than a run on `main`, both read off runs and never derived
- [ ] 7.5 **The archive handover — `implementer` ticks this in its last commit before the archive**, on the evidence that 2.1–7.4 are ticked and that this instruction is written here for the janitor. The janitor runs `/opsx:archive` itself, never a hand-applied version of the sync it prints, then reads the spec diff it produced. In `openspec/specs/commitment/spec.md` exactly ninety-six scenarios are added and eight reworded. Three requirement sentences change as `design.md` lists. The requirement renamed there leaves its place and lands at the end of the file with its title corrected. Nothing else moves. `pnpm run checks` runs after the archive commit exists. **Any other drift is a stop and a report, never a hand-edit**: rule 2 denies `openspec/specs/`, and `.claude/settings.json` denies `Edit(/openspec/changes/archive/**)`, so a box left unticked here cannot be reached afterwards.
