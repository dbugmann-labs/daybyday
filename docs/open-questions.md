# Open questions

Everything that is **not a want**: questions the product has not answered, technical decisions
nobody has had to make yet, and gaps in what is built that were left open on purpose.
`docs/backlog.md` holds the wants and only the wants, which is what keeps it groomable.

Nothing here is a backlog entry and nothing here is groomed. An item leaves by being **answered
by the change that finally forces it** — the grill's rounds at the top of Stage 4, the residual
round after them, or an ADR — and moves to *Settled* below with the pointer. If an item turns out to be something you
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
  did not widen it in passing. **One face of this closed with `add-commitments-screen` (#104),
  2026-09-06:** that Story's commitments screen has to seed a date picker with the day it offers
  to keep a commitment from, and a picker speaks instants, so it is the first thing that needed
  ADR-1004's conversion run backwards. `CalendarDate`'s `year`, `month` and `day` are now `public
  let`s, authorised by one requirement added to `openspec/specs/schedule/spec.md` — *A calendar
  date gives back the year, the month and the day it names*. The widening shipped before that
  requirement existed and was caught at #104's second review; the Story was reopened for a second
  G4 rather than reverted, on the ground that this entry had named those three members as owed
  since #72. **Six faces remain, and none of them is closed by that requirement, which says so in
  its own prose:** `CalendarDate` is still not `Comparable`, and `DayOfMonth`, `DayInterval`,
  `WeeklyQuota`, `History` and `Tick` still give their payloads back to nothing outside the
  module. The ranges those three value types accept are unreadable too, which is why
  `CommitmentsView`'s steppers write `1...31` and `1...7` a second time — a seventh face, added by
  #104 rather than closed by it.
- **`RecordStore.init` can throw outside `RecordStoreError`.** Surfaced at #56's review,
  2026-09-02. A place that exists but cannot be read as data — a directory, a file without
  read permission, or on iOS a store protected by data protection when the app is launched
  in the background before first unlock — escapes as a raw Foundation error rather than one
  of the three declared cases, so a caller has nothing to match on. Every delta requirement
  holds (it is still refused, and nothing is overwritten); what is missing is a fourth case in
  the seam, which is a `design.md` edit and a second G4. Left deliberately, for the Story that
  first meets it — realistically the app target or `day-screen` (#27) — to add with a delta.
  **Met and deliberately left open by `add-day-screen` (#91), 2026-09-03.** That Story is the
  first thing that opens a store from inside the app, so it is the caller with nothing to match
  on — and it chose not to widen the seam. Its `DayScreen` collapses every refusal it cannot act
  on differently into one `RecordState.unreadable`, and names only the one where a person's
  correct action differs: a record written by a later version of DayByDay, which
  `RecordStoreError.laterForm` already distinguishes. So the fourth case buys nothing on the
  screen, and the owner's answer at #91's question round said so in as many words. It is still
  owed by whatever first needs to tell a locked store apart from a corrupt one — a message
  saying "try again in a moment" rather than "something is wrong with your record".
- **The shell identifies rows by position.** Surfaced at #71's review, 2026-09-03, as
  *identity by equality*: the shell drew `List(dayView.rows, id: \.self)`, so a row's `Hashable`
  conformance told one row from another, while `day-screen`'s spec deliberately permits two rows
  to be equal — a commitment handed to a day view twice, or two commitments alike in name,
  schedule and kept-from day, produce identical rows — and SwiftUI given duplicate ids drops or
  misanimates them.

  **That is no longer the shape, and this entry described a line that had already gone.**
  `125da39`, `chore(shell): draw a row's kept flag` (#105), replaced it the same day with
  `ForEach(Array(screen.dayView.rows.enumerated()), id: \.offset)`, for a different reason: a tap
  flips `isKept`, which is part of the value, so keying on the value made SwiftUI read a tap as
  one row removed and another inserted. Corrected 2026-09-06.

  **What that fixed and what it did not.** Distinct offsets cannot collide, so the duplicate-id
  failure above is gone outright. The gap is not closed, though — it moved: an index is stable
  across a tap and not across an insertion, a removal or a reorder, where every row after the
  change point takes on the identity of its neighbour. Same misanimation, different trigger. It
  cannot bite today because a day's list is fixed once the day is: nothing in the app can add a
  row to the screen you are looking at. The fix is unchanged and still the shell's — a stable
  identity that is neither the value nor the position.

  **It is unowned, corrected 2026-09-06.** This entry named `add-commitments-screen` (#104) as the
  Story that would meet it, on the reasoning that it is the first to draw a list the user can add
  to. Read against #104 as it actually stands, that is wrong twice over. It draws the *commitments*
  screen's lists rather than the day screen's, and it leaves `ContentView.swift`'s
  `id: \.offset` exactly as it found it. Its own lists key on `id: \.self`, which looks like the
  original failure and is not: `specs/commitment/spec.md` in that folder carries a requirement
  refusing a commitment the roster already keeps, so value-uniqueness is guaranteed precisely
  where value-identity is used.

  Which sharpens the rule worth remembering here: **value identity is safe exactly where the model
  refuses duplicates**, and unsafe on the day screen because `day-screen`'s spec deliberately
  permits two rows to be equal. So this waits for a day screen whose list can change while someone
  is looking at it, and no Story on the tracker is that yet.
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
- **A day screen's `today` is both the day it is on and the day it is asked on.** Surfaced at
  #91's review, 2026-09-03. `DayScreen` keeps one `today`, and `tick(_:)` passes it to
  `Row.tick(asOf:)` — but `CONTEXT.md` § *Today* separates those deliberately, saying that
  "confusing the two is what would let a screen offer a tick for a day that has not happened".
  The two coincide while a day screen can only ever be on today, so the guard is correct and
  unreachable, and #91's delta approves exactly this shape. It stops being correct in
  `add-screen-navigation` (#93): moving the screen's day by writing the same field would leave
  the tick asked as of the *displayed* date, so navigating forward two days and tapping a row
  would write a tick for a day that has not arrived — the refusal `add-tick-from-row` (#71)
  exists to enforce. #91's `design.md` claims the guard "becomes reachable with #93", which is
  true only if #93 splits the field; splitting it is the finding. **Owed by #93's grill**, and
  written down here because #93 is two Stories away and nobody who has not read that review
  would rediscover it.
- **The tasks template puts G7 inside the implementer's own checklist.** Surfaced at #91's
  review, 2026-09-03. A change's `tasks.md` carries a box reading "`mattpocock-skills:code-review`
  reports nothing unresolved on either axis (**G7**)", and `openspec validate --archived`
  requires every box ticked — so the box asserting G7 is satisfied is necessarily ticked by the
  implementer before the reviewer has run, and the archived record shows a ticked G7 no reviewer
  produced. It is four Stories deep: `2026-09-02-add-day-view/tasks.md:123`,
  `2026-09-03-add-tick-from-row/tasks.md:101`,
  `2026-09-03-add-day-navigation/tasks.md:112`, and #91's own. It is not merely cosmetic: on
  #91 the implementer read that box as instructing it to perform G7 and reported having done
  so, which is the one thing `AGENTS.md`'s routing table gives to a separate agent that may
  write nothing. The fix is to the template the change folder is generated from, which is a
  chore; it is recorded rather than done because nothing has asked for it.
- **Playwright is ruled out on a fact, not a preference**, recorded so it is not re-proposed. It
  drives browser engines only, ships no `_ios` counterpart to its experimental `_android`, and
  cannot launch Apple's Simulator. It is unreachable without reversing ADR-1001, which chose
  native Swift and SwiftUI partly by rejecting the browser-based option outright.
- **`DayByDayKit` logs now, and nobody chose how.** Surfaced at #103's review, 2026-09-04.
  `DayScreen.swift` carries `import os` — the module's first non-Foundation import — and a
  `Logger` on the one path where a failure cannot be reported through the seam: the day-one
  rollback whose `removeItem` itself fails, leaving a partial roster at the place that a later
  open reads back as a legitimate one. Recording it is the honest option and the reviewer agreed
  it should not go back to `try?`. What is unresolved is that it arrived inside a review fix
  rather than through a design, so three things were set by default rather than decided. The
  `subsystem: "DayByDayKit"` / `category: "RosterStore"` naming is not Apple's reverse-DNS
  convention and wants the real bundle identifier, which is still `com.example.DayByDay` on
  `main` because the rename lives on PR #111. `privacy: .public` on the file path is a deliberate
  override of `Logger`'s safe default: harmless on iOS, where the path is a container UUID, but on
  macOS it un-redacts the account short name. And the whole facility is a side effect no test at
  either seam can observe, so nothing regresses it. The next Story that wants to log will copy
  this shape; whichever one that is owes the decision, or a chore does it first.
- **`RecordStore.write` can throw outside `RecordStoreError`.** Found during #100, 2026-09-06.
  `write(_:)`'s `let data = try encoder.encode(document)` (`RecordStore.swift:80`) sits outside
  the `do` block starting at `RecordStore.swift:82`, so an encoding failure escapes as a raw
  `EncodingError` rather than being wrapped as `RecordStoreError.cannotWrite(at:)` the way the
  directory-creation and file-write calls already inside that block are. It does not change
  #100's delta — the refused-tick notice follows any thrown error, whatever its type, so the
  shell tells the same thing either way — but a caller that switches on `RecordStoreError` sees
  nothing for this case, the same shape as the `RecordStore.init` gap above. Unowned; nothing in
  this repo yet switches on `RecordStoreError`, so it is naturally met by the same Story that
  finally widens `init`'s case for a caller wanting to tell failures apart, since a caller wanting
  one wants the other. Cheaper than that gap to close: moving the one line inside the `do` block
  is enough, because the existing catch-all already wraps everything there as
  `.cannotWrite(at:)` — no new case needed.
- **The walkthrough harness recipes in § 4.3 and § 7.17 cannot be rebuilt as written.**
  Found at #104's fourth review, 2026-09-06. Both sections invoke `-scheme UITests`, and their own
  steps create an Xcode project with a `DayByDayUITests` target but no scheme by that name; the
  correct invocation is `-scheme DayByDay -only-testing:DayByDayUITests`. The recipes are superseded
  in practice by #131's committed XCUITest target, which gets the scheme and path right, and neither
  section is executed by CI since the UI-test target lives outside the repo (ADR-1029). The gap is
  recorded because the archived change folder now holds instructions that fail at their last step —
  § 4.3's own standard is that evidence nobody can re-create is a claim rather than a check, and this
  is how it would be discovered: an agent or a human following the recipe from nothing but the
  archive would hit the scheme error. Unowned; whoever next needs to rebuild the walkthrough harness
  should report this rather than working around it.

- **§ 7.17's ninth-check record quotes what was checked but not how.** Found at #104's fourth review,
  2026-09-06. The record describes check 9 fully — what was tapped, what the screen should show —
  but omits two setup edits its execution depends on. A rebuild from the section alone drops check 9
  at its first assertion: a setup step stopping "Budget" between check 7 and check 8, so a stopped
  commitment is on hand for the ninth check's take-up-again, and a `typeText("\n")` inside check 8
  to dismiss the keyboard before the rhythm picker is revealed (recorded in that section at lines
  586–598). The section leaves the full `WalkthroughUITests.swift` code but truncates the setup
  story. Again, the standard is that evidence nobody can re-create is a claim rather than a check.

- **`RefusedChange` carries a `Commitment` its only consumer discards.** Found at #104's fourth
  review, 2026-09-06. `CommitmentsScreen.swift` publishes `public enum RefusedChange` with cases
  `stopping(Commitment, Refusal)` and `keepingAgain(Commitment, Refusal)`, carrying the commitment
  the person tapped to start the refusal. `CommitmentsView.swift:76` and `:93` destructure the
  commitment as `_`, discarding it and drawing only the message, so the requirement
  `design.md` cites — "a person is told beside the row they tapped" — describes placement the shell
  does not actually do. The requirement is met literally and thirteen scenarios pin it; what the
  story owes is either the shell placing the message beside the row that produced it (a layout
  change) or the requirement being narrowed to match what the shell does (a requirement edit by
  whichever Story next touches this screen). A secondary note: `.stopping` and `.keepingAgain` are
  typed `(Commitment, Refusal)` but only ever constructed with `.notKept`, so four of the six cases
  are structurally unreachable, which is defensible but worth knowing. **ADR-1019's bounded
  exception (its 2026-09-04 amendment) was used by this Story:** it exempts shell edits from the
  general rule that changes to `src/DayByDay` return to the `chore/` rule when they fail to meet
  the review's own bar, and only for "the next shell change that fails any of [the three conditions
  set by the first shell Story]" — meaning add-commitments-screen is the one Story the exception
  was written for, and the next shell change reads against "has a second Story claimed it yet".

## Settled

- 2026-09-06 — **the bundle identifier is `com.dbugmann.daybyday`, and it is fixed from the first
  install on a phone.** Reverse-DNS on the name the `dbugmann-labs` organisation already carries, so
  the prefix stays true whether or not a domain is ever bought. The trigger this entry named — the
  first thing that puts the app on a real phone — fired from a direction it did not anticipate: a
  chore wanting a week of real use, not a Story. It could not wait, because on iOS the container
  holding `DayScreen.recordPlace` is keyed to the identifier, so changing it after an install hands
  the app an empty container and says nothing. The UI test bundle takes
  `com.dbugmann.daybyday.uitests`, which nothing keys a container to.
  `docs/adr/1025-the-bundle-identifier-is-com-dbugmann-daybyday.md`.

  **Signing is settled with it, and deliberately not in the project file.** The committed
  `project.pbxproj` stays unsigned — `CODE_SIGN_IDENTITY = ""` — so CI's simulator build needs no
  certificate on a runner; `scripts/install-on-phone.ts` passes the identity, the team and
  `CODE_SIGNING_ALLOWED=YES` on the command line, where they outrank the project. That shape was
  chosen off a measurement rather than a preference: with the project as it stands a device build
  **succeeds and is unsigned** (`code object is not signed at all`, no `embedded.mobileprovision`),
  and setting only the identity in the project does not fix it because `CODE_SIGNING_ALLOWED = NO`
  still suppresses the step. Both checked 2026-09-06. **What is not settled is anything past the
  build**: no phone has ever been paired with this machine, so the install, the launch and the
  seven-day expiry are unrun. `docs/running-the-app.md` § *On your own phone* says so in place.

- 2026-09-06 — **the app is proved to draw, by a committed XCUITest target on the chore lane.**
  Open since `day-screen`'s G1 on 2026-08-31: acceptance tests attach at a seam inside
  `DayByDayKit`, so a row left blank by a misspelled binding type-checked, passed every test behind
  the seam, and shipped. The entry named three costs — an ADR, an `xcodebuild` job, and a change to
  CI check 4. The job landed with the compile step on 2026-09-06, this is the ADR, and **the third
  cost turned out not to exist**: it was booked on the assumption that UI tests would satisfy
  scenarios, and on the chore lane there are none to satisfy, so check 4 never has to read a name
  that is not a `@Test("...")` literal. Choosing the lane deleted the cost rather than paying it.

  Two facts settled it, both measured rather than recalled. **Swift Testing cannot be used in a UI
  test bundle** — Xcode compiles one with `-module-alias Testing=_Testing_Unavailable`, so
  `import Testing` fails with `Unable to resolve module dependency: '_Testing_Unavailable'` — which
  is why the layer is XCTest and why check 4 could never have seen it. And **the layer goes red for
  the right reason**: misspelling `Text("Today")` in the shell, a change that compiles and that all
  300 seam tests pass, ends the run `** TEST FAILED **`.

  What it asserts is deliberately thin, and the rule is worth keeping: **it asserts that the shell
  drew, never what it drew.** Anything asserting *what* is a requirement, and requirements live
  behind the seam.

  **It had been proven twice before it was committed, from inside `add-commitments-screen` (#104)**,
  where a harness was built outside the repository to evidence that Story's shell walkthrough and
  discarded each time — a new Xcode target being past that Story's shell exception. That is where
  the recipe and the `-1719`-not-`-25211` correction about Accessibility grants came from. Keeping
  the harness is what ends the rebuild-and-discard cycle.

  **It is gated so it does not cost five minutes a push**: skipped while a PR is a draft, and
  skipped unless the diff reaches `src/DayByDay/`, `src/DayByDayKit/Sources/` or the workflow.
  Nothing merges without it having run.
  `docs/adr/1029-the-ui-smoke-layer-is-a-chore-and-it-is-xctest.md`.

- 2026-09-06 — **the shell no longer swallows the one failure a tick reports.** `DayScreen` now
  carries `public private(set) var refusedChangeRow: DayView.Row?`, and `ContentView.swift` draws
  `Text("Not saved. Try again.")` in a red caption under the row's name when a row equals it.
  `try? screen.tick(row)` was deliberately left as it is — the screen does the telling, not the
  shell, so the swallow is no longer a silence — and the refusal still reaches the caller as well,
  which is the half that stayed testable throughout. Three requirements in
  `openspec/specs/day-screen/spec.md` pin it: *A day screen tells on the row that was tapped that a
  change could not be kept*, *What a day screen tells on a row lasts until the app is shown again,
  a change is kept, or the day it is showing changes*, and *A day screen tells nothing on a row
  where there was no tick to refuse*. Settled by `add-refused-tick-notice` (#100).

- 2026-09-03 — **the record is kept at `<Application Support>/DayByDay/record.json`, and the
  day screen is what chooses it.** `RecordStore` keeps the record wherever it is given and cannot
  enforce the choice from where it sits, so the choice had to land somewhere that owes
  requirements; `Caches/` is purged by the system and `tmp/` is not backed up, and either would
  silently lose the one thing the product promises to keep. #56's design expected a Story
  creating the app target to decide it, ADR-1019 made that target a chore instead, and a shell
  that decides nothing could not — so the obligation waited for the first Story that persists a
  tick from inside the app. That is `add-day-screen` (#91): `DayScreen.recordPlace` is the
  decision, it is a requirement in `openspec/specs/day-screen/spec.md`, and a scenario pins it.
  Settled by #91. **Extended 2026-09-04 by `add-roster-store` (#103)**: the same directory now
  holds a second file, `roster.json`, chosen the same way and for the same reasons —
  `DayScreen.rosterPlace` is a requirement in the same spec with its own scenario, and the two
  stores are independent, at places of their own, so taking on a commitment does not rewrite a
  history. B-009 therefore carries a directory rather than a file, which is what "one thing at
  one place that a backup can carry" now means.

- 2026-09-02 — **the app target is called `DayByDay`, and it is a chore rather than a Feature.**
  It sits at `src/DayByDay/` beside `src/DayByDayKit/`, is a hand-written `.xcodeproj` needing no
  Xcode GUI, and runs in the iOS Simulator. The suffix already carries the distinction — the kit
  is the part with requirements, and what is left is the product — and `PRODUCT_NAME =
  $(TARGET_NAME)` makes the target name the label under the Home screen icon, so every other
  candidate is a name plus an override putting `DayByDay` back. What it is *not* called, and what
  it deliberately does not decide, is the bundle identifier, settled by ADR-1025.
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
