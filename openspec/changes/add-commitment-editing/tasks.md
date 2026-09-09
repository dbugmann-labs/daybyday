## 1. Before a line is written

- [x] 1.1 Confirm the starting point, and report rather than work around a different one (rule 5).
  From `src/DayByDayKit`, `swift test` reports **933 tests passing** — measured 2026-09-09 on this
  branch cut from `main` at `e908ff8`, which carries `add-category-order` (#181), and unmoved by the
  rebase onto **`4e64641`** that this branch sits on at G4: #183 landed while the delta was being
  written and touched `src/DayByDay`, `docs/` and nothing in the kit or under `openspec/specs/`,
  which `git diff --stat e908ff8 4e64641 -- src/DayByDayKit openspec/specs` reports as empty. From the repo root,
  `pnpm run check:scenarios` reports `scenario coverage — 127/188 scenario(s) covered` for this change
  and names *"changing a commitment a roster holds puts the result in the place the one it replaced
  held"* as next. Those **127 are the scenarios this delta carries verbatim from the current specs,
  and no test behind any of them may be renamed, moved, or have an assertion changed by a box below.**

  **`CommitmentsScreen.init` gains a defaulted parameter and nothing else changes shape.** Every other
  seam member this change adds is new, so no carried test needs so much as an added argument. A
  carried test that has to be edited at all is a sign the design was not followed: stop and report it.
  The one exception is § 7, which **deletes** five tests along with the requirement they came from —
  those five are named there and no other test is touched by that box.

- [x] 1.2 Confirm the three facts the delta rests on, before writing any test, and stop and report if
  any is false (`design.md` § *Context*, § *Neither form number moves*):

  **A record embeds the whole commitment by value.** `grep -n 'commitment' src/DayByDayKit/Sources/DayByDayKit/History.swift`
  finds `RecordedDay(commitment:date:)` keying numbers, notes and additions, and `Set<Tick>` holding
  ticks. If a record keys on anything narrower, § *Two acts, not one* is wrong.

  **An interval schedule carries its own start date.** `grep -n 'everyNDays' src/DayByDayKit/Sources/DayByDayKit/Schedule.swift`
  finds `case everyNDays(DayInterval, from: CalendarDate)`, and `Commitment.isDue(on:)` applies
  `keptFrom` as a separate floor above it. **§ 6.12–6.14 turn on this being two fields**: the grid moves
  with the day because `change` writes the day it was handed into both. If the two are one field, those
  three boxes are moot and the delta needs re-reading before anything else.

  **Neither form number moves.** `grep -n 'currentVersion\|IntroducedInVersion' src/DayByDayKit/Sources/DayByDayKit/RosterDocument.swift src/DayByDayKit/Sources/DayByDayKit/RecordDocument.swift`
  finds roster form **4** with `removalIntroducedInVersion = 3`, and record form **5**. **No box below
  touches `RosterDocument`, `RecordDocument` or `CommitmentCoding`**, and a box that finds it needs to
  is the design being wrong rather than a file to edit.

## 2. `record` — a history carries every record of one commitment over to another

Rule 3 throughout: one scenario, one acceptance test named identically to it, one red-green cycle.
Every box here is driven at `History.carryOver(_:to:)` and lands in
`src/DayByDayKit/Tests/DayByDayKitTests/RecordTests.swift`. **This section comes first because
everything above it depends on the carry-over being right, and nothing in it depends on anything else
in this change.**

- [x] 2.1 *every record of a commitment is carried over to another, on the dates each was made for* —
  the first cycle, and the one that introduces `History.carryOver(_ commitment: Commitment, to changed:
  Commitment) -> Bool`.
- [x] 2.2 *a number, a note and a day's additions are carried over exactly* — digit for digit,
  character for character, and the additions in the order they were made, which is the order a
  take-back reads.
- [x] 2.3 *carrying over is refused where a record sits on a date the other commitment is not due on*
  — all or none, and the history is left byte-identical in value to one never asked.
- [x] 2.4 *carrying over is refused where the two commitments differ in the kind their days take* —
  the second way a record fails to form, and the reason § 5's screen never produces it.
- [x] 2.5 *carrying over the records of a commitment that has none refuses nothing and changes nothing*
  — nothing to move is not an error. **This is the box `design.md` § *Two files, one act* depends on**:
  it is what makes a retry after a half-written change succeed.
- [x] 2.6 *carrying a commitment's records over to that same commitment changes nothing and refuses
  nothing*.
- [x] 2.7 *carrying over to a commitment the history already holds a record of is refused* — carrying
  over is not merging.

## 3. `record` — a store carries every record of one commitment over to another, at its place

Driven at `RecordStore.carryOver(_:to:)`, in
`src/DayByDayKit/Tests/DayByDayKitTests/RecordStoreTests.swift`. The shape is every other store
change's: write before reporting, report what the history reports, write nothing when the history came
back unchanged.

- [x] 3.1 *records carried over through a store are read back under the other commitment by a store
  opened afterwards*.
- [x] 3.2 *a carry-over a store's history refuses keeps nothing at its place* — `false`, without an
  error and without a write.
- [x] 3.3 *a carry-over with nothing to carry keeps nothing at a store's place*.
- [x] 3.4 *a store that could not write a carry-over leaves its history exactly as it was* — the
  store's own failure, told as it already tells every other one it could not keep.

## 4. `commitment` — a roster changes and supersedes

Driven at `Roster.change(_:to:under:)` and `Roster.supersede(_:with:keptUntil:under:)`, in
`src/DayByDayKit/Tests/DayByDayKitTests/RosterTests.swift`.

- [x] 4.1 *changing a commitment a roster holds puts the result in the place the one it replaced held*
  — the cycle that introduces `change`. A replacement at the entry, not a removal and an addition.
- [x] 4.2 *a changed commitment is put under the category the change was offered under*.
- [x] 4.3 *changing a commitment a roster has stopped keeping leaves it stopped, on the day it was
  kept until*.
- [x] 4.4 *changing a commitment a roster has removed leaves it removed*.
- [x] 4.5 *changing a commitment a roster does not hold is refused and leaves the roster as it was*.
- [x] 4.6 *changing a commitment into one the roster already holds is refused, whichever state it
  holds it in* — all three states in one test, and the place the roster is stricter than it is about
  an addition.
- [x] 4.7 *changing a commitment for itself changes nothing and is not refused* — accepted, like a
  move that drops a commitment where it already is. Check this **before** looking for a duplicate, or
  4.6's rule swallows it.
- [x] 4.8 *changing a commitment on a copy of a roster leaves the roster it was copied from unchanged*.
- [x] 4.9 *superseding a commitment takes the other one on in the place the superseded one held* — the
  cycle that introduces `supersede`.
- [x] 4.10 *a superseded commitment is held removed, on the day it was kept until*.
- [x] 4.11 *the commitment that supersedes another is put under the category it was offered under*.
- [x] 4.12 *superseding a commitment a roster is not keeping is refused* — one it has stopped, one it
  has removed and one it never held, in one test.
- [x] 4.13 *superseding a commitment with one the roster already holds is refused* — including
  superseding a commitment with itself.
- [x] 4.14 *a commitment superseded as of a day before the day it is kept from was kept on no date* —
  the roster refuses on no date, exactly as a stop already does not.
- [x] 4.15 *a superseded commitment stays where it was for every date the roster answers about* — the
  superseded entry sits immediately behind the one that replaced it, which is where `design.md`
  § *Superseding puts the new commitment in the old one's place* puts it.
- [x] 4.16 *superseding on a copy of a roster leaves the roster it was copied from unchanged*.
- [x] 4.17 *a commitment taken on to supersede another lands in that one's place rather than after
  every commitment already there* — the scenario under the MODIFIED *A roster holds the commitments a
  person keeps*, and the one that proves adding still appends.

## 5. `commitment` — a roster store keeps a change and a supersession

Driven at `RosterStore.change(_:to:under:)` and `RosterStore.supersede(_:with:keptUntil:under:)`, in
`src/DayByDayKit/Tests/DayByDayKitTests/RosterStoreTests.swift`.

- [x] 5.1 *a commitment changed through a roster store is read back changed by a store opened
  afterwards*.
- [x] 5.2 *a commitment superseded through a roster store is read back superseded by a store opened
  afterwards*.
- [x] 5.3 *a change and a supersession a roster refuses keep nothing at a roster store's place* — both
  refusals pass through as `false`, without an error and without a write.
- [x] 5.4 *a change of a commitment for itself keeps nothing at a roster store's place* — `true`, and
  the file byte-for-byte what it was. Compare against the **roster** and not against the boolean, as
  `move` and `put` already do.

## 6. `commitment` — a commitments screen says what a commitment is made of, and changes one

Driven at `CommitmentsScreen`, in
`src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenTests.swift`. § 6.1–6.4 introduce
`whatItIsMadeOf(_:)` and the `Change` value; § 6.5 onward introduce
`change(_:toName:on:keptFrom:under:)` and the `keepingRecordAt:` parameter on `init`. **Do not start
§ 6.5 until § 2, § 3, § 4 and § 5 are all green** — the screen orders two stores, and debugging that
ordering against a red store is how the order gets quietly reversed.

- [x] 6.1 *a commitments screen says what a commitment it keeps is made of, on each of the four
  rhythms* — the cycle that adds the way back from a `Schedule` to a `Rhythm`. It is a total function
  and takes no failure path: every schedule this screen can define one on was named by a rhythm.
- [x] 6.2 *a commitments screen says the category a commitment it keeps is under*.
- [x] 6.3 *a commitments screen says a stopped commitment's rhythm and day kept from cannot be changed*.
- [x] 6.4 *a commitments screen says nothing about a commitment on neither of its lists*.
- [x] 6.5 *a commitment renamed through a commitments screen is drawn under its new name, in the place
  it held* — the cycle that introduces `change` and the record place on `init`.
- [x] 6.6 *every record of a commitment renamed through a commitments screen is carried over to the
  new name*.
- [x] 6.7 *a commitment whose rhythm is changed through a commitments screen is kept until yesterday
  and the new one is taken on today* — the day before the day the screen was handed, ADR-1023 as
  amended 2026-09-07.
- [x] 6.8 *a rhythm changed through a commitments screen leaves every record already made standing* —
  and the record place is byte-for-byte untouched, which is what says no carry-over ran.
- [x] 6.9 *a name and a rhythm changed in one save put the new name on the superseded commitment* — the
  carry-over first, then the supersession. **A test that passes with the two the other way round is
  measuring the wrong thing**; check it was red first.
- [x] 6.10 *the day a commitment is kept from is moved earlier through a commitments screen and the
  days it opens become due*.
- [x] 6.11 *moving the day a commitment is kept from past a day it has a record on is refused* — the
  first of the two new refusals, and the one § 2.3 makes reachable.
- [x] 6.12 *the day an interval commitment is kept from is moved earlier and every day it is due on
  moves with it* — the grid moves with the day, answered at the residual round on 2026-09-09 and
  recorded in `grill.md` § *Settled* 3 as amended. The cycle that makes `change` build the schedule
  from the day it was handed rather than carrying the old schedule's start date through; a test that
  passes while the start date stays put is measuring the wrong thing.
- [x] 6.13 *moving the day an interval commitment is kept from off a day it has a record on is
  refused* — the same refusal as § 6.11 reached by moving the day **earlier**, which is the direction
  the other three rhythms are safe in.
- [x] 6.14 *an interval commitment's day kept from moved earlier by a whole number of intervals leaves
  every recorded day due* — the boundary that says the refusal is about what the change leaves and not
  about which way the day moved.
- [x] 6.15 *a change whose result the roster already holds is refused, whichever state it holds it in*.
- [x] 6.16 *a change that names what is already there changes nothing and refuses nothing* — nothing
  written at either place, both byte-for-byte what they were.
- [x] 6.17 *a stopped commitment renamed through a commitments screen stays stopped, on the day it was
  kept until*.
- [x] 6.18 *changing the rhythm or the day kept from of a stopped commitment is refused* — the second
  new refusal, told apart from the other six.
- [x] 6.19 *a commitments screen asked to change a commitment on neither of its lists does nothing and
  says nothing* — a removed commitment among them, which is how a removed one is unreachable without a
  refusal of its own.
- [x] 6.20 *a change a commitments screen could not keep leaves both places as they were*.
- [x] 6.21 *a change refuses a name that says nothing, a rhythm due on no day and a rhythm number the
  calendar will not take* — the three the define form already makes, reached through `change`.
- [x] 6.22 *a commitment of the number kind changed through a commitments screen keeps the kind its
  days take* — the kind is not one of the four and is carried through from the commitment being
  changed. ADR-1030.
- [x] 6.23 *a rhythm changed on the first date the calendar supports supersedes as of that day itself*
  — there is no day before, and the screen hands that day rather than refusing.
- [x] 6.24 *a commitments screen holds a refused change against the commitment it was asked to change*
  — the eighth kind of refused change, naming the commitment tapped rather than the one it would have
  produced.
- [x] 6.25 *a commitments screen holds nothing against a change that asks for no change at all*.
- [x] 6.26 *what a commitments screen holds about a refused change ends when a change to a commitment
  is kept*.
- [x] 6.27 *what a commitments screen holds about a refused change stands when a change names what is
  already there*.

## 7. `commitment` — the rhythm preview goes (B-036)

The one REMOVED requirement in this delta, and the only box in this change that deletes a test.

- [x] 7.1 Delete `Rhythm.inWords` from `src/DayByDayKit/Sources/DayByDayKit/Rhythm.swift`, the preview
  line it feeds at `src/DayByDay/DayByDay/CommitmentsView.swift:278`, and **exactly these five tests**
  in `src/DayByDayKit/Tests/DayByDayKitTests/CommitmentsScreenTests.swift`: *a rhythm being built is
  said in the words the schedule it names says*, *an interval rhythm is said without a day to keep the
  commitment from*, *a weekday-set rhythm with no days in it is said as no day*, *a rhythm carrying a
  number the calendar will not take is said as nothing*, and *a rhythm carrying the number at each end
  of what it allows is said in words*. **`ScheduleWords` and `Schedule.inWords` stay** — they are the
  `schedule` capability's, ADR-1034, and every entry on both lists and every day-screen row still says
  a rhythm in words through them. A diff that touches either is a stop.

  `docs/backlog.md` B-036 names `CommitmentsView.swift:167` as the line; it is **:278** on this
  branch. The backlog is not `spec-author`'s to correct and the stale line is recorded here instead.

## 8. `day-screen` — a day screen returned to reads its record again where it is keeping one

Driven at `DayScreen.returnedTo()`, in `src/DayByDayKit/Tests/DayByDayKitTests/DayScreenTests.swift`.

- [x] 8.1 *a commitment renamed at a day screen's places is drawn under its new name and still kept
  when the screen is returned to* — the cycle that makes `returnedTo()` re-open the record place. Guard
  it on the screen **keeping** a record, or the carried scenario *a day screen returned to does not
  read its record again* goes red, and that one must stay green: its assertion is still the rule and
  only its title is now wrong.
- [ ] 8.2 *what a day screen tells on a row stands when the screen is returned to and reads its record
  again* — the re-read clears no notice.

## 9. The app shell

ADR-1019's 2026-09-04 exception, and `design.md` § *B-037 carries no requirement*. **No requirement is
attached to any box here**, and none may be added by one: a box that finds itself needing a scenario
is a stop.

- [ ] 9.1 Move the define form into a **sheet** in `CommitmentsView.swift`, reached by a `+` in the
  toolbar for defining and from a row for changing (B-037). The sheet fills its fields from
  `screen.whatItIsMadeOf(commitment)` when it opens to change one and from `screen.dayToKeepFrom` when
  it opens to define, calls `screen.change(...)` or `screen.define(...)` on save, and **stays open with
  what was typed when either is refused** — a rhythm built control by control is most of the work, and
  throwing it away to show a refusal elsewhere is the expensive answer. Where
  `whatItIsMadeOf` says the rhythm and the day kept from cannot be changed, draw both controls and let
  neither be edited: one sheet with one shape reads as one form. The category field stays and so does
  the row's swipe action — they answer different moments. Verify by building:
  `xcodebuild -project src/DayByDay/DayByDay.xcodeproj -scheme DayByDay -destination 'platform=iOS Simulator,name=iPhone 16' build`
  succeeds.
- [ ] 9.2 Walk it on the phone with `pnpm run phone`: define a commitment through the `+`; rename one
  and check a past day still shows it kept; change a rhythm and check yesterday still answers on the
  old one; rename a stopped commitment; try a rename that collides and read the refusal in the sheet.
  **Uninstall first with `simctl uninstall` if walking the simulator** — a setup tap on a record that
  survived a previous run unticks instead of ticking. Record what was walked in the PR.

## 10. The ADRs and `CONTEXT.md`

`docs/adr/**` and `CONTEXT.md` are `spec-author`'s to write, so all of it is already in the diff G4
signs and these boxes **confirm rather than write**.

- [ ] 10.1 Confirm **ADR-1023** is amended in place and stamped `2026-09-09`, and that what it now says
  about changing a commitment matches `design.md` § *Two acts, not one*: a commitment still has no
  identity, a mutable part is still refused, and a change is carried by a second commitment that the
  records follow or the roster keeps beside the first.
- [ ] 10.2 Confirm **ADR-1030** is amended in place and stamped, that its *Consequences* no longer say
  B-014's answer is "a new commitment, which starts a new history", and that **its ruling that a kind
  never changes is untouched** — that is the part this Story leans on, not the part it moves. Confirm
  **ADR-1038 is untouched**: nothing here adds a part to a commitment, so its ruling on which of 1023
  and 1030 governs one is cited and not reopened. A diff touching 1038 is a stop.
- [ ] 10.3 Confirm **this diff** adds no new file under `docs/adr/` and leaves `docs/adr/README.md`'s
  table untouched — `design.md` § *Why no new ADR*. Nothing in `scripts/` checks ADR numbering, so this
  box is the check: run `git diff --stat origin/main...HEAD -- docs/adr/` and confirm it names exactly
  `1023-…` and `1030-…` and nothing else. **ADR-1045 arrived on `main` from #183** while this Story was
  being written and is not this Story's; numbers are never reused and a gap is normal (ADR-1020).
- [ ] 10.4 Confirm `CONTEXT.md` carries **Carrying over** as a term of its own and the amendments to
  **Commitments screen** for the sheet and the eighth refusable change, and that the grill's three
  entries — **Changing a commitment**, **Superseding** and the amendment to **Removed** — are still
  there and still say what the delta says.

## 11. Before the review, and what the janitor does at the archive

- [ ] 11.1 From `src/DayByDayKit`, `swift test` — every test green, and the count is **986**: the 933
  measured at § 1.1, minus the **5** § 7.1 deletes, plus the **58** scenarios § 2 to § 8 add. **A
  number that comes back different is a stop** (rule 5), not a number to write down. From the repo
  root, `pnpm run verify` green and `pnpm run checks` reporting `188/188 scenario(s) covered`.
- [ ] 11.2 `openspec validate add-commitment-editing --strict` exits 0, and `openspec validate --all
  --strict --no-interactive` exits 0.
- [ ] 11.3 Rebase onto current `main` and push with `--force-with-lease`. A conflict inside
  `openspec/changes/add-commitment-editing/` or anywhere under `openspec/specs/` is a **stop**, not a
  merge to resolve (rule 5) — it means another Story landed on `commitment`, `record` or `day-screen`
  while this one was being written, and the ten MODIFIED requirements were extracted verbatim from
  those three specs as they stood at `e908ff8` and were re-checked against `4e64641`, the commit this
  branch sits on at G4 — neither commit changed any file under `openspec/specs/`. **A clean rebase that then fails § 11.2 is the same
  stop**, and it needs a further G4 rather than a quiet refresh of the delta.
- [ ] 11.4 Hand back for the review (**G7**). The conductor spawns `reviewer`; do not run
  `mattpocock-skills:code-review` on your own diff and do not act on findings until they come back
  through the conductor. This box is ticked when the hand-back is written.
- [ ] 11.5 Write the archive handover for the janitor, into the PR or the handover message, saying what
  it must check **after** `/opsx:archive` has run. **The `implementer` ticks this box, in its last
  commit before the archive, on the instruction having been written** — the checking itself is the
  janitor's step and has no box of its own, deliberately: `add-roster-store` (#103) shipped a box that
  could only be ticked after the archive and stalled the Story between review and merge, and
  `add-number-entry` (#139) shipped this box in the right shape and stalled anyway because nothing in
  it said whose tick it was.

  **Archive handover, for the janitor.** This delta touches three capabilities. `specs/commitment/spec.md`
  carries **four ADDED** requirements — *A roster changes a commitment it holds for another, in the
  place it holds it*, *A roster supersedes a commitment it is keeping with another, from a day*, *A
  commitments screen says what a commitment it is asked to change is made of* and *A commitments screen
  changes a commitment on either of its lists* — **seven MODIFIED**, and **one REMOVED**, *A
  commitments screen says in words the rhythm its form is building*. `specs/record/spec.md` carries
  **two ADDED** and **one MODIFIED**. `specs/day-screen/spec.md` carries **one MODIFIED** and nothing
  else. **No requirement is renamed anywhere in this delta**: only prose inside each MODIFIED one
  changes, no scenario is dropped or retitled, and every new scenario is an addition at the end of its
  own requirement's list.

  **The REMOVED section is the first this repository has archived**, so check it specifically. After
  `/opsx:archive` runs, read the recomposed `openspec/specs/commitment/spec.md` and confirm that *A
  commitments screen says in words the rhythm its form is building* is **gone from it entirely** — the
  header and all five of its scenarios — and that no other requirement moved out of the order it held
  before this archive. Then confirm the four ADDED requirements landed in `commitment` and nowhere
  else, that the two ADDED landed in `record`, that `openspec/specs/schedule/spec.md` is unchanged by
  this archive, and that `openspec validate --archived` exits 0. Any drift — a requirement moved,
  dropped, or reworded beyond this delta's own MODIFIED text — is **a stop and a report, never a
  hand-edit** (rule 2): `openspec/specs/` is written by `/opsx:archive` and by nothing else, and the
  archived folder is denied to every editor.
