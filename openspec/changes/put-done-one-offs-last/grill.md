# Grill — put-done-one-offs-last

*10 questions over 2 rounds, 2026-09-24, three fact agents. Groomed the same day from B-060
(`docs/backlog.md` § *Decided*), whose scope was put at G2 as one-offs only: commitment rows keep
the order the person set (ADR-1037, and `day-screen`'s "MUST NOT move a row that has been ticked"),
and the Birthdays group keeps its collation order. This Story reverses `one-off`'s "MUST NOT be
ordered … by whether a one-off is done", chosen at the grill of #243.*

## Settled

1. **The done are newest tick first.** Every undone one-off stands above every done one; among the
   done, the one ticked most recently comes first, so a tick moves the row to just below the last
   one still owed. *They took this over the recommended date-owed order for the done, knowing it
   needs a stored tick order and a new form of the one-off store; it is the owner's words at
   capture, "moves below the last unticked one".*
2. **The undone keep today's order.** Earliest owed first, one date's in the order they were added.
   *Unchallenged at capture — "all due ones on top" — and it is the order shipped at #243.*
3. **The move animates.** A tick moves the row to its new place with a short animation. *So the eye
   can follow it and a mistaken tick is easy to find and take back; nothing on the day screen
   animates on a tick today, in any group.*
4. **A tick taken back returns the row by the date owed.** It rejoins the undone at the place it
   would hold had it never been ticked. Ticked again, it is the newest tick. *Over "the bottom of
   the undone": the place it came from is the one rule the undone already keep.*
5. **The move animates both ways.** A tick taken back moves the row up with the same animation.
6. **A one-off ticked before the tick order was kept is older than every tick made since.** Among
   themselves such ones stand by the date owed, then added order — so every past day looks exactly as
   it does now. *Over putting them on top, which would break newest-first on the day the update
   lands.*
7. **A one-off made already done on a past day is ticked as it is made.** It is that day's newest
   tick and goes first among its done. *Making it is the tick.*
8. **A rename keeps a done one-off's place among the done.** Its tick order stays, as its date and
   done day already do. *A rename is one act, not a removal and an add — the rule #244 settled for
   the place among those owed on a date.*
9. **A copy carries the tick order.** A restored phone keeps newest-first; an older copy with no tick
   order restores under item 6. *A copy is the values (ADR-1054) and restore, not sync, is a product
   principle. Fact found: `CopyDocument` nests `OneOffDocument` and re-encodes it from the value, so
   the order survives a copy only if it lives in the `OneOffs` value.*
10. **The walk.** Today with two undone one-offs and one done:
    - before any tick;
    - one undone ticked — it stands directly under the undone, above the one done before;
    - the other ticked — it stands above the first;
    - one tick taken back — it returns to its date-owed place among the undone.

    **phone:** the move animates both ways and the row can be followed with the eye. *They took the
    four pictures plus the phone step over pictures only.*
11. **The one-off store's open-question test gap is folded in.** `docs/open-questions.md`'s "The
    one-off store's 'kept before the store reports it kept' test does not keep the first store open"
    is owed by the next Story touching those tests, which this one is; fix it here and remove the
    entry. *A few lines, no behaviour change.*

**Facts the grill turned on**, found by agents rather than asked: only **today** can hold done and
undone one-offs together — a past day holds only done, a future day only undone (`one-off` spec
"stands on exactly one day"); a tick records only its calendar day (`OneOffs.Entry.doneOn`), and
the order is decided in one place, `OneOffs.standing(on:asOf:)`, which sorts by date owed and is
stable over array position; no store may hold a time of day (`Moment.swift`, ADR-1054, `CONTEXT.md`
§ *Moment*), so "newest" is an order and never a clock; a new field in a store's form follows
ADR-1031 (each field read by the form it arrived in, no migration pass); one-off rows are keyed by
value (`ContentView.swift`, #244's grill answer 19), so a tick re-keys the row — how the animation
survives that is the design's. No spec outside `one-off` and `day-screen` depends on the order.
Item 9 reaches the copy, which #329 `carry-birthdays-in-a-copy` — in flight, grilled, no delta
pushed yet at this grill's close — also changes; G2 recorded no serialisation before item 9 was
answered. Whichever of the two lands second rebases over the other's copy change.

**No layout round.** `designer` returned *no layout question here*: the Story moves rows within the
group and draws nothing new — a done row already reads as done — and the animation is the walk's
`phone:` step.

## Terms landed in CONTEXT.md

- **One-off** — amended 2026-09-24: undone above done, the done newest tick first; the tick order is
  never a time of day; ticks from before it are older and stand by the date owed; a copy carries it.

## Left open

None. Every question the frontier raised was answered; how the tick order is stored and how the
animated move survives a re-keyed row are design, not preference, and are `spec-author`'s.
