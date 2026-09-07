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
    }

    public struct Row: Hashable, Sendable {
        // commitment, date, isKept as today, plus:
        let number: Decimal?

        /// The number entry this row offers, or `nil` when its commitment's kind is not a number
        /// or the row's date is later than `today`.
        public func numberEntry(asOf today: CalendarDate) -> NumberEntry?
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
```

`numberEntry(asOf:)` sits exactly where `tick(asOf:)` sits, takes the same argument for the same
reason, and refuses for a day that has not arrived on the same line of reasoning. `enter(_:on:)`
sits exactly where `tick(_:)` sits and guards the same three conditions in the same order.

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
by *where the number can be reached from* rather than by a rule anyone has to keep — `Row.number` is
internal, and the only way out is `numberEntry(asOf:)`, which the shell opens an alert from. A
screen drawing a row has nothing to draw the number with; you cannot forget a rule that has no
expression.

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
at least one digit, at most one separator); if the shape holds, replace a `,` with a `.` and call
`Decimal(string:)`, which cannot fail on text of that shape; otherwise it is not a number. The
whitespace trim is what makes `" "` a take-back rather than a `Decimal(string:)`-flavoured **0**,
and it is why the delta says space is disregarded *before* anything else is decided.

`Decimal` and not `Double`, which is ADR-1032 and not re-decided here.

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
  mechanical step, listed by line, with `swift test` reporting the same 489 before and after. A red
  test there is a rule-5 stop, not a licence to edit further.
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

## Migration Plan

Nothing to migrate. No store form moves, no file on a phone is read or written differently, and a
record written by #138 reads back unchanged. The one public renaming is source-level inside this
repository; `DayByDayKit` has no consumer outside it.

## Open Questions

**None.** `grill.md` § *Left open* says "None." with its reason, and writing the delta turned up
nothing that must be answered before the code is written. Four things it did turn up, and why each
is settled here rather than asked:

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
- **Whether `docs/adr/1021` is amended or a new record written.** Settled as a new record: 1021
  decides what a day screen does with a record it cannot open, and every word of it stays true. What
  changes is a sentence in a *spec* requirement, whose reasoning cites 1021 — so 1036 cites it back
  and says what it does not touch. `docs/adr/README.md`'s amendment rule applies to a decision that
  moved, and this one has not.
