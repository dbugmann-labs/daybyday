# Grill — mark-a-quota-without-slack

*4 questions over 3 rounds, 2026-10-06, on top of what the twenty-fifth grooming pass's Feature grill
settled for B-073 the same day.*

## Settled upstream, and not re-asked

From the Feature grill (`docs/backlog.md` § *Decided*, B-073; `CONTEXT.md` § *Slack*):

- **Slack** is the days left in a weekly quota's week, today included, beyond what the week still owes
  once its standing is counted. No slack means the week cannot be met without today.
- **Today only.** The mark is drawn on today's day screen only — a past date's row says its standing
  and nothing more. *The signal is for deciding today; the day picker reaches no later day.*
- **Only while today is unticked.** Once today keeps the commitment the mark goes; it comes back if
  the tick is taken back the same day. *It has done its job; the count says the rest.*
- **A lost week says nothing extra.** Where the week can no longer be met even with today, the row
  says its standing and no mark. *A "lost" mark is a shame mark.*
- **A mark, not words and not a colour.** The owner's call against the recommended words. ADR-1045
  § *Decision 8*'s two colours for the trailing slot (green done, grey nothing to target) stay as they
  are; the mark is not a third colour there.
- **Accepted against *nothing congratulates you*** because it warns, never rewards, and counts nothing
  across weeks.

## Settled

1. **A week that never had slack is marked too.** A 7× quota, or a part week owing every day it holds,
   carries the mark on every unticked day. *The rule is the rule — no special case to carry or to
   remember; a 7× quota behaves like a daily rhythm and the mark says so.*
2. **The mark's words are "Needed today".** VoiceOver reads it that way, and it is what the mark
   stands for when it is drawn. *Plain, and says what to do from today's point of view; "no slack" is
   the domain's word and reads as jargon aloud.*
3. **The walk is four states, no `phone:` line.** (1) Today's yuno row — 5× a week, one kept, four
   owed, Thursday to Sunday left — with the mark; (2) the same row once today is ticked, no mark;
   (3) that row paged back to yesterday, no mark; (4) a lost week on today, its standing and no mark.
   Light throughout, and (1) in dark as well. *Every state the rule distinguishes, and nothing here
   that only a phone can show.*

## Facts the answers rest on

Found by a dispatched agent on `origin/main` at e65783c, not asked:

- Every day after today in today's week is held by the era today's row is on: stops, resumes and
  rhythm changes are made as of today or earlier, and a commitment kept from a future day has no row
  today (`commitment` spec, the stop, resume and change requirements).
- What a week owes is counted over the days an era holds — a part week owes less — and is the same
  number wherever it is said (`look-back`'s week rule, read by the day screen's row words).
- A day screen's today is replaced only when the app is shown again, never by the clock while it
  stays open; the mark follows the screen's today, not the device's.
- No day-screen row draws anything on today alone yet, except a one-off's lateness; a row gives back
  four things at the seam (name, rhythm in words, kept, what it offers), and nothing on a row carries
  a spoken label.

## Terms landed in CONTEXT.md

None in this grill. **Slack** landed at the Feature grill, the same day.

## Layout

Option C, the mark beside the count, chosen from three at
https://claude.ai/artifact/DC6BnHvXLZxFXk8oXcbGe3 — *it sits next to the standing it is a reading
of, leaves the trailing slot and ADR-1045 § Decision 8's two meanings alone, and is the quietest of
the three.* The glyph is a placeholder the designer drew so the options compared like for like (an
exclamation in a circle, close to an error icon); the owner chose a position, not a glyph, and the
glyph is tuned on the phone at build. The wireframe follows, verbatim from the designer, its header and one-off bar taken from option A
as the designer's note on C says — `(!)` is
the mark; Pages is example data the designer invented to show a row with a chevron.

```
C · Beside the count   (recommended)
┌─────────────────────────────────────┐
│                         [ ≡   ⚙ ]   │
│ Thursday                            │
│ Today, 8 October 2026               │
│ ‹  M  T  W (T) F  S  S  ›           │
│    5  6  7 (8) 9 10 11              │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ C̶r̶e̶a̶t̶i̶n̶e̶ - Every day          ✓ │ │
│ │ Magnesium - Every day           │ │
│ │ Run - Tue, Thu, Sun             │ │
│ │ Yuno - 1/5x a week (!)          │ │  1
│ │ Gym - 1/3x a week               │ │
│ │ Pages - 0/4x a week (!)       › │ │  2
│ │ Weight - Every day            › │ │
│ └─────────────────────────────────┘ │
│ ( New one-off                     ) │
└─────────────────────────────────────┘
mark: caption-size glyph after the row's words, in the same run of text, label colour;
it wraps with the words and the trailing slot is untouched
```

## Left open

None. Every question the frontier raised was answered; the glyph itself is a build-time value,
not an open question.
