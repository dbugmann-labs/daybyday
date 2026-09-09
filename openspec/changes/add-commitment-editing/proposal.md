## Why

A person can define a commitment, stop keeping one and get rid of one for good, and cannot change
one. A typo in a name is permanent, a rhythm that turns out to be wrong can only be answered by
stopping the old commitment and defining a new one — which starts a fresh history and leaves two rows
saying nearly the same thing in every past week — and a person who has kept something since June and
said August has no way to say so afterwards. This is **B-014**, one of the three wants
`FEAT: commitment` (#26) took forward at G1, and it is the last of the commitment's lifecycle.

**This Story carries three wants, not one**, by the owner's decision at the grill (`grill.md`):
B-014 is what it was cut for, and **B-037** (reach the form when you want it) and **B-036** (drop the
rhythm preview) were taken into it because the sheet this Story needs is the same section of the
screen both of those move. Both are still live entries in `docs/backlog.md` § *Wants* and need moving
to *Decided* against #148; #26's G2 comment records a five-Story breakdown that did not carry them.
Both are `orchestrator`'s to do and neither is in this diff.

The grill also asked whether this is too large for one Story — three wants, a new sheet, a rewrite of
records, a supersession rule and amendments to two ADRs — and the owner reaffirmed one Story. It is
recorded here because the size is real: this delta carries **185 scenarios, 58 of them new**.

## What Changes

Changing a commitment is one act to a person and **two different acts to the model**, and which one
you get depends on which field you touched. That split is the whole of this proposal.

- **A name or the day it is kept from reaches the whole history.** A **history carries every record of
  one commitment over to another** — a new requirement on `record` — and the roster then **changes**
  the commitment it holds for the new one, in the place it holds it. Every past day afterwards draws
  the new value and answers about it exactly as it answered about the old. Neither a name nor a
  kept-from day is a rule about days ahead: one is what you call the thing, the other is a claim about
  your own history, so correcting either corrects the whole of it.
- **A rhythm does not reach the past, and never will.** The roster **supersedes**: the old commitment
  is kept until the day before today and held **removed**, and the new one is taken on in the place it
  held, kept from today. **No record moves.** ADR-1013's promise is that a day already lived answers
  exactly as it did, and a history that rewrites itself is the one thing this product must not do.
- **Both in one save: the carry-over first, then the supersession.** The only order that satisfies
  both rules — the superseded value then carries the new name and the corrected kept-from day, so past
  days redraw correctly, while the commitment taken on starts today.
- **The record place is written before the roster place**, and that order is part of the decision
  rather than an implementation detail: it is the only one of the two in which a failed second write
  can be repaired by asking for the same change again. `design.md` § *Two files, one act, and the
  order that makes a retry work*.
- **A commitment still has no identity of its own, and gains no fifth part.** That is the point:
  ADR-1023 refused a mutable part because a record embeds the whole commitment by value, and this
  change meets that argument rather than stepping around it — nothing is re-keyed, because in both
  acts every record still embeds a commitment the roster still holds. **ADR-1023 and ADR-1030 are
  amended in place**, which is the revisit ADR-1030 named B-014 as the trigger for; the amendment is
  *not* that a commitment gained an identity.
- **The roster records no link between a superseded commitment and the one that replaced it.**
  Nothing reads one. The cost is named rather than hidden: one commitment's record across a rhythm
  change cannot afterwards be read as a single run, and a rename after a supersession reaches only the
  value it was asked about.
- **A change into a commitment the roster already holds is refused — kept, stopped or removed alike.**
  This is stricter than defining, which takes a stopped or removed commitment *up again*. Merging two
  histories is irreversible; reaching a removed one through a spelling correction is too large a thing
  to happen invisibly.
- **Two refusals are new**, because nothing before this change could produce either: a change a
  **stopped** commitment does not take (it can only be renamed — its rhythm and kept-from day have no
  days left to decide about), and **a day already recorded on that the change would leave not due**,
  which is what stops the kept-from day being moved forward over someone's own record.
- **A day screen returned to now reads its record again where it is keeping one.** The record place
  has a second writer for the first time. Without this, renaming a commitment and walking back to the
  day screen would show every day it was ever kept as not kept — the one answer this product exists to
  prevent. What a day screen says about a record it **could not** read is untouched: a screen not
  keeping a record does not start keeping one by being returned to.
- **The rhythm-preview line goes (B-036).** *A commitments screen says in words the rhythm its form is
  building* is **REMOVED** — a shipped requirement, five scenarios, taken back rather than narrowed.
  The words are not lost: a schedule still says its rhythm in words (ADR-1034) and every entry and
  every day-screen row still says them. What goes is the one place that said them for a rhythm nobody
  had committed to yet.
- **The sheet (B-037) is the shell and carries no requirement**, and that is a decision this proposal
  makes explicitly rather than by omission. Defining and changing share one form; it is reached by a
  `+` in the toolbar and from a row; it is a sheet and not a pushed screen. Where a form is reached
  from and what it draws are the drawing's, exactly as `Move up`/`Move down` were for #181 — what the
  delta owes is **what a commitment is made of**, which is a new requirement so the sheet has
  something to fill itself from, and **whether its rhythm and kept-from day can be changed at all**,
  which is a fact about the commitment and not about the form.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`: **four requirements added** — a roster changes a commitment for another in the place
  it holds it; a roster supersedes one it is keeping with another from a day; a commitments screen
  says what a commitment it is asked to change is made of; a commitments screen changes a commitment
  on either of its lists. **Seven modified** — what a commitment is (the kind paragraph, which said
  changing one was a want of its own), the roster's ban on state of its own and its order rule, the
  roster store, the define form's four things and the day it offers, the already-kept-versus-cannot-
  write refusal, and the two requirements about what a refused change is held as and how long for.
  **One removed** — the rhythm preview.
- `record`: **two requirements added** — a history carries every record of one commitment over to
  another, all of them or none; a store carries them over at its place, written before it reports.
  **One modified** — the store's write-before-report rule, which now covers the one change that
  touches every record a place holds at once.
- `day-screen`: **one modified** — a day screen returned to reads its record place again where it is
  keeping a record. Nothing else in that capability moves; a supersession needs only the roster re-read
  it already does.

### Not modified

- `schedule`: untouched. Every rhythm this change builds is one the screen could already build, and no
  schedule's words, dueness or shape moves. `Rhythm.inWords` goes with the preview, but that is a
  `commitment` surface and `ScheduleWords` — which `schedule` owns — stays exactly as it is.

## Impact

- `src/DayByDayKit/Sources/DayByDayKit/` — `Roster` gains `change` and `supersede`, `RosterStore`
  passes both through, `History` and `RecordStore` gain `carryOver`, `CommitmentsScreen` gains
  `change` and what a commitment is made of and takes a **record place** for the first time, and
  `DayScreen.returnedTo()` re-reads its record. `Rhythm` loses `inWords` and gains a way back from a
  `Schedule`. **No new type, no new file, and no form on disk moves** — the roster file stays at
  form 4 and the record file at form 5, which `design.md` § *Neither form number moves* measures
  rather than assumes.
- `src/DayByDay/DayByDay/CommitmentsView.swift` — the form becomes a sheet reached by a toolbar `+`
  and by a row, and the preview line goes. It is at **`:278`** on this branch; `docs/backlog.md` B-036
  says `:167`, which is stale and is recorded in `tasks.md` § 7.1 rather than corrected, because the
  backlog is not `spec-author`'s to write. ADR-1019's 2026-09-04 exception; no requirement is attached
  to any of it.
- `docs/adr/` — **ADR-1023 and ADR-1030 amended in place** and stamped. No new ADR: ADR-1030 named
  this Story as the revisit trigger and named those two files as the ones to amend, and ADR-1020 makes
  in-place the way. `design.md` § *Why no new ADR* says why the amendment is smaller than the trigger
  anticipated.
- `CONTEXT.md` — **Changing a commitment**, **Superseding** and the amendment to **Removed** were
  landed by the grill. This Story adds **Carrying over** — the `record` verb the delta turned up,
  which the grill had no name for — and amends **Commitments screen** for the sheet and the eighth
  refusable change.
- **Not touched:** `Commitment` itself, `Schedule`, `Tick`, `Number`, `Note`, `Addition`, every record
  already made, and both files' form numbers. A change of commitment moves values between commitments
  that already exist; it invents nothing for either file to hold.
