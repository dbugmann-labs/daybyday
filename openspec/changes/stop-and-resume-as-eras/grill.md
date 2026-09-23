# Grill — stop-and-resume-as-eras

*18 questions over 4 rounds, 2026-09-23.*

## Settled

1. **The day a resume begins from.** The day of the resume. The swipe stays one tap, with no
   picker and no confirmation. *A forgotten resume leaves days in the gap owing nothing, which is
   the gentler mistake. The backlog's Decided line already said "from the day of the resume".*
2. **The resumed era's rhythm.** The same rhythm, range and target as the stopped era.
   *Changing the rhythm after resuming is a separate act that already exists, and asking for it
   at resume would turn a tap into a form.*
3. **An every-N-days count across a gap.** It begins again on the resume day, so that day is
   due. *This is what a restart already does. A grid from before a break means nothing to the
   person.*
4. **A weekly quota in a week cut by a stop or resume.** Pro-rated to the days held. *The owner
   chose this over the recommended "whole quota, as shipped". Items 11, 14 and 18 follow from
   it.*
5. **A record on the stop day.** When the stop day already holds a record, the stop is kept
   until that day rather than the day before, so the gap is a day shorter and the record stays
   drawn. *The owner chose this over "kept, never shown" and "erased at resume". It walks back the
   #145 price, a morning tick on an afternoon stop going undrawn, for exactly the days that paid
   it.*
6. **Stop and resume on the same day.** They collapse into one era, and the stop is undone as
   though it had never been made. *#305's rule: a commitment changed back on the day it was
   changed is the commitment it was that morning. It follows that a stop kept until its own day
   by a record (item 5) and resumed the next day also leaves no gap, and so is one era again.*
7. **A stop on the day an era began** (#305's Left open). If the new era would hold no day it is
   dropped, and the older era is the one stopped. If the stop day holds a record, the stop is
   kept until that day (item 5) and the new era, now holding a day, is kept. *The owner's words:
   "if the era is empty, then the older era stops, but if a commitment in the new era is kept and
   the stop ends 'today', then the new era is kept".*
8. **How a look-back draws the gap.** The same as any day that is not due, with no mark and no
   label. *A gap reads as a quiet stretch, which is what a pause is. #300 took every between-era
   mark off the page.*
9. **What counts as a record for item 5.** Any record: a tick, a number or a note. *One rule with
   nothing to explain, and a note is also something the person did that day.*
10. **A record taken away after the stop.** Kept-until does not move back. *This is the shipped
    rule that a day once given does not move while the commitment stays stopped. The row stays
    for that day with nothing on it and is gone the next day.*
11. **Rounding a pro-rated quota.** The quota times the days held over seven, rounded to the
    nearest whole number. *No tie can occur. Floor would let a 1-a-week commitment kept for six
    days owe nothing. Ceiling would make one kept day of a 3-a-week commitment owe 1.*
12. **The day screen's standing.** It shows the same pro-rated quota as the look-back. *If the
    two screens disagree about what a week owed, one of them is wrong.*
13. **A commitment defined and stopped on the same day, holding no record, then resumed on a
    later day.** The resumed era replaces its empty only era, and it is kept from the day of the
    resume. *This is collapse applied again. There is no older era for item 7 to fall back to.*
14. **Which part weeks pro-rate.** All of them: the week kept from, the week kept until, a week a
    gap begins or ends in, and a week a rhythm changes in. A week two quota eras share owes each
    era's part of its own quota, summed and rounded once. The days held include days still to
    come, so the week in progress is not a part week for being in progress. *One shape gets one
    rule. The owner took this knowing it overturns six shipped look-back scenarios and their six
    tests (look-back spec :162, :235, :250, :258, :267 and the whole at :131; the requirement at
    :199).*
15. **Ticks from before the stop in a resumed week.** They count toward the day screen's
    standing as they do in the look-back. Example: 3 a week, ticked Monday, stopped Tuesday,
    resumed Thursday; the standing reads 1 of 2. *This extends item 12 from the quota to the
    count. Today the standing drops a tick made before its era's kept-from, although numbers and
    notes are counted.*
16. **A part week that rounds to owing nothing.** Its week line is still drawn, owing 0, and a
    tick made in it is visible. *A missing line would read as a gap where the commitment was
    kept.*
17. **The row a record keeps on the stop day** (item 5). It is drawn as it always is, with no
    stopped mark. *The commitments screen moves the commitment under "Stopped" at once, which is
    the confirmation #145 wanted. The row is gone the next day.*
18. **A week lying wholly inside a gap.** Its week line is drawn in the look-back, "0/0",
    unbroken like the months. *A skipped span looks like a defect, which is the shipped reason
    months run unbroken.*

**Found as facts, not asked.** A resume today clears kept-until and adds no era, so a commitment
resumed before this ships has already lost its gap and there is nothing to recover. A commitment
stopped when this ships gets the new behaviour on its next resume. A record already standing on a
gap day stays in the store and is shown nowhere, which is what records past kept-until already do.
Both quota numbers are built in DayByDayKit and the shell only draws the strings, and no shipped
stop or resume copy promises anything this Story changes. So the Story stays behind the seam: it
has no walk and no layout round, unless writing the delta finds a change in `src/DayByDay/`.

## Terms landed in CONTEXT.md

- **Gap**: the days between a stopped era's kept-until and the next era's kept-from. Nothing is
  owed there and no row is drawn.
- **Part week**: a week a weekly quota holds on only some of its days, owing the quota in
  proportion.
- Amended in place: **Era** (a stop ends one and a resume begins one), **Kept until** (a stop day
  holding a record is kept), and **Look-back** (the part-week and two-quota sentences retired,
  and the gap drawn).

## Left open

None. Every question the frontier raised was answered. Two things are for `spec-author` rather
than open. ADR-1023, whose taking-up-again paragraph this changes, is to be amended in place.
The part-week rule reverses a shipped, argued decision (#273), which is surprising without its
context and so is ADR-worthy wherever `spec-author` finds the whole-quota rule recorded.
