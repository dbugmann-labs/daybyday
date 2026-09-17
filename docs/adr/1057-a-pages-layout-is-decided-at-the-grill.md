# 1057. A page's layout is decided at the grill, from a mockup

- Status: accepted — five answers by the owner at a grill on 2026-09-16, every one on the
  recommendation put to them; accepted by the chore PR that carries it
- Date: 2026-09-16
- Deciders: Diego Bugmann
- Amended: 2026-09-17 — the mockup page is pictures to compare, by the owner's word after the
  first few layout rounds: "way too much text, and I always had to scroll down to try and figure
  out where the differences between the options are". Decision 2's options now sit in one row,
  in one theme at a time behind a toggle rather than both at once, with their differences
  numbered on the pictures over one difference table; the recommendation's reasoning and the
  ASCII wireframes move off the page into the designer's report. What lands in `grill.md` and
  `design.md` is unchanged. `.claude/agents/designer.md` § *What you write* holds the rules.

## Context

**The owner first saw the look-back page's design at G7, and sent it back.** Story #272 was
grilled over thirteen questions, every one about what the page shows, counts and enters. None
asked what it should look like. `design.md` treated layout as the shell's, the implementer built
rows in a list, the walk pictured them, and at G7 the owner said the page was "just rows one below
another, not clear what means what, no styling, no headings". What followed was a design agent, an
HTML mockup published as an artifact so two options could be compared, a view rewritten, a walk
re-driven and a third review pass — three rounds after a Story that was otherwise clean.

The walk (ADR-1053) shows a screen before it merges, and it did its job: the owner saw the page.
What it cannot do is show a page before it is built, so a layout the owner dislikes costs a build
and a walk to find out. The mockup that settled it took minutes and no simulator, and the owner
chose from it without wanting a rendered prototype.

## Decision

1. **The layout is a grill question, asked as the last round of the Story grill.** For any
   Story whose diff will reach `src/DayByDay/` — the same trigger as the walk — the conductor
   writes `grill.md`, spawns `designer` with the issue number, publishes the file it returns as
   an artifact, and asks the round with the link: which option, with the designer's
   recommendation first. A change confined to one control gets the designer's line *no layout
   question here* and no round.
2. **`designer` is a read-only Opus agent that writes one HTML file in scratch.** It reads
   `grill.md`, the specs, the principles and the app's other screens, and returns two or three
   options as phone mockups in light and dark, drawn from the seam's real strings, with an ASCII
   wireframe of each. It never edits a view and never runs the simulator.
3. **The answer lands in `grill.md` under `## Layout`**: the option chosen, the artifact URL,
   and the wireframe. `spec-author` carries the wireframe verbatim into `design.md` under
   `### What the shell draws`, which G4 signs. The wireframe lines sit outside `design.md`'s
   150-line budget, as the walk sits outside `tasks.md`'s 80.
4. **The implementer builds the view to that section, and the reviewer reads the walk pictures
   against it.** A picture that shows a different layout from the wireframe is a finding by box,
   beside the ones ADR-1053 already names.
5. **The mockup is a decision aid, never a requirement.** Nothing in it is a rule: the strings
   are the seam's, the layout is the shell's, and a later Story may change the layout without a
   delta. The artifact is private to the owner's account and is read back with the Artifact
   tool; the repo keeps the wireframe.

## Consequences

- **A shell Story's grill gains one round and one spawn**, and the human's three stops per
  Story stay three: the layout is chosen inside the grill they were already sitting for. What
  it buys is that the first build is the one the owner wanted, and the walk's pictures are
  evidence rather than the first look.
- **The wireframe in `design.md` is the contract the implementer builds to**, so a layout
  argument at G7 is now about whether the pictures match it, not about taste after the fact.
- **A mockup precedes `design.md`**, so the seam's exact strings may not all exist when it is
  drawn. The designer uses what `grill.md` settled and marks the rest as example figures; the
  wireframe, not the figures, is what is carried forward.
- **Existing pages were never grilled this way.** `docs/agents/layout-audit.md` is the prompt
  that looks at all of them once, proposes as artifacts, and lands the answers as chores where
  no requirement moves and as wants where one would.

## Alternatives considered

**A stop before G4, with the mockup drawn from the delta.** The seam strings would all exist by
then. Rejected: it adds a fourth stop, and it puts a layout decision beside the hard gate, which
carries one decision by rule.

**The implementer posts mockups at Stage 6 before coding the view.** Rejected: an interruption
between G4 and G7, which the pipeline runs unattended by design.

**Committing the mockup HTML into the change folder.** It would be signed and archived. Rejected:
the file is a decision aid with example figures, a private artifact serves the choosing, and the
wireframe is the part that outlives the choice.

**The conductor draws the mockup itself**, as it did for #272. Rejected: it works once, but the
conductor holds no work context by rule (ADR-1002), and drawing options is creating, which routes
to an Opus agent.
