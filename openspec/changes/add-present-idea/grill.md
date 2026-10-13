# Grill — add-present-idea

*14 questions over 4 rounds, 2026-10-12–13, the last the layout round, and two fact agents.*

What the Feature grill of B-078 already settled is in `CONTEXT.md` § *Present idea* and
§ *Birthdays screen* and was not re-asked: an idea is typed and read on the Birthdays screen only,
held against the contact as a birthday tick is (ADR-1062), kept unseen for a contact the calendar
no longer hands and while birthdays are off. Changing, deleting and marking given are #409;
carrying ideas in a copy is #410.

## Settled

1. **A link with no text.** Allowed: an idea is text, a link, or both. *The owner chose this over
   requiring text; a pasted link is often the whole idea.*
2. **What counts as a link.** Something that reads as a web address; a bare domain such as
   `amazon.de/xyz` is kept with `https://` in front. *Every kept link then opens, and what a person
   naturally types is not refused.*
3. **Following a link.** Tapping a kept link opens it in Safari, in this Story. *A link that cannot
   be opened is only more text.*
4. **The same idea twice for one person.** Allowed, kept as two. *A list, not a set; removing the
   extra comes with #409.*
5. **Order of one person's ideas.** As added, the newest last. *An idea never moves when another is
   added.*
6. **A Birthdays row at rest.** Says how many ideas the person has (e.g. "2 ideas") and nothing when
   there are none; the ideas themselves are behind a tap on the row. *Who has ideas is seen while
   scanning; the row stays quiet otherwise. How the ideas open is § Layout's.*
7. **Text and link both blank** (whitespace counts as blank). Nothing is kept and one line says so,
   in the manner of the commitment sheet's "Give it a name."; the button is never disabled. Both
   are trimmed before keeping.
8. **The text's shape.** One line, no length cap. *Every text field shipped is one line and none
   is capped.*
9. **Text fine, link not a web address** (e.g. "ask Anna"). The whole idea is refused with one line
   saying the link is not a web address; the fields keep what was typed. *Nothing typed is dropped
   silently.*
10. **The store cannot be read, or a save cannot be written.** The Birthdays screen still lists
    every birthday, with no counts, and says in one line that the present ideas could not be read —
    or, for a file written by a later version, the shipped "written by a newer version … must not
    be deleted" wording; adding is refused, so the file is never overwritten. A save that cannot be
    written keeps nothing, says "Not saved. Try again.", and the fields keep what was typed. *As the
    four stores before it.*
11. **Where the walk runs.** On the phone, as #407's did: no simulator here gets calendar access
    (`docs/open-questions.md`), and no stand-in calendar is built for the walk. *A test hook in the
    app would not prove the real calendar path.*
12. **What the owner walks on the phone** — all four, each a `phone:` line:
    - a real contact opened, a text idea and a link-only idea added; the row then says "2 ideas",
      the ideas in the order added;
    - Add with both blank, and with a link such as "ask Anna" — each says its line and keeps what
      was typed;
    - the link idea, typed as a bare domain, tapped — Safari opens the `https://` address;
    - the app closed from the switcher and reopened — the ideas and the count are still there.

## Facts the delta turns on

- A Birthdays-screen line carries no contact today, by requirement: `birthday/spec.md` says a line
  "SHALL NOT give back its birthday's contact" and two lines alike in words and day are the same
  line. Ideas held against the contact cannot be put on a row without amending that.
- The reader keeps only birthdays with a contact identifier, so every row has a contact; the same
  contact can be listed twice, and two contacts can draw identical lines.
- Nothing in the app opens a link today; the only outward open is "Open iPhone Settings".
- A restore touches five named places only, so a present-idea file is left as it is until #410.

## Terms landed in CONTEXT.md

None. *Present idea* and *Birthdays screen* landed at the Feature grill. The store and its place
are named while the delta is written, as *Birthday store* and *Birthday place* were (#326, #328).

## Left open

None. Every question the frontier raised was answered. The words the mockup made up — the count's
singular, the placeholders, "New idea", the refusal lines — are `spec-author`'s, as is where the
"could not be read" line sits; the designer suggests above the card, as "Some records belong to no
commitment." sits on the commitments screen.

## Layout

Option A, *own page*, chosen from three at https://claude.ai/artifact/JH4TmWqroJyi6oJF3GBfLz — *it
is how Happenings already open: the row pushes a page and "New happening" opens a sheet, and a page
has room for #409's changed and given ideas.* Every line gains a chevron, because every line opens,
including one with no ideas, where the first is added.

Asked in the same round: **a long link is drawn on one line, cut, and a tap opens the full
address.** *The start of a link says which shop; the rest is Safari's.* The mockup drew links in
full; this answer overrides it.

The designer assumed iOS 26 would cut a long large title, so the line is drawn as wrapping heading
text on the page with only a back button in the nav bar — unlike the look-back pages, which put the
name in the large title. The implementer confirms it.

The wireframe, verbatim from the designer (example data; today is Tue 13 October 2026):

```
A · Own page  (recommended)
┌──────────────────────────────┐ ┌──────────────────────────────┐ ┌──────────────────────────────┐
│ (<)                          │ │ (<)                          │ │ [Cancel]   New idea   [Add]  │
│ Birthdays                    │ │ Kate Bell's 48th Birthday    │ │ ┌──────────────────────────┐ │
│ ┌──────────────────────────┐ │ │ Sat 14 November        (3)   │ │ │ Book voucher             │ │
│ │ Anna Keller's    Today > │ │ │ ┌──────────────────────────┐ │ │ │ ask Anna|                │ │
│ │ 35th Birthday            │ │ │ │ Ceramics class voucher   │ │ │ └──────────────────────────┘ │
│ │ 1 idea                   │ │ │ │ Hiking socks, size 38    │ │ │  <refusal line, red>     (4) │
│ │ Kate Bell's  Sat 14 Nov… > (1)│ https://bergzeit.ch/socks│ (2)│ ░░░░░░░░ keyboard ░░░░░░░░░ │
│ │ 48th Birthday            │ │ │ │ https://amazon.de/xyz    │ │ └──────────────────────────────┘
│ │ 3 ideas                  │ │ │ └──────────────────────────┘ │  sheet over the person's page
│ │ …                        │ │ │ ┌ New idea ────────────────┐ (4)
│ └──────────────────────────┘ │ │ └──────────────────────────┘ │
└──────────────────────────────┘ └──────────────────────────────┘
 count dimmed under the words;    nav bar: back only; the line is
 day trailing, never wraps;       the page's heading, wrapping
 chevron on every line
```

In every option a kept link is drawn in the accent colour, and an idea with both parts shows the
text over a smaller link; a refusal is the app's existing red caption under the fields.
