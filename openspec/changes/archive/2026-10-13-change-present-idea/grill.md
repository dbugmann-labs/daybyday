# Grill — change-present-idea

*13 questions over 3 rounds, 2026-10-13, the last the layout round, and one fact agent.*

What the Feature grill of B-078 and #408 already settled is in `CONTEXT.md` § *Present idea* and
the `present-idea` spec, and was not re-asked: a given mark says what was given and not when, an
idea belongs to a person and to no day or year (ADR-1062), duplicates are kept as two, and a link
is refused unless it reads as a web address. Carrying ideas and their marks in a copy is #410.

## Settled

1. **The count on a Birthdays row.** Counts only the ideas not given; a person whose ideas are all
   given says nothing, as one with none. *The count is what is still there to give.*
2. **Where a given idea sits.** At the foot of the person's page, below every idea not given; each
   part in the order added. Taking the mark back returns it to its place among the ideas not given.
   *The top of the list is what is still to give.*
3. **How long a mark lasts.** Until it is taken back or the idea deleted; nothing clears it at a
   birthday. *Given ideas are the record of what was given; clearing them is the person's.*
4. **Giving and the birthday tick.** Not tied: ticking a birthday touches no idea, and marking an
   idea given ticks no day. *Something is given at Christmas too; the day screen stays a name and a
   tick.*
5. **Changing an idea so text and link both say nothing.** Refused, as adding such an idea is; the
   idea stays as it was. *Deleting is its own action, and a cleared field never throws one away.*
6. **Changing a given idea.** Allowed, and the mark is kept. *Fixing a typo does not un-give it.*
7. **Asking before a delete.** One confirmation, with Delete and Cancel, as *Days away* asks
   "Remove days away?". *There is no undo anywhere in the app, and a lost link is worth one tap.*
8. **Cancelling an edited change sheet.** Closes without asking, as the shipped *New idea* sheet
   does. *One line is cheap to retype, and both idea sheets then behave alike.*
9. **A write that fails, and a place that cannot be read.** A change, delete or mark that cannot be
   written keeps nothing and says "Not saved. Try again.", the sheet keeping what was typed; while
   the place cannot be read the page offers no change, delete or mark, as it offers no *New idea*.
   *As adding does, and as the stores before it.*
10. **A given idea's link.** Still opens in Safari. *Given changes how an idea is drawn, not what it
    does.*
11. **What the owner walks on the phone** — the walk runs on the phone as #408's did, since no
    simulator here gets calendar access; all four are `phone:` lines:
    - an idea's text and link changed, the link typed as a bare domain and kept with `https://`;
      then both fields cleared — the "says nothing" line, and the idea unchanged;
    - one of three ideas marked given — it moves to the foot, drawn as given, and the row says
      "2 ideas"; the mark taken back — it returns to its place and the row says "3 ideas";
    - an idea deleted — the confirmation shows, Cancel keeps it, Delete removes it and the count
      drops;
    - the app closed from the switcher and reopened — the change, the mark and the order are all
      still there.

## Facts the delta turns on

- An idea has no identity: `PresentIdea` is a text and a link, two alike are both held, and the page
  keys its rows by position. A change, delete or mark must name an idea by where it stands.
- Tapping an idea row does nothing today; only the link's glyphs open Safari (an `AttributedString`
  link in `Text`). No idea row has a swipe, context menu or edit control.
- Elsewhere a change is a leading swipe "Edit" (commitments, happenings) or a tap that opens a sheet
  (occurrences); the confirm word is "Save" when changing and "Add" when making. A done row on the
  day screen is struck through, secondary, with a green checkmark, and stays where it is.
- The present-idea store is in form 1 and refuses a later form; a given mark needs a second form,
  as the happening store took one for occurrences — a first-form file read as nothing given.

## Terms landed in CONTEXT.md

None. *Present idea* already says an idea can be changed, deleted, marked given and the mark taken
back, and that the mark says not when.

## Left open

None. Every question the frontier raised was answered. The words — the confirmation's wording, the
change sheet's title, what the mark is called on a control — are `spec-author`'s and the
designer's.

## Layout

Option A, *swipe actions*, for both halves of the layout round, chosen from three at
https://claude.ai/artifact/RqAa4vLxV3nM4tXVBR3AqE — *it changes, deletes and marks an idea with the
swipes the Commitments screen already uses, keeps a row quiet until it is swiped, and leaves the
link's own tap alone.*

- **Acting on an idea.** Swipe right: a pencil, which opens the change sheet with Idea and Link
  filled in, Cancel and Save. Swipe left: a gift that marks the idea given — on a given idea the
  same slot takes the mark back — and a trash that asks before deleting.
- **A given idea.** Text and link struck through, the text grey, the link still in the accent
  colour because it still opens; at the foot of the one ideas card. Not the faded look ADR-1045
  keeps for a row that offers nothing, since a given idea can still be changed and opened.
- **The delete confirmation is an alert**, as "Remove days away?" is, because on iOS 26 a
  confirmation dialog anchored to a control draws no Cancel and Settled 7 wants both.

The words the mockup made up — "Change idea", "Save", "Delete this idea?", what the gift and its
take-back are called — are `spec-author`'s; "Save" and "Take back" are the app's existing words.

The wireframe, verbatim from the designer (example data):

```
A · Swipe actions  (recommended)
┌──────────────────────────────┐ ┌──────────────────────────────┐
│ (<)                          │ │ (<)                          │
│ Kate Bell's 48th Birthday    │ │ Kate Bell's 48th Birthday    │
│ Sat 14 November              │ │ Sat 14 November              │
│ ┌──────────────────────────┐ │ │ ┌──────────────────────────┐ │
│ │ Ceramics class voucher   │ │ │ │ oucher     [gift][trash] │ │ ← swiped left
│ │ https://amazon.de/xyz    │ │ │ │ https://amazon.de/xyz    │ │
│ │ ~Hiking socks, size 38~  │ │ │ │ ~Hiking socks, size 38~  │ │
│ │ ~https://bergzeit.ch/so~ │ │ │ │ ~https://bergzeit.ch/so~ │ │
│ └──────────────────────────┘ │ │ └──────────────────────────┘ │
│ ┌ New idea ────────────────┐ │ │ ┌ New idea ────────────────┐ │
└──────────────────────────────┘ └──────────────────────────────┘
 nav bar: back only, as shipped. A given idea is struck through
 (text grey, link still accent) and moved to the foot of the same
 card. Swipe right: pencil (accent) opens "Change idea" [Cancel]/
 [Save] with Idea and Link filled in. Swipe left: gift (accent) and
 trash (red); on a given idea the gift is replaced by take-back.
 Delete asks the Days away-style alert: Delete / Cancel.
```
