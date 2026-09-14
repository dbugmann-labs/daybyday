# Grill — cover-record-rules

*11 questions over 3 rounds, 2026-09-13.*

## Inherited, not re-asked

Settled at the seventh grooming pass (2026-09-12) and at the grill of `cover-schedule-rules` (#221),
and stated here because the brief that carried them is not in the repository: tests are accepted
green on arrival and not proven by mutation; a rule nothing can prove keeps its place in the spec and
is recorded; each capability writes its own bullet under `docs/open-questions.md` § *Known gaps* and
never appends to a shared one; the archived candidate list in
`openspec/changes/archive/2026-09-11-condense-record-spec/design.md` is a hint to re-derive, not the
answer. Read its § *Decisions* as well as § *Open Questions*: the absences sit in the former.

## Settled

1. **A partly covered rule counts as uncovered where a plausible wrong implementation passes.** A
   note take-back leaving a number standing, widening the question by schedule or kept-from day, a
   tick of another kind read off a store, a reader trimming only ASCII spaces. *A contrived break —
   a range enforcing a 0.5 step from its lowest value — is not worth a scenario.*
2. **Coverage from another requirement counts, and `design.md` names the scenario that gives it.**
   "As SHALL every tick" under *A number can be taken back* is covered by the store scenario that
   takes back a number and still reads the tick. *CONTEXT.md defines covered as "some scenario would
   fail"; a duplicate is what the pruning Stories just removed, and naming it lets the next pruning
   see the dependency.*
3. **"A store SHALL write only when a change is kept" was meant as written.** Every store change
   method but `carryOver` writes even when its history is left unchanged, so the covering test is
   expected red and the Story takes the least fix under the lane's exception. *They chose the rule
   over a rewording, and over a Story of its own.*
4. **That fix reaches every change that leaves the history unchanged**, not take-backs alone: a tick
   already held, the same number or note entered again, and a take-back of what is not there. *The
   sentence is store-wide, and `carryOver` already carries the guard.*
5. **The day whose additions overflow to NaN is out of scope.** Measured: two additions of
   `Decimal.greatestFiniteMagnitude` sum to NaN and the day answers not kept at the `record` seam,
   against "kept where they sum to its target or more". *What an overflowed day answers is a product
   decision, not a least fix.* The comparison-direction sentence ("the sum against the target, never
   the target against the sum") stays in the spec and is recorded as unprovable: under NaN both
   directions answer alike.
6. **The NaN finding is recorded as an entry of its own in `docs/open-questions.md`**, not under
   *Known gaps*, stating the measured case and that the answer is undecided.
7. **The file at a store's place is part of the `RecordStore` seam.** So "the form on disk SHALL NOT
   move for a carry-over … adds no key, no field and no version" and "MUST NOT persist the day's
   sum" are both covered through it. *Existing byte-for-byte scenarios already read the place. The
   sum check shows the writer adds no sum and cannot show nothing reads one; `design.md` says so.*
8. **The absences are their own group in the `record` Known gaps bullet**, citing CONTEXT.md's
   *Covering Story* entry: a history giving out the sum and never the additions, and no take-back by
   amount and no clearing a day in one act. *ADR-1047 is not amended — CONTEXT.md already names the
   category, and a third Story editing that merged list is the conflict the lane avoids.*
9. **A partly covered rule gets one new scenario per sentence, its uncovered members as AND lines.**
   *The lane's one scenario per rule, and the shape `cover-schedule-rules` used.*
10. **A partial break deliberately left uncovered is recorded in `design.md` only.** *Known gaps keeps
    the one meaning: rules nothing can prove.*
11. **`spec-author` writes both `docs/open-questions.md` additions, in the propose commit.** *So the
    unprovable list and the NaN entry are read at G4 beside the delta, rather than first seen at G7
    as #221's bullet was. Outside its listed write scope, as the implementer's write was at #221.*

## Settled after G4

12. **Where the no-op fix contradicts `day-screen`, `record` wins.** Two shipped `day-screen`
    scenarios — *a number refused by the place is told on the row and names no cause* and *a note
    refused by the place is told on the row and names no cause* — end in "committing nothing at all
    on that row tells the same thing on it and names no cause either", which holds only because a
    take-back of nothing writes, and fails once § 4's fix lands. This Story carries the two
    `day-screen` requirements holding them whole, drops exactly that AND line from each and nothing
    else, and removes the matching blank-commit block from each of their tests. *A screen saying a
    change could not be kept when nothing needed keeping is a false message about someone's record.*
    Asked 2026-09-14 as a stop after the implementer ran red on `swift test`; the grill had not asked
    who else depended on the no-op write failing.

## Terms landed in CONTEXT.md

None. Every word the questions turned on — covering Story, covered, absence, store, place, addition —
is already defined there.

## Left open

None. Every question the frontier raised was answered; which exact sentences are uncovered is
re-derived by `spec-author` against the rules above, not a question for the owner.
