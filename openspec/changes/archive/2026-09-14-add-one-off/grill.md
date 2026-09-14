# Grill — add-one-off

*5 questions over 2 rounds, 2026-09-14. The Feature grill of B-049 the same day settled what a
one-off is; its answers are the **One-off** term in `CONTEXT.md` and the ninth pass line in
`docs/backlog.md`, and this grill takes them as given.*

## Settled

1. **Identity.** Two one-offs alike in name and date are the same one-off, as two commitments
   alike in all four parts are. No identifier anywhere. *Asked because "call mum" twice on one day
   could be two things; they chose one — an identifier is a cost every later Story pays.*
2. **A one-off made with a date already past** can be made already done on that date. *Asked
   because the standing rule would otherwise put it on today at once; the Feature grill's answer
   that a past-dated one-off is "ticked there" needs the capability to make one as done, a record
   of something done that was never planned.*
3. **A done one-off can be removed outright**, tick and all. *Take-back then remove is the same
   outcome in two taps.*
4. **Making a one-off equal to one already held**, done or undone, is refused and said, as the
   roster refuses a commitment it is keeping. *Chosen over silently nothing so a later screen can
   say why.*
5. **A name that says nothing** — empty or blank space — is refused by the value itself, exactly
   as `Commitment` refuses one; every other name is kept as given, untrimmed. *One rule for names.*

## Facts found, so that the delta does not re-find them

- The two stores are `record.json` and `roster.json` under the app's application-support
  directory, opened by `DayScreen`'s private place helper; both refuse a file they cannot read
  rather than empty it, and ADR-1031 governs a document's `version` and per-field
  `IntroducedInVersion` constants. No rule anywhere chooses a new store's file name.
- `RecordStore` already deletes an entry from its document on untick, so removal outright has a
  precedent; `RosterStore` never deletes.
- Every "as of a today" at the seam is spelt `asOf today: CalendarDate`.
- The seam precedent for a value-plus-store capability is `add-record-store`'s `design.md`: one
  new exported type beside the value, four entry points, throwing where the disk can refuse.
- **ADR numbers.** 1051 is the highest on `main`, on every branch and in every worktree as of
  14:43 on 2026-09-14; nothing claims 1052 yet, but Story #235 (`add-quota-standing`, worktree
  `../daybyday-add-quota-standing`) owes one at its Stage 4 and may claim it first. Check that
  worktree and `chore/backlog` before writing a number; a collision here costs a second G4.

## Terms landed in CONTEXT.md

None new. **One-off** was landed by the Feature grill; nothing here changed what it says.

## Left open

None. Every question the frontier raised was answered, and the edges this grill did not ask about
— what a one-off's store is called, how the standing rule is spelt at the seam, what the ADR for
*stands on one day at a time* says — are design, not preference.
