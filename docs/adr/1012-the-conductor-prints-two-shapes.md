# 1012. The conductor prints two shapes, and the shape says whether a reply is wanted

- Status: accepted
- Date: 2026-09-02
- Deciders: Diego Bugmann

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
replies are choices rather than approvals. And at G7 the form's instruction to keep *what is in
front of you* short collided with ADR-1002's requirement that the reviewer's findings reach the
human unmediated, with nothing saying which wins.

## Decision

**The conductor prints two shapes, and the shape is what tells the human whether a reply is
wanted.** A five-part block asks. A three-line step report tells. There is no third.

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
ticked scenarios and rebase state; `janitor` the archive commit, the merge, the parents settled
and whether the graph changed. This is ADR-1002's *the conductor holds no work context* made
operational: the conductor can only relay what the agent named.

**The five-part form is used for three kinds of stop and its labels change so that it fits all
three.** Gates carry a G-number; stops without a marker — the question round, the sweep, the
cluster pick, the braindump split — carry a `Stop —` header instead. The pair becomes *if you
take the recommendation* against *if you don't*, which reads the same at a binary gate and holds
a choice without strain. And the first line of *what is in front of you* is what ran since the
human last replied, present only when something did, so that a gate reached after an unattended
run is complete on its own.

**The braindump split and the sweep's gaps are stops, and say so.** The reasoning `atlas.md`
already gave for the split — the one judgement the human can correct in a sentence and nobody
else can, cheap to get wrong silently — is the definition of a stop, and a stop ends the turn.

**At G7 the findings go in verbatim**, grouped under the conductor's triage, and the triage is
the recommendation. ADR-1002's *unmediated* outranks the form's *keep it short*.

**Status is echoed once, on entry, and not inside the loop.** It answers "where am I?", which is
asked once; inside the loop the step report's `next` line carries the one thing that changed.

## Consequences

- **The human learns two shapes and reads the header.** A `G` header or a `Stop —` header means
  a reply is wanted and the last part says what to type; a `▸` line means nothing is. The
  question "am I being asked something?" is answered before the first sentence.
- **Every gate is self-standing**, which is the same principle as *start every session from
  durable files* applied to the moment of decision.
- **The walk-away line is a promise the conductor can break.** If an agent stops early, the
  human is needed sooner than the line said; the *stopped* form is what tells them, and it is
  why that form exists rather than free prose.
- **The step report is only as good as the hand-back.** Nothing checks that an agent named its
  exit codes or its commit; a return that says "done, all green" produces a `left` line the
  conductor cannot fill, and the right move is to say so in it rather than to go and look — the
  same trade as ADR-1005 and ADR-1006: the artifact is checkable, the judgement is not.
- **One more stop on the capture path**, for a braindump only. A single want still has none.
  This is the honest version of a stop that was already there.
- **This adds shapes, not gates**, and ADR-1002's test still applies: nothing blocks on a step
  report, nothing reads one, and if either shape ever grows a marker or a check it has become
  the sixth gate that ADR was written to avoid.

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

**Keep yes/no and add a variant form for choices.** Rejected: the whole value of one shape is
that the human learns one, and two labels that fit every stop cost nothing.

**A `Report —` header for things the human may object to but need not answer.** This is the
"proceed if they say nothing" tier, given a name. Rejected because it does not exist: a printed
report either ends the turn or it does not, and naming a state between the two would describe a
channel that is not there — the defect ADR-1006 found in the question round, one layer up.
