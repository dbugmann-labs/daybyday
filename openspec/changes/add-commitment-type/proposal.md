## Why

`schedule` (#6) can answer *is this rule due on this date* three ways, and there is nothing to ask
it about. A schedule with no commitment attached to it is a rule about nobody's gym: the day screen
(#27) cannot draw a row from one, because a row needs a name, and no tick can be recorded against
one, because a tick is recorded against a thing rather than against a rule. `commitment` (#26) is
the capability that supplies the missing half, and this Story is the whole of it — the Feature has
exactly one Story, so what lands here is what a commitment is.

It is a small type and a short delta, and that is the point of doing it before the day screen rather
than inside it. Three of the four Stories in `schedule` wrote the phrase *"a commitment whose
schedule is …"* into normative prose without anything in the repository being one. This change makes
the word real, and fixes the two things every screen after it will assume: that a commitment is
**exactly** a name and a schedule, and that its due-ness is **exactly** its schedule's answer with
nothing added.

Two questions in it were not the agent's to close, and both are live as a **question round** in
`design.md` § *Questions for you*: whether a commitment carries a date it begins to exist from, and
whether the name a person typed is stored verbatim or trimmed. The delta below is written on the
recommended answers to both.

## What Changes

- Creates the `commitment` capability with its first requirements: a commitment is a name and the
  schedule it runs on, and it is due on a calendar date exactly when that schedule is.
- **Fixes that a commitment carries nothing else.** No identifier of its own, no creation date, no
  position in a list, no paused or archived state, no tick history. Two commitments with the same
  name and the same schedule are the same commitment — which is the observable way of saying there
  is no hidden identity, and the thing that stops a `UUID` being added on reflex.
- **Fixes that due-ness is pure delegation.** A commitment adds nothing to its schedule's answer and
  takes nothing away, so the fourth rule shape (#11) and any shape after it are answered without a
  requirement changing here. The name never enters the rule.
- Makes a nameless commitment unrepresentable rather than a blank row: a name that is empty or made
  only of whitespace forms nothing, and — per the round's recommended answer — every other name is
  stored exactly as it was given, with no trimming and no length, script or emoji restriction.
- Adds one public type to `DayByDayKit` beside `Schedule`. `Schedule.isDue(on:)` does not move, does
  not change signature, and gains nothing; this change adds the package's second seam rather than
  widening the first.
- **Not in this change:** the weekly quota (#11); ticking, and anything that reads a tick; a list of
  commitments, their order, or uniqueness among them; editing, pausing, archiving or deleting one;
  storage and the SwiftData/GRDB question `docs/parking-lot.md` still holds open; reading a
  schedule back out of a commitment to render it; anything on screen.

## Capabilities

### New Capabilities

- `commitment`: what a commitment is to DayByDay — a name and the schedule it runs on — and how it
  answers whether it is due on a calendar date.

### Modified Capabilities

None. `schedule`'s requirements are untouched: they are stated about schedules, and the prose in
them that already says *"a commitment whose schedule is …"* is describing the same relationship this
capability now defines from the other side. Nothing in `openspec/specs/schedule/spec.md` needs a word
changed, so CI check 2 has exactly one claimed capability.

## Impact

- **Code:** `src/DayByDayKit/Sources/DayByDayKit/` only. One new file, `Commitment.swift`, holding one
  public struct. No change to `Schedule`, `CalendarDate`, `DayOfMonth`, `DayInterval` or `Weekday`, no
  change to `Package.swift`, no new dependency in either language.
- **Specs:** creates `openspec/specs/commitment/spec.md` at archive time, and touches nothing else.
- **Tests:** thirteen acceptance tests in a new `Tests/DayByDayKitTests/CommitmentTests.swift`, one
  per scenario, taken one at a time. The existing forty-five tests are untouched and must stay green.
- **`docs/parking-lot.md`:** the read-back asymmetry entry of 2026-08-31 grows a third case — a
  `Commitment` does not give its `Schedule` back, for the same reason `DayOfMonth` does not give its
  day back, and the first Story that renders a rule on screen widens all of them in one delta. This
  change does not write there; `spec-author` may not, so it is flagged here for whoever does.
- **No ADR, on the recommended answers.** What a commitment holds is a model decision, but it is a
  cheap one to reverse in the direction it would actually move: adding a field later is a delta and
  a migration on storage that does not exist yet. The expensive decision underneath — that due-ness
  is a pure function of a calendar date — is already ADR-1004, and this change obeys it rather than
  revisiting it. **If question 1 comes back the other way**, that changes: a commitment carrying a
  date it exists from is a second anchor in the model, it interacts with the every-N-days start date,
  and it should be written up as an ADR taking the next free number in `docs/adr/` (1010 when this
  was written — read the directory rather than trusting that figure).
