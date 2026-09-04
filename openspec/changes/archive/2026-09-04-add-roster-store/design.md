## Context

`DayByDayKit` exports `Roster` (`#101`, widened by `#102`), `RecordStore` (`#56`) and `DayScreen`
(`#91`, `#92`, `#93`). Motivation is in `proposal.md`; the behaviour contract is in
`specs/commitment/spec.md` and `specs/day-screen/spec.md` and is not repeated here. What the grill
settled is in `grill.md`, and every decision below either implements one of its answers or was turned
up by writing the delta on top of them.

**Read out of the shipped sources on 2026-09-04, not recalled:**

- `Roster.Entry` and `Roster.entries` are `private`, not internal
  (`Sources/DayByDayKit/Roster.swift:5,10`). `archive/2026-09-03-add-roster-retirement/design.md`
  says #103 "can reach it internally without a delta, as `RecordDocument` already reaches
  `Commitment`'s internal members" — that is true of `Commitment`, whose `schedule` and `keptFrom`
  are internal, and **not** true of `Roster`, where `private` is scoped to `Roster.swift` alone. The
  grill settled the fix: widen both to internal, add no requirement.
- `Roster` is `Hashable`, so `roster == Roster()` is already sayable through the public surface.
  That is the whole of the day-one test, and it is why *holds nothing at all* needs no new member.
- `Commitment.name` is public; `schedule` and `keptFrom` are internal. `CalendarDate.year`, `.month`
  and `.day` are internal. `RecordDocument.swift`'s `CommitmentRecord`, `DateRecord` and
  `ScheduleRecord` already read exactly those, so lifting them into a file of their own moves no
  access level at all.
- `DayScreen` holds `private let commitments: [Commitment]`, and `ContentView.swift` hands it a
  `private let dayOneCommitments` literal. Nothing anywhere constructs a `Roster`.
- `cd src/DayByDayKit && swift test` reports **263 tests passing** at `e5faaef`, on Apple Swift 6.3.3
  (swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`. `DayScreenTests.swift` holds 59 `@Test`s
  and **68 `DayScreen(` construction sites**; every one of them is edited by this change and none of
  their names or assertions may be.
- `openspec` 1.10.0, `node` v24.19.0. ADR numbers: `docs/adr/` holds up to 1026 on `main`, 1025 is
  claimed on `chore/on-the-phone`, so **1027** is the lowest free number, checked against every ref.
- Every weekday named in the delta was checked rather than recalled: 30 August 2026 is a Sunday,
  31 August a Monday, 1 September a Tuesday, 2 September a Wednesday, 4 September a Friday; 1 January
  2026 a Thursday; 1 January 1583 a Saturday and 3 January 1583 a Monday; 27 December 9999 a Monday
  and 31 December 9999 a Friday. Only dates already pinned by shipped scenarios are used.

### A defect found in `openspec/specs/day-screen/spec.md` on `main`

**`/opsx:archive` lost prose when it archived `add-screen-navigation` (#93).** Comparing
`openspec/changes/archive/2026-09-04-add-screen-navigation/specs/day-screen/spec.md` with the main
spec it produced, requirement by requirement:

- *A day screen re-reads its day and its record when the app is shown again* — the main spec still
  carries #91's prose, including the sentence #93's proposal names as no longer true, "This SHALL be
  the only moment a day screen changes day". #93's three replacement paragraphs are absent.
- *A day screen makes and takes back the tick a row offers…* — the main spec still says the tick is
  "asked as of the day the screen holds". #93's paragraph fixing that to *the today, and never the
  day it is showing* — the sentence its proposal calls "the reason the split is not cosmetic" — is
  absent.
- The other two of #93's four MODIFIED requirements landed correctly, and **every scenario landed**,
  though the five new ones belonging to the shown-again requirement were appended under *A day view
  says its day as a weekday and a date…* instead. Two requirement headers are also glued to the
  preceding line with no blank line between (`spec.md:949`, `:1050`).

This is reported rather than routed around (`AGENTS.md` rule 5). Two of the affected requirements are
ones this delta MODIFIES anyway, and MODIFIED "MUST include full updated content" — so restating the
stale text would cement the loss. **Both are restated here with #93's approved prose folded back in**,
which repairs them through the only sanctioned path, `/opsx:archive`. Nothing else is touched: the
five misplaced scenarios stay where they are rather than being moved, because moving them would mean
a MODIFIED block on a requirement this Story has no business in and would risk duplicating them. The
glued headers and the misplaced scenarios are the human's to decide about, and `tasks.md` § 5 records
them.

## Goals / Non-Goals

**Goals:**

- A roster that survives the app being closed, backgrounded, killed or crashing, kept at a place of
  its own so that nothing about a history can take it down and nothing about it can take a history
  down.
- Two seams a test drives with temporary directories and no process, no global stream and no clock —
  one new (`RosterStore`), one already there (`DayScreen`).
- One coding of a commitment on disk, written once and shared by both documents, so that a fifth
  schedule shape is one compile error in one exhaustive switch rather than two.
- A first launch that is a *test*, not a code path: what makes day one happen is a roster equal to
  `Roster()`, which any test can construct and any store can be opened onto.

**Non-Goals:**

- Any way for a person to add, rename or stop a commitment. This Story writes day one and reads a
  roster; #104 gives it a screen. `RosterStore.retire` exists because a store that could not write
  what it can read would have to be reopened by #104, and the grill settled that it mirrors the
  roster's mutators — but nothing on `DayScreen` calls it.
- Reading a stopped commitment, or its kept-until day, back out of a `Roster`. #26's G1 hid stopped
  commitments and no want asks otherwise; the store reaches the entries internally.
- Migrating a roster store. None exists anywhere, so version 1 is the first form.
- Carrying either store to a new phone (B-009), or giving a commitment an identity (B-014).
- Sharing one place between two writers at once. The app has one of each.

## Decisions

### The seam

**Two seams. One is new — `RosterStore`, exported from `DayByDayKit` beside `RecordStore` — and one
is the existing `DayScreen`, widened.** The fifteen `commitment` scenarios attach at the first and
the fifty-five `day-screen` scenarios at the second.

```swift
public final class RosterStore {
    /// Opens the roster store kept at `place`, reading what is there. A place where nothing has
    /// been kept opens holding nothing; a place holding something that cannot be read throws.
    public init(at place: URL) throws

    /// Exactly what is kept at `place`.
    public private(set) var roster: Roster

    /// Kept at `place` before this returns. Answers what `Roster.add` answers — `false`, without
    /// throwing and without writing, when the roster is already keeping `commitment`.
    @discardableResult public func add(_ commitment: Commitment) throws -> Bool

    /// Kept at `place` before this returns. Answers what `Roster.retire` answers — `false`,
    /// without throwing and without writing, when the roster does not hold `commitment` or has
    /// already stopped keeping it.
    @discardableResult
    public func retire(_ commitment: Commitment, keptUntil date: CalendarDate) throws -> Bool
}

public enum RosterStoreError: Error, Equatable, Sendable {
    case notAStore(at: URL)
    case laterForm(at: URL, version: Int)
    case cannotWrite(at: URL)
}
```

`DayScreen` grows a second place, a second state and nothing else public:

```swift
extension DayScreen {
    public enum RosterState: Equatable, Sendable { case kept, notKept, writtenByALaterVersion }
    public static var rosterPlace: URL { get }
    public private(set) var rosterState: RosterState { get }
}

public init(
    startingFrom dayOne: [Commitment],
    asOf today: CalendarDate,
    keepingRecordAt recordPlace: URL = DayScreen.recordPlace,
    keepingRosterAt rosterPlace: URL = DayScreen.rosterPlace
)
```

**Two errors, not one shared with the record's.** `RosterStoreError` repeats
`RecordStoreError`'s three cases rather than being renamed into something both use. The cases mean
the same *kind* of thing and never the same thing: `.laterForm(at:version:)` carries a version from a
document whose version numbers are independent of the record's by the grill's own answer, and a
`catch` that could not tell which store refused would be a bug waiting for #104. Three duplicated
case names cost nothing; a shared error costs the ability to say which file is broken.

**`RosterState.notKept`, where the record has `.unreadable`.** Deliberately not the same word: the
roster's middle case covers one thing more, a place that could be read and could not be *written*,
which is where a failed day one lands. A case named `unreadable` that also meant "unwritable" would
be a lie in the source, and the two states are read by different `switch`es in the shell anyway.
What the *spec* says is the same either way — "it says it is not keeping a roster", with no further
reason — because ADR-1021's argument holds unchanged: a person's one action is the same.

**`init` renames two argument labels: `of:` → `startingFrom:` and `keeping:` → `keepingRecordAt:`.**
Every one of the 68 construction sites is edited regardless, because a second place has to be passed
and no test may be left pointing at the real `Application Support` directory. Given that, keeping
`of:` would cost the same edit and leave the seam saying something untrue — a day screen is no longer
*of* the commitments it is handed; it takes them on once and draws its roster. The rename is what
stops the next reader of `ContentView.swift` believing the literal is the list.

### The roster is kept beside the record, not in one document with it

**Chosen: two files, two stores, two states, at two places.** `record`'s shipped requirement already
says two stores at different places are independent of each other; merging them would put that
independence inside one document, make taking on a commitment a rewrite of the history, and need a
delta on `record` to say so. It would also fuse the two failure modes the delta works hard to keep
apart: one unreadable file would leave a person with neither their commitments nor their record,
where two leave them with whichever still reads.

*Alternative — one document with a `roster` and a `ticks` key.* Cheaper by one file and one version
number, and it is what B-009 would carry either way; the grill's answer notes B-009 carries a
directory, so nothing is gained there. Rejected on the coupling above.

### Day one is the app's content and the engine's moment

**Chosen: `ContentView.swift` keeps the eight commitments; `DayScreen` decides when they are taken
on, and the trigger is `roster == Roster()`.** A store that invented eight commitments would break
its own requirement that it holds only what it was given, and a shell that decided *when* would put
a rule behind a seam no test can reach (ADR-1019's own test: it could be wrong in a way a test would
catch, so it is not the shell's). ADR-1027 carries the decision.

**The trigger is *holds nothing at all*, not *reads back no commitments*.** Retiring keeps the entry,
so a roster whose eight commitments have all been stopped is never equal to `Roster()`, and the cheap
test is exactly right today. **A standing obligation follows, and it is written here so a later
Story finds it in a design review rather than a person finds it on a phone:** any Story that lets a
commitment be *removed* from a roster, rather than stopped, re-arms this trap — a roster emptied by
removal would equal a fresh one and day one would be written over the top of it. That Story owes a
different test for a virgin place, and this paragraph is the line that tells it so, exactly as
`add-record-store`'s design carries the migration obligation for schedule changes.

**Day one is retried, not done once.** The rule is about the roster that was *read*, so being shown
again onto a place that holds nothing takes the commitments on again. That is what makes a first
launch whose write failed recoverable without a force-quit, and it costs one `if` rather than a flag.

### The form on disk

**Chosen: a hand-written JSON document of its own, versioned independently of the record's.**
Version 1 is:

```json
{
  "version": 1,
  "commitments": [
    {
      "commitment": {
        "name": "Gym",
        "keptFrom": { "year": 2026, "month": 1, "day": 1 },
        "schedule": { "weekdays": ["monday", "wednesday", "saturday"] }
      },
      "keptUntil": { "year": 2026, "month": 1, "day": 31 }
    }
  ]
}
```

`keptUntil` is absent for a commitment the roster has not stopped keeping. The commitment object is
byte-for-byte the one `RecordDocument` already writes, because it is the same `CommitmentRecord`.

**The array is in the order the commitments were taken on, and is not sorted.** This is the one place
the two documents differ on purpose, and `CONTEXT.md` § *Roster store* says why: order is one of the
things a roster *is*, so writing a stable sorted order — which `RecordDocument` does, correctly, for
a history that is the same history whatever order its ticks arrived in — would destroy the value.
Byte stability still holds, and for a better reason: two equal rosters have equal orders, and
`.sortedKeys` on the encoder keeps a keyed container's keys off Foundation's per-process hash order.

**Reading back goes through `Roster`'s own mutators, and their answers are checked.** The document is
replayed into a fresh `Roster` with `add(_:)` and, where `keptUntil` is present, `retire(_:keptUntil:)`;
a `false` from either means the document could not be a roster and the whole is refused. That is how
"the same commitment twice" is caught without a second rule, and it is the same trick
`RecordDocument.formTicks()` plays with the engine's failable initializers.

**`CommitmentRecord`, `DateRecord` and `ScheduleRecord` move to `CommitmentCoding.swift`, unchanged.**
ADR-1017 refuses synthesised `Codable` because nobody has read the compiler's encoding of an enum
with payloads; that argument is about the coding being written and signed once, and writing it twice
would double it rather than honour it. A fifth `Schedule` case stays one compile error in one
exhaustive `switch`, which is the property that would be lost by copying. Each document keeps its own
`currentVersion`: the two files can move independently, and a roster form that never changes should
not be dragged to version 2 by a record migration.

### The day screen asks the roster per day it is showing

**Chosen: `DayScreen` holds a `Roster` and calls `roster.commitments(on: shownDay)` every time it
forms a day view.** The alternative — reading the roster once into a `[Commitment]` at open — is what
the screen does today with its literal, and it makes the kept-until day this whole Story exists to
persist unobservable: a stopped commitment would either vanish from every past day or stay on every
future one, and a person looking at last Tuesday would see this Tuesday's list. Asking per day is one
call and no state.

Below the seam this means `DayScreen` steps the date itself — `shownDay.adding(days: -1)` — and forms
the day view directly, rather than calling `DayView.previousDay(of:in:)`, because the commitments to
hand over cannot be known until the date is. `CalendarDate.adding(days:)` is internal and already
returns `nil` past either end of the calendar, which is exactly the refusal `previousDay`/`nextDay`
are built on, so *A move with nowhere to go leaves a day screen exactly as it was* is unaffected and
`DayView.swift` is not edited. The move requirement still defines a screen's move as what moving its
day view gives; that is a statement about the answer, and the answer is identical.

### What a day screen does with two stores

**Chosen: each place is opened, read and reported on entirely separately.** The screen holds
`recordState` and `rosterState` and never derives one from the other, because the two leave a person
different things to do: an unreadable record still draws every row the day asks for and says nothing
is kept about them, while an unreadable roster leaves nothing to draw at all. A single "something is
wrong" state would tell a person to go looking in the wrong file.

**A day screen with no roster draws no rows and takes nothing on.** It is the same refusal `record`
and `commitment` both make — refused whole, left byte-for-byte, never written over — and the seeding
rule is subordinate to it: a roster that will not open is not a roster holding nothing.

**Both are re-read on being shown, unconditionally.** Nothing else writes the roster today, so this
costs one file read per app activation and catches nothing. It is in for #104: a screen that adds a
commitment and a day screen holding a roster read once would disagree, and that bug would land in
#104 as a mystery rather than here as a line.

## Risks / Trade-offs

- **68 construction sites in `DayScreenTests.swift` are edited, in the file whose 59 tests are the
  evidence this change moves where commitments come from and not what a day screen does with them.**
  → `tasks.md` § 1 fixes the mechanical form before any new test is written: one `freshPlaces()`
  helper returning a record URL and a roster URL under one fresh directory, the two labels renamed,
  **no `@Test` name, no assertion, no date and no ordering changed**, and all 263 tests green before
  step 2 begins. A red test at that point is a rule-5 stop, not a test to edit.
- **This is the largest delta in the repository: seventy scenarios, thirty-seven of them new.** That
  follows from the grill's answer to how far the Story reaches — to the screen, so that #103's intent
  sentence is true at the end of #103 — and the size was accepted there rather than here. → `tasks.md`
  takes them one at a time in delta order, and the two halves are separable if the human wants to
  stop after the `commitment` half: `RosterStoreTests.swift` is green on its own with no change to
  `DayScreen` at all.
- **Day one ships the owner's own eight commitments to anyone who installs the app.** → Accepted and
  recorded in ADR-1027 with its reversal trigger; the app is one person's, and B-013's "add a
  commitment" screen is what makes the list a starting point rather than the whole product.
- **A person who stops all eight commitments sees an empty day for ever, with no way back.** →
  Real, and out of this Story: nothing can stop a commitment yet, and #104 is where a way back
  belongs. Named here so it is not discovered as a surprise.
- **Two files double the ways a first launch can half-fail** — a roster written and a record not, or
  the reverse. → Each is refused on its own and reported on its own, and neither is ever written over;
  the screen is usable in all four combinations, and four scenarios pin the two interesting ones.
- **`Roster.Entry` and `Roster.entries` widen from `private` to internal.** Anything in the module can
  now read a stopped commitment and its kept-until day. → No public surface moves, no requirement is
  added, and the only new reader is `RosterDocument`. The alternative is a public read-back on a spec
  that has passed G4 twice, for a caller no screen has asked for.
- **The whole roster file is rewritten on every change**, as the record's is. Eight commitments is
  well under a kilobyte. → Accepted for the same reason ADR-1017 accepts it, with the same reversal
  trigger.
- **The archive that produced `main`'s day-screen spec dropped prose once already.** → Two of the
  affected requirements are repaired by this delta; `tasks.md` § 5 makes checking the archive output
  requirement-by-requirement an explicit step, and a drift found there is a stop rather than a
  hand-edit.

## Migration Plan

None for data: no roster store exists anywhere, on any device, so version 1 is the first form and
nothing is migrated to it. The record's file is untouched — `RecordDocument`'s version stays 1, its
shape stays byte-for-byte what it was, and moving three types between files changes no encoding.

For the spec: the delta claims `commitment` and `day-screen`, both existing, so CI check 2 sees two
claimed capabilities and two touched spec files. `openspec/specs/record/spec.md` and
`openspec/specs/schedule/spec.md` must not appear in the archive diff at all.

## Open Questions

**None.** The grill left none — `grill.md` § *Left open* says so and gives its reason — and writing
the delta on its answers turned up no question that would change what this Story does. Four things
that could have become questions were decided here instead, each with its alternative written down,
because each was a fact or a rule already in the repository rather than a preference the owner holds:

- *What does a day screen say when its roster place can be read but day one cannot be written?* — that
  it is not keeping a roster, and it draws no rows. ADR-1021's own argument settles it: a person's
  single action is the same as for a roster that could not be read, and rows drawn for commitments
  that were never kept are the loss this product exists to prevent. § *The seam* records why the
  Swift case is named `notKept` rather than `unreadable`.
- *Where do the roster store's requirements live — `commitment`, or a capability of its own?* —
  `commitment`, on `add-record-store`'s own reasoning that a store is part of what the thing is.
  `grill.md`'s settled item 3 reads at first glance as "nothing at all is added to `commitment`", and
  the answer wins where it disagrees with a reading of mine; here settled item 7 says in as many words
  that "the delta owes both" `day-screen` **and** `commitment`, so item 3 is read as what its own
  reasoning argues — that no *read-back requirement* is added to the roster, the widening being an
  access level. No requirement of #101's or #102's moves, and none is added about a `Roster`.
- *Does the day screen re-read the roster on a move?* — no, exactly as it does not re-read the record.
  It re-asks the roster it holds about the day landed on, which is not a read. § *The day screen asks
  the roster per day it is showing*.
- *Does `DayScreen` need `RosterStore.retire` at all?* — not for this Story, and it is on the store
  anyway, by the grill's settled item 4. A store that could read a stopped commitment and not write
  one would have to be reopened by #104 for half a member.
