# Grill — start-a-number-from-the-last-one

*5 questions over 4 rounds, 2026-09-24, one fact agent, on top of the Feature grill of B-032 and
B-034 the same day. `CONTEXT.md` § *Starting number*, and the 2026-09-24 amendment to § *Number
entry*, carry what that grill settled: the latest number on a date before the day, from any era,
however far back; every typed number and no chosen or total one; committed unchanged it is
recorded, cancelled it records nothing; the range is said for an empty field only, so a field
that opens on a starting number does not say it — item 5 settles what that means once the field
is cleared.*

## Settled

1. **The entry says no date for its starting number.** The field holds the number and nothing says
   which day it came from, however old it is. *They took the recommendation over a date line
   always or past a week: it is a suggestion to keep or overwrite, and a line seen every time and
   rarely needed is what the row was kept clear of at #324.*
2. **A starting number the entry would refuse is not offered.** Where the latest earlier number
   lies outside the range the entry refuses against — the range of the era holding the day being
   entered, which after a range change is the new one — the field opens empty and says that range,
   exactly as on a day with no earlier number. It never reaches further back for one that fits.
   *The Feature's intent is that the screen offers no control it cannot honour, and just after a
   range change the new range is the thing worth saying; reaching back past the real last number
   could land on one from months ago. The "range the entry refuses against" is the refusal as it
   stands (`day-screen` spec, "A day screen enters the number a row's entry takes"), not a new
   choice.*
3. **The cursor on a starting number is where it is on a held number.** The field opens with the
   starting number as editable text, unselected, cursor at the end — the same as a day that already
   holds a number opens today. *72.4 to 72.1 is one delete and one digit; select-all would force a
   full retype and makes the two ways the field opens behave differently.*
4. **The walk.** Weight, typed, 40–150:
   - today's empty entry opens on yesterday's weight, with no range hint;
   - an empty day filled in after the fact opens on the weight from the day before it, not today's;
   - after a range change, a starting number outside the new range opens as an empty field saying
     the new range.

   A day with no earlier weight is left out; it opens as it does today and earlier walks show it.
   **phone:** save a starting number unchanged, and change its last digit with the cursor at the
   end — the keyboard feel no simulator shows. *They took the three new behaviours plus the phone
   step, over dropping the range-change screen or adding the unchanged one.*
5. **A starting number cleared from the field brings the range back.** The entry keeps its range
   hint while it holds a starting number; the starting number covers it, and emptying the field
   shows it again. *Raised by `designer`, reading the shell: the hint is the field's placeholder,
   shown whenever the field is empty. They took the recommendation — it is "said for an empty
   field" read literally, and it arrives just when a person is about to type from nothing — over a
   cleared field that says nothing.*

## Terms landed in CONTEXT.md

- **Starting number** — amended: a number the entry would refuse is not one, and there is then
  none (item 2).

## Layout

None asked. `designer` returned *no layout question here*: the typed entry is a system alert
whose field only changes what it opens holding, and items 1, 3 and 5 settle all of that.

## Left open

None. Every question the frontier raised was answered, and the facts it turned on — a range change
puts on a new era, an out-of-range number is refused with "Must be between …" and writes nothing,
the typed entry is a system alert whose field already holds a day's number as editable text, and no
function yet answers "the latest number before a date" — were established by the fact agent and
are for `spec-author` to cite.
