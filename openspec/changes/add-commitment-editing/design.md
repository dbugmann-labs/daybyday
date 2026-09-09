# design — add-commitment-editing

## Context

`grill.md` settled twenty-four questions over six rounds and left nothing open. This file records
what writing the delta on those answers turned up: the facts each answer had to be checked against,
the two places the settled wording did not survive contact with the code, and the one question that
was invisible until a requirement had to be phrased.

Three facts the whole design rests on, each measured in this worktree rather than remembered:

**A record embeds the whole commitment by value.** `Tick`, `Number`, `Note` and `Addition` each carry
a `Commitment`, and `History` keys them by it — `RecordedDay(commitment:date:)` and
`Set<Tick>`. `Commitment` is `Hashable` over all four of its parts. So a commitment that changed in
any part would orphan every record already made against it, which is ADR-1023's argument and is still
true; the way through is not a mutable part but a **second commitment** that either the record follows
(a rename, a corrected kept-from day) or the roster keeps beside the first (a rhythm change).

**An interval rhythm's start date is not the commitment's kept-from day, in the model.**
`Schedule.everyNDays(DayInterval, from: CalendarDate)` carries its own start date, and
`Commitment.isDue(on:)` applies `keptFrom` as a separate floor on top of it. They agree only because
`Rhythm.schedule(keptFrom:)` builds one from the other, and the shipped spec says so in as many words:
*"The two remain distinct in the model and may disagree where something other than this screen forms
the commitment; this screen offers one date and uses it for both."* This is the fact § *Questions for
you* 1 turns on, and it is why that question exists at all.

**Neither store's form number moves.** The roster file is at form 4 (`RosterDocument.currentVersion`)
and already carries `removed` — since form 3, `removalIntroducedInVersion` — which is the only key
superseding needs. The record file is at form 5 (`RecordDocument.currentVersion`) and a carry-over
writes different `CommitmentRecord` values into fields that already exist. `grill.md` § *Left open*
owed this as a fact for `design.md` rather than a decision; measured, the answer is no, for both.

## Goals / Non-Goals

**Goals**

- A person can change the name, the rhythm and the day kept from of a commitment they keep, and the
  name of one they have stopped, without losing what has been recorded against it.
- A rhythm change never alters a past day's answer; a rename and a kept-from correction always do,
  and that asymmetry is stated where a reader meets it rather than left to be discovered.
- The commitment stays four parts with no identity of its own, so ADR-1023's argument is met head-on.
- One form defines and changes (B-037), and it says nothing about a rhythm nobody has committed to
  (B-036).

**Non-Goals**

- **A commitment's history across a rhythm change.** The roster holds no link between a superseded
  commitment and the one that replaced it, and once records exist against both values the link cannot
  be reconstructed. Nothing reads one today; a screen that wanted one would be a Story of its own and
  would have to decide first whether the link is worth keeping from now on.
- **Changing the kind its days take.** There is no such change and there is deliberately none —
  ADR-1030, unamended on exactly this point.
- **A dedicated edit screen.** One sheet, shared. A second form drifts from the first.
- **Undoing a change.** A supersession can be walked back by defining the old commitment again
  exactly, which the roster already takes as taking it up again; a rename can be walked back by
  renaming again. Neither is an *undo* and neither is promised as one.

## Decisions

### The seam

**`CommitmentsScreen`, `Roster`, `RosterStore`, `History`, `RecordStore` and `DayScreen` — all six
already exist, and this change adds no seam.** Every acceptance test attaches at one of them, in
`src/DayByDayKit`, driven directly and without spawning a process. The members added:

| Seam | Added |
|---|---|
| `Roster` | `change(_:to:under:) -> Bool`, `supersede(_:with:keptUntil:under:) -> Bool` |
| `RosterStore` | `change(_:to:under:) throws -> Bool`, `supersede(_:with:keptUntil:under:) throws -> Bool` |
| `History` | `carryOver(_:to:) -> Bool` |
| `RecordStore` | `carryOver(_:to:) throws -> Bool` |
| `CommitmentsScreen` | `change(_:toName:on:keptFrom:under:) -> Refusal?`, `whatItIsMadeOf(_:) -> Change?` |
| `DayScreen` | nothing; `returnedTo()` changes what it does |

`CommitmentsScreen.init` gains `keepingRecordAt place: URL = DayScreen.recordPlace`, defaulted, so
every existing call site and every carried test compiles unchanged. **A carried test that has to be
edited at all is a sign the design was not followed: stop and report it.**

`CommitmentsScreen.Change` is the value the sheet fills itself from — the name, the rhythm, the day
kept from, the category, and whether the rhythm and the day kept from can be changed. It is a value
and not a form: it holds nothing a person typed and nothing a person reads.

### Two acts, not one, and which fields choose between them

A person says "change this commitment" and means one of two things the model cannot merge:

- **The value must follow the records** — a name, a day kept from. Nothing about dueness depends on a
  name, and a kept-from day is a claim about a person's own history rather than a rule about the days
  ahead, so correcting either is correcting the whole of what has been kept. The records are carried
  over to the new value and the roster's entry is replaced in place.
- **The records must stay where they are** — a rhythm. The new rhythm decides today onward and every
  day already lived answers exactly as it did (ADR-1013). The roster supersedes.

Asked for both at once, the carry-over runs first and the supersession second. It is the only order
that satisfies both: the superseded value then carries the new name and the corrected kept-from day,
so every past day redraws under the name the person now uses, while the commitment taken on starts
today. **The day the person typed into the kept-from field therefore reaches the past and not the
commitment that starts today**, which is a real oddity — reopen the sheet afterwards and it offers
today. It is stated in the requirement rather than hidden, and the alternative, refusing the
combination, buys clarity by removing a capability for no principle.

### Two files, one act, and the order that makes a retry work

A rename touches two files that nothing writes together: `record.json` and `roster.json`. There is no
transaction and there will not be one. So one of them is written first and the other can fail, and the
question is only which failure a person can get out of.

**Records first, then the roster.** If the record place refuses, nothing has happened anywhere and the
change is refused. If the record place takes it and the roster place then refuses, the records are
under the new value and the roster still holds the old — a past day draws the old name and reads as
not kept — and **asking for exactly the same change again repairs it**: the second carry-over finds no
record under the old value, does nothing and does not refuse, and the roster write then succeeds.

The other order cannot be repaired that way. With the roster written first, the old commitment is no
longer what the roster holds, so the same ask names a commitment that is not there and the screen
answers that it has nothing to change; the records are stranded with no ask that reaches them. The
window is small either way and the difference is whether it has an exit.

### Superseding puts the new commitment in the old one's place, and the old one right behind it

Two entries cannot share an index. The commitment taking over gets the place, and the superseded one
sits immediately behind it. A person changing a rhythm has not asked for a row to move, and appending
would send it to the bottom of an order #181 let them set deliberately.

The superseded entry is drawn in neither of the screen's lists, so the only place the two are read
together is a date's answer, where they are adjacent and at most one of them is ever due — the old one
past its kept-until day is out, and the new one is not due before today. Being adjacent also keeps
`Roster.groups(on:)` honest: a group sits where its first commitment sits (ADR-1038), and two adjacent
entries under one category cannot move a heading.

### Removed now covers something nobody did

A superseded commitment goes into the **removed** state. That reuses the state rather than minting a
fourth, and everything the state means is exactly what supersession needs: it keeps its place, it
keeps a kept-until day, every past day draws it, every record against it stands, and it shows in
neither list. What is widened is the word — "removed" now covers an act the person did not perform.
The cost, taken knowingly at the grill: an app shell that said anything about *removal* when someone
changes a rhythm would be lying, so it says nothing. `CONTEXT.md` § *Removed* carries the amendment.

The way back is unchanged and is the shipped one: define the old commitment again exactly and the
roster takes it up again, in its old place, with its records. Going back to your old rhythm genuinely
is going back to it.

### A rename reaches the whole history of the commitment it was asked about, and no further

Rename after a supersession and the superseded value keeps the old name, because the roster holds no
link between the two and there is nothing to follow. So a past day drawn from the superseded value
says the old name for ever. This is the priced consequence of *no link* rather than a second decision,
and it is the reason § *Both in one save* orders the rename first: a name and a rhythm changed
together do reach both, because the rename happens while there is still one value.

### The two new refusals, and why neither is folded into an existing one

- **A change a stopped commitment does not take.** A stopped commitment can only be renamed: its
  rhythm and its kept-from day decide dueness and it has no days left to decide. The act a person
  takes is *take it up again first*, which is different from every other refusal's, so ADR-1036 says
  tell it apart.
- **A day already recorded on that the change would leave not due.** Moving a kept-from day forward
  over a day someone recorded against would either orphan that record or drop it, and this system does
  neither. The act is *pick an earlier day*.

Everything else reuses what the define form already says. A **place that could not be written** now
covers the record place as well as the roster place, because a person can do nothing about either but
try again later, which is the test that requirement has always applied.

### A change into a commitment the roster already holds is refused in all three states

Defining a stopped or removed commitment takes it up again; changing another commitment *into* it
would put two histories under one value with nothing to say they were ever apart. So the change is
strictly stricter than the definition, and the roster enforces it rather than the screen, because the
roster is the only thing that knows all three states.

### B-037 carries no requirement, and that is a decision

Where a form is reached from, whether it is a sheet or a pushed screen, and which of its fields a
thumb can enter are the drawing's — the same line #181 drew when it let the shell choose `Move up` and
`Move down` over a drag. What the delta owes the sheet is two things it cannot work out for itself:
**what a commitment is made of**, so it can fill its fields from the commitment rather than from a new
one, and **whether that commitment's rhythm and kept-from day can be changed at all**, which is a fact
about a stopped commitment and not a fact about a form. Both are in the delta. Nothing else about the
sheet is.

### B-036 is a REMOVED requirement, and this repository has never written one

`## REMOVED Requirements` takes requirement names and no bodies, and `openspec` 1.10.0 drops the named
block from the recomposed spec at archive time —
`dist/core/specs-apply.js`, verified by reading it in this worktree, not assumed. No archived change
here has ever used the section, so the first one is worth naming: a near-miss header aborts the
archive, and a header that is simply absent from the baseline warns and continues. The header in this
delta was copied out of the current spec rather than retyped.

### Why no new ADR

**ADR-1030 named this Story as its own revisit trigger** and named the two files to amend: *"if a
commitment ever gains an identity of its own … both this ADR and ADR-1023 are amended in place rather
than superseded (ADR-1020)."* The condition it anticipated did not happen — a commitment gained no
identity — but the trigger event did, and what the two records say about *changing* a commitment is
now wrong in both: ADR-1023's *Alternatives considered* treats "changing a part" as necessarily
orphaning records, and ADR-1030's *Consequences* says that the day someone wants B-014 "the answer is
a new commitment, which starts a new history". Both are amended in place, stamped, and left reading as
one coherent decision. ADR-1038's ruling on which of the two governs a new part is cited and not
reopened, because nothing here adds a part.

A new record would put the decision in a third file that neither of the two existing cross-references
resolves to, which is exactly the failure ADR-1020 was written to end.

### Neither form number moves

Measured, not assumed. `RosterDocument.currentVersion` is 4 and `removalIntroducedInVersion` is 3, so
holding a superseded commitment removed uses a key that has been on disk since the roster's third
form. `RecordDocument.currentVersion` is 5, and a carry-over writes `CommitmentRecord` values into
`ticks`, `numbers`, `notes` and `additions` — every one of them already there. **No box in `tasks.md`
touches `RosterDocument`, `RecordDocument` or `CommitmentCoding`, and a box that finds it needs to is
this section being wrong rather than a file to edit.**

## Risks / Trade-offs

- **This is the largest delta the repository has carried: 185 scenarios, 58 of them new.** The owner
  reaffirmed one Story at the grill after the size was raised, so it is not reopened here. The
  practical risk is a long red-green run in which the ordering rules — carry-over before roster,
  rename before supersession — are easy to satisfy per-test and easy to lose overall; `tasks.md`
  sequences the screen's own cycles last, after both stores are green, for that reason.
- **The half-written window between the two files is real and is not closed**, only made repairable.
  A person who hits it and does not retry sees a past day drawing a commitment with no record. The
  alternative is a transaction across two files, which is a much larger change to two signed
  capabilities for a window measured in milliseconds.
- **A day screen returned to now re-reads its record**, which costs a file read on every return to the
  day screen. It is one small JSON file that the same screen already re-reads whenever the app is
  shown. If it ever shows on the phone, that is a shell-level fix and not a requirement change.
- **"Removed" now means two things**, and only one of them is something the person did. Any future
  surface that lists removed commitments, or explains removal, has to say which. `CONTEXT.md` carries
  the warning.
- **A rename is not reversible through the record if it is interrupted mid-way by a second rename.**
  Nothing here promises otherwise, and nothing offers a history of names.

## Questions for you

One question. It was invisible until the kept-from requirement had to be phrased, and **the grill
could not have reached it**: it turns on `Schedule.everyNDays` carrying its own start date separately
from `Commitment.keptFrom`, which is a fact about the code that only a delta-writing pass goes and
reads. Everything else the grill settled survived contact with the code unchanged.

The delta is written on the recommended answer, so it validates and is complete either way; if you
say otherwise, the change below is what moves.

1. **An interval commitment's kept-from day is also its rhythm's start date. When someone corrects
   the kept-from day, does the rhythm's grid move with it?**

   `grill.md` § *Settled* 3 says moving the day earlier "widens the window and every past day inside
   it becomes due". That is true of a weekday set, a day of the month and a weekly quota, whose
   dueness does not depend on the kept-from day at all. It is **not** true of *every 14 days*: there,
   moving the day back by three days moves every due day since, so a commitment with any record at all
   would have every one of those records sitting on a day it is no longer due on — and the carry-over
   would refuse the whole change.

   - *Recommended:* **the kept-from day moves the floor only, and an interval rhythm's start date
     stays where it is.** The model already allows the two to differ and the shipped spec says so; the
     grid a person has actually been keeping to is preserved; every existing record still forms; and
     "widens the window" becomes true of all four rhythms. The price: a commitment whose kept-from day
     is earlier than its interval's start opens no days before that start — an interval that began in
     August cannot be made to have been due in June, only to have been *kept* since June — and the
     sheet can no longer re-create such a commitment from scratch, though nothing asks it to.
   - *If you say the grid moves with the day:* the requirement *A commitments screen changes a
     commitment on either of its lists* is rewritten for the interval case, and its two kept-from
     scenarios with it, so that a kept-from change on an interval commitment with any record is
     refused as *a day already recorded on that the change would leave not due* nearly every time —
     including moving the day **earlier**, which the settled answer says is the safe direction. The
     refusal is one a person cannot predict from the screen. Nothing else in the delta moves; the
     `record` and `day-screen` deltas are untouched either way.

## Open Questions

**`grill.md` § *Left open* says "None.", and it is still none.** All three of the things it owed
`spec-author` as work rather than as questions are discharged in this diff, and each is recorded here
so a reader can check rather than trust:

1. **The ADR owed — written, and it is two amendments rather than a new record.** ADR-1023 and
   ADR-1030 are amended in place and stamped `2026-09-09`. § *Why no new ADR* gives the reasoning, and
   ADR-1038 is untouched, which `tasks.md` § 8.2 checks rather than assumes.
2. **The four shipped requirements this contradicts — all four amended.** `grill.md` named them by
   line number against the spec as it stood before #181 merged; against the spec at this branch's base
   they are *A roster holds the commitments a person keeps* (the ban on state of its own, and the
   order rule), *A roster removes a commitment it holds, and never lets it go* — **which is not
   modified, and that is the finding**: nothing in it becomes false, because a superseded commitment
   is removed in exactly the sense that requirement already defines, and the widening is a `CONTEXT.md`
   word rather than a spec rule — *A commitments screen defines a commitment from a name, a rhythm and
   the day it is kept from*, and *A commitments screen says in words the rhythm its form is building*,
   which is removed outright. Three more turned up that `grill.md` did not name and are modified here:
   the roster store, the already-kept-versus-cannot-write refusal, and the pair about what a refused
   change is held as.
3. **Whether either store's form number moves — measured, and neither does.** § *Neither form number
   moves*.

Two things are deliberately open **after** this Story, and neither blocks it:

- **A commitment's history across a rhythm change cannot be read as one run**, and once records exist
  against both values it cannot be reconstructed. This is the priced cost of *no link*, named at the
  grill. If a future screen wants it, the decision to take first is whether to start recording the
  link from that day forward.
- **`docs/backlog.md` B-036 and B-037 are still in *Wants* and belong in *Decided* against #148**, and
  #26's G2 comment records a five-Story breakdown that does not carry them. Both are `orchestrator`'s
  and neither is in this diff, because `docs/backlog.md` is not `spec-author`'s to write.
