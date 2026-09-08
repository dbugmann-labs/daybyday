# Grill — add-total-record

*17 questions over 6 rounds, 2026-09-08.*

Two agents were dispatched for facts: one mapped the existing record, row and store API, one
measured `Decimal` addition on this toolchain. Nothing below was asked of the human that either
of those could answer.

## Settled

1. **This stays one Story: the record and the row together.** *Asked because the number kind
   took two (#138 the record, #139 the row) while the note took one (#140), and the total is
   heavier than either — it is the only kind that changes how* kept *is answered. Recommended a
   split; they chose one Story, following #140.*

2. **An addition must be above zero.** *Zero and negative are refused where the record is
   formed, the shape a number outside its range is refused in. A negative addition would be a
   second way back that competes with take-back-last.*

3. **The reader stays kind-shaped; the general record reader is not built here.** *#138's Q5
   deferred it "rather than fix the shape of two records nobody has grilled yet" and #140's
   design named this Story as where that reason expires. It does expire — but folding four
   readers into one would rewrite requirements three merged Stories already signed. The general
   reader is its own change; see* ## Left open.

4. **A commit on a total entry is always an addition. Blank keeps nothing and takes nothing
   back.** *A number entry and a note entry committed blank are take-backs. A total's take-back
   removes only the* last *addition, so the same gesture would silently delete the last thing
   added and a person would have to remember what it was to know what they lost. Take-back-last
   is its own act on the row.*

5. **The record type is `Addition`: a commitment, a date and one decimal above zero.** *A day
   holds many and the total is derived, which is what CONTEXT.md already means by "the record is
   the additions". `Total` as a second type was offered and declined.*

6. **A history gives out the sum and not the additions.** *Nothing has asked for the list —
   take-back-last is named by commitment and date, so no caller needs it to reach the last one.
   The smallest widening of the public surface this can be.*

7. **There is no way to clear a whole day in one act.** *Repeated take-back is the only way
   back. One act that erases six records is a bigger undo than the other three kinds have, and
   nothing has asked for it; if it turns out to be wanted it is a want and its own change.*

8. **A total entry says two things — the sum so far and the target — and its field opens
   empty.** *A number entry's field opens holding the number, because committing it again is a
   replacement. A total's must not: a pre-filled 90 committed unread would make the day 180. It
   is the first entry whose value is for reading rather than for editing, and it is written down
   so nobody re-derives it.*

9. **A row offers take-back-last only where the day holds at least one addition.** *At the
   record level, taking back where there is nothing leaves the history unchanged, as the other
   three kinds do. At the row level that would be a visible control that does nothing, and a row
   that answers a tap with silence is already an open question against this product. Q14 makes
   this readable off the sum alone: additions are above zero, so a sum above zero means there is
   a last addition.*

10. **A total entry teaches nothing before it refuses.** *A number entry carries its range as a
    hint because a range is something the commitment declares and differs per commitment. "Above
    zero" is the same rule for every total there will ever be, and a hint identical on every
    total row is noise.*

11. **An addition that would take the day's sum past thirty-eight significant digits is
    refused.** *Measured, not recalled — see* ## Measurements *below. Overflow to `NaN` is
    unreachable, but a sum silently stops being exact ~137 orders of magnitude earlier, and
    truncates rather than rounds. Refusing keeps the sum always exactly what was added; a total
    whose sum quietly stops being the sum is a false record, which is what this product exists to
    remove. The threshold is #139's own rule for one number, applied to the sum.*

12. **The store re-forms each addition on its own and applies no rule across a day.** *A file
    whose additions sum past the cap is not a file this app can write, and a cross-record check
    on read would be the first of its kind. Refusing the whole store, and dropping the additions
    past the cap, were both offered and declined.*

13. **A row says the true sum once it has passed the target — "150 of 120".** *Additions past
    the target are allowed and change nothing about kept (CONTEXT.md, the Feature grill). Showing
    120 of 120 would be the app editing a person's record down to look tidy.*

14. **A day with no additions has a sum of zero, not nothing.** *Recommended nothing, to match
    `number(for:on:)` and `note(for:on:)`; they chose zero — the sum of no additions really is
    zero, and it keeps an optional off the surface. Additions are above zero, so a sum above zero
    means the day holds at least one, which is what answer 9 reads.*

15. **A refused addition names a cause, and `day-screen`'s closed set of causes goes from two to
    four.** *That requirement says "Exactly two causes SHALL be named" and "No third cause SHALL
    be named", with a stated test for admitting one: name a cause only where a person can act on
    that cause differently. Both new refusals pass it — the person gives a different number, and
    a different one again. This is a base-spec change, not an addition.*

16. **The sum reader answers zero for every commitment on every date, and never nothing.** *The
    way `isKept` answers a yes-or-no for all of them, rather than the way the number and note
    readers answer* nothing *for a kind mismatch or a date not due. Follows from 14: zero is a
    true answer to "what has been added" whatever the commitment is.*

17. **The two new causes are "Must be more than 0" and "Too large to add", word for word.** *The
    spec pins the existing two verbatim, so these are pinned the same way. The second says the
    only thing a person can act on; the headroom it would otherwise name is a thirty-eight digit
    number.*

## Measurements

Run on Apple Swift 6.3.3, arm64-apple-macosx26.0. Answer 11 turns on these and nothing else.

- `Decimal` addition **never traps or crashes**. It yields `Decimal.nan` silently on true
  overflow. There is no `addingReportingOverflow` on `Decimal`; `NSDecimalAdd` returns a
  calculation error, but it reports `noError` while digits are being dropped, so it is not a
  precision-loss signal.
- A sum stays **exact only while its significand fits 128 bits** (2^128 − 1 ≈ 3.4 × 10^38). Past
  that `Decimal` **truncates toward zero**, and `.plain`, `.down`, `.up` and `.bankers` all
  produce the identical truncated result. Summing 36 nines ten thousand times drifted from the
  exact answer at the 30th digit.
- True overflow to `NaN` needs on the order of **10^127 additions** of the largest admissible
  single value, so a rule that guards only `NaN` guards nothing.
- **Order sensitivity is real but only near that same cap**: `a + b + c ≠ c + b + a` was
  constructed at a ≈ 2^128 − 1. Below the cap, addition is exact and order does not matter — so
  answer 11 makes the additions' order irrelevant to the sum while keeping it meaningful for
  take-back-last.
- `Decimal.nan >= Decimal(120)` is `false`; **`Decimal(120) >= Decimal.nan` is `true`**. The
  comparison is asymmetric under `NaN`, so `sum >= target` is safe and `target >= sum` is not.
  Writing the kept rule in the wrong order would flip it. **For `design.md`.**

## Terms landed in CONTEXT.md

- **Addition** — one thing added to a total's day: a commitment, a date and one decimal above
  zero. New entry.
- **Total entry** — what a total commitment's row offers in a tick's place. New entry.
- **Total** — amended: an addition is above zero, a day's sum is capped at thirty-eight
  significant digits, a day with none sums to zero, and the row says the true sum of the target.
- **Row** — amended: a row offers a tick, a number entry, a note entry or a total entry, and a
  total row offers take-back-last besides, where the day holds an addition.

## Notes for `spec-author`

Not requirements — pointers, so they are not rediscovered.

- **Where answer 11's refusal lives is yours.** An addition's admissibility depends on what the
  day already holds, so unlike `Number` and `Note` it cannot be judged from the commitment and
  the date alone. Whether the `Addition` refuses to form against a history, or the history
  refuses the add, is a design call — the two are observably the same from the row.
- **ADR-1033 is amended, not superseded.** It already says the total is the one kind that will
  not be taken back by naming its day. `docs/adr/README.md`'s amendment rule applies.
- **Two ADR candidates**, both hard to reverse and both surprising to a reader who does not know
  why: the sum cap (answer 11), and blank meaning nothing on a total entry where it means a
  take-back on the other two (answer 4).
- **The store form moves 4 → 5**, with a `totalsIntroducedInVersion` of its own, and the eleven
  test fixtures that say `4` for "a later form" move to `5`. Same shape as #140's 3 → 4.
- **`day-screen`'s cause requirement is base spec** and answer 15 changes it. It is the only base
  requirement this change is known to modify.

## Left open

**One, deliberately, and it is not this Story's to close.** The **general record reader** all
four kinds would share — answer 3. #138's Q5 deferred it until all four existed; they now do, so
the deferral's stated reason is spent, and what replaces it is that the fix is a refactor across
`record` and `day-screen` with no behaviour change, in a Story that is about totals. It belongs in
`docs/open-questions.md` as the twelfth and thirteenth faces of the public-surface known gap,
recorded at G7 with the two this change adds — `History`'s sum reader and `DayView.Row`'s total
entry.

Every other question the frontier raised over six rounds was answered.
