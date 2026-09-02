# 1014. The question comes first, and the detail is budgeted

- Status: accepted
- Date: 2026-09-02
- Deciders: Diego Bugmann

Supersedes the **ordering** of the five parts fixed by ADR-1012, and replaces its instruction to
"keep *What is in front of you* short" with a budget and a test. Everything else in ADR-1012
holds unchanged: two shapes and no third, the three-line step report, the `Stop —` header, the
*if you take the recommendation* pair, the trail line, and G7's verbatim findings. Per
`docs/adr/README.md`, ADR-1012 keeps its file and is not edited.

## Context

ADR-1012 was accepted on 2026-09-02 and the first sessions run under it were measured the same
day. The step report worked: across four sessions the conductor printed seven of them, averaging
four lines. The five-part block did not. Twelve were printed across the same four sessions, at
**34 to 78 lines each** — so roughly six sevenths of everything the human read between steps was
gate and stop blocks, and the owner's report was that the conductor "states a lot of things to
me."

The shape had no size discipline, and *What is in front of you* was both first and unbounded.
Three failures followed from that, all of them visible in the transcripts.

**The ask was buried.** In the question round on Story #55, *The question* began on line 12 and
the reply vocabulary on line 30. The human read eleven lines of context before learning what they
were being asked, and forty-five at the G2 on Feature #53.

**The block absorbed the agent's report.** That G2 reproduced both proposed Stories with their
rationale paragraphs, the three things deliberately not sliced with a reason each, and the
decisions — nearly all of it also on the tracker or in the draft PR, one click away.

**Findings that were not the question rode along.** The stop that asked whether to drive #42 to
the finish also carried three unrelated repo edits the `orchestrator` had noticed. The form had
no slot for *by the way*, so they went into the gate, and the human had to hold them while
answering something else.

The common cause is that ADR-1012 gave the trail a budget and the block none, having assumed the
trail was the thing that would sprawl. It was the other way round.

## Decision

**The question is the first part, and `Detail` is the last.** The five parts, in order: the
question; *if you take the recommendation* against *if you don't*; the recommendation; the exact
reply; then `Detail`. The ask, the lean and the reply vocabulary fit on one screen, and what
supports them is read second or not at all. The parts themselves are ADR-1012's, unchanged and
unrenamed except that *What is in front of you* becomes `Detail`, which is what a section at the
bottom of a block is.

**`Detail` carries three things and nothing else** — the trail since the human last replied, the
links, and the one or two decisions the thing turns on. **The test is mechanical: anything the
human could read by opening a link is a link, not a paste.** Ten lines is the working budget, and
a block that runs longer has relayed an agent's report instead of the artifact that agent wrote.
An agent's self-description, and findings that are not the question being asked, are named as the
two things it is not.

**G7's reviewer findings are the single exemption.** ADR-1002 makes them the one artifact that
must reach the human unmediated; they sit under `Detail` like everything else, at whatever length
the reviewer wrote them.

## Consequences

- **The human answers the question they were asked, not the one they can still remember.** The
  ordering is the whole change; the parts, the labels and the reply vocabulary are all ADR-1012's.
- **The rubber stamp is now reachable from two sides, and the form guards both.** ADR-1002 put
  the recommendation in the form because without a stated lean the cheapest reply is yes. A block
  whose ask you must scroll to find produces the same reply for the opposite reason — the human
  reads the recommendation because it is the only part they can find. Question-first closes that.
- **A gate that will not fit the budget is a signal, not a formatting problem.** It means the
  conductor is holding work context, which is the failure ADR-1002's *the conductor holds no work
  context* exists to catch. The budget makes that visible at the moment it happens.
- **Side findings now have nowhere to go inside the block**, which is deliberate and incomplete:
  this record forbids them there without saying where they land. `docs/open-questions.md`,
  `docs/backlog.md` and an issue are the three existing homes, and choosing between them is a
  follow-on.
- **Nothing checks any of this.** Like ADR-1012, it adds shapes and not gates: nothing blocks on
  a block's length, and if the budget ever grows a check it has become a gate.

## Alternatives considered

**Shorten the step report.** The obvious move, and the measurement is what ruled it out: seven
reports at four lines against twelve blocks at fifty. Trimming the shape that was already working
would have bought nothing and cost the trail.

**Drop the *if you take the recommendation* pair, which duplicates the recommendation.** At many
stops one half is contentless — "the delta as it stands; G4 is the next stop" says nothing. But
it is a partial reversal of a decision taken hours earlier, and question-first may be the whole
of the problem. Left open deliberately, to be judged after this has been lived with.

**Write the trail to a file and print only the walk-away line.** Rejected as a mechanism invented
to solve a problem the block was causing. The trail is four lines and cheap; the fix belongs where
the cost is.

**Cap *What is in front of you* without moving it.** Half the change, and the weaker half: a
ten-line context section still sits between the human and the question, and a budget with nothing
behind it is the kind of instruction that erodes. Moving the section is what makes the budget
enforceable by eye — if the ask is not on the first screen, the block is wrong.
