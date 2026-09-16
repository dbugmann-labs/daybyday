# Grill — change-range-and-target

*7 questions over 4 rounds, 1 fact agent dispatched, 1 designer, 2026-09-16.*

Story #262, second and last of the third reopening of `FEAT: commitment` (#26), cluster A of the
ninth grooming pass, blocked by #261 `place-sheet-refusals` (closed 2026-09-16). Grilled against
the sheet as #261 left it: a refusal told under the field it is about, `SheetField.range` and
`SheetField.target` already named, the range row and the target field drawn on a change and
disabled.

## Decided before this grill, and not re-asked

Settled at #26's G1 of 2026-09-15 and carried here as given: a number's range or a total's target
**can be changed on the commitment sheet**; the change **supersedes**, exactly as a changed rhythm
does, because carrying records over under a narrower range would refuse them and a raised target
would silently un-keep past days; it is **refused on a stopped commitment**. `CONTEXT.md`
**Superseding** was amended for it at that pass. The kind itself still never changes.

## Facts found, not asked

- **The seam today takes four things and never a kind.** `CommitmentsScreen.change(_:toName:on:
  keptFrom:under:)` builds every result with the old commitment's kind verbatim; no range or target
  can be expressed through it. Supersede against carry-over is decided by the rhythm alone
  (`sameRhythm`); the superseded commitment is kept until the day before the day the screen was
  handed and the new one kept from that day.
- **What a commitment is made of** says whether the rhythm and the day kept from can be changed
  (`canChangeRhythmAndKeptFrom`, false when stopped) and shows the kind with what it carries; the
  spec says "nothing SHALL be said about whether it can be changed" of the kind. Nothing is said
  about the range or the target.
- **The sheet** already draws the kind picker, the range row and the target field on a change,
  prefilled and disabled by `changing != nil`; on a stopped commitment the rhythm controls and the
  kept-from picker are disabled by `canChangeRhythmAndKeptFrom`. Name, category and the kind
  controls are not gated by the stopped flag.
- **The refusals exist.** `rangeIsNotARange` and `targetIsNotATarget` are raised from `define`
  only and placed under the range and target fields by #261; `change` has no path that raises
  them. `stoppedCommitmentCannotChangeRhythm` is the stopped refusal, placed by comparing what
  the commitment is made of against what was asked.
- **Equality is on the whole kind.** Two number commitments differing only in their range are
  different commitments (*two number commitments differing only in their range are different
  commitments*), so a changed range produces a commitment the roster does not hold, and supersede
  is well-founded.
- **A look-back chains eras by resemblance on the name and the whole kind** (`look-back` §
  *A look-back reads a commitment's earlier eras off the roster by resemblance*;
  `LookBack.chain` compares `commitment.kind ==`). A supersession that changed the range or the
  target would therefore sever the chain, and the page would say the commitment is kept from the
  day of the change. `CONTEXT.md` **Era** names only a rhythm change and an interval restart as
  what ends an era.
- **The record's own rules are untouched**: a number outside its range is refused where the
  record is formed (`record` § *A number is of a number commitment on a calendar date it is due
  on*), and a total is kept where its additions sum to its target or more.

## Settled

1. **Every change to a range or a target supersedes** — widened or narrowed, a range added to a
   number that carried none or taken off, a target raised or lowered. *Asked because only a
   narrowed range and a raised target could hit a record; the owner chose one rule over one that
   turns on direction — the roster holds no link either way, so direction buys nothing back.*
2. **The boundary is the one a rhythm change uses.** The old commitment is kept until the day
   before the day the screen was handed, the new one from that day; a number entered or additions
   made that morning under the old range or target stand against the old commitment and are not
   drawn that day. *Asked because a total's additions accumulate on the very day a target looks
   wrong; the owner accepted the same price as a rhythm change and a stop rather than a second
   boundary rule for one kind of change.*
3. **On a stopped commitment the range and target controls are disabled**, as the rhythm and
   kept-from controls already are; the sheet says they cannot be changed and does not let a thumb
   in. The refusal *a change a stopped commitment does not take* still covers a range or a target
   at the seam, is tested there, and is placed under the field it is about by #261's rule — the
   range field where only the range differs, the target field where only the target does, the foot
   where more than one of the four things differs. *Asked because the alternative was live controls
   refused under the field; the owner chose the sheet that already says what a stopped commitment
   takes.*
4. **A look-back's chain follows a commitment across a range or target change.** Resemblance
   compares the name and the kind's sort — a number behind a number, a total behind a total — and
   not the range or target the kind carries. The page still says the day the commitment was first
   kept from. **This Story deltas `look-back` as well as `commitment`**, one MODIFIED requirement.
   *Asked because the fact agent found the chain compares the whole kind; the owner chose to
   follow — "without starting the commitment over" is the want, and a page saying Mood began today
   is the commitment started over in the one place a person would look. The four open look-back
   Stories (#273–#276) are at Stage 0, so nothing serialises behind this yet; the first of them to
   reach Stage 4 rebases onto this delta.*
5. **The walk** — five pictures, no `phone:` line: the change sheet on a kept number commitment
   with the range row live; the same on a kept total with the target live; a refusal told under the
   range row on a change, a lowest of 10 and a highest of 1; Mood's look-back page after its range
   is narrowed, the head still saying the day it was first kept from; a stopped number commitment's
   sheet with the range row greyed out. *One per line the delta adds that a person can see; the
   refusal picture repeats a placement #261 walked but through a path that did not exist then.*

## Consequences the delta carries, not asked

- A change is asked with **six things** where it was four: the range or the target joins the name,
  the rhythm, the day kept from and the category, and only where the kind has room for it. Which of
  the two acts a save needs is worked out from a different rhythm **or a different range or
  target**; a different name or day kept from beside either carries over first and supersedes
  second, exactly as name-and-rhythm does today.
- A range that is not a range, or a target that is not a target, is refused on a change as it is on
  a define, about the same field. What a commitment is made of says whether the range or target
  can be changed, as it says of the rhythm and the day kept from.
- A change naming the range or target the commitment already carries, with everything else the
  same, changes nothing, writes nothing and refuses nothing, as today.
- A change of range or target whose result the roster already holds is refused as a commitment
  already kept, as a change of rhythm is.

## Terms landed in CONTEXT.md

- **Era** — amended, not a new term: a range or target change ends an era too, and the chain's
  resemblance is on the name and the kind's sort, not the value the kind carries.

## Layout

Option A, *as it stands, only the flag moves*, chosen from three at
https://claude.ai/artifact/WQyWjWVKxi5D6PSEcT4oJ1 — **against the designer's recommendation of B**,
which would have named each value with a labelled row. *The owner's call: the sheet keeps the shape
the two shell chores gave it, and nothing moves but the disabled flag — the range pair and the
target field take a thumb on a change to a kept commitment, and grey out beside the frozen rhythm
on a stopped one.* No footer saying why a control is frozen, on the range or the rhythm; a want if
it grates. The wireframe follows, verbatim from the designer:

```
Cancel                                 Save
Change Mood

+-----------------------------------------+
| Mood                                    |
| Kind                           Number v |
| 1                                    10 |
| That's not a range.                     |
| Category (optional)                   v |
+-----------------------------------------+

+-----------------------------------------+
| Rhythm                       Weekdays v |
| (Mon)(Tue)(Wed)(Thu)(Fri)(Sat)(Sun)     |
| Kept from                    1 Jun 2026 |
+-----------------------------------------+
```

Kind stays frozen on a change; the two fields under it take a thumb. A total draws one field,
"120", where the pair sits. On a stopped commitment the values grey, with nothing beside them to
name. The refusal line shows only while one is being told.

**One thing drawing turned up, for the shell and not the delta:** the sentence the shell says for
*a change a stopped commitment does not take* is "Take it up again first to change its rhythm.",
which reads wrong the day anything lets a thumb into a stopped range or target. The sheet cannot
reach that refusal (Settled 3), so no picture shows it; the words are the app shell's and the
implementer may generalise them without a requirement. The look-back page needs no drawing: walk
picture 4 changes which eras the chain finds, not what the page draws.

## Left open

None. Every question the frontier raised was answered. Where the refusal for a stopped commitment
is told when the range and the rhythm both differ is #261's rule applied, not a preference, and is
`spec-author`'s to write out.

## Not this Story

- What a number's or a total's look-back page draws across an era whose range or target differs —
  a line whose bounds step, a target line that moves — is #274's and #275's.
- The words the sheet says beside a disabled range or target are the app shell's, as ever.
- The refusals told beside a row on the two lists are where they were.
