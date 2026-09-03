## 1. The public surface

- [ ] 1.1 Add `Sources/DayByDayKit/DayTitle.swift`, internal: the seven weekday names and the twelve
  month names, and whatever shape the two members below call into. Nothing in this file becomes
  public — no requirement asks for the name of a weekday on its own — and `Weekday.swift` is not
  touched, for the reason in `design.md` § *Why the words are the app's own*. Verify with
  `cd src/DayByDayKit && swift build` exiting 0.
- [ ] 1.2 Add `public func title(asOf today: CalendarDate) -> String` to `DayView` and
  `public var title: String` to `DayScreen`, exactly as `design.md` § *The seam* gives them, each
  body `fatalError("not implemented")`. Nothing else becomes public and no other existing source
  file is edited. Verify with `swift build` exiting 0 and `swift test` still reporting the 192 tests
  from #8, #9, #10, #11, #42, #55, #56, #70, #71, #72 and #91 passing. If any of those goes red
  here, stop: adding an unused member is not supposed to change behaviour, and that is a rule-5
  stop rather than a test to edit.
- [ ] 1.3 Confirm the starting point before writing a test: `pnpm run check:scenarios` reports
  `0/16 covered` for this change and names `"a day view says its day as a weekday, a day of the
  month, a month and a year"` as next.

## 2. Scenarios — one acceptance test each, in delta order

Each task takes exactly one `#### Scenario:` from `specs/day-screen/spec.md` and writes one
acceptance test whose `@Test("...")` display name is that scenario title verbatim, then makes it
pass with the smallest change that does. Never write two before the first is green (`AGENTS.md`
rule 3).

2.1 to 2.10 go in the existing `Tests/DayByDayKitTests/DayViewTests.swift`, beside #70's, #71's and
#72's; 2.11 to 2.16 go in the existing `Tests/DayByDayKitTests/DayScreenTests.swift`, whose suite is
already `@MainActor` and whose place-per-test temporary directory helper they reuse. **No test may
touch the real application-support directory.**

Verify each with `cd src/DayByDayKit && swift test`: the named test green, every earlier test still
green. Every date below was measured in `design.md` § *Context* rather than recalled; do not
re-derive a weekday, and do not substitute a date the delta does not name. Quote the expected string
in full in each test — an expectation assembled by the test out of the same pieces the code uses
proves nothing.

`design.md` expects these to run red on their own: 2.1 (the `fatalError`), 2.2 (if the day asked as
of were ignored), 2.3 (if "Today" were said for any day rather than one), 2.5 (if the day of the
month were padded), 2.6 and 2.7 (one wrong name in either table), 2.9 (if a day view with no rows
answered from a row), 2.11 (the second `fatalError`), 2.12 (if a clock were read) and 2.14 (if
`title` were stored at opening rather than computed). **Record which ones actually ran red as you
go, in this file** — a prediction here is not evidence.

- [ ] 2.1 `a day view says its day as a weekday, a day of the month, a month and a year` — Monday
  31 August 2026 asked as of Thursday 3 September 2026, expecting `"Monday 31 August 2026"`. The
  first tick of the seam, and the two-digit day of the month.
- [ ] 2.2 `a day view of the day it is asked as of says Today before the date` — Thursday
  3 September 2026 asked as of itself, expecting `"Today · Thursday 3 September 2026"`. The middle
  dot is U+00B7 with a space on each side.
- [ ] 2.3 `a day view of a day before the one it is asked as of says the date and not Today` —
  Wednesday 2 September 2026 as of Thursday 3 September 2026. The negative control for 2.2: without
  it, "Today · " could be unconditional.
- [ ] 2.4 `a day view of a day after the one it is asked as of says the date and not Today` — Friday
  4 September 2026 as of Thursday 3 September 2026. The other side of the same control, and the one
  that fails an implementation comparing "not later than" rather than "equal".
- [ ] 2.5 `a day of the month below ten is said without a leading zero` — Tuesday 1 September 2026
  as of Thursday 3 September 2026, expecting `"Tuesday 1 September 2026"` and not `"01"`.
- [ ] 2.6 `every weekday is said by its own name` — the seven day views from Monday 31 August 2026
  to Sunday 6 September 2026, each asked as of Thursday 1 January 2026, which is none of them, so no
  title says "Today". Seven full strings asserted.
- [ ] 2.7 `every month is said by its own name` — the fifteenth of each month of 2026, each asked as
  of Thursday 1 January 2026. Twelve full strings asserted; this is the test that catches a typo in
  the month table.
- [ ] 2.8 `a day view says its day in the first supported year and in the last` — Saturday 1 January
  1583 as of Monday 3 January 1583, and Friday 31 December 9999 as of Monday 27 December 9999. Both
  ends of what `CalendarDate` accepts.
- [ ] 2.9 `a day view says the leap day of a leap year` — Tuesday 29 February 2028 as of Monday
  28 February 2028.
- [ ] 2.10 `a day view holding no rows says its day just the same` — a day view of no commitments at
  all on Wednesday 2 September 2026. Assert both that it holds no rows and that it says its day:
  the title is read off the date, not off the rows.
- [ ] 2.11 `a day screen says the day it is showing` — opened as of Thursday 3 September 2026 at a
  place where nothing has been kept, expecting `"Today · Thursday 3 September 2026"`.
- [ ] 2.12 `a day screen says the day it was handed rather than the day it really is` — Monday
  3 January 1583 and Monday 27 December 9999. Any implementation that reaches for `Date()` fails
  both halves.
- [ ] 2.13 `a day screen says the day its own day view says, asked as of the day it was handed` —
  assert `screen.title` equals `screen.dayView.title(asOf:)` for the day it was opened on. The
  assertion that the screen delegates rather than formats a second time.
- [ ] 2.14 `a day screen shown again on a later day says that day` — opened Monday 31 August 2026,
  then `shown(asOf:)` Tuesday 1 September 2026. Fails an implementation that computed the title once
  at opening.
- [ ] 2.15 `a day screen that cannot read its record still says the day` — a place holding a run of
  bytes that is not a record, built the way `DayScreenTests` already builds one. Assert both
  `recordState` and the title: ADR-1021 applied to a second question.
- [ ] 2.16 `a day screen says the same day after a tick is made on it` — tick the screen's own row
  and assert the title is unchanged, which is #91's "a day screen does not change day when a tick is
  made on it" seen from the title.

## 3. The shell

No scenario covers this section — `docs/open-questions.md` § *No UI smoke layer* — so keep it to
what has no judgement in it, and change nothing in `DayByDayKit` from here.

- [ ] 3.1 In `src/DayByDay/DayByDay/ContentView.swift`, draw `Text(screen.title)` above the rows in
  the `List` that is already there. No branch, no interpolation, no string of its own, and nothing
  else in the file changes.
- [ ] 3.2 Build and run it: `xcodebuild -project src/DayByDay/DayByDay.xcodeproj -scheme DayByDay
  -destination 'platform=iOS Simulator,name=iPhone 17' build`, then `xcrun simctl` boot, install and
  launch as ADR-1019 records. Confirm the title is drawn, says today, and reads as one line a person
  can take in at a glance. **Record what you saw here, including the exact string on screen** —
  nothing in CI can observe it, and the whole want is that a person can read it.

## 4. Gates

- [ ] 4.1 `cd src/DayByDayKit && swift test` reports 208 tests passing and no failures — the sixteen
  here plus the 192 from #8, #9, #10, #11, #42, #55, #56, #70, #71, #72 and #91, none of which may
  change — and `pnpm run verify` exits 0.
- [ ] 4.2 `pnpm exec openspec validate add-screen-date --strict` exits 0 and `pnpm run checks`
  reports scenario coverage as 16 of 16.
- [ ] 4.3 `mattpocock-skills:code-review` reports nothing unresolved on either axis (**G7**).

Archiving is not a task here. It is the last commit on this branch, run by the janitor after G7, and
`openspec validate --archived` requires every box above to be ticked before it.

One move falls outside this change folder and outside `spec-author`'s reach, so it is named here
rather than done here: `docs/open-questions.md` § *Known gaps*, where the payload read-back entry
owes a line saying this Story met its fifth face and deliberately left it open — the shell never
needed a `CalendarDate`'s parts, because the words are formed behind the seam, so what is still owed
is a Story that renders a date or a rule *outside* `DayByDayKit`. A chore commit alongside the merge,
as `d1f99dc` was for #71 and #72. `docs/adr/1022-the-day-is-said-in-the-apps-own-words.md` and its
row in `docs/adr/README.md` are not in that category and are written by this Story's own commit.
