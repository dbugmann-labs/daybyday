# 1027. Day one is the app's content, written into a roster that holds nothing at all

- Status: accepted
- Date: 2026-09-04
- Deciders: Diego Bugmann

## Context

Until `add-roster-store` (#103) the commitments DayByDay draws were a compiled-in constant. They
still are, in `src/DayByDay/DayByDay/ContentView.swift`:

```swift
private let dayOneCommitments: [Commitment] = { ... }()
```

Eight of them — the owner's own week, quoted verbatim in `docs/backlog.md` § *What day one looks
like* — handed straight to `DayScreen(of:asOf:keeping:)` on every launch. Nothing writes them
anywhere, nothing can add a ninth, and nothing can stop one, because there is no store to hold the
answer.

#103 gives the roster a store. That immediately raises a question nothing before it had to answer:
**what does a person see the first time they open the app, before they have defined anything?** The
roster store, opened at a place where nothing has been kept, holds a roster holding nothing, and a
day view of no commitments has no rows. Left alone, the first launch is a blank screen — and it
stays blank, because the screen that lets a person add a commitment is #104's and does not exist yet.

Three shapes were weighed. `docs/backlog.md`'s day-one list is not a placeholder to be replaced; it
is the requirement the product was judged against at every grooming pass, and it is the actual week
of the only person who will run this app in 2026.

## Decision

**The app target owns the content of day one; the engine owns the moment it is written; and the
moment is a roster that holds nothing at all.**

- `ContentView.swift` keeps the eight commitments, unchanged, and hands them to `DayScreen` as the
  commitments it is *starting from* rather than the list it draws.
- `DayScreen` reads the roster at its place, and **exactly when that roster holds nothing at all**
  it takes those commitments on, in the order it was handed them, keeping each at the place before
  drawing from it. From then on it draws its roster and never its argument.
- *Holds nothing at all* means equal to a roster that has been given no commitment — in Swift,
  `roster == Roster()`. It is deliberately **not** "reads back no commitments": retiring keeps the
  entry, so a roster whose every commitment has been stopped still holds them and is never day one
  again.
- The rule is about the roster that was *read*, so it is re-applied whenever the roster is read —
  when the screen is opened and when the app is shown again. A first launch whose write failed
  recovers on the next activation without a force-quit.
- A roster store that refuses to open is **never** written over. A place that cannot be read is not
  a place that holds nothing, and day one must not be the thing that destroys a roster this app
  could not parse.

## Alternatives considered

**Ship an empty roster and let the person add the first commitment.** The honest shape, and the one
this decision will eventually become. Rejected for now on a fact rather than a preference: no screen
can add a commitment until #104, so a first launch would be a blank screen with no way off it. It is
also the wrong trade against `CONTEXT.md` § *Five percent of seven things, not all of one* — the
product's whole argument is that a person sees their week at once, and an app that opens on nothing
demonstrates none of it.

**Let the store invent the eight when it opens empty.** Rejected because it breaks the store's own
requirement — a roster store holds exactly what it was given and nothing it invented — and because it
would put product content inside `DayByDayKit`, where every existing type is a rule rather than a
fact about one person's life.

**Let the shell decide when to write them.** Rejected on ADR-1019's own test: *whether a roster holds
nothing at all* is a condition that could be wrong in a way a test would catch — written twice,
written over a roster emptied by retirement, written over a roster that would not open — so it
belongs behind the seam, where `DayByDayKit`'s tests can reach it. The shell keeps the part that
genuinely could not be wrong: the eight literals.

## Consequences

- **Anyone who installs DayByDay gets the owner's week.** Accepted knowingly. The app is one
  person's, the list is his, and B-013's *stop keeping a commitment* plus #104's *add one* are what
  turn it from the whole product into a starting point. **The trigger for reversing this decision is
  the first person other than the owner running the app** — at that point day one becomes either
  empty or a choice offered on first launch, and this ADR is amended in place rather than superseded
  (ADR-1020).
- **Editing the eight is a shell change with no G4**, because `dayOneCommitments` is content and not
  a rule, and `openspec/specs/` says nothing about which commitments they are. What *is* under a
  requirement is that the screen takes on exactly what it was handed, in that order, and invents
  nothing.
- **A standing obligation on any later Story that lets a commitment be removed** rather than stopped:
  a roster emptied by removal would equal a fresh roster, and day one would be written back over the
  top of it. Such a Story owes a different test for a place nothing has ever been taken on at —
  a marker in the document, or a distinction the roster itself draws. `add-roster-store`'s
  `design.md` § *Day one is the app's content and the engine's moment* is the other place this is
  written down, so a design review finds it before a phone does.
- **A person who stops all eight sees an empty day and, until #104, has no way back.** Real, small,
  and out of #103's scope; recorded here rather than discovered.
