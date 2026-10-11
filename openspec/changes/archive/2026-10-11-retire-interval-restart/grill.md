# Grill — retire-interval-restart

*4 questions over 2 rounds, 2026-10-11, with one fact agent.*

The 2026-10-06 grooming pass for B-054 settled the Story itself: the **shift** replaces restarting
outright, restarts already made stay in the history as made, and the Story that retires restart owes
an ADR, because none held it. The questions below are what that left open.

## Settled

1. **The CONTEXT.md entry Restarting.** Deleted outright, along with every mention of the word in
   other entries — Collapse, Shift, the Commitments screen amendment counting the kinds of refused
   change, Refused change, Sheet refusal, Look-back and Era. *The owner chose this over the
   recommended retired stub: the glossary describes what the app does now, and the archived change
   folders keep their own record of the word.*
2. **The walk.** One picture: the change sheet of an every-N-days commitment, with no restart
   control on it. No `phone:` lines. *Nothing here is a gesture or a feel, and the shift that
   replaces restart was walked when it shipped.*
3. **What a shift cannot do.** Accepted, and recorded in the ADR this Story owes, with no want
   captured. Three restarts have no shipped replacement once restart goes: reaching behind a rhythm
   change (or an earlier restart) to count again from a day the older era holds; a due day that
   is ticked, or has a record on a later day, which refuses the shift, though a kept-from
   correction gives the same due days at the cost of moving the kept-from day; and a commitment
   already holding a shift with a day after the due day, which refuses a new shift. *The first needs
   a rhythm change and a late regret within days of each other. The second has the kept-from
   workaround. The owner chose outright replacement on 2026-10-06 and keeps it, knowing these cases.*
4. **The dated `carryOver(_:to:onOrAfter:)` overloads** in `History.swift` and `RecordStore.swift`
   have no callers and are left from an older restart design that carried records. They are removed
   in this Story. *They are restart's, and removing them changes no behaviour.*

Facts the questions turned on, from the fact agent, for `spec-author` to verify rather than trust:
nothing on disk or in the model marks an era as made by a restart. A restart wrote an ordinary
superseding era through `Roster.put`, so restarts already made read unchanged once the code is
gone, and the roster needs no migration. One test outside the restart tests stops compiling:
`CommitmentsScreenTests.swift`, *what a commitments screen tells on its sheet stands when another
field is edited*, which passes `.restartDay`. The `restore` capability's copy-after-every-change
requirement lists "restarted" among the changes.

## Terms landed in CONTEXT.md

None. One term leaves: **Restarting** is deleted, with the mentions above, by `spec-author` in
this change, so the glossary changes when the Story merges.

## Layout

No layout question, from `designer`, so there is no mockup and no option to choose. The change
sheet's restart section is the last section of its form, and it is drawn only for a commitment that
can restart. Without it, an every-N-days commitment's sheet is the sheet every other commitment
already shows, and nothing else on it moves. The walk picture is read against that sheet, so there
is no wireframe.

## Left open

None. Every question the frontier raised was answered. How the requirements that mention restart
are cut — removed, or modified to drop restart — is the delta's to decide, not the owner's.
