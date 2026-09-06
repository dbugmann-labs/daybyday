## 1. The public surface

- [ ] 1.1 Confirm the starting point before writing anything. `cd src/DayByDayKit && swift test`
  reports **300 tests passing** at `566297e`, and `pnpm run checks` reports
  `scenario coverage — 0/20 scenario(s) covered` for this change, naming
  `"a refused tick is told on the row that was tapped"` as next. A different number for either means
  something else has moved on this branch; report it rather than working around it (`AGENTS.md`
  rule 5).
- [ ] 1.2 In `Sources/DayByDayKit/DayScreen.swift`, add
  `public private(set) var refusedChangeRow: DayView.Row?`, initialised to `nil`, with the doc
  comment `design.md` § *The seam* gives it. **Add no other member** — no `RefusalReason`, no message
  string, no count, no `Bool` beside it; their absence is the requirement that every refusal is told
  the same way and names no cause, not an omission. `DayView.swift` is not edited by this change at
  all. Verify with `cd src/DayByDayKit && swift build` exiting 0 and `swift test` still reporting
  300 tests passing — adding an unread property must change nothing, and one of those 300 going red
  here is a rule-5 stop rather than a test to edit.
- [ ] 1.3 Add a test helper to `Tests/DayByDayKitTests/DayScreenTests.swift` beside the existing
  `freshPlaces()`: one that makes a directory read-only and one that makes it writable again, over
  `FileManager.setAttributes([.posixPermissions:], ofItemAtPath:)` with `0o500` and `0o700`.
  `design.md` § *Context* proves the mechanism end to end on this machine — a file inside a `0o500`
  directory still reads, `createDirectory(withIntermediateDirectories: true)` on it still succeeds,
  and `Data.write(to:options:.atomic)` fails there with `NSCocoaErrorDomain 513`, which
  `RecordStore.write` turns into `cannotWrite`. **Every test that uses it must set the directory
  back to `0o700` before it returns**, including on the failure path, or the temporary directory is
  left unreadable behind it. Verify with `swift test` still reporting 300 tests passing: a helper
  nothing calls yet changes nothing.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/day-screen/spec.md` and writes one
acceptance test whose `@Test("...")` display name is that scenario title **verbatim**, then makes it
pass with the smallest change that does. Never write two before the first is green (`AGENTS.md`
rule 3).

All twenty go at the end of the existing `Tests/DayByDayKitTests/DayScreenTests.swift`, whose suite
is already `@MainActor` and whose `freshPlaces()` helper they reuse. **No test may touch the real
application-support directory.** No existing test may be rewritten: the 300 already on the branch
are the evidence that this change adds a fact to a day screen rather than moving one, and one of
them going red is a rule-5 stop.

Verify each with `cd src/DayByDayKit && swift test`: the named test green, every earlier test still
green. Every date below was checked twice in `design.md` § *Context* rather than recalled; do not
re-derive a weekday, and do not substitute a date the delta does not name. Where a scenario quotes a
title, quote the expected string in full — an expectation the test assembles out of the same pieces
the code uses proves nothing.

`design.md` expects these to run red on their own: 2.1 (nothing sets the property yet), 2.4 (if the
set happens anywhere but on the throwing path), 2.6 and 2.7 (if `shown(asOf:)` does not clear),
2.8, 2.9 and 2.10 (if a successful write does not clear), 2.11, 2.12 and 2.13 (if a move does not
clear), 2.14 and 2.15 (if a move clears unconditionally — the two most important tests in this
change), and 2.18, 2.19 and 2.20 (if the set happens before `tick(_:)`'s three guards rather than
after them). **Record which ones actually ran red as you go, in this file** — a prediction here is
not evidence.

### Telling it (five)

- [ ] 2.1 `a refused tick is told on the row that was tapped` — the first tick of the seam. Build the
  place the way `DayScreenTests.swift:209` already does: a `blocker` file, with `record.json` beneath
  it. Assert both halves — `#expect(throws: RecordStoreError.cannotWrite(at: place))` **and**
  `refusedChangeRow`. The throw is settled item 7 and is not optional.
- [ ] 2.2 `a refused tick is told on the row that was tapped and on no other row` — three
  commitments, the second ticked. The three rows differ in name, so they are three distinct values.
- [ ] 2.3 `a refused take-back is told on the row that was tapped` — the read-only-directory place
  from 1.3, seeded with the tick through a `RecordStore` **before** the directory is made read-only.
  Assert the row still says the commitment is kept: a refused take-back must not flip the row.
- [ ] 2.4 `a second refused tap is told on the row tapped last and no longer on the first` — the "at
  most one" requirement. Fails an implementation that appends rather than replaces.
- [ ] 2.5 `a refused change does not change what a day screen says about keeping a record` — tick
  twice at a place that cannot be written and assert `recordState` is still `.kept`. This is the
  guard against a later "improvement" that sets `.unreadable` when a write fails; a full disk refuses
  a write and opens the record perfectly.

### How long it lasts (ten)

- [ ] 2.6 `what a day screen tells on a row ends when the app is shown again` — shown again as of the
  same day.
- [ ] 2.7 `what a day screen tells on a row ends when the app is shown again where the record then
  cannot be read` — after the refusal, replace the `blocker` file with a directory and write a run of
  bytes that is not a record at `blocker/record.json`, then show the app again. Assert
  `recordState == .unreadable` **and** that nothing is told: being shown re-forms everything from the
  place, and what is told does not outlive it whatever is then there.
- [ ] 2.8 `what a day screen tells on a row ends when the same change is made again and is kept` —
  the retry. Read-only directory, tick refused, directory made writable, the row the screen then
  holds ticked again. This is the only scenario that pins the clear on the successful path.
- [ ] 2.9 `what a day screen tells on a row ends when a change is kept on another row` — settled
  item 4's "a tick on any row", asserted.
- [ ] 2.10 `what a day screen tells on a row ends when a take-back is kept` — the half settled item 4
  added. Tick "Journaling" and keep it; make the place unwritable; tick "Gym" and be refused; make it
  writable; tick "Journaling" again, which is now a take-back, and it lands.
- [ ] 2.11 `what a day screen tells on a row ends when the day screen is moved to the day before` —
  quote `"Sunday 30 August 2026"` in full.
- [ ] 2.12 `what a day screen tells on a row ends when the day screen is moved to the day after` —
  quote `"Tuesday 1 September 2026"` in full.
- [ ] 2.13 `what a day screen tells on a row ends when the day screen is sent back to today from
  another day` — move back a day first, tick there, then go home; quote
  `"Today · Monday 31 August 2026"` in full.
- [ ] 2.14 `what a day screen tells on a row stands when a move has nowhere to go` — both ends in one
  test, as the scenario states it: one screen on Saturday 1 January 1583 moved to the day before, one
  on Friday 31 December 9999 moved to the day after, each at its own place. Both commitments are kept
  from 1 January 1583. Red on any implementation that clears at the top of a move.
- [ ] 2.15 `what a day screen tells on a row stands when a day screen showing today is sent back to
  today` — **the most important test in this change.** `showToday()` has no `guard` and never
  refuses, so the clear there must be conditional on `shownDay != today`; this test is red on the
  unconditional version, which is the one anybody writes first (`design.md` § *The three ends*).

### Where it says nothing (five)

- [ ] 2.16 `a tap on a day screen that is not keeping a record is told nothing on the row` — a place
  holding a run of bytes that is not a record, built the way `DayScreenTests.swift` already builds
  one.
- [ ] 2.17 `a tap on a day screen holding a record from a later version is told nothing on the row` —
  the other half of not keeping a record, built the way the shipped later-version tests build it.
- [ ] 2.18 `a tap on a row for a day that has not arrived is told nothing on the row` — set up at a
  place that **cannot be written**, deliberately: it fails an implementation that reached the store
  before checking whether the row offers a tick.
- [ ] 2.19 `a tap on a row a day screen's day view does not hold is told nothing on the row` — the
  two-screen setup the shipped scenario *a row the day screen's day view does not hold changes
  nothing* already uses.
- [ ] 2.20 `a tap on a row a day screen's day view does not hold does not end what is already told` —
  the same setup with a refusal first. Red on an implementation that clears at the top of `tick(_:)`.

## 3. The shell

No scenario covers this section — `docs/open-questions.md` § *No UI smoke layer* — so keep it to what
has no judgement in it, and change nothing in `DayByDayKit` from here.

- [ ] 3.1 In `src/DayByDay/DayByDay/ContentView.swift`, inside the existing
  `ForEach(Array(screen.dayView.rows.enumerated()), id: \.offset)`, draw a short message under the
  row's name when `row == screen.refusedChangeRow`, and nothing otherwise. **Keep
  `try? screen.tick(row)` exactly as it is** — the screen is what does the telling now, and a
  `do`/`catch` in the shell saying anything of its own would be the shell inventing a requirement
  (`design.md` § *How the shell draws it*). One message for every refusal, naming no cause: no
  branch on the error, and nothing that distinguishes a refused tick from a refused take-back. The
  exact words, the styling and the placement under the name are yours; the grill left them open on
  purpose. Nothing else in the file changes.
- [ ] 3.2 Build and run it: `xcodebuild -project src/DayByDay/DayByDay.xcodeproj -scheme DayByDay
  -destination 'platform=iOS Simulator,name=iPhone 17' build`, then `xcrun simctl` boot, install and
  launch as ADR-1019 records. To reach a refusal on a real device you must make the app's own record
  place unwritable — `xcrun simctl get_app_container booted com.example.DayByDay data` gives the
  container, and `chmod 0500` on the `Library/Application Support/DayByDay` directory inside it is
  the same mechanism 1.3 uses; set it back to `0700` afterwards. Tap a row, then tap a second row,
  then step to the day before, and confirm the message appears under the first name, moves to the
  second, and is gone after the step. **Record what you saw here, including the exact string on
  screen and where it sat relative to the row's name** — nothing in CI can observe it, and whether
  the message is legible where it is drawn is the whole want. If the simulator step-through cannot be
  driven from this sandbox, say so plainly and hand that half back rather than reporting it done;
  that is what #93's own 3.2 did.

## 4. Gates

- [ ] 4.1 `cd src/DayByDayKit && swift test` reports **320 tests passing** and no failures — the
  twenty here plus the 300 already on the branch at `566297e`, none of which may change — and
  `pnpm run verify` exits 0.
- [ ] 4.2 `pnpm exec openspec validate add-refused-tick-notice --strict` exits 0 and `pnpm run
  checks` reports scenario coverage as 20 of 20.
- [ ] 4.3 Have `mattpocock-skills:code-review` run on both axes and record its findings here with a
  disposition for each (**G7**). This box is the reviewer having been run and its findings written
  down, not a verdict on them: `AGENTS.md`'s routing table gives the review to a separate agent that
  may write nothing, so ticking this while claiming to have performed the review yourself is the
  defect `docs/open-questions.md` § *The tasks template puts G7 inside the implementer's own
  checklist* records against four earlier Stories. Findings that stay unresolved are a stop and a
  report, never a quiet fix.

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it — so no box above may
depend on the archive having already run. Any drift the janitor finds between this folder and
`openspec/specs/day-screen/spec.md` after `/opsx:archive` is a stop and a report, never a hand-edit:
`.claude/settings.json` denies editing under `openspec/changes/archive/**` and rule 2 denies editing
`openspec/specs/` at all.

Two moves fall outside this change folder and outside `spec-author`'s reach, so they are named here
rather than done here. Both are `docs/open-questions.md`, and both belong in one chore commit
alongside the merge, as `d1f99dc` was for #71 and #72 and as #92 and #93 each named for the same
file:

1. **§ *The shell swallows the one failure a tick reports* is closed by this Story.** It ends
   "owed by whichever Story first gives the shell a way to say anything at all", and that is this
   one. It moves to § *Settled* with the answer: the screen tells it on the row, the shell draws
   that, and `try?` stays — what the entry objected to was nothing being said, not the `try?`.
2. **A new entry is owed on `RecordStore.write`.** `try encoder.encode(document)` sits outside the
   `do` that turns a failure into `RecordStoreError.cannotWrite(at:)`, so an encoding failure escapes
   as `EncodingError` and a caller matching on `RecordStoreError` will not catch it. It is invisible
   today — `RecordDocument` is a plain `Codable` over strings and integers and has nothing that
   fails to encode — and it does not touch this delta, since what is told on a row follows any
   refusal whatever type it arrives as. Found at this Story's grill on 2026-09-06; not fixed here,
   because it is `record`'s code and this Story is scoped to `day-screen`.
