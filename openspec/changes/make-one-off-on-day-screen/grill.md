# Grill — make-one-off-on-day-screen

*20 questions over 4 rounds, 2026-09-14. Two fact agents; no fact sent to the owner. The Feature grill
of B-049 had already settled that a one-off is made on the day screen on any day it can show, is
renamed there, is never re-dated, and is removed outright; #242 built add-already-done for a past
date; #243 handed this Story row identity for adding and removing. None of that was asked again.*

## Settled

1. **The date an add gives.** Always the day being shown; there is no date field. *A re-date is
   remove and add again (`CONTEXT.md` § One-off).*
2. **Adding on a past day.** The one-off is added already done on that day, so its row stays on the
   day it was added on. On today and on a later day it is added not done. *Added undone, it would
   stand on today at once and leave the day being looked at; #242's add-already-done exists for this.*
3. **Where adding lives.** An always-present empty line at the end of the One-offs group, typed into
   directly, as in Apple Reminders — the **one-off entry** — and a toolbar `+` as well, which brings
   that entry into focus. *The owner's call, beyond the recommended toolbar-only `+`.*
4. **The One-offs group on a day with no one-offs.** Drawn on every day, holding only the one-off
   entry, wherever one-offs are being kept. *Follows from 3; it withdraws "draws no such group where
   none stands", in the spec and in `CONTEXT.md`.*
5. **When a one-off store cannot be read.** Adding is not offered: no group, no entry, no `+`.
   *Offered: a control is drawn only where the screen can honour it.*
6. **When the entry adds.** On Return — which then leaves a fresh, empty entry focused — and on
   tapping away with text in it. Blank adds nothing and says nothing.
7. **The green checkmark.** While any one-off field is focused — the entry or a rename — a green
   checkmark shows top right, as in Reminders; it commits what is typed exactly as Return does and
   closes the keyboard without opening another entry. *The owner asked for it.*
8. **Leaving a field by changing day or leaving the app.** Swipe, chevron, `Today`, the day picker and
   the app going to the background all count as tapping away: the add or rename is committed on the
   day it was typed on, then the day changes. *Typed text is never lost silently in the ordinary
   case.*
9. **Blank space around a typed name.** Trimmed at the screen, for an add and a rename. *So an
   autocorrect trailing space does not make a second one-off; the one-off itself still keeps what it
   is given, untrimmed.*
10. **A refused add.** The cause is named where a person can act on it — a one-off of that name
    already on that date — and a write that failed says only that it was not saved. *ADR-1021's test.*
11. **Where and how long a refused add is told.** Under the one-off entry, which keeps the typed text.
    It is **not** the screen's one row notice, so the two can be told at once. It ends when the text is
    edited, when the day changes, and when the app is shown again, and the typed text goes with it; a
    change landing on another row does not end it. *The owner's call against the recommended "as the
    notice": "until edited", then bounded by the day and by being shown.*
12. **A refusal met while leaving.** An add or rename committed by a day change or by going to the
    background and then refused is dropped with its text by the time the day lands. Accepted. *Rare —
    a duplicate or a failed write — and nothing held is lost, only unsaved text.*
13. **How remove and rename are reached.** A long press on a one-off row opens a menu with *Rename* and
    *Remove*, on every one-off row: done or not, on any day, a later day's row that offers no tick
    included. *Swipe is refused by ADR-1042; a press is what it leaves open, and a tap is the tick.*
14. **Confirming a removal.** None beyond choosing the destructive *Remove* in that menu. *A mis-add
    must be cheap to undo; a commitment's typed-name-back guards history a one-off does not carry.*
15. **How a rename is typed.** The row's name becomes a focused field in place, committed as the entry
    is (6, 7, 8).
16. **A rename committed blank.** Removes the one-off. *The owner's call against the recommended
    "nothing changes", as Reminders drops an emptied item; no confirmation, consistent with 14.*
17. **A rename onto a one-off already held** (same name, same date). Refused, cause named, as a
    refused add. A rename keeps the one-off's date and, where it is done, its done day. *Merging would
    be choosing whose tick survives.*
18. **Where and how long a refused rename is told.** Exactly as a refused add (11): the row stays in
    edit with the typed name and the cause under it, ending on an edit, a day change or being shown.
19. **Row identity.** One-off rows are identified by their value; commitment rows are untouched and
    the gap in `docs/open-questions.md` stays open and unowned. *Value identity is safe where the model
    refuses duplicates, and one-offs refuse a second of the same name and date; nothing here adds or
    removes a commitment row.*
20. **The term.** *One-off entry*, after number, note and total entry — not *add row*, since a row
    in this glossary is a thing's line in a day view and this line holds no one-off.

## Reopened at the phone check, 2026-09-15

*4 questions over 1 round, after G7's phone walk found *Rename* in the long-press menu doing nothing
on the device. The owner asked for a different gesture rather than a fix; answers 13 and 15 are
amended by these, and nothing else above moves.*

21. **How rename is reached.** A tap on the one-off's **name** puts that row into rename, and a tap
    anywhere else on the row is the row's tick — or its take-back on a done row — as before. *The
    owner's call, as in Apple Reminders; told that one row becomes two tap targets and a tap meant to
    tick will sometimes open rename, which tapping away with the name unchanged undoes.*
22. **What counts as the name.** The drawn text of the name alone. The lateness words under it and
    the rest of the row tick. *A short name is a small target; accepted.*
23. **The long press.** Kept, with *Remove* alone; *Rename* leaves the menu. A blank rename still
    removes (16).
24. **Rows that offer no tick, and done rows.** A later day's row renames on its name and the rest of
    it does nothing, as today; a done row renames on its name, keeping its done day (17), and the rest
    takes the tick back. *Rename stays offered on every one-off row (13).*
25. **What Return leaves after an add** (amends 6). An add kept on Return leaves the entry empty and
    **not** focused, the keyboard closed — exactly as the checkmark does (7). A refused add on Return
    stays focused with its text and cause, as 11 already says. *The owner's call at the second phone
    walk: "Just add it, without going to the next add immediately". Keeping focus on a refusal was
    assumed from their check 1 passing, not asked.*

## Terms landed in CONTEXT.md

- **One-off entry** — new: the always-present line at the end of the One-offs group a one-off is
  typed into, and what it does with what is committed there.
- **One-off** — amended: made through the one-off entry, renamed by a tap on its name (21) and removed
  by a long press (23), a blank rename removes; the group is drawn on every day where one-offs are kept.
- **Day view** — amended: the One-offs group is drawn on every date where one-offs are kept, not only
  where one stands.

## Left open

None. Every question the frontier raised was answered, and the one interaction between two answers
(12) was put to the owner and accepted rather than left.
