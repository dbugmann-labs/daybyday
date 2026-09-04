# Grill — add-roster-store

*13 questions over 4 rounds, 2026-09-04.*

## Settled

1. **How far this Story reaches.** It goes all the way to the screen: the day screen draws its
   commitments from a stored roster, and a fresh install writes day one into that roster. *Asked
   because `Roster` is used nowhere in `src/` today — `ContentView` hard-codes its list — so an
   engine-only store would have had no caller until #104. The recommendation was engine-only; the
   owner took the wider scope, which makes #103's intent sentence true at the end of #103 rather
   than at the end of #104.*
2. **The roster is kept at its own place**, a file beside the record's, not in one document with
   it. *Two stores at different places are already required to be independent of each other;
   taking on a commitment must not rewrite the history, and merging them would need a delta on
   `record`. B-009 carries a directory rather than a file — one thing to carry either way.*
3. **Nothing is added to the `commitment` capability.** `Roster.Entry` and `Roster.entries` are
   widened from `private` to module-internal so the store can read a stopped commitment and its
   kept-until day. *A finding, not a free choice:
   `archive/2026-09-03-add-roster-retirement/design.md:382` says #103 "can reach it internally
   without a delta", and that is not true as written — they are `private`, so nothing in the
   module can read them. The alternative, a public read-back requirement on the roster, grows a
   surface no screen has asked for and reopens a spec that has passed G4 twice.*
4. **The store mirrors the roster's mutators** — an add and a retire, each kept at the place
   before it returns — rather than taking a whole roster. *Keeps "there is no separate step at
   which a store is saved" true, which is the record store's rule and the reason it has no save
   method. A store handed a whole roster lets a caller write a stale one over a newer one.*
5. **Day one is written when the roster holds nothing at all**, not when it reads back no
   commitments. *Retiring keeps the entry, so a roster emptied by stopping all eight is never
   equal to a fresh roster — the cheap test is correct today and needs nothing new on the store.
   **A standing obligation follows**: any later Story that truly removes a commitment from a
   roster, rather than stopping it, re-arms the trap this answer avoids, and owes a different
   test for a virgin place. That line belongs in `design.md`, the way `add-record-store`'s design
   carries the migration obligation for schedule changes.*
6. **The app target owns day one; the engine decides when it is written.** `ContentView` hands
   the day screen the eight commitments, and the day screen writes them only into a roster
   holding nothing. *A store that invents eight commitments would break its own requirement that
   it never holds more than is kept at its place. But the trigger has to be testable in
   `DayByDayKit`, so the engine keeps the when.*
7. **The day screen asks the roster per day it is showing** — what it had not stopped keeping on
   that date — rather than holding a fixed list. *Otherwise the kept-until day this store exists
   to persist cannot be observed at all, and a past day would show today's list. **This is what
   makes the Story touch `day-screen` as well as `commitment`**, and the delta owes both.*
8. **The day screen opens both stores and re-reads both on being shown.** A roster store place
   sits beside `DayScreen.recordPlace`. *One object owning both files is what makes reading them
   together on every scene-active possible. Re-reading the roster costs nothing today because
   nothing else writes it — and #104 adds a screen that does, so a day screen holding a stale
   roster is the bug that would otherwise land there as a mystery.*
9. **An unreadable roster is reported separately from an unreadable record**, in the same three
   cases the record already has. *The distinction is real and a person can act on it: an
   unreadable record still leaves rows to draw unticked, while an unreadable roster leaves
   nothing to draw at all. A roster store that refuses to open is never seeded over — refused
   rather than emptied applies to the seed too.*
10. **One hand-written coding of a commitment, shared.** `CommitmentRecord`, `DateRecord` and
    `ScheduleRecord` move out of `RecordDocument.swift` into a file of their own; each document
    keeps its own independent version number. *ADR-1017 refuses synthesised `Codable` because
    nobody has read the compiler's shape; that argument is about the coding being written and
    signed once, not about it being written twice. A fifth schedule shape stays one compile
    error in one exhaustive switch.*
11. **An ADR is owed for day one.** Shipping a roster pre-written with the owner's eight
    commitments is surprising, is a real trade-off against the two alternatives in question 1,
    and is expensive to reverse once anyone has launched the app. *`spec-author`'s to write;
    `docs/adr/README.md` has the numbering rule.*

## Terms landed in CONTEXT.md

- **Store** — amended. It is no longer the record's alone: a store is where a value survives the
  app being closed and opened again, at a place the app names, kept the moment it changes and
  refused whole rather than opened empty over what is there.
- **Record store** — the store that keeps a history. What the old **Store** term described.
- **Roster store** — the store that keeps a roster: every commitment taken on, in the order it
  was taken on, and the day each stopped one was kept until.
- **Day one** — the commitments a fresh install begins with, before anyone has defined one:
  the owner's own week, quoted in `docs/backlog.md` § *What day one looks like*.

## Left open

None. Every question the frontier raised was answered, and the two things that could have been
carried forward are recorded above instead of left hanging: the standing obligation a future
delete owes (settled item 5) and the ADR day one owes (settled item 11). Both are `spec-author`'s
to write into `design.md` and `docs/adr/`; neither is an open question about what this Story does.
