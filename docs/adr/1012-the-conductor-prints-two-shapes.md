# 1012. The conductor prints two shapes, and the shape says whether a reply is wanted

- Status: accepted
- Date: 2026-09-02
- Deciders: Diego Bugmann
- Amended: 2026-09-03 — `janitor` no longer hands back whether the graph changed, because it
  no longer refreshes it (ADR-1024). The two shapes, the step report and the rest of each
  worker's hand-back list are unchanged.
- Amended: 2026-09-03 — the five-part block asks first and details last, *What is in front of
  you* becomes `Detail` under a ten-line budget, and G7's findings are its one exemption. The two
  shapes, the step report, the labels and the reply vocabulary are unchanged.
- Amended: 2026-09-04 — the **round** joins as a third shape, so this record now describes three
  shapes across the four things the conductor prints, and wrapping a round in a five-part block
  is forbidden. The title still says *two* and is kept deliberately: over a hundred
  cross-references resolve by number, and ADR-1020 is explicit about what renaming costs.
- Amended: 2026-09-04 — a round is **one question, asked through `AskUserQuestion`**, not a block
  of markdown carrying the whole frontier. Settled by running the new grill in front of the owner
  the day it was written: the markdown round could not be answered from the keyboard, and a
  four-question batch was still four questions to hold in your head at once.

## Context

This extends ADR-1002; it reverses nothing in it.

ADR-1002 gave the gate stop a fixed form because "each session improvised the presentation,
which is how a gate quietly becomes a rubber stamp." It gave everything else the conductor says
one clause — *"reports what came back"* — and no form at all. So between gates the conductor
improvised by construction, in exactly the way the gate form was written to stop, and nothing
ruled out any of the shapes that takes: an agent's whole report pasted, the status tree echoed
on every pass of the loop, or nothing, with the next thing on screen a gate. The human had
learned one shape for decisions and none for the trail.

Three consequences follow.

**Nothing said when the human would next be needed.** The stage table's *Who decides* column is
described as "the column that matters when you are asking whether you can walk away", and it is
right about that — but it is a table in a document, and the moment the question is actually
asked is the moment the conductor spawns an agent. Nothing was printed there.

**A gate arriving after an unattended run did not stand on its own.** The owner's sessions are
days apart. G7 would open with a PR link and findings, and the human reconstructed from memory
what had happened since they said `approved`.

**"Report, not a gate — if they say nothing, proceed" cannot be executed.** `atlas.md` used that
phrase for the braindump split. In a session that takes turns, either the conductor's turn ends
and it is asking, or it does not end and it is telling; there is no third state in which a report
is printed and silence is read as consent. What that sentence produced in practice was a stop
that did not admit to being one.

Two smaller defects shared the cause. The gate form's pair, *what yes commits you to* against
*what no costs*, fit G4 and had to be bent to fit the question round and the cluster pick, whose
replies are choices rather than approvals. And at G7 the form's instruction to keep the context
section short collided with ADR-1002's requirement that the reviewer's findings reach the human
unmediated, with nothing saying which wins.

### And the block's first form had no size discipline

The two shapes were first fixed on 2026-09-02, and the sessions run under them were measured the
same day. The step report worked: across four sessions the conductor printed seven of them,
averaging four lines. The five-part block did not. Twelve were printed across the same four
sessions, at **34 to 78 lines each** — so roughly six sevenths of everything the human read
between steps was gate and stop blocks, and the owner's report was that the conductor "states a
lot of things to me."

The cause was that the context section was both first and unbounded. Three failures followed from
that, all of them visible in the transcripts.

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

The trail had been given a budget and the block none, on the assumption that the trail was the
thing that would sprawl. It was the other way round, and what follows is written against the
measurement rather than the assumption.

## Decision

**The conductor prints four things in three shapes, and the shape is what tells the human
whether a reply is wanted — and what kind of reply.** A gate block and a stop block, both the
five-part form; a round; and a three-line step report. **A five-part block asks for a decision, a
round asks for answers, a `▸` line tells.** There is no fifth.

The count moved because the round was added, not because the reasoning did. In a session that
takes turns, either the conductor's turn ends and it is asking, or it does not end and it is
telling. **The round is a species of asking, not a fourth state**: it ends the turn exactly as a
gate does, and differs only in what comes back. There is still no shape that reports and treats
silence as consent, and there is still no channel for one.

**The step report** is three lines: what ran, what it left behind, what comes next. It is printed
before every spawn, after every return, and as the form of a rule-5 stop.

- Before a spawn, `left` is dropped and `next` is the walk-away line: the gate or stop the human
  will be asked at next, and what has to happen first. This is *Who decides* said at runtime.
- After a return, `left` names only things the human can open, run or count — a URL, a commit, an
  exit code, a number — and never an account of how it went.
- On a rule-5 stop, the middle carries the failing command and its output **verbatim, in a code
  block**, followed by what was not done. The conductor never diagnoses inside it.

The workers are told what to hand back so that the report can be built from their return without
the conductor reading their work: `spec-author` the PR URL, the validate exit, the scenario count
and the decisions the delta turns on; `implementer` the PR, the last commit, the two exit codes,
ticked scenarios and rebase state; `janitor` the archive commit, the merge and the parents
settled. This is ADR-1002's *the conductor holds no work context* made operational: the
conductor can only relay what the agent named.

**The five-part block asks, and the question is its first part.** The parts, in order: the
question; *if you take the recommendation* against *if you don't*; the recommendation; the exact
reply; then `Detail`. The ask, the lean and the reply vocabulary fit on one screen, and what
supports them is read second or not at all.

**The same form is used for three kinds of stop, and its labels fit all three.** Gates carry a
G-number; stops without a marker — the residual round, the sweep, the cluster pick, the braindump
split — carry a `Stop —` header instead. The pair is *if you take the recommendation* against
*if you don't* rather than yes against no, which reads the same at a binary gate and holds a
choice without strain.

**`Detail` carries three things and nothing else** — the trail since the human last replied, the
links, and the one or two decisions the thing turns on. Its first line is what ran since the human
last replied, present only when something did, so that a gate reached after an unattended run is
complete on its own. **The test is mechanical: anything the human could read by opening a link is
a link, not a paste.** Ten lines is the working budget, and a block that runs longer has relayed
an agent's report instead of the artifact that agent wrote. An agent's self-description, and
findings that are not the question being asked, are the two things `Detail` is not.

**At G7 the reviewer's findings go in verbatim**, grouped under the conductor's triage, and the
triage is the recommendation. They sit under `Detail` like everything else, at whatever length the
reviewer wrote them: ADR-1002's *unmediated* outranks the budget, and this is the budget's single
exemption.

**The round is one question, asked through `AskUserQuestion`.** The recommended answer is its
first option, marked `(Recommended)`; the options after it are the answers actually considered;
*Other* comes from the harness and is where a written answer goes. No wrapper of any kind — no
five-part block, no line budget, no reply vocabulary. **The frontier is drained, not batched**:
every question whose prerequisites are settled gets asked, one after another, and the frontier is
recomputed after each answer rather than after each batch. `AGENTS.md`'s "a gate carries one
decision, so do not ask four things when one decides it" says in its own next clause that it is a
rule about gates and only about gates; it does not reach a grill, where the sixth question is the
product — and the rule it *does* impose here is about never dropping a question, not about
delivering them together. Like a gate a round ends the conductor's turn; unlike a gate another
almost always follows, and the loop runs until the frontier is empty. ADR-1006, amended, is where
the round belongs to the process; this record only fixes its shape.

**The braindump split and the sweep's gaps are stops, and say so.** The reasoning `atlas.md`
already gave for the split — the one judgement the human can correct in a sentence and nobody
else can, cheap to get wrong silently — is the definition of a stop, and a stop ends the turn.

**Status is echoed once, on entry, and not inside the loop.** It answers "where am I?", which is
asked once; inside the loop the step report's `next` line carries the one thing that changed.

## Consequences

- **The human learns three shapes and reads the header.** A `G` header or a `Stop —` header
  means a decision is wanted and the fourth part says what to type; a bare question with options
  means an answer is wanted and more will be asked; a `▸` line means nothing is wanted. The
  question "am I being asked something, and what kind of something?" is answered before the first
  sentence.
- **A round is one question, and the shape is the tool rather than the markup.** *Amended
  2026-09-04.* Two forms were tried in front of the owner on the day this was written and both
  failed for the same reason: a markdown block of six questions cannot be answered from the
  keyboard, and a four-question `AskUserQuestion` batch is still four things to hold in your head
  while answering the first. One question per call, recommendation first, frontier recomputed
  after every answer. **What must not follow is truncation** — asking one question and dropping
  the rest of the frontier is the failure ADR-1006 exists to stop, and it now looks superficially
  like the correct behaviour. The guard is `grill.md` § *Left open*, which is required and must
  say why anything is still there.
- **The human answers the question they were asked, not the one they can still remember.** The
  ordering is what makes that true; the parts, the labels and the reply vocabulary would work in
  any order and the ask would still be buried under an unbounded context section.
- **The rubber stamp is reachable from two sides, and the form guards both.** ADR-1002 put the
  recommendation in the form because without a stated lean the cheapest reply is yes. A block
  whose ask you must scroll to find produces the same reply for the opposite reason — the human
  reads the recommendation because it is the only part they can find. Question-first closes that.
- **Every gate is self-standing**, which is the same principle as *start every session from
  durable files* applied to the moment of decision.
- **A gate that will not fit the budget is a signal, not a formatting problem.** It means the
  conductor is holding work context, which is the failure ADR-1002's *the conductor holds no work
  context* exists to catch. The budget makes that visible at the moment it happens.
- **The walk-away line is a promise the conductor can break.** If an agent stops early, the
  human is needed sooner than the line said; the *stopped* form is what tells them, and it is
  why that form exists rather than free prose.
- **The step report is only as good as the hand-back.** Nothing checks that an agent named its
  exit codes or its commit; a return that says "done, all green" produces a `left` line the
  conductor cannot fill, and the right move is to say so in it rather than to go and look — the
  same trade as ADR-1005 and ADR-1006: the artifact is checkable, the judgement is not.
- **Wrapping a round in a five-part block is forbidden, and that is the point of adding the
  shape.** The block carries one question under a ten-line budget, so putting an interview inside
  it forces the conductor to drop every question except the most important one — which are
  exactly the questions a grill exists to reach. That wrapping was this repository's own addition
  to the `grilling` protocol, it is what made the grill read as a questionnaire, and it is now
  written down as wrong in `.claude/skills/grill/SKILL.md` so that the next tidy-up does not
  reinstate it. The general rule it is an instance of: a form built for one question does not
  become a form for n by being used for n.
- **Side findings have nowhere to go inside the block**, which is deliberate and incomplete: they
  are forbidden there without this record saying where they land. `docs/open-questions.md`,
  `docs/backlog.md` and an issue are the three existing homes, and choosing between them is a
  follow-on.
- **One more stop on the capture path**, for a braindump only. A single want still has none.
  This is the honest version of a stop that was already there.
- **This adds shapes, not gates**, and ADR-1002's test still applies: nothing blocks on a step
  report and nothing blocks on a block's length, nothing reads either, and if a shape or the
  budget ever grows a marker or a check it has become the sixth gate that ADR was written to
  avoid.

## Alternatives considered

**Leave the between-gate output to judgement.** The baseline, and the one ADR-1002 rejected for
gates on the grounds that improvised presentation degrades quietly. The same argument holds one
level down, and the retrospective's cost model — the owner's attention is the scarce input — is
what the trail spends when it has no shape.

**Give the status projection the job.** `pnpm run status` already says whose turn it is, so the
conductor could echo it after every step and print nothing else. Rejected because status is a
projection of the systems of record and cannot say what *just ran*, which is the thing the
trail is for; and because a transcript that is the same tree repeated is one the human stops
reading, which is the failure the step report is shaped against.

**Shorten the step report rather than the block.** The obvious move once the transcripts were
long, and the measurement is what ruled it out: seven reports at four lines against twelve blocks
at fifty. Trimming the shape that was already working would have bought nothing and cost the
trail.

**Write the trail to a file and print only the walk-away line.** Rejected as a mechanism invented
to solve a problem the block was causing. The trail is four lines and cheap; the fix belongs where
the cost is.

**Keep yes/no and add a variant form for choices.** Rejected: the whole value of one shape is
that the human learns one, and two labels that fit every stop cost nothing.

**Drop the *if you take the recommendation* pair, which duplicates the recommendation.** At many
stops one half is contentless — "the delta as it stands; G4 is the next stop" says nothing. Left
open deliberately rather than rejected: question-first may be the whole of the problem, and this
is to be judged after the shape has been lived with.

**A `Report —` header for things the human may object to but need not answer.** This is the
"proceed if they say nothing" tier, given a name. Rejected because it does not exist: a printed
report either ends the turn or it does not, and naming a state between the two would describe a
channel that is not there — the defect ADR-1006 found in the question round, one layer up.
