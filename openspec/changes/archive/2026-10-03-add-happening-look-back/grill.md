# Grill — add-happening-look-back

*14 questions over 4 rounds, the last one the layout round, 2026-10-03, with one fact agent. Every
answer was the recommended one.*

The Feature grill of B-076 already settled what the page is: reached from the commitments screen,
the occurrences newest first with their day, time and note, and a count per calendar month with
empty months included. This grill settled that page's edges.

## Settled

1. **The first month.** The months start at the month of the earliest occurrence noted. *A
   happening keeps no date of its own, and because occurrences can be noted on past days, the day
   one was made would say little; storing one would mean a new field and a migration.*
2. **The last month.** The months run through the current month, a month in progress included.
   *A run of empty months since the last occurrence is the reason to look: "none in three months".*
3. **A happening with nothing noted.** The page says its name and one line, "Nothing noted yet.",
   with no months, no count and no "since". *With no first occurrence there is no month to start
   from.*
4. **Order within a day.** Newest first means the latest time first, and an occurrence with no time
   comes after its day's timed ones. *An unknown time goes at the edge of the day, as the day screen's
   happening row puts "no time" last.*
5. **One count across everything.** The page gives one count of every occurrence, "14 times", or
   "1 time" for one: a count, never a rate or a percentage. *The note page's "38 notes" is the
   precedent.*
6. **How the page is reached.** By tapping the happening's row on the commitments screen, as a
   commitment's row opens its look-back. Renaming stays on the swipe. *The row has no tap action
   today (`CommitmentsView.swift:480-491`), so nothing is displaced.*
7. **The head.** The happening's name, then "since" and the day of the earliest occurrence, said as
   a look-back says a day: "since 4 March 2026". *The total needs a span to be read against. A
   happening has no rhythm and no kept-from day, so neither appears.* The layout round settled
   how it is drawn: as a labelled row, "Since | 14 July 2026", in the same head card a commitment's
   page uses for "Kept from". See 11.
8. **Month order.** The month counts run newest first, this month at the top. *That is the same
   direction as the occurrences beside them.*
9. **Long notes.** An occurrence's note is folded to its first two lines, and a longer one opens in
   place when tapped, as on a note commitment's page. Opening one changes nothing; an occurrence is
   still changed only on the day screen. *One long note would otherwise push a month off the
   screen.*
10. **The walk.** Three screens. (1) The commitments screen with a happening listed. (2) That
    happening's look-back over about three months, one of them empty, with one day holding two
    occurrences, one timed and one with no time, and one occurrence carrying a note. (3) The
    look-back of a happening with nothing noted. There are no `phone:` lines, because a tap is
    nothing a simulator cannot show.
11. **How the head draws "since".** As a labelled row in the head card, "Since | 14 July 2026",
    the card the commitment pages draw for "Kept from". It is not a line of text under the name.
    *Every look-back's head then looks alike, and the shell already draws that card.*
12. **A month with none.** It says "0 times", in the same form as "2 times" and "1 time". *The
    column then reads as one list of counts.*
13. **An occurrence with no time.** Where its time would stand, it says "no time". *These are the
    day screen's happening-row words, so an occurrence reads the same in both places.*

Fact found, not asked: no current look-back function fits a happening, because `LookBack` requires a
rhythm and a kept-from day (`LookBack.swift:6-19`, `CommitmentsScreen.swift:1996`). Choosing the
seam is spec-author's job.

## Terms landed in CONTEXT.md

- **Look-back**, amended: a look-back also answers a happening, and a happening's page is defined.
  No new term was needed.

## Layout

Option A, "Two lists", chosen from three at https://claude.ai/artifact/25ZuEcDrHDgG2TMkQaGxKQ.
*It is built only from layouts the owner already has: the tick page's Months table and the note
page's cards. A run of empty months reads at a glance, with no notes in between.* The wireframe
below is the designer's, verbatim, except for one line. Settled 11 replaced the "since" line under
the name with a labelled row in a head card, drawn as the commitment pages draw "Kept from".

```
A · Two lists
┌──────────────────────────┐
│ (‹)                      │
│ Kopfweh        large tit.│
│┌────────────────────────┐│
││Since     14 July 2026  ││   ← settled 11; the mockup drew "since 14 July 2026  (sec)" here
│└────────────────────────┘│
│                          │
│ Months         headline  │
│ October 2026     2 times │
│ ──────────────────────── │
│ September 2026   0 times │
│ ──────────────────────── │
│ August 2026      3 times │
│ ──────────────────────── │
│ July 2026         1 time │
│ ──────────────────────── │
│                          │
│ 6 times        headline  │
│┌────────────────────────┐│
││2 October 2026     18:40││
││Behind the left eye ... ││
││  (2 lines, tap opens)  ││
│└────────────────────────┘│
│┌────────────────────────┐│
││2 October 2026   no time││
│└────────────────────────┘│
│┌────────────────────────┐│
││28 August 2026     07:15││
││Woke up with it.        ││
│└────────────────────────┘│
└──────────────────────────┘
Empty:  (‹) / Kopfweh / Nothing noted yet.
```

The designer also noted that once the happening row on the commitments screen becomes a link, it
gets the platform's grey chevron. Walk screen 1 shows it.

## Left open

None. Every question the frontier raised was answered, including the three wording questions that
drawing the layout turned up.
