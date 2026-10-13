# Grill — say-days-away

*28 questions over 6 rounds, 2026-10-12, with two fact agents and the designer. Every answer was as
recommended except four: nothing starts out picked, a span carries an optional name, the day screen
says a day is away, and the week strip marks a span's days. Round 3's question on the sheet's button
was asked on a wrong premise — that the define sheet disables a Save — and was asked again in the
layout round; answer 3 holds the corrected one.*

## Settled

1. **A span is one thing.** Days away are remembered as one span over the commitments picked,
   listed on the commitments screen and removed as a whole, rather than only as gaps nothing
   groups. *Asked because nothing stored groups commitments today, and a span's gap looks
   exactly like a pause; "remove a span" in the intent, and #402 moving its ends, both need it.*
2. **Nothing starts out picked.** The person ticks each commitment that is away. *Against the
   recommendation of all kept ones picked: they chose safety against a gap they did not mean.*
3. **The sheet confirms with "Add", greyed out while nothing is picked.** "Add" as the define and
   happening sheets say; disabled as the delete sheets disable "Delete". *A span over nothing
   cannot be said. First asked as "Save, as the define sheet disables its Save", which is not what
   that sheet does: its "Add" is never disabled and refuses on tap.*
4. **A span starting today, over a commitment that already holds a record today**, gives that
   commitment its gap from tomorrow; the others start today. *The same as a stop on a day holding
   a record, which is kept until that day.*
5. **A span that overlaps one already said, on a commitment the two share, is refused**, naming
   the span it overlaps. Overlapping dates over disjoint commitments are allowed. *Two gaps cannot
   cover one day of one commitment.*
6. **A span may carry an optional name**, such as "Mallorca" or "flu". Free text, trimmed, blank
   meaning none, two spans may share a name, no cap beyond what a note allows. *Against the
   recommendation of dates only.*
7. **An end is required; one day is allowed; there is no maximum.** From today onward, the end
   not before the start. *Open-ended days away would be a stop.*
8. **A picked commitment kept from a day after the span's first day is refused**, naming it.
   *Rare, and the span never moves a date the person set.*
9. **Slack does not count a day away as a day left.** The days left in a week count only days the
   commitment is kept on, for every gap. *The question left open by the twenty-sixth grooming
   pass. What a week owes is already gap-aware and the days left are not, so the "Needed today"
   mark stays quiet before days away later in the week. No shipped case changes, since every gap
   was in the past until now. This puts a `day-screen` delta in the Story.*
10. **Changing a commitment keeps its days away.** A rhythm, range or target change made today
    holds from today and after the span; if today is itself a day away, from the day back.
    *Asked because the code today silently erases a future gap on such a change.*
11. **Stopping a commitment takes it out of a span** ahead or under way. The stop is an ordinary
    stop, dated as stops are, or from the day before the span if the span has begun; a span left
    with no commitment goes. *The code today would collapse the future era and erase the gap
    without a word.*
12. **Deleting a commitment for good takes it out of its spans the same way**, and a span left
    with no commitment goes. Taken by the conductor to hold for a span already past as well,
    since a delete removes everything the commitment had.
13. **Removing a span before it starts leaves every commitment exactly as if it had never been
    said**, an every-N-days count running on unbroken. *An interval's resumed era is never alike
    the era before it, so today's mend would not rejoin them.*
14. **Removing a span asks first**: an alert like Stop's, "Remove days away …?" with Remove and
    Cancel. *Saying it again means retyping the name and re-ticking every commitment.*
15. **A span is listed on the commitments screen until its last day passes.** Removing is offered
    only before it starts in this Story; the rest is #402.
16. **A span stays stored after its last day**, only unlisted. *The day screen's line reads it on
    past days, the copy carries it, and #402 needs it for spans under way.*
17. **A copy carries spans**, restored as listed spans. *The only answer that does not make a
    restored span read as a pause; it costs a `restore` delta and a copy form bump.*
18. **A span's name and picks are not changed in this Story.** Before it starts, remove it and
    say it again. *Changing the picks once under way carries #402's record conditions.*
19. **A picked commitment's own row on the commitments screen says nothing of the span.** It stays
    name and rhythm; the listed span names its commitments.
20. **The day screen says a day is away.** One line per span covering the day, above the rows,
    reading the span's name or "Away" without one; no commitment names, since the missing rows
    say which. It shows on every day inside a span, past days included, and on a day where a
    picked commitment's gap started tomorrow because of a record (answer 4). *Against the
    recommendation of leaving the rows out silently; a second `day-screen` requirement.*
    The day screen's week strip marks each day inside a span with a small dot under its number, in
    the secondary colour. *Against the recommendation of no mark; asked in the layout round.*
21. **The look-back does not mark days away.** It draws gap days as it does now; no `look-back`
    delta.
22. **The walk**, said from tomorrow and paged forward, since a walk cannot move the clock:
    1. the empty days-away sheet;
    2. the sheet filled with a name, dates and two commitments picked;
    3. the commitments screen listing the span;
    4. the day screen on a day inside the span — the away line, the dots on the strip, the two
       rows gone, the others there;
    5. an overlap refused, naming the span;
    6. the span removed and the rows back.

    No `phone:` lines: nothing here is a gesture a simulator cannot drive.

Carried from the G1 grill and not re-asked: each picked commitment takes a gap kept until the day
before the span's first day and resumed the day after its last, an every-N-days count beginning
again on the day back; a stopped commitment is not offered; a commitment with a shift whose
either day lies inside the span is refused until the shift is undone; one-offs, birthdays and
happenings show on days away as on any day.

## Terms landed in CONTEXT.md

- **Days away** — amended: remembered as one span, with an optional name; listed until its last
  day passes and kept after it; said on the day screen; taken out of by a stop or a delete; the
  "stopped on its first day" wording corrected to kept until the day before.
- **Slack** — amended: the days left count only days the commitment is kept on.

## Layout

Option A, *Beside Happenings*, chosen from three at https://claude.ai/artifact/EhYXPjJa7Gv83Aetz2n6vd —
*every piece is a pattern the app already ships, and + still defines a commitment in one tap.*
Two changes to it from the layout round: the sheet's button reads "Add", not "Save" (answer 3), and
the week strip carries a dot under each day of a span (answer 20), which the mockup does not draw.
A span is removed by a swipe on its row and the alert of answer 14. The wireframe follows, verbatim
from the designer.

```
A — Beside Happenings
Commitments (scrolled to foot)        Sheet                              Day screen, Thu 15 Oct
[<] Commitments          [⇅][+]       [Cancel]  Days away  [Save]        [Today]              [≡][⚙]
 | Yuno - 5x a week          > |      | Mallorca                 |      Thursday
 | Weight - Every day        > |      | First day    [13 Oct 2026] |    15 October 2026
 Stopped                              | Last day     [18 Oct 2026] |    < 12 13 14 (15) 16 17 18 >
 | Nothing has been stopped.   |      Commitments                        Mallorca            ← bare line
 Days away                            | ○ Creatine - Every day      |    | Creatine - Every day    | (faded)
 | Mallorca - Tue 13 Oct – Sun 18 Oct | ○ Magnesium - Every day   |      | Magnesium - Every day   |
 |   Gym, Run                  |      | ● Gym - Mon, Wed, Sat       |    | Yuno - 0/5x a week      |
 | New days away               |      | ● Run - Tue, Thu, Sun       |    | Weight - Every day    > |
 Happenings                           | ○ …                         |    ( New one-off )
 | Augenmigräne …              |
 (no span: the card holds only "New days away"; swipe a span → trash → "Remove days away …?")
```

Strings the mockup marks as example wording, and leaves to `spec-author`: the card heading and its
"New …" button, the sheet's title, the name placeholder, the date labels, the span's dates in words
and the overlap refusal. The designer used the app's shipped date form ("Tue 13 Oct") and the
"Reason (optional)" placeholder pattern.

## Left open

None. Every question the frontier raised was answered, the layout round included.
