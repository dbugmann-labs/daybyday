# Grill — shift-an-interval-day

*8 questions over 4 rounds, two fact agents and the designer, 2026-10-08, on top of what the twenty-fifth
grooming pass's Feature grill settled for B-054 on 2026-10-06 and what #392's grill settled for the
weekday-set and day-of-month half.*

## Settled upstream, and not re-asked

From the Feature grill (`docs/backlog.md` § *Decided*, B-054; `CONTEXT.md` § *Shift*):

- An every-N-days due day is shifted to **a day between the due days either side of it**, and **its
  count runs on from there**. This is what replaces restarting, which #394 retires; restarts already
  made stay as made.
- Made from the shifted day's row; refused while ticked; the day it came from keeps a row saying
  where it went and stops being due; counted due where it landed; shifted again freely, its own
  date included.

From #392's grill (`openspec/changes/archive/2026-10-08-shift-a-due-day/grill.md`), carried to
every N days unchanged because nothing in them is shape-specific: every kind can be shifted; a day
holding any record cannot be shifted; a gap day is not free; a rhythm, range or target change and a
stop are refused while any shift has an end after today, saying "Shift its day back first."; the
landing row says where it came from and the origin row where it went, offering nothing; reached by
a long press, "Shift to" with a submenu of the free days, and no Shift item where nothing can be
shifted.

## Settled

1. **A shift is refused while anything sits after the shifted day** — a record on a later day, a
   later shift, a later change. Take it back first. *A shift fixes one slip and never quietly
   undoes anything; the common case, the latest due day, is always allowed. Chosen over restart's
   rule, which replaces later eras and refuses only for records, and over a count that runs on only
   until the next change.*
2. **An era's first due day shifts back no further than the era's own first day** — the day it is
   kept from, the change day, the resume day. *A shift stays inside the stretch that shares one
   count; it never crosses into the previous era.*
3. **A range-only or target-only change no longer restarts an every-N-days count** — fixed in this
   Story, the owner's call against the recommendation to record it as a gap of its own. *Today any
   change that puts a new era on anchors the interval to the change day, and no scenario says so.*
4. **Every change but N keeps the count running** — kind, range and target alone. A change to N
   still starts the new count on the change day, as the shipped scenario says. *The count is the
   rhythm's, and what a day records has no bearing on it; a badly placed first day under a new N
   can now be shifted.*
5. **Eras a range, target or kind change already re-anchored stay as made.** The fix applies to
   changes made from now on. *As restarts already made stay; a repair would move due days under
   records already kept.*
6. **The walk is eight states, light, no `phone:` line**, on the day-one Nails, every 4 days, and
   Contact lenses, every 14, on the real date — the app has no clock override: (1) the long-press menu on Nails' due row with its
   submenu of the days either side; (2) the landing day's row saying where it came from; (3) the
   origin paged back, saying where the day went and offering nothing; (4) the day N after the
   landing, Nails due; (5) the old next due day, without Nails; (6) an earlier due day's menu with
   no Shift item; (7) the day shifted back, both rows as they were; (8) the long-press menu on
   Lenses' due row with its 26 days. *4 and 5 are what this Story adds over #392, and 8 is the only
   picture of a long submenu and a repeated weekday; the kind-change fix is the seam tests', since a
   picture cannot show a day that did not move.*
7. **An every-N-days shift names a day by weekday and date — "Tue 13 Oct"** — in the "Shift to"
   submenu and in the landing and origin rows ("from Tue 13 Oct", "to Tue 13 Oct"). #392's
   weekday-alone words stay as shipped for a weekday set and a day of the month. *Asked in round 4,
   after the designer found it: Lenses' 26-day window repeats each weekday up to four times, so
   "Tue" alone is ambiguous from N = 5; the same words for every N rather than a date only where
   ambiguous, and in the app's fixed words with the short month names it already holds (ADR-1022).*

## Facts the answers rest on

Found by dispatched agents on `origin/main` at c6b119d, not asked:

- An interval is due where `start.days(until:)` is zero or more and divisible by N
  (`Schedule.swift:54-59`). A new era's interval is anchored to the era's own first day
  (`CommitmentsScreen.swift:1349-1351`); a kind, range or target change puts a new era on
  (`CommitmentsScreen.swift:1312`), which is the re-anchor Settled 3 fixes.
- A restart is stored as a plain era starting on the picked day, and one picked before a later era
  replaces every later era (`commitment/spec.md:6650-6652`). A resume after a gap restarts the count
  from the resume day, deliberately (`commitment/spec.md:7132-7133`).
- **#392's shift cannot carry an interval as it stands.** It is a map of origin to landing that
  moves exactly two dates (`Commitment.swift:57, 133-146`); `Roster.shift` refuses every N days
  (`Roster.swift:833-837`); and the one-Mon–Sun-week rule is enforced in three places — when made,
  when the roster store is read, and when the record store is read (`CommitmentCoding.swift:445-449`,
  `RosterDocument.swift:215`, `CommitmentCoding.swift:124`; `commitment/spec.md:8254-8258`,
  `record/spec.md:22-23`). An every-4-days window crosses a week often. ADR-1066 rejected a
  one-week era as the way to store a weekday shift; how an interval shift is stored is
  `spec-author`'s to decide.
- The requirement excluding every N days is `commitment/spec.md:8059-8062`, with its refusal
  scenario at 8112-8121 ("Contact lenses", every 14 days). The day-screen offer walks the seven
  days of the week (`DayScreen.swift:1398-1416`) and labels each by weekday alone; the row words
  "from Mon"/"to Tue" are `DayView.Row.rhythmInWords` (`DayView.swift:139-144`).
- A past due day can be recorded however far back; a future one cannot, but can be shifted
  (`day-screen/spec.md:2513-2516, 7294-7295`). So a past due day can have records after it — which
  Settled 1 turns into a refusal.
- The owner's every-N-days commitments are Nails, every 4 days, and Contact lenses, every 14 days
  (`docs/backlog.md:37-38`) — a window of 6 and 26 days respectively. The day-one seed holds both,
  Nails from 6 Sep and Lenses from 5 Sep 2026, kept from 4 Sep, so the kept-from day is not always
  due (`ContentView.swift:23-43`).
- For #394, not this Story: `CONTEXT.md` § *Restarting* contradicts the spec in three places — the
  start date, a restart reaching behind another, and records carried over.

## Terms landed in CONTEXT.md

None. **Shift** landed at the Feature grill on 2026-10-06 and covers this Story.

## Layout

No layout question: the designer returned *no layout question here*. The rows a shift touches are
#392's option A, the words in the rhythm's place, and the long-press "Shift to" submenu is #392's,
both unchanged — `openspec/changes/archive/2026-10-08-shift-a-due-day/grill.md` § *Layout* holds
the wireframes, which this Story builds to. What changes is the submenu's length and its words,
Settled 7; a submenu grouped by week, the one answer that would have needed a mockup, was not
chosen.

## Left open

None. Every question the frontier raised was answered, the designer's included.
