# 1034. A schedule says its rhythm in words, and its payload stays inside the package

- Status: accepted — proposed and argued by `add-rhythm-in-words` (#144), the change that first
  shows a rule to a person
- Date: 2026-09-06
- Deciders: Diego Bugmann
- Amended: 2026-09-14 — records that the form's rhythm preview and `Rhythm.inWords` went at
  `add-commitment-editing` (#148, merged as #188; B-036), which this file went on describing as
  live. The sentence in § *Decision*, the three-readers consequence and the `nil` consequence are
  changed in place; § *Context* keeps the three surfaces it was written against, dated. The decision
  stands: a schedule still says its rhythm, and an entry and a row still read it.
- Amended: 2026-09-14 — `say-standing-in-quota-row` (#236): a schedule can also be said *given a
  count*, which a weekly quota says before its words — "1/3x a week" — and every other shape
  ignores; and a day-screen row on a weekly quota says its words given its standing, which makes
  that standing a thing the row *is*. Two sentences in § *Decision* are changed in place to say so.
  The decision stands: the English is still composed in the package, and nothing becomes readable.
- Amended: 2026-09-14 — the `Comparable` rejection in § *Alternatives considered* no longer rests on
  where a week begins being undecided: `CONTEXT.md` § *Weekly quota* now says Monday for everyone and
  ADR-1050 decides it. The rejection stands on the half that does not move — a week order in the rule
  engine is reachable by every rule shape — which ADR-1050 keeps out by putting the week in the
  history. The decision itself is untouched.
- Amended: 2026-09-11 — why an every-N-days schedule never says its start date, why seven times a
  week is not "Every day", and why the empty weekday set has words, recorded here. All three were
  argued in `schedule`'s requirement prose and nowhere else, and `condense-schedule-spec` (#208)
  deletes that prose.
- Amended: 2026-09-10 — the decision that a row says its rhythm *always*, and not only where two
  rows would otherwise read alike, is recorded here. It was argued in `day-screen`'s requirement
  prose and nowhere else, and `condense-day-screen-spec` (#201) deletes that prose.
- Renumbered: 2026-09-07 — written as `1033`, which `add-number-record` (#138) had already
  claimed at commit `7f476e2`; this record took the next free number, since
  `docs/adr/README.md` § *Numbering* gives a number to whoever claimed it first and never
  reuses one

## Context

`docs/open-questions.md` § *Known gaps* has been predicting one thing since 2026-08-31, and has
grown nine faces doing it: that a schedule's payload would have to become public, because a screen
that wants to draw "the 25th" beside a name has no way to recover the `25`. The entry says it in as
many words — "the widening is still owed by whichever Story first renders a rule, and B-021 is that
want." `docs/backlog.md` says the same. This change is B-021.

The facts, measured on this branch on 2026-09-06:

- `Schedule` is a public enum with four public cases, and every payload inside them is internal:
  `DayOfMonth.day`, `DayInterval.days`, `WeeklyQuota.timesPerWeek`. `Set<Weekday>` reads back,
  which makes the four shapes asymmetric.
- `Commitment.schedule` and `Commitment.keptFrom` are internal, so even a fully public payload
  would not help: there is no public way to get a schedule *out of* a commitment.
  `DayView.Row` publishes `name` and `isKept` and keeps `commitment` and `date` internal.
- Nothing in the package or the app turns a schedule into words today.

Three surfaces want the same sentence at once: an entry in each of the commitments screen's two
lists, a row on the day screen, and the form's live preview of the rhythm being built. (The third
went at `add-commitment-editing`, #188, on 2026-09-09 — B-036.)

ADR-1022 answered the neighbouring question for a **day**, and left this one open on purpose: "the
reasoning here — a sentence a test can be wrong about lives behind the seam, in fixed words —
applies to those on its face, but each is that Story's decision to take, and this record does not
take it for them." A day is a fact about the calendar. A schedule is a rule the product owns, which
is why this is a second record rather than a citation.

## Decision

**A schedule says the rhythm it runs on in words, and nothing about its payload becomes readable.**
`Schedule.inWords` composes the sentence inside `DayByDayKit`; `Commitment.rhythmInWords` and
`DayView.Row.rhythmInWords` pass it on. A rhythm still being built is said in no words at all:
`Rhythm.inWords`, which said them for the form's preview, went with that preview at #188. Every
payload named above stays internal.

Three consequences are part of the decision rather than incidental to it:

- **The words are the requirement.** "Mon, Wed, Sat", "Every 14 days", "The 25th", "3x a week",
  "Every day", "No day" — quoted verbatim in every scenario of #144's delta, in this package's own
  English, with no `Locale` and no formatter, exactly as ADR-1022 fixed a day title.
- **The words say the shape and its number and nothing else.** An every-N-days schedule does not
  say its start date; a day-of-month schedule does not say that a short month is due on its last
  day. Both are true of the schedule and neither is part of the rhythm a person chose. The one
  addition is a count the caller hands over: a weekly quota said given one says it before its words,
  as given and judging none, and every other shape ignores it — the schedule still consults no date.
- **A payload accessor is not a smaller version of this.** It is a different decision, and it moves
  the composing into the app shell, which `CONTEXT.md` § *App shell* forbids by name.

**Every row on a day view says its rhythm, always.** A row says the words whether or not its
commitment is kept on that date and whatever else the row offers or does not — a row for a day that
has not arrived offers nothing at all and still says them. The rhythm a thing runs on is part of
reading the day, at the one screen a person visits daily, rather than a disambiguation added when
two names happen to repeat. The rejected alternative was exactly that: say the rhythm only where
two rows would otherwise read alike, which makes what a row says depend on the other rows beside
it, and makes a day view's answer about one commitment depend on the rest of them. On a row
whose commitment is not on a weekly quota, the rhythm is still not a further thing a row is — the
words are read off the commitment the row already holds, so two such rows alike in commitment, date
and record agree on the rhythm they say. A weekly quota's row says its words given its **standing**,
and holds that standing, so two quota rows saying different counts are different rows.

**What the words leave out, and the two places they could have said something else, are each
decided for a reason.** An every-N-days schedule does not say its start date because, on every
commitment a commitments screen makes, the start date is the day the commitment is kept from
(ADR-1013), so saying it beside a name would repeat a day the person already chose; a commitment
formed some other way may carry a start date that disagrees with that day, and its words still say
only the interval. A weekly quota of seven is said "7x a week" and never "Every day", although it is
due on every date as a weekday set of all seven is (ADR-1015) and, a day holding at most one
completion of it, asks for one on each day. The reason that holds builds on this record's rule that
the words say the shape and its number, and adds what the record had not said — why an interval of
one day gets "Every day" and a quota of seven does not: an interval of one day and a weekday set of
all seven are both shapes that say which days, and name the same days, so they share one rhythm and
one set of words; a weekly quota's shape is a count of times in a week, said in one form for every
number from one to seven — "1x a week" and not "Once a week" is the same rule at the other end — and
names no days, so being due on the same dates does not make it their rhythm. This is the wording
B-017 and B-025 would reopen. The spec's former argument, that "Every day" would read an
obligation a quota of seven does not carry, contradicted the spec's own rule that a quota of seven
means one completion on each day and `record`'s rule of at most one tick per commitment a day, and
it is not carried here. And a weekday set listing no day is said "No day" rather than nothing,
although a commitments screen refuses to define a commitment on one (ADR-1028): the system forms it
and a roster can hold it, and an entry saying nothing would read as a rhythm missing rather than
empty.

## Consequences

- **The gap in `docs/open-questions.md` stays open and stops being urgent.** All nine faces are
  exactly as they were; what changes is that nothing is waiting on them. The next thing to need a
  payload will be something that must *compute* with one outside the package — an export, a second
  app, a rule edited in place — rather than something that must *show* one, and it will be a
  narrower widening for a stated reason.
- **One sentence, every reader, no drift.** An entry and a row cannot disagree about what a rhythm
  says, because they are asking the same function — as the form's preview could not either, while
  it existed. Had the payload been published, each surface would have composed its own sentence and
  one would have differed from another in a way only a person's eye would catch.
- **Every rhythm anyone will ever read is written out by hand.** Seven three-letter weekday names,
  three ordinal suffixes with the eleventh, twelfth and thirteenth taking the wrong-looking one,
  and four sentence forms. #144's delta answers that with four roll-call scenarios rather than with
  a review habit, which is the shape ADR-1022 used for nineteen names.
- **Localising is a spec change, not a refactor** — the same price ADR-1022 named, now on more
  strings. The trigger is unchanged: a second person using this app in another language.
- **A rhythm that is not yet a schedule is said in no words.** While the form's preview existed,
  `Rhythm.inWords` was optional and `nil` was its answer for the 32nd, every 0 days and 8 times a
  week, because previewing a refusal would have put a second wording of an existing refusal on the
  screen, which is what `CONTEXT.md` § *Refused change* exists to keep to one. Both went at #188
  (B-036), so nothing says a rhythm before a roster holds its schedule; that reasoning binds whatever
  says one next.
- **It does not extend to every sentence in the app by itself**, for the same reason ADR-1022 did
  not extend to this one. What it does settle, and what ADR-1022 could not, is the wider class: a
  **rule** this product owns is said in this product's words, in the package that owns the rule.

## Alternatives considered

**Publish the payload and let the caller say the words** — what the backlog and the open-questions
entry both predicted, for three Stories running. Rejected on the same ground ADR-1022 rejected it
for a date, plus one this change makes worse: there are three callers now, not one, and two of them
are behind the seam. A `DayView.Row` that published its commitment so the shell could read its
schedule so SwiftUI could compose "Mon, Wed, Sat" would put the one formatting rule in the one file
no test reaches, three times over.

**A structured value — shape plus number — composed by the shell.** The same move with a nicer
type: `RhythmDescription.weekdaySet([.monday, .wednesday])` and a `switch` in SwiftUI. Rejected
because the `switch` *is* the formatting rule, and because the comma, the space, the week order and
the choice of "Every day" over seven names are every one of them decisions that could be wrong in a
way a test would catch. `CONTEXT.md` § *App shell* names a formatting rule as one of four things
that fail that test and owe a Story.

**Words on `Rhythm` alone, with the screens reading a rhythm rather than a schedule.** Tempting,
because a `Rhythm` is what a person builds and it is already public. Rejected because a rhythm is
not stored and not held by a commitment: a roster holds schedules, so an entry and a row would have
had to reconstruct a rhythm from a schedule to say it, which is the payload read-back again with an
extra step. The words belong where the value that is kept lives.

**A `CommitmentsScreen.Entry` type carrying a name and a rhythm in words.** Rejected as a new seam
where an existing one already answers: `kept` and `stopped` are `[Commitment]`, twenty-odd tests
and the whole stop-keeping flow are written against that, and `add-kind-to-commitments-screen`
(#142) is about to put a third thing in the same entry. One computed property on `Commitment` costs
none of that and is what #142 extends.

**`Weekday: CaseIterable, Comparable`, so that a set sorts itself.** Rejected because it puts a week
order into the rule engine, where no rule shape consults one and every rule shape could reach it.
Where a week begins was undecided when this was written; ADR-1050 has since decided it — Monday, for
everyone, as `CONTEXT.md` § *Weekly quota* now records — and kept the order out of the rule engine
all the same, by putting the week in the **history**, which is the one place that counts the days of
one. The rejection stands on reachability, not on the question being open.
