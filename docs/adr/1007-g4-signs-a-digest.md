# 1007. The G4 marker carries a digest of what was approved; the specs are not merged first

- Status: accepted
- Date: 2026-08-30
- Deciders: Diego Bugmann

## Context

G4 is recorded as a comment on the Story issue reading `G4: approved` (ADR-0014), and read as
the draft PR's diff (ADR-1003). The question that opened this was whether the change folder
should instead be merged to `main` in its own pull request before implementation begins — the
approval becoming a merge rather than a comment.

Two claims are usually made for that shape, and neither survives inspection here.

**It would not make the gate more authentic.** Agents act through the repository owner's token,
so an agent can merge a pull request exactly as easily as it can write a comment. Nor is there
a review to lean on: [GitHub does not permit the author of a pull request to approve
it](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/approving-a-pull-request-with-required-reviews),
and every PR in this repository is authored by the one human account. That is why the ruleset
on `main` already requires zero approvals (`docs/process.md` §5). The authenticity residue
ADR-0014 named is not closed by a merge; it is unmoved by it.

**It would not improve the reading surface.** ADR-1003 already gave G4 a diff to be read as.

What the merge-first shape *would* buy is the one thing the marker genuinely lacked: the
approval pinned nothing. `G4: approved` names no commit and no content. A change folder edited
after the gate — a scenario softened once it proved awkward to test, a decision rewritten in
`design.md` — merges under an approval that covered different text, and nothing anywhere
notices. Check 5 asked only whether the marker existed. The reviewer at G7 reads spec fidelity
against the delta *as it stands on the branch*, not as approved. So the gate the entire
requirement set rests on could quietly come to cover something the human never read.

## Decision

**Keep the marker on the issue, and make it say what it approved.** The marker becomes:

```
G4: approved <digest> — authorised by <name>
```

where `<digest>` is 12 hex characters fingerprinting every file in the change folder except
`tasks.md`. **CI check 5 recomputes it** and fails when no marker on the issue signs the folder
as it stands. Re-approval is a second marker comment; the first is left in place, because when
a requirement changed and who agreed to it is worth more than a tidy thread.

Two properties are load-bearing, and both rule out the obvious cheaper signals:

- **Content, not history.** The branch is rebased before G4 and again before G7 (ADR-1003), so
  a commit sha recorded at approval is orphaned by the time CI clones the branch. A comment
  timestamp fails differently: a rebase rewrites committer dates and an amend preserves author
  dates, so a post-approval edit can carry a pre-approval date.
- **Relative paths.** `/opsx:archive` moves the folder to
  `openspec/changes/archive/<date>-<id>/`, which git records as a pure rename — verified on
  `chore(archive): add-weekday-set-schedule`, R100 on all five files. Hashing paths from the
  repository root would fail every Story at its archive commit, the last one before the merge.

**`tasks.md` is outside the signature**, because ticking boxes is the one thing `implementer`
may legitimately write in the change folder (`docs/process.md` §6).

`pnpm run status` reports a stale approval as a stop of its own, owned by the human, so the
conductor finds out at the gate rather than at the merge.

## Consequences

- **The marker now records a decision about specific text.** "A human was asked at some point"
  becomes "a human approved this delta", checked mechanically.
- **What it still cannot prove is who decided.** That residue is ADR-0014's and is untouched
  here; nothing in a GitHub comment separates the owner's fingers from the owner's token. This
  narrows the second failure — approval drift — not the first.
- **Editing a change folder after approval now costs a second gate stop.** That is the point,
  and it is a real cost at 4–8 hours a week: a typo fixed in `proposal.md` after G4 needs
  re-approval like a rewritten scenario does. The digest cannot tell the two apart, and a
  signature with exceptions is not one.
- **Adding a task after approval stays invisible.** A task list is a work plan; the
  requirements are in the delta.
- **Markers in ADR-0014's form no longer pass.** Check 5 names them specifically and asks for a
  re-record rather than reporting a missing approval. Exactly one Story is affected, #9.
- Rejected: **the spec PR merged before implementation.** Beyond buying no authenticity, it
  costs a second branch kind through `parseBranch`, `status.ts` and the graph; a rework of the
  four checks that assert a Story is *finished*, which a non-draft spec PR would fail on the
  day it opens — the red-by-construction build ADR-1003 rejected; an active change folder
  sitting on `main` between the two PRs, which is what check 3's single-change rule reads as a
  second Story; and two rebases and two CI cycles per Story. ADR-0004 weighed a second PR for
  the archive and rejected it as disproportionate at one concurrent Story; the same arithmetic
  applies, for a smaller gain.
- Rejected: **a `G7:` marker on the same pattern.** Status already declines to invent one
  (ADR-1002). G4 is the gate worth a machine-readable signature.
