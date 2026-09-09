## Context

See `proposal.md` § *Why* for the motivation and `grill.md` for the ten answers it was settled on.
What shapes the approach here is smaller and mechanical: **a day title is quoted 64 times across
`day-screen/spec.md`, in eleven requirements**, and only two of those eleven are about the day title
at all. The other nine quote it in a scenario as a stand-in for *which day is this screen showing*
or *is that day the today*. Both of those readings survive today only because the title spells out a
date and prefixes "Today · " on one of them; after this change it says a weekday, and a weekday
answers neither question. That is what makes the delta large.

Three shipped answers do the work instead, and none of them moves in this change:

- **`DayScreen.dayPickerReach.opensOn`** — the day being shown, as a `CalendarDate`. Added by
  `add-day-picker` (#176), which put it there deliberately: "which day that is is a fact about the
  control".
- **`DayScreen.offersGoingBackToToday`** — whether the day being shown is the today the screen was
  handed. #176's requirement says in as many words that a caller needing this "asks *A day screen
  says whether it offers the way back to today* and nothing else".
- **`DayView.title`** — the words, which after this change are the weekday and nothing else.

## Goals / Non-Goals

**Goals:**

- A day title that fits a row holding four controls, without truncating or shrinking it.
- One weekday abbreviation across the app, not two.
- Leave the capability's scenarios asserting at least what their names claim, which a plain
  string swap would not.

**Non-Goals:**

- **Changing what the day screen *does*.** Ten of the twelve requirements in the delta change no
  behaviour. Their scenarios are re-witnessed; nothing they require moves.
- **Deciding the day-title row's layout.** The picker sitting between the chevrons is the shell's
  under ADR-1019, confirmed in the Simulator at implementation rather than specified here.
- **Making the date something the app can assert again.** It is the picker's now, in the device's
  words. See § *What this costs*.
- Localisation of any kind. ADR-1022 stands.

## Decisions

### The seam

**`DayView.title` and `DayScreen.title`, both already there.** No new seam: this change narrows an
existing one rather than adding to it. Every acceptance test in the delta drives one of these two,
or — for the ten re-witnessed requirements — `DayScreen.dayPickerReach` and
`DayScreen.offersGoingBackToToday`, which are equally existing seam members.

`DayView.title` **loses its `asOf` argument**: `public func title(asOf: CalendarDate) -> String`
becomes `public var title: String`. The argument decided exactly one thing, the word *Today*, and
that word is gone. Keeping it would put an ignored parameter in the seam and would force the
requirement to state that an argument decides nothing — which no scenario can assert except by
sampling two values and finding them equal, where the compiler can enforce it outright. The
alternative, keeping the signature for source compatibility, buys nothing: the only callers are
`DayScreen.title` and this repo's own tests.

### Two requirements are replaced, not amended

`openspec validate --strict` **errors when a MODIFIED block omits a scenario the current spec has**
(`validator.js:521`, shared with archive so the two cannot disagree). So a requirement can only be
modified if every one of its scenario names survives. For the two title requirements, six names do
not — "a day view of the day it is asked as of says Today before the date", "every month is said by
its own name", "a day of the month below ten is said without a leading zero" and three more are
statements about a form that is going away. Their requirement names are equally untrue.

So both are `## REMOVED` and two new ones are `## ADDED`. `RENAMED` + `MODIFIED` was checked and
does not help: the validator follows the rename back to the old block and applies the same
scenario-preservation rule.

**Nine of the fifteen scenario names are deliberately reused verbatim** where the behaviour still
has the same shape — "a day view says the leap day of a leap year", "a day screen shown again on a
later day says that day" and so on. A reused name keeps its acceptance test, so only its assertion
changes; seven names are new and need new tests, and nine are retired with their requirements.

### Five scenarios are re-homed rather than dropped

The requirement being removed holds five scenarios that are not about a day view's title at all —
"a day screen moved off today keeps the day it is showing when the app is shown again" and four
like it. Removing the requirement would delete them from the capability, losing the only coverage
of *a screen moved off its today stays there when the app is shown again*. They move into **A day
screen re-reads its day and its record when the app is shown again**, whose own prose already
decides that ("Which day it then shows SHALL depend on where it was"), with their names kept so
their tests are kept.

### What the other ten requirements assert instead

**The rule, stated once because it is applied thirty-odd times:** outside the two requirements that
define a day title, a scenario needing to witness *which day the screen is showing* asserts **the
day its day picker opens on**; one needing to witness *whether that day is the today* asserts
**whether it offers the way back to today**. The title is quoted only where the requirement is
genuinely about the words — which, outside the two, is one clause: *A day screen that cannot read
its roster draws the day and no rows* is about the screen still saying its day, so its clause stays
and simply becomes `"Mon"`.

The cheaper alternative was a plain string swap — every `"Today · Monday 31 August 2026"` becomes
`"Mon"`. **It was rejected on a measurement, not a preference: six scenarios would then have
asserted nothing their names claim.** The clearest is *picking a day on a day screen does not
change the today it was handed*, whose two assertions are `"Monday 15 June 2026"` and
`"Today · Monday 31 August 2026"` — under a swap both read `"Mon"`, and the scenario passes while
witnessing neither the pick nor the today. *A day screen shows a day picked after the today it was
handed* collapses the same way (25 December 2026 and 31 December 9999 are both `"Fri"`), as do
*moving a day screen does not change the today it was handed*, *a day screen returned to keeps the
today it was handed*, *a day screen goes back to the today it was last handed rather than the day it
opened on*, and *what a day screen tells on a row ends when the day screen is sent back to today
from another day*.

Applying the rule uniformly rather than only to those six is deliberate: a spec where thirty
scenarios assert a weakened proxy and six assert the real thing is one nobody can review, and
leaving the title quoted in nine requirements rebuilds the 64-site coupling that made this change
cost what it costs. After this delta a day title is quoted in three requirements instead of eleven.

**This does not contradict `grill.md` § *Settled* 6.** That answer — "nothing the app owns can state
which date is showing, so no scenario, test or screenshot asserts it" — is about what the app
**says**, and it holds: no scenario in this delta asserts a date in words anywhere. `opensOn` is an
answer, not words; it is a `CalendarDate` the screen already gives out and the device has no part
in it. The settled answer costs the *date on screen* its assertions, and this rule is what keeps
the *day being shown* assertable at all.

### Why the two weekday tables stay apart

`ScheduleWords.weekdayOrder` already holds "Mon" through "Sun" and is tempting to share.
`DayTitle.weekdayNames` keeps its own copy. The two are alike by coincidence of this decision, not
by construction: `ScheduleWords`' table is an **ordered array** because its job is to join a
`Set<Weekday>` into "Mon, Wed, Sat" in Monday-first order, and it is `schedule`'s display rule;
`DayTitle`'s is a **lookup by weekday** and is `day-screen`'s. Sharing one table would make a
future change to either rhythm words or day titles silently change the other, and the thing saved
is seven string literals. `DayTitle.monthNames` is deleted outright — it loses its only caller.

### One MODIFIED block carries a sibling Story's amendment

`add-commitment-editing` (#148, PR #188) merged onto `main` after this folder was written, and it
amended *A day screen reads its roster again when it is returned to*: being returned to now **does**
read the record place again where a record is being kept, and two scenarios were added for it. That
requirement is one of the ten this change restates.

A MODIFIED block replaces the whole requirement, so a block written against the older text would
have merged that amendment away — silently, because the two edits sit in different files and git
reports no conflict. `openspec validate --strict` caught it on the omitted scenario names alone;
the reverted prose it does not check for.

**This delta therefore states that requirement as `main` now has it, with only its own two edits
re-applied** — the two `THEN` lines that witnessed the day in words become
`its day picker opens on <date>`. #188's prose, its two new scenarios and their two tests come
across unchanged; neither new scenario asserts a day title, so nothing about this change touches
them. Restating the older text was never a real option: it would undo a requirement that has passed
G4, shipped and merged.

## Risks / Trade-offs

- **A large mechanical delta invites a mechanical implementation.** Ten requirements are restated in
  full and 79 test assertions move. → `tasks.md` § 1 forbids renaming or deleting any test that a
  delta scenario names, and § 6.1 pins the test count so a quietly dropped test is a stop.
- **`swift test` is the only thing that catches a stale assertion.** CI check 4 matches scenario
  *titles* to test titles, so a reused scenario name whose assertion was never updated passes it. →
  It cannot pass `swift test`: the implementation returns "Mon" and the old assertion expects
  "Today · Monday 31 August 2026". The check is a coverage net, not a correctness one, and § 6.1
  says so.
- **The day title can no longer tell a person which day they are on.** A screen showing 24 August
  and one showing 31 August both say "Mon". → That is the point of the change, and the picker beside
  it says the date. If the row turns out to read badly on the phone, that is a further chore, not a
  respec — `grill.md` § *Left open*.
- **The date on screen becomes untestable.** After this, no test or screenshot can assert which date
  the day screen shows, because the picker renders it through the platform. → Accepted at the grill
  with the cost named; ADR-1022 is amended to record it rather than leaving the ADR claiming
  something that stopped being true.
- **`DayView.title` losing `asOf` is a breaking signature change.** → The package has two callers,
  both in this repo, and the compiler finds every one.

## Migration Plan

None. No stored data, no file format and no persisted record is touched; `RecordDocument`,
`RosterDocument` and every record already kept are untouched. The change is a display rule and its
callers, and it ships in one commit series on one branch.

## Open Questions

**None.** `grill.md` § *Left open* carries two items and neither is open for this delta:

1. **The picker becomes a tap target in the middle of a row #184 will make draggable.**
   `add-adjacent-day-views` (#184) pages the day under the finger and is blocked on this Story, so a
   compact `DatePicker` between the chevrons is a gesture conflict waiting for it. This is #184's to
   settle and nothing in this delta constrains how: the requirement says what the screen *says its
   day is*, and says nothing about where any control sits. Deliberately left there.
2. **Whether the row still lays out well once the picker is its centre** is a shell observation
   under ADR-1019, confirmed in the Simulator at implementation (`tasks.md` § 4) rather than decided
   here. If the short title still shares that row badly, that is a further chore and not a respec.

Writing the delta raised no residual round. The one question it turned up — what the nine
incidental requirements assert once a weekday can witness neither the day nor the today — resolved
to a fact rather than a preference: a plain string swap leaves six named scenarios asserting
nothing, which is measurable against the spec and needs no one's opinion. It is settled in
§ *What the other ten requirements assert instead* rather than asked.
