# Grill — add-commitment-category

*21 questions over 5 rounds, 2026-09-08.*

## Settled

1. **A category is the person's own word, not one the app names.** Typed the way a
   commitment name is typed. *No fixed menu holds the day-one week — creatine, magnesium,
   nails, public pool, yuno, finances, contact lenses — and `CONTEXT.md` § Commitment name
   already says the words are "the owner's own words rather than the system's".*
2. **At most one category per commitment: none, or one.** *Four lines of the day-one week are
   neither supplement nor habit, so being in no category is a normal state and not a gap;
   several would leave a grouped screen asking which group a row belongs to.*
3. **A category is set on the form that defines a commitment, and changed afterwards.** *B-029's
   trigger says "once, when a commitment is defined; and again whenever a list of them is read",
   and the Story's intent says changeable. The thinner only-afterwards slice was offered and
   declined.*
4. **The category is held by the roster, against each commitment, and never by the commitment.**
   *Not a question at this grill — the fifth grooming pass settled it on ADR-1023's argument: a
   tick embeds the whole commitment by value, so a fifth part a person can change would re-key
   every tick already recorded. ADR-1030 let the kind be a fourth part only because a kind never
   changes; a category does. An ADR is owed for this and is `spec-author`'s to write.*
5. **The form offers the categories already in use.** A person picks one of them or types a new
   one. *Asked because iOS autocapitalises: "Supplements" typed once and "supplements" the next
   time would silently become two groups. Offering what is in use removes the problem rather than
   having the app judge the owner's words — folding case would make the app choose which spelling
   a heading shows.*
6. **A category of nothing but blank space means no category, and is not refused.** *Unlike a
   name, a category is optional, so emptying the field is how a category is taken off. One fewer
   refusal for the screen to hold and say.*
7. **A category with no commitment carrying it stops existing.** The categories in use are exactly
   the words on the roster's commitments. *There is no second list of categories to hold, store,
   or delete a word from.*
8. **There is no rename-everywhere act.** Changing a word across five commitments means retyping
   it on each. *Offered and declined: a rename is a roster act of its own, with its own refusals,
   and it is a want if it turns out to bite.*
9. **The commitments screen groups its kept list by category.** *Recommended against — #146 had
   just made that list's order the person's own — and chosen anyway. It is what B-030 asked for,
   one screen earlier than B-030 asked for it.*
10. **The day screen groups its rows the same way.** *Recommended against as scope, and chosen:
    this Story now spans `commitment` and `day-screen` and answers B-030 outright. See
    § Left open.*
11. **Both screens place groups the same way: a group sits where its first commitment sits in the
    order the person set, and the commitments in no category come last, with no heading.**
    *Ordering the groups alphabetically would be a rule about the owner's own words, which is the
    argument #146 used against sorting the roster at all. Uncategorised-first was recommended, so
    that a screen with no categories yet looks exactly as it does today, and declined.*
12. **A group with nothing due today does not appear on the day screen.** *A day view already draws
    only what is due, so an empty group would be a claim about the day rather than about what a
    person keeps.*
13. **The stopped list is not grouped.** One flat list, as today. *It is not scanned daily, and
    grouping doubles the screen's structure for the list that needs it least.*
14. **Dropping a row under another group's heading gives it that category, and lands it where it
    was dropped.** *Recommended against — it makes a drag mean two things — and chosen: one
    gesture doing what it looks like it does. So a drop is a move and a category change together,
    and the category field is no longer the only way a category changes.*
15. **Dragging a row into the uncategorised rows at the end clears its category.** *Symmetric with
    the drop into a group, and the only drag that undoes a drag.*
16. **The drag is the commitments screen's alone.** The day screen draws groups and changes
    nothing. *#146 put the drag where a person manages what they keep; the day screen is what a
    day asks of you, which "entered where you stand" protects.*
17. **Giving a commitment a category moves it on screen but not in the roster.** A row seventh in
    the order, given a category whose first member sits second, is drawn in that group's block —
    and clearing the category returns it to seventh, where it never stopped being. *Nothing but a
    drag ever changes the roster's order.*
18. **A category may be changed only on a commitment the roster is keeping.** On a stopped or a
    removed one it is refused and said, exactly as moving one the roster is not keeping is. *A
    stopped commitment keeps the category it had.*
19. **Taking a stopped commitment up again with a different category typed on the form takes the
    typed one.** *The person is looking at the form now. Its place and its history are restored as
    they already are; the category is the roster's, so nothing recorded is re-keyed either way.*
20. **Two things were not asked, because the shipped spec already answers them.** A roster keeping
    a commitment still refuses that same commitment offered again, category or no category — the
    category is on the entry, not on the commitment, so it is not part of what makes two
    commitments the same one, and the screen has a control for changing a category. And a category
    is judged for saying something and for nothing else — no length limit, no restricted script,
    no reserved word — because that is what `CONTEXT.md` § Commitment name already says about the
    owner's own words.

## Terms landed in CONTEXT.md

- **Category** — the word a person put a commitment under, held by the roster against that
  commitment and never by the commitment itself; at most one, and a commitment may have none.
- **Roster**, amended — a roster also holds, for each commitment, the category it is under.
- **Roster store**, amended — it keeps that category, and a roster written before categories
  existed reads back with none.
- **Commitments screen**, amended — its kept list is grouped by category, it offers the
  categories in use, and its drag now sets one.
- **Day view**, amended — its rows are grouped by category, and a group with nothing due does
  not appear.
- **Move**, amended — a move made by dropping a row into another group also sets that row's
  category.

## Left open

1. **B-030 is answered by this Story and is still a want in `docs/backlog.md`.** The fifth
   grooming pass parked it behind B-029 and expected it to be its own Story; the day-screen
   answer at Q9 absorbed it instead. Moving it to *Decided* against this Story is the next
   grooming pass's, not this Story's — nothing in the delta depends on it. Recorded here so the
   pass does not have to reconstruct why.
2. **An ADR is owed and is `spec-author`'s**, amending or citing ADR-1023 and ADR-1030: why a
   category is the roster's when the kind is the commitment's. It is not left open in the sense
   of being undecided — the decision is settled at § Settled 4 — only unwritten.

Everything the frontier raised was answered.
