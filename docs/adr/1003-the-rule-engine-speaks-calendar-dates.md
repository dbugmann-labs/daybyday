# 1003. The rule engine speaks calendar dates, not instants

- Status: accepted
- Date: 2026-08-30
- Deciders: Diego Bugmann

## Context

ADR 1001 put the rule engine — *is this commitment due on this date* — in a Swift Package with no
UI dependency, and made its exported entry point the seam acceptance tests attach to. It said
nothing about what that entry point takes as an argument, because there was no requirement in
hand to force the answer.

`add-weekday-set-schedule` (#8) is that requirement, and it is the first of four rule shapes:
a set of weekdays, a day of the month, every N days, and N times within a week. Whatever the
first one takes, the other three take, and every screen that draws a day will pass it. Choosing
it once, before any of the four is written, is cheap; changing it after all four exist means
touching every signature and every acceptance test in the capability.

Three facts from the product's own definition point the same way. `CONTEXT.md` records that a
**day** is the unit DayByDay is organised around, that every record is keyed to a date rather
than to the time it was entered, and — most pointedly — that *whether a commitment is due is a
question asked of a date, not of the present moment*. The past is writable: a day other than
today can be ticked, and it must answer the same way tomorrow as it does now.

Foundation offers a `Date`, which is not a date. It is an instant — a point on a timeline, a
`TimeInterval` from a reference epoch. Turning an instant into "which day is this?" requires a
calendar and a time zone, and the answer changes with the time zone: the same instant is Sunday
in Zurich and Saturday in Los Angeles.

## Decision

**The rule engine's public surface is expressed in calendar dates: a year, a month of that year,
and a day of that month, with no clock, no time zone and no locale.** The seam for the schedule
capability is `Schedule.isDue(on: CalendarDate) -> Bool`, exported from `DayByDayKit`.

Three consequences are part of the decision rather than incidental to it:

- **A calendar date that names no day cannot be formed.** The initializer is failable and refuses
  30 February rather than adjusting it. Foundation does the opposite: `Calendar.date(from:)`
  returns 2 March 2026 when asked for 30 February 2026, and 1 January 2027 when asked for month
  13 of 2026, without reporting anything. That silent rolling is the specific behaviour this
  decision exists to keep out of the engine.
- **Conversion between an instant and a calendar date happens at the edges** — where "what day is
  it today?" is asked of the device, and where a tick is written to or read from storage. The
  engine never performs it, so no rule is ever a function of where the phone is.
- **A weekday is a named case, not an integer.** Foundation numbers weekdays from 1 for Sunday
  and ISO 8601 from 1 for Monday; a public integer picks a fight between two correct conventions.

## Consequences

- **Every acceptance test in the schedule capability is a pure function call over literal values,
  and gives the same answer on every machine in every time zone.** No test sets a global time
  zone, and none is quarantined for being flaky in CI. This is the main dividend.
- **DayByDay carries a small date type of its own.** It is a struct of three integers with a
  validating initializer, not a date library: no formatting, no parsing, no arithmetic beyond
  what a rule shape needs. If it ever starts growing convenience API, that is the signal that
  something belonging at the edge has leaked into the engine.
- **Something has to do the conversion, and this ADR does not say what.** The screen that asks
  for today's date and the store that reads back a tick both need it. That code is at the edge
  and will arrive with the Feature that needs it; the engine's contract is unaffected either way.
- **Any future rule shape that genuinely needs a time of day cannot use this seam.** None of the
  four shapes does. A commitment due "at 07:00" would be a notification concern, not a due-ness
  concern, and would be a new decision rather than a violation of this one.
- **Reversing this is expensive and gets more so with each rule shape**, which is why it is an
  ADR taken at the first Story rather than a line in a design document that gets archived.

## Alternatives considered

**`Foundation.Date` plus a `Calendar` and a `TimeZone` parameter** — the conventional Apple-
platform answer, and the one a Swift developer would reach for first. Rejected because it makes
every rule a function of three things instead of two, and because the extra two are ambient
state that acceptance tests would then have to pin. It also invites the exact bug the product
cannot afford: a commitment that reads as due on the wrong day because the device moved.

**`Foundation.Date` with a UTC calendar fixed inside the engine** — the same shape with the
ambient state hidden. Rejected because it is worse than the first: it looks like an instant, so
callers will pass instants derived in local time, and midnight-adjacent dates will silently shift
by a day. Hiding the time zone does not remove it.

**`DateComponents`** — Foundation's own year/month/day carrier, so nothing new to write.
Rejected because every field is optional and the type can hold combinations that are not dates at
all, which pushes validation into every caller and every rule shape instead of into one
initializer. It is a bag of components, not a date.

**A day number — days elapsed since a fixed epoch.** Compact, and it makes "every N days"
trivial arithmetic. Rejected because it is unreadable in a test and in a debugger, which is where
this engine's correctness is actually established: `20_326` says nothing, `29 February 2028` says
everything. Nothing stops the implementation from using such a number internally.
