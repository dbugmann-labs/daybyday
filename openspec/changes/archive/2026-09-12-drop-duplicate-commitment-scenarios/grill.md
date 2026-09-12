# Grill — drop-duplicate-commitment-scenarios

*7 questions over 3 rounds, 2026-09-12. The spec is `openspec/specs/commitment/spec.md` at `6294081`
— 42 requirements, 406 scenarios, 4,823 lines. Line numbers are that commit's; **re-anchor by
title**, and locate a test by its **function name** rather than its span, because every span shifts
as soon as anything above it is deleted. `CT` is `CommitmentTests.swift`, `RT` `RosterTests.swift`,
`RST` `RosterStoreTests.swift`, `CST` `CommitmentsScreenTests.swift`, all under
`src/DayByDayKit/Tests/DayByDayKitTests/`; bare `file:line` is under
`src/DayByDayKit/Sources/DayByDayKit/`. Every verdict below comes from **four independent read-only
passes** — one over the four surveys' candidates, one walking all 42 requirements, one confirming
both, and one re-testing the three cases that were still arguable. 48 mutations in total, each
against a scratch tree built with `git archive HEAD`, never in a worktree. The whole-suite baseline,
measured separately by all four, is **1010 tests passing**.*

## Settled

1. **Settled before the grill, by the Story's brief, and recorded here so this folder carries it.**
   ADR-1047 decision 6's four conditions decide what is droppable. Each dropped scenario's test is
   deleted in this PR and no test is added. Every requirement that loses a scenario is REMOVED and
   ADDED under a new heading, **reworded as little as keeps it true and distinct**, with old → new
   listed side by side in `design.md`; in-spec cross-references follow in the same delta. Quotes in
   `docs/backlog.md` are updated on `chore/backlog` after the archive, never in this PR.
2. **Eight scenarios are dropped, 406 → 398**, each against one keeper under the same requirement.
   The test named for each is deleted, and the `@Test` count in `DayByDayKitTests` falls
   **1010 → 1002**. No dropped test is a UI test, and **no kept test is edited** — see item 10.
   - *A commitment's kind is a tick, a number, a note or a total*:
     - `a commitment reads back the kind it was given` (`CT.aCommitmentReadsBackTheKindItWasGiven`)
       → kept `a commitment of each of the four kinds is formed and reads its kind back`, which
       asserts the same read-back for all four kinds including the one dropped.
   - *A roster stops keeping a commitment, on the day it was kept until*:
     - `stopping a commitment a roster keeps says so and takes it out of the commitments read back`
       (`RT.stoppingACommitmentARosterKeepsSaysSoAndTakesItOutOfTheCommitmentsReadBack`) → kept
       `a commitment kept until a day before the day it is kept from is accepted`, **not** the
       obvious neighbour: `stopping one commitment leaves the others where they were` discards the
       return value (`_ = roster.retire(...)`), so naming it would split cover across two scenarios.
   - *A commitments screen lists the commitments its roster keeps, in the order they were taken on*:
     - `two commitments alike in name and not in rhythm are two entries a person cannot tell apart`
       (`CST.twoCommitmentsAlikeInNameAndNotInRhythmAreTwoEntriesAPersonCannotTellApart`) → kept
       `two commitments alike in name and not in rhythm are told apart by the rhythm their entries
       say`, an identical fixture and identical acts holding the same two `#expect`s plus two more.
       This retires the first of ADR-1047 decision 5's three false titles — item 8.
   - *A commitments screen takes a stopped commitment up again in one tap*:
     - `a commitment taken up again through a commitments screen is in the place it was taken on in`
       (`CST.aCommitmentTakenUpAgainThroughACommitmentsScreenIsInThePlaceItWasTakenOnIn`) → kept
       `a commitment taken up again through a commitments screen moves from what it has stopped to
       what it keeps`, which is the requirement's base case and asserts the place among its values.
   - *A commitments screen holds the change it refused and why, one at a time* — two:
     - `a commitments screen holds a refused stop against the commitment it was asked to stop`
       (`CST.aCommitmentsScreenHoldsARefusedStopAgainstTheCommitmentItWasAskedToStop`) → kept
       `a commitments screen refused twice holds only the change it was asked for last`, whose setup
       is a strict superset and whose `#expect`s are verbatim identical. Both values come from one
       unconditional pair of statements (`CommitmentsScreen.swift:567-568`); separating them needs a
       guard the source does not have, which was tried.
     - `a commitments screen that has been asked for no change holds no refused change`
       (`CST.aCommitmentsScreenThatHasBeenAskedForNoChangeHoldsNoRefusedChange`) → kept
       `a commitments screen holds nothing against a call that changes nothing at all`.
   - *A commitments screen moves a commitment among the ones it keeps*:
     - `a commitment dropped among another group's entries is put under that group's category`
       (`CST.aCommitmentDroppedAmongAnotherGroupsEntriesIsPutUnderThatGroupsCategory`) → kept
       `an offset a commitments screen is given is counted over the group a drop landed in and not
       over the roster's own order`, which holds both its `#expect`s byte for byte after the
       identical `screen.move(gym, toOffset: 1, under: "Supplements")`, plus the persistence through
       a re-opened store. Item 11 covers its backlog consequence.
   - *A commitments screen refuses a range that is not a range, and a target that is not a target*:
     - `a commitments screen refuses a range whose lowest is above its highest`
       (`CST.aCommitmentsScreenRefusesARangeWhoseLowestIsAboveItsHighest`) → kept `a range a
       commitments screen refuses is told apart from a target and from its other refusals`, which
       carries the **same fixture** (`lowest: "10"`, `highest: "1"`) and all three `#expect`s, so the
       "lowest above highest" way of failing is still exercised by a scenario that remains, and by a
       second one besides.
3. **Condition 1 is proven by mutation, and the discriminator goes into ADR-1047 decision 6.** The
   question is whether the divergence between a dropped test and its keeper reaches a **predicate on
   a statement both tests execute**. A disjunction or a boundary means the cover is not there; an
   unconditional statement, or a field the read path never reads, means it holds. Literal cover — the
   keeper's own `#expect` asserting the same value — is not by itself enough, and a claim resting on
   several guards is the failure #215 withdrew three drops for. *This is the method that caught item
   4's first case after three passes had confirmed it. Recorded in ADR-1047 rather than only here,
   unlike item 5, because it is how a condition is tested rather than a reading of one clause.*
4. **Three candidates that passed a full verification were then withdrawn**, and the spec keeps them:
   - `a commitment taken up again through a roster store is read back kept, in the place it was
     taken on in`. Two passes called it a drop against `a commitment taken up again through a roster
     store after being removed is read back kept`, and a third confirmed it; the tests' `#expect`s
     are character-for-character identical. `Roster.swift:135`'s predicate `keptUntil != nil` is true
     for two entry states, stopped and removed, and **each test pins one arm**: mutating it toward
     removed reddens the dropped test alone, and the complementary mutation reddens the keeper alone.
     Item 3's discriminator, and the #215 item 20 pattern exactly. *Its cost is named rather than
     hidden: the roster-store requirement then has no scenario driving stop-then-take-up-again, and
     fifteen tests elsewhere, under other requirements, still do. Keeping it means that requirement —
     the spec's largest at 35 scenarios — is not renamed at all.*
   - `a commitments screen refuses a target that is not above zero`, against the same told-apart
     keeper. `CommitmentKind.swift:29`'s `guard amount > 0` is a **boundary** and only the dropped
     test pins its below-zero side: `> 0` → `!= 0` reddens the dropped test and leaves the keeper
     green. Negative targets survive only under *A target is a number above zero*, a different
     requirement, so the cover is split off the requirement — condition 1, not condition 3.
   - `a roster store opened again holds its commitments in the order they were taken on` — item 5.
5. **Condition 2 is read by content, not by title.** A test counts as named for a prohibition when
   its assertions are what prove it, whether or not its title says so. That keeps `a roster store
   opened again holds its commitments in the order they were taken on`: its requirement states three
   MUST NOTs in one sentence (`spec.md:861-864` — "MUST NOT impose an order of its own, MUST NOT sort
   by name, by a day, by a category or by anything else") and this scenario's THEN, *"and not in
   alphabetical order"*, is the only text in all 35 of that requirement's scenarios that denies an
   order. Conditions 1, 3 and 4 all pass amply. *#211 item 11 narrowed condition 2 to a prohibition
   the requirement states as a MUST NOT, but its worked case had the prohibition in the title too, so
   this was open. The title-based reading was the alternative and would have made condition 2 vacuous
   here: no test in that requirement is named for the ordering MUST NOT. Left in this file rather than
   written into ADR-1047, deliberately — #199 box 15 is the last pruning Story, so nothing is
   scheduled to inherit it.*
6. **Condition 3: each item a requirement's prose enumerates is its own clause.** So a per-verb or
   per-refusal family cannot be pruned to one member. *Across eleven enumerations in seven
   requirements this bars 40 scenarios — every "verb fixture" cluster the surveys propose. The
   alternative reading, one clause with several values, was measured before it was refused: condition
   1 independently bars 39 of the 40, so it releases exactly one scenario, one member of the
   `stopping`/`removing a commitment leaves every earlier date answering as it did` pair, whose tests
   differ in one line and whose shared statement (`Roster.swift:459`) no mutation can separate because
   `commitments(on:)` never reads `isRemoved`. That one is kept. Condition 4 does **not** bar it —
   1583-01-01 is incidental there, and the keeper carries the identical fixture — so the blocking
   reading is the only thing keeping it, and the reading rests on the prose: R25's says the seven
   "are counted here and numbered nowhere else", R40's that "the three ways a range fails SHALL be one
   refusal". ADR-1049 cites R25 for a neighbouring rule and does not settle this one.*
7. **Seven requirements take new headings, in one Story, with no cap and no split** — positions 3,
   10, 15, 22, 25, 30 and 40, which is 857 of 4,823 lines. OpenSpec 1.10.0 appends ADDED requirements
   after every survivor in delta order, so the seven move to the end and **the first gap appears at
   position 3**: the spec keeps its first two requirements first. *Splitting cannot avoid the
   reordering, since every rename appends whichever Story makes it, and only buys a second pipeline
   run — settled the same way on #214 (9 renames) and #215 (17). Taking only the clustered drops, and
   not running the Story at all, were the alternatives; the ratio here is worse than either
   predecessor's and the trade is the same one.*
8. **`docs/adr/1047`'s decision 5 loses its first title, and its list reads two rather than three.**
   Item 2 drops `two commitments alike in name and not in rhythm are two entries a person cannot tell
   apart`, and the spec prose that once explained why it was kept is already gone (removed by #207),
   so decision 5 is its only live record. The Story that makes a statement false fixes it — #211 item
   13 and #214 item 12 are the precedent. Decision 5's other commitment title, `a commitment stopped
   through a commitments screen is kept until the day the screen was handed`, is **not droppable**:
   it is the only scenario for its requirement's main clause and it is about the date boundary itself,
   failing conditions 3 and 4.
9. **One live reference outside the spec follows the renames, and there are no others.**
   `docs/adr/1049`'s `## Context` at line 21 names *A commitments screen holds the change it refused
   and why, one at a time*, wrapped across two lines, and is prose rather than a dated decision, so it
   takes the new heading in this PR. **No in-spec cross-reference** points at any of the seven; the
   spec's only two cross-referenced headings are not in this set. Nothing in `CONTEXT.md`, in another
   capability spec, in `src/`, or anywhere else under `docs/` cites one — `docs/open-questions.md`
   included, so #215's missed-search does not repeat. Three files under
   `docs/research/2026-09-09-concise-specs/` quote renamed headings inside dated survey records and
   stay exactly as they are, as do all quotes under `openspec/changes/archive/`.
10. **No kept test is strengthened, and this Story carries no strengthening step.** Every keeper
    already asserts its own unchanged scenario in full, and seven of the eight assert the dropped
    test's values verbatim. *#214 and #215 both had to grant a kept-test permission and both carried
    the risk that a strengthened test goes red and stalls the deletions; this Story has neither.*
11. **B-041's quote is repointed on `chore/backlog` after the archive.** `docs/backlog.md:313` quotes
    the dropped `a commitment dropped among another group's entries is put under that group's
    category` as want B-041's evidence that *"The requirement already exists and is tested"*. The
    claim stays true — the keeper asserts the same behaviour, including persistence — so the drop
    stands and only the quote moves, in the same pass as item 12, on the branch that already holds
    unmerged captures. *Giving the drop up instead was the alternative; fixing it inside this PR was
    refused, since a Story PR leaves `docs/backlog.md` alone.*
12. **Two latent test weaknesses go to the backlog as one want, captured after G4.** Neither is a
    pruning matter and no drop depends on either.
    - The four `a change that leaves the roster as it was keeps nothing at its place` tests stay green
      when `RosterStore` writes unconditionally, because `write` is byte-stable and rewriting an
      unchanged roster is byte-identical: they assert nothing *changed*, not that nothing was
      *written*. With all four `if nextRoster != roster` guards removed, **all 1010 tests pass** —
      nothing in the suite catches it. The uncovered rule is `spec.md:851-853`.
    - The `stopping`/`removing a commitment leaves every earlier date answering as it did` pair are
      blind to whether their own mutator recorded anything: the returned `Bool` is discarded, so
      making `retire` or `remove` a no-op leaves both green.
13. **R24's coverage gap goes to `docs/open-questions.md`, on a chore branch after the merge.**
    *A commitments screen that cannot read its roster lists nothing and changes nothing* names five
    verbs in its prose and three have a scenario. *`AGENTS.md` routes a known gap there and reserves
    the backlog for wants, so it does not join item 12's want.*
14. **A base case is not spared.** Four of the eight drops are their requirement's base or headline
    case. *The four conditions spare none, and sparing one would be a new rule — settled on #214 and
    applied again on #215.*
15. **The surveys were wrong in these places**, recorded so nobody re-trusts them. All four —
    `survey-commitment-A.md` §3, `survey-commitment-B.md` §3,
    `survey-2026-09-10-commitment-added.md` §4, `survey-2026-09-10-commitment-modified.md` §4 — were
    read in full, and **68 of their 71 candidates are keeps**.
    - **Every line number in all four is stale**, and no survey names its base commit but one: A and
      B were measured at `4e64641` (4,741 lines), the two 2026-09-10 surveys at `b68eab1` (5,896),
      and the spec is 4,823 after #207. Every candidate they name does still exist, by title.
    - **Survey A's whole reading of the roster-store requirement is wrong at the root.** It calls
      three pairs "stop/remove twins", four scenarios "fixtures of one rule" and three "fixtures of a
      no-op", concluding "~6 of 31 droppable on fixture grounds alone". `RosterStore` has **one method
      per verb**, each with its own guard, write and report; six mutations each reddened one member
      and spared the rest. Exactly one of the twelve was droppable, and item 4 has since withdrawn
      even that. It also counts the no-op family as three when it is four, and leaves a hedge on the
      removal path unresolved — the path does differ, at `RosterStore.remove`.
    - **Survey A reads three `Schedule` shapes as fixtures of one delegation rule.** `Schedule.isDue`
      is a four-way `switch`; each shape is its own statement, and three mutations separate them.
    - **Survey A says one take-up-again scenario "subsumes" another.** It does not: the first asserts
      whole-roster equality and the second asserts none, which is what proves no residual state
      survives.
    - **Survey A says one stopped-list scenario "is another plus a move".** Wrong twice — the keeper
      stops through the screen rather than at the roster place, and asserts the **reverse** order.
      `CST:195` is the only test in all 1010 pinning the stopped list to roster order rather than
      name order; the other order scenarios pass because their expected orders happen to be
      alphabetical.
    - **Survey B reads the two refused-change requirements' families as "verb fixtures".** Both
      enumerate their verbs in prose, and each screen clears its refusal in seven separate places, so
      every member is the only test of its own statement — item 6.
    - **Survey B proposes merges and calls them drops** — six of its rows rewrite a kept test, which
      decision 6 does not license: a pruning Story deletes tests and adds none.
    - **Survey A and the modified survey disagree about one keeper and both are wrong**, because that
      requirement's rule is an eleven-case enumeration and no scenario covers more than two cases.
    - **The modified survey says one scenario's third `AND` "covers a third kind and subsumes"
      another.** The third kind is the tick, not the number; its test never passes `kind: .number`.
    - **All four surveys missed the whole of items 2's second half**: four of the eight drops were
      named by no survey, and the walk that found them covered all 42 requirements.
    - **What they got right, so it is not re-litigated:** survey A's call on the commitments-screen
      name pair, including its keeper; the added survey's Block 7 call in every particular; survey
      B's observation that the unreadable-screen requirement's first scenario already covers define.
16. **Three traps for whoever implements this**, found while testing and cheap to pass on.
    `swift test --filter` takes the **Swift function name**, not the `@Test` display string — a
    display-string filter reports `0 tests ... passed`, which reads like green. `Roster.commitments`
    is **not** what a commitments screen reads, so a mutation aimed at the screen belongs at
    `CommitmentsScreen.swift:75`. And every test span shifts as soon as anything above it goes:
    delete from the bottom of each file upward, or locate each test by the function names in item 2.

## Terms landed in CONTEXT.md

None. *Pruning Story* already stands from #211, and nothing settled here names a new thing: items 3,
5 and 6 are readings of ADR-1047 decision 6's conditions, which is a rule rather than a domain term,
and item 3 lands in that ADR rather than in the glossary.

## Left open

None. Every requirement in the spec was walked, every candidate the four surveys name has a verdict,
and the three cases still arguable after confirmation were re-tested and settled in items 4 and 6.
The only follow-ups are items 11, 12 and 13 — the backlog repoint, the want and the open-questions
entry — each with a place and a time after the merge, and #199's box 15 with its outcome comment.
