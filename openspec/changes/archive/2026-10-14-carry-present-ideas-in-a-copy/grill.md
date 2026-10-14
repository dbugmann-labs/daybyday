# Grill — carry-present-ideas-in-a-copy

*11 questions over 4 rounds, 2026-10-13; one fact agent, and a layout round that drew nothing. Grilled against the two Stories that did
this for a store before, `carry-birthdays-in-a-copy` (#329) and `carry-happenings-in-a-copy` (#380),
whose questions this one re-asked rather than assumed.*

## Settled

1. **What a restore says about present ideas.** It counts them, one line on each side, given and
   not given together — "4 present idea(s)". *They are a list the person wrote, as happenings
   are, so what a restore takes away should be a number before it is confirmed. A "given" split
   was declined as more to read for little gain; the birthday ticks' count-none was declined too.*
2. **That count is every idea the place holds**, seen or not: a deleted contact's, a contact this
   phone does not have, and all of them while birthdays are off. *A restore replaces them all, and
   the count is there to show what goes; counting only what would show needs the calendar and
   understates the loss.*
3. **A copy asked for where the present-idea place cannot be read**, damaged or written by a later
   version, is refused whole and names the present ideas, whatever the birthdays switch says; the
   take-out is then offered and carries the present-idea file. *As for the other five: a copy
   without the ideas would empty them without a word when restored, and a damaged store with no
   take-out would be the only one with no rescue.*
4. **Restoring a copy made before copies held present ideas.** It reads as holding none, and the
   phone is left holding none. *A restore is never a merge; Settled 1's count shows the copy's
   zero against the phone's number before it is confirmed.*
5. **A copy holding present ideas the app never writes** — an idea with neither text nor link, a
   link that is not a web address, a malformed contact — is refused whole as a damaged copy.
   *Restoring part of it would quietly restore less than the file holds. Same call as #380.*
6. **Every present-idea change a person keeps writes a copy at the copy place, in this Story** —
   adding, changing, deleting, marking given and taking the mark back. *Otherwise the copy place
   holds stale ideas until the next commitment change.*
7. **The Birthdays screen says a copy can be restored** under its "could not be read" line for
   the present ideas, in the day screen's words and with its exception — not where the only cause
   is a file written by a later version. The day screen does not add present ideas to its own
   line. *It is where the loss is noticed; the day screen shows no present ideas, so a line there
   would be noise.*
8. **A person's page does not say it.** Only the Birthdays screen does. *The page is opened from
   that screen, so the way out is said once, one level up.*
9. **The walk.** In the simulator, from planted files: Settings refusing a copy and offering a
   take-out, both naming the present ideas (a damaged `present-ideas.json`); and the restore sheet
   with present-idea counts on both sides, the two different. On the phone: add an idea, make a
   copy, delete the idea, restore that copy, and the idea is back on the Birthdays screen.
10. **The Birthdays screen's restore line is not walked.** It needs a damaged file with birthdays
    on, which no simulator here can show (`docs/open-questions.md`, no calendar access), and the
    phone's own store is never damaged on purpose. Its seam test is the proof.
11. **The words on screen follow the five shipped stores**, "present ideas" in every slot they
    fill: "Your present ideas could not be read." in place of the phone-side count and as the
    refused copy's and the take-out's cause; "Your present ideas were written by a newer version
    of DayByDay."; "The present ideas could not be taken out."; and in the copy place's stop,
    lower case, "your present ideas could not be read" / "your present ideas were written by a
    newer version of DayByDay". *It matches the Birthdays screen's own "The present ideas could
    not be read."; asked rather than assumed, which #380 did not.*

Facts the fact agent found, which these answers rest on. The copy is at form 3 and the present-idea
store at form 2, at `present-ideas.json`. A restore in progress records and undoes six things today
and the present-idea place is not one of them, so a torn restore does not undo it yet; the restore
spec gave the birthday and happening places a "undone there too" requirement each. The take-out
carries seven files and no present-idea file. The copy place's stop persists its store by name and
reads an unknown name back as the record, so a build from before this Story shows a present-idea
stop as the record's. The present-idea store already refuses whole an idea with neither part, a
link that is not a web address and a link without a scheme; it accepts any non-blank contact key,
since contacts differ by phone. A restore onto a phone whose contacts differ matches nobody and
keeps the ideas unseen, which the Feature grill settled (`CONTEXT.md` § *Present idea*).

Not asked, because it was on disk: present ideas are carried whatever the birthdays switch says
(`CONTEXT.md` § *Present idea*); a restore that cannot be made whole leaves the present-idea place
as it was with the rest (`CONTEXT.md` § *Restore*).

## Terms landed in CONTEXT.md

None new. Dated amendments, 2026-10-13: **Present-idea store** ("in no copy until #410" no longer
holds) and **Present-idea place** (written by every kept change and by a restore, carried in a
take-out, and the Birthdays screen says a copy can be restored).

## Layout

No layout question, the designer's finding: every surface this Story reaches already has a slot for
one more line in the same form. The restore sheet adds "4 present idea(s)" after the happenings
line on each side, as #329 did for the birthday ticks; Settings' refused copy, take-out causes,
take-out refusal and copy-place stop each list the present ideas as one more store, last. On the
Birthdays screen, "A copy can be restored from Settings" is a second line in the section that
already holds "The present ideas could not be read.", drawn as the day screen draws it — caption
size, secondary grey — under that sentence, which stays body size. Nothing else moves. No mockup
was drawn.

## Left open

None. Every question the frontier raised was answered.
