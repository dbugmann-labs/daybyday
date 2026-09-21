# Layout audit

A prompt for a fresh session at the repo root, when the owner wants every page of the app looked
at for layout rather than one Story's screen. It is not a pipeline step: it runs on `main`,
proposes as artifacts, stops once for the owner, and then acts on the answer as chores or wants.
The per-Story version of the same question is the layout round of the Story grill (ADR-1057),
which is why nothing here opens a Story.

Start the session with:

> Run the audit in `docs/agents/layout-audit.md`.

---

Audit the layout of every page in the DayByDay iPhone app and propose improvements, two or three
of them as mockup artifacts. Read `AGENTS.md` first; it is binding. Work from the repo root on
`main`, and change nothing until step 5.

1. **Inventory the pages.** Read `src/DayByDay/DayByDay/ContentView.swift`,
   `CommitmentsView.swift`, `LookBackView.swift` and `CommitmentLine.swift`. List every screen and
   sheet a person can reach: the day screen and its paged day views, the day picker, the one-offs
   group and its entry, the commitments screen with its kept and stopped lists and categories, the
   commitment sheet with its refusals, and the look-back page. For each, name the file, the specs
   that say what it must show (`openspec/specs/day-screen`, `commitment`, `one-off`, `look-back`,
   `schedule` for the rhythm in words), and the strings the shell must draw unaltered.

2. **Learn the rules a layout must keep.** `CONTEXT.md` § *Product principles* and the terms
   *Offered*, *Day title*, *Look-back*; ADR-1045 (marks, fades, nothing congratulates, no
   percentage, no streak); ADR-1022 (the app's own words, locale-independent); ADR-1053 (the
   walk). A proposal that changes what a screen says, or a seam string, is a requirement change
   and not a layout change; keep the two apart in everything you write.

3. **See the pages as they are.** Fetch the most recent walk pictures from the merged Story PRs
   (`gh pr list --state merged --search "walk" --limit 20`, then the comments posted with
   `--attach`) and read them. Where a page has no recent picture, drive the simulator once for it
   with a throwaway XCUITest as `docs/running-the-app.md` § *The walk* describes; before you do,
   check with `xcrun simctl list devices booted` and `pgrep -fl xcodebuild` that no other agent is
   using the simulator, and wait until it is free. Never commit the test.

4. **Propose.** For every page, write what is unclear, unlabelled, inconsistent with the other
   pages, or wasting the screen, and one sentence on the fix. Then pick the two or three changes
   with the most effect for the least movement and build each as an artifact: an HTML page with
   phone mockups, the current page beside the proposed one, light and dark, using the seam's real
   strings and example figures, with a caption saying what moved and why. Load the
   `artifact-design` skill before writing them. Classify every proposal as **chore** (no
   requirement, no seam string and no test changes; only the view moves) or **want** (something a
   screen says would change). Stop and present the list and the artifact links to the owner in
   one five-part block: the question is which proposals to take, the reply is the numbers to take
   as chores, the numbers to capture as wants, or `none`.

5. **Act on the answer.** A chore: cut `chore/<slug>` in its own worktree per
   `docs/story-mechanics.md` (rule 8, `git branch --unset-upstream`, `pnpm install`), change only
   the view files, build with
   `xcodebuild -scheme DayByDay -destination 'generic/platform=iOS Simulator' build`, run
   `pnpm run verify` and `pnpm run checks`, walk the changed pages on a free simulator and post
   the pictures to the PR with `pnpm run walk -- --post-only <pr>` (never a bare
   `gh pr comment --attach`, which posts at full width), open the PR, and stop for the owner to
   read the pictures. Commits and PRs never mention Claude, AI or any agent, and carry no
   attribution trailer (rule 7). A want: capture it with `/atlas idea <want>` in the owner's
   words, one entry per outcome. Do not open Stories, do not edit `openspec/`, and do not touch
   `.claude/` or `CLAUDE.md`.
