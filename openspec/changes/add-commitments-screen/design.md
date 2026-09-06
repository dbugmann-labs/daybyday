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

**This folder has been reopened twice, and this document is its third version.** The Story passed
G4 on 2026-09-04, was implemented, and has been reviewed three times. The second pass raised eight
findings, of which three changed the requirements and are worked into the sections below: a public
widening of `CalendarDate` that shipped with nothing authorising it (§ *A calendar date gives back
its three numbers*), a form quietly rewriting and quietly swallowing numbers the kit refuses
(§ *A rhythm carries the number a person gave*), and, in `tasks.md`, a set of signed instructions
replaced by a report of why they could not be followed, two of whose stated reasons were untrue.
Every section below that was written before that pass and is still true is left exactly as it was,
so the second G4 is read as a diff against the first.

**The third pass raised one finding about the requirements, and it is the reason for this version:
how long a refusal is told was left to the shell.** `CommitmentsView.swift` held three `@State`
refusals with three unwritten lifetimes, two of which were already stale in ways nothing could
catch. § *How long a refusal is told is this capability's, and which change it was is part of it* is
the decision, two requirements in `specs/commitment/spec.md` are the rule, and the words a person
reads do not move. The owner settled two further things when they reopened the folder: `DayScreen`'s
unread roster store is deleted (§ *The store `DayScreen` holds is still not read*), and two
residuals the third pass turned up are recorded in `tasks.md` § 5.6 rather than fixed here. As
before, every section still true is left exactly as it was, so the third G4 is read as a diff
against the second.

Everything measured below was measured on this machine on 2026-09-04, from `566297e`, the `main`
this branch is rebased onto: Apple Swift
6.3.3, `cd src/DayByDayKit && swift test` reporting **300 tests passing**, `openspec` 1.10.0, Node
v24.19.0. Re-measured on 2026-09-06 on the branch as the second review pass left it, `swift test`
reports **348**; the nine scenarios the second version added take it to **357**, and the thirteen
this version adds take it to **370**.

## Goals / Non-Goals

**Goals**

- One screen a person manages a roster from: what they keep, what they have stopped, a form that
  defines a new commitment, a way to stop keeping one and a way to take a stopped one up again.
- All four rhythms creatable, thinly. `CONTEXT.md` § *Five percent of seven things*.
- A commitment defined on one screen visible on the other without the app being backgrounded.
- Every refusal a person can act on differently told apart from the others, and every refusal that
  leaves them the same single action told alike.
- **How long a refusal is told decided here, not by whatever draws the screen.** The distinction and
  the lifetime are this capability's; the words stay the shell's.

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

**Three seams, and only one of them is new — `CommitmentsScreen`, exported from `DayByDayKit`
beside `DayScreen`.** The second is the existing `DayScreen`, which gains one method. The third is
`CalendarDate`, which gains no method at all: it is the seam every `schedule` scenario in this repo
already attaches at, and the four scenarios this change adds to that capability attach there too,
alongside the nineteen `ScheduleTests.swift` already carries. The fifty-eight `commitment` scenarios
attach at the first and the eleven `day-screen` scenarios at the second — of which four are
restated verbatim under MODIFIED and already have their tests, so sixty-nine tests are written.
**No fourth seam appears, and the third was already there**: "an existing seam beats a new one" is
satisfied by putting the read-back on the type the capability is about rather than by threading a
component accessor through `DayScreen` or `CommitmentsScreen`.

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

    /// The change asked for last that was refused, and why — at most one at a time, `nil` when the
    /// last change asked for was kept and when none has been asked for. Cleared by `shown(asOf:)`.
    public private(set) var refusedChange: RefusedChange?

    /// A change a commitments screen was asked for and refused: which one, and why. The commitment
    /// is carried on the two changes that are asked about a commitment already on a list, so that
    /// a person is told beside the row they tapped rather than in one place for all three.
    public enum RefusedChange: Equatable, Sendable {
        case defining(Refusal)
        case stopping(Commitment, Refusal)
        case keepingAgain(Commitment, Refusal)

        /// Why it was refused, whichever change it was.
        public var refusal: Refusal { … }
    }

    /// Why a change was refused. `nil` from any of the four below means it was kept at the place
    /// before that call returned.
    public enum Refusal: Equatable, Sendable {
        /// A name that is empty or made only of blank space.
        case namesNothing
        /// A weekday set with no days in it — the one refusal the rule engine does not make.
        case dueOnNoDay
        /// A day of the month, an interval or a weekly quota outside what that rhythm allows.
        /// One case for all three: the person changes the number in the field they are on.
        case rhythmOutOfRange
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
/// commitment is kept from is it. The three numeric shapes carry the number a person gave, not a
/// value already judged — a rhythm is what was said, and `CommitmentsScreen.define` is the one
/// place that judges it.
public enum Rhythm: Hashable, Sendable {
    case weekdays(Set<Weekday>)
    case dayOfMonth(Int)
    case everyNDays(Int)
    case weeklyQuota(Int)
}
```

And `CalendarDate` gives its three numbers back. It is the same declaration, with `let` made
`public let` and nothing else touched:

```swift
public struct CalendarDate: Hashable, Sendable {
    /// The three components a validating initializer already checked. Public so that the edge —
    /// where an instant becomes a calendar date and back, per ADR-1004 — can rebuild a `Date` in
    /// whatever calendar it is asking on, the reverse of `ContentView.today()`'s own conversion.
    /// Read-only: the only way to change one is to form a new `CalendarDate`.
    public let year: Int
    public let month: Int
    public let day: Int
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

**The first two versions of this document therefore left the field exactly as it was, still unread**,
and put the three ways out to the human rather than taking one:

1. **Delete the field** — its declaration, its doc comment and the three assignments, in a file
   § *The seam* already edits.
2. **Keep it** for a later Story that does share a handle, with the doc comment corrected so it no
   longer names #104 as the consumer that will read it.
3. **Share the handle after all**, which is the alternative § *The commitments screen opens its own
   store at the same place* rejects on the seam, and which would need `DayScreen` to expose its
   store publicly.

**Decided 2026-09-06, by the owner, when this folder was reopened for its third G4: take the first
way out and delete the field.** The reason #103's G7 kept it was that this Story would read it, and
this design disproves that rather than merely failing to use it — sharing the handle is the thing
§ *The commitments screen opens its own store at the same place* rules out, so no design that keeps
the two screens apart can reach the field. Way 2 keeps a field alive on a promise no longer made by
anything, and way 3 reopens a seam decision on the strength of a line nothing reads. `tasks.md`
§ 5.7 is the box; it is `private`, assigned at three sites — `DayScreen.swift:30` declares it, and
`:73`, `:258` and `:272` assign it — and read at none, so the deletion changes no behaviour, needs no
requirement and moves no test. Those three assignments are also the only readers of
`openRoster(at:takingOnIfEmpty:)`'s `store` member, so the deletion leaves that member read by
nothing and the tuple narrows to `(state:, roster:)` in the same commit — the handle day one is
written through is a local inside that function and is unaffected. Any test that moves is a rule-5
stop, not a licence to change one.

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

`Refusal` has five cases and the delta requires each of the five to be told apart from the others.
It deliberately breaks the day screen's one-message pattern, and the reason is the reason that
pattern exists: ADR-1021 collapses a record's refusals because "a tick refused on a record that
could be read has no cause a person can act on differently". Here they can. A name that says
nothing, a rhythm due on no day, a rhythm number the calendar will not take and a commitment
already kept are each fixed by a different change to the form; a roster that could not be written
is fixed by nothing the person can do at that moment.

The same rule is what keeps `rhythmOutOfRange` a single case rather than three. Five cases is the
number of *different things to do*, not the number of ways a call can fail.

**The distinction is behind the seam; the wording is the shell's.** That is not new — the three
cases of `RosterState` already map to three `Text(...)` literals in `ContentView.swift`, and
ADR-1022 fixes words inside `DayByDayKit` only for the day title, which is *nothing but* its words.
A `Refusal` case is a fact about what happened; the sentence a person reads is a drawing decision,
and putting it in the kit would make the kit own a string per case for no test's benefit.

**One case is deliberately silent.** Asking to stop, or to take up again, a commitment the relevant
list does not hold answers `nil` and does nothing — the same shape `DayScreen.tick` already has for
a row its day view does not hold. There is nothing for a person to act on, because there was
nothing there.

### How long a refusal is told is this capability's, and which change it was is part of it

**Chosen: `CommitmentsScreen` holds one `refusedChange: RefusedChange?` — which of the three changes
was asked for last, the commitment it was asked about where there is one, and why it was refused —
and the shell holds no refusal state at all.** This is the third review pass's finding and it
reverses the shape the first two versions of this document left implicit: `define`,
`confirmStopKeeping` and `keepAgain` each answered a `Refusal?` and then forgot it, so
`CommitmentsView.swift` carried three `@State` refusals and three lifetimes, none of them written
down anywhere.

**The words are untouched and stay the shell's.** Task 4.1's `refusalText(_:)` keeps its five
sentences and ADR-1022 is unamended: what moves here is the *lifetime*, not the vocabulary. The kit
gains no string.

**There is no live defect on this branch, and the reason is a view-lifetime detail rather than a
rule.** `CommitmentsView` is reached through `navigationDestination(isPresented:)`, so SwiftUI
destroys it on pop and the `@State` resets. Present the same screen as a sheet, a tab or a detail
column later and every one of those three lifetimes changes silently with no test failing —
`docs/open-questions.md` § *No UI smoke layer* is exactly the layer that would not catch it. Two
things already inside this Story say that is the wrong place for it: `awaitingConfirmation` is a
transient screen fact of precisely this kind and is held at the seam *with* a requirement, and
`tasks.md` § 4's own guard says a line in `src/DayByDay` that decides something is a requirement
this delta is missing.

**Two lifetimes were already wrong rather than merely unwritten.** Held in three independent slots,
a refused stop went on being drawn under `Section("Kept")` after a later take-up-again succeeded —
two messages about two different moments, one of them contradicted. And a `rhythmOutOfRange`
message stayed under the Add button after the person switched the rhythm picker to a shape that
cannot produce it. The first is closed here by the at-most-one rule; the second is not, and § *Risks
/ Trade-offs* records why and what closing it would cost.

**Two conditions end the telling, and they are the at-most-one rule read twice.** The screen holds
the outcome of the last change asked of it, so a change that is asked for and *kept* leaves nothing
held, and a change that is asked for and refused replaces what was there. Being shown again ends it
too, because being shown re-reads the place and forms both lists afresh — the same sentence this
delta already writes for the roster state and for the day the screen offers. Nothing else ends it,
and in particular no clock does.

**Why `RefusedChange` carries the change and not just the `Refusal`.** A bare `Refusal?` was the
first shape considered and it does not survive the second review pass's finding 6, which moved each
message beside the control that produced it: a `.notKept` can come from any of the three calls, so
the case alone cannot place the message. The shell would then either draw all five sentences in one
place — and "Give it a name." belongs beside the name field, which on a phone is below two lists
that may both be nine rows long and off-screen when Add is tapped — or remember which call it last
made, which is the lifetime coming straight back into the shell under another name. Carrying which
change is one public enum and it is the same choice `add-refused-tick-notice` (#100) makes on the
day screen, where `refusedChangeRow` holds *which row* for the same reason.

**Why no fourth condition for the form changing.** Ending a defining refusal when the person edits
the name, the rhythm or the date would close the second stale case above, and it needs the kit to be
told the form changed — a public method the shell must call from an `.onChange` on each of six
`@State` values. A forgotten one is silent staleness that no test at any seam can reach, which is
the defect this section exists to remove rather than a fix for it. The cheaper honest answer is that
the message is about the change you asked for last and stands until you ask for another, and the
next Add replaces it with the right answer.

**Why no ADR.** `add-refused-tick-notice` (#100) states the same rule for the day screen and is an
open draft that has not merged; writing the pattern down as a decision record while one of its two
instances is unlanded would fix a shape that has been through review once. The two deltas agree
today — one refusal at a time, the last change asked for, ended by the app being shown and by a
change that lands — and whichever merges second should be read against the first. If they diverge,
that divergence is the ADR, and it belongs to whichever Story causes it.

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
`func schedule(keptFrom:) -> Schedule?` — is internal: nothing outside the module has a reason to
turn a rhythm into a schedule, and keeping it internal means the only route from a rhythm to a
commitment is through the screen that refuses an empty weekday set. It is failable for the reason
the next section gives.

`CONTEXT.md` gains **Rhythm** as a term. It is the person's word for a schedule — the Story's own
intent sentence uses it — and now it is also a type, so it needs one definition rather than two.

### A rhythm carries the number a person gave

**Chosen: `Rhythm`'s three numeric cases carry an `Int`, `Rhythm.schedule(keptFrom:)` is failable,
and `CommitmentsScreen.Refusal` gains `rhythmOutOfRange`.** This is the second review pass's
finding 7 and it reverses a decision the first version of this document made without arguing it:
that `Rhythm` should carry `DayOfMonth`, `DayInterval` and `WeeklyQuota` because "a rule is better
as a type than as a paragraph nobody re-reads".

That reasoning is right about the *start date* — which is the rule `Rhythm` exists for, and which
is untouched here — and wrong about the three numbers. Carrying already-valid values makes
`define(name:on:keptFrom:)` unable to be handed a number the calendar refuses, which sounds like a
guarantee and is in fact a hole: the number a person typed still has to become a `DayInterval`
somewhere, and the only place left is the shell. `tasks.md` § 4 forbids the shell to decide
anything and says in as many words that a shell that appears to need a refusal "is a requirement
this delta is missing and a rule-5 stop". It needed one, twice over, and neither stop was taken:

- `CommitmentsView.swift`'s day-count field bound itself through `max(1, $0)`, so a person typing
  `0` had it rewritten to `1` with nothing said. That is the shell choosing a value.
- `define()` guarded each of the three constructions with `else { return }`, so a number that got
  past the widget made the Add button do nothing and leave whatever message was already on screen.
  That is the shell choosing a refusal, and choosing silence for it.

ADR-1028 wrote the rule this breaks, in the course of arguing for the empty weekday set: every
refusal that is made by the value itself — "a day of the month outside 1–31, an interval below one,
a quota outside 1–7" is its own list — is one where "every screen simply reports what the value
said". So the fix is not a new principle. It is the existing one, carried out: put the number in
front of the screen, let the value refuse it, and report that. The `schedule` capability is
untouched; `DayOfMonth`, `DayInterval` and `WeeklyQuota` go on being the things that refuse.

**One `Refusal` case for all three**, which is ADR-1021's rule applied where it does hold. The
person's action is identical in the three cases — put a different number in the field they are
looking at — and the form already knows which field that is, so the wording is as specific as it
needs to be without the kit carrying three cases nothing distinguishes.

*Alternative — keep `Rhythm` validated and give the shell a message to show.* Rejected: the shell
would still be the thing that decided a number was bad, and no test at any seam could reach that
decision. The reviewer would be judging a `guard` in SwiftUI, which is the situation ADR-1019
exists to prevent.

*Alternative — bound every widget so a refused number cannot be produced.* This is what the two
`Stepper`s already do, and it is why they are kept (see the trade-off below). It cannot be the
whole answer, because the interval field is the one shape with no upper bound the kit will name:
`Stepper(value:in:)` needs a `ClosedRange`, so bounding it means the shell inventing a ceiling the
`schedule` capability has never stated, and a free-form number field is the right widget for
"every 14 days" anyway.

*Alternative — make `Rhythm` failable to construct, `Rhythm.everyNDays(days:) -> Rhythm?`.*
Rejected for the same reason as the first: `nil` arrives in the shell and the shell decides what to
do with it.

### A calendar date gives back its three numbers

**Chosen: `CalendarDate.year`, `.month` and `.day` are public, and one requirement in the
`schedule` capability says so.** This is the second review pass's finding 1. The widening itself is
not new — it shipped in this Story's implementation, in `4e92da5`, fixing a real defect where a
commitments screen left open overnight went on offering yesterday as the day to keep from — but it
shipped against a change folder saying three times over that `schedule` was untouched. The owner's
decision is to keep the code and authorise it, because the members have been recorded as owed since
`add-day-navigation` (#72) and this is the Story that finally needed them.

**It belongs to `schedule`, not to `commitment`.** `CalendarDate` is specified there — *A calendar
date names a day that exists* and *A calendar date lies within the years the system supports* are
both `schedule` requirements — and a rule about what a calendar date gives back sits beside the
rules about which ones exist. Putting it in `commitment` would make a screen's capability own a
sentence about a calendar value, which is the same mistake `grill.md`'s answer 1 refused when it
kept "saying a rhythm in words" out of this Feature.

**It is a read-back and it is bounded.** The requirement gives back the three numbers of a
`CalendarDate` and nothing else: no ordering (`Comparable` is still owed), no `Date`, and no
widening of `DayOfMonth`, `DayInterval`, `WeeklyQuota`, `History` or `Tick`, each of which stays
exactly as unreadable as it was. The requirement's own prose says so, so the next reader of the
archived spec cannot take it as a precedent for the other five.

**The three stay `let`.** A settable component would let a valid date be walked, one assignment at
a time, through a combination that names no day — 31 January with its month set to February — and
the two requirements above would then govern only how a date is first made. This is the one part of
the read-back that is a rule rather than an access level, which is why it is in the requirement's
prose and not only in a doc comment.

*Alternative — leave the components internal and hand the shell a `Date`.* That is a `Foundation`
type crossing the seam in the direction ADR-1004 spent a whole decision keeping it out of, and it
would need the kit to choose a calendar and a time zone for a conversion whose whole point is that
the edge chooses them.

*Alternative — revert the widening and let `CommitmentsView` read its own clock.* This is what the
code did before `4e92da5`, and it is the defect: two clock reads, a screen offering a day nobody
handed it, and `dayToKeepFrom` — a value this document put behind the seam precisely so that a test
could catch it being wrong — unreachable by the thing that draws it.

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

`commitment`, for the screen; `day-screen`, for the one thing a day screen learns to do;
`schedule`, for the one thing a calendar date learns to say. The screen
is the roster's own management surface and `CONTEXT.md` § *Commitments screen* is already written
as a `commitment` term; a `commitments-screen` capability would put a roster's rules and the only
thing that exercises them in different files. `add-screen-date` (#92) and `add-roster-store` (#103)
both set the precedent that one change may claim two existing capabilities, and three is that same
precedent rather than a new one: a change claims the capabilities its requirements belong to, and
the count is a consequence rather than a budget. The `schedule` claim is one requirement wide, and
the second review pass is what added it — had it been seen at the first G4 it would have been in
the folder then, which is why the folder is being signed a second time rather than the code
reverted.

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
- **`DayScreen.rosterStore` is deleted, and #103's G7 decision is overturned in the open.** The
  reason it was kept was that #104 would read it, and #104 does not. § *The store `DayScreen` holds
  is still not read* records the owner's decision at this Story's third G4 and `tasks.md` § 5.7 is
  the box. The risk is the one #103's G7 named: a later Story that does want a live roster handle on
  the day screen re-adds it. That is cheap — three lines in a file that will be open anyway — and
  cheaper than a field kept alive on a promise nothing makes.
- **A defining refusal outlives an edit to the form.** The screen holds the outcome of the last
  change asked of it, and editing the name, the rhythm or the date is not a change asked for, so
  "That number isn't one this rhythm accepts." stays under the Add button after the person switches
  the rhythm picker to a shape that cannot produce it, until the next Add or until the app is shown.
  § *How long a refusal is told is this capability's* records why the fix — a public method the
  shell calls from an `.onChange` on each of six `@State` values — costs more than it buys: a
  forgotten `.onChange` is silent staleness no test at any seam can reach, which is the same defect
  in a new place. **The trigger to revisit is a second refusal that is about the form's contents
  rather than about the roster place**, or a form long enough that a person cannot see the message
  and the field they changed at once.
- **Nothing automated proves the form draws.** `docs/open-questions.md` § *No UI smoke layer* is
  still open, and this Story roughly doubles the SwiftUI in the app — a second screen, a navigation
  and a form with four rhythm shapes. `tasks.md` § 5 closes it in the simulator by hand, which is
  the only tool this repo has, and § 5 also names the `docs/open-questions.md` entry this widens.
- **Fifty-six new tests in one Story.** That is the largest single delta this repo has written and
  it is the price of a screen with two lists, a form, four rhythms, five refusals and a
  confirmation. `tasks.md` § 2 is green on its own with no change to `DayScreen` at all, which is
  where to stop if the Story has to be split.
- **The two `Stepper`s still name a range the `schedule` capability owns.** `CommitmentsView`
  bounds the day-of-month stepper to `1...31` and the quota stepper to `1...7`, which are the
  kit's numbers written a second time in a file that may not decide anything. They are kept, and
  the reason they are not a decision is that nothing they can produce is refused and nothing they
  refuse to produce would have been accepted: they are drawing the range, not judging it. What the
  rhythm-number refusal changes is the failure mode if that ever stops being true — a stepper whose
  ceiling drifted *above* the kit's now produces a refusal a person can read, where before it
  produced silence. A stepper whose ceiling drifted *below* the kit's would still quietly withhold
  a legal number, and that residual is real. Closing it means the kit publishing each range, which
  is a further face of `docs/open-questions.md` § *Known gaps*'s read-back entry and is not
  authorised here.
- **`CalendarDate`'s components are public for ever.** A public `let` on a public struct in a
  library this repo consumes from one app is cheap to widen and awkward to narrow; narrowing it
  again would break `CommitmentsView`'s date picker and any later screen that renders a date, which
  is most of them. The bound is the requirement's own prose — three numbers, no ordering, no other
  type — and the trigger to revisit is a Story that wants `Comparable` or another payload, which
  should argue for it on its own rather than reading this one as a precedent.
- **A weekday set with no days in it stays legal in the engine.** Anything that forms a commitment
  without going through this screen can still make one due on nothing, and one scenario in the
  delta exists to say so out loud. ADR-1028 records that as a deliberate asymmetry rather than a
  gap; closing it would be a delta on `openspec/specs/schedule/spec.md` that forbids a value
  `ScheduleTests` currently pins as legal.

## Migration Plan

None for data. `RosterDocument.currentVersion` stays 1, its shape is untouched, and nothing this
change writes is a form an older app could not read: every commitment this screen makes is an
ordinary `Commitment` on an ordinary `Schedule`. The record's file is not opened by anything here.

For the spec: the delta claims `commitment`, `day-screen` and `schedule`, all three existing, so CI
check 2 sees three claimed capabilities and three touched spec files. `openspec/specs/record/spec.md`
must not appear in the archive diff at all. `openspec/specs/schedule/spec.md` must appear, and must
gain exactly one requirement and change nothing else — every rule already in that file, in
particular the one making `Schedule.weekdays([])` legal, must read afterwards character for
character as it reads now.

## Open Questions

**None.** `grill.md` § *Left open* left two, both of them explicitly `spec-author`'s to settle
rather than the human's, and both are settled above with their alternatives written down:

- *Does the commitments screen share a `RosterStore` with the day screen or open its own?* — its
  own, at the same place. § *The commitments screen opens its own store at the same place*, which
  also names the two alternatives and why the seam decides it.
- *By what mechanism does the day screen re-read on being returned to?* — a new `returnedTo()`,
  a sibling of `shown(asOf:)` rather than a reuse or a rename of it. § *Being returned to is not
  being shown*, which names the two documented lifetimes a reuse would have changed.

**The second review pass added two more, and both were settled by the owner before this version was
written**, so they are recorded here as answered rather than asked. Neither is a `## Questions for
you` entry, because a question whose answer is already given is a decision:

- *`CalendarDate`'s components shipped public with nothing authorising it — keep the widening or
  revert it?* — keep it, and authorise it with a `schedule` delta. The owner's reason is that
  `docs/open-questions.md` has named those three members as owed since #72 and this is the Story
  that finally needed them. § *A calendar date gives back its three numbers*.
- *Does `CommitmentsScreen.Refusal` owe a case for a rhythm number the kit refuses?* — yes. This
  was the reviewer's finding 7, left explicitly to be judged rather than assumed, and the judgment
  is that `tasks.md` § 4's own guard fires: two lines in `CommitmentsView.swift` decide, one a
  value and one a refusal. § *A rhythm carries the number a person gave*.

**The third review pass added two more, and both were settled by the owner before this version was
written.** Same shape as the two above: recorded as answered, not asked.

- *How long is a refusal told, and who decides it?* — this capability, not the shell. The three
  `@State` refusals in `CommitmentsView.swift` are replaced by one `refusedChange` at the seam, with
  two requirements saying what is held and for how long. The words stay the shell's.
  § *How long a refusal is told is this capability's, and which change it was is part of it*.
- *What becomes of `DayScreen`'s unread roster store?* — it is deleted. The reason #103's G7 kept it
  was disproved by this design rather than merely unused by it. § *The store `DayScreen` holds is
  still not read*, and `tasks.md` § 5.7.

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
