## Context

`proposal.md` § *Why* says what this is for, `grill.md`'s four settled answers are what the delta is
written on, and the four commitment surveys under `docs/research/2026-09-09-concise-specs/` are what
it is written from; `tasks.md` § 1 says which survey covers which requirement. They trace the prose
to the ADR register, to change history that belongs nowhere, and to eleven pieces of rationale with
no home at all. Measured here: `openspec/specs/commitment/spec.md` is 5,896 lines — 41 requirements,
406 scenarios, 26,522 words of requirement prose, every one of the 41 over the 150-word budget, and
all 406 scenarios `WHEN`/`THEN`/`AND` bullets carrying no prose, each naming a test passing today.

## Goals / Non-Goals

**Goals:** every *Rules at risk* sentence stated once as a SHALL/MUST sentence where it belongs;
every requirement inside the 40–150 word budget or named below as over it; every piece of rationale
with no ADR home homed first. **Non-Goals:** no scenario added, renamed, merged or dropped and no
body touched; no behaviour change, no test change, nothing under `src/`; no other capability.

## Decisions

### The seam

**None, and that is what this Story is.** ADR-1047 decision 2: an editorial Story's delta rewrites
prose, changes no behaviour and changes no test, so there is no new or changed member for an
acceptance test to attach to and rule 3's red-green loop is moot. `docs/process.md` § 9's DoR asks
for a seam **or** for `design.md` to state that no test changes and why, which is this paragraph.
Every scenario in the delta is already driven at a seam that ships — `Commitment`, `Roster`,
`RosterStore` and `CommitmentsScreen` — by a test carrying its title verbatim, and all go on passing
untouched. Fidelity is judged against the *Rules at risk* lists instead: a box per requirement in
`tasks.md`, and `reviewer`'s second axis at G7.

### Every rule survives as a sentence, and this Story adds no scenario

Grill answer 1. The twenty-seven rules the surveys find with no scenario stay as bare SHALL/MUST
sentences rather than being deleted or tested: deleting one changes behaviour by omission, and
writing a scenario adds a test, which an editorial Story may not do. The twenty-two testable today
are listed under § *Open Questions*. The other five are not untested in the sense a want means: two
are asserted by a scenario in a neighbouring requirement, one is an exclusion clause, one is
untestable at its seam, and one — *no requirement identifies a refusal by its position among the
seven kinds* — is a rule about how this spec is written, kept deliberately and half of ADR-1049.

### Rationale is homed before the prose carrying it is deleted

Grill answer 2. Rationale an ADR already records is deleted. Of the eleven pieces with no home, two
are dropped and nine are homed first, as four one-paragraph amendments and one new record.

- **ADR-1048** — why the aggregate earliest-day question is the roster's, which it consumes unsaid.
- **ADR-1046** — half a range is its own refusal; a value the chosen kind cannot hold is ignored.
- **ADR-1038** — three: categories in use are offered rather than case-folded; the store never writes
  the groups, that record's grouping rule reaching storage; a change touching both places is one act,
  because 1038 says what one act on a roster is, where ADR-1035 decides a state rather than an act.
- **ADR-1035** — an unreadable store is refused, not read as empty: its Context already argues that a
  roster reading as holding nothing is a first launch to whatever writes day one.
- **ADR-1049**, new — the record place is written first, and no requirement numbers a refusal kind.
  Grill answer 2 fixes its scope at those two, which is why *one act* went to ADR-1038 instead.
- Dropped — the unmeasured "would double the structure of the screen", and refuse-rather-than-adjust,
  whose MUST NOT sentences survive with no argument.

### One requirement splits, and REMOVED plus ADDED is the mechanism

Grill answer 3. *A commitments screen changes a commitment on either of its lists* is 1,622 words
over 21 scenarios and is the only requirement any survey gives a division for — which act a change
performs, against what a change is refused for. It becomes one `## REMOVED Requirements` heading with
a Reason and a Migration and two `## ADDED Requirements`, every scenario title carried verbatim to
the half it belongs to; ADR-1047 records that shape as accepted by `openspec validate --strict` and
by the archiver. *A roster store keeps a roster at a place* (1,123 words, 35 scenarios) and *A roster
refuses a commitment it already holds* (1,464 words, 17) are **not** split: no survey proposes a
division, and inventing one nobody has designed is not this Story's. They stay single and over
budget, named below with the rest.

### Every scenario title stands, including the two that are false

Grill answer 4. Titles are contracts a CI check reads, so none changes. That keeps *two commitments
alike in name and not in rhythm are two entries a person cannot tell apart* and *a commitment stopped
through a commitments screen is kept until the day the screen was handed*, which ADR-1047 decision 5
already records as false by title text. The bookkeeping paragraphs admitting it are rationale this
delta deletes; ADR-1047 needs no amendment, because this Story adds no third.

### Overruns the budget

Requirement prose goes from 26,522 words to 11,426, and **thirty-one requirements are still over
150**, because rule 1 — every *Rules at risk* sentence present as its own SHALL/MUST — outranks the
word cap; a finding only where a sentence is rationale rather than a rule. This list and the
twenty-two below are why `check:budgets` reports this file at 167 lines against 150: naming all
fifty-three entries costs that, and dropping one of them would be the worse failure.

- *A roster holds the commitments a person keeps, in the order they were taken on* — 630; five rule families with five at-risk sentences among them, and no survey proposes a division.
- *A commitments screen defines a commitment from a name, a rhythm and the day it is kept from* — 563; fifteen rules over eighteen scenarios, two unshortenable: both digit bounds in one sentence, and ignore-rather-than-refuse stated for all three kinds because *refuses a range that is not a range* defers to it.
- *A roster refuses a commitment it already holds* — 530; grill answer 3, stays single: it owns the equality rule, both forms of the category ask and the take-up-again rule, and two later requirements defer to it.
- *A roster store keeps a roster at a place, across the app being closed and opened again* — 518; grill answer 3, stays single: write-before-report, report-what-the-roster-reports, four persistence rules and store independence, over thirty-five scenarios.
- *A commitments screen works out which act a change on either of its lists needs* — 445; three acts and the order they combine in, the interval grid, the write order, the kind, the category and the no-op — the larger half of the only split.
- *A roster moves a group among the groups it is keeping* — 432; two landing anchors measured differently on purpose, the past-date price of the first, the carve-out, what the offset counts, two refusals and the no-change guarantees.
- *A roster store reads a roster kept before a commitment carried a kind* — 394; three earlier forms read three ways, the write-only-on-change rule, and form-agreement in both directions for two fields.
- *A commitments screen moves a commitment among the ones it keeps* — 359; a second arithmetic turning a place inside a group into a place in the roster's order, with both bounds on the offset, four asks that do nothing, and one refusal.
- *A roster puts a commitment under a category* — 359; a category's identity rules, three MUST NOTs against any list of categories, its persistence across the three states, one refusal and the accepted no-op.
- *A commitments screen moves a group among the groups it draws* — 351; the offset shared with the roster, the stopped list's reorder, the past-date price read back through the place it keeps, three asks that do nothing and one refusal.
- *A commitments screen holds the change it refused and why, one at a time* — 350; the eleven-item no-change enumeration is the rule and every item a distinct case, and the no-numbering rule that binds the rest of the spec is stated only here.
- *A roster removes a commitment it holds, and never lets it go* — 341; eleven scenarios, the kept-until rule both ways, two refusals, value semantics, and a not-the-same-roster sentence of forty-four words no scenario proves another way.
- *A roster stops keeping a commitment, on the day it was kept until* — 339; the stop, three refusals with the day-standing rule, accept-any-date and leaves-the-record-alone, across nine scenarios.
- *A commitments screen refuses a range that is not a range, and a target that is not a target* — 333; two refusal families of three causes each, three exclusions and four acceptance bounds.
- *A roster moves a commitment among the ones it keeps* — 329; the offset's placement arithmetic, the two offsets that hold the sequence still but not the category, two refusals and the no-date guarantees, over sixteen scenarios.
- *A commitments screen removes a commitment only when its name is typed back* — 328; seventeen scenarios over the confirmation slot, the matching rule, three reset points, does-nothing-unless-match and two kept-until day rules.
- *A roster answers which commitments it had not stopped keeping on a calendar date* — 295; the membership rule, the order rule, the take-up-again effect on past dates, and five MUST NOTs on what may not enter the answer.
- *A roster reads the commitments it is keeping in groups, one per category* — 286; the group order, three MUST NOTs against inventing another, the agreement between grouped and flat reads, and the same reading over a date.
- *A commitments screen lists the commitments its roster keeps, in the order they were taken on* — 281; twelve scenarios over two subjects, where each group sits and what an entry may say, neither implying the other.
- *A commitments screen asks you to confirm before it stops keeping a commitment* — 275; eleven scenarios over the confirmation slot, the day-before rule, the calendar-floor case and two refusal paths.
- *A roster supersedes a commitment it is keeping with another, from a day* — 272; a three-part act, two refusals, the date rules including both supported bounds, and the no-link rule.
- *A commitments screen refuses a change it cannot make* — 271; five refusals it inherits, two of its own, and the interval boundary that is accepted rather than refused.
- *What a commitments screen holds about a refused change lasts until the app is shown again or a change is kept* — 252; seven change kinds and five no-op cases, each an enumerated item of the rule, plus the record-place rule no scenario asserts.
- *A commitments screen says what a commitment it is asked to change is made of* — 219; four things said, the interval carve-out, changeability, and the kind with what it carries.
- *A roster changes a commitment it holds for another, in the place it holds it* — 210; the replacement guarantees, two refusals, the change-for-itself case and value semantics.
- *A commitments screen offers the categories in use* — 186; five rules on what is offered, plus the two MUST NOTs on case.
- *A roster answers the earliest day anything it holds has been kept from* — 179; eight rules, three of them with no scenario, and nothing that can be said in fewer words.
- *A commitment is a name, a schedule, and the day it is kept from* — 165; the four parts, three MUST NOTs on forming one, and equality across all four including what the kind carries.
- *A roster store that cannot be read is refused rather than emptied* — 165; three unreadable cases plus the half-a-range case each carry a scenario, and refuse-rather-than-empty is three MUST NOTs.
- *A commitment's kind is a tick, a number, a note or a total* — 163; four kinds, per-kind parameters, the two belonging rules, the formed-at-all rule, the default and the due-ness exclusion.
- *A range is a lowest and a highest, and the lowest is not above the highest* — 158; both-ends-required, inclusivity, refuse-not-adjust, where the refusal is made, and the not-a-number end.

## Risks / Trade-offs

- **A dropped rule is invisible to every check**: the tests pass whatever the prose says, so only a
  reader catches a rule that went out with its paragraph. → One `tasks.md` box per requirement, read
  against the surveys — which are not infallible: two of their claims failed against the current
  file and were not carried.
- **A cross-reference that names a count falsifies itself**, the seven refusal kinds being the live
  case. → Stated in one requirement, recorded in ADR-1049, named rather than numbered elsewhere.
- **A rule stated once and deferred to from elsewhere can be deleted twice**, because a
  per-requirement trim reads each copy as the other's restatement. → Named in both boxes.
- **One requirement contradicted itself, and the rewrite chose.** *A commitments screen says what a
  commitment it is asked to change is made of* said both that every control the form draws is present
  with the unchangeable ones refusing a touch, and, four lines on, that what a form draws and which of
  its fields a thumb reaches are the drawing's. → The control rule is kept, being a *Rules at risk*
  sentence grill answer 1 protects. The other is **dropped and homed nowhere**: a scope exclusion with
  no scenario, which the surveys class as cross-reference rather than rule and `openspec/config.yaml`
  keeps out of requirement prose. ADR-1022 and *holds no words a person reads* cover the words only,
  so the kept rule is now this capability's one word on a form's controls, and it is untested.

## Open Questions

**Twenty-two rules stay knowingly untested**, each kept as a SHALL/MUST sentence with no scenario:

- the kept-from floor does not shift the schedule's own start date or phase
- neither a changed nor a superseded commitment gains a fifth part
- a duplicate target is compared by whole value exactly as a duplicate range is
- a roster store does not write its commitments grouped by category
- a change of commitment reaches the record place, and a roster store is not what reaches it
- a commitment the screen already holds offers no kind at all to a change
- a range end or a target holds no more than thirty-eight significant digits
- an end holding only a zero-width space is refused as not a number, never as blank
- changing another commitment's fields into a duplicate of this one is refused
- ending what is held is one act, however many places the change touched
- a change asked about a commitment on neither list is a no-op rather than a refusal
- neither stopping nor removing raises the earliest day, and taking one up again does not lower it
- the earliest day consults no present moment, no time zone and no locale
- a commitment reads back its name and its kind and never the day it is kept from
- a supersession is supported on the very first and the very last supported date
- every control a change form draws is present, and the ones that cannot change refuse a touch
- the record place is written before the roster place
- where nothing is carried over, nothing at all is written at the record place
- the already-holds-it refusal covers the record place as well as the roster place
- the roster holds no link between a superseded commitment and the one that replaces it
- a number commitment with both range ends blank is a number with no range, not a refusal
- a group landing after the last category's last commitment lands there whatever state that one is in

**One want captures all twenty-two**, filed on the backlog branch after G4: *cover the commitment
rules the condensing surveys found testable but untested, with a scenario each* — its id assigned on
filing. Nothing else is open: `grill.md` § *Left open* is "None." and no residual round arose here.
