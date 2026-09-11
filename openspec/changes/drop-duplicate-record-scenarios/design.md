## Context

`proposal.md` § *Why* says what this is for, and `grill.md`'s settled answers are what the delta is
written on. `openspec/specs/record/spec.md` holds 19 requirements and 170 scenarios; the delta
carries 11 requirements and 96 scenarios, and drops 16.

The archiver in `openspec` 1.10.0 refuses a MODIFIED block omitting a current scenario and takes
REMOVED plus ADDED under a new heading, appending each added requirement after every surviving one in
delta order (ADR-1047 decision 2). `pnpm run check:scenarios` reads scenario → test only, so a test
whose scenario is gone passes every check. `RecordStore` has no close and holds no handle: it reads
its place once when opened and writes it whole for each change it keeps.

## Goals / Non-Goals

**Goals:** the sixteen scenarios of grill item 1 and their tests gone, with everything each asserted
still asserted by its keeper; the two carry-over lines of grill item 12 made true; the seven kept
tests of grill item 9 brought to their own scenarios, or withdrawn where that goes red.

**Non-Goals:** no requirement prose changed; no scenario title changed; no test added, and no kept
test edited but those seven; no code line in `src/` changed, only grill item 8's two doc comments;
ADR-1047 and `CONTEXT.md` unedited (grill item 10). #199's box 13 and outcome comment follow the merge.

## Decisions

### The seam

No member is new or changed, which makes this a *pruning Story*. The carried scenarios' tests attach at:
```swift
Tick.init?(_ commitment: Commitment, on date: CalendarDate)
Number.init?(_ number: Decimal, for commitment: Commitment, on date: CalendarDate)
Note.init?(_ text: String, for commitment: Commitment, on date: CalendarDate)
Addition.init?(_ amount: Decimal, for commitment: Commitment, on date: CalendarDate)
History.init()
History.add(_ tick: Tick)
History.add(_ number: Number)
History.add(_ note: Note)
History.add(_ addition: Addition)
History.remove(_ tick: Tick)
History.removeLastAddition(for commitment: Commitment, on date: CalendarDate)
History.isKept(_ commitment: Commitment, on date: CalendarDate) -> Bool
History.number(for commitment: Commitment, on date: CalendarDate) -> Decimal?
History.note(for commitment: Commitment, on date: CalendarDate) -> String?
History.total(for commitment: Commitment, on date: CalendarDate) -> Decimal
History.carryOver(_ commitment: Commitment, to changed: Commitment) -> Bool
RecordStore.init(at place: URL) throws
RecordStore.history: History
RecordStore.add(_ tick: Tick) throws
RecordStore.add(_ number: Number) throws
RecordStore.add(_ note: Note) throws
RecordStore.add(_ addition: Addition) throws
RecordStore.remove(_ tick: Tick) throws
RecordStore.removeNumber(for commitment: Commitment, on date: CalendarDate) throws
RecordStore.removeNote(for commitment: Commitment, on date: CalendarDate) throws
RecordStore.removeLastAddition(for commitment: Commitment, on date: CalendarDate) throws
RecordStore.carryOver(_ commitment: Commitment, to changed: Commitment) throws -> Bool
RecordStoreError.cannotWrite(at: URL)
```

### Sixteen scenarios are dropped, and nine headings change as little as keeps each true

| # | Dropped | Keeper, which asserts the same | Test file |
|---|---|---|---|
| 1 | a tick is formed for a commitment on a date it is due on | a commitment whose kind is not a tick takes no tick on a date it is due on | `RecordTests` |
| 2 | a commitment ticked on a date was kept on that date | a tick of one commitment does not keep another on the same date | `RecordTests` |
| 2 | a commitment ticked on one date was not kept on another date it is due on | a history answers each date on its own across a week | `RecordTests` |
| 2 | a commitment was not kept on a date it is not due on | a history answers each date on its own across a week | `RecordTests` |
| 2 | a number commitment with a number recorded on a date was kept on that date | every number a commitment accepts keeps its day, whatever the number is | `RecordTests` |
| 2 | a note commitment with a note recorded on a date was kept on that date | every note a commitment accepts keeps its day, whatever it says | `RecordTests` |
| 3 | a tick taken back leaves the commitment not kept on that date | taking back a tick leaves the same commitment's ticks on other dates standing | `RecordTests` |
| 4 | a number added to a history is the number that commitment has on that day | a number the commitment refuses leaves the number already on that day standing | `RecordTests` |
| 5 | a note is recorded for a note commitment on a date it is due on | a note takes any length, any script and a line break | `RecordTests` |
| 6 | a note added to a history is the note that commitment has on that day | a text the system refuses leaves the note already on that day standing | `RecordTests` |
| 7 | an addition is recorded for a total commitment on a date it is due on | a commitment whose kind is not a total takes no addition on a date it is due on | `RecordTests` |
| 8 | an addition added to a history is the total that commitment has on that day | the additions of one day are not counted in another day's total | `RecordTests` |
| 9 | a tick added to a store is held by a second store opened at the same place while the first is still open | stores at different places hold different histories | `RecordStoreTests` |
| 9 | a tick taken back is not held by a store opened afterwards at the same place | a store opened again holds exactly the ticks added and not taken back | `RecordStoreTests` |
| 9 | a number taken back is not held by a store opened afterwards at the same place | a store opened again holds exactly the ticks and numbers added and not taken back | `RecordStoreTests` |
| 9 | a note taken back is not held by a store opened afterwards at the same place | a store opened again holds exactly the ticks, numbers and notes added and not taken back | `RecordStoreTests` |

Grill items 1–5, 8 and 13. `#` is the row of the heading table below, and grill item 1 settles each
pair against decision 6's four conditions. Two doc comments follow their renamed heading (`tasks.md`
§ 4) and the dated `survey-record.md` quote stays; rows 2, 5, 7 and 8 stay over 150 words, verbatim.
Rejected: sparing base cases (item 4); cover split across two keepers (item 2); RENAMED (ADR-1047).

| # | Removed | Added |
|---|---|---|
| 1 | A tick is of a commitment on a calendar date it is due on | A tick is of a commitment on a calendar date it is due on, and nothing else |
| 2 | A history answers whether a commitment was kept on a day from the ticks it holds | A history answers whether a commitment was kept on a day from the records it holds |
| 3 | A tick can be taken back | A tick a history holds can be taken back |
| 4 | A history answers what number a commitment has on a day from the numbers it holds | A history answers what number a commitment has on a calendar date from the numbers it holds |
| 5 | A note is of a note commitment on a calendar date it is due on | A note is of a note commitment on a calendar date it is due on, and holds one text |
| 6 | A history answers what note a commitment has on a day from the notes it holds | A history answers what note a commitment has on a calendar date from the notes it holds |
| 7 | An addition is of a total commitment on a calendar date it is due on | An addition is of a total commitment on a calendar date it is due on, and holds one amount |
| 8 | A history answers what a commitment has added on a day from the additions it holds | A history answers what a commitment has added on a calendar date from the additions it holds |
| 9 | A store keeps what it is given before it reports it kept | A store keeps every change it is given before it reports it kept |

### Two scenario lines and seven kept tests are brought into agreement

Grill items 9–12. The two carry-over THEN lines of `tasks.md` 5.1 and 5.2 now say "does not refuse"
and "refuses nothing", as their prose requires, and their tests stay; the seven tests of `tasks.md`
§ 3 take their scenarios' values or are withdrawn, never bent. Rejected: bending the prose to fit.

## Risks / Trade-offs

- **A keeper that does not assert what it is said to** loses a rule no check sees. → A `tasks.md` § 2
  box is ticked only once its keeper's own `#expect` has been read, and `reviewer` confirms each pair
  in source at G7.
- **A test left behind, or the wrong one deleted**, passes `check:scenarios`. → The gates search `src/`
  for all sixteen titles and read the test count off a run on this branch and on `main`.
- **A corrected test that goes red** shows a kept test never proved its scenario. → Reverted, never
  bent to pass (grill item 11); that test stays out of step with its scenario until its own Story.
- **Nine requirements move to the end of the spec**, the tick's definition among them. → Accepted at
  the grill (item 5).

## Open Questions

None. `grill.md` § *Left open* is "None.", every drop and every surveyed candidate has a verdict, and
the nine headings and the two reworded lines were the only wording left to this change, written to
the rules grill items 1 and 12 set. No residual round was raised.
