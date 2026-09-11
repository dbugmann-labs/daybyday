## Context

`proposal.md` § *Why* says what this is for. `grill.md`'s five settled answers are what the delta is
written on, and `grill-frontier.md` beside it is what the delta is checked against: it indexes
`docs/research/2026-09-09-concise-specs/survey-schedule-cli.md` against the current file and corrects
the survey in three places — five pieces of rationale with no ADR home rather than two, ten rules with
no scenario rather than one, and one rule asserted by a scenario filed under another requirement.

Measured here: `openspec/specs/schedule/spec.md` holds 18 requirements, 78 scenarios and 3,448 words
of requirement prose, and 12 of the 18 are over the 150-word budget. Every scenario is
`WHEN`/`THEN`/`AND` bullets carrying no prose, and every title is an acceptance test's name.

## Goals / Non-Goals

**Goals:** every rule frontier § B and § C lists stated once, as a SHALL/MUST sentence, in the
requirement it stands in today; every requirement inside 40–150 words or named under § *Overruns the
budget*; every piece of rationale with no ADR home homed before the prose carrying it goes.

**Non-Goals:** no scenario added, renamed, moved, merged or dropped and no body touched; no behaviour
change, no test change, nothing under `src/`; no requirement split; no other capability,
`cli-version` included.

## Decisions

### The seam

**None, and that is what this Story is.** ADR-1047 decision 2: an editorial Story rewrites prose,
changes no behaviour and changes no test, so there is no new or changed member for an acceptance test
to attach to, and rule 3's red-green loop is moot because there is no red. `docs/process.md` § 9's
Definition of Ready asks for a seam **or** for `design.md` to state that no test changes and why,
which is this paragraph. Every scenario is already driven at a seam that ships — `Schedule.isDue(on:)`,
`Schedule.inWords`, `CalendarDate` with its read-back, and the failable initializers of `DayOfMonth`,
`DayInterval` and `WeeklyQuota` — by a test carrying its title verbatim, and each goes on passing.

### Every rule survives as a sentence, and this Story adds no scenario

Grill answer 1. The ten rules frontier § B finds with no scenario stay as bare SHALL/MUST sentences in
the requirement where each stands today: deleting one is a behaviour change by omission, and writing a
scenario adds a test, which ADR-1047 forbids an editorial Story. That includes the exclusion of the
current time, the time zone and the locale that five requirements each state for their own answer. It
is cut to one clause per requirement and not consolidated, because the five lists differ — the
Gregorian-weekday one names only the time zone and the locale, and the weekly-quota one adds which
week, where a week begins and how many times — so one sentence would drop items or re-enumerate them.
Rejected: one consolidated exclusion; dropping the compiler-enforced rule that no number is writable.

### The short-month clamp gets ADR-1051, and the read-back amends ADR-1004

Grill answer 2. No ADR recorded why a day-of-month schedule on a day a month lacks is due on that
month's last day; ADR-1006 cites the clamp only as an example. **ADR-1051** records it, with skipping
the month as the rejected alternative, and says why it does not contradict ADR-1004's refusing rather
than adjusting: the date the clamp lands on always exists, so nothing is formed and then adjusted.
**ADR-1004** gains one paragraph: a formed calendar date gives back the three numbers the edge's
conversion needs, and none can be assigned, because a date changed one component at a time could pass
through a combination that names no day. The date-picker motivation is history and goes with no home.
1051 was checked unused in `docs/adr/` and on every local and remote branch before it was written.
Rejected: homing the clamp in ADR-1004, whose decision is about forming a date and not about due-ness.

### Three arguments the survey missed amend ADR-1034

Grill answer 3. Frontier § A.3–A.5 found three arguments the survey had homed by their rule without
checking the argument beside it. All three become one paragraph of **ADR-1034**: an every-N-days
schedule does not say its start date because on every commitment a commitments screen makes it is the
day the commitment is kept from; seven times a week is not "Every day" because a quota's words say its
own shape, one form for every number; and the empty weekday set has words because saying nothing
reads as a rhythm missing rather than empty. The spec keeps the three rules and loses the arguments;
its old one for the quota was false and is not carried (§ *Risks / Trade-offs*). Rejected: ADR-1013, ADR-1015 and ADR-1028 in
turn, each of which records the rule's neighbouring fact and says nothing about a schedule's words.

### The rest of the rationale is already homed

The rewrite deletes it rather than restating it (survey § 2): the supported years and refusing rather
than adjusting are **ADR-1004**'s; not being due before the start date is **ADR-1013**'s; a quota due
on every date, completion being no schedule question, the ceiling of seven and the extension shared
with all seven weekdays are **ADR-1015**'s; the package's own English is **ADR-1022**'s and
**ADR-1034**'s, as is the shape and its number only; a screen refusing the empty weekday set is
**ADR-1028**'s. Three had no home and gain one: a four-digit year being past any commitment's horizon
joins ADR-1004's amendment, and a never-met quota being a never-due commitment and the all-seven-days
cost now stated in the record amend **ADR-1015**; **ADR-1028**'s quote of the spec is cut to words it
keeps. The eleventh-to-thirteenth note is a comment on the suffix table, and goes with no home.

### No requirement splits, and the misfiled scenario stays where it is

Grill answer 4. All 18 requirements are MODIFIED. *An interval longer than the supported years is due
only on its start date* sits under the every-N-days due-on requirement and tests the interval
requirement's no-upper-bound rule. Moving it needs its requirement REMOVED and re-ADDED, because the
archiver refuses a MODIFIED block that omits a current scenario, and that would put the requirement at
the end of the file inside an editorial diff. So the interval requirement states the rule in full, and
the one the scenario sits under refers to it in one clause, because its scenario depends on it, and
does not restate it. Rejected: moving the scenario; restating the rule in both requirements; splitting
the read-back requirement, which is over budget only on history this Story deletes.

### No scenario title changes and none is dropped

Grill answer 5. Every scenario block stays byte-identical under the heading it sits under now, because
a title is a contract a CI check reads. Frontier § E finds no false title in `schedule`, so ADR-1047
decision 5 needs no amendment. One positive SHALL is added rather than kept: the calendar-date
requirement now says a combination naming a day is formed, because *the twenty-ninth of February in
a leap year is a calendar date* asserts it and no current SHALL states it. Rejected: taking the survey's nine duplicate-scenario candidates now —
each deletes a passing test, which is the plan's next phase and not an editorial Story's.

## Overruns the budget

None. Every requirement's prose is within 40–150 words, as `pnpm run check:budgets` reports.

## Risks / Trade-offs

- **A dropped rule is invisible to every check**: the tests pass whatever the prose says, and a trim
  can lose a second bound, a MUST NOT no scenario asserts, or a rule carried only by a "so that" or a
  bare declarative. → One `tasks.md` box per requirement, read against frontier § B and § C with the
  current sentence beside the new one; the same lists are `reviewer`'s fidelity axis at G7.
- **A rule stated once and deferred to can be deleted twice**, each copy read as the other's
  restatement: the no-upper-bound rule, the clamp the day-of-month requirement defers to, and the month
  and day bounds the year range defers to. → Named in both boxes of each pair.
- **The quota-of-seven wording had a false argument.** The spec said "Every day" would misread a
  quota of seven's obligation, against its own rule that seven means one completion each day and
  `record`'s one tick a day. → ADR-1034 gives the reason that holds and says the old one is not
  carried; the rule itself does not change, so reversing it would be a behaviour Story.
- **The exclusion clause reads as repetition** across five requirements and invites consolidation at
  review. → Kept apart on purpose by grill answer 1, because the five lists differ.

## Open Questions

**Twelve rules stay knowingly untested** — kept as SHALL/MUST sentences with no scenario, or with one
that asserts them only in part (frontier § B, § C.3, § C.8): a calendar date's three numbers are not
writable, which the compiler enforces; the exclusion of the current time, the time zone and the locale
from each of the weekday-set, Gregorian-weekday, day-of-month, every-N-days and weekly-quota answers,
with everything else each excludes; a rhythm in words is the same whatever day it is asked on or about
and whether or not a commitment carries it; the weekday-set and day-of-month shapes match in either
direction; a surface stopping a quota once its week is complete decides that from tick records; month
and day are bounded by the calendar-date requirement and not by the year range; a schedule on the
thirtieth in a common February; and no leading zero in a rhythm in words. Nothing else is open:
`grill.md` § *Left open* is "None.", and no residual round was raised, but a settled answer was
corrected on a fact — the quota-of-seven argument (`grill.md` answer 3, *Corrected 2026-09-11*).
