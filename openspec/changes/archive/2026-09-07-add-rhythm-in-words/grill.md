# Grill — add-rhythm-in-words

*12 questions over 3 rounds, 2026-09-06.*

## Settled

1. **The package says the words.** A schedule is said in words by `schedule`, in the package's own
   fixed English, the way the day title is (ADR-1022). No payload accessor is made public for this
   Story, and the read-back gap in `docs/open-questions.md` § *Known gaps* stays open with a note
   that rendering a rule no longer needs it. *At G2 the widening was called the prefactor every
   later screen Story wants; on the facts the package can say the words without it, and the owner
   took that.*
2. **Both lists on the commitments screen say it**, kept and stopped, in one entry shape. *Two
   stopped "Vitamins" are as hard to tell apart as two kept ones, and the stopped list exists to
   take one up again.*
3. **The day screen row says it too, on every row, always.** A third delta spec, `day-screen`.
   *Against the recommendation: the owner wants the rhythm on the daily visit, not only where
   commitments are managed. "Only when two rows share a name" was offered and refused.*
4. **An entry says the name and the rhythm in words and nothing else.** Not the kind, which is
   `add-kind-to-commitments-screen` (#142)'s surface, and not the kept-from day.
5. **Weekday set:** three-letter names in week order, Monday first, comma-separated — "Mon, Wed,
   Sat". All seven says "Every day"; none says "No day", because an empty set is a legal schedule
   a roster can hold even though the screen refuses to define on it.
6. **Every N days:** "Every 14 days", with no start date in the words. An interval of one says
   "Every day", the same words as all seven weekdays. *The start date is redundant on every
   commitment the screen makes, since the kept-from day is that start.*
7. **Day of the month:** an ordinal, "The 25th" — 1st, 2nd, 3rd, 11th–13th, 21st–23rd, 31st by
   English rules. The short-month clamp is not said.
8. **Weekly quota:** the owner's shorthand, "3x a week", for every number one to seven with no
   special case — "1x a week", "7x a week". Never "Every day", because a quota is any days.
   *Against the recommendation of "3 times a week" with "Once a week".*
9. **The form previews the words live** as a rhythm is built on the commitments screen. *Against
   the recommendation; the owner wants to see what the rhythm will say before defining on it.*
10. **A rhythm the screen would refuse previews as the schedule would say it, or as nothing.** No
    days previews "No day"; a number the calendar will not take (32nd, every 0 days, 8x) makes no
    schedule and previews nothing. The refusal's own words stay where they are, at define.
11. **The preview needs no kept-from day**, because the every-N-days words carry no start date
    (6), so a rhythm's words are exactly the words of the schedule it names.
12. **The term is "rhythm in words"**, landed in `CONTEXT.md`.

Facts settled without asking, for `spec-author`: nothing in the package or the app turns a
schedule into words today; `DayTitle` holds full weekday names, internal; `Weekday` has no order
of its own and the wire order in `CommitmentCoding` is the only Monday-first list in the package;
`CommitmentsScreen.kept` and `.stopped` are `[Commitment]`, whose only readable parts are `name` and
`kind`; `DayView.Row` publishes `name` and `isKept`. Whether an entry becomes a type of its own or
the row and the commitment gain a readable `rhythmInWords` is the seam question and is
`design.md`'s.

## Terms landed in CONTEXT.md

- **rhythm in words** — the sentence a schedule is said in: the package's own English, one form per
  shape, read by a commitments screen entry, a day screen row and the form's preview.

## Left open

None. Every question the frontier raised was answered; the one the delta may still surface is the
seam, which is `design.md`'s and not a preference.
