## Context

See `proposal.md` § *Why* for the motivation and `grill.md` for the fourteen answers this is
written on. What matters here is the shape of the code the delta lands in.

`CommitmentsScreen` already carries two ways to set the category a commitment is under.
`put(_:under:)` (`CommitmentsScreen.swift:567`) is the older one, reached from the *Category* swipe
button on the kept list. `change(_:toName:on:keptFrom:under:)` (`:253`) is the newer, from
`add-commitment-editing` (#148): the category is one of the four things a change is made of, the
change sheet draws it as a field with *Already in use* under it, and a category-only change falls
straight through to `rosterStore.change(commitment, to: commitment, under: category)` (`:341`).
Both write the same value at the same place and both read `categoriesInUse` for what to offer.

Withdrawing the *Category* swipe therefore removes the only caller of `put`, and that is what makes
this a Story rather than a chore: everything else B-042 asks for is drawing.

Two facts about the tools shaped the delta more than anything in the code, and both were measured on
this branch rather than remembered:

- **`openspec` 1.10.0 refuses to drop a scenario through `MODIFIED`.** `findMissingCurrentScenarios`
  compares the incoming block against the current spec by scenario title and errors at both
  `validate --strict` and `archive` — "a MODIFIED requirement replaces the whole block, so archive
  refuses to drop them". The only supported way to lose a scenario is to remove the whole
  requirement, which is why the category requirement is `REMOVED` and re-landed as `ADDED` while the
  other three are `MODIFIED`.
- **The kit suite is 1015 tests** on this branch (`swift test` from `src/DayByDayKit`, 2026-09-10),
  and `pnpm run check:scenarios` reports **`86/88`** before a line is written — 78 of the delta's 88
  scenarios are restated unchanged and already have passing tests, and eight more keep their titles
  while changing underneath. **That check therefore proves nothing about eight of the ten scenarios
  this Story actually moves**, since a rewritten scenario keeps its title and so reads as covered by
  the test that has not been rewritten yet. Only the two new ones show as missing, and `tasks.md`
  names all ten by hand for that reason.

## Goals / Non-Goals

**Goals:**

- No requirement on the commitments screen names an act no gesture can reach.
- No guarantee `put`'s scenarios were the only ones asserting is lost — each one is either retargeted
  at the act that now performs it, re-landed under a name that says which act made it, or already
  answered by a scenario that exists.
- The withdrawal does not falsify a requirement or an archived change folder that counted the kinds
  of refused change.

**Non-Goals:**

- **The visible rework carries no requirement.** Which edge holds which icon, what a full swipe
  does, the tints, the row tap, the reorder toggle — none of it is specified here. See § *The shell
  rides this Story*.
- The kit below the seam. `Roster` and `RosterStore` are untouched — § *The kit below the seam
  keeps its `put`*.
- `docs/backlog.md`. B-041's *Principle* line is weakened by this Story and B-042 is delivered by
  it, but that file lives on `chore/backlog` and editing it from a Story branch invites the rebase
  conflict rule 5 calls a stop (`grill.md` § *Settled* 13, 14).

## Decisions

### The seam

**`CommitmentsScreen`**, in `src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift`. It is the
existing seam for every commitments-screen requirement and no new one is introduced — an existing
seam beats a new one, and this Story only takes surface off this one.

Removed from it: `put(_:under:)` and the `RefusedChange.categorising` case. Everything else stays,
including `categoriesInUse`, which the change sheet reads and which the `ADDED` requirement is
about. Every acceptance test in this delta drives `CommitmentsScreen` directly, as the existing ones
in `CommitmentsScreenTests.swift` already do; nothing here needs a process, a simulator or a
captured stream.

### The delta is the category split alone

A grep across `openspec/specs/` for *swipe*, *icon*, *edit mode*, `EditButton` or `systemName`
returns nothing: these specs are seam-level throughout, and ADR-1022's line — what a screen draws is
the drawing's — is the same one that kept *Move up* / *Move down* out of the spec at #168. So the
seven requirements in this delta are the whole of it, and the red-green cycles come only from them.

### Naming a kind rather than numbering it

`grill.md` § *Settled* 3 left this open as the one place the delta could quietly falsify a record,
and it is answered rather than deferred.

The kinds of refused change were numbered in three places and cited by ordinal in a fourth. *A
commitments screen holds the change it refused* enumerated **eight**; *moves a commitment* calls its
own the **fifth**; *puts a commitment under a category* called its own the **sixth**; *moves a group*
called its own the **seventh**; and `CONTEXT.md` plus four archived change folders cite those
numbers. Withdrawing the sixth renumbers the seventh and the eighth. Renumbering the live spec makes
every archived citation read wrong; not renumbering leaves the group move calling itself the seventh
of seven, beside a kind that no longer exists.

**The answer is to stop numbering.** The enumeration in *A commitments screen holds the change it
refused* becomes the only place a count lives, and a requirement that introduces a kind names it
instead of fixing it at a position. The rule is written into that requirement, so the next
withdrawal costs nothing, and it draws one line explicitly: **a statement about the kinds that came
*before* a kind is not a position.** That is why *A commitments screen moves a commitment among the
ones it keeps* is not in this delta — its "the **fifth** kind … beside defining a commitment,
stopping keeping one, taking one up again and removing one" names the four before it, all four go on
existing, and nothing withdrawn later can make it untrue. Restating 267 unchanged lines to delete
one word would be a worse diff at G4 than the word, and the word is not wrong.

The archived folders keep their ordinals and stay true records of the specs they were written
against. Nothing in the live spec claims to continue their numbering.

**Alternative rejected: keep the numbers as labels that are never reused**, so the kinds run 1–5, 7,
8 with a hole where the sixth was, exactly as ADR numbers do. It makes every archived citation
permanently correct and costs no renumbering. Rejected because "the eighth kind" in a spec that has
seven of them is a sentence a reader has to be told about, and this spec is read by cold agents who
will not be.

### Every scenario that reaches a category through the withdrawn act

Ten scenarios across six requirements reach a category through `CommitmentsScreen.put`. The sweep
that found them is a parse of `openspec/specs/*/spec.md` for a scenario whose body says *put … under
… through it* or *through the screen*, cross-checked against every `screen.put(` in
`CommitmentsScreenTests.swift`; both sides agree on the same ten, and the four further hits under *A
roster store keeps a roster at a place* and *A roster store reads a roster kept before a commitment
carried a kind* are the **store's** `put`, which is untouched.

Four go with the requirement that is removed. Six are retargeted at a change and keep their titles,
because each title stays true when the act underneath it changes: *a category no longer under any
commitment kept is no longer offered*, *a commitments screen does not fold the case of a category it
is given*, *a commitment given a category is drawn in that group and returns when the category is
taken off*, *a commitments screen that cannot read its roster does nothing when it is asked to put a
commitment under a category*, and the two under *What a commitments screen holds about a refused
change lasts…*. Two more keep their titles for the same reason under the refused-change requirement
— *holds a refused category change against the commitment it was asked about* and *holds nothing
against a category change that asks for no change at all*.

**One of those titles is a blemish and it is knowingly left.** *…when it is asked to put a commitment
under a category* names the withdrawn act; after this Story the screen is asked to *change*. It
cannot be dropped, because `openspec` refuses to drop a scenario from a requirement that survives,
and the only way to drop one is to remove the whole requirement and re-add it under a different name
— which would mean renaming *A commitments screen that cannot read its roster lists nothing and
changes nothing*, a name that is exactly right, to satisfy a tool. The title reads as the person's
ask ("file this under Sport") rather than as the screen's method, the body says which act carries it,
and the guarantee it proves — every act on an unreadable-roster screen is a silent no-op that writes
no bytes — is the one that matters. Renaming the requirement is the worse trade.

### The two scenarios the split would otherwise drop

`put`'s nine scenarios do not all have a home after the withdrawal, and two of them assert something
nothing else does. **No scenario in *A commitments screen changes a commitment on either of its
lists* passes a category at all except the one that asserts a no-op**, and only one test in the whole
suite passes a non-`nil` category to `change` (`CommitmentsScreenTests.swift:4885`). So a category
*set* through a change, and a category *taken off* through one, are guarantees with no screen-level
scenario the moment `put` goes.

They are re-landed on the change requirement, under names that say which act made them, and that
requirement gains one paragraph saying it is now the only act on this screen that writes a category
**without a move**. Not the only act that writes one: *A commitments screen moves a commitment among
the ones it keeps* puts a dropped row under the group's category by the same gesture, and this delta
leaves that requirement alone. The other two withdrawn scenarios are answered where they stand:
*asked to put a commitment it does not keep* by *a commitments screen asked to change a commitment
on neither of its lists does nothing and says nothing*, and *a category change it could not keep* by
*a change a commitments screen could not keep leaves both places as they were* together with the
rewritten *holds a refused category change against the commitment it was asked about*.

Two scenarios keep their titles and get new bodies, because the title stays true while the act
underneath it changes: *a category no longer under any commitment kept is no longer offered* and *a
commitments screen does not fold the case of a category it is given*. The second is why the `ADDED`
requirement keeps a case clause of its own — a screen that folded case would offer one word where a
person has two, and that is an offering rule, not a writing rule.

### The kit below the seam keeps its `put`

`Roster.put(_:under:)` and `RosterStore.put(_:under:)` stay, with their requirements and their
tests, and this is read out of the spec rather than chosen. *A roster store keeps a roster at a
place* says in as many words that **"a roster store SHALL report exactly what the roster reports"**
and enumerates a store act per roster act; withdrawing the store's `put` while the roster keeps its
own would break the mirror that requirement is built on. `Roster.put` also still has a live caller —
`RosterDocument.swift:59` uses it to rebuild a roster's categories when one is read back off disk.

The defect B-042 names is a **screen** requirement no gesture can reach. A roster is a value with a
contract, not a menu, and its acts were never reached by a gesture directly. That is the line, and
it is drawn once here rather than argued again per method.

### Why the delta is 1,339 lines for a small change

`MODIFIED` replaces the whole requirement block, so five requirements are restated in full — four of
them for a single scenario body each. **`git diff` on the delta file is not a guide to what changes.**
Run this from the repo root to see only the real edits, requirement by requirement:

```bash
python3 - <<'EOF'
import re, difflib
live = open("openspec/specs/commitment/spec.md").read()
delta = open("openspec/changes/rework-commitment-row-actions/specs/commitment/spec.md").read()
delta = delta[:delta.index("## REMOVED Requirements")]
def block(title, text):
    i = text.index(f"### Requirement: {title}\n")
    n = text.find("\n### Requirement: ", i + 1)
    return (text[i:] if n == -1 else text[i:n]).rstrip("\n").splitlines()
for title in re.findall(r"(?m)^### Requirement: (.*)$", delta):
    if f"### Requirement: {title}\n" not in live:
        print(f"===== ADDED: {title}\n"); continue
    print(f"===== {title}")
    print("\n".join(list(difflib.unified_diff(block(title, live), block(title, delta),
                                               lineterm="", n=0))[2:]))
EOF
```

It prints six paragraph-sized hunks and the one `ADDED` requirement. The `REMOVED` block carries the
whole of what is lost, in prose, and is the part worth reading closely.

### The shell rides this Story

None of this is specified and all of it is walked on the phone (`pnpm run phone`) before the review.
It is written down here because `tasks.md` has to name it and because the owner decided each of
these against a recommendation, so a later reader should not read them as defaults:

- **Leading edge: Edit, `pencil`, accent tint — and the row tap is removed.** Both lists.
  `.contentShape(Rectangle())` and `.onTapGesture` come off, so the swipe is the only door to the
  change sheet. One action on that edge, so a full swipe opens the sheet unambiguously; the sheet is
  cancellable and writes nothing on its own. `grill.md` § *Settled* 4, 7.
- **Trailing edge: Stop-or-Resume outermost, Remove inboard.** `stop.circle` orange on the kept
  list, `play.circle` green on the stopped one, `trash` red on both. A full swipe therefore stops
  rather than removes — the outermost action is the one a full swipe performs, and that should be
  the frequent reversible act. Remove keeps its typed-name sheet. `grill.md` § *Settled* 6, 9.
  **Which button ends up outermost is a fact about `swipeActions` and not about this document**:
  today's code already declares *Stop* before *Remove*, so the expected outcome is that nothing
  moves — confirm it on the phone rather than trusting the declaration order, and report a
  difference rather than reordering around it.
- **The mode becomes `arrow.up.arrow.down`**, a toggle that shows itself selected while on, in place
  of `EditButton()` and the word *Edit*. It keeps both things it holds — the row drag handles and
  the per-section *Move up* / *Move down* buttons — because both are reordering, which is what makes
  the rename honest. Its accessibility label carries *Reorder* and its state. `grill.md` § *Settled*
  10.
- **The category sheet goes**, with `categorising`, `categoryTyped` and the `.categorising` refusal
  line. `categoriesInUse` keeps its two callers in `CommitmentSheet`.
- **All five symbols were verified present from iOS 13** in the installed iOS 26.5 CoreGlyphs
  catalogue at the grill. DayByDayKit's floor is iOS 17 and the app target's is iOS 26, so no
  availability guard is needed. `pause.circle` was refused deliberately: `CONTEXT.md` says a
  commitment has "no state that can be paused or archived", and **stopping keeping** is the person's
  own verb.
- **Nothing on the screen depicts the swipe, and that is accepted.** This is the one decision that
  earns a record, because ADR-1042 declined exactly this for the day screen. See below.

### `CONTEXT.md` and the ADR

**Both landed in the propose commit rather than being left to the implementer**, because the grill
put the `CONTEXT.md` amendment on `spec-author` by name and because the ADR is a decision the human
is signing at G4 rather than one discovered while building. Neither is inside the G4 digest, which
covers the change folder alone, so a later correction costs no second approval — but a correction
after G4 is a finding, and `tasks.md` § 6 says so.

`CONTEXT.md` carries the clause *"refiling across groups is the row's Category action"* **twice** —
under § *Move* (the 2026-09-08 correction) and under § *Commitments screen* (the second 2026-09-08
correction, which adds "offered on the kept list beside *Stop* and *Remove*"). Both are false after
this Story. The grill named § *Move*; the second is the same clause and is corrected with it, as a
fact rather than a widening of scope. Both are appended as dated corrections rather than edited in
place, which is what every other amendment in that file does. § *Commitments screen* also states the
**seventh** and **eighth** ordinals, and the same amendment withdraws them.

**No new term is landed.** This Story changes what a person can *do* and adds no domain vocabulary;
every act it touches already has its word (`grill.md` § *Terms landed in CONTEXT.md*).

**ADR-1042 is amended in place** rather than superseded (ADR-1020), and no new ADR is written. The
amendment draws a line the original did not: **whether a screen depicts its swipe is decided per
screen**, and the sentence "a gesture nothing on the screen depicts is a gesture a person has to be
told about" is why the chevrons stay on the day screen rather than a rule the product carries
everywhere.
ADR-1042 owns the question "who owns the horizontal swipe on a screen, and is the gesture depicted",
and it answers it for the day screen with "the chevrons stay, because a gesture nothing on the
screen depicts is a gesture a person has to be told about". The commitments screen now goes the
other way on the second half, and the reason the two differ — moving days is the constant act of
every visit, these four are occasional, and a list row that swipes is the most universal idiom iOS
has — belongs in the record that made the claim, not in a second record that partly contradicts it.
The requirement removal gets no ADR: #148 deleted this repository's first `REMOVED` requirement and
recorded it in `design.md`, and that precedent holds (`grill.md` § *Settled* 12).

## Risks / Trade-offs

- **A stopped commitment's category becomes changeable, which `put` always refused.** → Accepted
  knowingly at `grill.md` § *Settled* 1. The change sheet has allowed it since #148 and *A
  commitments screen changes a commitment on either of its lists* already specifies it ("changed in
  name and category only"); this Story removes the act that refused it, so the two stop disagreeing.
  The roster still refuses `put` on a stopped commitment, and that requirement is untouched.
- **`RosterStore.put(_:under:)` has no caller in the app after this.** → Kept deliberately, for the
  mirror reason above. If a later Story finds it genuinely dead, withdrawing it is a delta on the
  roster-store requirement and is cheap; withdrawing it here would break a stated mirror to save
  nothing.
- **Setting a category is now three or four taps where it was two.** → The owner's own decision,
  made after walking the screen (B-042: "Category as a swipe action is really not needed anymore, it
  can be done with the edit"). Recorded because it reverses a decision taken hours earlier at #148's
  Q12, and the next pass should not read it as an oversight.
- **With the row tap removed, a person who does not find the swipe cannot open the change sheet at
  all.** → This is the sharpest edge in the Story and it is chosen: the owner took the tap away so
  the swipe is the only door (`grill.md` § *Settled* 4, against the recommendation to leave the
  leading edge unclaimed). The mitigation is that the leading edge carries exactly one action, so a
  swipe in either direction reveals something, and the reversal is one line of `CommitmentsView`.
- **Four acceptance tests are deleted, eight are rewritten and two are added**, on a suite where the
  count is the regression check. → `tasks.md` names every one of them and states the expected count,
  **1015 → 1013**. A different number at the end is a stop, not a number to write down. The eight
  rewrites are the exposure: each keeps its title, so `pnpm run check:scenarios` reads them as
  covered whether or not they have been touched, and nothing but the compiler catches a missed one —
  which is exactly what deleting `put` at the end of § 4 is for.
- **`commitment` is the busiest capability in the repo.** `add-kind-to-commitments-screen` (#142)
  deltas it too and is deliberately serialised behind this Story. → A change under
  `openspec/specs/commitment/` landing on `main` while this branch is open is a stop (rule 5), and
  `tasks.md` § 1 carries the check.

## Open Questions

**None.** `grill.md` § *Left open* records none, and the one thing it deliberately did not decide —
how the refused-change ordinals are reworded without falsifying an archived folder — was handed to
this document to solve rather than left for anyone to answer; it is answered above under § *Naming a
kind rather than numbering it*. Nothing else surfaced while the delta was written that would change
the specs, the approach or the task breakdown: the two questions that came close, whether the kit's
own `put` follows the screen's out and where the two orphaned guarantees land, are both settled by
reading the spec and the tests rather than by a preference, and both are recorded above with the
fact each turns on.
