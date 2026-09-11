# 1038. A category is the roster's, and the grouping rule with it

- Status: accepted
- Date: 2026-09-08
- Deciders: Diego Bugmann
- Amended: 2026-09-10 — three corollaries of this decision are written down here by
  `condense-commitment-spec` (#204), which deletes the requirement prose that carried them: a roster
  store never writes the groups, the categories in use are offered rather than case-folded, and a
  change that touches both places is one act on the roster.

## Context

B-029's want — *"put my commitments into categories"* — needs one thing decided before anything can
be written down: **where does a commitment say what it is filed under?** A category is a word a
person types beside a commitment, and the obvious place to put it is on the commitment, beside the
name and the schedule and the kind.

That place is spoken for twice over, and the two records read together look like a precedent for
using it again.

**ADR-1023 refused a fourth part** for *kept until*: a tick embeds the whole commitment by value, so
a part of a commitment that changes re-keys every record already written against it, orphaning the
history on every day it was ever kept. *Kept until* is held one level up, on the roster's entry, for
exactly that reason.

**ADR-1030 then allowed a fourth part** for the **kind**, on two grounds it stated carefully: a kind
never changes once a commitment is defined, and every commitment older than kinds is a tick, so
nothing already recorded is re-keyed and nothing already kept reads back differently.

A reader arriving at a category sees a fourth-part refusal and a fourth-part exemption and no rule
saying which applies. This record says which, so the fifth part is refused for a reason rather than
by habit — and it says one thing more, because deciding where the category lives also decides where
**grouping** is worked out.

## Decision

**A category is held by the roster, against each commitment, and never by the commitment. A
commitment stays four things.**

ADR-1030's exemption turns on one axis and a category sits at the far end of it. **A kind never
changes; a category is a label a person is expected to move.** Refiling a commitment from
*supplements* to *morning* is an ordinary Tuesday, and it is the whole of what the want asks for —
so a category on the commitment would re-key every record already written the moment a person used
the feature it was built for. That is ADR-1023's argument arriving intact, and ADR-1030's second
ground does not rescue it either: reading an older file back with "under no category" reproduces
what was there, but it is the *changes after* that do the damage, not the read.

So a category joins the day a commitment was **kept until** and the fact that one was **removed** on
the roster's entry: three things a roster holds about a commitment, none of them the commitment's.

**And the grouping rule is the roster's too, for the same reason and one more.** The roster is the
one thing that holds both the person's order and the categories, so it is the only place that can
answer "which groups are there, and where does each sit" without a second copy of anything. It
answers in **groups**: a group sits where its first commitment sits in the order the person set, the
commitments under no category come last as a group with no category, and within a group the
commitments are in the roster's own order.

Both screens then draw what they are handed. That is what leaves
`day-screen/spec.md`'s oldest promise — *"A day view is in the order it was handed its commitments…
The day view SHALL NOT impose an order of its own"* — **untouched by categories entirely**. The day
view's only contribution is a rule that is genuinely its own: a group with nothing due on the date
is not drawn, because a day view says what a date asks of you.

**A roster store never writes the groups.** The grouping rule being the roster's reaches storage:
groups are a reading of the roster's one order, worked out again on every read, so a store that wrote
them would keep the same fact twice and could read a file back whose groups disagreed with the order
beside them. ADR-1031 governs which forms a store reads and what each reads back as; it says nothing
about what a form may hold, so this corollary belongs to the grouping rule rather than to it.

**Offering the categories in use is a safety mechanism, not a convenience.** A phone capitalises the
first letter of a field, so "Supplements" typed once and "supplements" typed the next time would
silently become two groups. The alternative — folding case when matching — has the app decide which
of a person's spellings they meant, and the word is the person's by the decision above. Offering the
words already in use removes the problem instead of judging them, and a word matching none of them is
taken exactly as typed and becomes a group of its own.

**A change that touches both places is still one act on the roster.** Changing a commitment reaches
the record place as well, because the records already written are carried over to the changed
commitment; it is nonetheless one of the acts this record enumerates, and what a commitments screen
holds about a refused change ends once a change is kept, however many places that change touched.

## Consequences

- **Refiling re-keys nothing.** Every record already written stands, on every day, whatever a person
  does to their categories afterwards. This is the property the whole decision exists to buy.
- **Two commitments alike in name, schedule, kept-from day and kind are one commitment however they
  are filed.** A category is not part of what makes two commitments the same one, so a roster
  keeping a commitment refuses that same commitment offered again whatever category comes with it,
  and offering one under a new category does not add a second copy.
- **A commitment the roster has stopped keeping or removed goes on being under the category it was
  under.** A category cuts across the three states rather than adding a fourth.
- **Changing a category is an act on the roster**, beside taking a commitment on, stopping keeping
  one, removing one and moving one — and it is refused on a commitment the roster is not keeping,
  exactly as a move is, because a stopped commitment is not on the list a person is filing things on.
- **The grouping rule exists once.** The commitments screen and the day screen cannot disagree about
  where a group sits, in the same way and for the same reason ADR-1037 left them unable to disagree
  about the order.
- **The roster file gains a field and a form.** `RosterDocument` moves to form 4 with a `category`
  on every entry; a roster written at any earlier form reads back with every commitment under no
  category. That fires ADR-1031's own reversal trigger, and that record is amended in place rather
  than stretched.
- **A commitment offered to a roster now has two forms.** One says a category, and what it says wins
  — which is how a category is taken off while a commitment is taken up again. One says nothing at
  all, and leaves the category alone — which is what a commitments screen's one tap on a stopped
  commitment needs, and what day one uses. There is deliberately no third.

## Alternatives considered

**A fifth part on `Commitment`.** Rejected on ADR-1023's argument, above. It is the cheapest thing
to write and the most expensive thing to have written: the first time a person refiles a commitment,
every tick, number, note and total recorded against it becomes a record of a commitment that no
longer exists.

**A category held on the commitment but excluded from its equality.** Rejected as worse than either
honest option. It keeps the word next to the thing it describes and then quietly says the word is
not part of the thing, so two commitments a person filed differently would compare equal while
reading differently — and a record embedding one of them by value would embed a category it then
ignores.

**A list of categories held somewhere, with commitments pointing at entries in it.** Rejected as
premature and as a second thing to keep in step. The categories that exist are exactly the words the
roster's commitments carry, so a word whose last commitment lets it go stops existing with no delete
to perform, and a rename-everywhere is retyping a word on each commitment — offered at the grill and
declined. If renaming across many commitments turns out to bite, it is a want with its own refusals,
not a shape this decision has to anticipate.

**Grouping worked out by each screen from a flat list of commitments-and-categories.** Rejected for
the reason ADR-1037 rejected a screen-held order: two screens holding one rule is two places it can
disagree, and it would have made the day view — which has invented no order since `add-day-view`
(#70) — invent one.

**Several categories per commitment.** Rejected at the grill: a grouped screen would then have to be
told which group a row belongs to, and four of the owner's day-one commitments are in no category at
all, so being in none is already an ordinary state rather than the thing several would fix.
