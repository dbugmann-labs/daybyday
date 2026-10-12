# Grill — add-birthdays-screen

*10 questions over 3 rounds, 2026-10-12, the last the layout round. Two fact agents, and no fact
was sent to the owner. The Feature grill of B-078 settled the boundary: a **Birthdays screen**,
reached from the commitments screen, lists everyone the phone's birthday calendars hand over the
coming year, soonest first from today. It is the place a birthday is seen coming, while the day
screen still draws one on its day only and nothing notifies. It is not drawn at all while
birthdays are off (`docs/backlog.md` § Decided, B-078; `CONTEXT.md` § *Birthdays screen*). The
present ideas it will hold are `FEAT: present-idea` (#405), from #408 on. This file repeats none
of that.*

## Settled

1. **A line says the calendar's words and the date.** The words are the same verbatim title the
   day screen's row draws ("Kate Bell's 48th Birthday"), with the date beside them written as
   "Sat 14 November": weekday, day and month, no year. *The date is what a purchase is planned
   against, and the list never reaches a year ahead, so the year adds nothing. The owner combined
   the two offered forms, weekday plus "14 November".* The conductor reads that combination as
   follows, and the owner can correct it at the layout round.
2. **Today's birthdays say "Today" in place of the date**, and sit at the top because the list is
   soonest first. *Taken from the first offered form, as part of the same combined answer.*
3. **The Birthdays screen neither shows nor takes a tick.** Today's line looks like any other.
   *It is a screen for looking. The tick stays where it is entered, on the day screen
   (*entered where you stand*).*
4. **Birthdays on and nobody handed: the way in is still drawn, and the screen says in one line
   that there is nobody.** *The way in depends only on birthdays being on, so it does not appear
   and vanish as contacts change.*
5. **Access lost or the switch turned off while the screen is open: when shown again it empties to
   one line saying birthdays are off.** The app navigates nowhere on its own. Going back, the
   commitments screen draws no way in. *Nothing moves under the person, which is the day screen's
   rule too: it simply stops drawing the group.*
6. **The walk.** W.1, on the simulator: the commitments screen with birthdays off, with no way in.
   Then three steps on the phone. phone: W.2, the commitments screen with the way in. phone: W.3,
   the Birthdays screen, with today's (if any) on top and then soonest first, showing words and
   dates. phone: W.4, birthdays turned off in Settings and back on the commitments screen, where
   the way in is gone. *Anything with birthdays on cannot be walked on a simulator here (the known
   gap in `docs/open-questions.md`, since #328). The "nobody handed" line is left to the seam
   tests.*

**Settled by precedent, not asked.**
- A person the calendar hands twice is listed twice (`birthday` spec, "a birthday handed twice
  SHALL be answered twice").
- A 29 February birthday falls on whatever day the calendar puts that year's occurrence
  (`add-birthday` `design.md`: "no leap-year rule lives here").
- The screen reads the calendar again, and takes its **today**, only when it is **shown**, as the
  day screen does. It never turns over while someone is reading it.

**Facts the delta will meet.**
- The commitments screen's requirements live mostly in the `commitment` spec, and no spec puts
  birthdays there today.
- `CommitmentsScreen` holds neither the birthday calendar nor the birthday switch, only the
  ticks' place.
- The calendar reader already reads a range (`BirthdayCalendar.swift:10`), but nothing has asked
  it for more than three days.
- #400 (`decline-a-due-day`, in flight) modifies two `commitment` requirements: deleting a
  commitment, and confirming a stop. It touches nothing in `birthday`.

## Terms landed in CONTEXT.md

None in this grill. **Birthdays screen** and **Present idea** landed at the Feature grill (#406).

## Left open

None. Every question the frontier raised was answered. Where the way in sits on the commitments
screen is the layout round's question, below.

## Layout

Option B, chosen from three at https://claude.ai/artifact/62a5jdZUwJAJN9Trp63bzg, in both
regions. *The way in is a toolbar icon, as the day screen's ways into Commitments and Settings
are, and it stays in reach however far the roster scrolls. The dates sit in a column the eye
runs down, which is what a purchase is planned against.* Two more answers came in the same
round. The lines carry no 🎂, because every line on this screen is a birthday. The screen is
titled **Birthdays**, the same word as the switch and the day screen's group.

The designer flagged three things for the delta:
- "Sat 14 November" needs month names. Today `ContentView` writes the day screen's date with
  `Date.FormatStyle` in British English, outside the Kit (ADR-1022's amendment). So a seam that
  hands the words over verbatim puts month names back in the Kit.
- On a 375pt phone most of B's lines wrap the words onto two lines. Nothing is cut off.
- Giving the gift its own circle takes a `ToolbarSpacer` (iOS 26). Without one it joins the
  ⇅ + capsule.

The wireframe follows, verbatim from the designer (example data; today is Mon 12 October 2026):

```
B · Toolbar gift  (recommended)
┌──────────────────────────────┐   ┌──────────────────────────────┐
│ (<)            (🎁) [⇅  +]   │   │ (<)                          │
│ Commitments        ↑ (1)     │   │ Birthdays                    │
│ ┌ Creatine - Every day   > ┐ │   │ ┌──────────────────────────┐ │
│ │ …                        │ │   │ │ Anna Keller's 35th  Today│ │
│ Stopped                      │   │ │ Birthday                 │ │
│ ┌ Nothing has been stopped.┐ │   │ │ Kate Bell's 48th   Sat 14│ │
│ Happenings                   │   │ │ Birthday         November│ │
│ ┌ Kopfweh … New happening ─┐ │   │ │ …  (date right-aligned,  │ │
└──────────────────────────────┘   │ │     dimmed, never wraps) │ │
 (1) gift symbol in its own glass  │ └──────────────────────────┘ │
     circle, left of the ⇅ + capsule  └──────────────────────────────┘
```

All three options shared the rest: the Birthdays screen's lines sit in one card, with no chevron
and no tick, and today's line looks like any other.
