# Grill — add-number-record

*7 questions over 2 rounds, 2026-09-06.* Story #138, the second of six under `FEAT: record` (#53)
and the first record that is not a tick. #137 gave a commitment a kind; this Story gives a number
commitment's day something to hold.

## Settled

1. **A history answers what number is on a day, not only whether the day was kept.** *Asked
   because the Story's intent says only "kept by being there"; they chose the reader, because a
   record nothing can read back is not a record and #139's row has nowhere else to get the number
   it has to draw.*
2. **A refused number leaves the record that was there standing.** 300 entered against a range of
   40 to 150, over a day already holding 70.5, leaves 70.5. *Asked because "entered again it is
   replaced" can be read as replacing first and refusing second; they chose the refusal that
   changes nothing, which is the shape a refused tick already has.*
3. **A range is bounds and nothing else — 5.5 is a mood on a range of one to ten.** *Asked because
   a mood of one to ten reads like ten values; they chose bounds, since a step or a scale is not a
   thing this product has. What they want for a mood is a slider over whole numbers — that is the
   row's affordance and belongs to #139, so it is a want rather than anything in this delta —
   captured as B-034 on `chore/backlog-b034` (PR #150).*
4. **The record store reads every form this app has written — 3, 2 and 1.** *Asked because #137's
   `design.md` says exactly one step back is supported, and a phone that never ran #137's build
   still holds a form-1 file, which one step back would refuse whole.*
5. **The reader is number-shaped, not the general record reader all four kinds will share.**
   *Asked because #140's note and #141's total will each want one; they chose to leave the general
   shape until all three exist, rather than fix the shape of two records nobody has grilled yet.*
6. **Taking a number back names the commitment and the date, not the record.** *Asked because a
   tick is taken back by value (`History.remove(_ tick:)`); they chose the day, because a day holds
   at most one number and a caller that mistyped 300 must be able to clear it without reading it
   back first.*
7. **A number that is not a number is refused.** *Asked because `Commitment.Range` refuses a NaN
   end explicitly while `Target` refuses one only as a side effect; they chose the explicit
   refusal. The two measurements below are why it cannot be left to the range.*

## Facts found, not asked

- **NaN is the only non-finite `Decimal`.** `Decimal.infinity` is annotated unavailable and does
  not compile; `isInfinite` is false for every value reachable, division by zero gives NaN, and
  overflow past `greatestFiniteMagnitude` gives NaN. So `!isNaN` and `isFinite` are the same guard
  and the delta needs no second non-finite case.
- **A NaN in the file destroys the whole history, not just its own record.** `JSONEncoder` encodes
  `Decimal.nan` without complaint and writes `{"value":NaN}`, which is not valid JSON; decoding
  that fails with `dataCorrupted`, and `RecordStore.init` turns any decode failure into
  `notAStore(at:)` — every record in the file is refused, not one. That is what Settled 7 is
  protecting, and it is why the refusal has to happen where the record is formed rather than at
  the store.
- **A range check rejects NaN only through its lower bound.** `Decimal.nan < x` is true for every
  `x` measured, including negatives, and nothing is `<=` NaN. So `lowest <= n && n <= highest`
  refuses a NaN, while `n <= highest` on its own accepts it — an implementation that checks only a
  maximum would let one through.
- **`Decimal.nan == Decimal.nan` is true**, unlike IEEE-754, so a NaN would dedupe and compare as
  an ordinary value inside a `Set` or a `Hashable` record. A third reason to refuse it at
  formation.
- **`Decimal` round-trips exactly through JSON** — 70.5, 0.1 and a 30-digit value all written and
  read back unchanged, with no binary-float artifacts. Nothing here needs a requirement about
  precision; the delta says a number reads back as the same number and says nothing about how it
  is spelled, which is #139's to draw.
- **The record store already reads every earlier form.** `RecordStore.swift:25–40` guards
  `(1...RecordDocument.currentVersion).contains(envelope.version)`, and `RecordDocument.swift:15`
  has `currentVersion = 2`. Moving it to 3 reads forms 1, 2 and 3 for free — so Settled 4 is a
  requirement to pin rather than code to write, and it is worth pinning because nothing today says
  so.
- **A history has no way to read a record out.** `History` holds `private var ticks: Set<Tick>`
  (`History.swift:2`) with both of `Tick`'s properties internal, and `RecordDocument.swift:8–11`
  calls reading them back out "the direction that has no public way through"; `isKept` re-forms
  the tick and asks `contains`. Settled 1 is the first read-back this capability has.
- **The roster store does not move.** Both stores share `CommitmentCoding.swift`, which is why
  #137 moved both. This Story changes `RecordDocument`'s payload and not a commitment's wire form,
  so the roster stays at form 2.
- **This Story reverses a requirement #137 shipped the same week.** `record`'s *A history answers
  whether a commitment was kept on a day from the ticks it holds* says a commitment whose kind is
  not a tick is answered *not kept* on every date. A number commitment with a record is kept, so
  that requirement changes here — while a note and a total stay not kept until #140 and #141.
- **Nothing in `src/` holds a recorded numeric value yet** — no type, no property, no wire key.
  Every existing mention of "number" is the commitment *kind*, never a recorded value.
- **The app shell does not change.** Day one is nine ticks, #142 is what puts a kind on the
  commitments screen, and #139 is what enters a number in a row — so nothing shipped can reach a
  number record until then.
- **B-032 (start a weight entry from the last weight I gave) is a non-goal here**, and its own
  *Open* lines say why: it cannot be taken before a weight is recordable at all.
- **The mood-slider want went to its own branch, not `chore/backlog`.** Capturing it there was
  attempted on 2026-09-06 and failed: another session was rebasing that branch in the shared
  `../daybyday-backlog` worktree, and its checkout discarded the uncommitted entry — rule 8's
  hazard, live. B-034 was cut onto `chore/backlog-b034` instead and merged as PR #150. That
  session's own PR #149 was closed unmerged at the moment this was written and merged later the
  same day as `eb298a2`, so the backlog and the tracker agreed again before this Story left the
  grill. Neither fact touches this delta: `record` is not a capability any of #144–#148 claims.
- Measured on this machine on 2026-09-06, Apple Swift 6.3.3 (swiftlang-6.3.3.1.3), target
  `arm64-apple-macosx26.0`: `swift test` reports **418 tests passing** at the branch point.
  `openspec` is 1.10.0.

## Terms landed in CONTEXT.md

None new. **Number**, **Range** and **Taking back** landed at the Feature grill on 2026-09-06,
before this Story existed, and `CONTEXT.md` § *Record* already says a number keeps the day by being
there and is replaced when entered again. This grill added no noun the vocabulary does not have.

## Left open

None. Every question the frontier raised was answered, and the two things it raised that are not
this Story's went somewhere durable rather than into the delta: the mood slider to B-034, and the
weight prefill to B-032, where it already was.
