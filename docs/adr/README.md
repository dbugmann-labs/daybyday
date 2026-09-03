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
expected to move.

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
| [1002](1002-the-conductor-is-the-main-session.md) | The conductor is the main session; `pnpm run status` is a projection |
| [1003](1003-the-pr-is-the-gate-surface.md) | The PR opens at Stage 4 as a draft; both human gates are read through it |
| [1004](1004-the-rule-engine-speaks-calendar-dates.md) | The rule engine speaks calendar dates, not instants |
| [1005](1005-the-grill-is-a-step-inside-propose.md) | The grill is a step inside Stage 4; the stage numbers keep the gap at 3 |
| [1006](1006-the-question-round.md) | A question the grill cannot settle is relayed by the conductor as a round, not a gate |
| [1007](1007-g4-signs-a-digest.md) | The G4 marker carries a digest of what was approved; the specs are not merged first |
| [1008](1008-the-single-change-rule-is-convention.md) | CI check 3 is dropped; one change per PR is convention, and the check numbers keep the gap |
| [1009](1009-one-grill-skill-wraps-the-flagged-one.md) | One `grill` skill owned by this repo wraps `grill-with-docs`, which no agent can invoke |
| [1010](1010-a-groomed-backlog-replaces-the-parking-lot.md) | A groomed backlog replaces the parking lot; `/atlas idea` captures, `/atlas backlog` promotes, and a want waits without going bad |
| [1012](1012-the-conductor-prints-two-shapes.md) | The conductor prints two shapes: the five-part stop, which asks first and details last, and the three-line step report; extends ADR-1002 |
| [1013](1013-a-commitment-is-kept-from-a-day.md) | A commitment is kept from a day, and is not due before it |
| [1015](1015-a-weekly-quota-is-due-every-day.md) | A weekly quota is due every day; whether it has been met is not a schedule question |
| [1017](1017-records-are-kept-in-one-file.md) | Records are kept in one JSON file, written whole on every change; SwiftData and GRDB declined, with the reversal trigger named |
| [1019](1019-the-app-shell-runs-in-the-simulator.md) | The app shell is a chore rather than a Feature, runs in the iOS Simulator, and the target is called `DayByDay` |
| [1020](1020-adrs-are-mutable.md) | An accepted ADR is edited in place and stamped; git history is the audit trail, and numbers are never reused |
| [1021](1021-a-day-screen-without-its-record-draws-the-day.md) | A day screen that cannot read its record still draws the day and refuses every tick; nothing is held in memory |
| [1022](1022-the-day-is-said-in-the-apps-own-words.md) | A day is said in the app's own English words, fixed in `DayByDayKit`; no `Locale`, no `DateFormatter`, and the shell composes nothing |
