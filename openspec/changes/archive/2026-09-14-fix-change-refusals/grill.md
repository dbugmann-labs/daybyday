# Grill — fix-change-refusals

*2 questions over 1 round, 2026-09-14, on top of the Feature grill of the eighth grooming pass
(`docs/backlog.md` § Grooming passes, 2026-09-14; B-052 in § Decided), whose answers that bear on
this Story are carried in as items 1–4.*

## Settled

1. **A change that leaves the rhythm and the kept-from day alone leaves an every-N-days grid where
   it was.** This covers a rename, a category-only change and a save with nothing changed. *At the
   Feature grill. Measured on a scratch copy: the seeded Nails (every 4 days from 6 Sep, kept from
   4 Sep) refuses all three once ticked, as `.wouldLeaveARecordedDayNotDue`, because the change
   rebuilds the schedule from the kept-from day (`Rhythm.swift:23`, `:46`).*
2. **A carry-over onto a commitment that already holds records is refused for that cause**, told
   apart from *a day already recorded on that the change would leave not due* and from the other
   refusals. The same applies on the path that carries over and then supersedes. *At the Feature
   grill. Today every `false` from `History.carryOver` becomes the not-due refusal
   (`CommitmentsScreen.swift:426-429`, `:488-491`).*
3. **Nothing repairs such records in the app.** That state is reached only by a torn save, which
   is `save-change-whole` (#249). The owner's phone file is repaired once, by hand, outside any
   Story. *At the Feature grill, over re-attaching orphans on open.*
4. **The specified refusals stand.** Moving a kept-from day past a recorded day it would leave not
   due is still refused, and naming the blocking day stays B-050's. *At the Feature grill.*
5. **Moving the kept-from day on an every-N-days commitment moves its grid with it**, even where
   the grid's start and the kept-from day had differed. Only an unchanged kept-from day keeps a
   grid's own start. *The owner took the reading `commitment/spec.md:4174-4176` and `CONTEXT.md`
   § Kept from already give, and three shipped scenarios assert (`:4265`, `:4457`, `:4469`).
   `commitment/spec.md:255-257` ("MUST NOT shift the schedule's own start date") contradicts it
   and is to be brought in line.*
6. **The new refusal reads "Records already exist under that."** *Short like the other eight,
   and it states the cause without offering a fix the app does not have. The words are the
   shell's (`CommitmentsView.swift:58-77`); the screen holds the case (`commitment/spec.md:4959`).*

## Terms landed in CONTEXT.md

None. **Restarting** landed at the Feature grill and belongs to `add-interval-restart` (#248).
Nothing this Story settled needed a new word.

## Left open

None. Every question this Story's edges raised was answered. How the record seam tells the two
carry-over causes apart is a design choice, not a question for the owner. Today `History.carryOver`
answers `Bool` and `record/spec.md:469-470` states both causes in one sentence, so the choice is
between a widened carry-over and a check the screen makes first. That belongs to `design.md`,
along with the one fact it rests on: no screen scenario and no test expects the old refusal for a
target that holds records.
