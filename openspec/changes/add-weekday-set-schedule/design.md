## Context

There is no Swift in the repository yet. ADR 1001 decided the language and the shape of the
rule engine — a Swift Package with no UI dependency, driven from the terminal by `swift test`,
whose exported entry point is the seam — but it deliberately stopped short of saying where that
package lives or what a date is to it, because neither was worth guessing without a requirement
in hand. This Story has the requirement, so it answers both, and the three schedule Stories
behind it (#9 day of month, #10 every N days, #11 weekly quota) inherit the answers.

Motivation is in `proposal.md`; the behaviour contract is in `specs/schedule/spec.md` and is not
restated here.

Two facts were verified on this machine on 2026-08-30 rather than recalled, because both change
the design if wrong:

- `swift package init` on the installed toolchain (Apple Swift 6.3.3, Xcode 26.6) generates
  `// swift-tools-version: 6.3`, `swiftLanguageModes: [.v6]`, a Swift Testing test target and no
  external dependency. `swift test` runs offline. The `macos-26` runner CI uses defaults to
  Xcode 26.6 as well, so the same manifest builds there.
- Foundation's `Calendar.date(from:)` **rolls invalid components rather than returning nil**:
  asked for 30 February 2026 it returns 2 March 2026, and asked for month 13 of 2026 it returns
  1 January 2027. It does not report a problem. That single fact is why the third requirement in
  the delta exists and why it is worded as a refusal to adjust.

## Goals / Non-Goals

**Goals:**

- One seam, named below, that every scenario in this delta attaches to and that the next three
  schedule Stories can extend without moving.
- A date model that makes the answer to "is this due?" a function of its two arguments and
  nothing else — no clock, no ambient time zone, no locale.
- The smallest package that CI's existing `swift` job and check 4 can both already handle.

**Non-Goals:**

- An app target, an Xcode project, or any SwiftUI. Nothing here renders.
- Persistence. SwiftData versus GRDB stays open (ADR 1001); the rule engine touches neither.
- Date formatting, parsing, or display. The engine consumes dates; it never prints one.
- A general-purpose date library. `CalendarDate` exists to be the argument of one predicate.

## Decisions

### The seam

**`Schedule.isDue(on:) -> Bool`**, a public instance method on the public enum `Schedule`,
exported from the module `DayByDayKit`:

```swift
public enum Schedule: Hashable, Sendable {
    case weekdays(Set<Weekday>)

    public func isDue(on date: CalendarDate) -> Bool
}
```

Every acceptance test in this change attaches here: one test per `#### Scenario:`, titled
verbatim, constructing a `Schedule` and a `CalendarDate` and asserting on the returned `Bool`.
No process is spawned and no global stream is captured.

The seam's argument type is part of the seam, so the three validity scenarios necessarily
observe the initializer that forms it:

```swift
public struct CalendarDate: Hashable, Sendable {
    public init?(year: Int, month: Int, day: Int)
}
```

That is stated rather than glossed over — it is one boundary with an input contract, not two
seams, and there is no way to call `isDue(on:)` without going through it. Everything else in the
module is internal: in particular `CalendarDate`'s weekday is **not** public, so no test can
reach behind the predicate to assert on it directly. The scenarios that pin weekday derivation
(the leap day, the year boundary) are asserted through a one-weekday schedule, which is how the
product will actually consume it.

*Alternative — a free function `isDue(_ schedule: Schedule, on date: CalendarDate)`.* Equivalent
in testability and marginally less idiomatic Swift. Rejected on style alone; nothing turns on it.

*Alternative — a `Schedule` protocol with one conforming type per rule shape.* It would let each
of the four Stories add a type instead of a case. Rejected: an existential adds a layer for a
closed set of four shapes that only this repository will ever implement, and a protocol cannot be
exhaustively switched over, which is the property the UI will want when it comes to edit a rule.

### `Schedule` is one enum that gains a case per Story

`Schedule` ships here with exactly one case. That is deliberate, not an oversight: #9, #10 and
#11 each add a case to this enum and none of them moves the seam. A single-case enum is the price
of the seam surviving all four Stories, and it is cheaper than the alternative — a
`WeekdaySetSchedule` struct now, replaced by an enum in three weeks, with every acceptance test
already written against the struct.

### A date is a calendar date, not an instant — recorded as ADR 1003

`isDue(on:)` takes a year-month-day value, not a `Foundation.Date`. `CONTEXT.md` already says a
day is the unit the product is organised around and that due-ness is asked *of a date*, not of
the present moment; an instant would make the answer depend on the time zone the device happened
to be in, and would make every acceptance test depend on the time zone of the CI runner. This is
expensive to reverse — it is in the signature of every rule shape — so it is ADR 1003 rather than
a line in a design that gets archived.

### A weekday is a named case, never a number

`Weekday` is a public enum with seven cases, `monday` through `sunday`, and no public raw value.
Foundation numbers weekdays from 1 for Sunday; ISO 8601 numbers them from 1 for Monday. Both
conventions are correct and a public integer would invite the off-by-one that picks the wrong
one. The delta's *Sunday-only schedule* scenario exists specifically to catch it if the internal
derivation gets it backwards. The set is a `Set<Weekday>`, so a duplicated weekday is
unrepresentable and needs no scenario.

### Where the week begins is not decided here, because this rule does not need it

Set membership does not depend on which day starts the week — Sunday is Sunday whether the week
runs Monday-first or Sunday-first. The delta says so normatively so that nobody adds a
first-weekday parameter to the seam by reflex. The question is real, and it belongs to #11, where
"three times a week" cannot be answered without it. Deciding it here would be deciding it without
the requirement that forces the choice.

### An empty set is legal and never due; an impossible date is not legal at all

These two look inconsistent until you name the difference. An empty weekday set has a perfectly
well-defined answer — never due — that the user may not have wanted; 30 February has no answer at
all, so any `Bool` returned for it would be a lie. So the engine answers the first and refuses to
form the second. Refusing to *save* a commitment that can never come due is validation, it
belongs to the screen where a commitment is edited, and it is not this capability's job.

### The package lives at `src/DayByDayKit/`

One SwiftPM package: `Package.swift` at `src/DayByDayKit/`, library target `DayByDayKit` under
`Sources/`, test target `DayByDayKitTests` under `Tests/`, no platform requirement and no
dependency, so `swift test` runs on the macOS CI runner with no Xcode project in the way. CI's
`swift` job finds it by `find . -name Package.swift`, and check 4 finds its tests by walking
`.swift` files from the repository root; both work unmodified.

*Alternative — `DayByDayKit/` at the repository root*, which is the idiomatic Swift layout and
what an Xcode app target would later sit beside. Rejected for one unglamorous reason: the
implementer agent's write scope is `src/**` and `tests/**`, so a root-level package would make
every implementation commit an out-of-scope write, and widening that scope is an agent-definition
edit, which rule 6 says the conductor session must make itself. `src/DayByDayKit/` needs no
configuration change and an Xcode project can reference a local package at any path. If the owner
prefers the root layout, that is a G4 comment and a one-line change here — say so before Stage 5,
not after.

## Risks / Trade-offs

- **#11 may not fit this seam.** "Three times a week" cannot be answered from a schedule and a
  date alone; it needs to know what has already been ticked that week. → Accepted knowingly. The
  seam is the right shape for three of the four Stories and for every screen that draws a day.
  When #11 arrives it will either add a parameter to this method or add a second question beside
  it, and it will do so with a real requirement in hand. Designing that parameter now would be
  inventing the tick history model three Stories early.
- **Foundation will silently roll an invalid date if it is consulted first.** → The validity
  check must reach its verdict *before* Foundation is asked to build anything, and the three
  refusal scenarios are what hold that line. Whether the weekday is then derived through
  `Calendar` or by arithmetic is below the seam and is the implementer's choice.
- **`.gitignore` has no `.build/` or `.swiftpm/` entry**, and both appear the first time
  `swift build` runs. Left alone, the first `git add -A` commits build products. → Task 1.1 adds
  them, and it is the one task in this change that writes outside `src/**`. If the implementer
  treats that scope as binding, it stops there and the conductor makes that one-line edit. Better
  to hit that on the first task than on the commit.
- **Nothing in this repository has ever compiled Swift.** The `swift` CI job and check 4's
  `@Test("...")` reader were both written against no Swift at all. → Expect the first red run to
  be about plumbing rather than about weekdays, and report a defect in either rather than working
  around it (rule 5). The local toolchain was verified today, so a failure on the runner and not
  on the machine is information, not noise.
- **Eleven scenarios is a lot for one Story.** → They are eleven one-line predicates over four
  small types, and four of them exist only because Foundation's date arithmetic fails quietly.
  Cutting the validity requirement would save three tests and leave the trap in place.

## Migration Plan

None. Nothing exists to migrate: this creates a capability and a package, and removes nothing.

## Open Questions

None. Four questions `docs/parking-lot.md` left open reach the delta or a decision above:

- *Is "every day" a set of seven weekdays or an interval of one?* Both, and it does not matter.
  `isDue(on:)` is a predicate, not a normal form; two rules that select the same days are equally
  correct, and the delta pins the seven-weekday answer with a scenario. No "every day" rule shape
  is needed.
- *What happens on days before a thing existed?* Not this capability's question. A schedule is a
  rule about dates; when a commitment started, ended or was paused is a property of the
  commitment, and it belongs to the Feature that defines one.
- *Where does a week begin?* Deferred to #11, on the stated ground above that this rule cannot
  need it.
- *Where does the Swift package live?* Decided above: `src/DayByDayKit/`, with the reasoning and
  the rejected root-level alternative both written down.

Two facts that could have been assumptions were checked instead, and are in *Context*: the
generated manifest's tools version, and Foundation's rolling of invalid date components.
