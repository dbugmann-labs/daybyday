# Grill — rework-commitment-row-actions

*14 questions over 4 rounds, 2026-09-09. Story #192, from want B-042.*

Two facts found before the first round reshaped what the want had assumed, and both are why this
grill went where it did. **A row tap already opens the change sheet** (`CommitmentsView.swift:143`
and `:250`, both lists, from #148), so *Edit* was never an act that needed a swipe. And **the change
sheet already sets a category** — `change(_:toName:on:keptFrom:under:)` writes it at
`CommitmentsScreen.swift:341`, over the same `categoriesInUse` the category sheet offers — so the
*Category* swipe was the only caller of a method the app had already grown a second way to reach.

## Settled

1. **The `put` half of *A commitments screen puts a commitment under a category, and offers the
   categories in use* goes, and `CommitmentsScreen.put(_:under:)` leaves the seam.** The
   "offers the categories in use" half stays: the change sheet reads `categoriesInUse` for its
   *Use an existing category* menu, so that half keeps a caller while the other loses its last one.
   *Asked because a shipped, tested requirement no gesture can reach is the defect the want named.
   A side effect taken knowingly: a stopped commitment's category becomes changeable through the
   sheet, which `put` always refused.*

2. **The delta reaches the refused-change requirements too — `RefusedChange.categorising` goes
   with it.** `:2657` enumerates "the eight a person can ask for" with *putting one under a
   category* among them; `:3771` calls its write failure the fifth kind, `:4668` calls the group
   move the seventh "beside … putting one under a category", and the *no change at all* list names
   *asking to put a commitment the screen does not keep under a category*. All of it follows the
   method out. *Chosen over leaving `.categorising` in the enum unreachable, which would reproduce
   the Story's own defect one level down.*

3. **How the count is reworded is a real problem, not a tidy-up.** `CONTEXT.md` and archived change
   folders cite these refusals **by ordinal** — "the seventh kind", "the eighth kind" — and an
   archive is immutable. Renumbering makes the archive read wrong; not renumbering leaves ordinals
   that no longer count to the total. *Flagged, not decided: it is spec-author's to solve, and it is
   the one place this delta could quietly falsify a record.*

4. **The leading edge carries Edit, and the row tap is removed.** Against the recommendation, which
   was to leave the leading edge unclaimed because the tap already did the job. The owner chose the
   pencil *and* took the tap away, so the swipe is the only door. `.contentShape(Rectangle())` and
   `.onTapGesture` come off both lists.

5. **Nothing on the screen depicts the swipe, and that is accepted.** ADR-1042 declined exactly this
   for the day screen — it kept the chevrons because "a gesture nothing on the screen depicts is a
   gesture a person has to be told about". *The two screens go opposite ways because the acts are
   not alike: moving days is the constant act of every visit, these four are occasional, and a list
   row that swipes is the most universal idiom iOS has.* This is the Story's ADR — see below.

6. **The trailing edge carries Stop-or-Resume outermost and Remove inboard, so a full swipe stops
   rather than removes.** Against the want's own note, which asked for destructive outermost on
   Mail's convention. *The outermost action is the one a full swipe performs, and that should be the
   frequent reversible act, not the rare irreversible one. Mail puts delete there because deleting
   mail is the common act; here it is not.* Remove keeps its typed-name sheet either way.

7. **A full swipe on the leading edge opens the change sheet.** One action on that edge, so the
   gesture is unambiguous, and the sheet is cancellable and writes nothing on its own.

8. **The icons: `pencil`, `stop.circle`, `play.circle`, `trash`.** *`pause.circle` was the more
   legible pair-mate for `play.circle` and was refused: `CONTEXT.md` says a commitment has "no state
   that can be paused or archived", and **stopping keeping** is the person's own verb, so
   `stop.circle` says the true thing.* All four verified present from iOS 13 in the installed
   iOS 26.5 CoreGlyphs catalogue — DayByDayKit's floor is iOS 17, the app target's is iOS 26, so no
   availability guard is needed. `arrow.up.arrow.down` for the mode, same check.

9. **Each act is tinted: Edit accent, Stop orange, Resume green, Remove red.** Against the
   recommendation, which was to leave it to the system — red by destructive role, the rest grey.
   *With the words gone, colour is the only channel left beside the glyph.* The repo has set no
   `.tint` anywhere yet, so these are the first, and they sit inline as ADR-1045's green checkmark
   does.

10. **The mode becomes an `arrow.up.arrow.down` icon that toggles and shows itself selected while
    on**, replacing `EditButton()` and the word *Edit* with it. It keeps both things it holds — the
    row drag handles and the per-section *Move up* / *Move down* buttons — because both are
    reordering, which is what makes the rename honest. Its accessibility label carries *Reorder* and
    its state.

11. **The visible rework carries no requirement.** A grep across `openspec/specs/` for swipe, icon,
    edit mode, `EditButton` or `systemName` returns nothing: the specs are seam-level throughout,
    and ADR-1022's line — what a screen draws is the drawing's — is the same one that kept *Move up*
    / *Move down* out of the spec at #168. *So the delta is the category split alone, and the red-green
    cycles come only from it; the rest is app-shell work walked on the phone at `docs/process.md`
    § 9.5.*

12. **One ADR, on decision 5 — the undepicted swipe — amending ADR-1042 in place rather than
    superseding it (ADR-1020).** *The requirement removal gets none: #148 deleted this repository's
    first REMOVED requirement and recorded it in `design.md`, and that precedent holds.*

13. **`CONTEXT.md` § *Move* is amended in this Story; `docs/backlog.md` is not.** That entry's clause
    "refiling across groups is the **commitments screen**'s *Category* action on the row" — itself a
    correction made twice — becomes false, and refiling becomes the change sheet's category field.
    *B-041 is left to the next grooming pass: it lives on `chore/backlog`, and editing that file from
    a Story branch invites the rebase conflict rule 5 calls a stop.*

14. **B-041's Principle line is now weaker, and the next grooming pass should reweigh it.** It argues
    the drag-to-refile want loses because "the row's *Category* action already refiles across groups
    in one tap"; after this Story refiling is a swipe, a sheet, a field and a save. *Recorded here
    rather than edited there, per 13.*

## Terms landed in CONTEXT.md

**None new.** This Story changes what a person can *do* on a screen and adds no domain vocabulary —
every act it touches already has its word. What is owed instead is an **amendment**, settled at 13:
`CONTEXT.md` § *Move*'s clause naming the row's *Category* action as the way to refile across groups.
`spec-author` writes it with the delta.

## Left open

None. Every question the frontier raised was answered, and the one thing deliberately not decided —
how the refused-change ordinals are reworded without falsifying an archived folder — is stated at 3
as `spec-author`'s to solve inside the delta rather than as a question anyone is waiting on.
