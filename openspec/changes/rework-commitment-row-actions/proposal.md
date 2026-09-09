## Why

Every act on a commitment is reached by a different kind of gesture today — a tap on the row opens
the change sheet, a mode has to be entered before anything can be reordered, and a horizontal swipe
offers a growing row of word-labelled buttons, one of which does a job the change sheet already
does. The owner walked the screen after `add-commitment-editing` (#148) shipped and came back with
B-042: **one swipe reaches every act, with an icon rather than a word, and the mode that remains
does only reordering.**

Most of that is drawing, and drawing carries no requirement here (`grill.md` § *Settled* 11). One
part of it is not. Dropping the *Category* swipe leaves `CommitmentsScreen.put(_:under:)` with no
caller in the app, which would leave *A commitments screen puts a commitment under a category, and
offers the categories in use* a shipped, tested requirement no gesture can reach. That is the
defect this Story exists to prevent, and it is the whole of the delta.

## What Changes

- **BREAKING** — **a commitments screen no longer puts a commitment under a category.**
  `CommitmentsScreen.put(_:under:)` leaves the seam. The category a commitment is under is set on
  the change sheet, which has written it since #148 through
  `change(_:toName:on:keptFrom:under:)`, over the same categories this screen already offers.
- **The offering half stays**, under its own name. *A commitments screen offers the categories in
  use* keeps every rule about which categories are offered, in what order, each once, and none from
  the stopped list — the change sheet is the caller that keeps it alive.
- **`RefusedChange.categorising` goes with the method.** A refused category change is no longer one
  of the kinds a commitments screen can hold, and *asking to put a commitment the screen does not
  keep under a category* is no longer one of the calls that ask for no change at all.
- **The kinds are counted in one place and numbered nowhere.** Withdrawing a kind renumbers every
  position after it, which falsifies both the requirements that state one and the archived change
  folders that cite one. The enumeration in *A commitments screen holds the change it refused and
  why, one at a time* becomes the only place a count lives; *A commitments screen moves a group
  among the groups it draws* stops calling itself the seventh kind and names itself instead.
- **The visible rework carries no requirement and no delta.** Four acts on two swipe edges with
  icons, a full swipe that stops rather than removes, tints, the row tap removed, and `EditButton()`
  replaced by a reorder toggle — all of it is the app shell's, all of it is walked on the phone
  (`pnpm run phone`) before the review, and `design.md` § *The shell rides this Story* says what it
  is.
- **One ADR is amended in place**: ADR-1042, on why the commitments screen's row swipe is
  deliberately undepicted while the day screen's chevrons stay.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `commitment`, seven requirements — one **ADDED**, five **MODIFIED**, one **REMOVED**:
  - **REMOVED** *A commitments screen puts a commitment under a category, and offers the categories
    in use*, with its offering half re-landed as **ADDED** *A commitments screen offers the
    categories in use*. `REMOVED`-plus-`ADDED` rather than `RENAMED`, because `openspec` 1.10.0
    refuses to drop a scenario through `RENAMED` or `MODIFIED` alike — `design.md` § *Context*.
  - **MODIFIED** *A commitments screen holds the change it refused and why, one at a time* — loses
    the category kind, gains the rule that the kinds are counted there and numbered nowhere.
  - **MODIFIED** *A commitments screen moves a group among the groups it draws* — loses the ordinal
    the withdrawal falsifies.
  - **MODIFIED** *A commitments screen changes a commitment on either of its lists* — gains the
    paragraph saying it is the only act on this screen that writes a category, and the two scenarios
    that would otherwise have gone unasserted.
  - **MODIFIED** *A commitments screen lists the commitments its roster keeps, in the order they were
    taken on*, *A commitments screen that cannot read its roster lists nothing and changes nothing*
    and *What a commitments screen holds about a refused change lasts until the app is shown again or
    a change is kept* — four scenarios between them reach the category through the withdrawn act and
    are retargeted at a change. One scenario body each, except the last, which has two.

## Impact

- **Seam** — `CommitmentsScreen` (`src/DayByDayKit/Sources/DayByDayKit/CommitmentsScreen.swift`),
  which already exists. `put(_:under:)` and the `RefusedChange.categorising` case are removed from
  it. `categoriesInUse`, `change(_:toName:on:keptFrom:under:)` and everything else on it are
  untouched.
- **Kit below the seam is untouched.** `Roster.put(_:under:)` and `RosterStore.put(_:under:)` stay,
  with their requirements and tests — `design.md` § *The kit below the seam keeps its `put`* says
  why, and it is a fact read out of the roster-store requirement rather than a preference.
- **Tests** — four acceptance tests are deleted with the scenarios they carry, **eight** are
  rewritten to reach the same guarantee through the change sheet, and two are added for the
  guarantees the withdrawal would otherwise leave untested. The suite goes from **1017** to
  **1015**. The delta declares **88** scenarios, of which 78 already have passing tests that must
  not be touched.
- **App shell** — `src/DayByDay/DayByDay/CommitmentsView.swift`: both lists' `.swipeActions`, the
  row tap, the category sheet, the `.categorising` refusal line and the `EditButton()`.
- **Docs** — `CONTEXT.md` § *Move* and § *Commitments screen* each carry a clause naming the row's
  *Category* action as the way to refile across groups; both are corrected. `docs/adr/1042-*.md`
  is amended in place. `docs/backlog.md` is deliberately not touched (`grill.md` § *Settled* 13).
