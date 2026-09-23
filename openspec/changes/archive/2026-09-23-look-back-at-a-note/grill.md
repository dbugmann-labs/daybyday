# Grill — look-back-at-a-note

*16 questions over 5 rounds, one fact agent, one designer, 2026-09-23.*

## Settled

1. **How much of a note the page shows.** A folded preview, not the whole text. *The owner's
   call, against the recommendation to show every note whole; the answers below make the rest
   reachable.*
2. **A due day with no note.** Nothing — the page lists only the notes. *A placeholder on every
   missed day turns a journal into a list of misses.*
3. **What a tap does.** It opens the note on the page, and never goes to the day screen. *The
   owner's own answer; a note is still changed only in its day-screen row.*
4. **How a note opens.** In place: the entry grows to the whole note, the page moves down under
   it, and a second tap folds it back. *Nothing is pushed or covered, so a reader keeps their
   place in a long list; a read-only sheet would look editable.*
5. **How long a folded note is.** Two lines, then an ellipsis. *The owner's call, against the
   recommendation of three; a denser list.*
6. **How a note's day is said.** "14 March 2026" — the look-back's one day form, no weekday.
   *One way of saying a day across every look-back page.*
7. **A page with no note yet.** It draws its head and says "No note yet." *Mirrors "No number
   yet." and the note entry's own "no note".*
8. **A count.** The page says how many notes there are, "38 notes" — a plain count, not out of
   the due days. Where it stands was settled by the layout: a heading over the notes, not a line
   of the head. *The owner's call, against the recommendation of no count; a fraction out of
   due days was offered and not chosen.*
9. **Which notes open.** Only a note that is cut off, the one drawn with an ellipsis; a note that
   fits in two lines does nothing when tapped. *What is tappable is exactly what looks
   tappable.*
10. **Several open at once.** Yes — each opens and folds on its own taps, and opening one folds
    no other. Nothing is remembered between visits: every visit opens with every note folded.
    *As the number's graph remembers nothing between visits.*
11. **Line breaks in a folded note.** Kept as written: the fold shows the first two lines exactly
    as they stand open, so folding only cuts and never rewrites.
12. **The count at its edges.** "1 note" for one; with no notes the count is not drawn at all,
    only "No note yet." *"0 notes" beside it would say one fact twice.*
13. **The walk.** Five pictures: (1) a Journal page of about eight notes, short ones whole and
    long ones cut off, the count over the notes; (2) the same page with one long note open and the
    one under it still folded; (3) an open note holding line breaks, in dark appearance; (4) a
    note commitment with no note — "No note yet." and no count; (5) a stopped Journal with its
    kept-until day and "1 note".
14. **A phone step.** None. Opening and folding a note is a tap and a picture, both drivable in
    the simulator; the motion is the platform's.
15. **What a tap lands on.** The whole entry, its day and its text alike, opens or folds a cut
    note. *The bigger target, and a tap on the day that did nothing would read as a miss.*
16. **The layout.** Option B, a card per note — below.

Facts the fact agent found and the answers stand on, for `spec-author` to verify rather than
trust: a note is recorded only on a due day, at most one per day, keyed by the commitment's
identity and the date, so it reads across every era, a rename and a stop and resume; it may hold
line breaks, and blank space around it is trimmed where it is typed; the day screen's row never
says the note, and its sheet shows the whole of it; no look-back row is tappable today; the shipped
requirement *A look-back at a commitment whose days take a note says no line* is the one this
Story replaces.

## Terms landed in CONTEXT.md

- **Look-back** — amended for #276: what a note's page lists, a note **folded** to two lines and
  **opening** in place, and the **count** over the notes, which is never a fraction. No new entry; the
  words *folded*, *opens* and *count* are defined in that amendment rather than given entries of
  their own, since nothing outside the note's page uses them.

## Layout

Option B, a card per note, chosen from three at https://claude.ai/artifact/JUSsgC44jQkmcXFHiB91jA —
*the owner's call, against the designer's recommendation of A, a plain list in the months list's
idiom.* It moves the count out of the head to a heading over the notes, where "Months" stands on a
tick's page, and fits about one fewer note per screen. The wireframe follows, verbatim from the
designer:

```
 ( < )        Journal
 Journal
 Every day
 ┌──────────────────────────────┐
 │ KEPT FROM     1 January 2026 │
 └──────────────────────────────┘
   38 notes                    <- headline, the "Months" heading's place
 ┌──────────────────────────────┐
 │ 21 September 2026            │  <- caption semibold, not uppercased
 │ Quiet day.                   │
 └──────────────────────────────┘
 ┌──────────────────────────────┐
 │ 20 September 2026            │
 │ Three things today:          │
 │ – finished the draft…        │
 └──────────────────────────────┘
```

When a note is open its card grows to the whole text, line breaks kept, and the note below it stays
folded. The empty page ("No note yet.", no count) and the stopped page ("Kept until", "1 note") were
not drawn; they come out the same in every option.

## Left open

None. Every question the frontier raised was answered, the layout included.

One fact the designer turned up, for `spec-author` rather than for the owner: whether a note runs
past two lines depends on the screen's width and the text size, so the seam cannot know which notes
are cut and which open. Only the shell can measure it, and only the walk shows it; a larger text
size makes a different set of notes tappable.
