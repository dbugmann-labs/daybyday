## Context

See `proposal.md` § *Why*. What matters here is that this change adds no state, no stored part and
no file form: everything it asks for is a sentence derived from values that already exist, so the
whole design is about *where the sentence is composed* and *who is allowed to read it*.

Four facts the grill measured, and this design turns on all four:

- **Nothing in the package or the app turns a schedule into words today.** `DayTitle.swift` is the
  only precedent for words at all, and it holds full weekday names — "Monday" — as an internal
  table read by `DayView.title(asOf:)`. It is not reusable here: this change wants "Mon".
- **`Weekday` has no order of its own.** It is a plain `enum` with no `CaseIterable`, no
  `Comparable` and no raw value, and a weekday set is a `Set<Weekday>`. The only Monday-first list
  in the package today is the wire order inside `CommitmentCoding.swift`, which exists to make a
  roster file stable and is not a display rule. So week order has to be stated somewhere, and
  stating it is a requirement rather than a convenience.
- **What the two screens publish is thin.** `CommitmentsScreen.kept` and `.stopped` are
  `[Commitment]`, and a `Commitment` publishes `name` and `kind` and nothing else —
  `schedule` and `keptFrom` are internal. `DayView.Row` publishes `name` and `isKept`, keeping
  `commitment` and `date` internal.
- **`Rhythm` already carries the number a person gave, unjudged.** `Rhythm.dayOfMonth(32)` is a
  legal value, and `Rhythm.schedule(keptFrom:)` — internal — is where it turns into `nil`. The
  preview has to say something about such a rhythm without judging it a second way.

`CONTEXT.md` § *Rhythm in words* fixes the vocabulary; the grill landed it on this branch before
this folder existed, and writing the delta turned up no second term.

## Goals / Non-Goals

**Goals:**

- One sentence per schedule, composed in one place, read by three surfaces. An entry, a row and the
  form's preview say the same rhythm the same way because they are asking the same function.
- No widening of what a schedule gives back. The nine faces of `docs/open-questions.md` § *Known
  gaps* stay exactly as they are; this change closes none of them and needs none of them.
- Nothing on disk moves. No stored property, no coding, no document version — a person's phone
  reads and writes exactly the bytes it did before.
- The shell composes nothing. Every string it draws arrives whole from `DayByDayKit`.

**Non-Goals:**

- A general formatter, a pluralisation rule or a number style. Four shapes, four sentences, written
  out.
- Localisation, which ADR-1022 already decided and priced.
- Any read-back of a schedule's payload, in either direction — including parsing words back into a
  schedule, which nothing asks for.
- Making a row or an entry a type of its own. § *The seam* says why not.

## Decisions

### The seam

**No new seam and no new type.** Four members on four types that acceptance tests already drive,
all of them derived and none of them stored:

- **`Schedule.inWords: String`** — public, and the one place the words are decided. Every scenario
  in `specs/schedule/spec.md` is driven here, on a `Schedule` built directly, without a commitment,
  a screen, a store or a date.
- **`Commitment.rhythmInWords: String`** — public, `{ schedule.inWords }`. This is what a
  commitments screen entry says, because an entry *is* a `Commitment`:
  `CommitmentsScreen.kept` and `.stopped` are `[Commitment]` and stay so.
- **`DayView.Row.rhythmInWords: String`** — public, `{ commitment.rhythmInWords }`. What a row
  says, alongside `name` and `isKept`.
- **`Rhythm.inWords: String?`** — public, and `nil` is the whole of "previews nothing". Every
  preview scenario is driven here.

**An entry did not become a type of its own**, which was the open half of the grill's seam
question. A `CommitmentsScreen.Entry` holding a name and a rhythm in words would be a new seam
where the rule says fewer are better and an existing one wins; it would collide head-on with
`add-kind-to-commitments-screen` (#142), which puts a third thing in the same entry and would
either extend that type or fight it; and it would move `kept`'s element type, which the shell, the
stop-keeping flow and every one of the twenty-odd existing commitments-screen tests are written
against. Adding one computed property to `Commitment` costs none of that.

**No payload accessor becomes public**, which the grill settled and this seam keeps:
`Commitment.schedule` stays internal, and so do `DayOfMonth.day`, `DayInterval.days` and
`WeeklyQuota.timesPerWeek`. What a commitment publishes is one more *sentence*, not one more part.
The distinction is the whole of ADR-1033: a sentence can be wrong in a way a test catches, and it
is caught inside the package; a payload handed out is a rule the shell then has to compose, which
is the move `CONTEXT.md` § *App shell* forbids.

### One table of words, two switches, and the scenario that pins them together

`Sources/DayByDayKit/ScheduleWords.swift` is internal and holds four functions, one per shape,
keyed on the shape and its number — `weekdays(Set<Weekday>)`, `dayOfMonth(Int)`, `everyNDays(Int)`,
`weeklyQuota(Int)` — exactly as `DayTitle.swift` holds nineteen names for the day title and
publishes none of them.

Two callers switch onto it. `Schedule.inWords` switches over the four cases and passes each
payload straight through. `Rhythm.inWords` switches over its own four cases, guards each number
through the very initializer `CommitmentsScreen.define` guards it through — `DayOfMonth(day:)`,
`DayInterval(days:)`, `WeeklyQuota(timesPerWeek:)` — and returns `nil` when one refuses.

**Two switches is one more than ideal and it is the cheaper end of the trade.** The alternative was
`Rhythm.inWords = schedule(keptFrom: X)?.inWords`, which needs an `X` a rhythm does not have: a
rhythm carries no start date, and inventing a sentinel date inside a value function to satisfy a
signature is a lie in the code that a later reader has to un-read. The drift the second switch
risks — a preview that says something the defined commitment then does not — is pinned by a
scenario rather than by care: *an interval rhythm is said without a day to keep the commitment
from* asserts the rhythm's words equal the schedule's words for two different start dates, and *a
rhythm being built is said in the words the schedule it names says* does it for all four shapes.
Reusing the three failable initializers rather than restating `1...31`, `>= 1` and `1...7` is what
stops the preview and the refusal disagreeing about which numbers exist.

### Monday-first, and where the week order lives

`Weekday` gains nothing. The order is a display rule and lives in `ScheduleWords`, as a fixed array
of the seven cases from Monday to Sunday paired with their three-letter names — one array, so a
missing day is a compile-time hole rather than a name silently dropped from a set.

Making `Weekday: CaseIterable, Comparable` instead was rejected: it would put a week order into the
rule engine, where **no rule shape consults one**. `CONTEXT.md` § *Weekly quota* says where a week
begins is deliberately still undecided, and a `Comparable` conformance ordering Monday first is
exactly that decision taken by accident, in the one place it must not be — a quota's week is not
this sentence's week, and the two would then share a type-level answer.

### Words for a schedule the screen would refuse, and words for a rhythm that is not one

Two different things, deliberately said two different ways, and the split is what the grill
settled:

- An **empty weekday set** is a schedule. The engine forms it, a roster holds it, and a day view
  draws no rows for it for ever. It gets words — "No day" — because every schedule does, and
  because an entry that said nothing where a rhythm belongs reads as a missing rhythm rather than
  an empty one. The commitments screen still refuses to define on it (ADR-1028), and the refusal's
  wording is unchanged.
- A **number no schedule can be built on** — the 32nd, every 0 days, 8 times a week — is not a
  schedule at all. There is nothing to say about it, so `Rhythm.inWords` is `nil` and the form
  shows no preview line. It must not show a refusal there: the person is mid-edit, has not asked
  for anything yet, and the one place a refusal is worded is `define`. Saying it twice, in two
  wordings, is the failure `CONTEXT.md` § *Refused change* was named to prevent.

### A scenario title that is now wrong

`specs/commitment/spec.md` keeps the scenario *two commitments alike in name and not in rhythm are
two entries a person cannot tell apart* byte-for-byte, title included, and its title is false the
moment this change ships. It is kept because `openspec` 1.10.0 will not let it go. Measured on this
folder, 2026-09-06:

```
$ openspec validate add-rhythm-in-words --strict
✗ [ERROR] commitment/spec.md: MODIFIED "A commitments screen lists the commitments its roster
  keeps, in the order they were taken on" omits scenario(s) the current spec still has: "two
  commitments alike in name and not in rhythm are two entries a person cannot tell apart". Copy
  them into the MODIFIED block (a MODIFIED requirement replaces the whole block, so archive
  refuses to drop them).
```

The check has exactly one hole — `validator.js` skips a MODIFIED block whose requirement the same
delta also RENAMEs — and taking it would rename a requirement whose title is still accurate, to
dodge a check, at the price `add-commitment-kind` (#137) measured on this same tool version: a
RENAMED requirement is appended to the bottom of the spec at archive, because recomposition looks
each original block up under its *old* name. `openspec/specs/` may not be hand-edited (rule 2), so
that reordering would be permanent. A stale scenario title is a blemish a one-line delta fixes the
day the tool preserves position.

Three things follow, and they are the reason this is written down rather than absorbed. The
requirement's prose says the title is wrong and why, so the archived spec carries the correction
next to the defect. The scenario immediately after it — *two commitments alike in name and not in
rhythm are told apart by the rhythm their entries say* — asserts what is true now, on the same
pair of commitments. And the existing test keeping that name is **not renamed and not edited**:
everything it asserts still holds, and a rename here would be churn in service of a title the tool
is holding hostage.

### The shell rides this Story, and what it may contain

Three `Text(...)` views under ADR-1019's 2026-09-04 exception: one in each list of
`CommitmentsView.swift`, one in the define form for the preview, one under each row in
`ContentView.swift`. Every string arrives whole from `DayByDayKit`; the shell chooses no word, no
separator and no order, and the preview holds no state — it is `rhythm.inWords` recomputed from the
form's own `@State` on every keystroke, which is what "live" means here and why the preview is a
property of a `Rhythm` rather than something a screen keeps.

The one claim in this delta that no test can reach is the phrase **"and nothing else"** in what an
entry says. `Commitment.kind` is public, so nothing stops a future shell drawing it; the current
spec's "a name and nothing else" was untestable in exactly the same way and for exactly the same
reason. `tasks.md` § 5 answers it the only way it can be answered — by looking at the running app
in the simulator — and names what must be on the screen and what must not.

## Risks / Trade-offs

- **A word is wrong on one shape and every other shape is green.** → Four roll-call scenarios, one
  per shape: all seven weekday names, all thirty-one ordinals, all seven quota numbers, and the
  four-shape scenario at the top. This is ADR-1022's answer to nineteen hand-written names, applied
  to the seven abbreviations, three ordinal suffixes and four sentence forms this change writes
  out by hand.
- **English ordinals are written from the last digit and 11th, 12th and 13th ship wrong.** → Its
  own scenario, named for the trap, plus the thirty-one roll call that would catch it anyway.
- **A `NumberFormatter` or string interpolation of a locale-aware type reaches into the package and
  the words become the device's again.** → *A number is said in digits with no grouping separator*
  asserts "Every 1000 days", which is the one string a grouping formatter gets wrong in most
  regions. The parallel is ADR-1022's deliberately absent comma.
- **The preview and the definable rhythms drift apart** — the form previews "The 31st" for a number
  `define` then refuses, or shows nothing for one it would accept. → Both sides guard through the
  same three failable initializers, and *a rhythm carrying the number at each end of what it
  allows is said in words* mirrors the existing *a commitments screen accepts the number at each
  end of what a rhythm allows*, number for number.
- **"7x a week" reads as less informative than "Every day"**, and a reader may think the quota is
  the same rhythm as the weekday set. → Deliberate, settled at the grill, and pinned by *a weekly
  quota of seven times a week is not said as every day*, which asserts both strings in one
  scenario so that a later change cannot quietly merge them.
- **The day screen row grows a second line on every row**, on the screen the product is organised
  around, and on a phone. → The owner asked for exactly this at the grill, against the
  recommendation of showing it only where two rows share a name, and `tasks.md` § 5 puts the real
  screen in front of them before G7 rather than after it.

## Migration Plan

None, and this is worth one sentence rather than an omission: no stored property, no coding, no
document version and no place on disk changes, so a roster or a record written by the build before
this one is read by the build after it byte for byte, and the reverse is true too. This is the
first change since `add-commitment-kind` (#137) that touches what a commitment *says* without
touching what a commitment *is*.

## Open Questions

**None.** `grill.md` § *Left open* is "None." — every question the frontier raised was answered
over three rounds on 2026-09-06 — and the one thing it left to this document, the seam, is settled
in § *The seam* above: it is a design decision about where a computed property hangs, not a
preference whose answer only the owner holds.

Writing the delta raised no residual round. Three things came close and none of them is the
owner's: the grouping separator in a number (§ *Risks* — no realistic interval reaches four
digits, and the rule exists to stop a formatter, not to style a number); the week order (a
requirement, decided in § *Monday-first* because no rule shape consults one); and the stale
scenario title (a tool defect with a measured cost either way, § *A scenario title that is now
wrong*). Each is stated here so that a reviewer can disagree with it in one place.
