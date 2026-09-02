## 1. The public surface

- [x] 1.1 Add `Sources/DayByDayKit/RecordStore.swift` declaring `public final class RecordStore`
  and `public enum RecordStoreError: Error, Equatable, Sendable` exactly as `design.md` § *The seam*
  gives them — `public init(at place: URL) throws`, `public private(set) var history: History`,
  `public func add(_ tick: Tick) throws`, `public func remove(_ tick: Tick) throws`; the three cases
  `notAStore(at:)`, `laterForm(at:version:)`, `cannotWrite(at:)` — with the initializer and both
  methods bodied `fatalError("not implemented")`. Nothing else public. Verify with
  `cd src/DayByDayKit && swift build` exiting 0.
- [x] 1.2 Add `Sources/DayByDayKit/RecordDocument.swift` declaring the `internal` document type for
  version 1 as `design.md` § *The form on disk* fixes it — `version`, `ticks`, each tick a
  `commitment` (`name`, `keptFrom` as `{year, month, day}`, `schedule` as exactly one of
  `{ "weekdays": [...] }`, `{ "dayOfMonth": n }`, `{ "everyNDays": n, "from": {year, month, day} }`,
  `{ "timesPerWeek": n }`) and a `date` — with `init(_ history: History)` and
  `func history() -> History?` both bodied `fatalError("not implemented")`. The conversion from
  `Schedule` is an exhaustive `switch` over its four cases, so a case you did not expect is a
  compile error to report under § 4, not to paper over. Verify with `swift build` exiting 0.
- [x] 1.3 Confirm nothing else in the package moved: every file that existed before this Story is
  untouched in `git diff --stat`, `Package.swift` included, and `cd src/DayByDayKit && swift test`
  still reports the ninety-seven tests from #8, #9, #10, #11, #42 and #55 passing.
- [x] 1.4 Confirm the starting point before writing a test: `pnpm run check:scenarios` reports
  `0/13 covered` for this change and names `"a store opened where nothing has been kept holds an
  empty history"` as next.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/record/spec.md` and writes one acceptance
test whose `@Test("...")` display name is that scenario title verbatim, then makes it pass with the
smallest change that does. Never write two before the first is green (`AGENTS.md` rule 3). Put them
in a new `Tests/DayByDayKitTests/RecordStoreTests.swift`; `RecordTests.swift` is the pure record and
stays as it is. Each test opens its stores at a fresh place — a URL under
`FileManager.default.temporaryDirectory` with a `UUID` in the path, and the file itself one level
under that, so a directory has to be created — and reads bytes back with `Data(contentsOf:)` where a
scenario says *byte-for-byte*. No test reads a clock, sets a time zone or touches a path outside its
own place. Verify each with `cd src/DayByDayKit && swift test`: the named test green, every earlier
test still green.

Expect most of these to pin rather than drive, as on #42 and #55. **Record which ones actually ran
red as you go, in this file**; a prediction here is not evidence. The ones `design.md` expects to
run red on their own are 2.1 (the initializer's `fatalError`), 2.2 (the first `add` and the first
file on disk), 2.10 (a write that fails must leave `history` untouched — an implementation that
assigns before writing passes everything before it and fails here), 2.11 (the first refusal), 2.12
(the version read on its own, ahead of the body — an implementation that decodes the whole
document first reports a later form as `notAStore` and fails the `laterForm` assertion), and 2.13
if decoding does not go through the failable initializers.

- [x] 2.1 `a store opened where nothing has been kept holds an empty history` — opens at a place
  under a directory that does not exist yet; asserts no throw and `history == History()`.
- [x] 2.2 `a tick added to a store is held by a second store opened at the same place while the
  first is still open` — the write-through: the first store is a live local, the second is opened
  without any save or close on the first, and asserts `isKept` on the second.
- [x] 2.3 `a tick taken back is not held by a store opened afterwards at the same place` — two
  assertions on the later store: not kept, and `history == History()`. Fails an implementation
  that writes on `add` but not on `remove`.
- [x] 2.4 `a store opened again holds exactly the ticks added and not taken back` — four ticks
  in, one out, equality with a `History` built from the three that remain.
- [x] 2.5 `adding a tick the store already holds leaves what is kept unchanged` — equality with a
  history the tick was added to once; fails a document that appends rather than holds a set.
- [x] 2.6 `ticks of commitments on every schedule shape are read back as the same ticks` — one
  commitment per `Schedule` case: "Gym" on the weekday set, "Finances" on the 25th ticked
  25 September 2026, "Plants" every 3 days from 25 August 2026 kept from 1 September and ticked
  3 September 2026, "Reading" on a weekly quota of 3 ticked Monday 7 September 2026. Equality with
  a `History` of the same ticks, plus `isKept` for each. This is the test that proves each payload
  round-trips, since no payload is public.
- [ ] 2.7 `a commitment name is read back exactly, whatever it contains` — the name in the scenario,
  with the line break written as `\n` in the Swift literal; pins JSON escaping and that the name
  is stored as the person gave it, untrimmed and unnormalised.
- [ ] 2.8 `a tick in the first supported year and one in the last are read back unchanged` — the
  ADR-1004 pin for the disk: 3 January 1583 and 27 December 9999 are both Mondays and both round-
  trip. An implementation that encodes through `Date` or a `DateFormatter` fails one of them.
- [ ] 2.9 `stores at different places hold different histories` — two places, one tick in the
  first; the second opens empty and the first still holds it.
- [ ] 2.10 `a tick that cannot be kept is refused and not held` — the place is
  `<temporaryDirectory>/<uuid>/blocker/store.json` where `blocker` is an ordinary file written by
  the test. Opening succeeds with an empty history (the path does not exist), `add` throws
  `RecordStoreError.cannotWrite(at:)` (use `#expect(throws:)` with the exact case), `history` is
  still `History()`, and a store opened afterwards at the same place is empty too.
- [ ] 2.11 `content that is not a store is refused and left as it was` — write a run of bytes
  that is not JSON to the place; `RecordStore(at:)` throws `.notAStore(at:)`; the bytes read back
  are equal to what was written.
- [ ] 2.12 `a store written in a later form than this app knows is refused` — write
  `{"version": 2, "ticks": []}`; the initializer throws `.laterForm(at:version: 2)`; the bytes are
  unchanged.
- [ ] 2.13 `a store holding what could not be a tick is refused` — two places: one holding a
  version-1 document whose tick is "Gym" on Mon/Wed/Sat kept from 1 January 2026 on
  `{2026, 9, 1}` (a Tuesday), one holding a tick on `{2026, 2, 30}`; each throws `.notAStore(at:)`
  and each file is byte-for-byte unchanged. Write the two documents by hand in the test, in the
  form `design.md` fixes, not through the store.

## 3. Gates

- [ ] 3.1 `cd src/DayByDayKit && swift test` reports 110 tests passing and no failures — the
  thirteen here plus the ninety-seven from before, none of which may change — and `pnpm run verify`
  exits 0.
- [ ] 3.2 `pnpm exec openspec validate add-record-store --strict` exits 0 and `pnpm run checks`
  reports scenario coverage as 13 of 13.
- [ ] 3.3 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**). Two
  things the reviewer is asked to look for by name: that `history` is assigned only *after*
  `Data.write(to:options: .atomic)` returns, in both `add` and `remove`; and that decoding reaches
  every value through the engine's failable initializers rather than constructing one around them.

## 4. Things that moved while this Story was open

Record here anything the implementation had to absorb that `design.md` did not foresee — a fifth
`Schedule` case, a changed test count on `main` — so the reviewer and the archive read the folder
against what was actually true. "Nothing." is a valid entry.

- [ ] 4.1 Nothing, or what did.

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.
