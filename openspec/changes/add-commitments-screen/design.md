## Context

`FEAT: commitment` (#26) has shipped a commitment, a roster, a kept-until day and a roster store.
Between them they can take a commitment on, refuse a duplicate, stop keeping one, take a stopped
one up again and keep all of it across the app being closed. **A person can reach none of it.**
The only caller of `RosterStore.add` in the product is day one, writing the same nine commitments
that were already compiled into `ContentView.swift`, and `RosterStore.retire` has no caller at all.

This Story is the screen that reaches them, and its grill ran twelve questions over four rounds.
Three of those twelve were parked here by name by earlier Stories: whether stopping confirms first,
how something stopped is taken up again, and the stale-roster bug `add-roster-store`'s design
predicted would "land in #104 as a mystery". `grill.md` § *Settled* is the answer to all twelve and
this delta is written on it.

Two things were left to this document rather than to the human, both of them design questions
whose answers follow from what is already in the repository: whether the commitments screen shares
a `RosterStore` with the day screen or opens its own, and by what mechanism the day screen re-reads
on being returned to. § *The seam* and § *Being returned to is not being shown* answer them.

Everything measured below was measured on this machine on 2026-09-04, from `566297e`, the `main`
this branch is rebased onto: Apple Swift
6.3.3, `cd src/DayByDayKit && swift test` reporting **300 tests passing**, `openspec` 1.10.0, Node
v24.19.0.

## Goals / Non-Goals

**Goals**

- One screen a person manages a roster from: what they keep, what they have stopped, a form that
  defines a new commitment, a way to stop keeping one and a way to take a stopped one up again.
- All four rhythms creatable, thinly. `CONTEXT.md` § *Five percent of seven things*.
- A commitment defined on one screen visible on the other without the app being backgrounded.
- Every refusal a person can act on differently told apart from the others, and every refusal that
  leaves them the same single action told alike.

**Non-Goals**

- **Editing a commitment already taken on.** B-014 is still a want and G1 left it there on the
  ground that changing a commitment does not compose: a commitment carries no identifier, so a
  rename is a different commitment and `History.isKept` matches by value.
- **Saying a rhythm in words on a row.** B-021 is a delta against
  `openspec/specs/schedule/spec.md` and G1 put it out of this Feature. A kit-side screen inventing
  its own wording would be that requirement written in the wrong capability.
- **Searching, sorting or grouping either list.** Both are in the order the roster took its
  commitments on, which is the roster's own answer.
- **Any change to day one.** ADR-1027 stands untouched: the commitments screen never writes day
  one, and § *A commitments screen never writes day one* says why it must not.
- **A commitment identity (B-014), carrying a store to a new phone (B-009), a fifth rhythm.**

## Decisions

### The seam

**Two seams. One is new — `CommitmentsScreen`, exported from `DayByDayKit` beside `DayScreen` —
and one is the existing `DayScreen`, which gains one method.** The forty `commitment` scenarios
attach at the first and the eleven `day-screen` scenarios at the second — of which four are
restated verbatim under MODIFIED and already have their tests, so forty-seven tests are written.

```swift
@MainActor
@Observable
public final class CommitmentsScreen {
    /// The place a commitments screen keeps its roster when it is not told another: exactly the
    /// place a day screen keeps its. A static, so that a test can assert the two agree without
    /// opening the real Application Support directory.
    public static var rosterPlace: URL { DayScreen.rosterPlace }

    /// Opens on `today`, reading the roster kept at `place`.
    public init(asOf today: CalendarDate, keepingRosterAt place: URL = CommitmentsScreen.rosterPlace)

    /// The commitments the roster is keeping, in the order they were taken on.
    public private(set) var kept: [Commitment]

    /// The commitments the roster has stopped keeping, in the order they were taken on.
    public private(set) var stopped: [Commitment]

    /// Anything but `.kept` means both lists are empty and nothing is taken on.
    public private(set) var rosterState: RosterState

    /// The day to offer as the day a commitment is kept from: the day this screen was handed.
    public private(set) var dayToKeepFrom: CalendarDate

    /// The commitment a stop has been asked for and not yet confirmed or cancelled.
    public private(set) var awaitingConfirmation: Commitment?

    /// Why a change was refused. `nil` from any of the four below means it was kept at the place
    /// before that call returned.
    public enum Refusal: Equatable, Sendable {
        /// A name that is empty or made only of blank space.
        case namesNothing
        /// A weekday set with no days in it — the one refusal the rule engine does not make.
        case dueOnNoDay
        /// The roster is already keeping this commitment.
        case alreadyKept
        /// The roster could not be written, or this screen is not keeping one.
        case notKept
    }

    /// Forms a commitment from `name`, the schedule `rhythm` names when kept from `keptFrom`, and
    /// `keptFrom`, and takes it on. Takes a commitment the roster has stopped up again.
    public func define(name: String, on rhythm: Rhythm, keptFrom: CalendarDate) -> Refusal?

    /// Puts `commitment` up for confirmation, replacing whatever was there. Does nothing when
    /// `kept` does not hold it.
    public func askToStopKeeping(_ commitment: Commitment)

    /// Leaves nothing awaiting confirmation and changes nothing else.
    public func cancelStopKeeping()

    /// Stops keeping whatever is awaiting confirmation, as of the day this screen holds. Answers
    /// `nil` and does nothing when nothing is awaiting confirmation.
    @discardableResult public func confirmStopKeeping() -> Refusal?

    /// Takes `commitment` up again, in the place it was taken on in. Answers `nil` and does
    /// nothing when `stopped` does not hold it.
    @discardableResult public func keepAgain(_ commitment: Commitment) -> Refusal?

    /// The app has been shown on `today`: the day this screen holds is replaced and the roster is
    /// read again.
    public func shown(asOf today: CalendarDate)
}

/// The four shapes a commitments screen offers, each carrying nothing the calendar does not
/// supply. Deliberately not a `Schedule`: an interval rhythm has no start date, because the day a
/// commitment is kept from is it.
public enum Rhythm: Hashable, Sendable {
    case weekdays(Set<Weekday>)
    case dayOfMonth(DayOfMonth)
    case everyNDays(DayInterval)
    case weeklyQuota(WeeklyQuota)
}
```

`DayScreen` gains one method and nothing else public:

```swift
extension DayScreen {
    /// The person has come back to this screen from somewhere else in the app: the roster is read
    /// again and the day view is formed again for the day being shown. Takes no today, moves no
    /// day, and does not read the record.
    public func returnedTo()
}
```

**`RosterState` is lifted out of `DayScreen` and becomes a top-level type**, in a new
`Sources/DayByDayKit/RosterState.swift`, with its three cases and their doc comments verbatim. Two
screens now answer about the same roster place in the same three ways, and `CommitmentsScreen`
declaring `public private(set) var rosterState: DayScreen.RosterState` would make the newer screen
name the older one for a type that is about neither. **This costs no edit anywhere**: every one of
the eleven references to it — nine in `DayScreenTests.swift`, two in `ContentView.swift` — reaches
it by leading-dot inference off `screen.rosterState`, never by writing `DayScreen.RosterState`,
checked by `grep` on 2026-09-04. `swift build` is what proves it; a compile error here is a rule-5
stop, not a rename to work around.

**`RecordState` is not lifted**, because only one screen has a record.

### The commitments screen opens its own store at the same place

**Chosen: `CommitmentsScreen` opens a `RosterStore` of its own at the roster place, and the two
screens share the *place* rather than the handle.** This is the first of the two things `grill.md`
§ *Left open* leaves here.

`CONTEXT.md` § *Store* already settles that this is legal — "two handles on one place are two views
of one file" — so the question is which is better, not which is possible. Three things decide it:

- **The seam is drivable on its own.** `CommitmentsScreen(asOf:keepingRosterAt:)` needs a date and
  a URL, exactly as `DayScreen` does. Sharing a handle would make every one of the forty
  `commitment` scenarios construct a `DayScreen` first, to get a store out of it, to test a screen
  that has nothing to do with a day — and would need `DayScreen` to expose its store publicly,
  which is a wider surface than the whole of this change.
- **A shared handle would not have removed the refresh anyway.** `DayScreen.dayView` is a formed
  value, not a window onto the roster; a change made through a shared store would still leave the
  day view saying what it said. The day screen needs a re-read either way, so the handle buys
  nothing and costs the coupling.
- **`RosterStore` is a class with a `roster` read once at `init`.** A second handle opened later is
  the *fresher* one. That is only safe because the two screens are never live at once in a way that
  writes — see the risk below, which is why the day screen re-opens rather than merely re-forming.

*Alternative — `CommitmentsScreen(sharing: RosterStore)`.* Fewer file opens, one in-memory roster,
and no possibility of two handles disagreeing. Rejected on the seam: the price is that
`CommitmentsScreen` cannot be constructed without a `DayScreen`, or `DayScreen.rosterStore` becomes
public, and neither is worth the two `open` calls it saves.

*Alternative — widen `DayScreen` to hold both screens' state.* One seam instead of two, which
`AGENTS.md` § *Vocabulary* prefers on its face. Rejected because the grill already drew the line in
the vocabulary: `CONTEXT.md` § *Commitments screen* says in as many words that it is "deliberately
not the **day screen**", and a `DayScreen` holding two lists, a form's default date and a
confirmation would be one type answering two unrelated questions. "An existing seam beats a new
one" is a rule about not multiplying entry points for one behaviour, not a rule against the second
screen in a product having a type.

### The store `DayScreen` holds is still not read

**A finding, not a decision, and it is the human's to settle at G4.** #103 deliberately left
`private var rosterStore: RosterStore?` on `DayScreen` — assigned in `init` and in `shown(asOf:)`,
read nowhere. It was raised as dead state at #103's G7 and kept on the reason recorded as a comment
on issue #104: *"this Story needs a live store to add and retire commitments through, and deleting
it now only to reopen the same file and restore it is the worse shape."*

**That premise does not hold under this design, and it could not hold under any design in which
the two screens do not share a handle.** The commitments screen opens its own store (§ *The
commitments screen opens its own store at the same place*), so nothing on the day screen reaches
that field. Nor could `returnedTo()` use it: the handle a day screen is holding read its roster at
its own `init`, so after the commitments screen has written, it is precisely the stale copy —
`returnedTo()` has to re-*open* the place, which replaces the field rather than reading it. Day one
writes through a local `store` inside `openRoster(at:takingOnIfEmpty:)` and never through the
field either.

**This change therefore leaves the field exactly as it is, still unread.** Deleting it is a change
to `src/` that no requirement in this delta asks for, on a line the owner looked at and chose to
keep; doing it quietly inside a Story would be overturning that decision without saying so. What is
owed instead is that they are told the reason has expired. Three ways out, none of them this
Story's to take unasked:

1. **Delete the field** — three lines and its doc comment, in a file § *The seam* already edits.
2. **Keep it** for a later Story that does share a handle, with the doc comment corrected so it no
   longer names #104 as the consumer that will read it.
3. **Share the handle after all**, which is the alternative § *The commitments screen opens its own
   store at the same place* rejects on the seam, and which would need `DayScreen` to expose its
   store publicly.

### Being returned to is not being shown

**Chosen: a new `DayScreen.returnedTo()`, a sibling of `shown(asOf:)` and not a reuse of it.** This
is the second thing `grill.md` § *Left open* leaves here.

`shown(asOf:)` does four things: it takes a new today, it moves the day being shown when the screen
was on today, it re-reads the record, and it re-reads the roster. Coming back from the commitments
screen wants exactly the last one. Reusing `shown(asOf:)` would therefore change two documented
lifetimes rather than none:

- **`CONTEXT.md` § *Shown*** defines being shown as "the moment the app comes in front of a
  person", and § *Day screen* fixes what a screen without its record says as lasting "only until
  the app is **shown** again, since being shown opens the store afresh". A walk to another screen
  and back is not the app coming in front of anyone, and a message that cleared itself on that walk
  would be ADR-1021's rule quietly rewritten by a navigation.
- **ADR-1026** makes a screen showing today follow onto the new day when the app is shown. Calling
  `shown(asOf:)` on the way back from another screen would need the shell to read the clock to get
  a today at a moment nothing needs one, and would move a person off the day they had navigated to
  if the clock had crossed midnight while they were on the other screen.

*Alternative — rename `shown(asOf:)` to something covering both.* Rejected: the two moments differ
in what they do, so one name would have to take a flag, and a flag is two methods with a worse
signature.

*Alternative — have the commitments screen call back into the day screen.* Rejected: it couples the
two screens in the direction the seam decision above just refused, and it puts the shell's
navigation knowledge inside the kit.

`returnedTo()` reuses `openRoster(at:takingOnIfEmpty:)` unchanged, so day one and an unreadable
roster behave on the way back exactly as they do at `init` and at `shown(asOf:)`. That is why the
delta's last day-screen scenario is worth its test even though it looks like a repeat of #103's:
it is the assertion that being returned to added no rule of its own.

### A commitments screen never writes day one

ADR-1027 puts day one at exactly one moment — the day screen reading a roster that holds nothing at
all — and this screen must not be a second such moment. The reason is not tidiness: the day screen
is the landing screen, so by the time anything can navigate to the commitments screen, day one has
already been taken on or has already failed. A commitments screen that also seeded would only ever
fire after a day-one *failure*, writing nine commitments a person did not ask for at the moment
they came to define their first one.

So `CommitmentsScreen` is handed no commitments at all, and a roster holding nothing lists nothing.
The delta pins that with an assertion that the place is still empty afterwards.

### The screen holds one day, handed in, and no clock

`CONTEXT.md` § *Today* says a today is "always handed in and never asked for", and its amendment
lets a **screen** keep one so that a person is not moved onto another day underneath them. A
commitments screen keeps one for a second reason as well: it is the day a stop is *kept until*
(settled answer 9), and it is the day the form offers as the day to keep from (settled answer 5).

It is handed one at `init` and again at `shown(asOf:)`, and nothing else moves it. `shown(asOf:)`
is on this screen for one concrete defect: a phone left on the commitments screen overnight would
otherwise stop a commitment as of yesterday, writing a kept-until day that is a day early and
making a tick made this morning invisible. Three lines close it, and they are the same three the
day screen already has.

**The form's default date is behind the seam, not in the shell.** `dayToKeepFrom` looks trivial —
it is the today — and it is here because ADR-1019's guard says the shell "may contain no line that
could be wrong in a way a test would catch". A `@State var keptFrom = today()` in `CommitmentsView`
is exactly such a line.

### The refusals a person can act on differently, and the words they are said in

`Refusal` has four cases and the delta requires three of the four pairs to be told apart. It
deliberately breaks the day screen's one-message pattern, and the reason is the reason that pattern
exists: ADR-1021 collapses a record's refusals because "a tick refused on a record that could be
read has no cause a person can act on differently". Here they can. A name that says nothing, a
rhythm due on no day and a commitment already kept are each fixed by changing the form; a roster
that could not be written is fixed by nothing the person can do at that moment.

**The distinction is behind the seam; the wording is the shell's.** That is not new — the three
cases of `RosterState` already map to three `Text(...)` literals in `ContentView.swift`, and
ADR-1022 fixes words inside `DayByDayKit` only for the day title, which is *nothing but* its words.
A `Refusal` case is a fact about what happened; the sentence a person reads is a drawing decision,
and putting it in the kit would make the kit own a string per case for no test's benefit.

**One case is deliberately silent.** Asking to stop, or to take up again, a commitment the relevant
list does not hold answers `nil` and does nothing — the same shape `DayScreen.tick` already has for
a row its day view does not hold. There is nothing for a person to act on, because there was
nothing there.

### A rhythm is a schedule with the start date taken out

`Rhythm` exists because settled answer 6 is a rule about *forming* a commitment, and a rule is
better as a type than as a paragraph nobody re-reads. `Schedule.everyNDays(DayInterval, from:
CalendarDate)` needs a date the calendar cannot supply; `Rhythm.everyNDays(DayInterval)` does not,
and the screen supplies the day the person said they keep the commitment from. There is then no
way to write the screen so that the two dates disagree.

The model goes on holding the two apart, and the seed `chore(app)` (#126) landed on `main` on
2026-09-04 is the proof it has to: "Nails" counts every 4 days from Sunday 6 September while being
kept from Friday 4 September, and "Contact Lenses" every 14 days from Saturday 5 September on the
same kept-from day. Nothing this screen makes can look like that, and nothing this change stops
`ContentView.swift` making it.

`Rhythm` is public because the shell builds one from what the person tapped. Its conversion —
`func schedule(keptFrom:) -> Schedule` — is internal: nothing outside the module has a reason to
turn a rhythm into a schedule, and keeping it internal means the only route from a rhythm to a
commitment is through the screen that refuses an empty weekday set.

`CONTEXT.md` gains **Rhythm** as a term. It is the person's word for a schedule — the Story's own
intent sentence uses it — and now it is also a type, so it needs one definition rather than two.

### The confirmation lives behind the seam

Settled answer 8 was decided against the grill's recommendation and is the owner's preference, so
it is a requirement: a stop asks first. `awaitingConfirmation` holds the commitment rather than a
`Bool`, so the shell can say *which* commitment is about to be stopped without keeping a second
copy of it, and asking about a second commitment replaces the first because two stops awaiting one
confirmation is a state nobody could draw.

A stop that is confirmed writes through `RosterStore.retire`, which keeps the change at the place
before it returns, so the two lists are formed again from `store.roster` afterwards and are never
ahead of the disk. Taking up again writes through `RosterStore.add` in exactly the same shape,
which is what makes "in the place it was taken on in" free rather than something this screen has to
arrange.

### Where the requirements live

`commitment`, for the screen; `day-screen`, for the one thing a day screen learns to do. The screen
is the roster's own management surface and `CONTEXT.md` § *Commitments screen* is already written
as a `commitment` term; a `commitments-screen` capability would put a roster's rules and the only
thing that exercises them in different files. `add-screen-date` (#92) and `add-roster-store` (#103)
both set the precedent that one change may claim two existing capabilities.

## Risks / Trade-offs

- **Two handles on one file, and a write through the stale one.** If both screens were live and
  both wrote, the second write would be formed from a roster read before the first, and it would
  silently undo it — `RosterStore.write` writes the whole document. This does not happen today
  because the two screens are never both writable at once: the day screen writes the roster only at
  day one, which is at `init` and at `shown(asOf:)`, and the commitments screen is the only writer
  while it is up. `returnedTo()` re-*opens* rather than re-forming for exactly this reason: the day
  screen's handle is dropped and replaced, so it cannot go on holding a roster older than the file.
  **The trigger to revisit is a third writer, or either screen writing while the other is live** —
  a widget, a background refresh, or a commitments screen kept alive behind the day screen.
- **The shell rides this branch, against ADR-1019.** Settled answer 12, decided against the grill's
  recommendation. The exception is bounded and the amendment says so: the wiring is navigation and
  drawing only, the guard that the shell may hold no line a test could catch is unchanged, and the
  return to the rule is the next shell change that is not the immediate consumer of a Story landing
  in the same PR. The cost is that the G4 digest signs a folder whose branch will also carry
  SwiftUI, which is exactly what ADR-1019 wanted to avoid; the benefit is that the owner can use
  the Story at G7 rather than after a second branch.
- **`DayScreen.rosterStore` stays dead.** The reason it was kept at #103's G7 was that #104 would
  read it, and #104 does not. § *The store `DayScreen` holds is still not read* sets out the three
  ways out; this delta takes none of them and the field is left byte-for-byte as it is.
- **Nothing automated proves the form draws.** `docs/open-questions.md` § *No UI smoke layer* is
  still open, and this Story roughly doubles the SwiftUI in the app — a second screen, a navigation
  and a form with four rhythm shapes. `tasks.md` § 5 closes it in the simulator by hand, which is
  the only tool this repo has, and § 5 also names the `docs/open-questions.md` entry this widens.
- **Forty-seven new tests in one Story.** That is the largest single delta this repo has written and
  it is the price of a screen with two lists, a form, four rhythms, four refusals and a
  confirmation. `tasks.md` § 2 is green on its own with no change to `DayScreen` at all, which is
  where to stop if the Story has to be split.
- **A weekday set with no days in it stays legal in the engine.** Anything that forms a commitment
  without going through this screen can still make one due on nothing, and one scenario in the
  delta exists to say so out loud. ADR-1028 records that as a deliberate asymmetry rather than a
  gap; closing it would be a delta on `openspec/specs/schedule/spec.md` that forbids a value
  `ScheduleTests` currently pins as legal.

## Migration Plan

None for data. `RosterDocument.currentVersion` stays 1, its shape is untouched, and nothing this
change writes is a form an older app could not read: every commitment this screen makes is an
ordinary `Commitment` on an ordinary `Schedule`. The record's file is not opened by anything here.

For the spec: the delta claims `commitment` and `day-screen`, both existing, so CI check 2 sees two
claimed capabilities and two touched spec files. `openspec/specs/record/spec.md` and
`openspec/specs/schedule/spec.md` must not appear in the archive diff at all.

## Open Questions

**None.** `grill.md` § *Left open* left two, both of them explicitly `spec-author`'s to settle
rather than the human's, and both are settled above with their alternatives written down:

- *Does the commitments screen share a `RosterStore` with the day screen or open its own?* — its
  own, at the same place. § *The commitments screen opens its own store at the same place*, which
  also names the two alternatives and why the seam decides it.
- *By what mechanism does the day screen re-read on being returned to?* — a new `returnedTo()`,
  a sibling of `shown(asOf:)` rather than a reuse or a rename of it. § *Being returned to is not
  being shown*, which names the two documented lifetimes a reuse would have changed.

Writing the delta on the grill's twelve answers turned up **no question that would change what this
Story does**, so there is no `## Questions for you` section and the Story is at G4 rather than at a
residual round. Five things that could have become questions were decided here instead, each
because it was a fact or a rule already in the repository rather than a preference the owner holds:

- *Does the commitments screen write day one when it finds an empty roster?* — no. ADR-1027 puts
  day one at one moment, and the day screen is the landing screen, so a second seeding could only
  ever fire after a day-one failure. § *A commitments screen never writes day one*.
- *Does the commitments screen keep a today, or take one per question?* — it keeps one, handed at
  `init` and again when the app is shown. `CONTEXT.md` § *Today*'s amendment already allows a
  screen to, and settled answers 5 and 9 both need one. § *The screen holds one day*.
- *Where do the refusal messages' words live?* — in the shell, as `RosterState`'s already do. The
  kit owns the distinction; ADR-1022 fixes words in the kit only for a thing that is nothing but
  its words. § *The refusals a person can act on differently*.
- *Is asking to stop a commitment the screen does not keep a refusal?* — no, it is silence, on the
  shape `DayScreen.tick` already uses for a row it does not hold.
- *Does a stopped commitment need a public read-back on `Roster`?* — no. `Roster.entries` is
  module-internal since #103, and `CommitmentsScreen` is in the module. Adding a public read-back
  would grow a surface nothing outside the kit has asked for and reopen a spec that has passed G4
  twice.
