# 1046. A range and a target reach a commitments screen as text, and the screen judges them

- Status: accepted — the shape was the owner's decision at the Story grill of
  `add-kind-to-commitments-screen` (#142) on 2026-09-10 (answer 2), which asked for it to be
  explained in the delta; whether it was owed a record of its own was left to `spec-author`
- Date: 2026-09-10
- Deciders: Diego Bugmann
- Amended: 2026-09-10 — what a half-written range is, and why a value the chosen kind has no room for
  is ignored rather than refused, are added to the decision by `condense-commitment-spec` (#204),
  which deletes the requirement prose that carried both arguments.

## Context

A **commitments screen** takes a rhythm one of four ways, and three of those four carry a number: a
day of the month, an interval of days, a weekly quota. Every one of those numbers arrives at
`CommitmentsScreen.define` **already formed** — an `Int` the **app shell** built out of a `Stepper`
or a `TextField(value:format:)` — and all the screen judges is whether the rhythm allows it. That is
*A commitments screen refuses a rhythm number the calendar will not take*, and it has been the shape
since `add-commitments-screen` (#104).

This Story puts two more numbers on the same form: a number kind's **range**, which is two of them,
and a total kind's **target**. Following the rhythm's shape would have the shell form a `Decimal` for
each and hand three optionals over. Following the shape a **number entry** takes on a day screen's row
— `DayScreen.enter(_:on:)` takes the text a person committed and answers *not a number* — would have
the screen take three strings.

They are not the same decision dressed twice. A rhythm number is bounded and small: a `Stepper` can
offer 1 to 31 and there is no text a person can type into it that is not a number. A range end and a
target are neither. They may be negative, may carry a decimal fraction, may be spelled with a comma
or a full stop, and have no ceiling short of what this system can keep exactly — so a field that
takes one is a field a person can type something into that is not a number, and something has to say
so.

Two further facts shaped it, both already in the repo rather than reasoned out here:

- **`Decimal(string:)` is a prefix parser, not a validator.** `add-number-entry` (#139) measured five
  ways it reads a value nobody typed — `"40kg"` is 40, `"1e2"` is 100 — and wrote its own reading in
  `DayScreen`, which consults no locale and never hands that initialiser the text as typed. Whoever
  forms the number is the one who has to get this right.
- **A screen holds no words a person reads** (ADR-1022), and a notice names a cause a person can act
  on (ADR-1036). Both are about refusals surfacing *from* the package with the drawing left free.

## Decision

**A range end and a target reach the commitments screen as the text the person typed, and the screen
judges them.** They are not formed, judged or blocked before they arrive. The screen asks
`Blank.saysNothing` first — a blank field is a field nobody filled in, not a number that failed to
read — and then puts what is left to **one reading of a typed number**, the reading `add-number-entry`
wrote, which moves out of `DayScreen` to a package-internal type both screens call.

The screen answers two refusals from that, *a range that is not a range* and *a target that is not a
target*, each collapsing three ways to fail because what a person does about any of them within a
group is the same thing (ADR-1021).

**The rhythm numbers are deliberately left as they are.** This is not a rule that the screen must
take everything as text; it is a rule about which numbers a person can spell wrongly.

**A half-written range is its own refusal, because there is no such value as half a range.** A range
is both ends or neither, so a lowest typed with the highest left blank names nothing the value can be
asked about: reading it as "no range at all" throws away a bound the person deliberately entered, and
inventing the other end puts a bound on their commitment that nobody typed. Both ends left blank is
not this refusal and is not a refusal at all — it is a commitment of the number kind carrying no
range.

**A range or a target left in a field the chosen kind has no room for is ignored, and not refused.**
A tick or a note carries neither whatever those fields hold; a number kind takes its range and
ignores a target; a total kind takes its target and ignores a range. A person who typed a range and
then chose Note is not asking for a range, and refusing something nobody asked for is noise in front
of the thing they did ask for. It does not disagree with the rule above: there the person had chosen
the kind the field belongs to, so the bound they typed meant something.

## Consequences

**What this buys.**

- "That is not a number" is something a person reads beside the field they typed it in, rather than a
  keystroke the shell silently declined. A field that will not accept a character teaches nothing and
  a person who typed a comma on a phone that offered them one has no way to find out why.
- The **app shell goes on deciding nothing.** It binds four `String`s and a picker and calls one
  method. Every rule about what a range and a target are lives in one package, is regressed by
  acceptance tests, and cannot drift into a SwiftUI view where nothing checks it.
- **One answer in this system to "is that text a number."** The commitments screen and a day screen's
  row cannot come to disagree about `1e2`, `0,5`, a trailing zero or an invisible character, because
  there is one reading and both call it. That is the third time this package has pulled a shared
  judgement out to one place, after `Blank` (ADR-1039) and `Digits` (ADR-1040), and it is the same
  argument each time.

**What it costs, named rather than hidden.**

- **`define`'s signature is inconsistent on its face**: an interval rhythm's number arrives as an
  `Int` and a range end beside it as a `String`. A reader will trip over that, which is the reason
  this record exists.
- **A number this system cannot keep exactly is refused as "not a number."** The reading caps at
  thirty-eight significant digits (ADR-1040), which `Commitment.Range` itself would not refuse. That
  is accepted: keeping a bound truncated is a bound the person did not type, met months later on a
  day they cannot record a weight on. No mood, weight or dose is that long.
- **The screen now owns a parsing rule it could have been handed the result of.** Reversing this is
  cheap in code and expensive in meaning — it would move the refusal into a layer with no tests, so
  the reversal trigger is not "the signature looks odd" but "the shell has grown a rule of its own",
  which is what would make it wrong.

## Alternatives considered

**The shell forms the `Decimal`s and hands over optionals.** Rejected: `nil` then means both "left
blank" and "not a number", which are different answers with different consequences — one is *no
range*, the other is a refusal — and untangling them would put the reading back in the shell anyway.

**A field the shell will not let a bad character into.** Rejected: a person cannot be told why a
keystroke did nothing, and *An iPhone, in your hand* is exactly where an unexplained dead keyboard is
worst. It also decides, in a view, which spellings of a number are allowed.

**A second reading of a typed number, written for this screen.** Rejected on sight: two readings is
how `1e2` becomes a number on one screen and not on the other, and nothing would ever catch it.

**Widening the change sheet to take a kind too, so the two acts stay symmetric.** Out of scope and
refused at the grill (answer 8): a kind never changes, so a fifth argument there would only create a
refusal for a state the form cannot produce.
