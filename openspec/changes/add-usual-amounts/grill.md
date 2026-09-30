# Grill — add-usual-amounts

*7 questions over 2 rounds, 2026-09-30, and a layout round of 2. The Story was groomed the same day as
B-071 at the Feature grill of cluster B (ten questions over three rounds); what that grill settled
is carried below as 1–6, because it is the ground this one stood on and it is recorded nowhere
else as answers — the Decided line in `docs/backlog.md` and `CONTEXT.md` § *Usual amount* hold it
as prose.*

## Settled

*Carried from the Feature grill of B-071:*

1. **Where a total's usual amounts come from.** Declared on the commitment, on the commitments
   screen's sheet, each an amount with a name if one is given (*Müesli*, 35). *Recommended as
   declared rather than worked out from the record, so a button never moves under a thumb; the
   name was the owner's addition.*
2. **Where they are offered.** Inside the total entry, beside its field, which stays for an amount
   that is not usual. *The row at rest stays name and check, as the owner asked on #324.*
3. **What a tap keeps.** An addition like a typed one: the day keeps the amount and never the name.
   *Keeping the name would make the total a log of what was eaten, a different want.*
4. **Undoing a mis-tap.** *Take back last*, unchanged, and no confirmation before a tap adds.
5. **Totals only.** *A number replaces its day; its repeats are the starting number's and the
   short range's already.*
6. **Commitment-wide, not per era.** Changing a usual amount puts no new era on the commitment.
   *They are about how an amount is added, not what a day owes.*

*This grill:*

7. **How many.** Five; the sheet refuses a sixth. *The owner asked for five if five fit in the entry
   without scrolling and four otherwise, over the recommended four; the layout chosen below holds
   five with room to spare, and the walk shows it with the keyboard up. A walk that has to scroll
   to reach the fifth is a G7 finding against this answer, not a licence to scroll.*
8. **Two usual amounts with one amount.** Allowed where their names differ; two that would draw the
   same — the same amount and the same name, or the same amount and both unnamed — are refused.
9. **Order in the entry.** Smallest amount first; among equal amounts the unnamed one first, then
   by name. *No reordering control is needed on the sheet; the tie was found by the designer and
   asked in the layout round.*
10. **After a tap.** The entry closes, exactly as it does after its field is committed; a second
    Müesli is the row tapped again. *One addition per opening, as typing is.*
11. **A stopped commitment.** Its usual amounts can be changed, as its name and category can.
    *All three belong to the whole commitment; a stopped total is ready when resumed.*
12. **Two names that are one.** Judged exactly as two commitment names are: the same where they
    differ only in the case of their letters or in blank space at either end. A blank name is no
    name. Otherwise a name is kept as given, with no length limit, as a commitment's is.
13. **The walk.** Four pictures — the commitment sheet declaring two usual amounts, one named and
    one not; the total entry offering them, five of them with the keyboard up and nothing scrolled;
    the day row's sum after a tap; one refusal on the sheet (a duplicate, or a sixth). Two `phone:`
    lines: a usual amount tapped on the phone, then *Take back last* undoing it; and the entry
    opening with the keyboard already up, which the owner may ask to have reverted once they have
    used it (§ *Layout*).

## Facts the answers stand on

Dispatched, not asked. A usual amount's amount is read as a target is — the one reader both screens
share, above zero, at most thirty-eight significant digits — and a tap that would carry the day's
sum past what can be added is refused as a typed amount is. The total entry today says one thing
(*so far of target*) and offers Save, Take back last and Cancel in a system alert, and day-screen's
*A total entry says the day's sum and the commitment's target, and says nothing else* is the
requirement the offer has to change. A commitment's kind is fixed, a stopped one changes in name and
category only, and a rename writes the name on every era and leaves a listed set of fields as they
were. The copy nests the roster whole and `restore` lists no roster field; the roster store's
*reads every form … before the one it writes now* is where a new form is named.

## Terms landed in CONTEXT.md

- **Usual amount** — landed at the Feature grill of B-071, on `main` since #363. Nothing new at this
  grill.

## Left open

None. The count is five (7), the order is total (9), and the one thing the owner may still reverse —
the keyboard rising as the entry opens — is a `phone:` line at G7 rather than an open question: the
answer is up, and the layout carries it.

## Layout

Option C, a half-height sheet holding the usual amounts as list rows, chosen from three at
https://claude.ai/artifact/PSyixPF6zQg3RgjgJkQVLp — *the only option that holds five without
scrolling, and a name of any length wraps rather than being cut.* **With one change the owner made:
the keyboard rises as the sheet opens** (region 6), where the designer drew it down until the field
is tapped — "only if I dislike it then on the phone, I may want it reverted". C replaces the system
alert the total entry is today; draft PR #361 (`chore/entry-sheet`), set aside by the owner, moved
the same entry to a sheet, and the two now collide on it if #361 is revived.

The wireframes follow, verbatim from the designer, except the keyboard note on the field.

The total entry, as it opens (the day screen dimmed behind it, its top half in view):

```
┌──────────────────────────────┐
│ [dimmed day screen, top half]│
│╭────────────────────────────╮│
││            ▬▬              ││
││ (Cancel)   Protein   (Save)││  title = row name
││           30 of 120        ││  subtitle = soFarOfTarget
││ ┌────────────────────────┐ ││
││ │ Amount                 │ ││  focused as the sheet opens; keyboard up (owner's change)
││ └────────────────────────┘ ││
││ ┌────────────────────────┐ ││
││ │ 20                     │ ││  amount column, then name;
││ │ 30   Shake             │ ││  smallest first; tap adds
││ │ 35   Müesli            │ ││  and closes
││ │ 40   Greek yoghurt     │ ││
││ │ 45   Chicken breast    │ ││
││ └────────────────────────┘ ││
││ ┌────────────────────────┐ ││
││ │ Take back last         │ ││  red
││ └────────────────────────┘ ││
│╰────────────────────────────╯│
└──────────────────────────────┘
```

The commitment sheet — the usual amounts in a card of their own, under the first:

```
 (Cancel)   Change Protein   (Save)
┌──────────────────────────────┐
│ Protein                      │
│ [Tick|Number|Note|•Total]    │
│ 120                          │
│ Category (optional)       ⌃⌄ │
└──────────────────────────────┘
┌──────────────────────────────┐
│ 20       Name                │
│ 30       Shake               │
│ 35       Müesli              │
│ 40       Greek yoghurt       │
│ 45       Chicken breast      │
│ 50       Rice                │
│ ‹refusal under the row›      │
│ Add usual amount             │
└──────────────────────────────┘
┌ [Weekdays|Monthly|Every N|Per week] …
```

The figures are examples. "Add usual amount", the "Name" placeholder and the refusal's words are the
shell's placeholders, not the seam's; the refusal's words are `spec-author`'s, beside "A commitment
called … already exists."

**Amended 2026-09-30 at G7, from the owner's phone walk.** The keyboard does **not** rise as the
entry opens — the owner reversed their own change once used, as W.6 left room for, so the entry is
option C as the designer drew it: the field focused only when tapped. The same walk asked for a
tighter sheet (less space under the head, around the usual amounts, and lower rows, so the five sit
closer) and for *Add usual amount* to be offered no longer once five rows are on the sheet.
