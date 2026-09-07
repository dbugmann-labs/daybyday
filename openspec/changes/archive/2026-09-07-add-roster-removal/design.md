## Context

See `proposal.md` § *Why*, and `grill.md`, whose eight settled answers this delta is written on.
What matters here is that removal is **not** a delete. The owner settled that in one line — *"Past
days should not lose their rows"* — and everything below follows from it: the roster gains a state
rather than losing an entry, the file gains a field rather than losing a record, and the `record`
capability is not touched at all.

Five facts read off the code as it stands, each of which this design turns on:

- **`Roster.Entry` is a commitment and an optional kept-until day**, and `Roster` publishes `add`,
  `retire(_:keptUntil:)` and `commitments(on:)`. There is no removal and no third state. `entries`
  is internal, which is why `CommitmentsScreen` can compute its stopped list from it without the
  roster publishing one.
- **`RosterDocument.currentVersion` is 2**, and `RosterStore.init` accepts the closed range
  `1...RosterDocument.currentVersion`, refusing anything above as `.laterForm` and anything below as
  `.notAStore`. A third state is a third form. `RecordDocument` reached **its** third form on
  2026-09-06 at `add-number-record` (#138), with a second constant
  `numbersIntroducedInVersion` and a presence-against-version guard in `RecordStore.init`; that
  shape landed on `main` while this delta was being written and § *The form on disk* copies it.
- **`DayScreen` writes day one on `store.roster == Roster()`.** Decision 1 keeps that correct
  without a marker: a roster that has ever taken something on never again equals a roster that has
  been given nothing.
- **`CommitmentsScreen` holds one `awaitingConfirmation: Commitment?` and one
  `refusedChange: RefusedChange?`**, with `askToStopKeeping`, `cancelStopKeeping`,
  `confirmStopKeeping`, `keepAgain` and `define`. `confirmStopKeeping` retires as of
  `dayToKeepFrom`, which is the day the screen was handed.
- **`CalendarDate.adding(days:)` is internal and returns `CalendarDate?`**, `nil` outside 1583–9999.
  So "the day before" is a value that can fail, exactly once, at 1 January 1583.

`CONTEXT.md` fixes the vocabulary — **removed**, and the amendments to **kept until**, **roster**,
**roster store** and **commitments screen** — and the grill landed all of it on this branch before
this folder existed. Writing the delta turned up no sixth term; § *Open Questions* says why.

## Goals / Non-Goals

**Goals:**

- One removal, reachable from either list, that a person cannot make by accident and cannot make by
  half. The typed name is the whole of the guard.
- Every past day untouched, and provably so: the roster's date answer treats a removed commitment
  exactly as a stopped one, and the day-screen delta pins that end to end with a tick still drawn.
- Day one stays unreachable on a phone that has been in use, without a "has ever held something"
  flag being invented for it.
- A phone that upgrades reads its own roster, changes nothing on opening, and moves the file forward
  the first time something is kept.

**Non-Goals:**

- Deleting anything. No commitment leaves a roster, no tick leaves a record, and no file is ever
  shortened by this change.
- A list of removed commitments, an undo, or any second way back. Defining the identical commitment
  again is the way back, and it is the roster's existing rule rather than a new one.
- Telling a person *why* the typed name does not match. There is nothing to refuse; § *A name that
  does not match is not a refusal* says why at length.
- Removing more than one commitment at a time, and removing from the day screen. Neither is asked
  for, and the day screen has no list to remove from.
- Any change to `record`, `History`, `Tick` or `RecordStore`.

## Decisions

### The seam

**No new seam and no new type.** Three existing seams gain members, and every scenario in the delta
is driven at one of them:

- **`Roster.remove(_ commitment: Commitment, keptUntil date: CalendarDate) -> Bool`** — the whole of
  the roster's removal, and where every scenario under *A roster removes a commitment it holds* is
  driven. `Roster.Entry` gains a third stored part, `isRemoved: Bool`, beside the commitment and the
  optional kept-until day. It stays internal, as `entries` already is.
- **`RosterStore.remove(_ commitment: Commitment, keptUntil date: CalendarDate) throws -> Bool`** —
  the same shape as `retire`, writing before it reports, and reporting exactly what the roster
  reports.
- **`CommitmentsScreen`** — `askToRemove(_:)`, `cancelRemoving()`, `confirmRemoving() -> Refusal?`,
  and the two properties § *The screen holds what has been typed* fixes.

**One method rather than two, and the date is not always used.** `remove` takes a date because the
common case — a kept commitment — needs one, and the roster is not allowed to ask what day it is. A
commitment the roster has already stopped keeping has a kept-until day, and that day stands: the
date handed in is ignored there, which is stated in the requirement rather than left to a reader of
the signature. Two methods (`remove(_:keptUntil:)` and `remove(_:)`) were rejected because the
caller would then have to know which state the commitment is in before it can pick one, and the one
caller — a screen with two lists — would be re-deriving what the roster already knows.

**`Roster` publishes no list of removed commitments.** Nothing needs one: the screen's two lists are
what it keeps and what it has stopped, and a removed commitment is in neither. Publishing a third
list would be a surface with no reader and a second way to reach a state whose whole point is that a
person is no longer offered it.

### Removed is a third state on the entry, not a fourth part on the commitment

The entry gains a `Bool`; `Commitment` gains nothing. This is ADR-1023's argument applied a second
time and it is worth restating in one line, because the symmetric shape will be proposed again:
`Tick` embeds the whole `Commitment` by value and `History` answers by set membership, so a fourth
part on `Commitment` would change the identity of every commitment the moment it was removed and
orphan every tick already recorded against it. That is the exact failure a removal must not cause,
and it is the reason this change touches `record` not at all.

**Removed always carries a kept-until day**, so the state space is three and not four: kept (no
day, not removed), stopped (day, not removed), removed (day, removed). "Removed with no day" is not
a state a roster has ever been in, which is why a document claiming it is refused as content that
could not be a roster rather than read charitably.

### The form on disk, and the shape each form has

`RosterDocument.currentVersion` goes to 3 and `RosterEntryRecord` gains one field, `removed`. The
version guard stays the closed range `1...currentVersion`, so the store reads all three forms and
refuses everything else exactly as before.

**The field is present exactly at the form that introduced it, and its presence is checked against
the declared version in both directions.** A document declaring form 1 or form 2 that carries
`removed` is refused as content that is not a roster store, and so is one declaring form 3 that does
not. This is not a choice made here: ADR-1031 was amended on 2026-09-06 at `add-number-record`
(#138), a day before this Story, and it now says in as many words that each form is read as the
shape that form has, rejecting the cheap alternative — an optional field meaning *not removed when
absent* — because it makes the declared form decorative and launders a file this app never wrote
into a current-form one on the next change kept there.

So this design copies `RecordDocument`/`RecordStore` field for field, deliberately and visibly:

- `RosterDocument.removalIntroducedInVersion = 3`, a **second** constant beside `currentVersion`,
  for the reason the record's own comment gives — a fourth form raising `currentVersion` alone must
  not silently move which forms are expected to carry `removed`.
- One guard in `RosterStore.init(at:)`, after the document decodes and before `formRoster()`:
  every entry's `removed` is present exactly when `document.version >= removalIntroducedInVersion`.
- `removed` is a `Bool` at form 3 — written on every entry, `false` on most — rather than a flag
  present only where it is `true`. Presence then means "this form" rather than "this commitment",
  which is what makes the guard above a check about the *form* and not about the data.

**ADR-1031 is not amended by this change**, and that is a decision rather than an oversight. Its
trigger, as it now stands, is *"a fourth form, or a form that differs by more than a field"*. The
roster's form 3 differs from its form 2 by one field, read under one comparison against a version
already in hand, which is the case the record's amendment was written to cover. Nothing here is new
to it. The two files still move independently — a phone can sit with a form-3 record and a form-2
roster indefinitely — which is that record's own consequence, now true of three forms on one side
and three on the other.

`design.md` for `add-roster-store` fixed the byte-stable encoding (`.sortedKeys`, the roster's own
order never sorted), and nothing here moves it.

### Two confirmation slots, and one change awaiting confirmation at a time

A removal awaiting confirmation gets **its own slot**, separate from the stop's. Sharing one would
mean a discriminator inside a value the spec already pins by name — *"it says 'Gym' is awaiting
confirmation"* — and every existing scenario about `awaitingConfirmation` would have to be reworded
to say which kind. Two slots keeps thirteen shipped scenarios byte-for-byte.

Two slots would also permit a state the shell cannot draw: an alert and a removal sheet up at once.
So the requirement closes it by rule rather than by luck — **asking for either leaves the other
empty** — which is one line in each ask and two scenarios, and which generalises the sentence the
stop requirement has always carried (*"only one stop can be awaiting confirmation at a time"*) to
the screen as a whole.

### The screen holds what has been typed

`CommitmentsScreen` gains `nameTypedBack: String` and `nameTypedBackMatches: Bool`, and the shell
holds neither. The alternative — the shell keeps the text in `@State` and asks
`matches(_ typed: String)` — is smaller at the seam and wrong for the reason the *refused change*
requirement already gives about a message's lifetime: *"A screen that only answered would leave how
long a person is told for to whatever drew it, and that lifetime would then be decided in a layer
nothing regresses."* What has been typed has a lifetime too. It is cleared when a removal is asked
for, when a second one is asked for, when either is cancelled or confirmed, and when the app is
shown again — five moments, each with a scenario, none of which a test can reach if the string lives
in SwiftUI. `nameTypedBack` is settable so the shell can bind to it; everything derived from it is
`private(set)` or computed.

**Nothing here is words a person reads.** `nameTypedBackMatches` is a fact about two strings; that
it makes a button pressable, and what that button says, is the shell's, exactly as ADR-1022 and the
`RosterState` cases already have it.

### Blank space is trimmed from both sides of the comparison

The grill settled that a typed name matches "exactly after surrounding whitespace is trimmed". It
did not say whose whitespace, and writing the delta made the answer forced rather than optional: a
roster holds a name exactly as it was given, and `"Gym "` is a commitment a person can define. Trim
only the typed name and `"Gym "` can never be matched by anything — typing `"Gym "` trims to
`"Gym"`, which is a different string — so a commitment nobody could ever remove would exist. Trimming
both sides costs nothing, cannot make a wrong commitment go (the removal is asked about one
commitment, never picked out by what is typed), and is pinned by its own scenario. Case and inner
spacing still matter, which is what makes this a confirmation rather than a formality.

### The day before, and the one date that has no day before it

Settled answer 3, reaffirmed after its cost was stated: a stop and a removal made through the
commitments screen keep the commitment until the day **before** the one the screen was handed. The
price is in the requirement in as many words — a tick made this morning on a commitment stopped this
afternoon is not drawn today, and the record of it stands — because a person who reads the
requirement should meet the price, not discover it.

`CalendarDate.adding(days: -1)` is `nil` on 1 January 1583 and nowhere else in the supported range.
**The screen uses the day it was handed there**, rather than refusing: a person asked for a stop,
the calendar's floor is not something they can act on, and a refusal with no remedy is the one thing
the refused-change vocabulary is not for. It has a scenario at each of the two seams that can reach
it, and no device will ever present that day.

### Kept on no day at all is the commitment's floor, not the roster's answer

The scenario *a commitment defined and stopped on one day through a commitments screen is kept on no
day at all* asked, as first written, for the roster store to answer with nothing on Sunday 30 August
2026. It cannot, and the rule it would need bent is one this change does not touch: a roster answers
with a stopped commitment **on its kept-until day**, and MUST NOT apply the commitment's own day it
is kept from. Sunday is the kept-until day, so the answer has "Gym" in it.

The clause was rewritten rather than the rule, because the rule is right and the clause was asserting
the intent at the wrong seam. "Kept on no day at all" is a fact about the commitment, not about the
roster's answer: the roster answers with it on Sunday, the commitment's kept-from floor is the Monday
after, and asking that commitment whether it is due on Sunday gets no. A day drawn from the answer
asks each commitment exactly that, so no date ever shows the row. Stating the floor a second time in
the roster would be the two-places-to-be-wrong the requirement names in as many words.

The scenario keeps its title, which is still true of the commitment, and now asserts both halves:
what the roster answers with, and that what it answers with is not due there. Nothing else in the
delta moves — in particular *a commitment removed as of the first supported date and one as of the
last are both accepted*, which is green and depends on the rule as it stands.

### Three scenario titles that are now wrong

Three scenarios keep their titles and change what they assert, and one keeps a title this change
makes false outright. They are kept because `openspec` 1.10.0 will not let them go. Measured on this
folder, 2026-09-07, by deleting the block and re-running:

```
$ openspec validate add-roster-removal --strict
✗ [ERROR] commitment/spec.md: MODIFIED "A commitments screen asks you to confirm before it stops
  keeping a commitment" omits scenario(s) the current spec still has: "a commitment stopped through
  a commitments screen is kept until the day the screen was handed". Copy them into the MODIFIED
  block (a MODIFIED requirement replaces the whole block, so archive refuses to drop them).
```

The only way to drop one is to RENAME the requirement, which `add-commitment-kind` (#137) measured
on this same tool version: recomposition looks each original block up under its **old** name, so a
renamed requirement is appended to the bottom of the spec at archive time, permanently, and
`openspec/specs/` may not be hand-edited afterwards (rule 2). A stale title is a blemish; a
requirement block relocated to the end of a 2,000-line spec is a permanent one.

- **`a commitment stopped through a commitments screen is kept until the day the screen was handed`**
  — false from the day this ships. It now asserts the day before, and asserts explicitly that the
  day the screen was handed answers with nothing. The requirement's prose says the title is wrong
  and why, so the archived spec carries the correction beside the defect, and two scenarios with
  accurate titles — the same-day case and the calendar floor — say the true thing next to it.
- **`a commitments screen shown again on a later day stops a commitment as of that later day`** —
  still true as written (the stop *is* made as of that later day) but easy to misread; its
  assertions now name the day before, and say so in the clause.
- **`two commitments alike in name and not in rhythm are two entries a person cannot tell apart`** —
  already stale, inherited from `add-rhythm-in-words` (#144), carried again unchanged. Its own note
  in the requirement's prose is carried with it.

**No existing test is renamed by this change.** Assertions inside exactly two of them move —
`CommitmentsScreenTests.swift` lines 699–700 and 1099, measured 2026-09-07, and no other test in the
package asserts on a date a screen hands a stop — and the `@Test("...")` display names do not, because
CI check 4 matches on those names and a rename would read as a scenario losing its test.

### The shell rides this Story

`CommitmentsView.swift` gets swipe actions on both lists and a removal sheet, under ADR-1019's
2026-09-04 amendment. All three of its conditions hold and are worth naming rather than assuming:
the shell change is the immediate consumer of the Story in the same PR; it introduces no behaviour
the kit does not specify — every refusal, every day, every match is behind the seam with a scenario;
and `tasks.md` § 8 names it as its own section for the reviewer.

**The row's tap goes away, and that is a change to shipped behaviour** rather than an addition.
Settled answer 8, against the recommendation of two icons: a kept row swipes to stop or remove, a
stopped row to resume or remove, and tapping a row does nothing. A third action on a row that had
one tap forced the question, and the owner answered it for all three at once rather than leaving one
affordance for stopping and another for removing.

The ADR's own note — *"if a second Story claims the exception, that is the signal that the rule has
quietly changed and this record should be revisited"* — has already been read once, on 2026-09-06,
in `docs/open-questions.md`: the amendment is a standing conditional and the return to the rule is
the next shell change that **fails** one of the three conditions. This one meets all three, so
nothing is stretched and the ADR is not amended again here.

## Risks / Trade-offs

- **A removal that people expect to delete their data does not.** A person who removes a commitment
  to make the app forget something will find every past day still drawing it. → Deliberate, settled
  by the owner in the words the proposal quotes, and recorded as ADR-1035 precisely because it will
  surprise a reader who expects "for good" to mean gone. The commitments screen is the surface where
  "gone" is true, and it is the only surface a person manages a roster from.
- **The stop's day moving breaks a habit and can lose a tick from view.** A commitment ticked this
  morning and stopped this afternoon leaves today's day screen. → Stated in the requirement, priced
  at the grill, reaffirmed after the price was stated, and reversible in one line if the owner
  changes their mind. The tick itself is never touched, which is what makes it reversible.
- **A person mistypes the name, sees nothing happen, and does not know why the button is dead.** →
  The owner's own answer, quoted in `grill.md`: *"the button to confirm the removal is not clickable
  until it is correct. this is enough for the user to know."* The alternative — a message under the
  field — would be the screen refusing something nobody asked for, and would need a refusal case
  that means "you are still typing".
- **Two commitments alike in name and rhythm: a person removes the wrong one.** → The removal is
  asked about a commitment, never resolved from what is typed, and there is a scenario on exactly
  that pair. What the typed name guards is intent, not identity.
- **The third form is written by a build that a person then downgrades.** → ADR-1031's consequence,
  unchanged: the older build refuses the file, leaves it alone, and a forward build recovers it.
  Nothing is lost and there is no downgrade path, which is the decision rather than the gap.
- **`add-number-record` (#151) merged to `main` while this delta was being written**, taking the
  record store to its own third form and amending ADR-1031 on the way. → It touched
  `openspec/specs/record/spec.md` and neither of the two capabilities this delta modifies, so every
  MODIFIED block here is still exact against the current spec; the rebase conflicted only in
  `docs/adr/`, and the resolution took `main`'s ADR-1031 whole and rewrote § *The form on disk*
  against it. Reported rather than absorbed, because it is why this design copies a shape that did
  not exist when the grill ran.
- **Removing everything and being handed day one.** The failure mode this change could most easily
  have shipped. → Closed by construction rather than by a flag, and pinned by its own day-screen
  scenario: a roster that has removed every commitment is not equal to a roster given none.
- **The delta is large — 149 scenarios in `commitment`, 12 in `day-screen` — and most of them are
  carried verbatim.** → Unavoidable: `openspec` replaces a MODIFIED requirement whole, and
  seventeen existing requirements — fifteen in `commitment`, two in `day-screen` — have a sentence
  that changes. `tasks.md` § 1 names how many scenarios are already green so that the implementer
  starts from a number rather than a guess, and no task touches a carried scenario except the two
  whose assertions § *Three scenario titles that are now wrong* names.

## Migration Plan

**One file form, forward only, and no step a person takes.** A phone running the build before this
one holds a form-2 roster; the build after this one reads it, treats every commitment in it as one
that has not been removed, and writes nothing until a change is kept there. The first commitment
taken on, stopped, taken up again or removed rewrites the whole document at form 3. This is exactly
what `add-commitment-kind` (#137) did at form 2 and what ADR-1031 fixed as the shape.

The record file does not move and is not read by this change.

## Open Questions

**None.** `grill.md` § *Left open* is "None." — twelve questions over four rounds on 2026-09-07, two
answered against the recommendation and one reaffirmed after its cost was stated — and both things
it left to this document are settled above: the first supported date's missing day before, in
§ *The day before*, and whether one confirmation slot serves both a stop and a removal, in § *Two
confirmation slots*. Neither is a preference; both are design decisions about where a value hangs
and what a screen may be in the middle of.

Writing the delta raised **no residual round**, and three things came close enough to be named here
so that a reviewer can disagree with each in one place:

- **Whose blank space is trimmed** (§ *Blank space is trimmed from both sides*). It looked like a
  preference for about a minute. It is not: trimming only the typed name creates a commitment that
  can never be removed, which contradicts the requirement it would be part of, so there is one
  answer and no trade.
- **Whether the roster's third form owes ADR-1031 an amendment** (§ *The form on disk*). It does
  not, on that record as it stands since `add-number-record` (#138) amended it on 2026-09-06 — one
  field, one comparison, under a trigger that now names a fourth form. This delta was drafted
  against the record as it read the day before and rewritten against the one that landed; a reviewer
  who remembers the earlier wording should read the current file.
- **Whether `Roster` should publish its removed commitments** (§ *The seam*). No reader, and
  publishing one would undo the only thing removal does on a screen.

Writing the delta also turned up **no new domain term**. Everything it needed — *removed*, the
amended *kept until*, *roster*, *roster store* and *commitments screen* — the grill had already
landed in `CONTEXT.md`, and the one candidate, "the name typed back", is a mechanism inside the
commitments screen's own entry rather than a thing the product has elsewhere. It is defined where it
is used, in the requirement, and `CONTEXT.md` is left as the grill left it.
