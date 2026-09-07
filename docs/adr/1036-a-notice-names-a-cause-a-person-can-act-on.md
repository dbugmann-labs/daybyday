# 1036. A notice names a cause exactly where a person can act on that cause differently

- Status: accepted — the decision was the owner's at the Story grill of `add-number-entry` (#139) on
  2026-09-07; this record is written by that change, which reverses the sentence it replaces
- Date: 2026-09-07
- Deciders: Diego Bugmann

## Context

`add-refused-tick-notice` (#100) shipped one sentence in `openspec/specs/day-screen/spec.md` that
this change makes false: "It SHALL tell every refusal the same way, and SHALL name no cause."

It was not a throwaway. The argument behind it is ADR-1021's: a tick refused on a record that could
be read leaves a person exactly one thing to do whatever the reason was — try again, and if it keeps
failing, look at the device — so two messages buy nothing anyone can act on. And #100 built the
shape to make the sentence impossible to lose. Its `design.md` chose
`refusedChangeRow: DayView.Row?` and defended it in terms that leave nowhere for a cause to go: "One
optional, and **nothing else**. No `RefusalReason`, no message string, no count, no `Bool` alongside
it… An `Optional<Row>` has nowhere to put one." It even named what would break it, and named it
correctly: "the first thing a second case would be is the cause this delta exists to refuse."

`add-number-entry` (#139) is that second case. A row for a number commitment takes a typed value,
and two of the ways it can be refused are not the device's doing:

- **A number outside the range the commitment declares.** 300 against a weight of 40 to 150. "Try
  again" is *false* here — committing 300 a second time is refused, and a hundredth time is refused,
  and nothing about the device or the moment will ever change that.
- **A value that is not a number.** "1.2.3", or a lone separator off a decimal keypad. The person has
  to type something else, and nothing else will do.

The shipped words for a refusal — "Not saved. Try again." — are not merely unhelpful for those two.
They are wrong, and they send a person to look at a device that is working perfectly.

The owner was put the choice at the grill and chose to **amend the rule to its own reasoning rather
than reverse it**. The rule was never "say nothing"; it was "say nothing a person cannot act on".

## Decision

**A day screen's notice names a cause exactly where a person can act on that cause differently, and
names nothing otherwise.** The test is what the person does next, and it is the same test ADR-1021
applies to a record that could not be opened, where it yields exactly one named reason out of many.

**Two causes are named and no third may be added without a decision that says so.** A value that is
not a number is told as "Not a number". A number the commitment refuses is told by naming the bounds
it broke — "Must be between 40 and 150". Every other refusal on this screen names nothing: a tick
refused by the place, a take-back refused by the place, a number refused by the place, whatever went
wrong underneath.

**The words are the package's own, composed inside `DayByDayKit`.** Not an enum for the shell to
render. "Must be between 40 and 150" interpolates two bounds into English, which is a formatting
rule, and `CONTEXT.md` § *App shell* puts formatting rules behind the seam because a shell is the one
place no test reaches. ADR-1022 rejected "a `DayTitle` value with parts, composed by the shell" for
this reason and said its reasoning "applies to those on its face, but each is that Story's decision
to take". This is that Story taking it.

**The absence of a cause stays the shell's one constant.** `Notice.cause` is optional, and where it
is `nil` the shell says "Not saved. Try again." exactly as it has since #100. A constant is not a
formatting rule, and the two sentences about a record that could not be read already live there.

**ADR-1021 is not amended.** It decides what a day screen does with a record it cannot open, and
every word of it remains true: every way the store can refuse to open is still answered one way, and
one of them is still named. What moved is a rule about the *notice*, which borrowed 1021's test and
had over-applied it.

## Consequences

- **The notice stops being a bare row.** `DayScreen.refusedChangeRow: DayView.Row?` becomes
  `DayScreen.notice: Notice?`, a value carrying the row and an optional cause. That is the shape #100
  rejected, and it is rejected no longer — but only as one value, never as a second property beside
  the first, because a cause with no row must stay unrepresentable. The rename also lands the public
  surface on `CONTEXT.md`'s own word for this: a *notice* is the day screen's, a *refused change* is
  the commitments screen's, and `CommitmentsScreen.RefusedChange` already exists as a different type.
- **The rule is now a judgement, and judgements drift.** "Can a person act on it differently" has to
  be asked of every future refusal rather than answered once by "no". That is the real cost of this
  record, and it is why the two causes are enumerated in the requirement itself rather than left to a
  reader's sense of the principle: adding a third means editing a spec that has passed G4.
- **The rule met its first candidate before the change had even merged, and declined it.** The
  review of this change's own code found that a pasted number too long for the type to hold exactly
  is refused, and asked what it should say. It says "Not a number", because the person's next act is
  the one "1.2.3" calls for — type a plainer number — and that act is the whole of the test above. A
  third cause was not added. This is what the rule costs and what it is worth: the question has to
  be asked each time, and asking it took one paragraph rather than a new sentence in a spec.
- **Two more strings are pinned by scenarios, and localising the app later rewrites them.** The same
  was already true of every day title (ADR-1022) and every rhythm in words (ADR-1034). The trigger is
  unchanged: a second person using the app in another language.
- **A range that exists only as a refusal is no longer how a person meets it.** The same grill put a
  hint on the empty field — "40–150" — so the bounds are visible before they are broken. The named
  cause is the second half of that, not a substitute for it: a person who has already typed knows
  what the field would have told them.
- **Nothing about a failed write changed.** The one refusal a person can do only one thing about
  still says one thing, still on the row, still with the same three ends. If that ever stops being
  true, this record is what should be edited, and the question to ask is the one at the top: what
  does the person do next.

## Alternatives considered

**Leave the rule and say "Not saved. Try again." for a range refusal.** Cheapest, and no spec
reverses. Rejected because it is a lie in the one place this product cannot afford one: it tells a
person the record failed when the record is fine and the number was wrong, and the action it names —
try again — is guaranteed to fail. A message that is always wrong is worse than no message.

**Say the cause inside the entry rather than on the row.** Put the sentence in the alert, beside the
field, where a person is already looking. Reads better, and the owner considered it. Rejected at the
grill on two grounds: one mechanism then serves refusals on rows and another serves refusals in
fields, and the inside of an alert is unreachable to every test this repo has
(`docs/open-questions.md` § *No UI smoke layer*), so the wording would be the one thing nothing
checks.

**Carry an enum and let the shell compose the sentence.** `case notANumber` and
`case outsideTheRange(lowest:highest:)`. Rejected as the move ADR-1022 already refused: formatting a
`Decimal` bound into English is exactly the kind of thing a test catches and a SwiftUI body does not,
and "40" against "40.0" would be decided in the one file nothing reads.

**Carry the cause in a second property beside the row.** `refusedChangeCause: String?` next to
`refusedChangeRow`. Rejected: it is the "message string alongside it" #100 named and refused, it
makes a cause with no row representable, and two properties that must always move together will one
day not.
