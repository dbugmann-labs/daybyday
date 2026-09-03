## Context

`DayByDayKit` exports six seams today: `Schedule.isDue(on:)` (#8, #9, #10, #11), `Commitment` (#42),
`Tick`/`History` (#55), `RecordStore` (#56), `DayView` (#70) and `DayView.Row.tick(asOf:)` (#71),
with `DayView.previousDay`/`nextDay` added by #72. Every one of them is a pure value over
`CalendarDate` with no clock, no time zone and no locale (ADR-1004) — apart from `RecordStore`,
which is a reference to a file and the only thing in the package that can fail for a reason outside
its arguments. Since #81 there is also a caller: `src/DayByDay`, the app shell ADR-1019 built on a
chore branch, which draws `DayView.rows` in the iOS Simulator and decides nothing. Motivation is in
`proposal.md`; the behaviour contract is in `specs/day-screen/spec.md` and is not repeated here.

What is new is that this is the first thing in the package that is **not a value**. A day view is
what it holds and two of them a reader could not tell apart are the same day view; a day screen
holds one, holds a store, holds a today, and changes over time. That makes the interesting questions
four: what a day screen is made of, how a change reaches it and gets back out, where its record
lives, and what it is when the record will not open.

**Measured on this machine on 2026-09-03 rather than recalled.** `cd src/DayByDayKit && swift test`
reports **164 tests passing** at `c05e500`, on Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target
`arm64-apple-macosx26.0`; `openspec` is 1.10.0 and `node --version` is v24.19.0. Every weekday this
delta pins was checked twice — once in Python's proleptic Gregorian calendar and once in
Foundation's own `.gregorian` calendar under UTC, the calendar `CalendarDate` uses — and both agree:
in 2026, 31 August is a Monday, 1 September a Tuesday and 2 September a Wednesday; 1 January 2026 is
a Thursday, deliberately not a day any schedule here is due on, because a commitment need not be
kept from a due day (ADR-1013). 3 January 1583 and 27 December 9999 are both Mondays, which is what
lets one scenario pin both ends of the supported range against the same weekday set.

**Three facts about the environment, probed on 2026-09-03 rather than remembered:**

- A probe package with `platforms: [.iOS(.v17), .macOS(.v14)]`, `swift-tools-version: 6.3` and
  `swiftLanguageModes: [.v6]` compiles a `@MainActor @Observable public final class`. The same
  package with the `platforms:` line removed fails: `'Observable()' is only available in macOS 14.0
  or newer`, and `'ObservationRegistrar' is only available in macOS 14.0 or newer` from inside the
  macro expansion. So the platform floor is required by `@Observable` and is not a preference.
- `FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)` returns exactly
  one URL on this machine, `/Users/digib/Library/Application Support`, and it exists. The caches
  directory is `/Users/digib/Library/Caches` and `NSTemporaryDirectory()` is under `/var/folders`,
  so all three are distinguishable by path, which is what makes § *The place* testable. On iOS the
  same call resolves inside the app's own container, at `<container>/Library/Application Support`,
  which is why the delta's scenarios test the path's shape rather than an absolute string.
- The app's `IPHONEOS_DEPLOYMENT_TARGET` is 26.0 (ADR-1019, measured there), and the kit currently
  declares no `platforms:` and builds under it at its default iOS 12 floor. Raising the kit's floor
  to iOS 17 therefore takes away no platform anything actually runs on.

**Five facts about the shipped code that this design stands on, read out of the sources:**

- `RecordStore.init(at:)`, `.history`, `.add(_:)` and `.remove(_:)` are public, as are
  `RecordStoreError`'s three cases — `notAStore(at:)`, `laterForm(at:version:)` and
  `cannotWrite(at:)`. Everything this Story needs to read a record, keep one, and tell the
  later-version refusal apart from the rest exists already.
- `RecordStore.history` is `public private(set)`. A store cannot be handed a replacement history, so
  a day screen must re-read the store's own history after every change rather than compose one.
- `RecordStore.write` calls `createDirectory(at:withIntermediateDirectories: true)` on the place's
  parent before writing atomically. A place under a directory that does not exist yet is therefore
  created on the first tick, so § *The place* owes no directory-creation requirement of its own.
- `RecordStore.init` opens empty when nothing is at the place (`FileManager.fileExists` is false)
  and throws otherwise for anything it cannot read. It can also throw outside `RecordStoreError` —
  `docs/open-questions.md` § *Known gaps* — which § *Every refusal is one refusal* is the answer to.
- `DayView.Row` is public and `Hashable`, carries its own date since #71, and exposes `name`,
  `isKept` and `tick(asOf:)`. `DayView.init(of:on:in:)` is public. A day screen needs no widening of
  either, and this delta widens neither.

## Goals / Non-Goals

**Goals:**

- One object that holds what a person is looking at and everything it takes to answer and to keep an
  answer, so that every judgement the app makes is inside `DayByDayKit` and testable.
- A tap that is one call, with no branch left in the view: which of make-or-take-back it means is
  read off the row, and the day comes from the screen.
- A record kept somewhere it survives, chosen by the capability that owns the screen rather than by
  the shell that draws it.
- A failure mode that loses nothing. A record that will not open, and a change that will not write,
  both end with the person seeing exactly what is on the disk and nothing more.
- Purely additive. #70, #71 and #72's six requirements were signed between 2026-09-02 and
  2026-09-03 and none of them moves; the delta is five ADDED requirements and no MODIFIED one, and
  it touches no other capability.

**Non-Goals:**

- **Saying which day it is.** `CalendarDate`'s `year`, `month` and `day` are internal and it is not
  `Comparable` (`docs/open-questions.md` § *Known gaps*); reading a date back out is a `schedule`
  delta and is #92's whole Story. This screen knows its day and cannot yet say it.
- **Moving between days.** `DayView.previousDay`/`nextDay` shipped with #72 and this screen calls
  neither. #93 wires them, and only then can a day screen hold a day other than the one it was shown
  on — which is why the delta says a screen changes day only when the app is shown.
- **Anything drawn.** Colours, gestures, what a screen without a record looks like, and what a
  refused tick shows are the shell's. `docs/open-questions.md` § *No UI smoke layer* is unchanged.
- **Defining commitments from the phone.** The day-one week stays hard-coded in
  `ContentView.dayOneCommitments`, exactly as #81 left it. The commitment's lifecycle is cluster B
  in `docs/backlog.md`, and the owner took it forward separately.
- **Backup, restore or migration.** B-009's, and there is no record on any device to migrate: this
  Story is the first thing that ever writes one.
- **Widening `record`, `commitment` or `schedule`.** Nothing in those capabilities changes. The
  fourth `RecordStoreError` case the known gap describes is deliberately not added: the one refusal
  this screen tells apart is `RecordStoreError.laterForm`, which is public already, and everything
  the gap describes stays one refusal. § *One refusal is told apart* says why.
- **Retrying a change that could not be kept.** A refused tick is refused; nothing queues it. That
  is the same trade `record` already took and the whole point of ADR-1021.

## Decisions

### The seam

**New: `DayScreen`, one type in `DayByDayKit`.** A new seam rather than a widening, because there is
nothing here to widen: `DayView` is a value and this is deliberately not one. `CONTEXT.md`
§ *Day screen* named it before this Story existed.

```swift
@MainActor
@Observable
public final class DayScreen {
    /// What a day screen is doing with the record at its place.
    public enum RecordState: Equatable, Sendable {
        /// The record was read, and a tick made on this screen is kept.
        case kept
        /// The record could not be read, for a reason a person cannot act on differently.
        case unreadable
        /// The record was written by a later version of DayByDay. It is whole; the app is what is
        /// behind, and what is at the place must not be replaced.
        case writtenByALaterVersion
    }

    /// The place a day screen keeps its record when it is not told another.
    public static var recordPlace: URL { get }

    /// Opens on `today`, reading the record kept at `place`.
    public init(
        of commitments: [Commitment],
        asOf today: CalendarDate,
        keeping place: URL = DayScreen.recordPlace
    )

    /// The day view the person is looking at, as the record stood when it was last read.
    public private(set) var dayView: DayView

    /// Anything but `.kept` means the day is drawn from no record at all and no tick is taken.
    public private(set) var recordState: RecordState

    /// Makes the tick `row` offers, or takes it back where `row` says its commitment is kept, and
    /// keeps the change before `dayView` says so. Does nothing when `row` is not one this screen's
    /// day view holds, or when this screen is not keeping a record. Throws when the change could
    /// not be kept, leaving `dayView` as it was.
    public func tick(_ row: DayView.Row) throws

    /// The app has been shown on `today`: the day view and the record are read again.
    public func shown(asOf today: CalendarDate)
}
```

Internally it holds the commitments, the place, the day, and a `RecordStore?` that is `nil` exactly
when `recordState` is not `.kept`. Twenty-eight scenarios drive that surface. No process is spawned
and no global stream is captured; the only thing outside the seam's own arguments is the file at
`place`, which every test points at a directory of its own.

The shell's whole use of it is four things, and there is no fifth:

```swift
@State private var screen = DayScreen(of: dayOneCommitments, asOf: today())
...
List(screen.dayView.rows, id: \.self) { row in
    Button { try? screen.tick(row) } label: { Text(row.name) }   // plus whatever it draws
}
.onChange(of: scenePhase) { _, phase in
    if phase == .active { screen.shown(asOf: today()) }
}
```

The shell's one branch is over `recordState`, and it is a `switch` with no judgement in it: `.kept`
draws nothing extra, `.unreadable` says the record could not be read, and `.writtenByALaterVersion`
says the record was written by a newer version of DayByDay and must not be deleted.

### Where the day comes from, and how long it is held

**Chosen: handed in at `init` and at `shown(asOf:)`, held in between.** No clock enters the package,
as ever; what is new is that a day screen *keeps* the day it was handed.

This is an amendment to `CONTEXT.md` § *Today* rather than a contradiction of #71, and the amendment
is already landed (`c05e500`). #71 argued that the day should arrive *with the question* so that a
day view held across midnight does not refuse today's tick on last night's reckoning, and
`Row.tick(asOf:)` still works exactly that way — it takes a day per call and keeps none. What
changes is the caller: the day screen supplies a held day rather than a freshly read one, because a
screen that silently changed day underneath a person mid-tap is a worse failure than a screen that
is a few hours stale. The staleness window is now the length of a foreground session and it closes
the moment the app is shown, which is exactly what the owner settled at the Feature grill.

*Alternative — read the clock inside `DayScreen`.* Rejected outright: it puts a clock in the package
for the first time, makes every acceptance test time-zone-dependent, and gains nothing the shell's
existing `today()` does not already give. ADR-1004.

*Alternative — a day screen with no day of its own, asked for one at every call.* Rejected: it makes
`dayView` a function rather than a property, which `@Observable` cannot drive, and it moves the
"which day am I on?" decision back into the SwiftUI body, where nothing tests it.

### A tick takes a row, and a row the screen does not hold changes nothing

**Chosen: `tick(_ row: DayView.Row) throws`, ignoring any row `dayView.rows` does not contain.**

#71 rejected handing a whole `Row` to `DayView`, because rows were values with no provenance and one
from another day view would have been answered on *this* view's date. That objection is dead: #71
itself gave `Row` its date, so a foreign row is now recognisable by value, and a `contains` check is
the whole guard. It is worth having rather than merely cheap — with `shown(asOf:)` in the seam, a
shell holding a row from before the day turned over is not hypothetical, and the alternative is
that a stale tap writes a tick to a day the person is no longer looking at and sees nothing happen.

*Alternative — `tick(rowAt index: Int)`.* Rejected: an index needs a bounds check, and `nil`-ing or
trapping on a bad one is a second failure mode that says nothing about what went wrong. A stale
index is also *silently valid*, which is worse than a stale row: after the day turns over, index 2
still exists and now names a different commitment.

*Alternative — the screen forms the tick itself from the row's commitment.* Rejected: it would need
the row to give back its commitment, which `day-screen`'s own signed requirement forbids ("It MUST
NOT give back the commitment itself, the schedule underneath it, the day it is kept from, or the
date the row is for"), and it would duplicate the judgement `Row.tick(asOf:)` exists to make.

**Which of make-or-take-back a tap means is read off `row.isKept`, not given.** That is #71's
settled answer restated at the screen — "the same tick makes the record and takes it back; which of
the two a tap means is read off whether the row already says it is kept" — and it is what keeps the
SwiftUI body free of the one branch it would be easy to invert.

### What `tick` reports, and what it stays silent about

**Chosen: `throws`, and exactly one thing throws — a change the store refused to keep.** The two
other ways nothing happens are silent.

The three ways a tick can come to nothing are not alike, and the seam treats them by whether the
caller could have known:

| Why nothing happened | Reported how |
|---|---|
| the row is not one this screen holds | silent — the screen's day view is what a shell draws, so it cannot happen without a bug the shell can see |
| the screen is not keeping a record | silent — `recordState` already said so, before the tap |
| the store refused the write | **thrown** — nothing said it would fail, and a person must be told |

*Alternative — a result enum with a case per outcome.* Rejected as the same shape #71 already
rejected on this capability: its content is `(recordState, dayView.rows.contains(row), didWrite)`,
all of which the caller already has, so it buys one public type and a `switch` where an `if` would
do. Nothing in the delta becomes unassertable without it.

*Alternative — throw for the no-record case too.* Rejected because it would make the common,
already-announced condition an exception, and because the shell would then have two places to
explain the same state — a banner and a caught error — which is exactly where the two drift apart.

**`throws` and not `throws -> Bool`.** Whether the day view changed is readable from the day view.

### The place

**Chosen: `DayScreen.recordPlace`, `<Application Support>/DayByDay/record.json`, as a default
argument on `init`; tests pass a directory of their own.**

`docs/open-questions.md` § *Known gaps* assigns this to "the first Story that persists a tick from
inside the app" and says why it cannot be the shell's: "a place a store is opened at is exactly the
kind of decision that fails `CONTEXT.md` § *App shell*". It cannot be `record`'s either — a store
"keeps the record at whatever place it is given and cannot enforce the choice from where it sits" —
so it lands here, on the thing that opens the store.

The directory is the right one on both platforms this repository has run on, for different reasons:
on iOS `Application Support` is inside the app's own container, backed up and never purged; on macOS
it is shared, which is why the app's own subdirectory is part of the requirement rather than
decoration. `Caches/` is purged under space pressure and `tmp/` is excluded from backups, and losing
a record to either is precisely the failure ADR-1001 says the product exists to remove.

`record.json` follows ADR-1017 — one versioned JSON file, written whole and atomically. This delta
does not name the file's extension as a requirement, because ADR-1017 already owns the form and a
Story that changed it should not have to re-sign a `day-screen` requirement to do so.

**A default argument, not a hard-wired place**, because a hard-wired place is untestable without
touching the real `Application Support`, and a place with no default puts the choice back in the
shell. The default is the only value the shell ever passes and it does not name it, so nothing
outside this capability decides where the record lives. Three scenarios test `recordPlace` directly
and every other scenario passes a temporary directory.

### A day screen without its record draws the day and keeps nothing

**Chosen: opening never fails. A store that will not open leaves `recordState` at something other
than `.kept`, the day view formed from a history that has taken no tick, and every tick refused.**

This is the owner's decision at the Feature grill on 2026-09-03, and it is recorded as **ADR-1021**
because a future reader meeting a screen whose rows all say "not kept" against a record nobody could
read will otherwise assume it is a bug. The three alternatives and the reasoning are in the ADR;
what belongs here is the consequence for the seam. `recordState` is a `var` and not a `let`,
because the condition is not always permanent — a store protected by data protection before first
unlock is the case `docs/open-questions.md` names — so § *Showing the app again* re-opens it.

Rows saying "not kept" is a compromise and is stated as one: a day view has two states per row and
no third, adding one would MODIFY a requirement signed on 2026-09-02, and every scenario under it
would be copied forward to add a case nothing else in the product has asked for. The screen carries
the missing information beside the day view instead, which is enough for the shell to draw the
difference. If a third row state is ever wanted, it is its own Story.

### One refusal is told apart, and exactly one

**Chosen: `DayScreen` catches every error `RecordStore.init` can throw. It answers all of them the
same way — the day drawn, no tick taken, the file left alone — and it *says* which it was for one:
a record written by a later version of DayByDay.** Settled by the owner on 2026-09-03, on the
question round below.

The behaviour is one behaviour, so `recordState` is one value with three cases rather than a flag
plus an error. The split falls where a person's correct next action differs, and it differs in
exactly one place. A record written by a later version is **whole** — `record` refuses it because
the *app* is behind, not because the file is damaged — and the right response is to update the app
and leave the file completely alone. A screen that says only "something is wrong with your record"
invites the one action that loses it: delete it and start again. That is the loss ADR-1001 says the
product exists to remove, so this reason is worth a case of its own. Every other reason — bytes that
are not a record, a tick that could not be formed, a directory at the place, a file with no read
permission, an iOS store still protected before first unlock — leaves a person the same single
thing to do, and telling those apart buys a case the shell would have nothing different to say
about.

**This still needs no change to `record`, and the fourth-case gap stays open.**
`RecordStoreError.laterForm(at:version:)` already exists and is public — read out of
`RecordStore.swift`, not recalled — so the one distinction is a `catch RecordStoreError.laterForm`
and nothing more. `docs/open-questions.md` § *Known gaps*, "`RecordStore.init` can throw outside
`RecordStoreError`", is met by this Story and deliberately left open: everything that escapes as a
raw Foundation error lands in `.unreadable` alongside `notAStore`, so a fourth case would still buy
this capability nothing, and catching only `RecordStoreError` would let a raw error escape an
initializer that cannot throw, which means trapping. `record` is untouched by this delta, and the
change stays inside `day-screen`.

*Alternative — say the reason for all four.* Rejected on the owner's answer, and worth recording
why it is not merely "less work": the other three reasons are indistinguishable *to the person*.
Three shell strings that all mean "your record could not be read, and there is nothing you can
usefully do about it" are three chances to word one of them into sounding like an instruction to
delete the file.

*Alternative — expose the caught error itself, `Error?` or `RecordStoreError?`.* Rejected. It
cannot be `RecordStoreError?` while raw Foundation errors escape (the gap above), so it would have
to be `Error?` — which the shell cannot switch over, and which a test can only assert against by
matching a message. It also re-exposes every refusal the owner just said to treat alike.

*Alternative — keep `keepsRecord: Bool` and add a second flag.* Rejected: two booleans make four
combinations, one of which — keeping a record *and* it being from a later version — is nonsense that
nothing in the type prevents.

### Showing the app again re-reads both the day and the record

**Chosen: `shown(asOf:)` replaces the day, re-opens the store, and re-forms the day view. It is the
only thing that changes a day screen's day.**

The day half is the owner's, settled at the Feature grill: "the day is re-read when the app is
shown, so the morning visit lands on the morning". The record half is this design's, and it comes
free — the same three lines already run — while fixing something the day half alone would not: a
screen opened before the device was first unlocked would otherwise stay recordless until the person
force-quit the app, which is the one recovery step nobody thinks to take. There is no case where
re-reading is wrong: only this app writes to the place, so a re-read either sees the same thing or
sees something a person's own restore put there.

*Alternative — re-read only when the day has actually changed.* Rejected: it saves one file read per
foregrounding of a file measured in kilobytes (ADR-1017), and it is exactly the branch that would
keep a recordless screen recordless.

### Observation crosses the seam, and the platform floor comes with it

**Chosen: `DayScreen` is `@Observable` and `Package.swift` gains
`platforms: [.iOS(.v17), .macOS(.v14)]`.** Measured, not assumed: the floor is required by the macro
and the app already targets iOS 26.

`Observation` is a standalone framework in the Swift toolchain, not SwiftUI, so the kit still
imports no UI framework and still builds and tests from the terminal with `swift test`. What it buys
is that the shell holds no copy of the day view and writes no line to keep one in step — which
matters more here than it would in most repositories, because `docs/open-questions.md` § *No UI smoke
layer* means every line in the SwiftUI body is a line nothing tests.

*Alternative — `DayScreen` as a struct with mutating methods, held in `@State`.* Needs no floor and
no `Observation`, and SwiftUI would redraw on mutation because `dayView` changes. Rejected because a
day screen is an identity and a struct invites the one bug that matters: it holds a `RecordStore`
reference, so a copy shares the store while diverging in `dayView`, and two copies would each write
over the other's ticks with a stale set. A `final class` cannot be copied by accident.

*Alternative — a plain `final class` with the shell mirroring `dayView` into its own `@State`.*
Rejected: it moves two lines of state-keeping into the untested body and gives them the chance to be
forgotten after `tick` or after `shown`.

**`@MainActor`** because a day screen is a screen and does synchronous file I/O on the caller's
thread; it is also what satisfies Swift 6 strict concurrency around the non-`Sendable`
`RecordStore`. Tests are `@MainActor` for the same reason, which Swift Testing supports directly.

### One Story, five requirements

This is the largest delta in the repository — twenty-eight scenarios against #71's fourteen — and it
was checked for a seam down the middle rather than assumed indivisible. There is not one. A screen
that reads a record but cannot write is not a thing anybody wanted; a screen that writes but does not
survive a quit is the bug this Story exists to fix; and a screen that survives a quit but keeps its
record in `tmp/` survives nothing. The Feature's G2 already made the two cuts that were available —
saying the date is #92 and moving between days is #93 — and what is left is one screen.

## Risks / Trade-offs

- **A record that will not open looks exactly like a record with nothing in it, row by row.** →
  Accepted deliberately and recorded as ADR-1021; the screen says which it is beside the day view,
  and the shell has everything it needs to draw the difference. The residual risk is that the shell
  draws nothing and a person reads an empty day as a real one — and that risk lives in the layer
  `docs/open-questions.md` § *No UI smoke layer* already flags.
- **The one refusal that must not be misread is the one nothing automated draws.** → A record from
  a later version is told apart in the seam and two scenarios pin it, but what a person actually
  reads is a string in the SwiftUI body, which nothing tests (`docs/open-questions.md` § *No UI
  smoke layer* again). The mitigation is that the seam makes the case impossible to miss — a
  `switch` over three cases will not compile with one forgotten — where a boolean would have let the
  shell silently draw the wrong sentence.
- **The shell can pass any day as `today`, including a wrong one.** → The same trade #71 took, and
  the same mitigation: there is exactly one caller, one line, and `ContentView.today()` is already
  the right conversion. A wrong day cannot corrupt the record; it shows the wrong day's rows.
- **The screen's day goes stale while the app is in the foreground.** → Deliberate, and the owner's
  choice at the Feature grill. Someone reading the screen at 23:59 still sees yesterday at 00:01 and
  can tick it, which is correct — the past is writable — and the day corrects itself the next time
  the app is shown. The alternative moves a person's screen underneath them mid-tap.
- **A tick that could not be written is simply lost.** → `record`'s own contract, carried through:
  the history a store reports is never ahead of what is kept. `tick` throws so the shell can say so,
  and nothing queues the tap. Queuing is what ADR-1021 refuses.
- **`@Observable` raises the kit's platform floor to iOS 17 / macOS 14.** → Nothing runs below it;
  the app is iOS 26 and CI is `macos-26`. Reversing it costs the struct-shaped alternative above,
  which is argued rather than merely dismissed.
- **`Row` equality identifies rows, and two rows can be equal.** →
  `docs/open-questions.md` § *Known gaps* records this against the shell, and it now decides which
  row a tap changes rather than only how a list draws. It still cannot bite — the day-one week holds
  no duplicate and this Story adds no way to make one — and the fix remains the shell's, for
  whichever Story first draws a list a person can add to.
- **Every test in the delta writes to the file system.** → Each one gets a directory of its own
  under the system temporary directory and removes it afterwards, exactly as `RecordStoreTests`
  already does; the delta's three `recordPlace` scenarios ask for a path and never write to it, so
  no test touches the real `Application Support`.

## Open Questions

**None.** Everything the grill raised was a fact that was measured or read out of the shipped
sources, or a decision made above with its alternatives beside it. The one thing that was a
preference rather than a fact went to the owner as a question round, and it has been answered and
folded in — it is the first entry below.

- *When the record cannot be read, does the screen say why, or only that it could not?* — **asked
  and settled by the owner on 2026-09-03, and the answer was neither of the two this design
  offered.** Not "only that it could not" (this design's recommendation) and not "the reason for
  all four": **the reason for exactly one — a record written by a later version of DayByDay — and
  every other refusal alike.** The reasons are not alike, which is what both offered answers
  missed. For a later-version record the correct human response is *do not touch this file, update
  the app*, and a screen saying only "something is wrong with your record" invites the one action
  that loses the record, which is the failure this product exists to remove. The other reasons carry
  no distinct action, so distinguishing them buys nothing. What moved: the fourth requirement gained
  a paragraph and one scenario, the fifth gained a clause and one scenario, and `keepsRecord: Bool`
  became `recordState: RecordState` with three cases. What did not move: `record` is untouched —
  `RecordStoreError.laterForm` already exists — the fourth `RecordStoreError` case stays a known gap
  in `docs/open-questions.md` and not this Story's to close, and the delta stays inside
  `day-screen`. § *One refusal is told apart, and exactly one*.

- *Where does the day come from, and does a screen keep one?* — settled at the Feature grill on
  2026-09-03 and already landed in `CONTEXT.md` § *Today*: handed in when the app is shown, held
  until it is shown again, never read from a clock. § *Where the day comes from* argues the seam.
- *Does that contradict #71's "the day arrives with the question"?* — no, and it was checked against
  #71's `design.md` rather than assumed. `Row.tick(asOf:)` still takes a day per call and keeps
  none; the day screen is a caller that supplies a held one. § *Where the day comes from*.
- *Who chooses where the record is kept?* — read out of `docs/open-questions.md` § *Known gaps* and
  `CONTEXT.md` § *App shell*: not `record`, which cannot enforce a place from where it sits, and not
  the shell, which decides nothing. This Story, which is what that gap entry says.
- *Can `RecordStore` throw something that is not a `RecordStoreError`?* — read: yes, and it is a
  documented gap. Settled by catching everything and landing all of it in one case,
  § *One refusal is told apart, and exactly one*. The gap stays open on purpose.
- *Does telling the later-version case apart need a new `RecordStoreError`?* — read out of
  `RecordStore.swift` rather than assumed: no. `laterForm(at:version:)` is already one of the three
  public cases and is thrown from `init` exactly where the envelope's version is greater than the
  form this app writes. So the owner's answer costs a `catch` clause and no `record` delta.
- *Does the place need creating before the first tick?* — read: no. `RecordStore.write` creates
  intermediate directories before writing, so the delta owes no requirement for it.
- *Does `@Observable` need a platform floor?* — probed on this machine, both ways. It does, the
  error is quoted in § *Context*, and nothing runs below the floor.
- *Can a row this screen holds ever refuse its tick?* — reasoned from the delta rather than left
  open: a day screen holds only rows of its own day, and it asks as of that same day, so
  `Row.tick(asOf:)` never refuses on this Story's screen. It becomes reachable with #93, which is
  why the requirement says the tick is "the one the row itself offers" and no scenario tries to pin
  an unreachable refusal.
- *Does anything here force the week-turnover product question?* — no. Nothing in this delta reads a
  week, and a quota commitment simply has a row every day, as ADR-1015 already says. B-025 and
  `docs/open-questions.md` § *Open product questions* are untouched.
- *Should this Story be split?* — asked and answered against a real cut rather than dismissed;
  § *One Story, five requirements*.
