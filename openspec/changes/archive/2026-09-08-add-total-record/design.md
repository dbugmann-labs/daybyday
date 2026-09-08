## Context

See `proposal.md` § *Why*. What matters here is what already exists, what this change may not
invent, and — because `grill.md`'s carried-over note 2 binds it — what was **measured** rather than
recalled.

`record` is finished for ticks, numbers and notes, and this change copies their shape where the
total has the same shape and departs from it only where the kind actually differs.
`Number.init?(_:for:on:)` and `Note.init?(_:for:on:)` refuse a record the commitment will not take,
`History.number(for:on:)` and `History.note(for:on:)` read one back, `History.removeNumber(for:on:)`
and `History.removeNote(for:on:)` take one back by naming the commitment and the day (ADR-1033), and
`RecordStore` persists all of it at form 4, reading forms 1 through 4 and refusing a form whose shape
disagrees with what it declares (ADR-1031). `day-screen` has the three shapes this change extends:
`DayView.Row.numberEntry(asOf:)` / `numberRecord(_:asOf:)` and their note twins — the pair #139 named
**for the two Stories that would copy it** — `DayScreen.enter(_:on:)`, and `DayScreen.Notice` with
the two causes ADR-1036 admitted.

**Three departures, and the delta turns on them.** A day holds **many** additions rather than at most
one record; *kept* is answered by a **comparison** rather than by a record being present; and the
row's take-back is a **second act** rather than the same gesture as the entry. Everything else in
this change is the note's shape with a different noun.

### Measured, not recalled

`grill.md` § *Measurements* carries five findings from the grill, each run against this toolchain.
Three of them decide something here and are restated with what they decide. **Two further
measurements were run while writing this delta**, because the grill settled *that* the sum is capped
and left *where and how* to this document, and neither could be answered from the grill's own
numbers. Both were run on this machine on 2026-09-08, Apple Swift 6.3.3 (swiftlang-6.3.3.1.3),
target `arm64-apple-macosx26.0`.

**From the grill, and load-bearing here:**

- `Decimal` addition never traps. It yields `Decimal.nan` on true overflow, which needs on the order
  of 10^127 additions of the largest admissible amount — so a rule guarding only `NaN` guards
  nothing, and the cap cannot be written against it.
- A sum stays exact only while its significand fits 128 bits; past that `Decimal` **truncates toward
  zero**, and every rounding mode gives the identical truncated answer. `NSDecimalAdd` reports
  `noError` while digits are being dropped, so the platform offers no precision-loss signal to read.
- `Decimal.nan >= Decimal(120)` is `false` and `Decimal(120) >= Decimal.nan` is `true`. **The kept
  rule is therefore written as `sum >= target` and never as `target <= sum`**, and the delta says so
  in words ("the comparison SHALL be the sum against the target, in that order").

**Measurement A — a truncated sum cannot be recognised from the sum alone.**

```
a                        b        a + b                                     sig(a+b)  exact?
38 nines                 1        100000000000000000000000000000000000000          1   yes
38 nines                 0.5      99999999999999999999999999999999999999          38   NO
1e37                     1e-10    10000000000000000000000000000000000000           1   NO
38 nines                 38 nines 199999999999999999999999999999999999998         39   yes
37 nines                 0.5      9999999999999999999999999999999999999.5         38   yes
```

Row two is the finding. The true sum of 38 nines and 0.5 needs thirty-nine significant digits, and
`Decimal` answers with thirty-eight — a value that *looks* well inside any digit bound and is not the
sum. **So a rule written as "the sum this system then holds has at most thirty-eight significant
digits" would accept exactly the case it exists to refuse**, and the delta is written against the sum
*arithmetic gives* rather than against any shortened form of it. Row one is the other half: 38 nines
plus 1 is 10^38, which has **one** significant digit and is held exactly, so a rule written on
magnitude rather than on significant digits would refuse a sum that is perfectly good.

**Measurement B — a predicate that answers correctly on every case above.**

```swift
let sum = soFar + amount
sum.isNaN == false
  && significantDigits(of: sum) <= 38
  && (sum - amount) == soFar && (sum - soFar) == amount
```

Run against ten cases spanning the two directions, the boundary and ordinary amounts, it answered as
predicted on all ten: `0 + 30`, `30 + 90`, `70.5 + 0.25`, `0.000001 + 0.000001`, `1e38 + 1e38` and
`37 nines + 0.5` admitted; `38 nines + 0.5`, `1e38 + 0.5` and `38 nines + 38 nines` refused; `38
nines + 1` admitted. The two subtractions are what catch measurement A's row two, and the digit count
is what catches `38 nines + 38 nines`, whose exact sum has thirty-nine significant digits and which
`Decimal` happens to hold — refused deliberately, because **thirty-eight is #139's own bound and
thirty-nine is only sometimes holdable**, so admitting it would make the answer depend on the
magnitude rather than on the digits.

It also holds a line under accumulation: adding "37 nines and a half" repeatedly, twenty attempts
admitted two and refused eighteen, and the sum it left is exact.

**This is a shape, not a specification.** `tasks.md` § 15 requires it measured again through
`DayByDayKit` before it is believed, because #139's carried-over note 3 is that evidence which does
not go through the seam is not evidence.

## Goals / Non-Goals

**Goals**

- One `Addition` record that copies `Number`'s shape exactly where the shape is the same, so a
  reader meeting the fourth kind reads three familiar refusals and one new one.
- **One place that decides whether an amount may be added**, holding both the above-zero rule's
  outcome and the sum cap, so that the state the delta forbids — a commit that is neither added nor
  refused — is unrepresentable rather than merely tested for.
- One way in for a commit, whatever entry the row offers, so a caller cannot pick the wrong door;
  and exactly one act besides, for the one thing a commit cannot mean.
- The day's **sum** kept out of everything but the entry, and the day's **additions** kept out of
  `day-screen` entirely.

**Non-Goals**

- The general record reader all four kinds could share. `grill.md` § *Left open* carries it, and
  § *Open Questions* below says why it is not taken here even though #138's deferral named this
  Story as where its stated reason expires.
- Any change to what a number entry or a note entry does. Their readings, their causes and their
  blank-means-take-back are untouched; what changes is that the sentence naming *two* causes now
  names four, and every one of the two it named still says what it said.
- Reading a day's additions back anywhere — a list on the row, a history of the day, an "undo"
  showing what would go. Nothing has asked for one, and `grill.md` answer 6 settled it.
- Clearing a day in one act. `grill.md` answer 7, and it is a want if it turns out to be wanted.
- Fixing B-035, the tap a future row does not answer. Repeated a fourth and last time, deliberately,
  so one fix covers every kind of row.
- A UI test of any kind. `docs/open-questions.md` § *No UI smoke layer* still holds.

## Decisions

### The seam

**Widened, not new.** One new type in `record`, three new members on `History` and two on
`RecordStore`; three members and two nested types on an existing row; one existing screen member
widened and one added beside it. Every scenario in this delta is driven through `Addition`,
`History`, `RecordStore`, `DayView` or `DayScreen`, and no test spawns a process or captures a
stream.

```swift
/// An addition recorded for a total commitment on a calendar date it is due on.
public struct Addition: Hashable, Sendable {
    let commitment: Commitment
    let date: CalendarDate
    let amount: Decimal

    /// `nil` when the commitment is not due on `date`, when its kind is not a total, or when
    /// `amount` is not above zero — a value that is not a number among them.
    public init?(_ amount: Decimal, for commitment: Commitment, on date: CalendarDate)
}

public struct History {
    // ticks, numbers and notes as today, plus:
    private var additions: [RecordedDay: [Decimal]]

    /// Appends to the day `addition` is for. A day holds many, in the order they were made, and a
    /// second addition alike in every way to the first is held beside it.
    public mutating func add(_ addition: Addition)

    /// Removes the last addition of that day, leaving the history unchanged where it holds none.
    public mutating func removeLastAddition(for commitment: Commitment, on date: CalendarDate)

    /// What that day has added: the sum of the additions it holds, and zero where it holds none —
    /// for every commitment, on every date, whatever its kind.
    public func total(for commitment: Commitment, on date: CalendarDate) -> Decimal

    // isKept widens a third and last time: a total is kept when total(for:on:) >= its target.
}

public final class RecordStore {
    public func add(_ addition: Addition) throws
    public func removeLastAddition(for commitment: Commitment, on date: CalendarDate) throws
}

extension DayView {
    /// What a total commitment's row offers in a tick's place. One thing, and no more.
    public struct TotalEntry: Hashable, Sendable {
        /// The day's sum and the commitment's target, in this package's own words — "150 of 120".
        public let soFarOfTarget: String
    }

    /// What a row makes of an amount committed in its total entry.
    public enum TotalRecord: Hashable, Sendable {
        case addition(Addition)
        case notAboveZero
        case tooLargeToAdd
    }

    public struct Row {
        // commitment, date, isKept, number, note as today, plus:
        let total: Decimal

        /// The total entry this row offers, or `nil` when its commitment's kind is not a total or
        /// the row's date is later than `today`.
        public func totalEntry(asOf today: CalendarDate) -> TotalEntry?

        /// What this row makes of `amount` — an addition of this row's commitment on this row's
        /// date, or the reason it makes none. `nil` when the row offers no total entry as of
        /// `today`.
        public func totalRecord(_ amount: Decimal, asOf today: CalendarDate) -> TotalRecord?

        /// Whether this row offers taking its day's last addition back: exactly when it offers a
        /// total entry as of `today` and its day's sum is above zero.
        public func offersTakeBackLast(asOf today: CalendarDate) -> Bool
    }
}

@MainActor @Observable public final class DayScreen {
    /// Unchanged signature. Enters what `text` holds in whichever entry `row` offers — and on a
    /// total row, adds it to what that day already holds.
    public func enter(_ text: String, on row: DayView.Row) throws

    /// Takes back the last addition `row`'s day holds. Does nothing when `row` offers no
    /// take-back, when it is not one this screen's day view holds, or when this screen is not
    /// keeping a record.
    public func takeBackLast(on row: DayView.Row) throws
}

/// The one place this package decides how many significant digits a decimal holds, and whether a
/// day may take an amount. Internal; `design.md` § *Where the sum cap lives* fixes the rule.
enum Digits {
    static func significant(in decimal: Decimal) -> Int
    static func canAdd(_ amount: Decimal, to soFar: Decimal) -> Bool
}

// In DayScreen.swift, private to this capability, beside the number's and the note's twins.
private extension RecordStore {
    func removeLastAddition(on day: RecordedDay) throws
}
```

`totalEntry(asOf:)` follows the pair #139 named — `<kind>Entry(asOf:)` for what a row offers. **The
second half of that pair is where the total departs, and #139's own note said it would**: a
`<kind>Record(_:asOf:)` returning `Addition?` would collapse two refusals a person is told apart
into one `nil`, and the screen would then have to re-derive which of them happened, from the amount
and a sum the row is deliberately not giving out. `TotalRecord` is the enum that keeps that
derivation in the one place that already holds both facts. Optional-returning, so `nil` still means
*this row offers no such entry* exactly as it does for the number and the note.

**Rejected: a second screen member for adding, `add(_:on:)` beside `enter(_:on:)`.** #140's argument
holds unchanged: two public members taking `(String, DayView.Row)` and differing only in name, each
answering the other's row with silence, cannot be told apart from a bug at a call site. `enter` was
already a kind-neutral verb and the row already says which entry it offers.
**Accepted, in contrast: a second screen member for the take-back, `takeBackLast(on:)`.** It is not
that rejected shape — it takes no text, so no caller can confuse the two, and it answers a row that
offers no take-back with silence for the same reason `enter` answers a row that offers no entry with
silence. The alternative is a magic text committed in the entry, which is exactly what `grill.md`
answer 4 refuses.
**Rejected: `Row.takeBackLast(asOf:) -> TakeBackLast?`, a value with no parts.** A value carrying
nothing is a `Bool` with ceremony, and there is no second thing a take-back could ever say: the
addition it removes is named by the day's order and not by anything the row could hand over.

### Where the sum cap lives, and why it is not in `record`

**It is `day-screen`'s, and it is the same rule `add-number-entry` already ships there.** *A day
screen reads what an entry is committed with as a number…* already says: "Up to **thirty-eight
significant digits** SHALL be kept… Text saying more digits than that… MUST NOT be rounded,
shortened or otherwise fitted to what can be held". `Number.init?` carries no digit bound at all, and
`record` has never had one. Putting the total's cap anywhere else would give this package two homes
for one number.

`grill.md` § *Notes for `spec-author`* named two candidates and left the choice here. Both are in
`record`, and **both were rejected on the same measured ground**:

- **`Addition.init?(_:for:on:addedTo: History)` — the record refuses to form against a day.** It
  makes `record`'s own store unable to re-form its own content: `grill.md` answer 12 fixes that a
  store re-forms each addition on its own and applies no rule across a day, so `RecordDocument`
  would have to call this initializer with an *empty* history, where the fourth argument does
  nothing. An argument that is a lie at one of its two call sites is worse than no argument.
- **`History.add(_:)` refuses the add.** Then a store reading a file whose day sums past the cap
  drops the additions past it while its own mirrored copy still holds them — so the store's history
  and the bytes it will write next disagree, and the next change kept at that place writes back
  records the history never had. That is a store that reads back differently from what it holds,
  which is the one failure `record`'s store requirements exist to prevent. `grill.md` answer 12
  declined dropping them, and declined refusing the whole store; what is left is that a history
  holds what it is given.

So: `record` accepts every amount above zero and holds whatever sum results, and the delta says so —
*A store that cannot be read is refused rather than emptied* gains a paragraph stating that each
addition is re-formed on its own and **no rule is applied across a day**, with a scenario proving a
hand-written file past the cap opens rather than being refused. That paragraph is the honest cost of
this decision and it is written down rather than left as a silence.

**Where in `day-screen`**: at the **row**, in `totalRecord(_:asOf:)`, because the row is the one
thing that holds both the amount offered and the day's sum. `DayScreen.read(_:)` already refuses text
saying more than thirty-eight significant digits, so the amount reaching the row is always inside the
bound on its own; what the row adds is whether the *day* stays inside it.

**The rule is written on the sum arithmetic gives, never on the sum the system would then hold.**
Measurement A row two is the whole reason: those two differ exactly when the rule is about to be
broken. The delta says it in words, and `tasks.md` § 15.2 is the box that fails an implementation
which reads the digits off the truncated answer.

`docs/adr/1040` carries this decision, because a reader meeting a thirty-eight in `day-screen` and
none in `record` will otherwise assume the cap was forgotten in the record.

### `kept` stops being "is there a record"

For three kinds, `isKept` asks whether a day holds something. For a total it asks whether the day's
sum has reached the commitment's target. Two things follow and both are in the delta:

- **The comparison is `sum >= target` and never the reverse.** Measured at the grill: the two answer
  differently where a sum is not a number, and only this order answers *not kept* there. A sum can
  reach that state only through a hand-written store, which the decision above deliberately reads
  rather than refuses — so the order is not decoration.
- **A day with no additions is not a special case.** It sums to zero, a target is above zero
  (`commitment`'s own requirement), so zero is below every target there can be. The delta states the
  chain rather than writing an empty-day rule, because an empty-day rule is a second place for the
  answer to live.

`History.total(for:on:)` answers **zero and never `nil`**, for every commitment of every kind on
every date — `grill.md` answers 14 and 16, given against the recommendation. It is a real widening of
the package's shape and the delta owns it: the number's and the note's readers answer *nothing*
where the day holds none, and this one does not, because the sum of no additions really is zero
whatever the commitment. It also buys the take-back's availability for free — every addition is above
zero, so `total > 0` and *the day holds an addition* are the same question, and the row can read the
second off the first without ever seeing the list.

### A day's additions are a list, and the file holds them as one record per day

`History.additions` is `[RecordedDay: [Decimal]]` — the same key every other record uses, with an
ordered list behind it rather than one value. On disk, `RecordDocument` gains
`additions: [AdditionsRecord]?` where an `AdditionsRecord` is a commitment, a date and the day's
`amounts` **in order**.

**One record per commitment-day, not one per addition.** `RecordDocument` sorts every record kind on
one five-part key — name, kept-from, date, schedule, kind — so that two equal histories produce
byte-identical files. Two additions of one commitment on one date tie on all five, and a
per-addition record would therefore need a sixth key that is nothing but *the position in the day*.
Holding the day's list in one record makes the position implicit in the array, keeps the existing
sort key untouched, and makes "at most one record per commitment per day" true again at the file
level even though it is false at the history level.

**Each amount is re-formed through `Addition.init?` on its own**, exactly as `formNumbers()` and
`formNotes()` do, and a `nil` refuses the whole document rather than dropping the bad one. A day
carrying an **empty** `amounts` array refuses the document too: the store never writes one, because a
day with no additions holds no record, so an empty array is content this app did not write.

`RecordDocument.currentVersion` moves 4 → 5 and `additionsIntroducedInVersion = 5` joins its two
siblings; `RecordStore.init`'s shape-against-form guard gains a third clause of the same shape.
`AdditionsRecord` conforms to `DatedCommitmentRecord`, so the order stays one comparison.

**Rejected: persisting the day's sum beside the additions.** It is derived, `CONTEXT.md` says so in
as many words, and a file carrying both would have two answers to one question the moment one of them
was written wrong.

### `RecordStore.write` and `RecordDocument.init` take labels

`docs/open-questions.md` records, against this Story by name, that `(ticks, numbers, notes)` travels
as three unlabelled positional parameters through `RecordStore.write(_:_:_:)` and
`RecordDocument.init(_:_:_:)` across six call sites, and that the compiler tells them apart today
only because the value types differ. This change makes it four.

**They become `write(ticks:numbers:notes:additions:)` and
`RecordDocument(ticks:numbers:notes:additions:)`.** No behaviour moves, no requirement moves, and it
is a mechanical box in `tasks.md` § 1 rather than a refactor pass — the point is that it happens at
the moment the debt was recorded to come due, rather than one kind later when there is nothing left
to add and no reason to touch the file.

**Rejected: a `Records` struct holding all four.** That is the general-record shape § *Open
Questions* defers, and taking half of it here — a container for the writer while the reader stays
four members — would leave the package with two answers to "what is a record" and neither complete.

### The entry says the words, and says only the words

`TotalEntry` has one member: `soFarOfTarget`, "150 of 120". Three things fix that:

- **`CONTEXT.md` § *App shell* forbids the alternative.** "A formatting rule… fails that test and
  owes a Story." Two `Decimal`s handed out for a SwiftUI body to interpolate is a formatting rule in
  the one file nothing tests — the same move ADR-1022 rejected for the day title and ADR-1036 for
  the range cause. `NumberEntry.hint` is the settled precedent: the range is composed inside the kit
  as "40–150", and this is that, one kind along.
- **`grill.md` answer 8 is satisfied.** The entry says two things — the sum so far and the target —
  and one phrase says both. Answer 13 pins the shape of the phrase, "150 of 120", including that the
  sum is the true one past the target.
- **Answer 6's principle applies to the entry too.** Handing out `soFar` and `target` beside the
  phrase would be three members where one has a caller.

**No hint, deliberately** — `grill.md` answer 10. A range is a bound one commitment declares and
another does not; "above zero" is the same rule on every total row there will ever be, and a hint
identical everywhere teaches nothing and is read by nobody after the first week.

**The field opens empty, and nothing in the seam offers a value to prefill it with.** That is the
one place a caller could get this catastrophically wrong — prefilling from the day's sum and
committing it unread doubles the day — and the shape is what prevents it: `TotalEntry` hands out a
phrase, not a number, so there is nothing a field could be bound to.

### `enter(_:on:)` gains a fourth branch, dispatching on what the row offers

```swift
if let entry = row.numberEntry(asOf: today)      { /* unchanged, exactly as today */ }
else if row.noteEntry(asOf: today) != nil        { /* unchanged, exactly as today */ }
else if row.totalEntry(asOf: today) != nil       { /* the total's reading */ }
else { return }
```

The total branch reads `Blank.saysNothing(text)` first and returns having changed and told nothing —
the one commit in this system that is read and then means nothing. Otherwise it runs
`DayScreen.read(_:)`, **unchanged**, and switches: `.notANumber` names "Not a number"; `.takeBack`
cannot arrive, because the blank test already returned; `.number(d)` goes to
`row.totalRecord(d, asOf: today)`, whose three answers are the addition, "Must be more than 0" and
"Too large to add". The final `else` is now a **tick row alone**, which is what shrinks the fourth
case of *A day screen tells nothing on a row where there was no tick to refuse*.

Sharing `read(_:)` rather than writing a second reading is what makes "Not a number" one cause rather
than two, and it is why ADR-1036's set grows by two and not by three.

### ADR-1033 is amended in place, and its reversal trigger fires without reversing it

1033 says its reversal trigger is "the fourth kind, and only the fourth", and that when the total is
recordable "a single take-back over a shared record type may be worth having, and the tick would move
with it". **This is that day, and the answer is still no** — for the reason 1033 itself names one
paragraph earlier: a total's take-back removes its last addition rather than the record, so a shared
signature would have one member that means *clear the day* for three kinds and *remove one thing*
for the fourth. That is the shape the record already rejected as reading more general than it is.

The amendment records that the trigger fired, what was found, and what would now have to change for
the answer to be yes — so the next reader does not have to run the question again from the top.
`docs/adr/README.md` § 2's stamp applies, and **the filename does not move**, for the reason it did
not move in #140: the archive holds a path to it that permission settings forbid editing.

## Risks / Trade-offs

- **The sum cap lives in `day-screen`, so `record` will accept a day whose sum is not the sum.** →
  Accepted, stated in the delta, and given a scenario. It is reachable only by hand-writing a store
  file, the alternatives both break something worse (§ *Where the sum cap lives*), and `grill.md`
  answer 12 already declined refusing such a store. The cost is that a reader of `record` alone
  cannot see the rule; ADR-1040 exists so that reader finds it in one hop.
- **Thirty-eight refuses a thirty-nine-digit sum `Decimal` could hold.** → Accepted and measured
  (measurement B, `38 nines + 38 nines`). Thirty-nine is holdable only below 2^128−1, so admitting it
  would make the answer depend on magnitude; thirty-eight is #139's own bound and one number in this
  package rather than two. What is refused is a day nobody keeping a commitment can reach.
- **The predicate needs two subtractions to be correct, and nothing about it is obvious.** →
  Mitigated by measurement A, which shows why the cheap version is wrong, and by `tasks.md` § 15,
  which requires it measured through `DayByDayKit` rather than beside it — #139's carried-over note
  3, which cost that Story four review passes.
- **Two rows of one total commitment on one date whose days hold different additions summing alike
  are the same row.** → Accepted, stated in the delta and pinned by a scenario. Everything a row does
  is answered by the sum, and the take-back reaches the record at the place rather than through the
  row, so nothing behaves wrongly; carrying the list to tell them apart would put the additions
  inside `day-screen`, which § *The entry says the words* exists to prevent.
- **A total row is the first row that offers two things, and the second appears and disappears.** →
  Accepted. `grill.md` answer 9 weighed it against a control that does nothing when tapped, which is
  already an open question against this product, and chose the appearing control. The price is that
  a shell must ask two questions of a total row where it asks one of every other.
- **`History` now answers four questions four ways and still gives no tick out.** → Accepted and
  recorded: the thirteenth and fourteenth faces of the public-surface gap, landed at G7 as #139's
  eleventh and #140's twelfth were.
- **A commit meaning *nothing at all* exists only on a total row**, so one gesture has two meanings
  across two kinds of row. → Accepted, and ADR-1041 is written for it. The alternative — blank means
  take-back-last — silently deletes the most recent thing a person added, which is `grill.md` answer
  4 and the sharpest failure this change could ship.
- **This is the largest delta the repo has taken: 102 new scenarios — 43 in `record` and 59 in
  `day-screen`.** → Accepted, and it is the arithmetic of `grill.md` answer 1: this Story is a record
  half and a row half in one folder, like #140, plus a second act on the row that no earlier kind
  had. The alternative was two Stories and two G4s for one kind, which the grill weighed and
  declined.

## Migration Plan

Nothing to migrate by hand. Form 4 stores read back unchanged with no addition on any day, and are
rewritten whole at form 5 the next time anything is kept at that place — ADR-1031, unchanged. The
sites that say `5` to mean *a form later than the record store writes* move to `6`, which is a
mechanical step with no behaviour in it (`tasks.md` § 1), and the roster store's own sites do not
move because `RosterDocument.currentVersion` is untouched.

## Open Questions

**One, carried from the grill, and it is deliberately not closed here.**

**The general record reader all four kinds would share.** `grill.md` § *Left open* is this, and
answer 3 settled that this Story's reader stays kind-shaped. #138's grill deferred the general reader
at its Q5 "rather than fix the shape of two records nobody has grilled yet", and #140's `design.md`
named this Story as where that reason expires. **It does expire** — all four kinds now exist, and the
fourth is the one whose shape was said to decide it. What replaces the deferral is a different
reason, and it is one this Story cannot spend: folding four readers into one is a refactor across
`record` and `day-screen` with **no behaviour change**, rewriting requirements that three merged
Stories have already signed, inside a Story that is about totals. Doing it here would mean a G4 diff
in which the new kind and a rewrite of the old three are indistinguishable.

It is recorded in `docs/open-questions.md` at G7 (`tasks.md` § 17.5) as the thirteenth and fourteenth
faces of the public-surface gap, together with what the fourth kind actually taught: the four readers
are **not** the same shape — three answer *a value or nothing* and this one answers *a value,
always* — so a general reader is a design question rather than a mechanical merge, and it is its own
change.

**No residual round is outstanding, and none was raised.** Six rounds of grilling settled seventeen
questions, and everything writing the delta turned up was decided by something already written down
rather than by a preference the owner holds. What was settled here, and what settled it:

- **Where the sum cap lives.** Not a preference: `add-number-entry` already puts the same
  thirty-eight in `day-screen`, and both `record`-side candidates break a store's own round trip
  (§ *Where the sum cap lives*). Measured, not argued.
- **Whether the cap is judged on the exact sum or on the sum the system would hold.** Not a
  preference: measurement A shows the second accepts the case the rule exists to refuse.
- **Whether the total entry hands out two decimals or one phrase.** Not a preference:
  `CONTEXT.md` § *App shell* forbids a formatting rule in the shell, and ADR-1022 and ADR-1036 have
  both already decided this for a day title and a range cause.
- **Whether the row's second member returns `Addition?` or an enum.** Not a preference: two causes
  are told apart on the row, and one optional cannot carry two.
- **Whether the file holds one record per addition or one per day.** Not a preference: the existing
  five-part sort key ties on two additions of one commitment-day, and the alternative is a sixth key
  that means nothing but *position*.
- **Whether `takeBackLast(on:)` is a second screen member.** Settled against #140's own rejected
  shape, on the stated ground that it takes no text and so cannot be confused with `enter`.
- **Whether two rows whose days sum alike from different additions are the same row.** A consequence
  of answer 6 rather than a decision of its own, pinned by a scenario so it stays one.
- **Whether ADR-1033's reversal trigger, which fires here, is taken.** Not a preference: 1033's own
  paragraph on a shared take-back names why a total cannot join one, and it names it before this
  Story existed.
