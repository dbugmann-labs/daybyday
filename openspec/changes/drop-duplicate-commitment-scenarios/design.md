## Context

`proposal.md` § *Why* says what this is for, and `grill.md`'s settled answers are what the delta is
written on. `openspec/specs/commitment/spec.md` holds 42 requirements and 406 scenarios; the delta
carries 7 requirements and 64 scenarios, and drops 8. No member is new or changed, which makes this
a *pruning Story*; § *The seam* lists where the keepers' tests attach.

The archiver in `openspec` 1.10.0 refuses a MODIFIED block omitting a current scenario and takes
REMOVED plus ADDED under a new heading, appending each added requirement after every surviving one in
delta order (ADR-1047 decision 2). `pnpm run check:scenarios` reads scenario → test only, so a test
whose scenario is gone passes every check. Every dropped test sits in `CommitmentTests.swift`,
`RosterTests.swift` or `CommitmentsScreenTests.swift`, in the `DayByDayKitTests` target; none is a
UI test.

Six of the seven carried requirements are over 150 words — all but *A commitments screen takes a
commitment it has stopped up again in one tap* — at 163, 281, 333, 339, 350 and 359. Each is
pre-budget prose carried verbatim, which is what the REMOVED-plus-ADDED mechanism requires, so
nothing here can move a count. No requirement in the delta is under 40 words.

## Goals / Non-Goals

**Goals:** the eight drops of grill item 2 and their tests gone, with everything each asserted still
asserted by its keeper under the same requirement; ADR-1047 carrying grill item 3's discriminator and
a decision 5 list that is true; ADR-1049's § Context naming the heading it cites as it now reads.

**Non-Goals:** no requirement prose changed; no scenario title changed; no test added, no kept test
edited and none strengthened (grill item 10); no line under `Sources/` changed; the three withdrawn
candidates of grill item 4 and the forty scenarios grill item 6 bars are all kept; `CONTEXT.md`
unedited. The backlog repoint of grill item 11, the want of item 12, the `docs/open-questions.md`
entry of item 13 and #199's box 15 with its outcome comment all follow the merge.

## Decisions

### The seam

No member is new or changed, which makes this a *pruning Story*. The carried scenarios' tests attach
at:
```swift
Commitment.init?(name: String, schedule: Schedule, keptFrom: CalendarDate, kind: Kind = .tick)
Commitment.kind: Commitment.Kind
Commitment.isDue(on date: CalendarDate) -> Bool
Roster.commitments: [Commitment]
Roster.add(_ commitment: Commitment) -> Bool
Roster.retire(_ commitment: Commitment, keptUntil date: CalendarDate) -> Bool
Roster.remove(_ commitment: Commitment, keptUntil date: CalendarDate) -> Bool
Roster.commitments(on date: CalendarDate) -> [Commitment]
RosterStore.init(at place: URL) throws
RosterStore.roster: Roster
RosterStore.add(_ commitment: Commitment, under category: String?) throws -> Bool
RosterStore.retire(_ commitment: Commitment, keptUntil date: CalendarDate) throws -> Bool
RosterStore.remove(_ commitment: Commitment, keptUntil date: CalendarDate) throws -> Bool
RosterStore.put(_ commitment: Commitment, under category: String?) throws -> Bool
CommitmentsScreen.init(asOf today: CalendarDate, keepingRosterAt place: URL, keepingRecordAt recordPlace: URL)
CommitmentsScreen.kept: [Commitment]
CommitmentsScreen.keptGroups: [Roster.Group]
CommitmentsScreen.stopped: [Commitment]
CommitmentsScreen.rosterState: RosterState
CommitmentsScreen.awaitingConfirmation: Commitment?
CommitmentsScreen.awaitingRemoval: Commitment?
CommitmentsScreen.nameTypedBack: String
CommitmentsScreen.refusedChange: CommitmentsScreen.RefusedChange?
CommitmentsScreen.define(name: String, on rhythm: Rhythm, keptFrom: CalendarDate, under category: String?, kind: KindChoice, lowest: String, highest: String, target: String) -> Refusal?
CommitmentsScreen.change(_ commitment: Commitment, toName name: String, on rhythm: Rhythm, keptFrom: CalendarDate, under category: String?) -> Refusal?
CommitmentsScreen.askToStopKeeping(_ commitment: Commitment)
CommitmentsScreen.confirmStopKeeping() -> Refusal?
CommitmentsScreen.askToRemove(_ commitment: Commitment)
CommitmentsScreen.confirmRemoving() -> Refusal?
CommitmentsScreen.keepAgain(_ commitment: Commitment) -> Refusal?
CommitmentsScreen.move(_ commitment: Commitment, toOffset offset: Int, under category: String?) -> Refusal?
CommitmentsScreen.move(group category: String?, toOffset offset: Int) -> Refusal?
CommitmentsScreen.shown(asOf today: CalendarDate)
```

### Eight scenarios are dropped, and seven headings change as little as keeps each true

Grill items 2, 7 and 14. Rejected: RENAMED, per ADR-1047 decision 2; splitting the seven renames
across two Stories (item 7); sparing a requirement's base or headline case (item 14); dropping the
three candidates a full verification passed and mutation then withdrew (item 4).

| # | Dropped | Keeper, which asserts the same | Test file |
|---|---|---|---|
| 1 | a commitment reads back the kind it was given | a commitment of each of the four kinds is formed and reads its kind back | `CommitmentTests` |
| 2 | stopping a commitment a roster keeps says so and takes it out of the commitments read back | a commitment kept until a day before the day it is kept from is accepted | `RosterTests` |
| 3 | two commitments alike in name and not in rhythm are two entries a person cannot tell apart | two commitments alike in name and not in rhythm are told apart by the rhythm their entries say | `CommitmentsScreenTests` |
| 4 | a commitment taken up again through a commitments screen is in the place it was taken on in | a commitment taken up again through a commitments screen moves from what it has stopped to what it keeps | `CommitmentsScreenTests` |
| 5 | a commitments screen holds a refused stop against the commitment it was asked to stop | a commitments screen refused twice holds only the change it was asked for last | `CommitmentsScreenTests` |
| 5 | a commitments screen that has been asked for no change holds no refused change | a commitments screen holds nothing against a call that changes nothing at all | `CommitmentsScreenTests` |
| 6 | a commitment dropped among another group's entries is put under that group's category | an offset a commitments screen is given is counted over the group a drop landed in and not over the roster's own order | `CommitmentsScreenTests` |
| 7 | a commitments screen refuses a range whose lowest is above its highest | a range a commitments screen refuses is told apart from a target and from its other refusals | `CommitmentsScreenTests` |

| # | Removed | Added |
|---|---|---|
| 1 | A commitment's kind is a tick, a number, a note or a total | A commitment's kind is exactly one of a tick, a number, a note or a total |
| 2 | A roster stops keeping a commitment, on the day it was kept until | A roster stops keeping a commitment it holds, on the day it was kept until |
| 3 | A commitments screen lists the commitments its roster keeps, in the order they were taken on | A commitments screen lists the commitments its roster keeps, in the order the roster answers with |
| 4 | A commitments screen takes a stopped commitment up again in one tap | A commitments screen takes a commitment it has stopped up again in one tap |
| 5 | A commitments screen holds the change it refused and why, one at a time | A commitments screen holds the change it refused and why it was refused, one at a time |
| 6 | A commitments screen moves a commitment among the ones it keeps | A commitments screen moves a commitment among the ones it is keeping |
| 7 | A commitments screen refuses a range that is not a range, and a target that is not a target | A commitments screen refuses to define a commitment whose range is not a range, or whose target is not a target |

Row 2's keeper is not the obvious neighbour: *stopping one commitment leaves the others where they
were* discards what the roster reports, so naming it would split the cover across two scenarios.
Row 3's new heading no longer repeats a scenario title under it, and every new heading is distinct
from the one it replaces, which is the only distinctness the mechanism asks for.

### Two documents outside the spec are edited here, and no in-spec reference moves

Grill items 3, 8 and 9. ADR-1047's decision 6 gains how condition 1 is proven, and its decision 5
reads two false titles rather than three, this change dropping the first. ADR-1049's § *Context*
takes row 5's new heading. No in-spec cross-reference points at any of the seven; the quotes under
`docs/research/` are dated survey records and stay as they are.

## Risks / Trade-offs

- **A keeper that does not assert what it is said to** loses a rule no check sees. → A `tasks.md` § 2
  box is ticked only once its keeper's own `#expect` has been read, and `reviewer` confirms each pair
  in source at G7.
- **A test left behind, or the wrong one deleted**, passes `check:scenarios`. → The gates search
  `src/` for all eight titles and read the test count off a run on this branch and on `main`.
- **The four surveys under `docs/research/` are wrong in the places grill item 15 lists**, 68 of
  their 71 candidates being keeps. → Nothing here is read back off them; the drop set is item 2's.
- **Seven requirements move to the end of the spec**, the commitment's own kind among them, and the
  first gap opens at position 3. → Accepted at the grill (item 7).
- **Two latent test weaknesses are known and untouched** (grill item 12). → No drop rests on either;
  they go to the backlog as one want after G4.

## Open Questions

None. Every question this change raised is settled in `grill.md`, whose § *Left open* is "None." —
every requirement in the spec was walked, every survey candidate has a verdict, and the three cases
still arguable after confirmation were re-tested and settled there.
