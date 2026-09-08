# Architecture Decision Records

One file per decision, in [MADR](https://adr.github.io/madr/)-style format.

**An accepted ADR may be edited.** When a decision changes, change the file that holds it rather
than writing a new record that supersedes part of the old one. Git history is the audit trail:
this repository is public, every ADR change arrives as a commit on a pull request, and
`git log -p docs/adr/<file>.md` answers "what did this say before, and why did it change" better
than a chain of files each holding a fragment of the answer.

Three things go with the edit.

1. **Say what changed and why in the PR.** That is where it is read, attached to the diff that
   carries it.
2. **Stamp it in the file.** Add a line to the header block, under `Deciders`, newest first:
   `- Amended: YYYY-MM-DD — <one line>`. A reader sees the file has moved without opening git,
   and knows to go looking if they care why.
3. **Leave one coherent decision behind.** Fold the new shape in, so the file reads as the
   decision as it stands today rather than as a decision with a rebuttal stapled to it. Keep
   reasoning from the old shape only where it explains why the current one is what it is.

**A trivial fix needs no stamp** — a typo, a dead link, a path that moved. The stamp is for a
change that someone who has read the decision would want to be told about. `## Corrections` was
the older name for the same idea; the five ADRs carrying one keep it as the history it is, and
nothing new goes there.

An ADR should not be the place a command name lives in the first place. It fixes the *shape*
of a decision; the operative commands belong in `AGENTS.md` or under `docs/`, where they are
expected to move. **The same holds for a count or a price.** State the delta a decision makes —
*one guaranteed stop gained, one occasional one lost* — which stays true however the totals move,
and leave the totals in the one file that keeps them. ADR-1002 carried "roughly four times per
Story" from the day it was accepted to the day it was amended, and the figure was never right,
because it had written down a total in a record.

Write an ADR when a decision was hard, is expensive to reverse, or would surprise someone
reading the code later. Do not write one for choices the code already makes obvious.

**Numbering.** This repository shares its history with Atlas, the development system it was
started from, and may merge process fixes down from it. Numbering both from the same sequence
would sooner or later have each of them writing a different `0015`. So `0001`–`0999` are
reserved for Atlas, and **DayByDay's own ADRs start at `1001`**. The fourteen records below
are Atlas ADRs this project inherits; they are real decisions and they still hold.

**A number is never reused, and a gap is normal.** Deleting a file frees nothing. Over a hundred
`ADR-NNNN` cross-references resolve by number — in `AGENTS.md`, under `docs/`, in `.claude/`, and
in archived change folders that may not be edited at all — so a reused number silently re-points
every one of them at a different decision. A new ADR takes the lowest number that no file and no
open branch has ever used, which is why claiming one means checking the branches and not just
`main`. `1011`, `1014`, `1016` and `1018` are gaps, left by decisions that were folded into the
records they had partly superseded; that is what a gap looks like, and it is fine.

| ADR | Decision |
|---|---|
| [0001](0001-monorepo.md) | Specs, docs and code live in one repository |
| [0002](0002-systems-of-record.md) | The repo owns content, GitHub owns state |
| [0003](0003-epic-feature-story-mapping.md) | Epic to Feature to Story, mapped onto OpenSpec changes |
| [0004](0004-branch-isolation-and-archive.md) | One change per branch; archive inside the story PR |
| [0005](0005-scenarios-drive-tests.md) | Scenarios drive acceptance tests one-to-one; nothing is generated |
| [0006](0006-model-routing-and-agent-permissions.md) | Model routing rule and the agent write-permission matrix |
| [0007](0007-public-repo-free-org.md) | Public repository in a free organisation, with no LICENSE file |
| [0008](0008-toolchain.md) | Toolchain: Node 24, pnpm 11, TypeScript pinned to 5.9.3, Vitest 4 |
| [0009](0009-skill-inventory.md) | Install the skills plugin whole; four skills are never invoked |
| [0010](0010-tdd-enforcement.md) | TDD is enforced by convention and a PR-time lint, not commit-order forensics |
| [0011](0011-supply-chain-quarantine.md) | Dependency versions are quarantined for 24 hours |
| [0012](0012-no-project-board.md) | No GitHub Project board; the gate checkboxes are the status |
| [0013](0013-permission-matrix-enforcement.md) | The write-permission matrix is enforced in three layers, and only partly |
| [0014](0014-g4-approval-marker.md) | G4 is a relayed human decision, recorded as `G4: approved` and enforced at merge time |

DayByDay's own records start here.

| ADR | Decision |
|---|---|
| [1001](1001-swift-and-swiftui.md) | The app is built in Swift and SwiftUI, native to iPhone |
| [1002](1002-the-conductor-is-the-main-session.md) | The conductor is the main session; `pnpm run status` is a projection; it holds no work context but the grill's question tree |
| [1003](1003-the-pr-is-the-gate-surface.md) | The PR opens at Stage 4 as a draft; both human gates are read through it |
| [1004](1004-the-rule-engine-speaks-calendar-dates.md) | The rule engine speaks calendar dates, not instants |
| [1005](1005-the-grill-is-a-step-inside-propose.md) | The grill is a step inside Stage 4, run by the conductor; the stage numbers keep the gap at 3 |
| [1006](1006-the-question-round.md) | The conductor holds the Story grill, in rounds, before the change folder is written; a written round is what is left over, and it is a stop rather than a gate |
| [1007](1007-g4-signs-a-digest.md) | The G4 marker carries a digest of what was approved; the specs are not merged first |
| [1008](1008-the-single-change-rule-is-convention.md) | CI check 3 is dropped; one change per PR is convention, and the check numbers keep the gap |
| [1009](1009-one-grill-skill-wraps-the-flagged-one.md) | One `grill` skill owned by this repo wraps `grill-with-docs`, which no agent can invoke; both grills run through it |
| [1010](1010-a-groomed-backlog-replaces-the-parking-lot.md) | A groomed backlog replaces the parking lot; `/atlas idea` captures, `/atlas backlog` promotes, and a want waits without going bad |
| [1012](1012-the-conductor-prints-two-shapes.md) | The conductor prints three shapes across four things: the five-part gate and stop, which ask first and detail last, the round, and the three-line step report; extends ADR-1002 |
| [1013](1013-a-commitment-is-kept-from-a-day.md) | A commitment is kept from a day, and is not due before it |
| [1015](1015-a-weekly-quota-is-due-every-day.md) | A weekly quota is due every day; whether it has been met is not a schedule question |
| [1017](1017-records-are-kept-in-one-file.md) | Records are kept in one JSON file, written whole on every change; SwiftData and GRDB declined, with the reversal trigger named |
| [1019](1019-the-app-shell-runs-in-the-simulator.md) | The app shell is a chore rather than a Feature, runs in the iOS Simulator, and the target is called `DayByDay`; amended 2026-09-04 with a bounded exception letting shell work ride the Story it exists to make usable |
| [1020](1020-adrs-are-mutable.md) | An accepted ADR is edited in place and stamped; git history is the audit trail, and numbers are never reused |
| [1021](1021-a-day-screen-without-its-record-draws-the-day.md) | A day screen that cannot read its record still draws the day and refuses every tick; nothing is held in memory |
| [1022](1022-the-day-is-said-in-the-apps-own-words.md) | A day is said in the app's own English words, fixed in `DayByDayKit`; no `Locale`, no `DateFormatter`, and the shell composes nothing |
| [1023](1023-a-commitment-is-kept-until-a-day-the-roster-holds.md) | A commitment is kept until a day, and the roster holds that day — a fourth part on the commitment would orphan every tick; amended 2026-09-07 so a commitments screen hands the day *before* the one it was handed |
| [1024](1024-the-graph-refreshes-itself.md) | `docs/graph.mmd` is regenerated by CI on every issue event and pushed to `main` over a deploy key; the janitor's graph step and its chore PR are gone |
| [1025](1025-the-bundle-identifier-is-com-dbugmann-daybyday.md) | The bundle identifier is `com.dbugmann.daybyday`, fixed from the first install on a phone; changing it orphans the record |
| [1026](1026-a-day-screen-keeps-the-day-you-moved-to.md) | Being shown again keeps the day a day screen was moved to, except on today, where it follows onto the new day; one comparison, no state of its own |
| [1027](1027-day-one-is-written-into-an-empty-roster.md) | Day one is the app's content and the engine's moment: the owner's eight commitments are taken on exactly when the roster read holds nothing at all |
| [1028](1028-a-screen-may-refuse-what-the-engine-accepts.md) | A screen may refuse what the rule engine accepts, where the refusal is about what a person should be offered to make; the engine is never narrowed to match a screen |
| [1029](1029-the-ui-smoke-layer-is-a-chore-and-it-is-xctest.md) | The UI smoke layer is a committed XCUITest target on the chore lane; Swift Testing is switched off in a UI test bundle, so CI check 4 never has to see it |
| [1030](1030-the-kind-is-a-commitments-fourth-part.md) | The kind its days take is a commitment's fourth part; a kind never changes and every commitment older than kinds is a tick, so ADR-1023's re-keying argument does not reach it |
| [1031](1031-a-store-reads-the-form-before-it.md) | A store reads every form it has written and refuses every other, reads each as the shape that form has, and rewrites the file only when a change is kept there; no migration pass, no rewrite on open; amended twice on its own reversal trigger, 2026-09-06 and 2026-09-08 |
| [1032](1032-a-recorded-number-is-a-decimal.md) | Every number a person records is a `Decimal`; `Double` loses a total's sum, and `Decimal`'s not-a-number comparisons are asymmetric, so a refusal may never rest on one |
| [1033](1033-a-number-is-taken-back-by-naming-the-day.md) | A record is taken back by naming its commitment and its date, never what it holds — a mistyped weight or a wrong day's note must be clearable without reading it back; the tick keeps its by-value shape, and the total's fourth signature removes one addition rather than the day |
| [1034](1034-a-schedule-says-its-rhythm-in-words.md) | A schedule says its rhythm in the package's own words — "Mon, Wed, Sat", "Every 14 days", "The 25th", "3x a week" — and no payload accessor becomes public; extends ADR-1022 from a date to a rule |
| [1035](1035-a-roster-never-lets-a-commitment-go.md) | A roster never lets a commitment go: removing is a third state beside kept and stopped, so every past day keeps its rows and day one stays unreachable without a marker |
| [1036](1036-a-notice-names-a-cause-a-person-can-act-on.md) | A day screen's notice names a cause exactly where a person can act on that cause differently — four of them, and no fifth: a value that is not a number, a number outside its range, an amount not above zero, and a sum too large to keep exactly; the words are the package's, and ADR-1021 is untouched; amended 2026-09-08 when the set went from two to four |
| [1037](1037-a-rosters-order-is-the-persons.md) | A roster's order is the person's, carried by `move` and array position alone; the day screen inherits it for nothing, and a screen-held arrangement was rejected so nothing has to keep two orders in step |
| [1038](1038-a-category-is-the-rosters.md) | A category is held by the roster against a commitment, never as a fifth part of one — ADR-1023's re-keying argument reaches a label a person is expected to move, where ADR-1030's exemption for the kind does not — and the grouping rule is the roster's with it, so the day view goes on inventing no order |
| [1039](1039-blank-is-one-test-asked-in-one-place.md) | Whether a text says anything is one test in one place with no exception, and it is Swift's `Character.isWhitespace` — Foundation's character sets swallow a zero-width space, which is measurably how a paste deleted a day's number until the number entry's trim moved onto this test too |
| [1040](1040-a-days-sum-is-capped-where-a-typed-number-is.md) | A day's additions may sum to at most thirty-eight significant digits, judged on the sum arithmetic gives and refused at the row — `Decimal` truncates silently past that and reports no error, so a `record`-side cap would make a store read back differently from what it holds |
| [1041](1041-a-total-entrys-blank-commit-means-nothing.md) | A total entry's blank commit keeps nothing and takes nothing back, and its take-back is its own act on the row, offered only where the day holds an addition — the other two entries' blank take-back would delete the last addition from a field that opened empty |
| [1042](1042-the-horizontal-swipe-belongs-to-the-day.md) | A horizontal swipe on a day screen moves the day — left goes forward — and the screen owns that gesture permanently, so no day-screen row may ever take a swipe action; the chevrons stay beside it |
