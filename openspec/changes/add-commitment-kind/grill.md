# Grill — add-commitment-kind

*3 questions over 1 round, 2026-09-06.* Story #137, the first of six under `FEAT: record` (#53),
reopened at the fifth grooming pass's Feature grill the same day. That grill settled what a kind
is; this one settled the edges of giving a commitment one.

## Settled

1. **A range whose lowest is above its highest cannot be formed.** Refused when the kind is
   formed, the way 30 February is refused as a date and 32 as a day of the month; #142's screen
   refusal is this refusal surfaced. Equal ends are allowed — a range of exactly one value — and
   the ends are inclusive: a mood of one to ten takes 1 and 10. *Asked because "accept anything"
   was cheaper here and a trap for #142; they chose the value refusing it.*
2. **A target is any number above zero, decimals included.** Zero would make every day kept
   before anything was added, so zero and below are refused when the kind is formed. *Asked
   because both day-one examples are whole; they chose the same number type as everything else.*
3. **A tick is of a commitment whose kind is a tick.** This Story deltas `record`'s tick
   requirement to refuse forming a tick for a commitment of any other kind, as it already refuses
   a day the commitment is not due on — and a history therefore answers *not kept* for such a
   commitment, having no tick it could hold. *Asked because leaving it to #138 kept this Story on
   one capability; they chose to close the hole where a number commitment could be ticked, which
   is the first thing the kind actually does.*

## Facts found, not asked

- **Both stores are at form 1 and refuse a later form by requirement.** The code also refuses an
  *earlier* form as "not a store" (`RosterStore` and `RecordStore` both treat `version <
  currentVersion` as `.notAStore`) and no requirement pins that. This Story's intent needs the
  opposite: form 2 for both documents, because an older install must not read a number commitment
  as a tick, and a form-1 file reads back with every commitment a tick. A store writes nothing on
  open, so a form-1 file stays form 1 until the next change is kept there.
- **The kind is readable back**, like the name. `Commitment.schedule` and `keptFrom` are internal
  (the read-back gap's eighth face, `docs/open-questions.md`), but the kind is new and #139's row
  has to know what to offer, so there is no reason to hide it.
- **Kinds carry their own parameters**: a tick and a note carry nothing, a number an optional
  range, a total a required target. Decided at the Feature grill; `CONTEXT.md` § *Kind* to
  § *Target*.
- **The day-one seed is nine ticks and does not change.** The shell's
  `Commitment(name:schedule:keptFrom:)` calls stay valid with the plain kind as the default, and
  the roster's refusal of a duplicate now reads "alike in all four".
- **The fourth part is owed an ADR**, said at G1. ADR-1023 refused a fourth part for *kept until*
  because a part that changes re-keys every tick; the kind never changes once defined and form 1
  defaults to a tick, so nothing already recorded is re-keyed. `CONTEXT.md` § *Commitment*'s
  amendment of 2026-09-06 carries the argument; the ADR records it.
- **Serialised on `commitment`.** Another session is cutting Stories against #26 the same day;
  this Story deltas the same spec and goes first (G2, 2026-09-06). A rebase conflict in
  `openspec/specs/commitment/` is a stop, not a merge.

## Terms landed in CONTEXT.md

None new. Kind, number, range, note, total and target all landed at the Feature grill on
2026-09-06, before this Story existed.

## Left open

None. The three edges the delta turns on are answered above, and everything else the frontier
raised turned out to be on disk.
