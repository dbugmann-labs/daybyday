# Grill — save-change-whole

*17 questions over 4 rounds, 2 facts dispatched, 2026-09-14.*

## Settled

1. **Which failures.** Both: the app stopped between the record write and the roster write (a
   kill), and a write that throws while the app runs. *The kill is the defect the eighth pass found;
   a throw reaches the same torn state.*
2. **Which way a torn save is made whole.** As it was — the change did not happen, and a failure at
   save time is refused as a place that could not be written. *A change is kept before it is said,
   so a torn one was never said; the person makes it again.*
3. **Which acts.** Every act that writes both places: a change in all four forms (rename, kept-from
   correction, rhythm change, name or kept-from plus rhythm in one save) and a restart (#248).
   Define, stop, remove, move and a rhythm-only change write the roster alone and are untouched.
   *A rule about two-place acts, or restart ships the tear this Story closes.*
4. **Kill survival.** Record and roster stay two files; a two-place save leaves a durable note of
   the change in progress, and whatever opens the places next undoes it. *Chosen over one file for
   both, which would reverse the roster place being deliberately not the record place (#103).*
5. **Told after a kill.** Nothing. *They were never told it saved and the commitment reads as
   before — the same as a kill before any write.*
6. **An undo that fails** (places still unwritable when shown, or the in-save undo failing — today
   a swallowed `try?`). The screens keep no record until it lands: a day screen is without its
   record and draws no ticks, the commitments screen changes nothing, and the next show tries
   again. *Nothing torn is ever drawn or written over.* This covers the fact found at round 1 that
   a restart's in-save undo is refused outright whenever the commitment holds records before the
   restart day, so it never puts anything back today.
7. **Past tears are repaired**, against the recommendation to prevent only. *The owner wants
   history already orphaned on a phone to come back.*
8. **An orphan whose source is not certain** — none or several could be it. Left untouched and said.
   *Choosing between two plausible sources is a judgement about someone's history.*
9. **A successful repair is not said.** *The history reads as it did before the tear.*
10. **The owner's phone `record.json`** is still repaired by hand now, as the eighth pass decided,
    without waiting for this Story.
11. **Candidate sources** are every roster entry, removed ones included. *A removed entry may have
    been kept when it was torn from; ambiguity it causes falls to 8.*
12. **Collision on carrying back** — some records land on days the source already holds one.
    None of that orphan's records move, and it is said like an ambiguous one. *All or none, as
    carrying over already is.*
13. **Where the unrepaired orphans are said.** On the commitments screen, as a standing statement
    for as long as any remain. *Not a daily-visit surface, and not a notice with a lifetime.*
14. **Orphans from other causes** (a roster file deleted outside the app and reseeded with day one)
    are treated exactly as tear orphans. *Nothing on disk tells the causes apart.*
15. **The latent stale-copy lost update** is not guarded here and goes to `docs/open-questions.md`.
    A two-place save rewrites the whole record file from the commitments screen's copy loaded at
    its `init`; unreachable today only because the shell builds that screen fresh on every push
    (`ContentView.swift:131-133`, `238-242`) and the day screen cannot be used meanwhile.
16. **Names.** *Torn save* and *orphaned record*, the words the archived designs of #248 and
    fix-change-refusals already use.

## Facts the answers rest on (dispatched, not asked)

- Two-place acts are only `CommitmentsScreen.change` (same-rhythm and rhythm-plus paths) and
  `restart`; record written first, roster second; all refusals run before the first write.
- The in-save undo exists (`CommitmentsScreen.swift` ~510, ~591, ~720) under `try?`; a retry after a
  tear is refused as records already existing, so #148's "ask for the same change again" repair no
  longer converges.
- No store can write back a prior history other than by an inverse carry-over.
- An orphan differs from its source only in name, kept-from and an interval's start date — never
  in schedule shape, interval, kind, range or target — but two roster entries can both match
  (two commitments alike except in name; the kept and removed entries a restart leaves).

## Terms landed in CONTEXT.md

- **Torn save** — a change that reached one of its two places and not the other; made whole as it
  was.
- **Orphaned record** — a record of a commitment the roster holds in no state; carried back to its
  one possible source, otherwise left and said.
- **Store**, amended — undoing a torn save and carrying back an orphaned record write when the
  places are opened.

## Left open

None. The frontier emptied at round 4 and the owner confirmed the summary. What remains is design
rather than preference and is `spec-author`'s: how the in-progress note is shaped and where it
lives, the exact source-matching rule over the four tear shapes, when and in what order the undo
and the repair run on opening, and whether this is ADR-worthy (it amends ADR-1023's neighbourhood
and #148's retry design).
