# Grill — add-commitment-editing

*24 questions over 6 rounds, 2026-09-09.*

This Story carries three wants, not one. B-014 (change a commitment) is what it was cut for;
B-037 (reach the form when I want it) and B-036 (drop the rhythm preview) were taken into it
during round 2 and round 5, by the owner's decision. Both were live entries in `docs/backlog.md`
§ *Wants* and both need moving to *Decided* against #148, and #26's G2 comment records a
five-Story breakdown that did not carry them — that amendment is `orchestrator`'s.

## Settled

### What a change does to the past

1. **Changing a rhythm does not reach the past.** The new rhythm decides today onward; every day
   already lived answers exactly as it did. *ADR-1013's promise is shipped, and a history that
   rewrites itself is the one thing this product must not do.*
2. **A rename reaches the whole history.** Every past day draws the new name. *Renaming is fixing
   what you call something, not starting a new thing — and the alternative puts two rows for one
   commitment in a week's view.*
3. **Changing the kept-from day reaches the whole history, and is the exception.** Moving it
   earlier widens the window and every past day inside it becomes due; moving it later, where a
   record already sits outside the new floor, is refused. *A forward-only split cannot fix a
   kept-from day at all — the new commitment would start today and the June days stay not-due —
   so the likeliest real use of the feature would achieve nothing. This corrects a fact about a
   history rather than changing a rule.*

   **Amended 2026-09-09 at the residual round**, against the recommendation and by the owner's
   decision. "Widens the window" holds for a weekday set, a day of the month and a weekly quota,
   whose dueness does not depend on the kept-from day. It does not hold for an interval rhythm,
   which carries its own start date: **there the grid moves with the day.** Moving the kept-from
   day of an *every N days* commitment therefore moves every due day since, so the change is
   refused wherever it would leave an existing record on a day that is no longer due — in either
   direction, earlier included. The alternative was to move the floor only and leave the interval's
   start where it is; it was declined.

### How that is carried

4. **A rhythm change supersedes.** The old commitment is kept until one day and the new one taken
   on from the next; no record moves, and each past day answers against the value it was written
   against. *Chosen over giving a commitment an identity of its own: nothing re-keys, and it uses
   machinery the roster already has.*
5. **A rename rewrites its records in place.** Every record embedding the old value is rewritten to
   embed the new one. *Dueness does not depend on the name, so every rewritten record still forms —
   which is why this is safe for a name and is not safe for a rhythm.*
6. **The roster stores no link between the old commitment and the new.** *Nothing reads one, and
   `add-roster-removal` already refused to publish a list on that test. Not free: it means a future
   screen could not show one commitment's history across a change.*
7. **A superseded commitment goes into the removed state.** It stays in the roster, every past day
   draws it, every record against it stands, and it appears in neither of the screen's lists.
   *Reusing the state rather than minting a fourth; the cost, taken knowingly, is that "removed"
   now covers an act the person did not perform.*
8. **The change takes effect on the day the screen was handed.** Old kept until yesterday, new kept
   from today. *The same shape #145 chose for stopping, and its price is the same one: a record made
   this morning under the old rhythm is not drawn today, though it stands.*
9. **Name and rhythm changed in one save: rename first, then supersede.** *The only order that
   satisfies 2 and 1 together — the superseded value carries the new name, so past days redraw
   correctly and the new rhythm starts today.*

### What is refused, and what is not

10. **An edit that produces a commitment the roster already keeps is refused**, in the words the
    define form already uses. *Merging two histories is irreversible and discards the fact that
    they were deliberately kept apart.*
11. **An edit that produces a commitment the roster holds removed is also refused.** *Editing is
    not defining. Taking a removed history back under a spelling correction is a large thing to
    happen invisibly — the way back stays deliberate.*
12. **Defining a superseded commitment again exactly takes it up again**, in its old place with its
    records. *No new rule; the shipped way back applied unchanged. Going back to your old rhythm
    genuinely is going back to it.*
13. **Saving a sheet that changes nothing does nothing, and refuses nothing.** *Closing a sheet you
    opened by accident is not an error.*
14. **A refusal is said in the sheet, which stays open with what was typed.** *A rhythm built
    control by control is most of the work; throwing it away to show the refusal elsewhere is the
    expensive answer.*

### Which commitments, and where

15. **Kept and stopped commitments can be changed; removed ones cannot.** *A stopped commitment
    still draws on every past day it was kept, so a typo in it is visible forever. A removed one
    is in no list, so there is no row to reach it from.*
16. **A stopped commitment can only be renamed.** *The rhythm and the kept-from day decide dueness,
    and a stopped commitment has no days left to decide.*
17. **The changed commitment keeps the old one's place in the order.** *Anything else sends a row
    to the bottom of a list #146 let the owner order deliberately.*

### The sheet (B-037, B-036)

18. **Defining and changing share one sheet.** *A dedicated edit sheet beside a permanent define
    section is two forms that drift; B-037's own open question anticipated this.*
19. **B-037's open question — a pushed screen or a sheet — is answered: a sheet.**
20. **The sheet is reached by a `+` in the toolbar for defining, and from the row for changing.**
    *Where a phone puts it, and it costs no room in either list, which is what B-037 is about.*
21. **On a stopped commitment the sheet shows every control, with rhythm and kept-from not
    editable.** *One sheet with one shape; hiding half the controls makes it read as a different
    form.*
22. **The sheet carries a category field and the row's swipe action stays.** *They answer different
    moments — setting one while defining, and refiling in one tap from the list.*
23. **The rhythm-preview line goes (B-036).** *Taken into this Story by the owner's decision in
    round 5, because the sheet moves the same section of the screen. It deletes a requirement that
    has shipped and passed a G4, which the delta has to say out loud.*

### Size

24. **This stays one Story.** *Raised as too large — three wants, a new sheet, a records rewrite, a
    supersession rule and amendments to three ADRs — and the owner reaffirmed one Story. Decided.*

## Terms landed in CONTEXT.md

- **Changing a commitment** — the person's verb: giving one a different name, rhythm or kept-from
  day without losing what has been recorded against it.
- **Superseding** — the roster's verb for what a rhythm change does to the old value: keeps it
  until the day before, marks it removed, and takes on the new one in its place.
- **Removed** — amended in place, to cover a commitment the roster superseded as well as one the
  person got rid of.

## Left open

None. Every question the frontier raised over six rounds was answered.

Three things are deliberately *not* open questions but are owed to `spec-author` as work:

- **An ADR is owed**, amending ADR-1023 and ADR-1030 **in place** (ADR-1020, and ADR-1030 names
  this Story as its own revisit trigger). The amendment is not "a commitment gained an identity" —
  it is that a commitment still has none, and that changing one is carried by the roster and by a
  rewrite of records rather than by a mutable part. ADR-1038's ruling on which of 1023 and 1030
  governs a new part is untouched and should be cited rather than reopened.
- **Shipped requirements this contradicts** must be amended rather than left to disagree: the
  roster's ban on state of its own (`openspec/specs/commitment/spec.md:412`), the removed state's
  definition (`:2910` onward), the define form as a permanent section (`:1837`), and the
  rhythm-preview requirement (`:2851`), which B-036 deletes outright.
- **Whether either store's form number moves** is a fact for `design.md`, not a decision taken
  here. A rename writes different commitment values into `record.json` but adds no key; marking a
  superseded commitment removed uses a key that has existed since the roster's third form.
