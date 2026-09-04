# 1028. A screen may refuse what the rule engine accepts

- Status: accepted — the decision is the owner's, taken at the grill of `add-commitments-screen`
  (#104) on 2026-09-04, question 4 of twelve
- Date: 2026-09-04
- Deciders: Diego Bugmann

## Context

`Schedule.weekdays(Set<Weekday>)` accepts the empty set. That is deliberate and it is pinned:
`openspec/specs/schedule/spec.md` § *A weekday-set schedule is due on the weekdays it lists* says
"membership is the whole rule", `CONTEXT.md` § *Weekday set* says "an empty set is due on none",
and `ScheduleTests.swift` carries a passing acceptance test asserting exactly that. The value is
total, the rule is one line, and there is no date in the supported range on which such a schedule
is due.

`add-commitments-screen` (#104) puts a form in front of a person for the first time. The form
offers all four rhythms, and one of the four is a set of weekdays with a tick against each day. A
person can therefore reach a state where none of the seven is ticked, and if the form takes it, a
commitment is created that is due on no day the calendar has. It appears in nothing. It cannot be
ticked, because a tick is of a *due* commitment. Its only visible property is that it exists on the
commitments screen, and the only thing a person can do with it is stop keeping it.

Until this Story, nothing in the product had a reason to disagree with the engine. Every refusal
that existed — a name that says nothing, a day of the month outside 1–31, an interval below one, a
quota outside 1–7, 30 February, a year before 1583, a roster refusing a duplicate — is made by the
value itself, and every screen simply reports what the value said. The question this Story forced
is whether a screen may make a refusal of its own.

## Decision

**Yes, and this is the first one.** A commitments screen refuses a weekday set with no days in it.
`Schedule` is unchanged, `openspec/specs/schedule/spec.md` is unchanged, and
`Schedule.weekdays([])` goes on being a legal value that is due on nothing.

The line, stated so that the next screen has a rule rather than a precedent:

> **A value may be refused by a screen and accepted by the engine when the refusal is about what a
> person should be offered to make, and not about what the value may be.** The engine answers for
> every value it can be handed, including ones it was handed by a file, by a test, or by a later
> version of the app. A screen answers only for what it is about to create on someone's behalf.

Two things follow from that wording and are part of this decision:

1. **The engine is never narrowed to match a screen.** Narrowing `Schedule` would make a legal
   stored value illegal, which is a migration; it would break the pinned scenario in `schedule`;
   and it would refuse the empty set to a future caller — a rhythm being edited towards a valid
   set, a rhythm imported from a backup — that has a good reason to hold one transiently.
2. **A screen's refusal is a requirement like any other**, written in the capability that owns the
   screen, with its own scenario. It is not a validation convention, not a UI guard, and not
   something a shell may hold. `openspec/specs/commitment/spec.md` § *A commitments screen refuses
   a name that says nothing, and a rhythm due on no day* is where this one lives, and the delta
   carries a second scenario — *a weekday set with no days in it is still a schedule the rule
   engine accepts* — whose only job is to assert that the asymmetry survived.

## Consequences

- **The delta says out loud that the engine still accepts it.** That scenario looks redundant next
  to `ScheduleTests`' existing one and is not: it is the guard against the obvious "fix", which is
  to make `Schedule.weekdays` refuse the empty set and delete the screen's refusal. Someone taking
  that shortcut fails a test whose name explains why.
- **There is now a shape a person cannot reach and a file can hold.** A roster written by hand, by
  an older build, or by a future feature could contain a commitment due on no day, and the
  commitments screen will list it — because listing is not creating. It shows a name and offers a
  stop, which is exactly what a person needs. No code path is added to detect or repair one.
- **The next screen has one question to answer rather than a precedent to argue from.** Is the
  refusal about what to offer, or about what the value may be? The second belongs in the value and
  costs a delta on the capability that owns it.
- **This does not license a screen to tighten anything else.** A name has no length limit, no
  restricted script and no reserved word, and this decision must not be read as permission to add
  one: `CONTEXT.md` § *Commitment name* says the name is the owner's own words rather than the
  system's, and "a person would never see it again" is not an argument that reaches a long name.
  The test is whether the created thing can ever be *shown to its maker*, not whether it is
  tasteful.
- **ADR-1021 is untouched.** That record is about telling refusals apart, and this one is about
  where a refusal is made. They meet in `add-commitments-screen`, whose delta deliberately breaks
  ADR-1021's one-message pattern for a different reason — a duplicate and an unwritable roster
  leave a person different actions — and that argument stands on its own.

## Alternatives considered

**Refuse the empty set in `Schedule` itself**, making `Schedule.weekdays` a failable construction
like `DayOfMonth`, `DayInterval` and `WeeklyQuota` already are. Consistent on its face, and it puts
the rule in one place instead of two. Rejected on three counts. It breaks a shipped, approved
requirement and the test that pins it, which is a delta on `schedule` in a Story whose Feature is
`commitment`. It is a migration: a roster store already on a device could hold such a commitment,
and `RosterDocument.formRoster()` would start refusing a file it wrote itself. And it is wrong on
the merits — the empty set is the identity of a set of weekdays, and a rule engine that cannot
represent "due on no day" cannot answer about a rhythm being built up one day at a time.

**Accept it and let the commitment exist.** The cheapest option, and it costs no code at all: the
person made a thing that does nothing, and they can stop keeping it. Rejected because a commitment
that never appears is indistinguishable from the app having silently dropped it, which is the one
impression this product cannot afford — `CONTEXT.md` opens on the durability of a record, and a
person who defines something and then never sees it will not trust the ones they do see.

**Accept it, and warn on the day screen.** Draw the commitment as a row that says it is due on no
day. Rejected: it puts a second screen's problem on the daily visit, against `CONTEXT.md`
§ *Entered where you stand*, and it needs the day view to say something about a commitment that is
not due, which `CONTEXT.md` § *Day view* forbids in as many words — it shows what is due and
nothing else.

**Default the form to all seven weekdays ticked, so the empty state is unreachable.** Rejected
because it is a refusal in disguise, made by a default rather than by a rule, and a person can
untick all seven anyway. A default that exists to prevent a state is a guard that will be removed
by the first person who thinks it is only a default.
