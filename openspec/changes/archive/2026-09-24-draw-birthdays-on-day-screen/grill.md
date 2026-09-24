# Grill — draw-birthdays-on-day-screen

*13 questions over 4 rounds, the last the layout round, 2026-09-24. Two fact agents, and no fact
was sent to the owner. The Feature grill settled the boundary: the group is headed *Birthdays*,
it comes before every commitment group, it is drawn only while the switch is on and a birthday
falls on the date, and it follows nobody forward (`docs/backlog.md` § Decided, B-059). The grill
of `add-birthday` (#326) settled the birthday, its tick and its store. The grill of
`turn-birthdays-on` (#327) settled the switch. This file repeats none of them.*

## Settled

1. **A birthday row at rest shows the calendar's words and the check, and nothing else.** There
   is no second line: a birthday has no rhythm in words. *The words already carry the name and the
   age. Under the owner's #324 call, a row at rest is its name and its check.*
2. **A birthday whose words are empty is drawn as a blank row with a working check.** *The row is
   the calendar's. Making up a name would put words in the calendar's mouth.*
3. **A birthday on a date later than today is drawn and refuses the tick**, the same as a
   commitment row. *A tick says it was done that day, and one rule covers every row.*
4. **Birthdays appear on the day screen only.** They are not in a look-back, and nowhere else.
   *A look-back is one commitment's, and a birthday is not a commitment.*
5. **Tapping a birthday row works like tapping a commitment row.** One tap ticks, a second tap
   takes the tick back, and neither asks for confirmation. Any earlier date can be ticked,
   however far back. *One gesture for every row. A late wish still belongs to the day.*
6. **With the switch on and the calendar unreadable, the list gets a red line and no Birthdays
   group is drawn.** The line is "Birthdays could not be read.", beside the other stores' lines.
   The calendar is unreadable when EventKit fails, or when access was withdrawn and the app has
   not yet been shown again. *Every other source already fails out loud. Silence would read as a
   day with no birthdays.*
7. **With the birthday store unreadable, the day screen works as it does for an unreadable
   record.** The Birthdays group is still drawn, every row unticked, and every tick refused. A red
   line reads "The birthday ticks could not be read." *It is the same rule applied to the fourth
   store, and today's birthdays stay visible over a damaged tick file.*
8. **A birthday tick that cannot be saved says "Not saved. Try again." on the tapped row**, and
   the line lasts on the same terms as a commitment row's. *Every row gets the same shape of
   failure.*
9. **Birthdays on one day are drawn in order of their words**, sorted by the phone's own
   collation. *EventKit promises no order. The probe saw it return titles alphabetically, but
   nothing guarantees that, and rows must not swap places between reads.*
10. **The walk has five screens, on the simulator.**
    1. The switch turned on.
    2. 20 January 2026: the Birthdays group first, holding "Kate Bell’s 48th Birthday" unticked,
       above the One-offs group. On that date the seeded roster has no commitment rows, because
       it starts on 4 September 2026 and none of the sample birthdays falls between that day and
       today. So this screen does not show the group sitting above commitment groups. The seam
       tests prove that order, and the phone line in 11 shows it. *The walk originally promised
       that order here; the designer found it could not be shown. The owner chose to drop the
       promise over seeding a contact through `scripts/walk.ts`.*
    3. The same row ticked.
    4. Today, with no Birthdays group.
    5. 22 June 2027: John Appleseed's row drawn and not tickable.

    *These are every decision above that a picture can show.* Fact, from the second agent: the
    simulator's sample contacts carry birthdays through EventKit with no seeding. Kate Bell falls
    on 20 January 1978, John Appleseed on 22 June 1980, Anna Haro on 29 August 1985, and David
    Taylor on 15 June 1998. Titles read "Kate Bell’s 48th Birthday", with a curly apostrophe.
    `pnpm run walk` uninstalls the app, which leaves access never asked, so the walk must either
    answer the system prompt or grant access first (`xcrun simctl privacy <udid> grant calendar
    <bundle-id>`). Without either, the app waits on the prompt.
11. **One line is walked on the phone:** turn birthdays on, then page to a day known to be
    someone's birthday. Their row is first, in the phone's own words, and it ticks and unticks.
    *No simulator holds the owner's real contacts.*

## Terms landed in CONTEXT.md

None. *Birthday*, *birthday store*, *switch*, *refused line* and the *Birthdays* group under
**Day view** were all landed by the Feature grill, #326 and #327. This grill named nothing new.

## Layout

Option A, *Like commitments*, chosen from three at
https://claude.ai/artifact/1hmUvWBxgCyCH3hsgcrQVy. *It follows settlements 3 and 5: one rule and
one gesture for every row. The strikethrough is the owner's own ADR-1045 decision 11, and the
option adds nothing to build.* A ticked birthday is drawn exactly as a kept commitment is: grey,
struck through, with the green check. An unticked birthday shows the calendar's words in the label
colour, with no mark. A row on a future day fades as a whole to 0.5. The two red lines from 6 and
7 are caption lines under the date row, beside the other stores' lines. The group sits 12 pt above
the next card, the list's own gap. The wireframe follows, verbatim from the designer; the
commitment rows in it are examples.

```
A · Like commitments
┌─────────────────────────────┐
│ (Today)     (Commitments +) │
│  <     Tue [20 Jan 2026]  > │
│                             │
│  Birthdays                  │
│ ┌─────────────────────────┐ │
│ │ K̶a̶t̶e̶ ̶B̶e̶l̶l̶’̶s̶ ̶4̶8̶t̶h̶ ̶B̶i̶r̶t̶h̶d̶a̶y̶  ✓ │ │
│ └─────────────────────────┘ │
│   (12 pt)                   │
│ ┌─────────────────────────┐ │
│ │ C̶r̶e̶a̶t̶i̶n̶e̶ - Every day    ✓ │ │
│ │ Magnesium - Every day   │ │
│ │ Run - Tue, Thu, Sun     │ │
│ └─────────────────────────┘ │
│  One-offs                   │
│ ┌─────────────────────────┐ │
│ │ New one-off             │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

## Left open

None. Every question the frontier raised was answered. How the day screen reads the calendar
(its seam, and when it reads again) is the design's, and belongs to `spec-author`. The facts it
needs are recorded under 10: find the calendar by its type, and match by
`birthdayContactIdentifier`, never by a stored calendar or event identifier, because both change
when the Birthdays calendar is rebuilt.
