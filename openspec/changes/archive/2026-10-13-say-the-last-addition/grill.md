# Grill — say-the-last-addition

*4 questions over 2 rounds, 2026-10-12: one at the targeted groom of B-081, three at this Story's
grill. One fact agent. One layout round, which found no question.*

## Settled

1. **Scope: the last amount only.** The total entry's *Take back last* says the amount it will
   remove, and nothing else on the sheet changes. Listing a day's additions stays out. *Asked at the
   groom, because a list is a second want. Answered as recommended. If it is ever missed, it is its
   own entry.*
2. **The words: "Take back last (35)".** The label keeps its words, and the amount follows in
   brackets. *These are the owner's own words from B-081, chosen over "Take back 35".*
3. **A decimal amount is written the way the sum is: "Take back last (12.5)".** No digit is added
   and none is dropped, as the sheet already does for the day's sum and the usual amounts. *Chosen
   over rounding, which would make the button disagree with the sum it changes.*
4. **The walk: two pictures, and no phone line.**
   - (a) A total's sheet on a day holding 35 then 20, saying "Take back last (20)".
   - (b) After that is tapped and the sheet closes, as it does today, the sheet opened again,
     saying "Take back last (35)".

   *A label needs no hand to prove it. No decimal picture: the seam tests carry 12.5.*

### Facts the answers stand on

These were checked by the fact agent against `origin/main` 6fc8a77. They are not decisions.

- **Two shipped rules close the amount off.**
  - `record` § *A history answers what a commitment has added on a calendar date from the
    additions it holds*: "A history SHALL give out the sum and SHALL NOT give out the additions
    themselves."
  - `day-screen` § *A row offers taking back its day's last addition, and offers none where the day
    holds none*: "this capability SHALL NOT ask for the additions themselves."

  This Story amends both. How narrowly is `spec-author`'s to decide, and the owner reads it at G4.
- **The label exists only in the shell.** It is at `ContentView.swift:905`; no spec says "Take back
  last".
- **The take-back of an addition is offered nowhere but the total entry sheet.**
- **The additions are already held in the order they were made.** They sit in `History`'s private
  `additions`, and `removeLastAddition` removes the last one appended. The record keeps that order
  because it "names the addition a take-back removes".
- **A usual amount needs no question.** The day keeps its amount and never its name (`CONTEXT.md`
  § *Usual amount*), so the brackets can only ever say the amount.

## Terms landed in CONTEXT.md

None. *Addition*, *take-back*, *total entry* and *usual amount* are all defined already, and nothing
here needed a new word.

## Layout

There is no layout question, and so no mockup. The `designer` read this file and the shipped sheet
(`ContentView.swift:903-910`): *Take back last* sits alone in its own full-width section. Settled 1–3
fix its words and its place, and "Take back last (35)" and "Take back last (12.5)" both fit that row
without wrapping. The wireframe is the sheet as shipped, with only that label changed, verbatim from
the designer:

```
┌───────────────────────────────┐
│ Cancel     <name>        Save │
│         <soFarOfTarget>       │
├───────────────────────────────┤
│ [ amount field            ]   │
├───────────────────────────────┤
│ <usual amount>  <name>        │
│ ...                           │
├───────────────────────────────┤
│ Take back last (20)           │  ← destructive role, as shipped
└───────────────────────────────┘
```

## Left open

None. The three edges a delta could turn on were asked and answered: the words, a decimal amount,
and the walk. Where the two shipped rules are loosened is a question of how the requirement is
written, so it belongs to `spec-author` rather than to the owner.
