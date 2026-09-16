# 1053. A Story that reaches the shell walks it, and the pictures go on the PR

- Status: accepted — sixteen answers by the owner at a plan grill on 2026-09-15, every one on the
  recommendation put to them; accepted by the chore PR that carries it
- Date: 2026-09-15
- Deciders: Diego Bugmann
- Amended: 2026-09-16 — decision 5 also reads each picture against the wireframe `design.md`
  § *What the shell draws* carries, the layout the owner chose at the grill from a mockup
  (ADR-1057); a picture of a different layout is a finding by box like the ones named there.

## Context

**Nothing looked at the app before it merged, and nobody had decided that.** Until 2026-09-09
every Story that touched the shell carried a walk box in its `tasks.md`: the implementer wrote a
throwaway XCUITest, drove the Simulator through the new screen, took screenshots, and wrote what
it saw into the box — `add-offered-today-control` (#174) § 4.4 and `add-day-picker` (#181) § 4.3
are the shape. Where the Simulator could not prove a step, the owner walked it on the phone
(`rework-commitment-row-actions` (#192) § 5.6). Three rules landed on 2026-09-10 and, together,
deleted the step without any of them meaning to:

- ADR-1047's budget took prose, logs and transcripts out of `tasks.md`, so the written evidence
  had nowhere to go.
- The apply guidance in `openspec/config.yaml` said *never run the `DayByDayUITests` bundle*,
  after one run outlived a session's output watchdog and was killed with work uncommitted.
- #186's G7 ruled *a simulator is not this box: it is the phone* — and from #192 on,
  `spec-author` wrote no phone box either, because nothing required one.

Six UI Stories then merged with no one having seen a screen: one-offs on the day screen, interval
restart, quota standing, the row actions, adjacent day views and the kind on the commitments
screen. `ui-smoke` ran on each and passed, as it should have: it asserts that the shell drew,
never what (ADR-1029).

**What was measured on this machine on 2026-09-15**, macOS 26.6.2, Xcode 27.0, before deciding:

- The smoke bundle runs in 40 seconds on a warm simulator: boot 9s, build 12s, test 19s. The
  never-run rule was written from a cold boot on a runner and from one stalled session; neither
  is the local case.
- A `simctl io screenshot` taken after a test ends shows the home screen, because the runner has
  terminated the app. Screenshots therefore have to be taken *inside* the test, with
  `XCTAttachment`, and exported afterwards with `xcresulttool export attachments`, which names
  them by attachment name in its manifest.
- **The stall had a cause, and it was not the boot.** A *failing* UI test returned only after
  ten minutes, during which `xcodebuild` collected a sysdiagnose — Xcode's default failure
  diagnostics — and the process sat silent. `-collect-test-diagnostics never` is a documented
  `xcodebuild` flag and turns it off. A passing test returned in seconds both times.
- XCUITest is the only driver this machine can run. AXe, idb and Maestro install through
  Homebrew, which this account cannot use (`AGENTS.md` § *This machine*). Claude Code Desktop's
  simulator pane needs Xcode 26.x and this machine has only 27. Synthetic touch still cannot
  drive a drag across groups, which is why B-042 went through the owner's phone.
- `gh pr comment --attach` uploads an image to GitHub's attachment store and renders it inline;
  it arrived in `gh` 2.99.0, needs push access, and refuses the Actions `GITHUB_TOKEN`. The
  installed `gh` was Homebrew's 2.83.0. A 2.100.0 binary in `~/.local/bin` shadows it.
- `ui-smoke` has never gone red. All thirteen failed CI runs in the repository's history failed
  in `swift` or `verify`.

## Decision

**A Story whose diff reaches `src/DayByDay/` owes a walk, and the walk's pictures go on the PR
before review.** In nine parts, each an answer the owner gave:

1. **The walk is written at propose.** `spec-author` adds `## The walk` to `tasks.md` from
   `grill.md`: one box per screenshot, one line each, naming the state to drive to and what the
   picture must show. The Story grill asks which screens the owner wants to see and which steps
   only a phone can prove. G4 signs the list with the rest of the folder.
2. **The implementer runs it at the end of Stage 6**, after every scenario is green and
   committed: uninstall the app so the walk starts on the day-one roster, write a throwaway
   `WalkUITests.swift` that drives the boxes and attaches a screenshot named for each, run it
   through `pnpm run walk`, read every picture against its box, and post them to the PR as one
   comment with `--attach`, each captioned with its box. Then delete the test.
3. **The test is never committed.** A UI suite nobody owns rots (ADR-1029), so the PR comment is
   the durable evidence and the tree merges with `src/DayByDay/DayByDayUITests/` unchanged; the
   reviewer checks that diff is empty. The exported PNGs stay untracked in `walk/` for the
   reviewer to read.
4. **The walk fails only when a step cannot be driven.** Each step waits for the control it
   taps; nothing about what is shown is asserted, because that is what the seam tests do. A walk
   that asserted content would be a second, calendar-sensitive copy of the delta in XCUITest —
   the thing ADR-1029 rejected.
5. **The reviewer reads the pictures** on the spec-fidelity axis: a screen that contradicts a
   requirement is a finding named by box, and so is a missing picture or a missing comment.
6. **G7 is where the human sees them.** The stop links the walk comment and lists any line
   marked `phone:`. No new gate and no new number; the G7 reply covers the pictures and the phone.
7. **The phone is asked only where the simulator cannot prove a step** — a drag, paging under
   the finger, a long press, haptics. Those lines are marked `phone:` in the walk list at
   propose, and the owner walks them before replying at G7.
8. **Screenshots only.** No recordings: they are large, hard to read in a PR, and the steps a
   recording would show best are the ones that go to the phone.
9. **`ui-smoke` stays exactly as it is.** Its one unique guard is a shell chore merged without a
   walk. It costs nothing attended and nothing in money, and removing it is a ruleset change
   plus an ADR amendment for a saving of a few unattended minutes.

**The walk is a Story artifact and a chore's tool, not a capability.** It lives in `tasks.md`
one line per screenshot, outside ADR-1047's 80-line budget the way a scenario does, and its
runner is `scripts/walk.ts` with the commands written out longhand in `docs/running-the-app.md`.

## Consequences

- **A UI Story costs one more implementer step and one more thing to read at G7**, and the
  human's three stops per Story do not become four. What it buys is the owner's stated goal: to
  see a change before it ships, and where it can be felt only on a phone, to be told which step
  that is.
- **The never-run rule is replaced**, in `openspec/config.yaml` and `.claude/agents/implementer.md`,
  with the three things that actually keep a session safe: commit before the run, run
  `xcodebuild` in the background with its output to a file, and pass
  `-collect-test-diagnostics never`. `pnpm run walk` refuses a dirty tree and passes the flag.
- **`gh` on this machine is `~/.local/bin/gh` 2.100.0**, recorded in `AGENTS.md`
  § *This machine*. It is a machine setting, like the OpenSpec `delivery` pin; a new machine
  starts at whatever Homebrew has, and `pnpm run walk -- --post` says so when `--attach` is
  missing.
- **The walk runs here, not in CI**, and that is a fact rather than a preference: the Actions
  token cannot attach an image, a runner pays a two-minute cold boot, and the owner's phone is
  on this side anyway. CI keeps `ui-smoke`; it does not gain a screenshot step.
- **A walk list is a promise about controls the shell has not been written yet**, so a step the
  implementer cannot drive is a stop under rule 5 with the runner's own error, never a retry
  loop, a `sleep`, or a walk rewritten around the missing control. If the box is what is wrong,
  that is reported the same way.
- **The pictures are a record the archive does not keep.** They live on the PR; the change
  folder holds the list and the comment's URL. A reader who wants to know what a Story looked
  like opens the PR, which is the same place the gates were read.
- **The first walk was of `main`**, on the chore PR that carries this record — eighteen pictures
  covering the day screen, paging, ticking, the commitments screen, reorder mode, both swipe
  actions, the change sheet with its Restart section, the define sheet, the kind picker, and a
  total defined and added to. Anything wrong in them is a backlog want, not a fix on that PR.

## Alternatives considered

**Snapshot testing with a pixel reference.** Rejected again for the reason ADR-1029 gave, and one
more: a stored reference answers "did this change" and the owner asked "what does it look like".
The walk answers the second and leaves the first to the seam tests.

**Running the walk in CI and attaching from there.** Rejected on a fact: `--attach` refuses the
Actions token. A workflow could commit PNGs to the branch or upload an artifact, and both put
the pictures somewhere other than the PR conversation the gates are read in.

**Committing the walk tests and keeping them.** Rejected: one file per Story in a bundle CI does
not run is dead code that every screen change breaks, and ADR-1029's rule — this bundle asserts
that the shell drew, never what — would be broken by the first kept walk.

**Committing the pictures into the change folder.** Rejected: every screenshot of every Story in
a public repository's history forever, for a record the PR already keeps.

**A separate "look" stop before G7.** Rejected: a fourth interruption per Story for what the G7
reply already covers once the block links the comment.

**The reviewer or the conductor running the walk.** Rejected: the reviewer writes nothing and
posting is a write; the conductor holds no `src/`. Driving a written list is execution, which is
the implementer's tier (ADR-0006).

**Driving the simulator with AXe, idb or Maestro instead of XCUITest.** Not reachable — all
three install through Homebrew — and not needed: XCUITest taps, swipes, types and screenshots
through a supported interface with nothing to install.
