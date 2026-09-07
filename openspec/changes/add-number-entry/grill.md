# Grill — add-number-entry

*16 questions over 3 rounds, 2026-09-07.*

## Settled

1. **A number is kept when the entry is committed, never as it is typed.** One typed number is one
   change, exactly as one tap is one change. *Asked because a tick reaches the store the instant it
   is tapped and a number does not exist until it is finished; keystroke-by-keystroke, 70.5 against
   a range of 40 to 150 writes 7 — refused — then 70, then 70.5, and a person watches a refusal
   appear and vanish mid-typing.*
2. **Committing an empty entry takes the number back, and that is this Story's.** *Asked because
   `record` built take-back by naming the commitment and the day explicitly so a person who mistyped
   300 could clear it, and nothing yet reaches it from a row. There is no later Story in this lane
   for it — #140 is the note, #141 the total — so leaving it would mean a number entered on the
   wrong day could never be removed.*
3. **The row never draws the number. It draws the marker and nothing else.** A number row says its
   name, its rhythm in words and whether the day was kept, exactly as a tick row does. *Asked
   because a history now answers what number is on a day and #138's grill assumed #139's row would
   draw it; the owner chose otherwise — "the number itself is not important, it's only important
   that an entry was made ... at least on the day screen". The number matters where it is read as a
   trend, and that screen does not exist.*
4. **The entry hints the range, as a placeholder on an empty field** — `40–150` for a weight,
   nothing at all where the commitment declares no range. *Asked because a range that exists only as
   a refusal teaches a person by refusing them; the hint costs one line and is gone the moment a
   number is in the field.*
5. **A number the commitment refuses is told on the row, and the telling names the bound it broke.**
   "Must be between 40 and 150", not "Not saved. Try again." *Asked because the notice is
   deliberately shaped so that no cause can be told — `refusedChangeRow` is a row and nothing else,
   and an enum was rejected because "the first thing a second case would be is the cause this delta
   exists to refuse". That shape rests on ADR-1021's argument that a person has exactly one thing to
   do whatever the reason. A range refusal breaks the argument: trying 300 again against 40 to 150
   fails for ever, so the shipped words are false there.*
6. **A number row for a day that has not arrived draws no entry at all** — just the name, the rhythm
   and the marker, like every other row. *Asked because a tick row on a future day answers a tap
   with total silence, which is B-035, captured off the phone on 2026-09-07. This Story does not
   take B-035; it declines to repeat it for the row it is adding.*
7. **Tapping a number row opens an alert holding one field, with Save and Cancel.** *Asked because
   answer 3 leaves the field with nowhere permanent to live. An inline expanding field is closer to
   "entered where you stand" but costs focus handling and a row whose height changes; a sheet is a
   second screen inside the daily visit. The alert is the smallest thing that works, and its Cancel
   is what makes a stray tap unable to wipe a number, which matters because of answer 2.*
8. **The field opens holding the number already recorded for that day.** *Asked because answer 2
   makes an empty commit a deletion: a field that always started blank would turn a tap-and-confirm
   with no typing into an erasure. Prefilled, clearing is deliberate. This is not B-032, which is
   prefilling from the last entry on a day that holds none, and which stays a want. The number is
   still never on the row — only inside the entry the person opened.*
9. **A tick's refusal stays wordless.** "Not saved. Try again.", unchanged. *Asked because answer 5
   breaks the sentence "SHALL tell every refusal the same way, and SHALL name no cause". The owner
   chose to amend the rule to its own reasoning rather than reverse it: only a refusal a person can
   act on differently names itself, and a failed write still leaves exactly one thing to do.*
10. **A value that is not a number is refused and said so** — "Not a number" — and is never read as
    a clear. *Asked because a decimal keypad still types "." alone and "1.2.3"; an empty field is
    already a take-back, so a half-typed value must not fall into the same case.*
11. **The field accepts whatever the device's keypad prints as its separator.** *Asked because an
    iPhone's decimal keypad shows a comma on a German or French phone; a field parsing only "." makes
    the key on the keyboard produce "not a number". `record` still consults no locale — this is the
    shell turning text into a number, one layer above it.*
12. **B-034's mood slider stays a want.** *Asked because that entry's Touches line points at exactly
    this Story. It still carries two unanswered questions — whether it is every range or only a
    narrow one, and whether a whole-number slider may accept less than the record does — and neither
    was settled here.*
13. **A refused number closes the alert and is told on the row.** *Asked because saying it inside
    the alert reads better; the owner chose the row, since one mechanism serves every refusal and
    the alert's inside is unreachable to any test (`docs/open-questions.md` § No UI smoke layer).*
14. **A tap on a number row does not open the alert when the screen is not keeping a record.** The
    row does nothing at all, exactly as a tick row does. *Asked because the screen already says at
    screen level why nothing is being kept; opening a field, typing a weight and having it silently
    vanish is worse than a row that does not respond.*
15. **Cancel is not a fourth end for a notice.** The three ends stand — the app being shown again, a
    change reaching the place, the day being shown changing. *Asked because "nothing else SHALL end
    it" is a sentence written to have exactly three, and Cancel is a plausible fourth. Cancel keeps
    nothing, so nothing has changed and the notice still describes the last thing that happened.*
16. **A number row draws the standard disclosure chevron.** *Asked because answers 3 and 7 together
    make a number row and a tick row identical until entered, while one records on tap and the other
    opens something. The chevron says the kind, not the value, so it does not undo answer 3; #142
    puts the kind on the commitments screen and the day screen would otherwise have nothing.*

Two things follow from the answers rather than being asked, and are recorded so nobody re-decides
them: **the day screen holds no draft** — answer 1 means nothing uncommitted is ever a record, and
the text being typed is the shell's own state — and **a number commitment with no range can only
ever be refused for answer 10's reason**, since answer 4's placeholder and answer 5's words both
need bounds to exist.

## Terms landed in CONTEXT.md

- **Number entry** — what a number commitment's row offers in place of a tick: the number a person
  gives for that day, asked for one at a time, kept whole when it is committed and taken back when
  it is committed empty. It is not a record — `record` says what a number is; it is the place one is
  made, the way a tick is made in the row.
- § *Row* is **amended**: a row offers a tick *or* a number entry, according to its commitment's
  kind, and it never says the number — only whether the day was kept. It says which of the two it
  offers, which is the chevron of answer 16.
- § *Day screen* is **amended**, at the notice: a notice **may name a cause where the cause is one a
  person can act on differently**, which the range refusal and the not-a-number refusal are and a
  refused write is not. The lifetime is untouched — still three ends, still at most one per screen.
  `docs/adr/README.md`'s amendment rule applies: this is edited into the entries that hold those
  decisions rather than given new ones.

An **ADR is owed** for answer 5. It meets all three tests — the notice's shape was deliberately made
unable to carry a cause and defended at length, a future reader meeting "SHALL name no cause" beside
a named cause will ask why, and there were real alternatives. Whether it amends ADR-1021, which
holds the reasoning, or takes its own number is `spec-author`'s judgement against
`docs/adr/README.md`; the ADR numbering hazard in `docs/open-questions.md` applies, since #145 is an
open branch.

## Left open

None. Every question the frontier raised was answered. Three things were found beside this Story and
deliberately left outside it, each with somewhere durable to go:

- **A number row on a future day will not invite the tap while a tick row still will.** That
  asymmetry is answer 6's price and it is B-035's other half. It belongs in `design.md` § *Impact*,
  the way #137's went, so that whoever takes B-035 finds it.
- **B-034 (the mood slider) and B-032 (the prefill from the last entry)** stay wants, by answers 12
  and 8. Neither is touched here.
- **The tenth face** — `docs/open-questions.md` § the public-surface gap — is confirmed rather than
  widened: the row must give the recorded number *out*, for answer 8's prefill, while answer 3 stops
  it from ever being drawn on the row. Worth a line there at G7, not before.
