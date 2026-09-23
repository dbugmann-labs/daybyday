# Grill — keep-a-folded-rosters-eras-together

*3 questions over 1 round, 2026-09-23, one diagnostic agent and one fact agent. A defect Story:
the owner's phone, on the build #303 merged on 2026-09-22, lost every commitment after the first
roster write that followed the fold. Replayed in the kit against the owner's own copy.*

## The defect, as diagnosed (facts, not decisions)

- **What breaks.** `RosterDocument.folded()` leaves each chained era at the position the old
  roster held it (`resultEntries[index]`, RosterDocument.swift:244) and assembles the roster in
  document order (:274). A form-4 roster that interleaved entries of one name — the owner's
  held Nails, Public Pool, Nails — folds into a roster where one identity's eras straddle another
  identity's entry. `formRoster()` refuses that on the next read (the adjacency guard at :83,
  "the same identity's eras split apart by another identity's"); `RosterStore` throws
  `notAStore` (:47), and the screens show one-offs only. The fold writes nothing, so the app
  runs on the in-memory roster until the first roster write encodes it as form 5; ticks write
  only the record and do not trigger it. Removing any commitment, kept or stopped, or a bare
  `replace(with:)` of the fold's output, does. The copy written after that change refuses the
  same way. The owner's data is intact; the copy in `~/Coding/daybyday-data/` nests a form-4
  roster and is the clean pre-fold snapshot to test a fix against — never committed.
- **What the spec says.** *A roster store folds a roster kept before a commitment had an
  identity* has no sentence placing a folded era in the output, and no sentence requiring the
  fold's output to be a roster the store reads back; its one round trip scenario folds a single
  kept entry. The adjacency rule lives in *A roster holds a commitment's eras as the entries
  that carry its identity* — "the eras of a commitment SHALL stand together in the roster's
  order, the newest first and each earlier era immediately behind the one it gave way to" — and
  *A roster store that cannot be read is refused rather than emptied* does not name a split
  identity among what it refuses, though the code does. No fixture in the suite interleaves two
  names; the nearest, § 8.4's, is a tail, not an interleave.

## Settled

1. **Where a folded commitment's eras sit.** Together, directly behind the commitment they
   belong to, newest first — the shape a rhythm change writes today. The order of commitments
   is untouched; only eras move, and eras show on no list. *The alternative, keeping document
   order and relaxing the store's adjacency rule, leaves two readers disagreeing on what a
   well-formed roster is and hands every later writer the looser rule.*
2. **A roster the broken fold already wrote.** Not read. *The only such file that ever existed
   was restored over; a second tolerant path in the reader for a state no shipped build writes
   again is not worth having.*
3. **The walk.** No pictures: the fix is behind the seam and no screen changes. Two `phone:`
   lines, because the owner's real roster is the one input the suite cannot hold: install over
   the old build, open (the fold runs), remove one stopped commitment, force-quit, reopen —
   commitments still there; then rename one, force-quit, reopen. *The seam tests carry a fixture
   shaped like the owner's roster — two names interleaved so a chained era has another
   identity's entry between it and its front — which no test has today.*

## Terms landed in CONTEXT.md

None. **Fold** and **Era** stand as they are; the fix makes the fold honour the era rule.

## Layout

No layout question: nothing in `src/DayByDay/` changes, so no designer was spawned.

## Left open

None. Three things are `spec-author`'s and not open: whether the fold requirement gains the
placement sentence and a round-trip sentence (it must gain at least the first, since nothing
states where a folded era sits); whether the refusal requirement names a split identity among
what the store refuses, as the code already does; and the fixture that reproduces the owner's
shape without the owner's file.
