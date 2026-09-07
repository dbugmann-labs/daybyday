## Context

See `proposal.md` § *Why*, and `grill.md`, whose fifteen settled answers this delta is written on.
What matters here is that a roster's order stops being a fact about history and becomes a decision
of the owner's. Everything else follows: the roster gains a verb rather than a field, the file gains
nothing at all, and the day screen gains one test and no code.

Six facts read off this worktree at `00a8f23`, 2026-09-07, each of which this design turns on. The
grill measured the first four and this document measured the last two.

- **The stored shape needs no new field and no form bump.** `RosterDocument.currentVersion` is 3 and
  order is carried solely by array position in `commitments`; there is no position, index or rank
  field anywhere in `RosterDocument`, `RosterEntryRecord` or `CommitmentRecord`. `RosterDocument(_
  roster:)` writes `roster.entries.map { … }` in sequence and `formRoster()` replays them in file
  order through `Roster.add`, so a reordered `entries` array round-trips as a reordered roster with
  no code change and no version change. A roster written before this change reads back with its
  taken-on order as the person-set order it starts from.
- **The day screen needs no new behaviour.** `day-screen/spec.md:406` already requires *"A day view
  is in the order it was handed its commitments"*, and `:1642` already forbids the day screen
  reordering what the roster answers with. `DayScreen.swift:76`, `:209` and `:217` call
  `roster.commitments(on:)` and consume that order verbatim.
- **`CommitmentsView.swift:62` is already a `List`**, with both lists as `ForEach` children of
  `Section`s — the structure `.onMove(perform:)` attaches to. There is no `.onMove`, `EditButton` or
  `editMode` in the file today.
- **Requirement titles that this change makes wrong are kept, not renamed.** Three say "in the order
  they were taken on" — `commitment/spec.md:382`, `:1249`, and the day screen's scenario title at
  `day-screen/spec.md:1648`. `openspec` 1.10.0 refuses a MODIFIED requirement that drops a scenario
  the current spec has, and renaming a requirement relocates its whole block to the bottom of the
  spec at archive time, permanently. Settled three times already — `add-commitment-kind`,
  `add-rhythm-in-words` and `add-roster-removal` — and the reasoning is in
  `archive/2026-09-07-add-roster-removal/design.md` § *Three scenario titles that are now wrong*.
  § *The stale titles, and why one delta spec is not carried for them* below applies it here.
- **`Array.move(fromOffsets:toOffset:)`'s destination is an offset in the collection as it stands
  *before* the move.** Measured rather than remembered, by running it: on `["A","B","C"]`, `0 → 3`
  gives `["B","C","A"]`, `0 → 2` gives `["B","A","C"]`, `2 → 1` gives `["A","C","B"]`. Settled
  answer 11 rests on this and it holds.
- **The same measurement shows that two destinations are a no-op for any element**: `1 → 1` and
  `1 → 2` both leave `["A","B","C"]` untouched. The grill settled that a no-op move is accepted
  (answer 5) without naming how many offsets produce one; the answer is two, always, and the delta
  says so with a scenario rather than leaving a reader to discover it.

`CONTEXT.md` fixes the vocabulary — the new **move**, and the amendments to **roster**, **roster
store**, **commitments screen** and **app shell** — and the grill landed all of it on this branch
before this folder existed. Writing the delta turned up no sixth term; § *Open Questions* says why.

## Goals / Non-Goals

**Goals:**

- One order, over everything a roster holds, that the person sets and nothing else ever changes.
- A move that a person makes with the gesture an iPhone list already teaches, on the one screen a
  roster is managed from, and that the day screen picks up for free.
- The file untouched: no new field, no new form, no migration, and no phone that has to be told
  anything.
- The seam taking exactly what a drag produces, so that no conversion exists anywhere to be wrong.

**Non-Goals:**

- Moving more than one commitment at once, moving a stopped or a removed one, and moving anything
  from the day screen. None is asked for, and the day screen has no order of its own to set.
- Grouping, sections, or any order the app works out — alphabetical, by rhythm, by day kept from.
  That is B-030, it waits on B-029, and every argument the roster has ever made against inventing an
  order still stands against it.
- An undo, an order history, or a record of when a move happened. A drag back is the undo, and a
  move is dated by nothing.
- Any change to `record`, `History`, `Tick`, `RecordStore`, `RosterDocument`, `DayScreen` or
  `DayView`.

## Decisions

### The seam

**No new seam, no new type and no new file.** Three existing seams gain one member each, and every
scenario in the delta is driven at one of them:

- **`Roster.move(_ commitment: Commitment, toOffset offset: Int) -> Bool`** — the whole of the
  roster's move, and where every scenario under *A roster moves a commitment among the ones it keeps*
  is driven. `Roster.Entry` gains nothing; `entries` is reordered.
- **`RosterStore.move(_ commitment: Commitment, toOffset offset: Int) throws -> Bool`** — the same
  shape as `retire` and `remove`, writing before it reports, and reporting exactly what the roster
  reports, with the one difference § *A store writes what a change made, and a no-op made nothing*
  fixes.
- **`CommitmentsScreen.move(_ commitment: Commitment, toOffset offset: Int) -> Refusal?`** — the
  same shape as `keepAgain`. `RefusedChange` gains a fifth case, `moving(Commitment, Refusal)`.

**The seam takes an insertion point, not a final position**, and this is the one decision the whole
change hangs on. `toOffset` is counted over the commitments the roster is keeping *as they stand
before the move*, which is exactly what SwiftUI's `onMove(perform:)` hands over and exactly what
`Array.move(fromOffsets:toOffset:)` means by its destination — measured above, not remembered. The
alternatives were both weighed at the grill and both lose to the same argument:

- **A final position** — "put it at index 2 afterwards" — differs from an insertion point by one
  whenever a commitment moves down the list, so the shell would carry a `destination > sourceIndex ?
  destination - 1 : destination`. That is a line that can be wrong in a way a test would catch,
  which ADR-1019 forbids the shell from holding.
- **`move(_:above:)`, naming the commitment to go before** — the shell would then have to map an
  insertion point to a commitment, including the past-the-end case where there is no commitment to
  name. Same objection, one case worse.

So the conversion must not exist, and the way to make it not exist is for the kit to speak the
gesture's own arithmetic. The requirement states that arithmetic in words a test can assert — *"put
back immediately before the commitment that stood at that offset among the ones the roster was
keeping, or immediately after the last of them where the offset is the number it is keeping"* — so
the seam is pinned by the spec and not by a comment about SwiftUI.

**The roster's ban on a position survives, and the delta says why.** *A roster holds the commitments
a person keeps* has always forbidden giving a commitment *"a position a commitment can be asked
for"*. It forbids a **read**: nothing asks a roster where a commitment is, and `move` hands a place
**in**. The sequence stays observable only as the order `commitments` and `commitments(on:)` answer
in, which is what it has always been.

### One order over three states, and what it costs

The order runs over every entry a roster holds — kept, stopped and removed alike — because the
roster already holds all three in one sequence, and scoping an order to one state would mean a
roster holding two orders. So a stopped commitment keeps the slot it has and taking it up again
returns it there, which is the answer to the third `## Open` question B-033 was captured with, and
it costs nothing extra: `add` already restores in place.

**Only the moved commitment moves**, which is the same sentence *stop* and *remove* already carry —
*"everything else the roster holds SHALL be exactly as it was, in the order it was in"*. A stopped or
removed commitment lying between the source and the target is **passed, not pushed**: the moved
commitment goes by and it stands still. The delta pins this with a four-commitment scenario in which
a stopped "Gym" starts second and ends first without ever being named.

**The price, taken knowingly and stated in the requirement rather than here alone:** a stopped
commitment taken up again lands where the sequence now puts it, not beside the neighbour it used to
have. Nothing about the roster records who anything used to sit next to, and giving it one would be
an order per state under another name.

**A target offset is counted over the kept commitments only**, so an offset of 0 puts a commitment
before the first one *kept* and not before a stopped one that happens to be earlier in the sequence.
That reads oddly written down and is obviously right on a phone: the kept list is the only list the
drag happens on, so a place counted over all three states would be a number nothing shows. It has
its own scenario, because it is the one place where "the offset is over the kept ones" and "only the
moved one moves" produce a result a reader would not guess.

### A no-op move is accepted, and there are exactly two of them

Settled answer 5 makes a drop that changes nothing an acceptance rather than a refusal. Writing the
delta made the arithmetic concrete: for a commitment at kept index *i*, both offset *i* and offset
*i+1* leave the list untouched, and **they get there for different reasons**. Offset *i* names the
moved commitment itself. Offset *i+1* names the **next** commitment kept — or, where the moved one is
the last kept, is the number kept, which is after the last of them — and a commitment already stands
immediately before the one that follows it. Measured on `Array.move` above; the requirement says it,
and a scenario asserts both.

**Reading *i+1* as naming the moved commitment too is arithmetically false**, and it is false in
exactly the case the `Array.move` measurement cannot show, because a plain array has no stopped
commitments in it: where one lies between the moved commitment and the next one kept, "insert
immediately before the next one kept" taken literally walks the moved commitment past it, and the
roster comes out different from the roster it was. Nothing moves on either no-op offset, so nothing
passes anything.

So the requirement's anchor rule — take the commitment out, put it back before whatever stood at the
offset — is written with both no-op offsets carved out of it, rather than stated flat and then
contradicted a paragraph later. And the case has a scenario of its own, because neither of the other
two can reach it: both leave the moved commitment beside the one that follows it with nothing lying
in between, which is precisely the arrangement in which the flat reading and the true one agree.

**It is not a refusal**, because the roster's refusals are about a move it cannot make at all and
this is one it can make whose result is the roster it already had. **And it does not clear a standing
refused-change notice**, which is settled answer 13 and which the existing spec already covers
without a new sentence: *A call that reaches the place with no change to make SHALL NOT end it*. The
delta adds the naming clause and two scenarios rather than a rule.

### An offset outside the range is refused by the roster and ignored by the screen

The roster refuses an offset below 0 or above the number it is keeping, rather than clamping, because
a clamp puts a commitment somewhere nobody asked for. A drag cannot produce one, but the seam is
public and the way in is not the gesture's alone.

The **screen** answers the same offset differently, and that is deliberate rather than inconsistent.
A commitments screen already has a rule for this shape: asking to stop a commitment it does not
keep, or to remove one neither list holds, *"answers nothing and changes nothing"* and is expressly
**not** a refusal, because nothing was asked for. An offset the kept list does not have is the same
thing — a call about a place that is not there. So the screen never reaches either of the roster's
refusals, and the only refusal a move can carry through the screen is a roster that could not be
written. The delta states that in the screen's requirement so a reader does not go looking for
wording that does not exist. ADR-1028 is the standing record that a screen may refuse what the
engine accepts; this is the same boundary read the other way, and it does not amend that record.

### A store writes what a change made, and a no-op made nothing

`RosterStore.move` reports what `Roster.move` reports — including `true` for a move that changed
nothing — but writes only when the roster actually changed. `Roster` is `Hashable`, so this is one
comparison, and it matters for a reason a person can feel: a drag that lands where it started should
not rewrite the file, and a byte-for-byte scenario pins it at both the store and the screen.

This is the one place the store does *not* mirror the roster exactly, and the requirement says so
rather than leaving it to the reader of a signature. It does not weaken the store's promise — the
promise is that the roster a store reports is never ahead of what is kept at its place, and a write
of identical bytes cannot make it truer.

### Nothing on disk moves, and ADR-1031 is not amended

`RosterDocument.currentVersion` stays 3. A roster's order has always been carried by the order the
commitments are written in, so a move rewrites the same fields in a different sequence at the same
form. There is no new field, no `movesIntroducedInVersion`, no shape-against-form guard to extend,
and no migration.

**ADR-1031 is therefore not amended**, and that is a decision rather than an oversight. Its trigger
since `add-number-record` (#138) reads *"a fourth form, or a form that differs by more than a
field"*, and this change introduces no form at all. If the implementation finds itself reaching for a
version bump, **stop and report it**: that would mean the order was not carried by array position
after all, which is the fact this whole design rests on and which `tasks.md` § 1 measures before a
line is written.

Byte-stability is unaffected: `add-roster-store`'s `design.md` fixed `.sortedKeys` for a keyed
container's keys, on top of the roster's own order, which is never sorted. A move changes the roster's
own order, which is the array, and the array is exactly what is meant to be able to change.

### The stale titles, and why one delta spec is not carried for them

Three titles become wrong here and none of them can be fixed, for the reason `add-roster-removal`
measured on this same tool version: `openspec` 1.10.0 refuses a MODIFIED requirement that omits a
scenario the current spec has, and the only way to drop one is to RENAME the requirement, which
appends its whole block to the bottom of the spec at archive time, permanently, in a file that may
not be hand-edited afterwards (rule 2).

- **`A roster holds the commitments a person keeps, in the order they were taken on`** — the
  requirement is MODIFIED and its prose now opens *"The order SHALL be the person's"*, so the
  correction sits three lines under the wrong title.
- **`A commitments screen lists the commitments its roster keeps, in the order they were taken on`**
  — its prose already says *"in the order the roster answers with"*, which is still exactly right,
  so **the requirement is not carried in this delta at all**. Carrying eight scenarios to fix
  nothing would be cost with no correction at the end of it.
- **`a day screen draws the commitments its roster keeps, in the order they were taken on`**, a
  scenario title at `day-screen/spec.md:1648` — a scenario title cannot be changed either, for the
  same reason: renaming one is dropping one and adding one.

That last point settles `grill.md` § *Left open* 1, whether this change carries a `day-screen` delta
at all. **It does, and not for the title.** The title is unfixable; what earns the delta is one
*scenario*: *a day screen draws its rows in the order its roster was moved into*. The claim that the
day screen inherits the new order for nothing is the load-bearing claim of the whole design, and
`add-roster-removal` § 8 set the precedent for turning exactly that kind of claim into a fact —
*"Both should pass without a line changing in `DayScreen.swift`; that is the claim, and these are the
tests that turn it into a fact."* Five carried scenarios is a small price for it. If that scenario
needs a line changed in `DayScreen.swift`, **stop and report it**: it would mean the day screen was
reordering something after all.

### The shell rides this Story

`CommitmentsView.swift` gets `.onMove` on the kept `ForEach`, under ADR-1019's 2026-09-04
amendment. All three conditions hold and are worth naming rather than assuming: the drag is the
immediate consumer of the move, landing in the same PR; it introduces no behaviour the kit does not
specify, which is precisely what the insertion-point seam buys — the shell converts nothing, decides
nothing and refuses nothing; and `tasks.md` names it as its own section for the reviewer. A move
nobody can reach from a phone does not meet the Story's stated intent.

**The one line a reviewer should look at is `source.first`.** `onMove(perform:)` hands an `IndexSet`
and an `Int`; a single-row drag in a `List` produces an `IndexSet` of exactly one element, and the
shell resolves it to the one commitment and passes the `Int` through untouched. That is a fact about
the gesture rather than a rule about rosters, so it stays in the shell — but it is named here so the
reviewer reads it deliberately rather than skimming it.

The **stopped list gets no `.onMove`**, which is what makes "the move is offered on the kept list
alone" true on a phone rather than only in a requirement.

ADR-1019's own note — *"if a second Story claims the exception, that is the signal that the rule has
quietly changed"* — was read once already on 2026-09-06 in `docs/open-questions.md`, and the
amendment is a standing conditional whose return to the rule is the next shell change that **fails**
one of the three conditions. This one meets all three, so the ADR is not amended again here. The
`CONTEXT.md` § *App shell* entry that still described the pre-amendment rule was corrected at the
grill (settled 15).

### ADR-1037, and why the decision earns one

`grill.md` § *Left open* 2 asked for it and it is written: **ADR-1037, "A roster's order is the
person's"**. All three of `domain-modeling`'s tests are met. It is expensive to reverse — every
roster on a phone would carry an order nothing could then explain. It is surprising — three
`CONTEXT.md` entries and two requirement titles said the opposite until this change, and two of the
titles still do. And it is the result of a real trade-off: a screen-held arrangement was weighed
against the roster's own order and lost, because a day view already draws what it was handed in the
order it was handed it, so the roster's order reaches the day screen for nothing where a screen-held
one would need the day screen to read and apply it too, and could then disagree with it.

**The number is 1037, not 1036.** `docs/adr/README.md` on `main` ends at 1035, but
`origin/story/139-add-number-entry` already holds
`docs/adr/1036-a-notice-names-a-cause-a-person-can-act-on.md`. Checked with `git ls-tree -r
--name-only <branch> -- docs/adr` over every remote branch, 2026-09-07, which is the check
`add-roster-removal` § 10.1 wrote down after `add-rhythm-in-words` had to renumber.

## Risks / Trade-offs

- **A stopped commitment taken up again does not come back beside its old neighbour.** → The known
  price of one order over three states, stated in the requirement rather than only here, and
  settled at the grill (answer 10). The alternative is a roster holding a second order, which is a
  bigger thing than the problem.
- **A drag is discoverable only in edit mode.** iOS puts a reorder handle behind `EditButton`, so a
  person who never taps *Edit* never finds the order they can set. → Accepted for this Story: the
  gesture is the platform's own and the alternative — long-press-to-drag on a plain row — competes
  with the swipe actions `add-roster-removal` just shipped on the same rows. `tasks.md` § 6 makes
  running it on a phone the box, which is what the ADR-1019 exception exists for; if it reads badly
  there, that is a want and not a rewrite of this delta.
- **The delta is large — 141 scenarios in `commitment`, 6 in `day-screen` — and 130 of them are
  carried verbatim.** → Unavoidable: `openspec` replaces a MODIFIED requirement whole, and thirteen
  existing requirements have a sentence that is false once an order can be moved. `tasks.md` § 1
  names how many are already green so the implementer starts from a number rather than a guess, and
  no task touches a carried scenario. The requirement that was *not* carried — *A commitments screen
  lists the commitments its roster keeps* — is named above with the reason.
- **Nine requirements change "the place it was taken on in" to "the place it has".** For every
  roster nobody has moved, those are the same place, so no shipped test changes what it asserts. →
  That is the claim `tasks.md` § 1 measures before anything is written: if a test goes red on a
  prose-only requirement, stop and report it, because it would mean one of those sentences was
  load-bearing in a way this design did not see.
- **A person expects the day screen to have its own order.** → It does not, deliberately: one order,
  set in one place, drawn everywhere. The day-screen scenario is what makes that visible in the spec
  rather than merely true in the code.
- **`add-number-entry` (#139) is open on `main` and holds ADR-1036.** → It touches `record` and
  `day-screen`. Its `day-screen` delta and this one's could collide at rebase; a conflict inside
  `openspec/specs/` or this change folder is a **stop** and the owner's call (rule 5), never a merge
  to resolve. Named here so the reason is on record before it happens.

## Open Questions

**None.** `grill.md` § *Left open* named two, both explicitly `spec-author`'s to settle while writing
the delta rather than the human's, and both are settled above:

1. **Whether the change carries a `day-screen` delta spec at all** — it does, settled in § *The stale
   titles, and why one delta spec is not carried for them*. Not for the stale scenario title, which
   is unfixable at this tool version, but for one added scenario that turns "the day screen inherits
   the order for nothing" from a claim into a fact. `add-roster-removal` § 8 is the precedent.
2. **An ADR for settled answer 1** — written as **ADR-1037**, numbered against every remote branch
   rather than against `main` alone, in § *ADR-1037, and why the decision earns one*.

Neither is a preference. Both are judgements about how a delta is written and where a decision is
recorded, which is this document's work.

**No residual round.** Writing the delta raised no question whose answer would change it and which is
a preference rather than a fact. Three things came close enough to be named here so a reviewer can
disagree with each in one place:

- **How many offsets are a no-op** (§ *A no-op move is accepted*). It looked like a decision for
  about a minute. It is arithmetic — exactly two, always — and it was measured rather than argued.
- **Whether an out-of-range offset is a refusal at the screen** (§ *An offset outside the range*).
  Not a preference: the screen already has a rule for a call that asks for no change at all, and an
  offset that is not there is one. Answering it as a refusal would need a refusal case meaning "that
  place does not exist", which no person could act on.
- **Whether the store should write on a no-op move** (§ *A store writes what a change made*). One
  comparison against a `Hashable` value, and the alternative rewrites a file on a gesture that
  changed nothing. There is one answer and no trade.

Writing the delta also turned up **no new domain term.** Everything it needed — the new **move** and
the amended **roster**, **roster store**, **commitments screen** and **app shell** — the grill had
already landed in `CONTEXT.md`. The one candidate, "offset", is the seam's parameter and the
gesture's own arithmetic rather than a thing the product has elsewhere; it is defined where it is
used, in the requirement, and `CONTEXT.md` is left as the grill left it.
