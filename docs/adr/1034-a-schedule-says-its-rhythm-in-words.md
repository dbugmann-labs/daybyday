# 1034. A schedule says its rhythm in words, and its payload stays inside the package

- Status: accepted — proposed and argued by `add-rhythm-in-words` (#144), the change that first
  shows a rule to a person
- Date: 2026-09-06
- Deciders: Diego Bugmann
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
lists, a row on the day screen, and the form's live preview of the rhythm being built.

ADR-1022 answered the neighbouring question for a **day**, and left this one open on purpose: "the
reasoning here — a sentence a test can be wrong about lives behind the seam, in fixed words —
applies to those on its face, but each is that Story's decision to take, and this record does not
take it for them." A day is a fact about the calendar. A schedule is a rule the product owns, which
is why this is a second record rather than a citation.

## Decision

**A schedule says the rhythm it runs on in words, and nothing about its payload becomes readable.**
`Schedule.inWords` composes the sentence inside `DayByDayKit`; `Commitment.rhythmInWords` and
`DayView.Row.rhythmInWords` pass it on; `Rhythm.inWords` says the same words for a rhythm still
being built, and says nothing at all for a number no schedule can be built on. Every payload named
above stays internal.

Three consequences are part of the decision rather than incidental to it:

- **The words are the requirement.** "Mon, Wed, Sat", "Every 14 days", "The 25th", "3x a week",
  "Every day", "No day" — quoted verbatim in every scenario of #144's delta, in this package's own
  English, with no `Locale` and no formatter, exactly as ADR-1022 fixed a day title.
- **The words say the shape and its number and nothing else.** An every-N-days schedule does not
  say its start date; a day-of-month schedule does not say that a short month is due on its last
  day. Both are true of the schedule and neither is part of the rhythm a person chose.
- **A payload accessor is not a smaller version of this.** It is a different decision, and it moves
  the composing into the app shell, which `CONTEXT.md` § *App shell* forbids by name.

## Consequences

- **The gap in `docs/open-questions.md` stays open and stops being urgent.** All nine faces are
  exactly as they were; what changes is that nothing is waiting on them. The next thing to need a
  payload will be something that must *compute* with one outside the package — an export, a second
  app, a rule edited in place — rather than something that must *show* one, and it will be a
  narrower widening for a stated reason.
- **One sentence, three readers, no drift.** An entry, a row and the preview cannot disagree about
  what a rhythm says, because they are asking the same function. Had the payload been published,
  each surface would have composed its own sentence and the third one would have differed from the
  first two in a way only a person's eye would catch.
- **Every rhythm anyone will ever read is written out by hand.** Seven three-letter weekday names,
  three ordinal suffixes with the eleventh, twelfth and thirteenth taking the wrong-looking one,
  and four sentence forms. #144's delta answers that with four roll-call scenarios rather than with
  a review habit, which is the shape ADR-1022 used for nineteen names.
- **Localising is a spec change, not a refactor** — the same price ADR-1022 named, now on more
  strings. The trigger is unchanged: a second person using this app in another language.
- **A rhythm that is not yet a schedule says nothing rather than something.** `Rhythm.inWords` is
  optional, and `nil` is the answer for the 32nd, every 0 days and 8 times a week. The alternative
  — previewing a refusal — would have put a second wording of an existing refusal on the screen,
  which is what `CONTEXT.md` § *Refused change* exists to keep to one.
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
order into the rule engine, where no rule shape consults one. `CONTEXT.md` § *Weekly quota* records
that where a week begins is deliberately still undecided; a `Comparable` conformance starting at
Monday is that decision taken by accident, in the one place it must not be taken.
