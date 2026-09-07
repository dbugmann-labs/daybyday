## Context

See `proposal.md` § *Why*. What matters here is what already exists and what this change is
therefore not allowed to invent.

`record` is finished for numbers. `Number.init?(_:for:on:)` refuses a value the commitment will not
take, `History.number(for:on:)` reads one back, `History.removeNumber(for:on:)` takes one back and
`RecordStore` persists all of it at form 3. This change adds no requirement there and calls no
private thing: everything below drives that surface from `day-screen`, which sits in the same
module.

`day-screen` already has the two shapes this change extends. `DayView.Row.tick(asOf:)` is a row
offering a change, asked as of a day, refusing for a day that has not arrived.
`DayScreen.refusedChangeRow` is what a person is told when a change is refused. Both were signed
recently and deliberately — `add-tick-from-row` (#71) and `add-refused-tick-notice` (#100) — and
this change reverses exactly one sentence out of the second one.

**One measured fact shapes the whole of reading a typed number.** `Decimal(string:)` is a *prefix*
parser, not a validator. Measured on this machine on 2026-09-07, Apple Swift 6.3.3
(swiftlang-6.3.3.1.3), target `arm64-apple-macosx26.0`:

```
Decimal(string: "70.5")   -> 70.5      Decimal(string: "1.2.3") -> 1.2
Decimal(string: "70,5")   -> 70        Decimal(string: "12abc") -> 12
Decimal(string: ".")      -> 0         Decimal(string: "1e3")   -> 1000
Decimal(string: " ")      -> 0         Decimal(string: "1,234.5") -> 1
Decimal(string: "")       -> nil       Decimal(string: "٧٠")    -> nil
Decimal(string: "0000070.50") -> 70.5  Decimal(string: "-12.75") -> -12.75
```

Five of those are catastrophic for this change if the parse is left to Foundation. `"."` and `" "`
becoming **0** would record a weight of zero on a day someone fat-fingered the keypad; `"1.2.3"`
becoming 1.2 and `"12abc"` becoming 12 would record a number nobody typed; and `"70,5"` becoming
**70** rather than 70.5 is precisely the German-phone bug the grill's answer 11 exists to prevent —
a silent half-kilo, not a refusal anyone would notice. So the shape of what was committed is
checked first, in full, and `Decimal(string:)` is called only on text already proved to be digits,
at most one separator and an optional leading minus. `Decimal(string:locale:)` **does** read
`"70,5"` as 70.5 given `de_DE`, and is not used: reading a locale is what ADR-1004 keeps out of
this package, and accepting both separators unconditionally is both simpler and right on a phone
whose keyboard language and region disagree.

**A second measurement, taken at G7 because the first set was incomplete, is why a length bound
exists at all.** Past a point `Decimal(string:)` does not mis-read, it *fails*; just short of that
point it rounds without saying so. Same machine, same day:

```
Decimal(string: 200 x "1")              -> nil        more digits than the type holds
Decimal(string: "0." + 128 x "0" + "1") -> nil        below 10^-128, which is the type's floor
Decimal(string: 39 x "9")               -> 999...990  38 digits kept, the 39th dropped, silently
Decimal(string: 38 x "9")               -> 999...999  exact, and exact through the store
```

**A third measurement, taken at the third G7 pass, is why the length bound is the only bound.** The
second set proved the type has a ceiling and a floor; it did not say where, and a sentence written
in this design as though it had was wrong by thirty-eight powers of ten. Where they actually are,
measured 2026-09-07 on the toolchain named above:

```
Decimal(string: "1"     + 165 x "0")    -> exact      and "3" + 165 zeros is exact too
Decimal(string: "4"     + 165 x "0")    -> nil        as is "1" + 166 zeros
Decimal(string: 38 x "9" + 127 x "0")   -> exact      the same 38 digits x 10^128 are nil
Decimal(string: "0." + 127 x "0" + "1") -> exact      and one place further down is nil
```

That is the type's own line and it is not one bound but two together: a mantissa below 2^128 and a
power of ten from −128 to 127. The largest number it holds is a shade over 3.4 x 10^165, the
smallest step it holds is 10^-128, and **neither is a bound on the significant digits** — `1`
followed by 165 zeros is one significant digit at a magnitude 10^38 past where a design sentence
here had claimed the type gives up.

**And the one property the reading actually needs, measured rather than reasoned:** at **at most
thirty-eight significant digits, `Decimal(string:)` never rounds — it is exact or it is `nil`.**
150,000 random values of 1 to 38 significant digits at powers of ten from −200 to 260: 89,492 read
back digit for digit, 60,508 returned `nil`, **none** came back a different number. Above 38 digits
it does round, silently, which is the row above. So one bound of this system's own — the digits —
and one question asked of the type, is the whole of it. `tasks.md` § 13.4 re-runs the boundary cases
before the code moves; a measurement two review passes have now corrected is not something to take
on this document's word.

Every one of those is reachable from the shell — `ContentView.swift` binds an unbounded `TextField`,
so a paste is enough — and every one is digits and nothing else, so a shape check on characters
alone passes them. The `nil`s answer a parse this design had claimed could not fail; the rounding
keeps a number nobody typed, which the delta's own "no digit added and none dropped" forbids. One
rule answers all of them, and it is § *A number this system cannot keep exactly is not a number
here* below.

## Goals / Non-Goals

**Goals**

- One way for a row to say what its commitment's kind takes, that #140 and #141 can follow.
- The number reachable for the prefill and unreachable for drawing, by shape rather than by rule.
- A notice that can carry a cause without becoming a place to put every cause.

**Non-Goals**

- Any change to `record`. If something below wants one, it is a mistake in this design.
- The mood slider (B-034) and the last-weight prefill (B-032). Both stay wants.
- Fixing B-035, the tap a future row does not answer. This change repeats it deliberately so that
  one fix later covers both kinds of row.
- A UI test of any kind. `docs/open-questions.md` § *No UI smoke layer* still holds, and § 8 of
  `tasks.md` is a person looking at a phone.

## Decisions

### The seam

**Widened, not new.** Two existing types gain members and no third type is introduced at the
boundary. Every scenario in this delta is driven through `DayView` or `DayScreen`, and no test
spawns a process or captures a stream.

```swift
extension DayView {
    /// What a number commitment's row offers in a tick's place.
    public struct NumberEntry: Hashable, Sendable {
        /// The number the day already holds, or `nil` where it holds none.
        public let number: Decimal?
        /// The range the commitment declares, said for an empty field — "40–150" — or `nil`
        /// where it declares none.
        public let hint: String?
        /// The same range said as the cause a number outside it is refused for — "Must be
        /// between 40 and 150" — or `nil` where the commitment declares none. Internal: the
        /// shell reads a cause off the notice, never off an entry.
        let refusalCause: String?
    }

    public struct Row: Hashable, Sendable {
        // commitment, date, isKept as today, plus:
        let number: Decimal?

        /// The number entry this row offers, or `nil` when its commitment's kind is not a number
        /// or the row's date is later than `today`.
        public func numberEntry(asOf today: CalendarDate) -> NumberEntry?

        /// The number record this row makes of `decimal` — this row's commitment, on this row's
        /// date — or `nil` when the row offers no number entry as of `today`, or its commitment
        /// refuses the value.
        public func number(_ decimal: Decimal, asOf today: CalendarDate) -> Number?

        /// The record a number for this row is kept under: this row's commitment on this row's
        /// date. Internal, and the only thing a take-back needs.
        var recordedDay: RecordedDay
    }
}

@MainActor @Observable public final class DayScreen {
    /// What a person is told on a row, and nothing else: which row, and the cause where there is
    /// one a person can act on.
    public struct Notice: Hashable, Sendable {
        public let row: DayView.Row
        public let cause: String?
    }
    public private(set) var notice: Notice?

    /// Enters what `text` holds on `row`, or takes that day's number back where it holds nothing.
    public func enter(_ text: String, on row: DayView.Row) throws
}

// In DayScreen.swift, private to this capability: `record` spells a take-back with a commitment
// and a date, and a day screen holds neither.
private extension RecordStore {
    func removeNumber(on day: RecordedDay) throws
}
```

`numberEntry(asOf:)` sits exactly where `tick(asOf:)` sits, takes the same argument for the same
reason, and refuses for a day that has not arrived on the same line of reasoning. `enter(_:on:)`
sits exactly where `tick(_:)` sits and guards the same three conditions in the same order.

**The row makes the record, and this is the third G7 pass's finding 1.** The delta says the screen
"MUST NOT form a number of its own" and "MUST NOT reach past a row to the commitment underneath it",
which is the invariant `tick(_:)` honours structurally — it says `row.tick(asOf: today)`, the row
makes the `Tick` because the row *is* the commitment and the date, and the screen never names a
commitment at all. The first draft of this section named `numberEntry(asOf:)` and `enter(_:on:)` and
said nothing about which side makes the `Number`, so the code made it screen-side and reached
through the row three times to do it. Nothing in the delta moves; the seam gains what it was short
of, and each of the three reaches ends somewhere:

- **`Row.number(_:asOf:)`** makes the record, refusing on the two conditions `numberEntry(asOf:)`
  already refuses on plus the one `Number.init?` refuses on. It is `tick(asOf:)` with a value.
- **`NumberEntry.refusalCause`** is the range said as a sentence, formed in `numberEntry(asOf:)`
  beside `hint` off the one `case .number(let range)` binding there. `DayScreen.rangeRefusalCause`
  goes: it was a second place wording a bound, reading `commitment.kind` to do it, and two places
  wording one bound have to be kept agreeing by hand. Internal rather than public because nothing
  outside the module has a use for it and the shell already reads its sentence off `notice.cause`.
- **`RecordStore.removeNumber(on:)`** is where the row-made record is unpacked into the two
  arguments `record` spells its take-back with, and it is the only place that happens. `enter` reads
  `try recordStore.removeNumber(on: row.recordedDay)` and names no commitment.

`RecordedDay` is `record`'s own internal value for "a commitment on a day" — the key its history and
its store already hold numbers under — so a row naming one invents nothing.

**Rejected: an overload on `RecordStore` taking a row-made record, in `record`'s own file.** It
reads better at the call site and it is this capability's convenience sitting in another
capability's source, against this design's own non-goal. A private extension in `DayScreen.swift`
buys the same call site and changes nothing `record` owns.
**Rejected: leaving the take-back reaching for `row.commitment` because it decides nothing.** It is
true that unpacking a pair is not a decision, and it is exactly the reasoning that would have
excused the other two reaches; the requirement is worded about the reach and not about the
decision, and #140 and #141 will copy whatever this leaves behind.

### The notice carries a cause, so it stops being a bare row

`add-refused-tick-notice`'s own `design.md` chose `refusedChangeRow: DayView.Row?` and said why in
terms that rule out the cheap fix here: "One optional, and **nothing else**. No `RefusalReason`, no
message string, no count, no `Bool` alongside it." Adding `refusedChangeCause: String?` beside it
would be that rejected shape exactly, and it makes a state representable that must not exist — a
cause with no row. So the property becomes one value:

```swift
public private(set) var notice: Notice?          // was: refusedChangeRow: DayView.Row?
```

**Named `notice` because that is this screen's word.** `CONTEXT.md` § *Refused change* is explicit
that the two screens have two words for the neighbouring thing — "a refused change" is the
commitments screen's and "a notice" is the day screen's, "two words for two things, not one thing
twice" — and `CommitmentsScreen.RefusedChange` already exists in this module as a different type
with different cases. The old name was drift from the day it was written; the rename lands the
public surface on the vocabulary and costs 26 mechanical edits in `DayScreenTests.swift`, listed by
line in `tasks.md` § 1. `#expect(screen.refusedChangeRow == nil)` becomes
`#expect(screen.notice == nil)` — not `screen.notice?.row == nil`, which is true for two different
reasons and would weaken the assertion.

**The cause is words, not an enum.** `Notice.cause` is the sentence, composed inside `DayByDayKit`.
This follows ADR-1022 rather than departing from it: that record's rejected alternative was "a
`DayTitle` value with parts, composed by the shell", refused because assembling is a formatting
rule and `CONTEXT.md` § *App shell* puts formatting rules behind the seam. "Must be between 40 and
150" interpolates two `Decimal`s into English, so it is the same move one screen along. ADR-1022
says in as many words that its reasoning "applies to those on its face, but each is that Story's
decision to take" — this is that Story, and `docs/adr/1036` takes it.

**`cause` is optional, and the shell keeps its one sentence.** A refusal by the place names nothing,
and the shell's existing `Text("Not saved. Try again.")` is untouched — a constant is not a
formatting rule, and the two record-state sentences already live there for the same reason. So the
shell reads `screen.notice?.cause ?? "Not saved. Try again."` and gains no new decision.

**Rejected: naming a cause for the write failure too**, so that `cause` could be non-optional. It
would move a fourth string into the kit for no gain, and it would put words on the one refusal ADR
1021 argues a person can do only one thing about.

### A row holds the number and does not give it out

The prefill in the grill's answer 8 and the silence in answer 3 pull in opposite directions: the
field must open holding the day's number, and the row must never draw it. The delta resolves that
by *where the number can be reached from* rather than by a rule anyone has to keep — the stored
`Row.number` is internal, and the only way out is `numberEntry(asOf:)`, which the shell opens an
alert from. A screen drawing a row has nothing to draw the number with; you cannot forget a rule
that has no expression. `Row.number(_:asOf:)` takes a number *in* and gives back the record made of
it, so it is no second way out: `Number`'s own value is internal to `record`.

That makes the number part of what a row **is**, which is why *A row is a commitment's line on a
date* is modified rather than left alone. `Row` is `Hashable` with synthesized conformance, so a
stored `number` participates in equality, and the alternative — storing it and excluding it from
`==` by hand — is the kind of invisible exception this repo has already paid for once. Including it
is also *correct* on the requirement's own argument: two rows for one number commitment on one date
holding 70.5 and 71 offer different entries, and "one cannot stand in for the other" is exactly what
that requirement says makes two rows different.

**Rejected: `DayScreen.number(on:)`.** It puts the prefill on the screen and leaves the row offering
a hint with no number, which is two public members where one will do and splits one entry across two
types.
**Rejected: passing the history back in — `row.numberEntry(asOf:in:)`.** The shell has no history
and should not be handed one; a row that needs its day view's history to answer is a row that is not
a value.

### Reading what was committed

One private function on `DayScreen`, driven only through `enter(_:on:)`, turning a `String` into one
of three answers. It is not public: the delta's scenarios about "1.2.3" and "70,5" are all
observable through the screen — what the day holds afterwards, and what the row is told — so a
second seam would buy nothing but a second place to test.

The order is: trim surrounding whitespace; if what is left is empty, it is a take-back; otherwise
check the shape in full (optional leading `-`, then characters that are `0`–`9` or one separator,
at least one digit, at most one separator); then count the *significant digits*, which is the next
section; if both hold, replace a `,` with a `.` and call `Decimal(string:)`, and read a `nil` from
it as a value that is not a number. The whitespace trim is what makes `" "` a take-back rather than
a `Decimal(string:)`-flavoured **0**, and it is why the delta says space is disregarded *before*
anything else is decided.

**The parse is never force-unwrapped, and its `nil` is now load-bearing.** An earlier draft of this
section said `Decimal(string:)` "cannot fail on text of that shape" and the code took a `!` on that
word; the measurement in § *Context* shows the claim was false and the `!` a crash a paste could
reach. The draft after it removed the `!` but called the `nil` unreachable, guarded by a bound of
its own — and that bound was wrong, which is the third G7 pass's finding 2. A `nil` is reachable, it
is *how the type says it cannot hold the number*, and it is read as a value that is not a number.

`Decimal` and not `Double`, which is ADR-1032 and not re-decided here.

### A number this system cannot keep exactly is not a number here

The delta promises the number kept is "the number those digits say, exactly, with no digit added and
none dropped", and `record`'s store requirement promises the same digit for digit. `Decimal` cannot
honour that for every string of digits, so the delta says where the promise stops rather than
letting the type decide it silently.

**The rule the reading applies**, on the text once space is disregarded: take the digits, drop the
leading zeros and the trailing zeros, and count what is left. The number is kept when that count is
at most **38**; text saying more digits than that is a value that is not a number. Then the parse
answers the rest — `Decimal(string:)` returning `nil` is the type saying it cannot hold the number
at all, and that too is a value that is not a number.

**One bound of this system's own, and one question asked of the type.** The digits are ours because
past 38 of them the type does not refuse, it *rounds*, and it does not say so: 39 nines come back as
38 nines and a zero. Nothing but counting first catches that. The magnitude is the type's because
the type knows where its own line is and this document twice did not — the sentence that stood here
until the third G7 pass said the line "falls where the type's own does" and then put it at 10^127,
which is thirty-eight powers of ten short: `1` followed by 165 zeros is held exactly, and a person
pasting it was told "Not a number" for a number the delta says SHALL be kept. § *Context* measures
where the line actually is, and the point of asking rather than restating is that the reading can no
longer be wrong about it.

**What makes the two safe together** is measured in § *Context* and is the whole load-bearing claim
here: at 38 significant digits or fewer, `Decimal(string:)` never rounds — it is exact or it is
`nil`. So nothing gets past the count and then comes back a different number.

It is still deliberately a shade conservative, in the one direction that costs nothing: a 39-digit
mantissa below 2^128 does in fact fit — `1` followed by 37 zeros and a `1` reads back exactly — and
is refused all the same, because "thirty-eight digits" is a sentence a person can be told, `2^128`
is not, and no commitment in this product asks for a 39th digit.

**Refused rather than rounded**, because rounding is the one outcome the delta had already ruled
out. A weight of 39 nines kept back as 38 nines and a zero is a record nobody made, and nothing on
the screen would say so. A refusal is visible; a wrong number is not.

**Told as "Not a number", and not as a third cause.** ADR-1036 names exactly two causes and says a
third needs a decision that says so; this is the first candidate and it is declined. The person's
next action is identical to the one for "1.2.3" — type a plainer number — and that action is the
test 1036 actually applies. The requirement is also already using this sentence for a value that is
a number to a person and not to this package: `٧٠` and `1e3` are told "Not a number" today. And the
notice requirement's own paragraph argues that a commitment with no range can meet no refusal but
this one; that argument stays true only while this case lands inside it.

**Rejected: bound the field instead**, capping the `TextField`'s length in the shell. It puts a
requirement in the one file nothing tests, a paste can defeat it, and a capability that promises
exactness must be able to say what it will not keep whatever shell is in front of it.

### A value the commitment refuses does not throw

`enter(_:on:)` throws for exactly one reason — the place would not take the change — which is
`tick(_:)`'s one reason too. A value that is not a number, and a number outside the range, set the
notice and return.

That is deliberate and it has a precedent in this module: `CommitmentsScreen.define(name:on:keptFrom:)`
**returns** its refusal rather than throwing, because a refusal that is an answer about the value a
person gave is not an error condition — it is the screen doing its job. The write failure is
different in kind: it is the device, the caller must not swallow it, and the existing sentence "the
refusal reaching the caller is what a test asserts on" is about exactly that case. Keeping one throw
reason also means no error enum is declared whose cases would duplicate `Notice.cause` and could
drift from it.

**Rejected: throwing for all three.** It forces a public `enum EntryError` that says the same thing
the notice already says, in a second vocabulary, and it makes the shell's `try?` swallow a refusal a
person is meant to read.

### What the shell draws, which nothing tests

`ContentView.swift` gains: a disclosure chevron on a row that offers a number entry, the grill's
answer 16, which is what tells a number row from a tick row before either is used; a tap that opens
`.alert` with one `TextField` prefilled from `entry.number` and place-held with `entry.hint`, with
Save and Cancel; Save calling `try? screen.enter(text, on: row)` and closing; Cancel closing and
calling nothing at all, which is what makes it not a fourth end for the notice. A tick row's tap is
unchanged.

None of that is a requirement (`CONTEXT.md` § *App shell*) and none of it is tested
(`docs/open-questions.md` § *No UI smoke layer*), which is why `tasks.md` § 8 is a person entering a
weight on the phone and reading it back after a force-quit.

## Risks / Trade-offs

- **A number row on a future day invites a tap it will not answer, and now so does its field.** →
  Not mitigated, deliberately. It is B-035's other half and this change declines to fix half a bug
  in one kind of row; whoever takes B-035 finds both here and in the delta's own words.
- **The rename touches 26 assertions in a file of passing tests.** → `tasks.md` § 1 is one
  mechanical step, listed by line, with `swift test` reporting the same count before it and after it
  — whatever `main` has made that count by then. A red test there is a rule-5 stop, not a licence to
  edit further.
- **"Must be between 40 and 150" is now a spec'd string, and localising the app later rewrites it.**
  → Accepted on ADR-1022's own terms: the same is already true of every day title and every rhythm
  in words, and the trigger for revisiting it is a second person using the app in another language.
- **A range of one value says "Must be between 100 and 100".** → Accepted. One rule reads worse in
  a case nobody will meet than two rules read in every case; a `Range(lowest:highest:)` where the
  two are equal is legal and takes exactly one number, which the sentence states truthfully.
- **`enter` is a `String` in, which invites a caller to pre-parse.** → The delta says the reading is
  this capability's, and a caller that parsed first would have to reimplement the separator rule to
  get the same answer. The shell holds a `TextField`'s text and hands it over unread, which is the
  only thing it can do without deciding something.
- **The reading rests on a measured property of `Decimal(string:)` that Foundation does not
  document** — that at 38 significant digits or fewer it never rounds. → Accepted, and it is the
  cheaper of the two risks on offer: the alternative is restating the type's ceiling as a constant
  of our own, which is what this design did twice and got wrong twice. If the property ever stopped
  holding, a number would be kept rounded and nothing would say so, which is why the count is
  checked *before* the parse and never left to the type; and § *Context* records the fuzz, its
  range and its counts, so a later reader can re-run it rather than believe it.

## Migration Plan

Nothing to migrate. No store form moves, no file on a phone is read or written differently, and a
record written by #138 reads back unchanged. The one public renaming is source-level inside this
repository; `DayByDayKit` has no consumer outside it.

## Open Questions

**None.** `grill.md` § *Left open* says "None." with its reason, and writing the delta turned up
nothing that must be answered before the code is written. **Nor did the review, in any of its three
passes.** The first pass's finding that a long paste crashes the app is answered above by a rule
this delta's own words already implied, and the one place it could have become a question — whether
such a value earns a cause of its own — is decided against ADR-1036's stated test rather than by
preference. **The third pass's two are the owner's decisions already taken**, both the same way: the
requirements stand and the code moves. What was left for this document was where the seam is short
(§ *The seam*) and where a measured claim was false (§ *Context*, § *A number this system cannot
keep exactly is not a number here*), and neither is a preference — one is read off the requirement
`tick(_:)` already honours, the other off a measurement anyone can re-run. Five things writing it
turned up, and why each is settled here rather than asked:

- **Whether text holding nothing but space is a take-back or a value that is not a number.** Settled
  as a take-back. A decimal keypad cannot print a space, so nothing a person can do reaches it; the
  delta has to say something, and "space is disregarded first" is one rule where the alternative is
  two that disagree about `" 70.5 "`.
- **Whether the number is part of what a row is.** A real fork, settled in § *A row holds the number
  and does not give it out* on the requirement's own existing argument rather than on a preference.
  The alternative shape was rejected for a stated reason, which is a design decision and not a
  question.
- **Whether a value the commitment refuses throws.** Settled by precedent inside this module —
  `CommitmentsScreen.define` returns its refusal — and it changes no scenario either way, since
  every one of them observes the notice and the day rather than the throw.
- **Whether a number too long to be kept exactly is refused or rounded.** Settled as refused, by
  this requirement's own sentence and by `record`'s store requirement, which both say the number
  kept is the number typed, digit for digit. Rounding satisfies neither, and there is no preference
  available that overrules two requirements already past G4.
- **Whether `docs/adr/1021` is amended or a new record written.** Settled as a new record: 1021
  decides what a day screen does with a record it cannot open, and every word of it stays true. What
  changes is a sentence in a *spec* requirement, whose reasoning cites 1021 — so 1036 cites it back
  and says what it does not touch. `docs/adr/README.md`'s amendment rule applies to a decision that
  moved, and this one has not.
