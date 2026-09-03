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

## Open technical decisions

- **When an ADR number is claimed.** Today it is taken at Stage 4, when the file is written,
  and merged at Stage 9 — so two branches open at once can both write the same number and
  neither learns of it until a rebase conflicts in `docs/adr/README.md`. Story #11 hit it twice
  in one day (`docs/retrospective.md` §7), the second time for the price of a G4 signature,
  because the number is cross-referenced from inside the signed change folder. The candidate
  answers are: claim the number at merge and let the branch carry a placeholder; let the
  archive assign it, as `/opsx:archive` already assigns an archive date; or keep claiming
  early and add a check that fails the PR when the number is taken. The first two stop the
  collision reaching the change folder at all, which is what made it expensive. Worth an ADR
  when something forces it; nothing does yet, and the workaround is a rename.
- **The app's bundle identifier.** Opened by ADR-1019, which settled the target's name and
  deliberately did not settle this. Changing it after even one install orphans the store the
  previous identifier wrote, and it wants a domain the owner actually controls rather than a
  placeholder that becomes permanent by being installed once. Forced by the first Story that puts
  the app on a real phone rather than a simulator.

## Known gaps

Things that are built, or deliberately not built, in a state someone will trip over.

- **A schedule's payload cannot be read back out.** Surfaced at #9's review, 2026-08-31.
  `DayOfMonth` and `Schedule.dayOfMonth(_)` are public but `DayOfMonth.day` is internal, so an
  app target can build a rule on the 25th and never recover the `25` to render "the 25th" in a
  row. `.weekdays(Set)` reads back fine, so the two shapes are asymmetric, and `DayInterval`
  carries the same asymmetry. Nothing needs it yet — no surface renders a rule — and the first
  Story that does needs a delta widening it, not a bug fix. Grew a fourth case with
  `add-tick-record` (#55), 2026-09-02: a `History` gives back nothing but a yes or no, and a
  `Tick` gives back neither its commitment nor its date. `add-record-store` (#56) was expected
  to widen that and did not need to — the store lives in the same module and reads the internal
  members — so the gap is still the screen's, and the widening is still owed by whichever Story
  first renders a rule or a tick. Grew a fifth case with `add-day-navigation` (#72), 2026-09-03,
  and this one is the closest to biting: the shell can now move between days and still cannot say
  which day it is on, because `CalendarDate`'s `year`, `month` and `day` are internal and it is
  not `Comparable`. Rendering a date is a delta against `openspec/specs/schedule/spec.md` rather
  than `day-screen`, so it is a Story of its own against a second capability — which is why #72
  did not widen it in passing.
- **The store must be opened under `Library/Application Support/`.** Owed by #56's design,
  2026-09-02. `RecordStore` keeps the record at whatever place it is given and cannot enforce
  the choice from where it sits; `Caches/` is purged by the system and `tmp/` is not backed up,
  and either would silently lose the one thing the product promises to keep. It was written
  expecting a Story to create the app target; ADR-1019 made that a chore instead, and a shell may
  choose nothing — a place a store is opened at is exactly the kind of decision that fails
  `CONTEXT.md` § *App shell*. So the obligation did not travel with the target: it falls to the
  first Story that persists a tick from inside the app, realistically `day-screen` (#27), and this
  is the line that says which.
- **`RecordStore.init` can throw outside `RecordStoreError`.** Surfaced at #56's review,
  2026-09-02. A place that exists but cannot be read as data — a directory, a file without
  read permission, or on iOS a store protected by data protection when the app is launched
  in the background before first unlock — escapes as a raw Foundation error rather than one
  of the three declared cases, so a caller has nothing to match on. Every delta requirement
  holds (it is still refused, and nothing is overwritten); what is missing is a fourth case in
  the seam, which is a `design.md` edit and a second G4. Left deliberately, for the Story that
  first meets it — realistically the app target or `day-screen` (#27) — to add with a delta.
- **The shell identifies rows by equality, and two rows may be equal.** Surfaced at #71's
  review, 2026-09-03. `src/DayByDay` draws `List(dayView.rows, id: \.self)`, so a row's
  `Hashable` conformance is what SwiftUI uses to tell one row from another — but `day-screen`'s
  spec deliberately permits two rows to be equal, since a commitment handed to a day view twice,
  or two commitments alike in name, schedule and kept-from day, produce identical rows. SwiftUI
  given duplicate ids drops or misanimates rows. It cannot bite today: the day-one week has no
  duplicates, and `add-tick-from-row` (#71) made rows count their date towards equality, which
  narrows nothing here because every row in one list carries that list's date. The fix is the
  shell's — a stable identity that is not the value — and it belongs to whichever Story first
  draws a list the user can add to. Left alone in #71 deliberately: changing it there would have
  been a silent edit to the app target from a Story scoped to `DayByDayKit`.
- **The Story issue template asks an agent to write the G4 marker string.** Surfaced writing
  #91..#93, 2026-09-03. `.github/ISSUE_TEMPLATE/story.yml`'s last Definition-of-ready checkbox
  quotes the marker line literally, so an agent rendering the template faithfully writes that
  string into the body of a Story that has not been approved — which `AGENTS.md` rule 1 forbids
  "for any other reason, including while explaining that you are waiting for it". Every Story so
  far has quietly deviated, saying "records the G4 marker" instead: #70, #71, #72 and now
  #91, #92, #93. The deviation is right and was undocumented, which is the actual defect — the
  next agent has no way to know the template is not to be followed here.
  **It cannot trip the automated gate**, and the first report of this said it could: check 5
  reads `/issues/<n>/comments` and never the body (`scripts/check-g4-approval.ts:50`), so a
  marker-shaped string in a template-rendered body is invisible to it. What is at risk is a
  person or an agent grepping issue text, and the rule itself. The fix is one line in the
  template, which is a chore; it is written down here rather than done because nothing was
  asked for it.
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

- 2026-09-02 — **the app target is called `DayByDay`, and it is a chore rather than a Feature.**
  It sits at `src/DayByDay/` beside `src/DayByDayKit/`, is a hand-written `.xcodeproj` needing no
  Xcode GUI, and runs in the iOS Simulator. The suffix already carries the distinction — the kit
  is the part with requirements, and what is left is the product — and `PRODUCT_NAME =
  $(TARGET_NAME)` makes the target name the label under the Home screen icon, so every other
  candidate is a name plus an override putting `DayByDay` back. What it is *not* called, and what
  it deliberately does not decide, is the bundle identifier, now an open technical decision above.
  `docs/adr/1019-the-app-shell-runs-in-the-simulator.md`, and `CONTEXT.md` § *App shell* for the
  guard that keeps the lane honest.

- 2026-09-02 — **the record is kept in one file, neither SwiftData nor GRDB.** One versioned JSON
  file, written whole and atomically on every tick, at a place the app names. The record is a set
  of (commitment, date) pairs that is already a value and fits in kilobytes for years; a file
  adds no platform floor, no dependency and no model mirror of the engine types, and it is the
  form a person can read and copy to a new phone. The trigger for reversing it is a tap that
  measurably stalls on the write, and the file is then what a database imports from.
  `docs/adr/1017-records-are-kept-in-one-file.md`, settled by `add-record-store` (#56).
- 2026-09-02 — **the past is writable back to the day a commitment is kept from, and no
  further.** Answered as a consequence rather than a choice: a tick exists exactly where the
  commitment is due, and ADR-1013 already bounds that at the kept-from day. Whether a screen
  offers all of it is `day-screen`'s (#27, B-016), not the record's. Settled by
  `add-tick-record` (#55).
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
