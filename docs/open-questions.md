# Open questions

Everything that is **not a want**: questions the product has not answered, technical decisions
nobody has had to make yet, and gaps in what is built that were left open on purpose.
`docs/backlog.md` holds the wants and only the wants, which is what keeps it groomable.

Nothing here is a backlog entry and nothing here is groomed. An item leaves by being **answered
by the change that finally forces it** — a `## Questions for you` round inside Stage 4, or an
ADR — and moves to *Settled* below with the pointer. If an item turns out to be something you
want the app to *do*, it was in the wrong file: capture it with `/atlas idea` and delete it here.

## Open product questions

- **Week turnover.** A quota of three reading nights, met twice by Sunday: does the unfinished
  third vanish, or is it recorded as a miss? Nothing in the day-one list decides it and the
  answer changes what a week *is*. Forced by the first Story that renders a quota's state.
- **How far back the past stays writable**, and what a day before the commitment existed shows.
  `CONTEXT.md` says the past is writable; it does not say how far, and "for ever" and "since the
  commitment was created" are both defensible.

## Open technical decisions

- **SwiftData or GRDB.** ADR-1001 chose Swift and SwiftUI and deliberately left persistence
  open. Still open, and nothing has forced it: the rule engine is pure and stores nothing.
  The Story that first persists a tick decides it, and it is worth an ADR when it does.
- **What the app target is called.** Where the package lives is settled — `src/DayByDayKit`, and
  CI discovers `Package.swift` rather than assuming a path, so a second package needs no CI
  change. The target that draws the screens does not exist yet and is unnamed.

## Known gaps

Things that are built, or deliberately not built, in a state someone will trip over.

- **A schedule's payload cannot be read back out.** Surfaced at #9's review, 2026-08-31.
  `DayOfMonth` and `Schedule.dayOfMonth(_)` are public but `DayOfMonth.day` is internal, so an
  app target can build a rule on the 25th and never recover the `25` to render "the 25th" in a
  row. `.weekdays(Set)` reads back fine, so the two shapes are asymmetric, and `DayInterval`
  carries the same asymmetry. Nothing needs it yet — no surface renders a rule — and the first
  Story that does needs a delta widening it, not a bug fix.
- **No UI smoke layer.** Surfaced at `day-screen`'s G1, 2026-08-31. Acceptance tests for the
  first screen attach at a view-model seam inside `DayByDayKit`, so nothing automated proves
  SwiftUI actually draws: a row left blank by a misspelled binding passes CI. The answer is one
  or two XCUITest cases, and it is deferred because it costs an ADR, an `xcodebuild` job against
  a simulator, and a change to CI check 4, which reads `@Test("...")` display names out of Swift
  source and cannot see an XCTest method name. Revisit when there is a second screen to regress
  against.
- **Playwright is ruled out on a fact, not a preference**, recorded so it is not re-proposed. It
  drives browser engines only, ships no `_ios` counterpart to its experimental `_android`, and
  cannot launch Apple's Simulator. It is unreachable without reversing ADR-1001, which chose
  native Swift and SwiftUI partly by rejecting the browser-based option outright.

## Settled

- 2026-08-31 — **"every day" may be expressed two ways** and that is not a contradiction: an
  interval of one day and a weekday set of all seven say the same thing. `CONTEXT.md`
  § *Every N days*, settled by `add-every-n-days-schedule`.
- 2026-08-29 — **the tick record is durable, not transient.** A past tick is looked at again, and
  the failure being solved is a gap a few days old that cannot be reconstructed. This is also
  what disqualifies Apple Reminders on its own terms — it nags and forgets.
  `docs/adr/1001-swift-and-swiftui.md`.
- 2026-08-29 — **test enumeration reads Swift source.** CI check 4 reads `@Test("...")` display
  names out of the source text, because no Swift tool reports them without going through
  unpublished internals. One of the two things ADR-1001 left open.
