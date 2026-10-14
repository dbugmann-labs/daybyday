# Grill — find-a-birthday-from-the-day

*14 questions over 5 rounds, 2026-10-14: seven at the grooming grill of B-084 and B-085 (two
rounds), seven at this Story's grill (three rounds), two of them re-asked after their premises
broke. Four fact agents.*

## Settled

1. **The way to the Birthdays screen moves to the day screen.** The gift leaves the commitments
   screen's toolbar and is drawn on the day screen's, beside the ways into Commitments and Settings;
   no other way in is added. *The owner's words were "reachable from day screen, not commitments";
   the commitments screen is for keeping commitments, and B-078's grill had inherited it there
   without a recorded reason.*
2. **When the way in is drawn.** Under the rule it is drawn under today, unchanged: exactly while
   birthdays are on, and not where the phone no longer gives full calendar access. *A way into a
   screen that can only say birthdays are off is a dead end.*
3. **It is on every day the day screen shows**, past and future alike, and the Birthdays screen it
   opens lists from today whichever day it was opened from. *The screen is about whose birthday is
   coming; a list that starts wherever you tapped would be two screens under one name.*
4. **Search is in this Story, not one of its own.** *The owner chose one Story over the conductor's
   two; B-085 fails five percent of seven things and was taken because the list is a year of every
   contact, uncapped, and a line is where an idea is added.*
5. **What a search matches: a line's words as they are shown.** Never the present ideas. *Asked
   first as "names only"; the fact agent then found a line's words are the calendar's whole title —
   "Kate Bell's 48th Birthday" — and the app holds a contact id, never a name. Re-asked, the owner
   chose the words as shown over cutting the name out of the title (it depends on the phone's
   language) and over asking for Contacts access (a second permission for one field). "birth" then
   matches everyone, which is harmless.*
6. **How it matches: anywhere in the words, whatever the capitals and accents.** "mul" finds
   "Anna Müller". *Contacts are typed with and without umlauts, and a surname is typed as often as a
   first name.*
7. **Spaces.** Spaces before and after what is typed are ignored, and a search of spaces only is no
   search: the whole list. *A stray space from the keyboard's suggestion should not empty the list;
   blank is the app's one rule for this, ADR-1039.*
8. **A search that matches nobody says so, quoting what was typed.** *An empty list reads as a
   screen that has not loaded.*
9. **No highlighting.** A matching line is drawn exactly as it is unsearched. *The line matching
   is the answer.*
10. **How long a search lasts.** It holds while the Birthdays screen is open — across opening a
    line's present ideas and coming back, and across the app being shown again — and is gone once
    the screen is left. *Finding someone and then adding an idea must not lose the place; the next
    visit starts on the whole list.*
11. **The search is offered only while the screen lists at least one line.** Not while it lists
    nothing in the coming year, says birthdays are off, or says they could not be read. *A search
    over nothing can only say nobody matches, on top of the sentence the screen already says.*
12. **The walk: two pictures and four `phone:` lines.** On the simulator, with birthdays off: the
    day screen with no gift, and the commitments screen with no gift. On the phone: (a) the gift on
    the day screen opens the Birthdays screen; (b) typing narrows the list; (c) a search that
    matches nobody shows the line saying so; (d) the search is still there after opening someone's
    ideas and coming back, and gone after leaving the screen and opening it again. *Asked first as
    six simulator pictures; the fact agent then found nothing with birthdays on can be walked on
    this Mac's simulators (`docs/open-questions.md`, the calendar access found at #328's walk), as
    #408, #409 and #410 found, and the owner chose the phone over diagnosing that here.*

## Terms landed in CONTEXT.md

- **Birthdays screen** — amended, not new, at the grooming grill (b5f9eae, merged in a37f8ce): reached
  from the **day screen** and only from there, and it finds a person by what is typed, looked for
  anywhere in a line's words whatever the capitals and accents, never in the ideas. No new term:
  *search* is plain English here.

## Layout

Option A, *Field at foot*, chosen from three at https://claude.ai/artifact/XTenF7BJmm27xcpzS2fTjT —
*the search field sits where the thumb is, as the day screen's "New one-off" field does; the gift
joins the one trailing capsule, so the day screen keeps one toolbar group; the line saying nobody
matches sits in a card, as "No birthdays in the coming year." already does.* The wireframe follows,
verbatim from the designer.

```
A — Field at foot (recommended)
Day screen                          Birthdays screen
┌──────────────────────────────┐    ┌──────────────────────────────┐
│ [Today]      ( 🎁  ☰  ⚙ )    │    │ (<)                          │
│ Wednesday                    │    │ Birthdays                    │
│ Today, 14 October 2026       │    │ ┌──────────────────────────┐ │
│ ‹ M T W T F S S ›            │    │ │ <words>       <day>    > │ │
│ Birthdays                    │    │ │ <n ideas>                │ │
│ ┌ <birthday rows> ─────────┐ │    │ │ …                        │ │
│ ┌ <commitment rows> ───────┐ │    │ └──────────────────────────┘ │
│ ( New one-off              ) │    │ ( 🔍 Search                ) │  ← field at foot, rides keyboard
└──────────────────────────────┘    └──────────────────────────────┘
No match: ┌ Nobody matches "<typed>". ┐ in a card, field stays at foot
```

Three things the drawing raised, none of them the owner's to answer: the mockup's
`Nobody matches “Kim”.` is an example, and the exact words are `spec-author`'s; SwiftUI's default
prompt "Search" follows the phone's language, which ADR-1022 settles against, so the field's word is
the app's own; and the designer could not confirm where iOS 26 puts a search field on a pushed
screen by default, so the foot placement has to be named in the build rather than inherited. The
gift loses the separate glass circle it has on the commitments screen today.

## Left open

None. Every question the frontier raised was answered, and the three the drawing raised are facts
or wording for `spec-author`, listed under § *Layout*.
