# Open questions

Everything that is **not a want**: questions the product has not answered, technical decisions
nobody has had to make yet, and gaps in what is built that were left open on purpose.
`docs/backlog.md` holds the wants and only the wants, which is what keeps it groomable.

Nothing here is a backlog entry and nothing here is groomed. An item leaves by being **answered
by the change that finally forces it** — the grill's rounds at the top of Stage 4, the residual
round after them, or an ADR — and moves to *Settled* below with the pointer. If an item turns out to be something you
want the app to *do*, it was in the wrong file: capture it with `/atlas idea` and delete it here.

## Open product questions

- **What a total's day answers when its additions overflow to NaN.** Two additions of
  `Decimal.greatestFiniteMagnitude`, each above zero and so each an addition, sum to NaN, and the
  history answers that day not kept at the `record` seam — against `record`'s rule that a total is
  kept exactly where its additions sum to its target or more. `day-screen` refuses an addition that
  would take a day's sum past thirty-eight significant digits, so no entry made on a phone reaches
  it; a store's file could still hold such a day, because each addition read back is re-formed on
  its own. Whether that day is kept, not kept, or refused where it is read is undecided, and it is a
  product decision rather than a least fix. Measured 2026-09-13 at the grill of
  `cover-record-rules` (#222), which left it alone.

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
  **It recurred again, 2026-09-07, and the convention is what failed.** `add-number-record` (#138)
  committed `docs/adr/1033-a-number-is-taken-back-by-naming-the-day.md` at 22:41:19 on 2026-09-06
  and `add-rhythm-in-words` (#144) committed `docs/adr/1033-a-schedule-says-its-rhythm-in-words.md`
  at 22:52:10 — eleven minutes apart, proposed by two sessions in parallel, both pushed. ADR-1020's
  rule is exactly what should have caught it and did not: the second session read 1032 as the
  highest and never asked what an open branch was holding. What caught it was a box in a Story's own
  `tasks.md` — #138's 8.1, which told the agent to confirm 1033 was still free and to **report
  rather than renumber**, and which duly reported the collision at `4812770` and was left unticked
  until G7 settled it; #144's 8.1 found the same thing six minutes later and also declined to move.
  Both are hand-written Story instructions rather than a systemic check, so neither would have fired
  on a Story whose § 8 lacked one. Resolved at `2e5db79` by #144 renumbering to 1034 before merge,
  #138 keeping 1033 on `docs/adr/README.md`'s first-claim rule. Cheap, but not free: nothing in
  `src/` names an ADR number, so the rename reached only the ADR, its README row, `CONTEXT.md` and
  #144's own change folder — but that folder is signed, so the digest moved and the Story was
  re-approved, which is the same price #11 paid. The third candidate answer above — keep claiming
  early and add a check that fails the PR when the number is taken — is the one this recurrence
  argues for, the convention having now failed on its second outing.

- **The shell reads its own clock per row.** `ContentView.swift:164` asks each row what it offers as
  of `today()`, a `Calendar.current` read (`ContentView.swift:59-62`), while the screen holds a today
  it was handed at `init` and re-handed on `shown(asOf:)`. The two can disagree across midnight, and
  gating the row tap the same way inherits that. It predates this Story — all five existing row
  offers are already asked that way — and closing it means either exposing the screen's today or
  moving row answers onto the screen, both of which #174's grill rejected on their own merits.
  Recorded 2026-09-09, at #174's close-out.

- **The general record reader all four kinds would share.** Deferred by `add-number-record` (#138)
  at its grill's Q5 — "rather than fix the shape of two records nobody has grilled yet" — and
  `add-note-record` (#140)'s `design.md` named `add-total-record` (#141) as the change where that
  reason expires. **It has expired.** All four kinds exist: `History.isKept(_:on:)`,
  `number(for:on:)`, `note(for:on:)` and `total(for:on:)` are four members answering one question
  each, with `DayView.Row`'s four entry-shaped members above them. #141 did not fold them, and its
  grill (answer 3) and `design.md` § *Open Questions* give two reasons that outlive that Story:

  - **It is a no-behaviour refactor across two capabilities.** Folding four readers into one
    rewrites requirements that three merged Stories have already signed, in `record` and in
    `day-screen` both. Done inside a Story about totals it would have produced a G4 diff in which
    the new kind and the rewrite of the other three were indistinguishable.
  - **The four are not the same shape, and that is what the fourth kind taught.** Three answer *a
    value or nothing*; the sum answers *a value, always*, because a day with no additions sums to
    zero rather than to nothing (#141's grill answer 14, and answer 9 reads take-back-last off
    exactly that). One reader has to pick one of those two answers for all four, and either choice
    changes what one of the existing three means.

  So the deferral has stopped being "not yet" and become "not like this": it is a design question
  and its own change rather than a mechanical merge. Nothing forces it — every kind's record and
  every kind's row work as they stand — and the standing cost is a package with four members where
  a reader coming to it fresh expects one, plus a fifth kind, if there ever is one, arriving as a
  fifth member. Whoever takes it inherits the thirteenth and fourteenth faces in § *Known gaps*
  below as the surface it would move, and `add-total-record`'s rejection of a `Records` struct for
  the writer — recorded in § *Settled* — as the half of the shape that is already argued.
  Recorded 2026-09-08, at #141's G7.

- **`design.md`'s sub-budgets are invisible to `check:budgets`, which measures whole files only.**
  `openspec/config.yaml`'s `design` rules cap Context at 20 lines, Goals/Non-Goals at 12, Decisions at
  80 with each decision at 12, Risks at 20 and Open Questions at 12, inside a 150-line file total — but
  `scripts/check-artifact-budgets.ts` (ADR-1047) counts only the whole file, so a section running over
  its own cap passes silently as long as the file stays at or under 150. `condense-day-screen-spec`
  (#201) hit this at the section level, on purpose: two decision blocks ran 20 and 19 lines and
  § Open Questions ran 14, all against a 12-line cap and all invisible, while the file landed exactly
  at 150. `condense-commitment-spec` (#204) hit the same wall at the file level: naming all 31
  over-budget requirements and the rules kept deliberately untested together took `design.md` to 169
  lines against 150, disclosed in the file rather than trimmed, on the judgement that dropping an entry
  from either list is the worse failure. #204's close-out reads two Stories hitting this as evidence the
  150-line cap is wrong for a spec this size, not that the files are wrong to have it. Whether the fix
  is the cap, the sub-budgets, or a lint that reads them is undecided. Recorded 2026-09-11, at #199's
  close-out; surfaced at #201's G7 (2026-09-10) and #204's G7 (2026-09-11).

- **`grill-frontier.md` is a second conductor-written file in every editorial change folder, against
  `AGENTS.md` § *The conductor* — "it writes exactly one file, `grill.md`."** Each of the four
  condensing Stories has the conductor index the surveys' *Rationale needing a home* and *Rules at
  risk* entries into a `grill-frontier.md` beside `grill.md`, as the frontier the grill's rounds are
  asked from. It carries no analysis of its own and sits under no ADR-1047 budget, since only
  `grill.md` and the ordinary change-folder artifacts are named. It is not inert: `condense-commitment-spec`
  (#204) traced a misattributed rule to its own frontier index, which had then propagated uncorrected
  into `design.md` § Open Questions until a G7 finding caught it. Bless it as a second file the
  conductor may write for a grill this size, or fold its index into `grill.md` itself. Recorded
  2026-09-11, at #199's close-out; surfaced at #201's G7 (2026-09-10) and repeated at #208's close-out
  (2026-09-11).

- **The three places travel as a trio of parameters, and want to be one type.** `recordAt:`,
  `rosterAt:` and `oneOffsAt:` — the labels `RestoreInProgress.restore` and `undoTornRestore` give
  them, where `readPlaces` says `place:`/`recordPlace:`/`oneOffPlace:`, `readRecordAndRoster` says
  `oneOffAt:` and `readStoresForCopy` says `recordPlace:`/`rosterPlace:`/`oneOffPlace:` — now pass
  together through those five functions, differing in name and not in kind — a data clump,
  and the shape of a "three places" type nobody has written. `restore-from-a-copy` (#267) did not
  introduce it: `make-a-copy` (#266) already read all three together, and this Story widened the
  trio to the writing side, which is the first time the same three paths are both read and written
  in one operation. Left alone deliberately at #267's G7, where the reviewer raised it as a
  judgement call rather than a finding: a Story fixing three correctness defects is the wrong place
  to move five call sites, and the delta was signed without it. The candidate answers are a value
  type holding the three URLs, passed everywhere the trio goes; or leaving it, on the ground that
  the trio is stable at three and every call site names its members. What would force the first is
  a fourth store, which `copy-on-every-change` (#268) does not add but a later capability might.
  Recorded 2026-09-16, at #267's G7.

- **A copy can be formed two ways, and only one of them checks.** `CopyDocument.formCopy()`
  (`CopyDocument.swift:37-70`) forms the three stores through `formTicks()`, `formRoster()` and
  `formOneOffs()`, with no version bound and no shape-versus-form check; `CopyDocument.read(_:)`
  (`:113-119`) forms the same three through `RecordStore.formed`, `RosterStore.formed` and
  `OneOffStore.formed`, which guard the version bound, and — for the record and the roster — the
  shape against the form it declares; `OneOffStore.formed` guards the bound alone, there being no
  form-specific field to check. `formCopy()` has seven call sites, all in `CopyTests.swift`
  and none in `Sources/`, and it pre-dates `restore-from-a-copy` (#267) — `CopyDocument.swift` is
  +75/−0 on that branch. What #267 changed is that the two paths' checks now differ: its G7 fix round
  added the missing lower-bound guard to the three `formed` statics, so a later caller reaching for
  `formCopy()` gets back exactly the defect that fix closed — a copy holding a store at form 0
  forming rather than being refused as damaged. The candidate answers are to make `formCopy()` call
  the same three statics; to delete it and have the tests read through `read(_:)`; or to leave it,
  on the ground that it is test-only and the compiler will not let a `Sources/` caller appear without
  review noticing. Raised as a judgement call rather than a finding at #267's second G7 read, and
  left out of that Story deliberately: it is not #267's defect and the delta was signed without it.
  Recorded 2026-09-16, at #267's G7.

- **"Writes nothing" over-claims, in the requirement as much as in the design.** `restore-from-a-copy`
  (#267) says of a restore in progress that cannot be read or undone, at
  `openspec/specs/restore/spec.md` and in that Story's `design.md` alike, that it "writes nothing".
  The *cannot be read* half is exact: `RestoreInProgress.undoTornRestore` returns on the decode
  failure before any write. The *cannot be undone* half is not. That path puts back the record, then
  the roster, then the one-offs, then the save in progress, and returns false on the first throw — so
  a rollback that fails at the roster has already written the record place. Reachable with a valid
  restore in progress standing, the record place writable and the roster place's directory read-only;
  no test reaches it, both torn-restore tests exercising the decode branch instead. **The behaviour
  is right and is not what is in question**: the restore-in-progress file still stands, so the next
  open retries the whole rollback, which is what ADR-1056 means by a restore being said only once it
  is whole. What over-claims is the sentence, and it over-claims in a shipped requirement, which is
  why it was not fixed at #267's G7: correcting it there would have been a requirement edit and a
  third signature on a Story whose behaviour nobody disputed. The candidate answers are to reword the
  requirement in an editorial Story (ADR-1047), which is what this costs if it is ever worth paying;
  to add a scenario pinning what a half-finished rollback leaves, which would make the wording's
  falsity visible in a test rather than in prose; or to leave it, on the ground that a reader who
  reaches this case is reading `RestoreInProgress` anyway. Raised at #267's fifth G7 read and left
  deliberately. Recorded 2026-09-16.

## Known gaps

Things that are built, or deliberately not built, in a state someone will trip over.

- **The one-off store's "kept before the store reports it kept" test does not keep the first store
  open.** The scenario opens a second store at the same place *with the first still open*, but the
  test's first store is last used before the second opens, so an optimised build may release it
  first; nothing like `withExtendedLifetime` holds it. Harmless today because `OneOffStore` has no
  `deinit`, and a later version that wrote in `deinit` could pass the test while breaking the rule.
  Found at #326's G7, 2026-09-24, as the twin of a gap fixed in `BirthdayStoreTests`; outside that
  Story's diff, so owed by a chore or the next Story that touches the one-off store's tests.
- **A deletion's put-back is not checked.** When the roster refuses a deletion, the commitments
  screen puts the erased record back with `try?` and ignores a failure
  (`CommitmentsScreen.confirmDeleting`). If the put-back also fails, the commitment stays listed
  with its records gone and the person sees only that the change was not kept. That is the same
  end state `design.md` accepts for an app killed between the two writes, reached by a second
  failure instead. Found at G7 of `delete-a-commitment-for-good` (#304) and left on purpose; a
  save in progress for deletions would close both.
- **A swiped look-back graph clips its newest date label.** The dates axis on a number's or a
  total's graph (#274's code, `LookBackView.swift` dates-label placement) picks its day ticks from
  the opening scroll position rather than the current one, so the labels slide with the chart and,
  once it is swiped back, the newest runs past the card's right edge — "18 Se" for "18 September
  2026". Seen in #275's W.5 walk picture, the first simulator picture of a swiped graph; outside
  #275's diff, so not fixed there. Found at #275's third G7 pass, 2026-09-23; owed by a chore or
  the next Story that touches the graph.
- **A shipped requirement is unreachable after #303, and stays on purpose for a phone upgrading
  from an earlier form.** `openspec/specs/commitment/spec.md` § *A change that carries records
  leaves a save in progress until its roster place is written* is untouched by
  `give-a-commitment-an-identity`'s (#303) delta on purpose — `design.md`:86-88 says so, because a
  phone upgrading from this app's earlier forms may still hold a torn save one of the three
  save-in-progress requirements exists to undo. After this Story, no change or restart carries a
  record to the record place at all — `keepSaveInProgressIfCarrying` is gone from source — so its
  three scenarios each have a test again and pass vacuously: nothing is ever refused, and no save
  in progress is ever kept. Found at #303's G7 fix round, 2026-09-22; two of the three scenarios'
  tests, deleted by `5e3ee61`, were restored at #303's second G7 fix round the same day. That
  commit also deleted six non-scenario-named torn-save tests — five in `CommitmentsScreenTests`,
  one in `TakeOutTests` — that went with the helpers they drove. The next Story that deltas
  `commitment` carries this requirement as REMOVED.
- **`RosterDocument.folded()`'s tie-break for "the nearest such commitment" picks the farthest
  chain, not the nearest.** `RosterDocument.swift:252` reads
  `attachable.max(by: { $0.frontIndex < $1.frontIndex })` for what its own doc comment calls "the
  nearest such commitment, by that front's own place" (`design.md` says "nearest in the roster's
  order"). The two agree for every roster the old `supersede` ever wrote, where at most one
  un-attached chain is ever attachable to a given removed entry at once — but not for a
  hand-formed document holding two live entries of one name whose chains front at index 3 and
  index 9 around a removed entry at index 5: the nearer of the two by roster position is the one
  fronting at 3, and `max(by:)` picks the one fronting at 9 instead. Found at #303's G7 fix round,
  2026-09-22.
- **A `day-screen` scenario says a rename is "changed at both places" after #303 makes a rename write
  the roster place only.** *a commitment renamed at a day screen's places is drawn under its new name
  and still kept when the screen is returned to* (`openspec/specs/day-screen/spec.md`) keeps that
  WHEN in a requirement `give-a-commitment-an-identity` (#303) does not modify — its THENs still hold,
  its test is edited under that Story's `tasks.md` § 1.3, and `design.md` says `day-screen` needs no
  requirement change, which is true of the rules and not of this sentence. Found by `spec-author` on
  2026-09-22 while naming carried tests; booked here rather than reopening the G4-signed delta for
  one clause of stale prose. The next Story that deltas `day-screen` carries the requirement as
  MODIFIED and drops "at both places".
- **A take-out's write failure is refused as a place that could not be written, and no test can reach it.**
  `CommitmentsScreen.takeOut` (#270) creates a directory named by a fresh UUID and writes each file
  into it in the same call; a failing `createDirectory` is refused the same way and is tested, but a
  write that fails after the directory exists cannot be staged from the seam — the test cannot know
  the name, the process owns the directory, and there is no hook between creation and the first
  write. Reviewed at #270's G7, 2026-09-21: the branch is right by reading and unprovable by test.
- **A walk box's prose can be rewritten after G4 and nothing catches it.** At #270's walk,
  2026-09-21, two boxes in `tasks.md` § 11 described pictures the shell could not produce — a
  refused-copy line assumed red that had shipped black, and a share sheet assumed to list file names
  where iOS summarises two items as "2 Documents". The conductor reworded both on the owner's `go`
  at a rule-5 stop and committed (`7d5afd2`); `pnpm run check:g4` still passed because
  `scripts/lib/g4.ts` excludes `tasks.md` whole from the digest, and the agent table allows the
  implementer only that file's checkboxes, not its prose. The reviewer flagged it at G7 as a
  rewrite that went through no gate. The substance was right — the walk asserts nothing about what
  is shown, the seam tests do — but an acceptance line can be rewritten to describe the picture
  taken, and only a reviewer reading the commit log sees it. Whether `tasks.md` § 11 belongs in the
  digest, or a stop at the walk should be a second G4, is open.
- **A number graph's year and "All" spans say one month label, and a wide label can overlap the
  one kept before it.** Found at #274's G7, 2026-09-21, and reshaped by its fifth fix round.
  `LookBackView`'s dates-axis candidates are every month in the whole domain; where two would
  touch, the newer replaces the older, so under "Year" on a long history — months about 27pt
  apart against a ~90pt label — the chain collapses to one label, the newest month at its own
  position. That replaced the earlier symptom, an oldest-first subset whose leftmost label could
  name a month not at its position. Two residuals: a replacement is compared only against the
  entry it replaces, never the one before, so September replacing May can overlap March; and a
  tick whose label was dropped still draws its gridline, so a month-span page can carry an
  unlabelled dashed line. A third, seen by the owner on the phone after G7: the day ticks are
  sampled at the sixths of the window and kept only where they land inside the history, so a
  two-week history under the month span says one date five days back, and under the three-month
  span says today by the newest-day fallback — positions, not the days that hold numbers, and
  never the era rule's day. The owner left all three at G7 as a later shell tidy, not a Story: the
  seam says every day, every month and every point with its position, and nothing in the delta is
  contradicted.
- **A values-axis bound wider than 30% of the graph card is drawn truncated.** Found at the same
  G7. The lane beside the chart is clamped to 30% of the card so a long bound cannot squeeze the
  plot to a sliver, and a label that does not fit truncates with an ellipsis, so the axis can read
  "1234567…" for a bound the graph holds. It crosses no requirement — what a look-back *says* is
  the kit's `lowestInWords` and `highestInWords`, untouched — and the case is a thirty-eight-digit
  whole that the delta names as reachable rather than one anybody has typed. Left at G7 as a later
  shell decision: a smaller font for a long bound, or a lane that may grow to half the card.
- **The app died once during #274's walk with "Fatal error: Range requires lowerBound <=
  upperBound", and the explanation on record is wrong.** Seen 2026-09-21 by the implementer
  driving the simulator: a Mon, Wed, Sat number commitment, a number entered on its kept-from
  day, then a second entry a day later on a re-run. The implementer attributed it to its own
  test's navigation order and reordered the test; a UI test drives taps and cannot make correct
  app code trap, so that is not a mechanism. The reviewer audited every variable-bound range in
  both targets — `chartYScale`'s `lowest...highest` and `chartXScale`'s domain in
  `LookBackView`, the restart bounds in `CommitmentsView` (already guarded, after an earlier
  trap), the day picker's one-sided range, and the two slices in `LookBack` — and none can
  invert on the paths a number entry or the look-back page touches. What survives: a trap inside
  SwiftUI or Charts on inputs shown to be ordered, or a trap in the throwaway test process
  itself (`1..<count` on an empty query is the usual one), which reads almost identically in
  the log and is the only way "my test caused it" is literally true. Unverifiable now: the walk
  test is deleted by ADR-1053 and no log was kept. Not this Story's — nothing in its delta or
  diff is implicated — but a real crash of a real build. If it recurs, keep the log before the
  test is thrown away; a walk that dies should do that as a rule.
- **`CalendarDate.adding(days:)`'s comment names two callers and has eleven.** Found at #273's
  fix-round verification, 2026-09-16. `CalendarDate.swift` documents the method's nil-on-out-of-range
  behaviour as holding "at the ±1 steps this method is actually called with
  (`DayView.previousDay`/`nextDay`), the only callers today". The claim that matters is true —
  every caller in the kit steps by one — but the list is not: `History.standing`, `LookBack.chain`,
  `LookBack.walkDays`, `LookBack.monday(of:)` and `sunday(of:)`, four sites in `DayScreen.swift` and
  one in `CommitmentsScreen.swift` all call it. #273 amended the sentence and then withdrew the
  edit, because it put a file outside the Story's `tasks.md` boundary into the diff for one comment;
  the sentence predates the Story. Strike "the only callers today" or say "every caller in the
  kit" the next time that file is open for a reason of its own.
- **`LookBack.walkDays` does five jobs.** Found at #273's G7, 2026-09-16. It grew from about
  forty-five lines to about a hundred and thirty-five when the quota's weeks landed: the day walk,
  the nil-line filter, two key-to-last-day dictionaries written in the same shape twice, the
  rhythm-change placement moved down out of `form`, the sort by last counted day, and the totals,
  returned as `(lines:totalDue:totalKept:)`, which the name does not say. The reviewer traced the
  logic through the three-era chain and both mixed-boundary directions and mutation-tested the
  sort, the placement and the newer-quota rule; it is right, and the split it wants — a tally pass
  and a `lines(from:)` pass, since the placement needs each line's last day — is a refactor left
  out of the Story's fix round rather than done at its end. Owed by the next Story that changes
  how a look-back counts, which is #274 or #275 if either reaches this function. *Amended
  2026-09-22 at #300's G7: #274 archived without reaching it, and #300 deleted the placement and
  the two dictionaries, so the function is about ninety lines and does three of the five jobs —
  the walk, the sort and the totals. #300's fix round takes out the sort's leftover tuple and
  `SortableLine` wrappers; what is still owed is the tally-pass split, by #275 if it reaches the
  function.* *Amended 2026-09-23 at #275's G4: a total's page says no line, so #275 does not reach
  `walkDays` and its `design.md` says so; the split is owed by the next Story that changes how a
  tick or a quota is counted.*
- **A quota's look-back scrolls its whole out of sight.** Flagged by the designer at #273's
  layout round, 2026-09-16. A weekly quota's page says one line per week, about fifty-two a year,
  where a tick's twelve month lines kept the whole card in view; nothing on the page is pinned, so
  on a quota kept for a year the one summary figure the page has is a screen above the rows. No
  layout in the mockup fixes it: a pinned card duplicates a figure and a collapsed run hides part
  of the record, both of which ADR-1045 and `CONTEXT.md` § *Look-back* argue against. A later
  layout question, once the page exists and has been read on a phone; `design.md` § *Risks* of
  `look-back-at-a-quota` books it too.
- **`canChangeMoreThanNameAndCategory` answers for four things, and the kind is a fifth it does
  not cover.** Left at #262's G7, 2026-09-16. The flag `change-range-and-target` renamed is `true`
  on a kept commitment, yet the kind still cannot be changed — the sheet freezes that picker on
  `changing != nil`, never on this flag — and the delta's rewrite of *A commitments screen says what
  a commitment it is asked to change is made of* dropped the shipped sentence "nothing SHALL be
  said about whether it can be changed", which was the rule that kept the broad reading out. A
  narrower name, or that sentence restored, is an edit to a signed change folder — a second G4 —
  so it was left as approved, for the next Story that touches what a commitment is made of.
- **One SHALL in `commitment` has no scenario: a range or a target named for a kind with no room
  for it is ignored.** Left at #262's G7, 2026-09-16. The implementation honours it — the change
  path returns the commitment's own kind for a tick and a note before reading either string — but
  nothing in the suite goes red if a later refactor moves the reading above the kind switch and a
  tick change starts refusing. A scenario under *A commitments screen works out which act a change
  on either of its lists needs* closes it, and adding one to a signed folder is a second G4, so it
  waits for the next `commitment` Story or an editorial one (ADR-1047).
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
  since #72. **Six faces remain, and none of them is closed by that requirement:**
  `CalendarDate` is still not `Comparable`, and `DayOfMonth`, `DayInterval`,
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
  **The ninth face's prediction has been answered and the gap is unchanged.** `add-rhythm-in-words` (#144) is the Story that entry has been naming since #9 as the one that would have to widen a schedule's payload — "the widening is still owed by whichever Story first renders a rule, and B-021 is that want" — and it renders every rule in the product without reading a single payload out. The package says the words (ADR-1034), so `Commitment.schedule`, `DayOfMonth.day`, `DayInterval.days` and `WeeklyQuota.timesPerWeek` are all still internal and all nine faces are still open. What changed is that nothing is now waiting on them: the next thing to need a payload will be something that must *compute* with one outside the package, not something that must *show* one. Recorded 2026-09-07.
  **A tenth face, and it is odd in the same way the ninth is: `add-number-record` (#138) gives a
  `History` a way to let a number out.** `History.number(for:on:)` returns the `Decimal?` recorded
  for a commitment on a date, while a tick still comes out of that same type as nothing but a yes or
  no from `History.isKept(_:on:)`, and `Tick` still gives back neither its commitment nor its date —
  nor does `Number` give back any of its three. So one value type now answers one of its two
  questions with a value and the other with a boolean. Like the ninth, this is a *deliberate*
  widening authorised by a requirement in the delta rather than an oversight: that Story's grill
  settled at Q1 that a record nothing can read back is not a record, and that #139's row has nowhere
  else to get the number it must draw. The widening is number-shaped rather than general — the same
  grill's Q5 — so #140's note and #141's total will each face this question again, and the shape the
  three would share is deliberately not being designed until all three exist. Recorded 2026-09-07,
  at #138's G7. #138 has not merged — PR #151 is still a draft — so `main` does not have this yet
  and the tenth face is a forward reference until it lands.
  **The tenth face has landed and an eleventh sits on top of it, of the same shape.** #138 merged, so
  `History.number(for:on:)` is on `main` and the tenth face is no longer a forward reference.
  `add-number-entry` (#139) then widens `DayView.Row` the same way: a row gives its number **out**,
  through the `NumberEntry` its `numberEntry(asOf:)` offers, while still giving no tick out —
  `tick(asOf:)` hands back a `Tick` that answers nothing about itself. So the same row now answers
  one of its two questions with a value and the other with a yes or no, exactly as a `History` does
  one level down. Like the ninth and tenth this is authorised by a requirement rather than an
  oversight: the entry has to carry the number so the field opens holding what the day already
  holds, which is that Story's grill answer 8, and the row still never *draws* it, which is answer 3.
  The widening stays number-shaped — #140's note and #141's total will each face it again — and
  `Commitment.schedule`, `Commitment.keptFrom` and the four schedule payloads are all still internal.
  Recorded 2026-09-08, at #139's G7.
- **A row now gives a note out, while still giving no tick out** — the twelfth face of the
  public-surface gap. `add-number-entry` (#139) gave a `DayView.Row` a way to give a number
  out through the `NumberEntry` its `numberEntry(asOf:)` offers, while `tick(asOf:)` still
  hands back a `Tick` that answers nothing about itself. `add-note-record` (#140) does the same
  for notes: a row gives a note out through the `NoteEntry` its `noteEntry(asOf:)` offers,
  while a note-kind commitment still cannot form a tick at all, so the row offers nothing for that
  entry. Like #139's widening, this is authorised by a requirement rather than an oversight: the
  entry has to carry the note so the field opens holding what the day already holds, and the row
  still never *draws* it, which is answer 7 of this Story's grill.
  `History.note(for:on:)` lets a note out at the record level and answers a third question with
  a value, exactly as `History.number(for:on:)` does — so a history now answers three questions
  three ways: ticks as a boolean from `isKept(_:on:)`, numbers as a value from
  `number(for:on:)`, and notes as a value from `note(for:on:)`, while a tick still gives back
  neither its commitment nor its date, and a number and note still give back none of their three.
  The widening stays note-shaped — #141's total will face it again — and `Commitment.schedule`,
  `Commitment.keptFrom` and the four schedule payloads are all still internal.
  **Half of *A commitment of a kind nothing can yet record is a row that does nothing when
  tapped* is spent by this Story:** a row for a note commitment now offers a note entry,
  ending the case where a person defines a note and sees a dead row. A row for a total
  commitment still offers nothing, and nothing in the shipped app can reach that state — the
  commitments screen defines only the plain kind until #142 lands. The fix is unchanged and
  still an edge on the tracker from #141 to #142.
  Recorded 2026-09-08, at #140's close-out.
  **The thirteenth and fourteenth faces, and the thirteenth widens less than either of the two
  before it.** `add-total-record` (#141) gives a row two new things. The first is the same widening one
  kind further along: a row gives its day's sum out through the `TotalEntry` its
  `totalEntry(asOf:)` offers (`DayView.swift:131`) — but as **words** rather than as a number,
  `TotalEntry.soFarOfTarget` being the single string `"150 of 120"` (`DayView.swift:24`), because
  `CONTEXT.md` § *App shell* forbids the shell composing that sentence and ADR-1022 and ADR-1036
  had each already decided it once. So the sum leaves the package readable and not computable,
  which is narrower than the number's and the note's: those hand out the value itself.
  The fourteenth is a new shape rather than a fourth of the same. `offersTakeBackLast(asOf:)`
  (`DayView.swift:164`) is the first thing a row gives out that depends on what the **history**
  says rather than on the commitment and the date alone — `true` exactly where the row offers a
  total entry and its day's sum is above zero, which is ADR-1041's decision that a take-back is
  its own act and comes and goes with what there is to take back. Every other affordance a row
  publishes is there, or not there, by the kind alone.
  One level down, `History.total(for:on:)` (`History.swift:74`) lets a sum out, so a history now
  answers **four questions four ways**: ticks as a boolean from `isKept(_:on:)`, numbers and notes
  as a value **or nothing** from `number(for:on:)` and `note(for:on:)`, and additions as a value
  **always** — zero for every commitment on every date, whatever its kind (#141's grill answers 14
  and 16). What still does not come out is unchanged and grew by one: a tick gives back neither its
  commitment nor its date, a number, a note and an addition give back none of their three, the
  day's additions themselves never leave the package at all (answer 6 — a history gives out the sum
  and not the list), and `Commitment.schedule`, `Commitment.keptFrom` and the four schedule payloads
  are all still internal. The four readers this leaves are the subject of a new entry under
  § *Open technical decisions* above; the widening itself is authorised by requirements rather than
  an oversight, exactly as the ninth through twelfth were. Recorded 2026-09-08, at #141's G7.
  **#141 has not merged** — this chore lands ahead of that Story's archive, on its own `tasks.md`
  § 17.5 — so `main` does not carry any of this yet and both faces are a forward reference until it
  does.
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
  `row == screen.notice?.row` — value equality — so two rows alike in name and kept-state would
  both draw the same notice, against *A day screen tells on the row that was tapped*. The property
  was `refusedChangeRow` until `add-number-entry` (#139) renamed it and gave the notice a cause;
  this line was updated with it on 2026-09-08, and the face is unchanged. The dated `## Settled`
  entry below still says `refusedChangeRow`, correctly — it is a record of 2026-09-06, not a claim
  about `main`.

  **There is no shell-only fix, so this is a Story rather than a chore.** The shell can see only
  `name` and `isKept`; a stable identity that is neither the value nor the position has to come from
  a public widening of `DayView.Row`, which is a delta against `openspec/specs/day-screen/spec.md`
  and a G4. It is the same widening the eighth face above describes, which is an argument for one
  Story covering both. Unowned: the tracker holds no open issue at all.

  **A second screen hit a related shape, fixed 2026-09-22 by `give-a-commitment-an-identity`
  (#303) at `tasks.md` § 14.4, but not by a stable row identity** — keying the commitments
  screen's row `ForEach`s and `SheetTarget.id` on more than `Commitment` itself was tried and
  found insufficient, since `CommitmentsView.body` was confirmed, at the pixel level, not to
  re-run at all off a rename or a rhythm change kept through `CommitmentSheet` however a row was
  keyed, while `screen.kept`/`keptGroups`/`stopped` already held the new value the instant the
  sheet closed; the fix kept is a `listRevision` `@State` bumped in `.sheet(item:onDismiss:)`'s
  `onDismiss` and read via `.id(listRevision)` on the `List`, forcing it to rebuild fresh
  against those three properties whenever a sheet dismisses, and why Observation's own
  invalidation does not reach this view across that presentation boundary on its own is not
  understood, only worked around. The catch for this redraw is the walk's picture 3
  (`tasks.md` § 16.3), not a committed test: ADR-1053 decision 3 keeps
  `src/DayByDay/DayByDayUITests/` merging unchanged, and ADR-1029 restricts that bundle to
  asserting only that the shell drew, never what it drew. `.id(listRevision)`'s cost is that the
  whole `List` is rebuilt on every sheet dismissal, so a scroll offset, edit mode and an
  in-flight swipe are all lost with it, and a long list jumps back to the top after editing a row
  near the bottom. The day screen's own gap above is untouched.
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
  for § 4.3 should use that instead of rebuilding anything — and since 2026-09-15 the per-Story
  form of § 4.3 is the **walk**, `pnpm run walk`, ADR-1053. Nothing is owed; the entry stands so the
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

- **One decimal is split into a whole part and a fraction in two places.** Raised at
  `add-total-record` (#141)'s second G7 pass, 2026-09-08, as finding 3, and **declined by the repo
  owner as a judgement call rather than a defect** — recorded here rather than fixed on that
  branch. `Digits.swift:18-20` and `DayScreen.swift:298-301` run the same step: split on `"."`
  with `omittingEmptySubsequences: false`, take `parts[0]` as the whole part and
  `parts.count > 1 ? parts[1] : Substring()` as the fraction, then hand both to the same
  `Digits.stripped(whole:fraction:)` — which is where #141's first G7 pass put the counting, so
  that the two could not drift on what a significant digit is. The two are not one input copied: `Digits.significant(in:)` splits a `Decimal`'s
  own description, after stripping a leading `-`; `DayScreen.writtenOut(_:)` splits text a person
  typed, after normalising `","` to `"."`. `Digits.swift:28-30`'s doc comment defends exactly that
  — "Read off `whole` and `fraction` exactly as each caller split them … so the two callers can
  never drift apart on what counts as a significant digit" — and the defence is true of the
  counting, which is shared, rather than of the getting there, which is not.

  **The residual risk is that the two splitters recognise different things and nothing says so.**
  `DayScreen` accepts `","` as a separator and `Digits.significant(in:)` does not, and that is
  correct today for a measured reason: a `Decimal`'s own description never uses a comma and never
  uses exponent notation — checked on this toolchain 2026-09-08, where `Decimal(string: "1e40")`
  prints as forty-one digits and `Decimal.greatestFiniteMagnitude` as a hundred and sixty-six. But
  if a third separator, or an exponent form, is ever taught to one splitter and not the other, then
  `read(_:)`'s refusal of typed text (`DayScreen.swift:240`) and `canAdd`'s refusal of a sum
  (`Digits.swift:60`) stop being the same rule, and the same value becomes a number when typed and
  not a number when summed — which is the one thing ADR-1040 says must not happen, its own words
  being that the two "must agree or the same value is a number when typed and not a number when
  summed". Nothing would go red: the only test reading both paths against one value is the single
  free-form unit test at `DayScreenTests.swift:3291`, *Digits.significant(in:) and a typed value's
  own significant-digit count agree on 10^38*, and it pins one value at one magnitude.

  **What would close it:** `Digits` owning the split as well as the counting — one member,
  `Digits.stripped(_:)`, taking text that its caller has already normalised and already stripped the
  sign from, and doing the split itself. Each caller keeps the part that is genuinely its own — a
  `Decimal`'s description and its `-` on one side, a comma and a person's typing on the other — and
  neither keeps a splitter. It is below the seam and changes no behaviour, so it needs no delta and
  no G4: a chore, or whatever next touches `Digits`. `Digits.swift` arrives with #141 and is not on
  `main` yet.

- **ADR-1031's stated reversal trigger, a fifth form or a form that differs by more than a field,
  appears to have fired with no amendment recording it.** `RecordDocument.currentVersion` is `5`
  (`RecordDocument.swift:15`), reached by `add-total-record` (#171, merged 2026-09-09), after the
  2026-09-08 amendment restated the trigger at a fourth form. The ADR carries three amendments, the
  latest 2026-09-10 for `condense-record-spec` (#205) deleting the requirement prose that argued one
  of its rules; none addresses a fifth form arriving. The decision reads as unaffected on inspection
  — five forms each differing from its predecessors by one field still read under the single
  `1...currentVersion` comparison the decision describes — so this looks like a missing stamp rather
  than a wrong decision, per ADR-1020's rule to amend a record in place when a trigger it named itself
  fires. Surfaced at #205's G4, 2026-09-10, and left alone there as outside that Story's scope.

- **Four groups of `schedule` rules cannot be proven by a test, and stay in the spec anyway.**
  `cover-schedule-rules` (#221) gave every other uncovered rule a scenario and left these four
  groups alone, per ADR-1047 decision 7.6:
  - time, time zone, locale and week start: the exclusion clause in each of the five due
    requirements, and rhythm in words "not taken from the device's language, region, locale" — no
    seam accepts them;
  - compiler-enforced: the five "no schedule SHALL be built on / asked about" an out-of-range
    value, "MUST NOT form a date with a component missing", a calendar date's numbers "not
    writable" and "only by forming a new one", and words "the same whatever day asked on / about"
    and "in every month";
  - meaning or consumer: quota "due MUST NOT mean still outstanding", "week complete MUST be
    decided from tick records", "seven SHALL mean one completion each day", words "whether or not
    any commitment carries it";
  - an interval at `Int.max` not lost to overflow: shown only at 4,000,000.

  Recorded 2026-09-13, at #221's grill.

- **Five groups of `record` rules cannot be proven by a test, and stay in the spec anyway.**
  `cover-record-rules` (#222) gave every other uncovered rule a scenario and left these alone, per
  ADR-1047 decision 7.6:
  - absences, the category `CONTEXT.md` § *Covering Story* names: a history giving out a day's sum
    and never the additions themselves; no taking back an addition by its amount, and no clearing a
    day's additions in one act;
  - compiler-enforced: a tick, a number, a note and an addition each being its parts "and nothing
    else" — no unit, time of day, time zone, note beside it, count, order or position;
  - no seam accepts them: a tick "MUST NOT consult the present moment, the time zone or the
    locale", a store "MUST NOT … pass a date through an instant, a time zone or a locale", and a
    carry-over "SHALL judge no date except by asking the second commitment whether it is due";
  - binds a consumer: "a screen withholding days not yet arrived SHALL do so itself", and what a
    day's additions may sum to "SHALL be judged in the `day-screen` capability";
  - the comparison "the sum against the target, in that order and never the target against the
    sum": for any sum that is a number the two orders answer alike, and under NaN, the one case
    where they could part, both answer not kept (the open product question above).

  Recorded 2026-09-13, at #222's grill.

- **Seven groups of `day-screen` rules cannot be proven by a test, and stay in the spec anyway.**
  `cover-day-screen-rules` (#223) gave every other uncovered rule a scenario and left these alone,
  per ADR-1047 decision 7.6. Line numbers are `openspec/specs/day-screen/spec.md` as of `6078297`:
  - bind a meaning or a caller: the way back to today "about the control and not the position" and
    not standing in for whether the screen shows its today (4032–4034); a caller "MUST NOT stand a
    move down", and a screen "SHALL NOT say whether it can move" (350–352); the absence at an end
    "SHALL NOT be read as an answer about moving" (1915–1916); and 443–446, 727, 730–731, 1387–1388,
    1390–1391, 1720–1721, 4126–4127;
  - compiler-enforced: a total entry "SHALL say no hint" and nothing to prefill from (1340–1341);
    nothing answered about whether the day picker is offered, and the reach never giving out the
    today "under any name" (2239–2240); showing a picked day "handed one thing" (1797–1798) and a
    move "handed nothing" (202); the signatures that take no day (22, 296, 2268, 2797–2798, 3589,
    3762, 4034); the internal fields a row does not say (917–918, 1341, 3722, 3725); and 348, 1538,
    1717–1718, 2101–2109, 2580–2581;
  - no seam accepts them: closing a number or note entry uncommitted ends nothing (3192–3193), the
    screen is never called; a non-total row's sum of zero (2011–2012), `Row.total` being internal;
    words in "this package's own English and no locale's" (1339, 3046, 4125); and 474–475 "anywhere
    else", 547–548 "when a tick is made", 642, 1540, 2010–2011, 2462–2464, 2804, 3184, 3597,
    3898–3899;
  - time zone, clock and locale clauses: 21, 397–398, 834, 915, 973, 1108, 2461;
  - meaning, with the same answer either way: a total row's take-back not widening *offers
    anything* (1717), since it is offered only where a total entry is; and 916, 975–976, 1181–1182,
    1336, 2157, 2884, 3723;
  - universal over every input, where each scenario pins only its own: 1454, 3041;
  - unreachable at the seam: two rows that are the same row both told of (3049), since a roster
    refuses a duplicate on every path, file replay and day one included.

  Recorded 2026-09-14, from #223's grill and `design.md`.

- **Four groups of `commitment` rules cannot be proven by a test, and stay in the spec anyway.**
  `cover-commitment-rules` (#224) gave every other uncovered rule a scenario and left these four
  groups alone, per ADR-1047 decision 7:
  - no seam accepts them: the present moment, time zone, locale and clock in every requirement; a
    category kept as a reference to a list; a roster store "SHALL NOT be what reaches" a record
    place (*the record place SHALL be written before the roster place* is not here — *a change a
    commitments screen could not carry over at the record place leaves the roster place as it was*
    proves it instead);
  - compiler-enforced: a commitment's four parts and nothing else, its kind fixed, no unit on a
    target, both range ends required; a roster's lack of identifier, position and added day; a
    move's two things, no third ask and no second way back; the screen's five fields, a change's
    four and no kind; no interval start date; range and target text taken unjudged; no date to
    pick; no words a person reads; take-up asking nothing;
  - meaning or consumer: inclusive range ends; one refusal where a range is formed; delegation to
    shapes added later; ticks and records standing, nothing carried by a roster; no link to a
    replacement; nothing stored for a group; no second category collection; `schedule` and the
    value rules unchanged; the seven refusals numbered nowhere else;
  - only a UI test proves them: the change form's controls, a row saying only name and rhythm, and
    the app calling `shown(asOf:)`.

  Recorded 2026-09-14, at #224's design.

- **`check:scenarios` matches scenario titles in one flat set across every capability**, so a
  scenario whose title collides with a shipped one elsewhere is reported covered by the other
  capability's test. `scripts/lib/coverage.ts` unions every Swift and TypeScript test title into a
  single `Set<string>` and asks only whether the delta's title is in it, with nothing tying a title to
  the capability it belongs to — so a change can pass the coverage gate with no test of its own, and
  a later rename of the other capability's test breaks a gate the two Stories never shared.
  `add-one-off` (#242) shipped such a collision — *a change that cannot be kept is refused and not
  held*, byte-identical to a scenario in `openspec/specs/commitment/spec.md` — caught by a reviewer
  reading the titles rather than by the check; the delta's scenario was renamed, which fixes that one
  Story and not the hole. The fix is the script's: scope the match by capability, or by the file the
  test lives in. Unowned. Surfaced at #242's review, 2026-09-14.

- **A commitments screen writes the record place from the copy it read, not from the file as it
  stands.** A change or restart that carries records goes through `RecordStore.carryOver`, which
  builds the whole document from that store's own ticks, numbers, notes and additions and replaces
  the file atomically (`RecordStore.swift:243-312`). A commitments screen reads that copy only when
  it is made, when the app is shown, and after undoing a torn save (`CommitmentsScreen.swift:34-37`,
  `:1140-1143`, `:492`). So a record a day screen keeps at the same place after that read, through its
  own `RecordStore`, would be dropped by the next carrying change, and one taken back in between
  would come back. Nothing reaches it today: the shell builds a fresh `CommitmentsScreen` on every
  push and drops it on the way back (`ContentView.swift:132`, `:241`), the screen is pushed rather
  than presented as a sheet (`:124`), so the day screen cannot be used while it shows, and the app
  has one window. It becomes live the moment a shell keeps a commitments screen alive across a visit
  to the day screen, or draws both at once. The guard is to read the record place afresh immediately
  before a two-place write. `save-change-whole` (#249) declined it because the app it shipped in
  cannot produce the case; it is owed by whichever change first keeps that screen alive. Surfaced
  2026-09-14 at #249's grill, answer 15.
- **`docs/agents/issue-tracker.md` documents sub-issues and not native issue dependencies.** Four
  G2 comments on #26 and #27 use GitHub's `dependencies/blocked_by` and `dependencies/blocking`
  endpoints for the blocking edge between Stories, and the orchestrator confirms their shape
  against a live edge each time because the file names only the sub-issue calls. Adding the four
  endpoints is a chore on that file. Surfaced 2026-09-15 at the ninth pass's G2.
- **Four copy-place test helpers live twice, once per test file.** `DayScreenTests.swift` carries
  `freshCopyPlaceDirectoryForDayScreenTests` and three siblings copy-pasted from `CopyPlaceTests.swift`
  (`freshCopyPlaceDirectory`, its two neighbours and `makeCopyPlaceDirectoryUnwritable`) with a suffix to
  dodge the file-private clash, because the package has no shared test-support file and every test file
  is file-private by default. The candidate answers are a `TestSupport/` target or one internal helper
  file in the test target, carrying them once; or leaving it, on the ground that four helpers is not yet
  a pattern. Left out of `copy-on-every-change` (#268) deliberately at its G7: the fix round there took
  the six behavioural findings and this one changes no behaviour. Surfaced 2026-09-17 at #268's review,
  finding 7.
- **Deleting the copy place in Files does not stop the copy; it follows the folder into Recently
  Deleted.** Walked on the phone at #268's G7, 2026-09-17, line 15.7: after the picked folder was
  deleted in Files and a commitment ticked, the commitments screen still said the last copy was made
  there, and the folder in Recently Deleted held the fresh copy. The same held for a folder in iCloud
  Drive and one On My iPhone. iOS moves a deleted folder to Recently Deleted rather than removing it,
  and a bookmark resolves across a move by Apple's own documentation, so *the folder cannot be
  reached* is not reachable by deleting in Files; it needs the folder gone for good (emptied from
  Recently Deleted, or its access taken away in Settings › Privacy › Files and Folders), neither of
  which the walk tried. The copy is safe throughout, which is why the owner closed the Story as it
  stands. Left open: whether a folder in Recently Deleted should count as unreachable, which would
  mean the app telling a trashed folder from a live one (`URLResourceKey` gives no such flag; the
  path contains `.Trash` on iCloud Drive) — a want if anyone wants it, not a defect. Forgetting the
  place and picking again worked as walked.
- **Carried tests were edited outside `give-a-commitment-an-identity`'s (#303) `tasks.md` § 1.3,
  in more than one class of edit.** Fourteen are a store form moving: § 1.4 raises
  `RosterDocument.currentVersion` from 4 to 5 and `RecordDocument.currentVersion` from 5 to 6; the
  fixtures for *"a form one later than the one this app knows"* hand-write that number plus one,
  so raising the constant forces the literal to move with it in every fixture that names one — ten
  in `DayScreenTests.swift` (`:339`, `:423`, `:601`, `:990`, `:1176`, `:3367`, `:3540`, `:3562`,
  `:4233`, `:6939`), one in `CommitmentsScreenTests.swift` (`:1962`), one in
  `RecordStoreTests.swift` (`:256`) and two in `RosterStoreTests.swift` (`:319`, `:2263`). Three
  more swap out a fixture's own second identity for the one already in hand — *a stopped
  commitment renamed through a commitments screen stays stopped, on the day it was kept until*
  (`CommitmentsScreenTests.swift:5845`), *what a commitments screen holds about a refused change
  ends when a change kept at both places is kept* (`:6723`) and *an interval commitment restarted
  from the day it is kept from is kept on no date before the restart* (`:7765`) each dropped a
  second commitment formed alike to the one already asked about, reading the original's identity
  back where the dropped one used to stand. One restores an assertion a rewrite of it dropped: *an
  interval commitment restarted from today is kept until yesterday and runs on from today under
  its name, interval and category* (`:7688`) lost, then regained (`b296f9a`), the assertion that
  the restarted era's interval starts on the restart day. And two are this Story's own G7
  fix-round repairs rather than the original implementation pass's — *a take-up-again a
  commitments screen could not keep leaves both its lists as they were* (`:7151`) and *a change
  refused at the roster place after carrying its records leaves no save in progress and a roster
  still kept* (`:8091`) — which is a repair's business and not § 1.3's. Every edit named above is
  correct and forced by the fact that drives it, and none is named in § 1.3 — § 1.2's own stop, "a
  carried test that has to be edited and is not named in § 1.3 is the design being wrong: stop and
  report it," was not taken for any of them. Found across #303's G7 fix rounds, 2026-09-22. The
  next Story whose delta moves a store's form names that class of edit in its own § 1.3.

- **`check:scenarios` can miss a test that is there.** `blankSwiftComments` in
  `scripts/lib/swift-tests.ts` builds its output from `[...source]`, indexed by code point, but
  scans `source` by UTF-16 code unit. Every non-BMP character earlier in a `.swift` file — the
  `"Gym 🏋️"` already in `CommitmentsScreenTests.swift` is one — shifts each later blanked comment by
  one unit, which can blank part of an unrelated `@Test("…")` title further down and report its
  scenario missing. In CI that is a false failure of the merge check rather than a false pass. Found
  by the implementer of `collapse-a-same-day-rhythm-change` (#305), 2026-09-23, and worked around
  there by where a comment was placed; the tool is unchanged and wants a chore.

## Settled

- 2026-09-22 — **ADR-1055 says "the same name and the same kind" where the shipped chain rule said
  "a kind of the same sort".** Closed at `give-a-commitment-an-identity` (#303), the next Story to
  open ADR-1055, as the entry asked. Resemblance chaining goes with it: a look-back now reads a
  commitment's eras off the roster by **identity**, not by walking removed entries that resemble
  the one in front, so the name-and-kind question the entry raised no longer has anything to
  answer — ADR-1055 is amended in place with a dated line rather than a rewritten Decision.

- 2026-09-21 — **a copy that cannot be made over a store from a later version says so.** Closed at
  #270's grill, which #266's review had left it to: a refused copy tells a later-form store apart —
  *from a newer version*, as the roster line and the restore refusal already do — rather than
  saying *could not be read* four rows under *must not be deleted*; and the residual round after
  the grill extended it to the copy the app makes on its own, whose stop line at the copy place
  named the same second cause about the same file. Both are MODIFIED requirements in
  `take-out-an-unreadable-store`'s delta, and the take-out row that Story adds carries the same
  cause as its caption, so one reading of the three places answers all three (its `design.md`).

- 2026-09-17 — **`look-back-at-a-quota`'s wireframe said "nav bar: back only"; #274's `design.md`
  says back and the name.** Closed at #274's Stage 4, the next Story to touch the look-back's
  `design.md`, as the entry asked. Its § *What the shell draws* carries the wireframe with the
  navigation bar saying back and the name, which is what the shipped page does since the
  `look-back-name-twice` chore. The G4-signed #273 folder keeps its stale annotation, archived;
  a mockup is a decision aid and never a requirement (ADR-1057).

- 2026-09-16 — **a look-back's line stays two strings, and the shell may compose exactly one of
  them.** Closed at #273's grill, which #272's G7 had left it to. `LookBack.Line` keeps two strings
  per line, because one string would make the shell split a week or a month from its fraction to
  draw its two columns; `look-back-at-a-quota`'s `design.md` § *What the shell may compose* says
  the shell may compose the rhythm-change line — the rhythm, a space, a middle dot, a space, the
  day — and nothing else, and that the heading over the lines and the sentence where a look-back
  says no line are the shell's own words. The em dash the entry named is already gone: since the
  `look-back-layout` chore a kept commitment draws only the "Kept from" row. The `MonthTally` tidy
  the same entry named is `tasks.md` 2.3 of that Story.

- 2026-09-16 — **every worktree walks on a simulator of its own.** `pnpm run walk` used to pick
  whatever iPhone was booted, so with three Stories walking in parallel on 2026-09-15 every
  overlapping run of #261's walk was killed by #267's or #272's uninstalling the app from under it,
  about twenty-three seconds after its last step with `Restarting after unexpected exit, crash, or
  test timeout` and no crash report. A device per worktree rather than a lock, because a lock
  serialises the walks and parallel Stories are the point: `DayByDay walk <worktree directory>`,
  created on first use, kept booted between runs, deleted by the janitor with the worktree and
  pruned by any later walk whose worktree list no longer names it. The stock devices are never
  touched. `docs/running-the-app.md` § *The walk*; the chore is PR #283.

- 2026-09-14 — **a week begins on Monday for everyone, and an unmet weekly quota leaves nothing
  behind when the week turns.** Decided at the eighth grooming pass's grill of B-025, the want
  *Week turnover* had named as the one that would force it: the unfinished third night is neither
  recorded as a miss nor carried over; the week turns, the next starts from zero, and the week that
  turned stays readable by looking back at its days. What a quota's row shows is its **standing**, the
  count of kept days through the row's own date, answered by the history (`CONTEXT.md` § *Week*,
  § *Standing*). Goes to #235 `add-quota-standing` and #236 `say-standing-in-quota-row`; the ADR is
  owed by #235 at Stage 4, where ADR-1015 left the question.

- 2026-09-11 — **specs and change folders are made concise through per-artifact and per-requirement
  budgets, advisory only, and a dedicated editorial-Story lane.** `docs/research/2026-09-09-concise-specs.md`
  measured the problem and ADR-1047 decided it: `openspec/config.yaml` states the budgets `spec-author`
  writes to (60 lines for `proposal.md`, 150 for `design.md`, one line per scenario plus 80 for
  `tasks.md`, 40–150 normative words per requirement), `pnpm run check:budgets` warns on an overrun and
  never blocks, and `reviewer` enforces the same numbers at G7 on its standards axis. A capability spec
  may be condensed with no behaviour change through an **editorial Story**: its delta carries every
  requirement in full — as `## MODIFIED Requirements`, or as REMOVED plus ADDED where a requirement
  cannot reach 150 words and splits — every scenario title is unchanged and no test changes, so rule
  3's red-green loop is moot. The schema is not forked. Tracked at #199: a chore (PR #200) landed the
  config, the four agent edits and the advisory lint, then four editorial Stories condensed one
  capability spec each, every one of them with every scenario byte-identical to `main`:
  `condense-day-screen-spec` (PR #203) took `day-screen`'s prose from 24,847 to 8,374 words over 399
  scenarios; `condense-commitment-spec` (PR #207) took `commitment`'s from 26,522 to 11,414 over 406;
  `condense-record-spec` (PR #206) took `record`'s from 9,244 to 3,287 over 170; `condense-schedule-spec`
  (PR #209) took `schedule`'s from 3,448 to 1,960 over 78, the one Story with no requirement left over
  budget. **Phase 3 — dropping the roughly 118 scenarios the plan found duplicated — is taken up at
  #199's close-out**, one capability at a time, each as its own Story outside #199. It is not an
  editorial Story: every drop deletes a passing test, which that lane forbids, and a scenario leaves a
  requirement only through REMOVED plus ADDED under a new heading — MODIFIED with a scenario omitted,
  REMOVED plus ADDED under the same heading, and RENAMED plus MODIFIED are each refused by
  `openspec validate --strict` and by `openspec archive` on 1.10.0 (ADR-1047, amended 2026-09-11).

- 2026-09-10 — **the two scenarios owed since #137's second review are written, and neither went
  red.** Open since `add-commitment-kind`'s second review, 2026-09-06, as *Two of #137's tests do
  not match their scenarios clause for clause, and check 4 cannot see it* — owed to whichever Story
  next touched `commitment`'s roster or store requirements. `add-kind-to-commitments-screen` (#142)
  pays it, against the owner's decision at that Story's grill (round 2) and against the
  recommendation, since #142 touches `commitment`'s roster and store requirements anyway. *Two
  number commitments alike in every way but the range their kind carries are both held*
  (`RosterTests.swift`) and *a roster store holding a commitment with half a range is refused*
  (`RosterStoreTests.swift`) were both written and run before either had a production change to
  drive: both passed on the first run, confirming rather than fixing the behaviour — the roster
  already compares whole values and the store already refuses a half-written range, exactly as the
  entry said. No test was skipped for being expected to pass, and neither test edits the ones it
  stands beside.

- 2026-09-09 — **the reordered-row lag was the kept list's per-group `ForEach` keyed on
  `\.offset`, introduced by #147, and keying it on the commitment's own value instead fixed it.**
  Open since #147's § 9.5 walkthrough, narrowed at #147's own G7 to `CommitmentsView.swift:79`:
  `main` before #147 read the kept list as one flat `ForEach(screen.kept, id: \.self)`, and #147's
  diff was the one that switched it to `id: \.offset`. #168 (`add-category-order`) moved whole
  blocks through that same line and, per `tasks.md` § 6.3, tried the fix the entry named as the
  remaining candidate — keying the per-group `ForEach` back on the commitment's own value
  (`id: \.self`) rather than its position. The lag was gone on the walk that also confirmed this
  Story's own group-move actions, 2026-09-09. **Confirmed by one walk, not measured** — the earlier
  simulator timings that could not reproduce it off the phone were not repeated here, only the
  phone symptom itself, watched for and not seen.

- 2026-09-08 — **every kind's row now offers something, so a commitment of a kind nothing can
  record is a state nothing can reach.** Open since #137's G7 as *A commitment of a kind nothing can
  yet record is a row that does nothing when tapped*: `add-commitment-kind` made a commitment of the
  number, note or total kind formable and had `record` refuse a tick for it, so `day-screen`'s row
  for one offered nothing — by requirement, and on purpose, since a due commitment does not leave
  the day. `add-number-entry` (#139) gave the number kind its entry, `add-note-record` (#140) the
  note kind its own, and `add-total-record` (#141) spends the last of it: a total row offers a total
  entry, and a take-back besides. **The ordering hazard the entry named is spent with it.** It
  warned that `add-kind-to-commitments-screen` (#142) could land first and let a person define a
  kind whose row answers a tap with silence; there is now no kind #142 can offer that lands on a
  dead row, and the tracker edge the entry kept asking for is no longer owed. It closes on a Story
  that has **not merged** — this chore lands ahead of #141's archive on that Story's `tasks.md`
  § 17.5 — so the closure is true of `story/141-add-total-record` and reaches `main` when it does.

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

  **It is gated twice**: skipped while a PR is a draft — a condition on the job since 2026-09-08,
  so a draft push allocates no runner at all — and skipped unless the diff reaches
  `src/DayByDay/`, `src/DayByDayKit/Sources/`, `src/DayByDayKit/Package.swift` or the workflow,
  which is a condition on the steps
  because it is computed from a diff inside the job. Nothing merges without it having run. The
  gates were put there because the step cost five minutes a push; on 2026-09-07 it was found to be
  costing eight and a half, and taking it apart showed most of that was never the test: a needless
  simulator clone, which is gone, and a cold simulator boot of 2m06s, which is not. The gates
  matter more for that, not less — they are the only thing in the job that can decline to pay a
  boot. What they do **not** promise is worth saying once: a green `ui-smoke` asserts that every
  merge whose diff reached the app drew it, not that this merge drew it.
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

- **`RecordStore.write` and `RecordDocument` carry an unlabelled data clump.** `(ticks,
  numbers, notes)` travels as three positional parameters across the boundary between the
  screen and the store. `RecordStore.write(_:_:_:)` at `RecordStore.swift:148` and
  `RecordDocument.init(_:_:_:)` at `RecordDocument.swift:52` take them in that order; the
  pattern recurs at six call sites across the two modules, plus a bare
  `RecordDocument([], numbers, [:])`  in `RecordDocumentTests.swift:52`. The compiler catches a
  swap today only because the two dictionaries differ in value type — one maps to `Decimal?` and
  one to `String`. `add-total-record` (#141) makes it four kinds, and unlabelled positional
  parameters of the same shape stop being distinguishable by the compiler at all. `design.md` §
  *`History` grows a third one-off reader, knowingly* covers the reader surface and the deferral
  of a general record reader; it does not cover the writer's parameter list, which is where the
  fourth kind will actually hurt. `#141`'s grill will be forced to answer whether four kinds
  justify a `Record` struct holding all four, or a `records(ticks:numbers:notes:totals:)` method
  on the store, or some other shape — and either way the current signature is in the debt for a
  reason: it is deliberately not being designed until all three exist. Recorded 2026-09-08,
  at #140's close-out.
  **Closed by `add-total-record` (#141), 2026-09-08, at the moment it came due.** That Story's
  `tasks.md` § 1.3 labels both parameter lists instead of adding a fourth positional parameter of
  the same shape: `RecordStore.write(ticks:numbers:notes:additions:)` (`RecordStore.swift:183`) and
  `RecordDocument(ticks:numbers:notes:additions:)` (`RecordDocument.swift:61`), with every call site
  moved with them. No behaviour moved and no requirement moved — `design.md` § *`RecordStore.write`
  and `RecordDocument.init` take labels* records it as a mechanical box in § 1 rather than a
  refactor pass, on the ground that the debt was paid at the moment it was recorded to come due
  rather than one kind later, when there would be nothing left to add and no reason to open the
  file. **A `Records` struct holding all four was rejected there rather than deferred**: it is half
  of the general-record shape that is now its own entry under § *Open technical decisions*, and
  taking the writer's half while the reader stays four members would leave the package with two
  answers to what a record is and neither complete. #141 has not merged, so `main` does not carry
  the labels yet. This entry and the note-reader one above it were appended past the `## Settled`
  heading at #140's close-out, which was a mistake; the other has been moved up to § *Known gaps*
  where it belongs, and this one stays here, which as of this closure is where it belongs.
