# 1005. The grill is a step inside Stage 4, and the stage numbers keep the gap

- Status: accepted
- Date: 2026-08-30
- Deciders: Diego Bugmann
- Amended: 2026-09-04 — the grill step is the conductor's rather than `spec-author`'s: it is held
  as an interview, in rounds, and `spec-author` writes the change folder on the answers it
  settled. The stage decision is untouched — grilling is still the first step of Stage 4 and not
  a stage of its own, and the numbering gap at 3 stands. ADR-1006.

## Context

The process had ten stages, and Stage 3 was *Grill*: a `spec-author` session that ran
`grill-with-docs` on a Story, closed its open questions, added any new domain terms to
`CONTEXT.md`, and stopped — after which a second session ran `/opsx:propose` and wrote the
change folder.

`docs/process.md` §12 has always listed folding that stage into Stage 4 as the first cut to
make if the process hurt: *"Cheapest cut, smallest loss."* `docs/retrospective.md` §6 scored
the list against the first end-to-end Story and left it first: *"Grilling never justified its
own session at one Story."*

What settled it is that the cut had already happened. Authoring the change folder for
`add-day-of-month-schedule` (#9), the whole of Stage 3 and Stage 4 ran as one pass: the open
questions were closed inside `design.md` while it was being written, `CONTEXT.md` gained its
new term in the same pass, and the change folder validated. The *artifacts* Stage 3 exists to
produce were all there and all correct. The separate session was not, and nothing noticed —
because nothing checks for it, and there is nothing it could check. A stage whose only trace is
a section of `design.md` that the next stage would fill in anyway is a stage that has already
been absorbed.

Leaving the table describing a session nobody runs is the failure mode this repository has hit
before and written down twice: four documented commands that could never have worked, every one
of them written from memory rather than verified (`docs/retrospective.md` §5). Documentation
that describes a mechanism nobody executes is the same defect wearing process clothes.

## Decision

**Grilling is the first step of Stage 4, not a stage.** The grill and the propose are one stage
with no gate between them: the conductor holds the grill, and `spec-author` writes the change
folder on the answers it settled. The three obligations Stage 3 carried survive the move intact,
and are now Stage 4's:

- `design.md` § **Open Questions** is filled in. "None." — with the reason — is a valid and
  required answer; an empty section is not one.
- New domain terms land in `CONTEXT.md`. The grill lands the terms it settles; `spec-author`
  lands what writing the delta turns up.
- **The human still answers what the grill cannot settle** — and they now answer it inside the
  grill itself, in the round, rather than in writing after the fact, so folding the stage made
  this obligation stronger rather than weaker. That was never an agent's decision to make, and
  folding the stage did not make it one. It is stated in the *Who decides* column of Stage 4, in
  `docs/process.md` §4's obligation sentence, and in `.claude/commands/atlas.md` § *The Story
  grill*; what is still answered in writing is the residual round, for the question that only
  becomes visible while the delta is being phrased. ADR-1006.

**`grill-with-docs` stays enabled.** It is no longer named as a mandatory step, but it is still
the skill the grilling step is built out of, and it is what maintains `CONTEXT.md`. A skill you
have stopped *requiring* is not a skill to disable; the kill list in ADR-0009 is for skills that
would do damage if invoked, and this is not one.

*Overtaken twice since, and left here because the reasoning above is why it survived both times.*
ADR-1009 stopped routing anything to it a day later: it is flagged `disable-model-invocation`, so
`grill` — this repository's own — makes the two `Skill` calls its body makes, and nothing reaches
`grill-with-docs` any more. `grill` is the tool for the grilling step; this is the skill it wraps.
And the step itself is now the conductor's, per the amendment above.

**The stage numbers keep the gap.** There is no Stage 3. Stages run 0, 1, 2, 4, 5, 6, 7, 8, 9,
and everything downstream keeps the number it had.

## Consequences

- **`G4: approved` survives untouched, which is the whole reason for the gap.** A stage number
  is also its gate's name, and G4's marker is a literal string read by CI check 5,
  `pnpm run check:g4`, `.github/ISSUE_TEMPLATE/story.yml`, ADR-0014 and every Story issue
  already approved on GitHub. Renumbering the stages would force one of two bad outcomes:
  rename the marker and falsify the record on issues that are already closed, or keep the
  marker and leave G4 hanging off a stage numbered 3. The gap costs a reader one question,
  answered where the table stands.
- **The numbering already worked this way.** The gates are G1, G2, G4, G7, G8 — there is no G3,
  G5 or G6, and nobody reads that as an error. A number names the thing it belongs to, not its
  place in a queue. The stage numbers now behave the same way.
- **`pnpm run status` reports one fewer stage.** A Story with no change folder, and a Story
  whose `design.md` leaves Open Questions empty, both report Stage 4 — the second with the
  human as owner, so the obligation stays visible in the projection and not only in the prose.
- **Nothing enforces that the grill happened**, and nothing did before either. `pnpm run status`
  checks that the Open Questions section is non-empty, which is a check on the artifact, not on
  the thinking. Now that the grill is an interview the gap is wider at one point: **a grill in
  progress is not observable at all**, because `grill.md` is written when the interview closes.
  A session that stops mid-grill leaves its answers in a transcript and nothing on disk to resume
  from. That is the same trade ADR-0010 makes for red-before-green: the artifact is checkable,
  the discipline is not, and saying so is better than implying otherwise.
- **`docs/process.md` §12's cut list is one shorter**, and its first remaining entry is folding
  Stage 7 into Stage 8 — which `docs/retrospective.md` §6 demoted on evidence, review being the
  highest-yield stage measured. The next cut to reach for is dropping the Epic level.
- Rejected: **renumbering 4–9 down to 3–8.** It reads tidier and costs the gate names, the
  marker string, two ADR titles and every "Stage N" reference in `scripts/`, `.github/` and
  `docs/`. Tidiness is not worth falsifying a record that CI reads.
- Rejected: **keeping Stage 3 in the table as a row that says "folded into Stage 4".** That is
  the fiction with a footnote attached rather than removed, and the next reader has to work out
  which of the two the process actually is.
- Rejected: **retiring `grill-with-docs`.** Nothing about it was the problem. The problem was
  the session boundary around it.
