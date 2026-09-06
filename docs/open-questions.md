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
  **It recurred on a chore, 2026-09-03, and a fourth answer is what caught it.** The
  `chore/on-the-phone` branch wrote `docs/adr/1023-the-bundle-identifier-...`; `add-roster-retirement`
  (#109) merged nineteen minutes later carrying `1023-a-commitment-is-kept-until-a-day-the-roster-holds.md`,
  and the branch renumbered past 1024 — taken meanwhile by #114 — to land as ADR-1025. Two renames
  in one branch, cheap only because a chore has no signed change folder to re-approve. The fourth
  answer is the one now in force and is not in the list above: ADR-1020 put a rule in
  `docs/adr/README.md` — a new ADR takes the lowest number no file **and no open branch** has used —
  so the mitigation is convention, checked by a human, and `main`'s own README does not show which
  numbers an open branch is holding.

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
  #104 rather than closed by it. **An eighth face is the load-bearing one and was never written
  down:** `Commitment.schedule` and `Commitment.keptFrom` are internal, and `DayView.Row` publishes
  only `name` and `isKept` while keeping `commitment` and `date` internal. So `Schedule` and its four
  cases being public buys nothing from outside — there is no public way to get a schedule *out of* a
  commitment, or a commitment out of a row. Making `DayOfMonth.day` public tomorrow would still leave
  B-021 unable to render "the 25th" beside a name. Recorded 2026-09-06.
  **A ninth face, and it is the odd one out: `add-commitment-kind` (#137) made `Commitment.kind` public
  while `schedule` and `keptFrom` stay internal**, because #139's row has to know what to offer before
  anything is recorded and nothing had yet asked for the other two. So a commitment now has four parts,
  two readable and two not, and a screen that can say "a number from 1 to 10" still cannot say "every
  14 days". The widening is still owed by whichever Story first renders a rule, and B-021 is that want.
  Recorded 2026-09-06, at #137's G7.
- **A commitment of a kind nothing can yet record is a row that does nothing when tapped.**
  `add-commitment-kind` (#137) makes a commitment of the number, note or total kind formable and has
  `record` refuse a tick for it, so `day-screen`'s row for one offers nothing — by requirement, and on
  purpose, since a due commitment does not leave the day. Nothing in the shipped app can reach that
  state: day one is nine ticks and the commitments screen defines only the plain kind. Two Stories
  change that, in different lanes: `add-kind-to-commitments-screen` (#142) lets a person choose
  "number", and `add-number-entry` (#139) gives the row a number to offer. If #142 lands first, a
  person who defines a weight sees a row that answers nothing to a tap until #139 merges. No requirement
  forbids the ordering and no edge on the tracker prevents it; the fix belongs to whichever lands first,
  and the cheapest one is an edge from #139 to #142. Recorded 2026-09-06, at #137's G7, from that
  change's `design.md` § *Impact*.
- **Two of #137's tests do not match their scenarios clause for clause, and check 4 cannot see it.**
  Found at `add-commitment-kind`'s second review, 2026-09-06. The G7 fix for a half-written range
  added a fourth malformed place to the test named *a roster store holding what could not be a roster
  is refused*, whose scenario is base spec and says "each of the three places"; the behaviour is
  approved (*a range is both ends or neither*), but the store-level refusal has no scenario of its own.
  And the roster test *two commitments alike in every way but the kind their days take are both held*
  adds the same range twice, so a roster that compared the kind's case while ignoring its range would
  still pass it — the implementation compares whole values, so it is a coverage gap and not a bug.
  `scripts/check-scenario-coverage.ts` maps scenario to test and never test to scenario, which is why
  neither shows. Owed by whichever Story next touches `commitment`'s roster or store requirements,
  as one scenario each.
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
  permits two rows to be equal.

  **The trigger arrived with #104, and this entry said the opposite. Corrected 2026-09-06.** It
  claimed the gap "cannot bite today because a day's list is fixed once the day is: nothing in the
  app can add a row to the screen you are looking at". That is false on `main`.
  `ContentView.swift` calls `screen.returnedTo()` when the commitments screen is dismissed, and
  `DayScreen.returnedTo()` re-reads the roster and forms the day view again from
  `roster.commitments(on: shownDay)` — so stopping a commitment removes a row **from the middle of
  the day list**, and every row below it inherits its neighbour's `\.offset`, on a list the person
  is watching as it comes back. The earlier reading was right that #104 leaves the `ForEach`
  untouched and wrong to conclude it is unrelated: it did not touch the `ForEach`, it built the
  mutation path that makes the `ForEach` unsafe.

  A second face, same cause: `ContentView.swift` picks the refusal notice with
  `row == screen.refusedChangeRow` — value equality — so two rows alike in name and kept-state would
  both draw "Not saved. Try again.", against *A day screen tells on the row that was tapped*.

  **There is no shell-only fix, so this is a Story rather than a chore.** The shell can see only
  `name` and `isKept`; a stable identity that is neither the value nor the position has to come from
  a public widening of `DayView.Row`, which is a delta against `openspec/specs/day-screen/spec.md`
  and a G4. It is the same widening the eighth face above describes, which is an argument for one
  Story covering both. Unowned: the tracker holds no open issue at all.
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
  write nothing.
  **The premise in the title is wrong, and the fix named here pointed at a file this repo does not
  own. Corrected 2026-09-06.** There is no such template: OpenSpec's own
  `node_modules/@fission-ai/openspec/schemas/spec-driven/templates/tasks.md` holds two placeholder
  task groups and no G7 box at all, and nothing in this repo prescribes one either. The box
  propagates by `spec-author` copying the previous change folder, which is why it reaches back to
  `2026-08-23-add-version-command/tasks.md:44` and appears in a dozen more — and why it is still
  arriving: #103 and #104 both carry it.
  **#100 already wrote the wording that fixes it**, in
  `2026-09-06-add-refused-tick-notice/tasks.md`: the box is *"the reviewer having been run and its
  findings written down, not a verdict on them"*. So the chore is to put that form where
  `spec-author` will read it — `.claude/agents/spec-author.md`, beside its existing rule that every
  box must be tickable before the archive — which under rule 6 belongs to the session talking to the
  human. Still not done, and now for a reason: nothing has asked for it.
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
  convention and wants the real bundle identifier — **which is no longer an obstacle: ADR-1025
  landed on `main` 2026-09-06 and the identifier is `com.dbugmann.daybyday`**, so the naming
  decision this entry is waiting on can now actually be taken. `privacy: .public` on the file path is a deliberate
  override of `Logger`'s safe default: harmless on iOS, where the path is a container UUID, but on
  macOS it un-redacts the account short name. And the whole facility is a side effect no test at
  either seam can observe, so nothing regresses it. The next Story that wants to log will copy
  this shape; whichever one that is owes the decision, or a chore does it first.
- **The walkthrough harness recipes in § 4.3 and § 7.17 cannot be rebuilt as written.**
  Found at #104's fourth review, 2026-09-06. Both sections invoke `-scheme UITests`, and their own
  steps create an Xcode project with a `DayByDayUITests` target but no scheme by that name. The
  recipes live in `openspec/changes/archive/2026-09-06-add-commitments-screen/tasks.md`, which is
  **deny-listed for writing** (`.claude/settings.json`, one of the three mechanical guardrails
  `AGENTS.md` names), so this is corrected here rather than there — the archive is the record of what
  was run, and corrections belong in a writable place.
  **The working invocation is committed and running.** #131's XCUITest target is
  `src/DayByDay/DayByDayUITests/`, inside the existing `src/DayByDay/DayByDay.xcodeproj`, and CI
  drives it as `-project src/DayByDay/DayByDay.xcodeproj -scheme DayByDay -destination "platform=iOS
  Simulator,id=<udid>" -only-testing:DayByDayUITests` (`.github/workflows/ci.yml`). Anyone reaching
  for § 4.3 should use that instead of rebuilding anything. Nothing is owed; the entry stands so the
  recipe is not followed off a cliff, and because § 4.3's own standard — evidence nobody can
  re-create is a claim rather than a check — is the part worth keeping.

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
  exception (its 2026-09-04 amendment) was used by this Story.**

  **Two corrections, 2026-09-06.** First, *"a person is told beside the row they tapped"* is a **doc
  comment** on `RefusedChange` — mirrored in that Story's `design.md` — and not the requirement it is
  attributed to. The requirement says *"a person is told beside the thing they asked for"*, and is
  about what the **screen holds**, not where the shell draws it; two paragraphs later the same
  requirement says a commitments screen "SHALL hold no words a person reads". So the mismatch is
  between the shell and a doc comment, which makes the "narrow the requirement" branch of the fix
  largely unnecessary — what is left is either the shell placing the message, or the doc comment
  being brought back to what the spec actually says.

  Second, **the exception is not spent, and reading it as spent was wrong.** ADR-1019's amendment
  states a standing conditional: shell work may ride a Story's branch subject to three conditions,
  and "the return to the rule is the next shell change that **fails any of those three**" — not the
  next shell change outright. A second Story meeting all three may claim it; what the ADR adds is
  that doing so is the signal to revisit the record rather than stretch it again.

  A third thing, unnamed until now: that `design.md` sketches `RefusedChange` with a
  `public var refusal: Refusal` accessor, and **it did not ship**. Had it, the shell would have had a
  way to read the refusal without discarding the commitment. Design-to-code drift, unreviewed.

## Settled

- 2026-09-06 — **`RecordStore.write` no longer throws outside `RecordStoreError`.** `write(_:)`'s
  `try encoder.encode(document)` sat outside the `do` block that wraps everything else it does, so an
  encoding failure escaped as a raw `EncodingError` while the directory-creation and file-write calls
  beside it came back as `.cannotWrite(at:)`. Moving the one line inside the block was the whole fix
  — the existing catch-all already wraps everything there, so no fourth case was needed and no
  requirement moved. Closed on a chore rather than waiting for the `RecordStore.init` gap above, and
  the earlier claim that the two are "naturally met by the same Story" was wrong about this half:
  `init` needs a new case in the seam and a G4, this needed neither. **It is unobservable, and that
  is deliberate**: `RecordDocument` is `Int`s and `String`s to the leaves, with no custom
  `encode(to:)`, so `EncodingError` cannot be provoked and no red test is writable at the seam —
  which is also why this was not a Story. Every one of the 391 kit tests passes unchanged.

- 2026-09-04 — **a day screen's `today` and the day it is showing are two fields, and a tick is
  asked as of the first.** Open since #91's review, which found one `today` serving both roles and
  named `add-screen-navigation` (#93) as the Story where that stops being correct: moving the day by
  writing the same field would leave a tick asked as of the *displayed* date, so navigating forward
  and tapping would write a tick for a day that has not arrived. **#93's grill split the field, which
  is exactly what the entry said it owed.** `DayScreen` now holds `today` and `shownDay` separately,
  `tick(_:)` passes `today`, and `showPreviousDay`/`showNextDay` move only `shownDay`. It is a
  requirement rather than an accident of the code — `openspec/specs/day-screen/spec.md`: *"The tick
  SHALL be the one the row itself offers, asked as of the today the screen was handed and never as of
  the day it is showing"*, with the scenario *ticking a row on a day a day screen has moved onto that
  has not arrived keeps nothing* pinning it. Recorded here 2026-09-06, having been settled on merge
  and missed.

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
