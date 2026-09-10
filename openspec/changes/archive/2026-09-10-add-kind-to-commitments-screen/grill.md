# Grill — add-kind-to-commitments-screen

*10 questions over 3 rounds, 2026-09-10.*

The commitments screen is the last thing in the product that does not know about kinds. A
commitment has carried one since `add-commitment-kind` (#137), every kind's record and every
kind's row have shipped (#138–#141), and the screen still defines only the plain kind — which is
why `docs/open-questions.md` records that a total commitment is a state nothing in the shipped app
can reach. This Story spends the last of that.

`openspec/specs/commitment/spec.md:215` names this Story in advance and settles its shape: the
screen's refusal of a bad range is "that refusal surfaced rather than a second one". Most of what
follows is that sentence applied.

## Settled

### What the form takes

1. **The form offers the four kinds, and offers the tick kind for a new commitment.** *The day-one
   week is nine ticks, a tick is the common case, and every commitment written before kinds existed
   reads back as a tick — the form's default matching the store's migration default keeps one
   meaning across both. A weight or a note is the deliberate choice and should cost the tap.*
2. **The screen takes a range end and a target as the person typed them, and judges them itself.**
   *Chosen over being handed numbers the app shell had already formed, so that "that is not a
   number" is a refusal a person reads rather than a field the shell silently blocks, and so the
   shell goes on deciding nothing. This departs from the shape a **rhythm** number arrives in —
   three of the four rhythms carry a number the shell has already made, and the screen judges only
   its range — and matches the shape a **number entry** arrives in on a day screen instead
   (`DayScreen.read(_:)`). The departure is deliberate and is owed an explanation in the delta.*
3. **Both range fields blank is no range; one filled and one blank is refused.** *Two spaces and an
   untouched field say the same thing — this commitment declares no range — so clearing a range is
   not a delete-every-character operation. Filling one end and not the other is not: a typed floor
   is something the person deliberately entered, and reading it as "no range at all" throws it
   away. Blank is judged by ADR-1039's one test, so a zero-width space is a character and still
   refuses.*
4. **A range or a target left in the fields when the chosen kind has no room for it is ignored, not
   refused.** *A person who typed a range and then chose Note is not asking for a range, and
   refusing something they did not ask for is noise. Held against answer 3 deliberately: there the
   person had chosen the number kind and the bound was meaningful.*

### What it refuses, and in how many words

5. **The screen refuses exactly what the value refuses, and invents nothing.** A range whose lowest
   is above its highest, a range end that is not a number, a half-written range, a target that is
   not above zero, a target missing from a total. *`openspec/specs/commitment/spec.md:215` already
   assigns this to #142 as the value's refusal surfaced. This is the opposite of the empty weekday
   set, which is the screen refusing what the engine accepts.*
6. **A target below one is a target.** *The Story issue's intent sentence says the screen refuses
   "a target below one"; the shipped spec has an approved scenario that 0.5 is a target — "0.5 of a
   dose is a target a person can mean" — and another that 0.0001 forms. Rule 4 gives it to the
   spec, and the owner confirmed the issue's wording is loose for "not above zero". **The issue's
   intent sentence should be corrected**, and that is `orchestrator`'s, not this delta's.*
7. **Two new reasons, not five and not one: a range that is not a range, and a target that is not a
   target.** *ADR-1021's rule as `A commitments screen refuses a rhythm number the calendar will not
   take` already applies it — three ways to fail are one refusal there, because what a person does
   about any of them is the same thing. Every way a range fails sends them back to the same two
   fields; every way a target fails sends them to the one.*

### The kind on a change

8. **A change still takes four things, and the kind carries forward.** *The kind is not editable, so
   nothing can differ, and a fifth argument would create a refusal for a state the form cannot
   produce. `openspec/specs/commitment/spec.md:5133` already requires the changed commitment to be of
   the kind the one it replaces is of. The sentence "the same four things it defines one from" is
   now false and must be rewritten to name them.*
9. **The screen says a commitment's kind, with its range or target, when asked what it is made of;
   the sheet shows it and does not let a thumb into it.** *#148 answer 21 settled the neighbouring
   case this way — a stopped commitment's sheet shows every control with rhythm and kept-from not
   editable, because "hiding half the controls makes it read as a different form". Someone opening
   "Mood" should see Number, 1–10, rather than a sheet that has quietly lost two fields since they
   defined it. This **modifies** `A commitments screen says what a commitment it is asked to change
   is made of`, which today says the kind "is not said here".*

### Scope

10. **Changing a range or a target is out of scope and is a want.** *A range is part of what a
    commitment is — two number commitments differing only in their range are different commitments —
    so changing one would have to supersede, exactly as a rhythm change does, with a new refusal set
    and a widened change sheet. This Story is about defining. Captured as a want rather than
    carried.*

## Owed to `spec-author`, and not open questions

- **The debt from #137's second review is paid here, against the owner's decision at round 2 and
  against the recommendation.** `docs/open-questions.md` owes it to "whichever Story next touches
  `commitment`'s roster or store requirements", which this Story does not — the owner took it
  anyway. Two scenarios: the roster store's refusal of a half-written range, which has no scenario
  of its own, and a roster scenario for two commitments alike but for the kind that does **not**
  add the same range twice. The open-questions entry closes with them.
- **Three shipped sentences this contradicts must be amended rather than left to disagree**:
  `openspec/specs/commitment/spec.md:1956` (the form takes "four things and no others", "which is
  why they are four rather than five"), `:5038` (the kind "is not said here"), and `:5087` ("the
  same four things it defines one from").
- **`A kind SHALL be one of four, and all four SHALL be offered`** follows the shape the rhythm
  already has at `:1982`, rather than being left to the app shell.
- **Whether answer 2 is owed an ADR** is `spec-author`'s call, not decided here. It is a departure
  from how a rhythm number reaches this screen, in the same act, and "surprising" is one of the
  three triggers the Definition of Done names.
- **The seven kinds of refused change do not become nine.** Answers 5 and 7 add refusal *reasons*,
  not kinds of change, so `A commitments screen holds the change it refused and why` and its "the
  seven are counted here and numbered nowhere else" are untouched.

## Terms landed in CONTEXT.md

No new terms. **Kind**, **Range**, **Target**, **Number**, **Note** and **Total** were all agreed
on 2026-09-06 at the Feature grill of `FEAT: record` (#53) and are unchanged by this Story.

Two existing entries need amending, which is `spec-author`'s:

- **Commitments screen** — it now defines a commitment from five things rather than four, and the
  2026-09-09 amendment's reasoning that they are "four rather than five" is withdrawn. What it says
  a commitment is made of now includes the kind.
- **Kind** — a row has read it since #137; a commitments screen now writes it.

## Left open

None. Every question the frontier raised over three rounds was answered.
