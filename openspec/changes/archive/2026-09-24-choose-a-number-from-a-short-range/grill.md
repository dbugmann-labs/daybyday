# Grill — choose-a-number-from-a-short-range

*13 questions over 5 rounds, 2026-09-24, on top of the Feature grill of B-032 and B-034 the same day
(`CONTEXT.md` § *Short range*, and the 2026-09-24 amendment to § *Number entry*, carry what that one
settled: whole bounds and eleven values or fewer is short, choosing the only way in, an empty day
starts with nothing chosen. Its "one tap on a value" is reversed here, at item 7).*

## Settled

1. **Taking a chosen number back.** A separate clear control beside the values, not a second tap on
   the chosen value. *Asked because a tick is taken back by tapping it again and a number by committing
   blank, and neither fits a row of values; they chose a control of its own over tap-again, against
   the recommendation.*
2. **When the clear control is drawn.** Only when the day holds a number, as the total's *Take back
   last* is only offered when there is an addition to take back. *An empty day shows the values
   alone.*
3. **Tapping the value the day already holds.** Nothing: nothing changes and nothing is written.
   *With a clear control as the one way to take back, a double tap must never clear a mood.*
4. **A day holding a number that is not one of the values** — 5.5 typed before this ships, or 8 kept
   under a range since narrowed to 1–5. The entry says the day's number with no value marked, and a
   tap on a value replaces it; the clear control takes it back like any other. *Nothing the day
   holds is hidden or lost silently; falling back to the keypad for that day was declined as two
   affordances on one commitment.*
5. **Which era decides whether a day is chosen or typed.** The era holding that day: a Mood changed
   from 1–10 to 1–20 today offers the chooser on last week's days and the keypad from today. *The
   same rule a range refusal and the look-back already follow — a day is judged under its own era.*
6. **The walk.** Six screens and one phone line, replacing the five first settled once item 7
   changed what there is to see:
   - *Mood* (1–10) at rest holding nothing, beside a *Weight* (40–150) row: no value, no values;
   - *Mood* opened on that empty day: the ten values over the screen, nothing chosen, no clear control;
   - 7 tapped: the values closed, *Mood* kept, no value shown in the row;
   - *Mood* opened again: 7 marked, the clear control drawn;
   - the clear control tapped: closed, the day holds nothing;
   - a *Mood* day holding 5.5, opened: the number said, no value marked.
   - `phone:` hitting the value meant, among ten, with a thumb.
7. **The values are hidden until asked for.** A short-range row at rest shows its name, and the check
   when kept — never the day's number and never the values. A tap on the row opens them; a tap on a
   value records it and closes them. *The owner's words: "I don't want to see the value or the value
   choices without clicking on it to record it." This reverses the Feature grill's one tap: choosing
   is now two, open and pick, and `CONTEXT.md` § Short range is amended to match. It also keeps the
   shipped "a row never draws" the number true for chosen entries.*
8. **Where they open.** Over the screen, as a typed number's keypad opens in an alert today — not
   inside the row. *Against the recommendation to grow the row in place.*
9. **What closes them.** A value tap records and closes; the clear control takes back and closes;
   dismissing without either changes nothing; one open at a time. *Proposed and taken as asked; with
   the values over the screen, "tapping the row again or another row" is dismissing the overlay.*
10. **The clear control and the caption only while open.** The clear control, and the day's number
    when it is not one of the values (item 4), appear with the values and never on the row at rest.
    The clear control is a symbol with a VoiceOver label ("Clear"), not words.

## Facts found for the delta

Dispatched, not asked — carried here so `spec-author` does not re-derive them.

- Six shipped scenarios type into a 1–10 *Mood*, which choose-only falsifies: in `day-screen`,
  "an entry committed empty takes the number back, and one holding nothing but space does the
  same", the `0.5` clause of "a number outside the commitment's range is told on the row, naming the
  bounds it broke", "a second refused commit is told on the row committed on last and no longer on
  the first", "committing an empty entry at a place that cannot be written is refused only on a row
  whose day holds a number"; in `restore`, "a day screen returned to after a restore tells nothing
  it was telling". "a number entry says the range its commitment declares as a hint" gives *Mood*
  the hint `1–10`; whether a chosen entry still says a hint, with its values in view, is the delta's
  call, as is how each of these is carried.
- The seam exposes no range bounds today: `DayView.NumberEntry` has `number` and `hint` only, and
  `Row.commitment` is internal. `DayScreen.enter(_:on:)` takes a `String`.
- A range can be changed on a commitment that is not stopped, which puts a new era on it; no rule
  refuses a change that leaves a recorded number outside the new range.

## Terms landed in CONTEXT.md

No new term. *Short range* is amended for item 7 — a short range is chosen by opening its values and
picking one, not by one tap.

## Layout

Option B, an anchored popover, chosen from three at
https://claude.ai/artifact/5EkBz4JRm2Ztii6iKRSWst (version 2) against the designer's recommendation
of a short sheet — *it keeps the Mood row in view and dims nothing.* Version 1 of the same page drew
the values inside the row, and item 7 sent it back. The wireframe follows, verbatim from the designer.

```
B · Anchored popover                     (nothing dimmed)
 │ M̶o̶o̶d̶ - Every day                  ✓  › │
 ╭────────────────────^─────────────────────╮
 │ 1  2  3  4  5  6 (7) 8  9  10  │  ⊗      │
 ╰──────────────────────────────────────────╯
 ╭────────────────────^─────────────────────╮
 │ 5.5                                      │
 │ 1  2  3  4  5  6  7  8  9  10  │  ⊗      │
 ╰──────────────────────────────────────────╯
Empty: digits only. Closed by a tap anywhere else. Covers the row below it.
```

At rest, in every option: `Mood - Every day  ›` when empty, and `M̶o̶o̶d̶ - Every day  ✓  ›` when kept —
the chevron the typed number rows have, because a tap still opens something. `(7)` is a filled
circle with the digit inverted; ⊗ is the clear control (items 1, 2, 10).

## Left open

One thing, a fact rather than a preference, for the delta and the build. **Whether a popover anchors
to one row** of the day screen's list, inside its swiped day pages, is unverified. On iPhone a
popover needs `.presentationCompactAdaptation(.popover)`, or it becomes a sheet. If it cannot be
anchored there, that is a rule-5 stop for the implementer, brought back to the owner — not a quiet
switch to the sheet. Everything else the frontier raised was answered.
