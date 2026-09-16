# Grill — look-back-at-a-quota

*11 questions over 3 rounds, 2026-09-16 — the third the layout round.*

Story #273, under `FEAT: look-back` (#271), `EPIC: Looking back` (#269). Intent: on a
weekly-quota commitment's look-back page, list its weeks newest first as kept days out of its
quota, through today or the day it was kept until. Blocked by #272 `look-back-at-a-tick`, which is
merged: the page, the seam (`CommitmentsScreen.lookBack(at:)`, `LookBack`, `LookBack.Line`), the
chain of eras, the rhythm-change line and the whole all exist, and #272's `grill.md` 9 and 10 left
a quota era's months saying no fraction and a chain holding one saying no whole, for this Story.

## Settled

1. **A week's line says its span, with short month names.** "9–15 Mar 2026"; across a month
   "30 Mar – 5 Apr 2026"; across a year "29 Dec 2025 – 4 Jan 2026". Three-letter names, "Sep"
   not "Sept". *The recommendation was the span in full names; the owner took the span and asked
   for the short names — two dates on one line is what they buy room for.* A week is Monday
   through Sunday, `CONTEXT.md` § *Week*, and the span is the calendar week whatever days of it
   the era holds.
2. **The short names stay on the week span.** Month lines keep "March 2026" and the head keeps
   "1 January 2026", as the shipped requirement fixes them. *One word has the room; two dates do
   not.*
3. **A partial week counts against the full quota.** The week the commitment is kept from
   mid-week, the week in progress today, and the week a stopped commitment was kept until
   mid-week each say kept days out of the whole quota, "1/3". *The week is the unit the quota is
   owed in, nothing is scaled when a week turns, and the week in progress reads as the day
   screen's row already does.* Unlike a tick's month in progress, the denominator never shrinks.
4. **The whole for a quota is the sum of the lines.** Kept days out of the sum of the weeks'
   quotas, "22/30" over ten weeks of three. *One rule for the whole across both kinds, and it is
   what the requirement already says the whole is.* Standing is never a cap (`CONTEXT.md`
   § *Standing*), so a week can say "4/3" and a whole can say "31/30"; that is the count, not a
   defect. This replaces #272's "no whole where any era is a quota".
5. **A mixed chain lists each era in its own unit.** A weekday-set era's months and a quota
   era's weeks, with the rhythm-change line between them where it already sits; the month that
   straddles the boundary counts only the days through the older era's kept-until, the week that
   straddles it counts only the days from the newer era's kept-from, against the full quota (3).
   The whole is every line's numerator over every line's denominator, month lines and week lines
   alike. *The change line already marks the switch, and nothing on the page says nothing.* This
   replaces #272's "a month any quota era touches says no fraction".
6. **A week straddling two quota eras appears once, against the newer era's quota.** 3x a week
   until Tuesday 3 March and 5x a week from Wednesday 4 March: the week 2–8 March says every kept
   day of the week out of 5, "2/5", and the rhythm-change line sits above it as a tick's line
   sits above the month the newer era is kept from. *Two quotas do not sum; the week is one unit
   and the newer rule is the one it ends on.* The reverse boundary, a quota era giving way to a
   weekday era mid-week, is 5: the quota's last week says its kept days out of its quota below
   the line, the weekday era's first month above it.
7. **The seam keeps two strings per line; `design.md` names the one join the shell may make.**
   #272's G7 left this question for this Story (`docs/open-questions.md` § *A look-back's line is
   two strings*): the rhythm-change line is composed by the shell as rhythm, a middle dot and the
   day, and no requirement covers the join. A `design.md` sentence saying what the shell may join
   and with what separator closes it, and the month and week lines stay two columns. *One string
   per line would make the shell split a month or a week from its fraction to draw its columns.*
   The entry leaves `docs/open-questions.md` on this branch once `design.md` carries the
   sentence — the conductor's edit after `spec-author` returns, since that file is outside the
   folder and outside `spec-author`'s write set. The `MonthTally` tidy the same entry names is a
   `tasks.md` box for the implementer.
8. **The walk — three pictures, no `phone:` line.** A kept quota's page with several weeks and
   the week in progress on top; a stopped quota's page with kept-until in the head and its last
   partial week; a mixed chain with weeks above the rhythm-change line and months below it. *A
   week past its quota is the same row a week deeper.* Every step is a tap or a push a simulator
   drives.

**Consequences the facts settle, not asked because no preference is involved.**

- A quota era's weeks run unbroken from the week holding the era's first counted day through the
  week holding its last, newest first, exactly as a tick's months do; a quota is due every day
  (ADR-1015) and its number is one to seven, so no week says "0/0". A week the era holds no kept
  day of says "0/3".
- Kept is `History.isKept(_:on:)` day by day, as #272 counts a tick's months, so that a day is
  counted against the era that holds it and a chain's older era counts its own days. Whether the
  week's numerator is that walk or `History.standing(for:through:)` is `design.md`'s; the
  answer must be the same, and `standing` is asked *of a date* and counts the week's days through
  it.
- Counting runs through today for a kept commitment and through kept-until, inclusive, for a
  stopped one; a commitment kept from a day after today says no line and a whole of "0/0", as the
  shipped requirement already says for any kind.
- The head is unchanged: the newest era's rhythm in words, "3x a week", the earliest era's day
  kept from, and kept-until where the roster has stopped keeping it.
- A number's, a note's and a total's pages still say no line and no whole (#274, #276, #275).
- The week's words are the kit's own English, locale-independent, as the month names are
  (ADR-1022): a second internal table beside `LookBackWords`' twelve full names, three letters
  each. The en dash inside a span and the spaced en dash between two dated ends are what the
  owner's examples show; the exact separators are `design.md`'s and the delta fixes them so
  they are testable, as the shipped requirement fixes the month and the day.
- `LookBack.Line` gains a week case beside `.month` and `.rhythmChanged`; a mixed chain's `lines`
  hold both in one list. Its shape is `design.md`'s.
- Today is the one the commitments screen is already handed (`CommitmentsScreen(asOf:)`), never
  a clock read in the kit (ADR-1004).
- ADR-1047's budgets apply. No persisted type changes, so no `### Migration`. No `commitment`
  delta: the ninth pass made one on this Story a stop at G4, and #262 is still in flight on that
  capability.

**ADR.** None looks owed. Decisions 3, 5 and 6 are cheap to reverse and follow the rules already
recorded for a tick; decision 4 is the whole ADR-1045's 2026-09-15 amendment already stands for,
extended to a quota — `spec-author` amends that ADR's text where it says a quota's whole says
nothing, rather than writing a new one.

## Terms landed in CONTEXT.md

**The conductor named these; `spec-author` lands them.** No new term: the week, the standing, the
era and the look-back all exist. Two amendments.

- **Look-back** — amended. A quota era's page lists its weeks, newest first, each saying its span
  in short month names and its standing out of its quota, "2/3", never capped; a partial week
  counts against the full quota; a chain mixing kinds of era lists each in its own unit with the
  rhythm-change line between; a week two quota eras share is judged by the newer; and the whole
  sums every line, month or week. Replaces the 2026-09-15 amendment's "say nothing yet".
- **Week** — amended. How a week is said on a look-back: its span, "9–15 Mar 2026", the one
  place in the app a month name is short.

## Left open

None. Every question the frontier raised was answered; the owner departed from the recommendation
once (1, the short names) and that departure raised one question of its own (2), which was asked
and answered. Every other edge the facts turned up is a consequence of a decision already made
rather than a preference, and is listed above so `spec-author` does not re-decide it. The layout
is § *Layout* below, appended after this section was written.

## Layout

**Option A**, one headed table with the heading naming the unit, chosen from three at
https://claude.ai/artifact/5kXBn8onr2uAYd4jtNKZ8k — *it is the shipped page with week rows added
to its table; a week span and a month name already look different, and the change line between
them says when.* Two more answers from the same round, both shell wording and no requirement:

- The heading says "Weeks" where every line is a week, "Months" where every line is a month, and
  **"Months and weeks"** where the chain mixes.
- **The dark-mode cards ride this Story.** Today both cards on the page are filled with
  `.background` over the grouped background, which resolve to black on black, so the walk picture
  on PR #289 shows them vanished. The fix is a line in `LookBackView` — the secondary grouped
  background — and it is a `tasks.md` box under the shell section, not a chore. The mockup's dark
  phones assume it.

Noted by the designer, not decided here: a quota page is long — a year is about fifty-two rows —
and nothing is pinned, so the whole scrolls away where a tick's twelve rows kept it in sight. No
option fixes that without duplicating a figure or hiding part of the record; it is a later layout
question and this grill leaves it as one, in `docs/open-questions.md` once the page exists.

The wireframe follows, verbatim from the designer. The example the designer drew for a mixed chain
has the weekday era newest and the quota era older, the reverse of Settled 5's worked example; the
layout is the same either way, and the walk's third picture (Settled 8) shows the quota era
newest.

```
Option A — one headed table, the heading names the unit

+------------------------------------------+
| <                                        |  nav bar: back only
|                                          |
| Gym                                      |  .largeTitle.bold      name
| 3x a week                                |  .subheadline, dimmed  rhythmInWords
|                                          |
| +--------------------------------------+ |
| | KEPT FROM           1 January 2026   | |  dates card, unchanged; a KEPT UNTIL
| +--------------------------------------+ |  row below it only where stopped
|                                          |
| +--------------------------------------+ |
| | THE WHOLE                            | |
| | 24/33                                | |  .title, monospaced digits   whole
| +--------------------------------------+ |
|                                          |
|  Weeks                                   |  .headline. "Weeks" where every line
|                                          |  is a week, "Months" where every line
|  9–15 Mar 2026                      2/3  |  is a month, "Months and weeks" where
|  --------------------------------------  |  the chain mixes
|  2–8 Mar 2026                       3/3  |
|  --------------------------------------  |
|  23 Feb – 1 Mar 2026                4/3  |  over quota is the same row
|  --------------------------------------  |
|  16–22 Feb 2026                     1/3  |
|  --------------------------------------  |
|  ... one row per week, newest first ...  |
|  --------------------------------------  |
|  29 Dec 2025 – 4 Jan 2026           1/3  |  the part week at the start
|  --------------------------------------  |
+------------------------------------------+

a mixed chain, the lines only:

|  Months and weeks                        |
|                                          |
|  March 2026                         3/5  |  the newer, weekday era
|  --------------------------------------  |
|  ======================================  |
|        Mon, Wed, Sat · 4 March 2026      |  .rhythmChanged, drawn as it is today
|  ======================================  |
|  2–8 Mar 2026                       1/3  |  the older, quota era
|  --------------------------------------  |
|  23 Feb – 1 Mar 2026                3/3  |
|  --------------------------------------  |
```
