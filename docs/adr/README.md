# Architecture Decision Records

One file per decision, in [MADR](https://adr.github.io/madr/)-style format.

**ADRs are immutable once accepted.** A reversal is a new ADR that supersedes the old one;
the superseded file stays where it is. Never edit an accepted ADR to change its decision, its
rationale, or the alternatives it weighed. Those three are the record, and the whole value of
the register is that a reader can trust they still say what they said on the day.

**Incidental detail may be corrected in the open.** A command name, a version, a path or a
cross-reference that was simply wrong is not the decision — and leaving it wrong turns the
register from a record into a trap, because these are the files an agent is told to read to
find out how things work. Correct it in place and make the correction visible:

1. Fix the text.
2. Add a `## Corrections` section at the end of the file, if it has none.
3. Add one dated line saying what it said before, and why this is not a change of mind.

**The test is step 3.** If you cannot write that line without describing a change of mind,
this is not a correction — supersede the ADR instead. Silent edits are the thing this policy
exists to prevent; a visible erratum is not one.

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
| [1010](1010-a-groomed-backlog-replaces-the-parking-lot.md) | A groomed backlog replaces the parking lot; `/atlas idea` captures, `/atlas backlog` promotes |
| [1011](1011-fable-is-the-fourth-model-tier.md) | Fable is a fourth model tier, taken by `spec-author` alone; supersedes ADR-0006's routing rule |
