# Survey — what makes archived change folders long

Line counts as measured (`wc -l`):

| folder | proposal | specs delta | design | tasks | total (3 artifacts) |
|---|---|---|---|---|---|
| `2026-08-30-add-weekday-set-schedule` | 59 | 165 (19 scen) | 233 | 120 | 412 |
| `2026-09-06-add-commitments-screen` | 207 | 1012 (74 scen) | 728 | 1151 | 2086 |
| `2026-09-08-add-number-entry` | 173 | 1060 (75 scen) | 581 | 888 | 1642 |
| `2026-09-09-add-offered-today-control` | 96 | 295 (20 scen) | 239 | 203 | 538 |

Per scenario, `tasks.md` runs 6.3 lines (baseline), 15.6, 11.8, and 10.2 (latest). The baseline is
already the tightest and the latest is close to it — **the two 2026-09-06/08 folders are the
outliers, and both were reopened for a second and third G4.** Reopening is the single largest
driver.

---

## 1. What the space goes on

### proposal.md (207 / 173 / 96)

| category | share in `add-commitments-screen` (207) | evidence |
|---|---|---|
| Requirement inventory restated from the delta | 44 lines (21%) | `## Capabilities` 94–137. L106: "`commitment`: twelve requirements **ADDED**, with fifty-eight scenarios between them — the two lists, defining a commitment, the two refusals…" — the delta's own table of contents |
| Swift declarations / file paths duplicated with `design.md` § *The seam* and `tasks.md` § 1 | ~30 lines (14%) | L141–156: "`DayScreen`'s `private var rosterStore` is **deleted**, with the three assignments that fed it and the now-unread `store` member of `openRoster`'s return tuple" |
| Measurement diary | 7 lines | L171–177: "Measured on this machine on 2026-09-04, on Apple Swift 6.3.3, from `566297e` … reported **300 tests passing**. Measured again on 2026-09-06 … **348** … takes it to **357** … to **371**" |
| Revision history | ~12 lines | "Found at the second review pass of this Story." (L48), "Found at the third review pass." (L57), "when this folder was reopened a second time" (L198) — 3 occurrences plus surrounding clauses |
| Documents explicitly *not* touched | 18 lines (9%) | L201–206: "`docs/backlog.md` — untouched, and it needs no edit." followed by five lines of why |
| Genuinely necessary (Why, one-line What Changes, capability names, Impact) | ~90 lines | — |

`add-number-entry` is the same shape (Impact 119–172 = 54 lines of file-by-file member names,
test counts and ADR-number arithmetic). `add-offered-today-control` (96) shows the floor: its Impact
is six one-line bullets and it carries no counts.

### design.md (728 / 581 / 239)

`add-commitments-screen`, 728 lines:

| category | lines | share | evidence |
|---|---|---|---|
| Swift declarations in `### The seam` | 121 (L90–210) | 17% | the whole `CommitmentsScreen` class body with doc comments, re-issued in `tasks.md` 1.3, 6.5 and 7.1 |
| Revision history / which review pass raised what | ~120 | 16% | L20 "**This folder has been reopened twice, and this document is its third version.**"; L30 "**The third pass raised one finding…**"; L392 "This is the third review pass's finding and it reverses the shape the first two versions of this document left implicit" |
| Answered questions kept in `## Open Questions` | 44 (L685–728) | 6% | L685 "**The second review pass added two more, and both were settled by the owner before this version was written**"; L711 "Five things that could have become questions were decided here instead" |
| Rationale that is ADR-shaped | ~80 | 11% | L444 "**Why no ADR.**" then 10 lines arguing it — inside the design; L388–454 (67 lines) is one decision about a refusal's lifetime |
| Restated from proposal | ~30 | 4% | `## Goals / Non-Goals` L48–74 repeats the proposal's "Not in this change"; L581–594 "Where the requirements live" repeats `## Capabilities` |
| Archive-diff instructions duplicated in `tasks.md` 5.8 | 11 (L666–671) | 1.5% | "`openspec/specs/record/spec.md` must not appear in the archive diff at all" |
| Genuinely necessary: seam prose, decisions, alternatives, risks, real open questions | ~290 | 40% | 10 `*Alternative —*` / `**Rejected:**` blocks; `## Risks / Trade-offs` L595–659 |

`add-number-entry` is worse in one specific way: `## Context` is **132 of 581 lines (23%)** and is
almost entirely a chronology of measurements — L18 "**One measured fact shapes the whole of…**",
L42 "**A second measurement, taken at G7 because the first set was incomplete**", L53 "**A third
measurement, taken at the third G7 pass**", L81 "**A fourth measurement, taken at the fourth G7
pass**", L99 "**A fifth measurement, taken at the sixth G7 pass**". Four of the five exist only to
correct the one before. The *facts* are ~25 lines.

### tasks.md (1151 / 888 / 203)

`add-commitments-screen`, 1151 lines:

| category | lines | share | evidence |
|---|---|---|---|
| **Embedded UI-test source, build recipe and run logs** (all inside box 4.3) | 406 (L259–664) | **35%** | verbatim `WalkthroughUITests.swift` at L335–513 and L601–624 (203 lines of Swift); "File > New > Project… > iOS > App" recipe L317–332; `xcodebuild` invocations and `** TEST SUCCEEDED **` blocks L527–542, L626–642; per-check narration L544–573, L644–663 |
| Absorption / red-green diary (box 5.6) | 130 (L779–908) | 11% | L802 "**1 of 7 new tests in § 3 ran red; 6 of 7 passed on first write**"; L790–800 quotes the implementation of `returnedTo()` back into the task file |
| "What the Nth review pass found" preambles | 76 (L958–981, L1035–1086) | 7% | L1035 "## 7. The third review pass"; L1051 "**One thing happened on `main` while this section was being written, and it is not a finding.**" |
| §2/§3 preambles restating design + predicting reds | 55 (L43–85, L195–206) | 5% | L77–84 lists 13 boxes "`design.md` expects these to run red" |
| Accreted reviewer checklist (box 5.3) | 41 (L683–723) | 4% | three "Three more, added for the Nth pass" blocks plus a G7 triage narrative |
| Rule-5 stop clauses repeated per task | ~25 | 2% | 10 occurrences of "is a rule-5 stop" / "stop and report" |
| Correction-of-a-previous-version prose | ~60 | 5% | L273 "**This box was replaced once and is restored here.**" + 30 lines about an `osascript` error code that turned out to be `-1719`; L816 "**Corrected 2026-09-06:**" |
| Genuinely necessary: 86 checkboxes with their catch-this-bug clauses | ~300 | 26% | e.g. 2.5 "the scenario stops \"Journaling\" before \"Water plants\" precisely to fail an implementation that appends" |

`add-number-entry` (888): §§ 12–15 "What the review found / third / fourth / sixth pass" plus the
trailing `## Notes` and three per-pass "moves" journals occupy **L313–888 = 575 lines (65%)**, and
those journals are pure measurement diary — L770–779 and L801–807 are raw fuzz output pasted in.

`add-offered-today-control` (203) shows what the same discipline costs without a reopening: 17
scenario boxes at one line each, one setup section, one shell section, one gates section. Its
remaining fat is small and identifiable: box 4.4's method narrative (L120–135, 16 lines) and six
per-task stop clauses.

---

## 2. Duplication map

| content | appears in | single home it should have |
|---|---|---|
| Full Swift declarations of the seam (class body, doc comments, cases) | `design.md` § *The seam* (121 lines) **and** `tasks.md` 1.1–1.4, 6.5, 7.1 | `design.md`, as a signature list without doc comments; `tasks.md` cites it ("exactly the surface `design.md` § *The seam* gives") — which it already does, while re-listing every member anyway |
| Which requirements/scenarios the delta contains, and their titles | `proposal.md` § *Capabilities* (44 lines), `design.md` § *Where the requirements live*, `tasks.md` §§ 2–3 box titles, `specs/**` | `specs/**`. Proposal names capabilities and the operation only |
| Rationale for a requirement | `grill.md` § *Settled*, `proposal.md` § *What Changes* bullets, `specs/**` requirement prose, `design.md` § *Decisions* | `design.md` (or an ADR). The specs delta's own prose is a second copy: `add-offered-today-control/specs/day-screen/spec.md` L8–18 argues "**The screen answers this, and nothing outside it works it out**", which is `design.md` § *Why the screen answers about the control* |
| Test counts and toolchain versions | `proposal.md` § *Impact*, `design.md` § *Context*, `tasks.md` 1.1, 5.1, 5.6, 11.2, 6.1 | one gate box in `tasks.md`, measured not derived (5.1 L667–676 spends 10 lines re-deriving 391 from 300+47+1+9+14 and getting it wrong) |
| Archive-time checks for the janitor | `design.md` § *Migration Plan* L666–671 **and** `tasks.md` 5.8 | `tasks.md`, in the one box that names who ticks it |
| Grill answers | `grill.md` § *Settled*, quoted into `proposal.md`, `design.md` § *Context*, `design.md` § *Open Questions*, and per-task notes | `grill.md`, cited by number ("settled answer 9") — the folders already do this well; the leakage is `design.md` § *Open Questions* re-narrating them |
| Which scenarios ran red | `tasks.md` § preambles (prediction) + 5.6 / `## Notes` (outcome) | nowhere, or one line in the hand-back. It is evidence about the process, not about the change |

---

## 3. What must stay (with the rule that demands it)

- **`### The seam` under Decisions in `design.md`.** `AGENTS.md` § *Vocabulary you need before Stage
  4*: "a `design.md` naming none fails the Definition of Ready. The openspec `design` template has
  **no seam section** — add `### The seam` under Decisions yourself". `docs/process.md` L636 (DoR):
  "Seam(s) named in `design.md`".
- **`## Open Questions` filled in, "None." valid and required.** `.claude/agents/spec-author.md`
  L38–41: "That section must be **filled in**: \"None.\" is a valid and required answer — say why,
  never leave it empty." DoR: "No open questions left by the grill, and no residual round
  outstanding."
- **One task per scenario, with its verification.** `AGENTS.md` rule 3: "Each red-green cycle takes
  the next unsatisfied `#### Scenario:` from the delta, writes exactly one acceptance test named
  identically to that scenario". Schema `tasks` instruction: "Each task MUST state how to verify
  completion (a test, command, observable behavior, or delivered artifact). Put the verification in
  that task's checkbox description."
- **Checkbox format `- [ ] X.Y` under `## numbered headings`.** Schema: "**IMPORTANT: Follow the
  template below exactly.** The apply phase parses checkbox format… Tasks not using `- [ ]` won't be
  tracked."
- **Every box tickable before the archive.** `spec-author.md` L97–99: "`openspec validate
  --archived` refuses until all of them are ticked, and the janitor that runs `/opsx:archive` cannot
  tick one afterwards". DoD: "every `tasks.md` box ticked".
- **The "who ticks it and when" clause on a post-archive task.** `spec-author.md` L115–118: "**Say in
  that box who ticks it and when** … `add-number-entry` (#139) shipped this box in exactly the right
  shape and it still stalled, because nothing in it said whose tick it was". `add-offered-today-control`
  6.5 L185 is the model: "**The `implementer` ticks this box, in its last commit before the archive**".
- **Error and edge scenarios, not just the happy path.** DoR: "every requirement has scenarios
  covering its error and edge cases". `spec-author.md` L92–94.
- **MODIFIED requirements carried in full.** Schema: "**MODIFIED Requirements**: Changed behavior -
  MUST include full updated content… Common pitfall: Using MODIFIED with partial content loses
  detail at archive time." This is duplication the archiver requires — do not rule it out.
- **`## Purpose` on a new capability's delta**, 50+ chars, or `--strict` flags it (schema L86–90).

---

## 4. Rules I would write

```yaml
rules:
  proposal:
    - Hard cap 60 lines — Why ≤6, What Changes ≤12 one-line bullets, Capabilities ≤8, Impact ≤12.
    - Capabilities names capability paths and ADDED/MODIFIED/REMOVED only — never requirement titles, scenario counts, or why some other capability was not created.
    - Impact names files and directories only; no Swift declaration, member name or signature — the seam is declared once, in design.md.
    - No test counts, tool versions, commit SHAs or dates anywhere in this file.
    - Never say when in the Story's life a point was found; write the current state as if this were the first version.
    - Do not account for documents this change leaves alone.
  design:
    - Hard cap 150 lines — Context ≤20, Goals/Non-Goals ≤12, Decisions ≤80, Risks ≤20, Open Questions ≤12.
    - Include "### The seam" under Decisions; give each member one signature line and no doc comment.
    - One decision is at most 12 lines — the choice in bold, why, then each rejected alternative in one line.
    - Context states each fact the design turns on once, as its current measured answer; never a chronology of measurements or which review pass took them.
    - Reference proposal.md and specs/ rather than restating them; Non-Goals adds only design-level boundaries.
    - Open Questions lists only what is still open, or "None." with the reason; an answered question is a decision and belongs above.
    - A decision that outlives this change goes to docs/adr/ and is cited here by number in one line.
  tasks:
    - One line per scenario — the title verbatim, plus at most one clause naming the wrong implementation it catches.
    - Hard cap = one line per scenario, plus 80 lines for setup, shell, gates and the archive handover.
    - Never paste source code, a test body, a build recipe, a command transcript or a log; record a verification as one line — what ran, the count, pass or fail.
    - State the rule-5 stop rule once at the top of the file, not per task.
    - No "what review pass N found" sections; when the folder reopens, edit the boxes that change and append the new scenario boxes.
    - One test-count assertion for the whole file, in the final gate box, read off a run and never derived by arithmetic.
    - Every box tickable before /opsx:archive; a post-archive check is prose inside a box that names who ticks it and when.
    - Do not predict which scenarios will run red, and do not record afterwards which ones did.
  specs:
    - Requirement prose states the rule normatively and stops; why this rule belongs in design.md or an ADR.
    - Scenarios are WHEN/THEN bullets only — no note about the implementation a scenario would catch.
    - MODIFIED requirements carry the whole requirement verbatim; that duplication is the archiver's and is never trimmed.
```

What each removes, and what it would have saved in `add-commitments-screen`:

| rule | category from part 1 | saved |
|---|---|---|
| tasks: never paste code/recipes/logs | embedded UI-test source + recipe + logs (35%) | **~300 of box 4.3's 406** — keeps the box, the simulator/iOS line, the pass line, nine one-line observations |
| tasks: no review-pass sections, no red diary | absorption diary + §6/§7 preambles + corrections | **~300** (5.6's 130, preambles 76, corrections ~60, prediction lists ~30) |
| tasks: one line per scenario | per-scenario prose | ~40 |
| tasks: stop rule once, one count | repeated stops + per-section counts | ~50 |
| design: seam is signatures only | 121 lines of declarations | ~100 |
| design: no measurement chronology, no revision history | 120 lines | ~110 (and ~100 in `add-number-entry`'s Context) |
| design: Open Questions = still open only | 44 lines | ~40 |
| design: 12 lines per decision, ADR for the rest | ADR-shaped rationale | ~150 |
| proposal: Capabilities is names only | 44 lines | ~34 |
| proposal: no Swift, no counts, no history, no untouched docs | ~67 lines | ~60 |

Realistic targets for this repo: **proposal ≤ 60, design ≤ 150, tasks ≤ 1 line/scenario + 80.**
`add-commitments-screen` would land at roughly **60 / 180 / 155** instead of 207 / 728 / 1151 — a
1690-line cut. `add-offered-today-control` already passes proposal (96 → needs ~15 cut) and comes
within ~40 lines on tasks, which is the evidence the targets are reachable rather than aspirational.

---

## 5. Where the length is earning its keep — do not cut these

1. **A measured Foundation fact that generates a requirement.**
   `2026-08-30/design.md` L28–31: "Foundation's `Calendar.date(from:)` **rolls invalid components
   rather than returning nil**: asked for 30 February 2026 it returns 2 March 2026 … That single
   fact is why the third requirement in the delta exists and why it is worded as a refusal to
   adjust." Same in `2026-09-08/design.md` L18: "`Decimal(string:)` is a *prefix* parser, not a
   validator" — without it an implementer puts the length check after the parse, which is exactly
   the `fatalError` box 12.2 found shipped. **The rule cuts the chronology of measurements, never
   the current fact.** Budget ~4 lines per fact in § *Context*.

2. **The "who ticks it" clause and the archive handover.**
   `spec-author.md` L100–118 records two real stalls: `add-roster-store` (#103) shipped a box whose
   tick depended on the archive and "unpicking it meant resetting an uncommitted archive by hand";
   `add-number-entry` (#139) had the right shape and stalled anyway for want of one clause.
   `add-offered-today-control` 6.5 (L184–203, ~20 lines) is the whole cost and it prevented both.

3. **The one clause per box that names the wrong implementation.**
   `2026-09-06/tasks.md` 2.5: "the order is the order they were **taken on**, not the order they
   were stopped in; the scenario stops \"Journaling\" before \"Water plants\" precisely to fail an
   implementation that appends"; 2.8 "an implementation using the today as the start date fails";
   3.5 "the test that fails any implementation of `returnedTo()` that delegates to `shown(asOf:)`".
   Also `2026-09-09/tasks.md` 1.2, four facts to confirm before a line is written. These are one
   line each and each one is a defect not shipped. The one-line-per-scenario rule keeps them.

4. **A trade-off recorded so it is not read later as an oversight.**
   `2026-09-06/tasks.md` L885–896: the test for *a commitments screen keeps its roster at the place a
   day screen keeps its* is `#expect(CommitmentsScreen.rosterPlace == DayScreen.rosterPlace)` where
   the static is *declared* as `DayScreen.rosterPlace`, so "the assertion is `X == X` and no change
   to either side can fail it… what was missing is this paragraph." That belongs in
   `design.md` § *Risks* as one bullet, not in a 130-line diary — but it must survive the cut.
