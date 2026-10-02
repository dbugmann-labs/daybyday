# Grill — add-happening

*9 questions over 4 rounds, 2026-10-02, one fact agent and the layout round. The Feature grill of B-076 (15
questions over 3 rounds, the same day) settled what a happening is; its answers are in
`CONTEXT.md` § *Happening* and § *Occurrence* and in `docs/backlog.md` § *Decided*, and are not
repeated here. This Story makes and renames a happening only: occurrences are #376, the look-back
#378, stopping and deleting #379, the copy #380.*

## Settled

1. **Two happenings with one name.** Refused, judged as the roster judges a commitment's name — one
   name where two differ only in case or in blank space at either end — and told under the field the
   way a commitment's is ("A happening called … already exists."). *A happening is a name and
   nothing else, so two with one name could not be told apart on the day screen or in a look-back.*
2. **A happening named as a commitment is.** Allowed. *They sit in different groups and mean
   different things — owed against came — and refusing it would couple two stores to prevent no
   real confusion.*
3. **Order.** The order happenings were made in, newest last, with no reordering in this Story; a
   rename keeps a happening's place. The day-screen group (#376) takes the same order. *There will be
   two or three; a drag can be a want of its own if the order ever matters.*
4. **The section before any happening exists.** Drawn, headed as happenings, with a line saying none
   exists yet and the way to make one — as Kept and Stopped each say a line when empty. *It is how the
   feature is found.*
5. **A happenings store that cannot be read.** Refused rather than emptied, as the one-off and
   birthday stores are: the section says the happenings could not be read and offers neither making
   nor renaming, so nothing overwrites the file; the commitments on the screen work as before. *A
   section silently dropped would hide that the history is unreadable.*
6. **Day one.** A fresh install holds no happening. *Day one spares typing nine rhythms; one name is
   a tap.*
7. **The walk.** From a fresh install, five pictures and no `phone:` line: the commitments screen with
   the empty happenings section; making "Augenmigräne" part-way; the section holding Augenmigräne
   and Kopfweh in the order made; a second "kopfweh" refused with its words showing; Kopfweh renamed
   to "Spannungskopfweh". *Nothing in this Story is a gesture only a phone can prove; an unreadable
   store cannot be driven through the screen and is the seam tests' to show.*
8. **Which name a refusal quotes.** The happening that already exists — "kopfweh" typed against
   "Kopfweh" is told *A happening called "Kopfweh" already exists.* *It points at the row the person
   already has, as a commitment's refusal does.* Asked in the layout round, from the mockup.

## Terms landed in CONTEXT.md

None in this grill. **Happening** and **Occurrence** landed at the Feature grill the same day, and
**Moment** was amended there.

## Left open

None. Where the section sits on the commitments screen and how a happening is made and renamed there
were the layout round's, below. The section's heading, its empty line and the sheet's title and
buttons are words the grill did not settle — spec-author's to set, in the commitments screen's idiom.

## Layout

Option A, *Sheet, at foot*, chosen from three at https://claude.ai/artifact/CJFdvVcUJUFJ33bodrYtqL —
*it uses only patterns the commitments screen already has: a text action row in the accent like* Add
usual amount*, swipe right for the pencil and a sheet like a commitment's* Edit*, and the refusal under
the name field. A row's tap stays free for the look-back (#378), and the toolbar is unchanged.* With A,
Settled 4's "the way to make one" is the *New happening* row beneath the empty line, not words in it.
The wireframe follows, verbatim from the designer.

```
A · Sheet, at foot
[<] Commitments      [⇅ +]
┌ … Yuno - 5x a week       >
│   Weight - Every day     >
└──────────────────────────
Stopped
┌ Nothing has been stopped.
└──────────────────────────
Happenings
┌ Augenmigräne
│ Kopfweh
│ New happening   (accent)
└──────────────────────────
Empty: "No happenings yet." row
       above New happening

Make:   sheet
[Cancel] New happening [Add]
┌ kopfweh|
│ A happening called "Kopfweh"
│ already exists.     (red caption)
└──────────────────────
[keyboard]

Rename: swipe right on the row
[✎]│ Kopfweh  → sheet
[Cancel] Rename Kopfweh [Save]
```
