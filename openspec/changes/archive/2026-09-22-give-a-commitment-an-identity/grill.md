# Grill — give-a-commitment-an-identity

*9 questions over 3 rounds, 2026-09-22, one fact agent and the designer's read. The Feature grill of 2026-09-21 that
reopened `FEAT: commitment` (#26) settled the shape this Story builds — its answers are the two
2026-09-21 lines in `docs/backlog.md` § Decided (B-058, B-057) and are not re-asked here; the ones
this Story turns on are restated under § Inherited so `spec-author` reads one file.*

## Inherited from the Feature grill (2026-09-21, not re-asked)

- **A commitment has an identity of its own.** Two commitments are two however alike their parts;
  one stays itself through a rename, a rhythm change or a kept-from move. Its **eras** and every
  record against it hang off that identity, not off its value. *The four B-058 symptoms trace to
  value identity; this reverses ADR-1023, ADR-1030 and ADR-1055 in place.*
- **A rename reaches the whole commitment**: every era, every past day, the look-back. *A name is
  a label for one thing, not a fact about a day.*
- **The sheet shows one Kept from, the earliest era's, and says nowhere when the current rhythm
  began.** *Consistent with #300, where the look-back's rhythm-change line was called clutter.*
- **The roster refuses a name already in use by a kept or stopped commitment**, and no longer a
  value it already holds. *Under an identity, value equality means nothing.*
- **The roster on the phone is folded once at the upgrade.** Removed entries adjacent by name,
  kind-sort and day (kept until the day before the next's kept from, the nearest in roster order
  winning where two answer) fold as eras under the commitment in front of them; a removed entry
  that nothing kept or stopped resembles by name and kind-sort is erased with every record
  against it (*the owner's call, against the recommendation to make them stopped*); a removed
  entry that resembles a kept or stopped commitment but does not chain survives as its own
  stopped commitment, tidied by hand. *An upgrade must not erase a real era; anything else the
  owner would rather erase than sort.*
- **Not this Story's:** delete and the retirement of the removed state (#304); a same-day rhythm
  change collapsing (#305); stop and resume as era boundaries (#306). Remove, stop and resume ship
  here exactly as they are today.

## Settled

1. **What counts as the same name.** Case and blank space at the ends are ignored — "gym",
   "Gym " and "GYM" are one name for the refusal; blank space inside still matters; the name is
   stored as typed. *Two rows told apart only by a capital are not told apart on a phone.*
2. **Kept from moved into a later era.** Eras that would hold no day are dropped and the current
   era starts on the new day; days before it are not due, as today, and a record on such a day
   still refuses the move as *a day already recorded on that the change would leave not due*. *A
   rhythm that held on no day is not an era — the rule #305 applies to a same-day change.*
3. **Duplicate names the fold leaves behind.** Nothing: both survive and the owner tidies by
   hand. *The refusal governs what a person offers or renames to, never what was found on disk;
   no invented names.*
4. **The fold is silent.** No notice, no count. *The owner chose the erasure knowing what it
   erases, the stopped list shows what survived, and there is one phone.*
5. **Remove between this Story and #304.** Remove stays exactly as shipped. Its one way back —
   defining the same commitment again exactly — no longer finds it under an identity, so a
   commitment removed after this lands is unreachable until #304 turns remove into delete, whose
   upgrade erases removed entries nothing live resembles. *Accepted as the weeks-long gap it is;
   nothing extra built or unbuilt.*
6. **The refusal's words and place.** *A commitment called "Gym" already exists.* — red under the
   name field, on a define and on a rename alike, in the form #261 gave every field refusal. *It
   names the collision and the field to fix; today's "Already being kept." at the foot names
   neither.*
7. **The walk.** Four pictures in the simulator: (1) defining a second Gym — the refusal under
   the name field; (2) Gym's rhythm changed and the sheet reopened — Kept from unchanged; (3) Gym
   renamed Lifting — the look-back head with the new name, the original day kept from, and counts
   across both eras; (4) a past day drawn under the new name. One `phone:` line — the fold on the
   owner's real roster: the stopped list showing what survived, and one tangled commitment's
   look-back reading as one. *The walk starts from a fresh install and nothing seeds an old
   roster, so the simulator cannot show the fold; building seeding for one picture was declined.*
8. **Consequences read off the facts, not asked.** The *records already kept under what a change
   would produce* refusal has no target under an identity and goes; the *would leave a recorded
   day not due* refusal stays. An interval restart ends an era as a rhythm change does. Records
   already orphaned before the upgrade stay under the existing carry-back rule. Removed entries
   erased at the fold take their records with them; nothing else about the record moves except
   its key.
9. **Resume into a name collision.** Taking a stopped commitment up again is refused where a kept
   commitment already carries its name (as § Settled 1 reads names), and the refusal is said
   under the stopped row in its existing footer — *A commitment called "Test" is already kept.*
   *The name rule holds wherever a commitment becomes kept, so stopping first cannot walk around
   it; raised by the designer, who found resume has no name field and no name refusal today.*

## Layout

No layout question here — the designer's one line, after reading the shipped sheet, list and
look-back against this file. The one shell change is a caption already drawn in a shipped idiom:
the name-field refusal slot #261 gave the sheet, and the stopped row's footer for § Settled 9.
Nothing to choose between, so no mockup and no artifact. One note the designer left for
`design.md`: this is the first refusal caption whose length is unbounded, because it carries a
commitment name; it wraps and is never truncated (ADR-1022), and the seam hands the whole
sentence over already said, as every other refusal string is, rather than the shell quoting a
name itself.

## Terms landed in CONTEXT.md

- **Fold** — the one-time reading of a roster kept in the form before identities into
  commitments with eras: what chains folds, what nothing resembles is erased, what resembles
  and does not chain becomes stopped. Under **Commitment**'s 2026-09-21 amendment.

## Left open

None. Every question the frontier raised was answered, and the Feature grill's answers cover
the shape. Two things are `spec-author`'s and not open: the identity's form on disk and the
stores' new forms (design), and the in-place amendments to ADR-1023, ADR-1030 and ADR-1055, plus
the stale "nothing reads a chain" sentence under `CONTEXT.md` § *Superseding* that
`docs/open-questions.md` line 200 and the #272 landing left behind.
