# Grill — add-note-record

*12 questions over 4 rounds, 2026-09-08.*

## Settled

1. **This Story stays whole: the record half and the row half in one change folder.** *G2 accepted
   the asymmetry on 2026-09-06 — the number took two Stories, the note and the total one each —
   before #138 or #139 had been built, so it was worth re-asking with what they cost now known. The
   note's `day-screen` half is thinner than #139's: a note commitment declares nothing, so the entry
   has no hint to say, and every text is a text, so there is no parse table and a commit reads as
   two things rather than three.*

2. **A note has no length limit, no restricted script and no reserved word.** *"Short" in
   `CONTEXT.md` describes what a row's field invites, not what `record` refuses. A note is the
   owner's own words and is judged exactly as a **commitment name** is — the alternatives were a
   fixed cap in the package and a cap the commitment declares, and both put the system in the
   position of judging what a person wrote.*

3. **A note that is empty or holds only blank space is not a note, and is refused where it is
   formed.** *The same refusal that stops a commitment name of only blank space naming anything.
   Enforced at `record` rather than only at the screen, so nothing anywhere can make a record that
   draws as nothing at all. Separately, a commit that is blank is a **take-back** at the day screen
   — the two are different rules that happen to meet on the same text.*

4. **`record` takes a line break.** *A line break is a character like any other and `record` knows
   nothing of a row; what a person can actually type is what the field affords, which is decided one
   level up. Keeps interface rules out of the record, which is the line every other requirement in
   `record` holds. The shell will need a field that can show one.*

5. **Blank means whitespace in the full sense — spaces, tabs and newlines alike.** *A note of three
   newlines says nothing, exactly as a name of three spaces names nothing. This matches
   `Commitment.init?`, which refuses a name on Swift's full whitespace test, and deliberately does
   **not** match `DayScreen.read(_:)`, which trims a committed number with `.whitespaces` and so
   reads a number committed as a single newline as "not a number" rather than as a take-back. That
   inconsistency between the two entries is real, is now written down, and is deliberately **not**
   fixed here: fixing it is a delta against `day-screen` requirements that are already archived and
   signed. Record it in `design.md` § Impact and at G7; do not widen the number's trim.*

   **Reversed at the residual round, 2026-09-08, before G4. The number's trim moves onto the same
   test after all, and both directions close here.** *The half of this answer that said "do not
   widen" was decided on two figures the conductor gave and both were wrong: that fixing it would
   rewrite an archived scenario — `spec-author` measured that none breaks — and that the harm was a
   newline told "Not a number", which is cosmetic. The measured harm is the other direction and it
   is not cosmetic: a lone `U+200B` committed in a **number** entry is inside
   `CharacterSet.whitespaces`, so it trims to empty, so it is read as a take-back, so it silently
   deletes the number that day holds. There was no second G4 to weigh either — this folder was not
   signed when the question was asked. What survives unchanged is the first half: blank is
   `Character.isWhitespace`, in one place, for the whole package.*

6. **`History` grows a third one-off reader, `note(for:on:)`, and a third store beside its ticks and
   its numbers.** *#138's Q5 deferred the general record reader "rather than fix the shape of two
   records nobody has grilled yet". The note is now one of those two; the total is not, and the
   total is the case that would actually decide the shape, because its record is a list of additions
   rather than one value. The deferral's own stated end is after all three exist. Price, taken
   knowingly: a twelfth face on the public-surface known gap, recorded at G7.*

7. **A row says nothing about the note.** *Answered against the recommendation, and it narrows what
   #140 is for — the Story's intent sentence said the note was "drawn in the row" and no longer is.
   A note commitment's row says its name, the rhythm it runs on and whether the day is kept, exactly
   as a number's does, and the note is reachable **only** through the entry the row offers. So
   #139's rule holds for both kinds rather than being the number's alone, and the row holds the note
   without giving it out, the way it already holds the number.*

8. **Space around a committed note is disregarded before it is kept; everything between the first
   and last non-space character is kept exactly, newlines included.** *The screen already has to
   trim in order to tell a blank commit from a note (3), so the trim does double duty. The
   alternative — keeping it character for character — would keep whatever space a keyboard left on
   it under the person's name.*

9. **ADR-1033 is amended in place to be about a record taken back by naming the day, rather than
   about a number.** *A day holds at most one note as it holds at most one number, and someone who
   mistyped must be able to clear it without reading it back first — the argument transfers word for
   word. This repo amends a decision in place rather than superseding it, and an ADR reading as
   number-specific while two kinds follow it is one a later reader has to reconstruct.*

## Not this Story's, but settled here

10. **#142 `add-kind-to-commitments-screen` takes a native blocking edge on #140 and #141.** *So
    nobody can choose the note or total kind on the commitments screen before a row can record one.
    Closes the ordering hazard in `docs/open-questions.md` § *A commitment of a kind nothing can yet
    record is a row that does nothing when tapped*, whose own text names this as the cheapest fix.
    `orchestrator`'s, verified from both ends.*

11. **#140's one-sentence intent is corrected before G4** to drop "and drawn in the row", which (7)
    removed. *Rule 4 means the spec wins over the issue either way, so nothing breaks mechanically;
    the tracker should still say what the Story is. Same `orchestrator` spawn as (10).*

12. **The question of where a note is ever read back is folded into `B-007`** — *look at one
    commitment on its own, deliberately and rarely* — at the owner's direction, as an `Open` line
    rather than a new want. *With (7) settled, nothing in the product draws a note: the only way to
    see Tuesday's note is to move to Tuesday and open that row's field. B-007 already carries the
    aggregate question for a tick and for a number; the note is the third of them. No new `B-nnn`,
    because a want's blockquote must be the owner's own words and there are none to quote here.*

## Terms landed in CONTEXT.md

**The conductor named these; `spec-author` lands them**, because `AGENTS.md` § *The conductor* says
the grill "writes exactly one file, `grill.md`" while `AGENTS.md` § *Grilling* says it owes "every
new domain term in `CONTEXT.md`", and `.claude/commands/atlas.md` § *The Story grill* step 4 settles
it the first way — "write `grill.md` into it, and nothing else". `spec-author` is the agent
authorised to write `CONTEXT.md`. Flagged to the human at the close of this grill.

- **Note entry** — *new term, parallel to **Number entry***. What a note commitment's row offers in
  a tick's place: the note a person gives for that day, kept once it is committed and taken back
  when it is committed blank. Deliberately not a **note**, which is the record `record` holds. It
  says **one** thing and no more — the note the day already holds, or *no note* — where a number
  entry says two, because a note commitment declares no bound and so has nothing to teach before it
  refuses anyone. The note is reachable only through it: a row never says one.

- **Note** — *amend the existing entry*. Add: it has no length limit and no restricted script,
  judged as a **commitment name** is, because it is the owner's own words; "short" describes what a
  row's field invites rather than what `record` refuses. It may hold a line break. A note that is
  empty or holds only blank space — spaces, tabs and newlines alike — is not a note and is refused
  where it is formed, the same refusal that stops a name of only blank space naming anything. Space
  around a committed note is disregarded before it is kept and what lies between is kept exactly.
  Agreed 2026-09-08 at the grill of `add-note-record` (#140).

- **Row** — *amend the 2026-09-07 amendment*. A row offers **a tick, a number entry or a note
  entry**, according to the **kind** its commitment declares, and never more than one; a total row
  offers none until there is a record for what its days take. It says neither the number nor the
  note: which of the three it offers stays the only thing a row says about its kind. What a row
  **is** grows by the note the history holds for it, for the same reason it grew by the number —
  two rows of one note commitment on one date holding different notes offer different entries and
  neither can stand in for the other.

## Left open

None. Every question the frontier raised over four rounds was answered.

Two things are carried rather than open, and both belong in `design.md` rather than here. The
whitespace inconsistency in (5) is a **finding**, recorded and deliberately not fixed. And #139's
carried-over note 2 binds this Story: whatever `design.md` claims a note may hold — length,
whitespace, scripts, newlines — carries a **measurement driven through `DayByDayKit`** beside it,
never a confident sentence, and evidence that does not go through the seam is not evidence.
