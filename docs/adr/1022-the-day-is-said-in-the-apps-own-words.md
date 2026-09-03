# 1022. The day is said in the app's own words, not the device's

- Status: accepted — proposed and argued by `add-screen-date` (#92), the change that first says a
  day back to a person
- Date: 2026-09-03
- Deciders: Diego Bugmann

## Context

Everything `DayByDayKit` has answered so far is a fact: is this commitment due, is it kept, what is
at this place. `add-screen-date` (#92) is the first thing it is asked that has an *audience* — the
day a person is looking at, said in words they read off a phone. "Thursday 3 September 2026" is not
a fact about the calendar in the way that "Thursday" is; it is a sentence, and a sentence is written
in a language.

Three places could hold it, and two of them are already ruled out by decisions this repository has
taken.

**`CalendarDate` cannot.** ADR-1004 put the rule engine's surface in calendar dates precisely to
keep clocks, time zones and locales out of it, and said what the type is allowed to be: "a struct of
three integers with a validating initializer, not a date library: no formatting, no parsing, no
arithmetic beyond what a rule shape needs. If it ever starts growing convenience API, that is the
signal that something belonging at the edge has leaked into the engine."

**The app shell cannot.** `CONTEXT.md` § *App shell* says the shell decides nothing, and gives the
test: whether the thing could be wrong in a way a test would catch. It names a **formatting rule**
as one of four examples that fail that test and owe a Story. A shell handed a weekday, a day, a
month and a year, assembling them into a sentence, is exactly that rule, sitting in the one place in
this codebase no test reaches.

So it lands in `day-screen`, behind the seam, with the rest of the requirements. That much was
forced. What was not forced is **which words**, and Foundation is standing right there with an
answer. Measured on this machine on 2026-09-03, `DateFormatter` with `dateStyle = .full` asked for
3 September 2026:

```
en_US -> Thursday, September 3, 2026      de_CH -> Donnerstag, 3. September 2026
en_GB -> Thursday, 3 September 2026       fr_CH -> jeudi, 3 septembre 2026
                                          ja_JP -> 2026年9月3日 木曜日
Locale.current on this machine is en_CH -> Thursday, 3 September 2026
```

## Decision

**A day is said in words this package owns: the English names of the seven weekdays and the twelve
months, written out in `DayByDayKit`, with no `Locale`, no `DateFormatter` and no localisation.**
The same day is said in the same words on every device, in every region, in every language setting.

Two consequences are part of the decision rather than incidental to it:

- **The form is fixed by the spec, not by a style.** "Monday 31 August 2026" — weekday name, day of
  the month with no leading zero, month name, four-digit year, single spaces — with "Today · " in
  front on the day the question is asked as of. It is quoted verbatim in every scenario of #92's
  delta, because the words *are* the requirement: there is nothing else to a day title.
- **The comma is deliberately absent**, which makes the form differ from every locale's full date
  style, including the one this machine happens to run (`en_CH`, above). An implementation that
  quietly reached for `DateFormatter` therefore fails the scenarios here, in this language, rather
  than passing locally and failing on the first phone whose region differs.

## Consequences

- **A day title is something a scenario can state.** That is the whole dividend: `#### Scenario: a
  day view says its day as a weekday, a day of the month, a month and a year` has an expected string
  in it, and it is the same string in CI, on the owner's laptop and on a phone bought abroad. With
  the device deciding, that scenario could only have asserted that *something* was returned.
- **The app is English, and says so by shipping.** A person with a German phone reads "Thursday
  3 September 2026". The owner is the only user (`AGENTS.md` § *Working with the human*), so the
  cost today is zero and the honesty is worth more than a half-localisation that covers the date and
  nothing else on the screen.
- **Localising later is a spec change, not a refactor.** Every scenario quotes a string, so adding a
  second language rewrites those scenarios and the requirement above them. That is the expensive
  half of this decision and the reason it is an ADR: it is cheap to take now and not cheap to undo.
  The trigger that would force it is a second person using the app in another language — nothing
  else does.
- **Nineteen names are written out by hand, and a typo in one would ship.** #92's delta answers that
  with two scenarios that name every weekday and every month, rather than with a review habit.
- **It does not extend to every string in the app by itself.** The shell already draws two sentences
  about a record that could not be read (#91), and `add-refused-tick-notice` (#100) will add more.
  The reasoning here — a sentence a test can be wrong about lives behind the seam, in fixed words —
  applies to those on its face, but each is that Story's decision to take, and this record does not
  take it for them.

## Alternatives considered

**`Date.FormatStyle` or `DateFormatter` with `Locale.current`** — the conventional Apple-platform
answer, one line long, and it speaks the person's language for free. Rejected because it makes the
day title a function of the device: the five strings above are five different requirements, and a
scenario that must accept all of them is asserting nothing. It also puts a locale back inside
`DayByDayKit`, which is the thing ADR-1004 exists to prevent — the same class of bug, one screen
along: a rule that answers differently because of where the phone is.

**A formatter pinned to one fixed locale** — `DateFormatter` with `Locale(identifier: "en_GB")`,
which is deterministic and hands the nineteen names to Foundation. Rejected on two counts. It is
deterministic only as far as ICU's data is stable across OS versions, which is not a promise Apple
makes and not something this repo can test for; and the strings it produces are the *only* ones
available, so "Thursday, 3 September 2026" with its comma would be the form, chosen by a locale
database rather than by anyone. Writing out nineteen words costs less than depending on a table
nobody here controls.

**A `DayTitle` value with parts, composed by the shell** — the weekday, the day, the month, the year
and a flag saying whether it is today, with SwiftUI assembling the sentence. Rejected because
assembling is the formatting rule, and this is the specific move `CONTEXT.md` § *App shell* forbids.
It would also have made the shell the only place the wording could be reviewed, and the shell is the
one place with no test.

**Publishing `CalendarDate`'s year, month and day and letting the caller say the date** — what
`docs/backlog.md` and `docs/open-questions.md` both predicted this Story would do. Rejected as the
same move as the one above with an extra step, and as the convenience-API growth ADR-1004 names as a
warning sign. The parts have no reader once the words are formed inside the package; the known gap
stays open and stays owed by whatever first needs a date's parts *outside* `DayByDayKit`.
