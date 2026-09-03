## Context

`DayByDayKit` exports six seams today: `Schedule.isDue(on:)` (#8–#11), `Commitment` (#42), the pair
`Tick`/`History` (#55), `RecordStore` (#56), `DayView` (#70, widened by #71 and #72) and `DayScreen`
(#91). Everything below the last is a pure value over `CalendarDate` with no clock, no time zone and
no locale (ADR-1004); `DayScreen` is the one exception and it is handed its day rather than reading
one. Motivation is in `proposal.md`; the behaviour contract is `specs/commitment/spec.md` and is not
repeated here.

This is the first Story on `commitment` since #42 defined what a commitment is, and the first of the
four #26's G2 accepted on 2026-09-03: this one, then `add-roster-retirement` (#102),
`add-roster-store` (#103) and `add-commitments-screen` (#104), serialised because all four target
the same capability.

**Measured on this machine on 2026-09-03 rather than recalled.** `cd src/DayByDayKit && swift test`
reports **192 tests passing at `125da39`**, on Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target
`arm64-apple-macosx26.0`; `openspec` is 1.10.0 and `node --version` is v24.19.0. **No scenario in
this delta asserts that anything is due**, so no weekday is claimed anywhere in it and none needed
measuring — a deliberate property of the delta rather than an omission, and it is what
§ *A roster judges no date* below is arguing for. The two dates at the edge of the supported range
are `openspec/specs/schedule/spec.md`'s and are consumed rather than restated: `CalendarDate.init?`
guards `(1583...9999).contains(year)`, so 31 December 9999 is a date a commitment can be kept from
and is the one such date used here.

Five facts about the shipped code that this design stands on, read out of the sources rather than
assumed:

- **A commitment is already a value with no identifier.** `Commitment` is a `Hashable, Sendable`
  struct of `name`, `schedule` and `keptFrom`, and `openspec/specs/commitment/spec.md` says in as
  many words that it "holds no hidden identity that would make two commitments a person would call
  identical distinguishable to the system". So *"a commitment it already holds"* has exactly one
  possible meaning, and this Story invents none of it.
- **Nothing in the package holds a set of commitments.** `DayView.init(of:on:in:)` and
  `DayScreen.init(of:asOf:keeping:)` both take `[Commitment]`, `DayView` keeps only its rows and its
  date, and `DayScreen` keeps the array it was handed privately and never adds to it. There is no
  existing type this behaviour could be a widening of.
- **`History` is the shape to copy.** It is a `Hashable, Sendable` struct with an empty `init()`,
  private storage and `mutating` `add`/`remove`; `RecordStore` is the class that keeps one at a
  place. The roster/#103 pair is the same split, one capability over.
- **`Commitment.name` is public; `schedule` and `keptFrom` are internal.** A roster living inside
  the module can compare whole commitments regardless — `Hashable` is synthesised over all three —
  so nothing has to become public for the refusal to work, and this Story does not widen the known
  gap in `docs/open-questions.md` about a schedule's payload not reading back.
- **The shell holds the only list of commitments there is.** `ContentView.swift` builds
  `dayOneCommitments`, eight values with `keptFrom` 2026-08-28, and passes it straight to
  `DayScreen`. It is display data, not a rule, and it stays exactly as it is after this Story.

## Goals / Non-Goals

**Goals:**

- One place that holds what a person keeps, which cannot hold the same commitment twice.
- An order that comes from the person and never from the system.
- A refusal the caller can see. #104's screen has to be able to say "you already keep this", and it
  can only do that if the roster tells it.
- Purely additive. #42's four requirements were signed on 2026-09-02 and none of them moves; the
  delta is two ADDED requirements and nothing else.
- Nothing new made public that the delta does not observe, and no existing member widened.

**Non-Goals:**

- **Retiring, removing or changing anything.** A roster in this Story only grows. Stopping keeping
  a commitment is #102 and is the Story that makes the roster hold more than a list; changing a
  commitment's name or rhythm is B-014 and is not in this Feature at all.
- **Keeping a roster across the app being closed.** #103. Nothing here is encoded, decoded, or given
  a place, and no version number is written.
- **Any screen.** #104. What a list of commitments looks like, in what order it is *drawn*, what it
  says when an addition is refused, and where the "add" button is are all the screen's.
- **Feeding `DayView` or `DayScreen` from a roster.** Both take `[Commitment]` and keep taking it.
  Changing either signature is a delta against `openspec/specs/day-screen/spec.md` — a second
  capability, so a second Story (rule 5), and it is #104's, where there is finally a screen that
  holds a roster to feed them from.
- **Answering which commitments apply on a date.** Deferred to #102 by the owner on 2026-09-03.
  See § *A roster judges no date*.
- **Telling two identical commitments apart.** The roster's answer is that there are never two. If
  the product ever wants two commitments a person would call identical, that is a want, and it is
  the want that would force an identifier onto `Commitment` — which ADR-1013's reasoning says costs
  every tick already recorded.
- **A limit on how many commitments a person may keep.** None, and the delta says so.

## Decisions

### The seam

**New: `Roster`, one public type in `DayByDayKit` with three members.** `AGENTS.md` prefers an
existing seam over a new one, and there is no existing one this could widen (§ *Context*): a roster
is a value holding commitments, and neither `Commitment`, which is one commitment, nor `DayView`,
which is an answer about a date, can be that without becoming something else. It is the
commitment-side twin of `History`, which is its own type for exactly the same reason.

```swift
public struct Roster: Hashable, Sendable {
    /// A roster holding no commitments.
    public init()

    /// The commitments this roster holds, in the order they were added.
    public private(set) var commitments: [Commitment]

    /// Adds `commitment` after every commitment already held, and answers `true`. Answers `false`
    /// and changes nothing when this roster already holds it.
    public mutating func add(_ commitment: Commitment) -> Bool
}
```

Thirteen scenarios in the delta observe those three members and roster equality. No process is
spawned and no global stream is captured. Nothing else in the package is touched, and nothing
existing becomes public.

The shell's whole use of it, when #104 gives it one, is `roster.add(commitment)` and
`roster.commitments`, and there is no third thing.

### The order is the order they were taken on

**Chosen: insertion order, kept in an array, and no sorting of any kind.**

*Alternative — sort by the day each commitment is kept from.* This is the reading the phrase "the
order they were taken on" invites, and it is unworkable rather than merely unwanted: the owner's own
day-one week is eight commitments all kept from 2026-08-28, which ties eight ways, and the roster
would then be choosing between them by something it invented. A person who says they have kept the
gym since June and adds it after the plants would also see it jump above them, which is not what
"the order they were taken on" means to the person who did the taking.

*Alternative — sort by name.* Rejected on something already agreed: `CONTEXT.md` § *Day view* says
"any order a day view invented would be a rule about names, which are the owner's words and not the
system's". The same holds one level up. It also collides with the delta's own edge case — "Gym" and
"Gym " sort adjacently and read identically, so a person could not see why there were two.

*Alternative — no order at all, a `Set`.* Rejected: a set gives duplicate-refusal for free and
throws away the one thing #26's intent asked for. It would also make the roster's iteration order
depend on Foundation's per-process hashing, which is the same instability `add-record-store`'s
design had to write `.sortedKeys` to escape.

The cost is that the roster cannot answer "where should a new commitment go" other than "at the
end", and a screen wanting alphabetical order must sort a copy. That is the screen's, and it is
recoverable; an order the roster had thrown away would not be.

### The refusal is reported, not silent

**Chosen: `add` answers whether it took the commitment, and the answer is not marked
`@discardableResult`.**

A caller that does not care writes `_ = roster.add(c)` and the discard is visible in the diff; a
caller that does care has the answer. The reverse does not hold: a silent no-op is indistinguishable
from a successful addition to everything except a count taken before and after, and #104's screen
would have to take that count to know what to say. A report is recoverable from; its absence is not.
This is the same argument `add-day-navigation` settled `nil`-versus-clamp on.

*Alternative — throw.* Rejected: there is exactly one reason, so the error type would carry no
information a `Bool` does not, and Swift's own `Set.insert` reports insertion this way rather than
throwing. It would also make the day-one seeding loop a `try` for something that is not a failure of
the system.

*Alternative — silently do nothing, by analogy with untick.* `CONTEXT.md` § *Untick* says taking
back a tick that was never there "is nothing rather than an error", and the analogy is real enough
to have to be answered. It breaks on what the caller is: an untick is a tap on a row that already
shows its state, so the person can see the outcome, whereas an addition is a form someone filled in
and submitted, and a form that returns having done nothing reads as broken or as having made a
second one. The roster reports; whether a screen says anything is #104's.

*Alternative — `add` returns a new `Roster?`, `nil` on refusal.* Rejected only for consistency:
`History` is the value in this package that is added to, and it is `mutating`. Two shapes for the
same idea, one capability apart, would be the surprise.

### Sameness is the commitment's own, and the roster adds nothing to it

**Chosen: a roster refuses exactly what `Commitment`'s equality calls equal.** That is signed
behaviour from #42, and it makes the refusal boundary a consequence rather than a new rule: "Gym"
on Mon/Wed/Sat kept from January and the same name kept from February are two commitments and both
are held.

The uncomfortable case is deliberate. `"Gym"` and `"Gym "` are different commitments, so a roster
holds both and a list shows two rows a person cannot tell apart. The alternative — trim, fold case,
or compare names loosely — was refused where it belongs: `openspec/specs/commitment/spec.md` says a
name is "stored exactly as it was given" and that "tidying what a person typed belongs where they
typed it, not in the rule that decides what a commitment is". A roster that normalised would be
deciding that two commitments the `commitment` capability calls different are the same, which is a
MODIFIED requirement and a second G4. The delta pins the awkward case with a scenario so that it is
a known consequence rather than a discovery, and the tidying, if it is ever wanted, is the text
field's in #104.

### A roster judges no date

**Chosen: no method on the roster takes a date, and the delta says the roster judges none.**

#26's G1 comment sketched this Story as *"the commitments a person keeps, in the order they were
taken on, answering which of them apply on a given date"*, and the Story issue #26's G2 accepted
drops the date clause: *"hold the commitments a person keeps as one ordered set, in the order they
were taken on, which refuses a commitment it already holds"*. Those were the same owner in two
documents a day apart, scoping this Story differently, so it was not settled here by picking the one
that suited — it was put back to him as this change's question round.

**He answered on 2026-09-03: defer.** The date clause waits for #102, and the roster in this Story
takes no date at all. The reason is what the round recommended on: its whole content today would be
*every commitment this roster holds*, because nothing is retired yet and a commitment's own
kept-from floor already answers whether it was owed before it was taken on (`Commitment.isDue(on:)`,
signed at #42). The requirement would say nothing a reader could not derive, the method's body would
be `return commitments`, and #102 would then have to MODIFY a requirement signed a day earlier
rather than ADD one of its own.

### No ADR

`docs/adr/README.md` asks for hard, expensive to reverse, or surprising. The three candidates:

- *Refusing a duplicate by value equality* — decided before this Story, at #26's G1, and recorded
  there and in `docs/backlog.md` § *Decided*. Not this change's to record.
- *Retiring belongs to the roster rather than to the commitment* — the same G1, and its reasoning is
  ADR-1013's. #102 is the change that acts on it, so if an amendment is owed it is owed there.
- *Insertion order over any computed order* — follows from something already written down
  (`CONTEXT.md` § *Day view*) and is reversible for the price of one requirement and three
  scenarios.

The vocabulary this Story does settle lands in `CONTEXT.md` § *Roster*, which is where the grill is
required to put it.

## Risks / Trade-offs

- **A person cannot yet get a commitment into a roster from the phone.** → True and deliberate. The
  roster is reachable only from a test until #104. This is what "the smallest of the four" costs,
  and #26's G2 serialised the four for exactly this reason. Nothing built here becomes wrong when
  the screen lands.
- **The shell still hands `DayScreen` a hand-written array.** → Unchanged by this Story on purpose.
  Rewiring it is a `day-screen` delta and a second Story (rule 5). Until #104 there are two ways to
  say what a person keeps — the array and the roster — and only one of them is in front of a person.
  Recorded in `proposal.md` § *Impact* so that it is visible rather than discovered.
- **`add` is easy to call and ignore.** → A caller writing `_ = roster.add(c)` throws the refusal
  away, and no type stops it. Mitigated by not marking the result `@discardableResult`, so the
  discard is a character someone wrote and a reviewer can see, and by the delta making the report a
  requirement rather than a convenience.
- **Two commitments named "Gym" can be held, and a list will show two identical-looking rows.** →
  Specified, scenario-pinned, and forced by #42. It is the price of a commitment with no identifier,
  and the alternative costs every tick already recorded (ADR-1013). #104 is where a screen can say
  what distinguishes them, once B-021 lets a rhythm be said in words.
- **This narrows one known gap without closing it, and that gap has moved under it.** →
  `docs/open-questions.md` records that "the shell identifies rows by equality, and two rows may be
  equal": two *equal* rows require two equal commitments, which a roster cannot hold, so once #104
  feeds the day screen from a roster, that source of duplicate rows is gone. The other half — a
  caller handing the same commitment to a `DayView` twice — is not, because `DayView` still takes an
  array. **Read as the shell stands rather than as the gap records it:** #105 (`125da39`, which
  landed on `main` while this change folder was being written) already keys `ContentView`'s
  `ForEach` on the array offset instead of on the row value, so the shell no longer identifies a row
  by equality at all and that entry is stale on its central claim. Correcting the entry is a chore
  and is reported rather than done here. Nothing in this Story is claimed to fix any of it, and
  nothing here makes it worse.
- **The roster is a value that will grow a second thing in #102.** → Retirement has to be held
  somewhere, and it will be held here. That is a widening of this type, not a change to what these
  two requirements say, and the delta was written to leave room: nothing in it says a roster holds
  *only* commitments in the sense of forbidding a retirement day beside one, it says a roster does
  not give a commitment state of its own.
- **Nothing proves a roster is what the app uses.** → `docs/open-questions.md` § *No UI smoke
  layer*, unchanged. Not this Story's to fix; there is no UI here at all.

## Open Questions

**None.** One question in this grill was a preference rather than a fact, so it was put to the owner
as a question round; he answered it on 2026-09-03 and it is recorded as settled below. Every other
question was a fact read out of the shipped sources or measured on this machine, or a decision made
above with its alternatives.

- *Should the roster answer which commitments apply on a given date in this Story, or when
  retirement arrives?* — **settled by the owner on 2026-09-03: defer to #102.** It was his to
  answer because his own two documents disagreed: #26's G1 comment scoped the first Story as
  "answering which of them apply on a given date", and the Story he accepted at G2, #101, drops the
  date clause. The reason for deferring is that the requirement would assert nothing today — with
  nothing yet retired, "which apply on this date" is every commitment the roster holds, and a
  commitment's own kept-from floor already answers whether it was owed before it was taken on — so
  #102 ADDs that requirement against a roster that can retire, rather than MODIFYing one signed a
  day earlier. The delta was written on that answer and needed no change when it came back;
  § *A roster judges no date* carries the reasoning.

- *Is there an existing seam a roster could be a widening of?* — read: nothing in the package holds
  a set of commitments; `DayView` and `DayScreen` both take `[Commitment]` and keep neither. A new
  type it is, and the delta observes all three of its members.
- *What does "a commitment it already holds" mean, given a commitment has no identifier?* — read out
  of `openspec/specs/commitment/spec.md` and `Commitment.swift`: name, schedule and kept-from day,
  all three, and nothing else. The roster consumes that rather than restating it.
- *Does the refusal need `Commitment.schedule` or `keptFrom` to become public?* — no. `Roster` is in
  the same module and compares whole commitments through the synthesised `Hashable`. The known gap
  about a schedule's payload not reading back is untouched.
- *Is the roster a value or a reference?* — a value, matching `History` and for the same reason: it
  is pure logic with no place and no lifetime. The reference type arrives in #103, as `RecordStore`
  did for `History`.
- *Is roster equality order-sensitive?* — yes, and deliberately unlike `History`, which is "the same
  history whatever order they were ticked in". Order is a thing a roster holds and a thing a history
  does not, so equality has to see it. Two scenarios pin both halves.
- *Should a duplicate addition move the existing commitment to the end?* — no. "Refusing leaves the
  roster exactly as it was" is the whole of the refusal, and a scenario pins the position.
- *Should there be a bulk initialiser taking a list of commitments?* — not in this Story. One way in
  keeps the refusal's meaning single: a bulk initialiser would have to drop duplicates silently,
  which is the behaviour § *The refusal is reported, not silent* rejected. #103, which rebuilds a
  roster from what it read, can fold the same `add` and gets the refusal checked for free; if it
  wants one, it can ask for one with its own delta.
- *Should the roster answer whether it holds a given commitment?* — not needed. It is derivable from
  the commitments it reads back, and `add`'s report answers the question a caller actually has.
  Adding a member no scenario observes would be surface for its own sake.
- *Does anything already signed have to change?* — no. Checked requirement by requirement against
  `openspec/specs/commitment/spec.md`: all four are about a single commitment, none constrains what
  may hold one, and nothing about a commitment's identity, name rule, delegation or kept-from floor
  moves. The delta is ADDED throughout, in one capability.
- *Does this Story touch `day-screen`?* — no. `DayView` and `DayScreen` keep taking `[Commitment]`,
  and `src/DayByDay` is not edited. Feeding them a roster is #104's, and doing it here would be a
  second capability's delta.
- *Does a roster need to know about ticks or history?* — no, and it must not. A tick embeds the
  whole commitment (`Tick.swift`), so a history keeps answering for a commitment whatever a roster
  does with it; that independence is what lets #102 retire a commitment without orphaning a tick
  (ADR-1013), and it is why the two are separate values.
- *Is "roster" the right word, and does it clash?* — nothing in `CONTEXT.md`, the four capability
  specs or `DayByDayKit` uses it, the Story and change id already carry it, and it names a set of
  people or things one is responsible for. It goes into `CONTEXT.md` as a new term.
