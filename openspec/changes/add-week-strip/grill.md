# Grill — add-week-strip

*6 questions over 3 rounds, 2026-09-28, the last the layout round; carrying 4 answers from the B-065
grooming pass the same day (6 questions over 2 rounds), which are marked as such.*

## Settled

1. **What the strip marks.** The day being shown and the today, and nothing else: no kept, missed
   or due mark on any day. *From the B-065 pass. Seven days in a row is the shape a streak is drawn
   in, and the product's first principle is that nothing congratulates you.*
2. **The chevrons.** They leave in this Story, and ADR-1042's sentence naming them as what depicts
   the day swipe is amended here; the strip is what shows the swipe now. The swipe itself stays.
   *From the B-065 pass. One control on the head, not two ways of moving one day.*
3. **Which week.** The strip holds the week the shown day lies in, Monday to Sunday (`CONTEXT.md`
   § *Week*). Paging it to another week is Story #347's, blocked by this one. *From the B-065 pass,
   where the owner chose paging and the split followed: paging adds a second horizontal gesture
   only the phone can judge.*
4. **The term.** **Week strip**, landed in `CONTEXT.md` at the B-065 pass. *From the B-065 pass.*
5. **Days before the reach.** A day in the strip earlier than the reach's earliest day is drawn,
   faded as a row that offers nothing is (ADR-1045 decision 5), and takes no tap. *The strip stays
   seven days at every week; a missing Monday would read as a gap, not a boundary.*
6. **A tap's motion.** A tap on a strip day replaces the day where it stands, with no slide, as the
   `Today` button and the day picker do. *A control that can jump any distance must not sometimes
   slide (`CONTEXT.md`, the 2026-09-10 amendment to day navigation).*
7. **The date row stays**, above the strip: the day's name, then the **date row**, then the strip,
   then the rows. It still says the month and year and still opens the calendar. *The strip says
   neither the month nor the year, and the date row is the calendar's handle.*
8. **The week turning under a swipe.** The head does not move with the swipe; when a swipe carries
   the day across Sunday into Monday, or back, the strip redraws in place as the new week once the
   day lands. *The icons travel, the dock stays. Any motion of the strip itself is #347's to settle,
   since paging is its subject.*
9. **The walk.** Five pictures: today with the strip; a tap on an earlier day of the same week; a
   swipe from Sunday onto Monday, the strip showing the next week; a calendar pick into another
   week; the week holding the earliest day, with the days before it faded. One `phone:` step: the
   swipe across a week boundary, and whether the strip reads as the swipe's depiction now that the
   chevrons are gone. *The owner's choice of the recommended set.*

### Consequences drawn from rules already on the record, not asked

- **The shown day's own cell is not a target.** A tap there has nowhere to go, and a screen draws
  as a target only what it offers (`CONTEXT.md` § *Offered*).
- **A tap on a strip day is a day move like the others.** It commits a focused one-off field for
  departure first, exactly as a swipe, `Today` and the day picker do, and it is bounded by the reach
  exactly as the day picker is. Days after today are reachable, as the reach is open forward.

### Facts the answers rest on

- The day swipe is attached to the paged lists only, not to the head above them
  (`ContentView.swift`, `pagedDayContent`'s `.simultaneousGesture(daySwipeGesture…)`), so a strip in
  the head takes taps without contesting the swipe.
- Every commitment the shell seeds is kept from Friday 4 September 2026, so on a fresh install the
  week of 31 August to 6 September has four days before the reach — what the walk's fifth picture
  shows.
- The seven dates cannot come from the shell: `CalendarDate.weekday`, `CalendarDate.adding(days:)`
  and `WeekQuota.monday(of:)` are all internal to `DayByDayKit`. The seam's shape is `spec-author`'s.

## Terms landed in CONTEXT.md

- **Week strip** — at the B-065 pass (on `main` since #344).
- **Date row** — at this grill, for what `chore/day-as-title` (PR #345) drew.
- Amended at the B-065 pass: **Day picker** (a month calendar, opened from the date row; the
  "Epic #1 excludes a grid" premise withdrawn), **Day title** (no longer drawn), **Week** (the week
  strip consults it too).

## Left open

None. Every question the frontier raised was answered. What is left is `spec-author`'s rather than
the owner's: the seam's shape, and the words of ADR-1042's amendment.

## Layout

Option B, the named-day capsule, chosen from three at
https://claude.ai/artifact/6HeCvdyn4XF91hycx5t2f3, **with one change taken from option A: each day
says a single letter, "M T W T F S S", not "Mon".."Sun".** *The owner: "I love B, only one thing I
would like to have from A (number 2) -> just one Letter instead of 3 per day. All the rest should
stay with B".* So the date row moves to the leading edge now that no chevrons flank it; the shown
day is a capsule round its letter and number, in the text colour, blue where it is the today; the
today alone is a blue letter and number. The seven letters are words the app owns, in fixed British
English (ADR-1022), and a set it did not have before; two T's and two S's was the designer's stated
cost, and the owner took it.

The wireframe follows, the designer's option B with its words line changed to the letters:

```
┌───────────────────────────────────┐
│ (Today)            (Commitments +)│  Today only when not on today
│ Tuesday                           │  large title
│ 29 September 2026                 │  date row: leading, blue, opens calendar
│  M  ┌───┐  W    T    F    S    S  │  single letter over the day of the month
│  28 │ T │  30   1    2    3    4  │  shown day: capsule round both lines,
│     │29 │                         │    text colour, inverted text
│     └───┘                         │  today (Thu 1): letter and digit blue;
│                                   │    on today the capsule is blue
├───────────────────────────────────┤
│ Creatine - Every day              │
│ Magnesium - Every day             │
│ Run - Tue, Thu, Sun               │
│ Yuno - 0/5x a week                │
│ Weight - Every day              > │
│ One-offs                          │
│ New one-off                       │
└───────────────────────────────────┘
```

Days before the reach are drawn at half opacity, the same in every option, so the mockup does not
draw that week.
