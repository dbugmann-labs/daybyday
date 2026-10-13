# present-idea Specification

## Purpose
TBD - created by archiving change add-present-idea. Update Purpose after archive.

## Requirements

### Requirement: A present idea's link is kept only where it reads as a web address, with https:// in front where it names no scheme

A link SHALL read as a web address exactly when it holds no blank space and, after an optional
"http://" or "https://" in any mix of capitals and small letters, begins with a host — two or more
parts joined by single dots, each one or more letters, digits or hyphens, the last letters alone and
at least two long — followed by nothing, or by "/", "?" or "#" and whatever comes after. A link
naming neither scheme SHALL be kept with "https://" in front, and any other exactly as typed once
trimmed. Making an idea whose link says something and does not read as a web address SHALL be
refused as a link that is not a web address, whatever its text, and no idea SHALL come of it. A kept
link SHALL open exactly the address it says.

#### Scenario: a link that names no scheme is kept with https:// in front, and opens that address

- **WHEN** a present idea is made from an empty text and the link "amazon.de/xyz"
- **THEN** it holds the link "https://amazon.de/xyz", and opens the address "https://amazon.de/xyz"
- **AND** one made from the link "www.galaxus.ch" holds the link "https://www.galaxus.ch"
- **AND** one made from the link "müller.de" holds the link "https://müller.de", and opens the
  address "https://müller.de"

#### Scenario: a link that names http or https is kept exactly as typed

- **WHEN** a present idea is made from the text "Hiking socks" and the link
  "HTTP://Bergzeit.ch/socks?size=38#top"
- **THEN** it holds the link "HTTP://Bergzeit.ch/socks?size=38#top", and opens that address
- **AND** one made from the link "https://amazon.de/xyz" holds the link "https://amazon.de/xyz"

#### Scenario: a link that does not read as a web address is refused, whatever the text

- **WHEN** a present idea is made from the text "Book voucher" and the link "ask Anna"
- **THEN** making it is refused as a link that is not a web address
- **AND** with the links "amazon", "amazon.de/a b", "ftp://amazon.de", "anna@example.com",
  "amazon.d3" and "amazon..de" in its place, each is refused the same way
- **AND** one made from an empty text and the link "ask Anna" is refused the same way

### Requirement: A present-idea store keeps each contact's ideas at a place, in the order added, across the app being closed and opened again

A present-idea store SHALL be opened at a place and SHALL hold present ideas against contacts: every
idea added there and not deleted, each given or not, under the contact it was added to, each contact's ideas in the order added, the
newest last. Two ideas alike added to one contact SHALL both be held. It SHALL be a store of its
own, holding nothing another store holds. Opening a store where nothing has been kept SHALL hold no
ideas rather than give an error. Every idea SHALL be kept at that place before the store reports it
kept, and nothing SHALL be held only in memory. An idea that cannot be kept SHALL be refused and not
held. An idea added to a contact that says nothing SHALL be refused without an error and SHALL leave
the place untouched. Stores at different places SHALL be independent.

#### Scenario: a present-idea store opened where nothing has been kept holds no ideas

- **WHEN** a present-idea store is opened at a place where no present-idea store has ever been kept
- **THEN** it opens without error
- **AND** it holds no ideas against the contact "kate"

#### Scenario: a present-idea store opened again holds each contact's ideas in the order added, two alike both held

- **WHEN** the ideas "Ceramics class voucher", then "Hiking socks, size 38" with the link
  "https://bergzeit.ch/socks", then "Ceramics class voucher" again are added to the contact "kate"
  in a present-idea store, and an idea of the link "https://amazon.de/xyz" alone to the contact
  "john", and a second store is then opened at the same place with the first still open and nothing
  else done to it
- **THEN** the second store holds those three against "kate", in that order
- **AND** it holds the one against "john"
- **AND** it holds none against the contact "anna"

#### Scenario: a present idea that cannot be kept is refused and not held

- **WHEN** a present-idea store is opened at a place where nothing can be written — a path beneath
  an existing ordinary file — and the idea "Book voucher" is added to the contact "kate"
- **THEN** adding it is refused with an error
- **AND** the store holds no ideas against "kate"
- **AND** a store opened afterwards at the same place holds none against "kate"

#### Scenario: a present idea added to a contact that says nothing is refused and leaves the place untouched

- **WHEN** the idea "Book voucher" is added to the contact "kate" in a present-idea store, and the
  idea "Ceramics class voucher" is then added to a contact of blank space alone
- **THEN** the second addition is refused without an error
- **AND** the content at that place is byte-for-byte what it was after the first addition

#### Scenario: present-idea stores at different places are independent

- **WHEN** the idea "Book voucher" is added to the contact "kate" in a present-idea store at one
  place, and a present-idea store is opened at a different place where nothing has been kept
- **THEN** the second store holds no ideas against "kate"
- **AND** a store opened afterwards at the first place holds "Book voucher" against "kate"

### Requirement: A present-idea store that cannot be read is refused rather than emptied

Opening a present-idea store at a place holding something this app cannot read as one SHALL be
refused with an error, and the store SHALL say which of two causes it is: content that is not such a
store, or a store written in a form later than the one this app writes. The store MUST NOT hold no
ideas instead, overwrite or delete what is there, or keep the part that could be read: the whole
SHALL be refused and what is there left unchanged. A store holding what could not be held — a
contact that says nothing, an idea whose text and link both say nothing, a text or a link with blank
space at either end, or a link that does not read as a web address or names neither scheme — SHALL
be content that is not such a store.

#### Scenario: content that is not a present-idea store is refused and left as it was

- **WHEN** a present-idea store is opened at a place holding content that is not a present-idea
  store — a run of bytes that is not what the store writes
- **THEN** opening is refused with an error saying it is not a present-idea store
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a present-idea store written in a later form than this app knows is refused

- **WHEN** a present-idea store is opened at a place holding a present-idea store written in a form
  one later than the form this app writes, holding no ideas
- **THEN** opening is refused with an error saying it was written in a later form
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a present-idea store holding what could not be held is refused

- **WHEN** a present-idea store is opened at a place holding a store in the form this app writes,
  whose one idea, "Book voucher", is held against a contact of blank space alone
- **THEN** opening is refused with an error saying it is not a present-idea store
- **AND** a store whose one idea, against the contact "kate", has neither a text nor a link is
  refused the same way
- **AND** so is one whose one idea against "kate" has the text " Book voucher "
- **AND** so is one whose one idea against "kate" has the link "ask Anna", and one whose one idea
  against "kate" has the link "amazon.de/xyz"
- **AND** the content at each place is byte-for-byte what it was before

### Requirement: The app keeps present ideas at a place of its own

The app SHALL name the place present ideas are kept at: one file inside the directory belonging to
this app within the platform's application-support directory, the same place every time it is asked
for, and never the caches directory or the temporary directory. It SHALL be none of the places the
record, the roster, the one-offs, the birthday ticks, the happenings and the birthday switch are kept
at.

#### Scenario: the present-idea place is a file of the app's own under Application Support, the same every time

- **WHEN** the place present ideas are kept at is asked for twice
- **THEN** the two are the same place
- **AND** it is one file inside a directory of this app's own within the platform's
  application-support directory, not inside the caches directory and not inside the temporary
  directory
- **AND** it is none of the places the record, the roster, the one-offs, the birthday ticks, the
  happenings and the birthday switch are kept at

### Requirement: A Birthdays screen line says how many present ideas its contact has

A Birthdays screen SHALL be opened with a present-idea place, and SHALL read it when it is opened and
each time it is shown again, whatever its birthday switch, and at no other moment. Each line SHALL
say how many ideas not given that place holds against its birthday's contact: "1 idea" for one, the number
followed by a space and "ideas" for more, and nothing for none, so a contact whose every idea is given SHALL say nothing and every line of one contact SHALL
say the same. Opening a Birthdays screen, showing it again and reading what it lists SHALL write
nothing at its present-idea place, and ideas held against a contact its calendar does not hand SHALL
be kept there and said on no line.

#### Scenario: a Birthdays screen line says how many present ideas its contact has, and nothing for none

- **WHEN** a present-idea place holds three ideas against the contact "kate" and one against the
  contact "john", and a Birthdays screen is opened at it as of Tuesday 13 October 2026 with birthdays
  on and a calendar handing the contact "anna"'s birthday worded "Anna Haro's Birthday" on
  13 October 2026, the contact "kate"'s worded "Kate Bell's 48th Birthday" on 14 November 2026,
  handed twice, and the contact "john"'s worded "John Appleseed's 40th Birthday" on 5 June 2027
- **THEN** Anna's line says nothing of ideas
- **AND** both of Kate's lines say "3 ideas"
- **AND** John's line says "1 idea"

#### Scenario: ideas against a contact the calendar does not hand are kept, and said once it hands that contact

- **WHEN** a present-idea place holds two ideas against the contact "anna", and a Birthdays screen is
  opened at it as of Tuesday 13 October 2026 with birthdays on and a calendar handing only the
  contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026
- **THEN** its one line, Kate's, says nothing of ideas
- **AND** the content at that place is byte-for-byte what it was before
- **AND** after the calendar also hands the contact "anna"'s birthday worded "Anna Haro's Birthday"
  on 1 March 2027 and the screen is shown again as of that same day, Anna's line says "2 ideas"
- **AND** a Birthdays screen opened at that place with birthdays off lists nothing, and the content
  at that place is still the same

#### Scenario: a Birthdays screen line counts only its contact's ideas not given

- **WHEN** a present-idea place holds the ideas "Ceramics class voucher", "Hiking socks, size 38" and
  "Book voucher" against the contact "kate", the second given, and the idea "Scarf" against the
  contact "john", given; and a Birthdays screen is opened at it as of Tuesday 13 October 2026 with
  birthdays on and a calendar handing the contact "kate"'s birthday worded "Kate Bell's 48th
  Birthday" on 14 November 2026 and the contact "john"'s worded "John Appleseed's 40th Birthday" on
  5 June 2027
- **THEN** Kate's line says "2 ideas"
- **AND** John's line says nothing of ideas

### Requirement: A Birthdays screen gives back a line's present ideas and adds one to its contact

A Birthdays screen SHALL give back the ideas its present-idea place holds against a line's contact,
whatever else the line says: those not given in the order added, then those given in the order
added. It SHALL add an idea made from a typed text and a
typed link to a line's contact, last, kept at its present-idea place before the screen reports it
kept, and every line of that contact SHALL then say the new count at once, without its calendar being
asked again. An add SHALL be refused, and nothing written, as an idea that says nothing or as a link
that is not a web address wherever making that idea is refused so, and as not kept where the place
cannot be written, in which case nothing SHALL be held.

#### Scenario: an idea added through a Birthdays screen is kept against its line's contact, last, and its count says so at once

- **WHEN** a present-idea place holds the idea "Ceramics class voucher" against the contact "kate";
  a Birthdays screen is opened at it as of Tuesday 13 October 2026 with birthdays on and a calendar
  that records every ask and hands, whatever it is asked for, the contact "kate"'s birthday worded
  "Kate Bell's 48th Birthday" on 14 November 2026 and the contact "john"'s worded "John Appleseed's
  40th Birthday" on 5 June 2027; and the text "Hiking socks, size 38" with the link
  "bergzeit.ch/socks" is added through it to Kate's line
- **THEN** the add is not refused
- **AND** Kate's line gives back "Ceramics class voucher" and then "Hiking socks, size 38" with the
  link "https://bergzeit.ch/socks", and says "2 ideas"
- **AND** Kate's line as it was given back before the add gives back the same two ideas
- **AND** its calendar has been asked once in all
- **AND** an empty text with the link "amazon.de/xyz" added to John's line is not refused, and John's
  line then says "1 idea"
- **AND** a Birthdays screen opened afterwards at that place gives back the same ideas for each line

#### Scenario: an add whose text and link both say nothing, or whose link is not a web address, is refused and writes nothing

- **WHEN** a present-idea place holds the idea "Ceramics class voucher" against the contact "kate",
  a Birthdays screen is opened at it as of Tuesday 13 October 2026 with birthdays on and a calendar
  handing the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026, and
  a text of blank space alone with an empty link is added through it to Kate's line
- **THEN** the add is refused as an idea that says nothing
- **AND** the text "Book voucher" with the link "ask Anna" added to Kate's line is refused as a link
  that is not a web address
- **AND** the content at that place is byte-for-byte what it was before, and Kate's line says
  "1 idea"

#### Scenario: an idea a Birthdays screen cannot keep is refused as not kept and not held

- **WHEN** a Birthdays screen is opened as of Tuesday 13 October 2026 at a present-idea place where
  nothing can be written — a path beneath an existing ordinary file — with birthdays on and a
  calendar handing the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on
  14 November 2026, and the text "Book voucher" is added through it to Kate's line
- **THEN** the add is refused as not kept
- **AND** Kate's line gives back no ideas and says nothing of ideas
- **AND** a Birthdays screen opened afterwards at that place gives back none for Kate's line

#### Scenario: a Birthdays screen gives back a line's ideas not given in the order added, then those given

- **WHEN** a present-idea place holds the ideas "Ceramics class voucher", "Hiking socks, size 38" and
  "Book voucher" against the contact "kate", the first given; and a Birthdays screen is opened at it
  as of Tuesday 13 October 2026 with birthdays on and a calendar handing the contact "kate"'s
  birthday worded "Kate Bell's 48th Birthday" on 14 November 2026
- **THEN** Kate's line gives back "Hiking socks, size 38", then "Book voucher", then "Ceramics class
  voucher", given
- **AND** once the idea "Scarf" is added through it to Kate's line, Kate's line gives back "Hiking
  socks, size 38", "Book voucher", "Scarf", then "Ceramics class voucher", given
- **AND** once the mark of "Ceramics class voucher" is taken back through it, Kate's line gives back
  "Ceramics class voucher", "Hiking socks, size 38", "Book voucher", then "Scarf", none given

### Requirement: A Birthdays screen that cannot read its present-idea place lists every birthday with no count, and adds none

A Birthdays screen whose present-idea place cannot be read SHALL list its birthdays as ever, every
line saying nothing of ideas and giving back none, SHALL say its present ideas could not be read, and
SHALL tell apart one cause, a store written by a later version of DayByDay, from every other. It
MUST NOT write over what is at the place, and adding an idea through it SHALL be refused as not kept.
The condition SHALL last only until the screen is shown again, since being shown reads the place
afresh, and a place that can then be read SHALL be said as kept.

#### Scenario: a Birthdays screen that cannot read its present-idea place lists every birthday with no count and leaves the place as it was

- **WHEN** a run of bytes that is not a present-idea store is written at a present-idea place; a
  Birthdays screen is opened at it as of Tuesday 13 October 2026 with birthdays on and a calendar
  handing the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026; and
  the text "Book voucher" is added through it to Kate's line
- **THEN** it lists one line, saying "Kate Bell's 48th Birthday" and "Sat 14 November" and nothing of
  ideas, and giving back none
- **AND** it says its present ideas could not be read, and so does one opened the same way with
  birthdays off
- **AND** the add is refused as not kept
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a present-idea place written by a later version makes a Birthdays screen that says so

- **WHEN** a present-idea store declaring a form later than this app writes is written at a
  present-idea place, and a Birthdays screen is opened at it as of Tuesday 13 October 2026 with
  birthdays on and a calendar handing the contact "kate"'s birthday worded "Kate Bell's 48th
  Birthday" on 14 November 2026
- **THEN** it lists Kate's line, saying nothing of ideas
- **AND** it says its present ideas were written by a later version of DayByDay
- **AND** the content at that place is byte-for-byte what it was before

#### Scenario: a Birthdays screen that could not read its present-idea place reads it again when shown

- **WHEN** a run of bytes that is not a present-idea store is written at a present-idea place; a
  Birthdays screen is opened at it as of Tuesday 13 October 2026 with birthdays on and a calendar
  handing the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026; that
  content is replaced by a present-idea store holding the idea "Book voucher" against "kate"; and the
  screen is shown again on that day
- **THEN** Kate's line says "1 idea" and gives back "Book voucher"
- **AND** it says its present ideas are kept

### Requirement: A present idea is a text, a link or both, each trimmed, and whether it is given

A present idea SHALL be made from a typed text and a typed link, each with the blank space at both
ends trimmed first, and SHALL hold the text where it says anything, the link where it says anything,
whether it is given, and nothing else, and an idea so made SHALL be not given. A text or a link that says nothing SHALL be held as none, whether it says nothing
SHALL be judged exactly as a commitment's name is judged, and the text SHALL otherwise be kept
exactly as typed, with no limit on its length. Making an idea whose text and link both say nothing
SHALL be refused as an idea that says nothing, and no idea SHALL come of it.

#### Scenario: a present idea holds its text and its link, each trimmed

- **WHEN** a present idea is made from the text " Book voucher " and the link
  " https://amazon.de/xyz "
- **THEN** it holds the text "Book voucher" and the link "https://amazon.de/xyz"
- **AND** one made from the text "Hiking socks, size 38" and an empty link holds that text and no
  link
- **AND** one made from a text of blank space alone and the link "https://bergzeit.ch/socks" holds
  no text and that link
- **AND** one made from a text of the letter "a" a thousand times over and an empty link holds all
  thousand letters

#### Scenario: a present idea whose text and link both say nothing is refused

- **WHEN** a present idea is made from an empty text and an empty link
- **THEN** making it is refused as an idea that says nothing
- **AND** one made from the text "   " and a link of a tab alone is refused the same way

### Requirement: What a Birthdays screen tells about a present idea lasts until a field is edited, the next add, change, deletion or mark, a sheet closing or the screen being shown again

A Birthdays screen SHALL hold the refusal of the last add, change, confirmed deletion or mark made
through it until a field of an idea sheet is told edited, until the next add, change, confirmed
deletion or mark, until an idea sheet is told closed, or until the screen is shown again, and SHALL
then hold none; nothing else SHALL end it. An add, change, confirmed deletion or mark that is not
refused SHALL end it, and one that is refused SHALL replace it. Giving back a line's ideas, and
asking for or cancelling a deletion, SHALL NOT end it.

#### Scenario: what a Birthdays screen tells about a present idea ends when a field is edited, the sheet closes or the screen is shown again

- **WHEN** a Birthdays screen is opened as of Tuesday 13 October 2026 at a present-idea place where
  nothing has been kept, with birthdays on and a calendar handing the contact "kate"'s birthday
  worded "Kate Bell's 48th Birthday" on 14 November 2026; an empty text with an empty link is added
  through it to Kate's line and refused; Kate's line's ideas are given back; and a field of the idea
  sheet is then told edited
- **THEN** before the field is told edited it tells an idea that says nothing, and afterwards it
  tells nothing about a present idea
- **AND** the same refusal ended instead by the idea sheet being told closed leaves it telling
  nothing, and so does the screen being shown again on that day
- **AND** the same refusal followed by the text "Book voucher" with the link "ask Anna" leaves it
  telling a link that is not a web address
- **AND** the same refusal followed by the text "Book voucher" with an empty link leaves it telling
  nothing

#### Scenario: what a Birthdays screen tells about a refused change, deletion or mark ends with the next one not refused

- **WHEN** a present-idea place holds the ideas "Ceramics class voucher" and "Book voucher" against
  the contact "kate"; a Birthdays screen is opened at it as of Tuesday 13 October 2026 with birthdays
  on and a calendar handing the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on
  14 November 2026; the first idea Kate's line gives back is changed through it to an empty text with
  an empty link and refused; and it is then asked to delete the first idea, and the deletion is
  cancelled
- **THEN** it tells an idea that says nothing
- **AND** once the second idea is marked given through it, it tells nothing about a present idea
- **AND** a mark of the third idea Kate's line gives back then leaves it telling an idea not kept,
  and a field of an idea sheet told edited leaves it telling nothing
- **AND** the same refusal followed by the deletion of the first idea, confirmed, leaves it telling
  nothing

### Requirement: A present-idea store changes, deletes and marks an idea by where it stands in the order added, and reads its first form as holding none given

A present-idea store SHALL change, delete, mark given and take back the mark of the idea standing at
a position among a contact's ideas in the order added, each kept at its place before it reports it
kept, and refused with an error and not held where it cannot be kept. A change SHALL leave the idea
where it stands and keep its mark, and a deletion SHALL leave the contact's other ideas in their
order. A change, deletion or mark at a position naming no idea of the contact, marking given an idea
already given, and taking back a mark not there SHALL be refused without an error and leave the
place untouched. It SHALL write a form one later than its first, and SHALL read a store in its first
form as holding no idea given, writing nothing there on opening.

#### Scenario: a present-idea store opened again holds each idea as changed, deleted and marked

- **WHEN** the ideas "Ceramics class voucher", "Hiking socks", "Book voucher" and "Scarf" are added
  to the contact "kate" in a present-idea store; the second is changed to the text "Hiking socks,
  size 38" with the link "https://bergzeit.ch/socks"; the third is marked given; the fourth is
  marked given and its mark taken back; the first is deleted; and a second store is opened at the
  same place
- **THEN** the second store holds against "kate" "Hiking socks, size 38" with the link
  "https://bergzeit.ch/socks", not given, then "Book voucher", given, then "Scarf", not given
- **AND** once the second idea it holds against "kate" is changed at it to the text "Book voucher,
  hardback", a store opened again at that place holds that idea second, given

#### Scenario: a change, deletion or mark the present-idea store cannot keep is refused and not held

- **WHEN** the ideas "Ceramics class voucher" and "Book voucher" are added to the contact "kate" in
  a present-idea store and the second is marked given; its place is then made so that it can be read
  from but not written to; and the first is changed to the text "Hiking socks"
- **THEN** changing it is refused with an error, and the store holds "Ceramics class voucher" first
- **AND** marking the first given is refused with an error, and the store holds it not given
- **AND** taking back the second's mark is refused with an error, and the store holds it given
- **AND** deleting the first is refused with an error, and the store still holds both
- **AND** a store opened afterwards at that place holds the same

#### Scenario: a change, deletion or mark naming no idea, or a mark already so, is refused without an error and leaves the place untouched

- **WHEN** the idea "Book voucher" is added to the contact "kate" in a present-idea store and marked
  given, and the content at that place is read
- **THEN** changing the second idea against "kate" to the text "Scarf", deleting it, and marking it
  given are each refused without an error
- **AND** so is each of them for the first idea against the contact "john", and against a contact
  of blank space alone
- **AND** marking the first idea against "kate" given is refused without an error
- **AND** the content at that place is byte-for-byte what was read
- **AND** once that idea's mark is taken back, taking it back again is refused without an error

#### Scenario: a present-idea store in its first form is read as holding no idea given

- **WHEN** a present-idea store is opened at a place holding a store in the first form, holding the
  ideas "Book voucher" and "Scarf" against the contact "kate", the record of "Scarf" saying it is
  given as a later form says so
- **THEN** it opens without error, holding "Book voucher", then "Scarf", against "kate", neither
  given
- **AND** the content at that place is byte-for-byte what it was before it was opened
- **AND** once "Book voucher" is marked given at it, a store opened again at that place holds "Book
  voucher", given, then "Scarf", not given

### Requirement: A Birthdays screen changes a line's idea where it stands, keeping its mark

A Birthdays screen SHALL change the idea standing at a position among those it gives back for a line
to one made from a typed text and a typed link, kept at its present-idea place before the screen
reports it kept. The changed idea SHALL keep its mark and SHALL be given back where the idea it
replaced was. A change SHALL be refused, and nothing written, as an idea that says nothing or as a
link that is not a web address wherever making that idea is refused so, the idea staying as it was.

#### Scenario: an idea changed through a Birthdays screen is kept where it stands, its mark with it

- **WHEN** a present-idea place holds the ideas "Book voucher", "Hiking socks" and "Ceramics class
  voucher" against the contact "kate", the first given; a Birthdays screen is opened at it as of
  Tuesday 13 October 2026 with birthdays on and a calendar handing the contact "kate"'s birthday
  worded "Kate Bell's 48th Birthday" on 14 November 2026; and the first idea Kate's line gives back,
  "Hiking socks", is changed through it to the text "Hiking socks, size 38" with the link
  "bergzeit.ch/socks"
- **THEN** the change is not refused
- **AND** Kate's line gives back "Hiking socks, size 38" with the link "https://bergzeit.ch/socks",
  then "Ceramics class voucher", then "Book voucher", given
- **AND** the third changed to the text "Book voucher, hardback" with an empty link is not refused,
  and Kate's line then gives back that idea third, given, and says "2 ideas"
- **AND** a Birthdays screen opened afterwards at that place gives back the same ideas for Kate's
  line

#### Scenario: a change whose text and link both say nothing, or whose link is not a web address, is refused and leaves the idea as it was

- **WHEN** a present-idea place holds the idea "Ceramics class voucher" with the link
  "https://amazon.de/xyz" against the contact "kate"; a Birthdays screen is opened at it as of
  Tuesday 13 October 2026 with birthdays on and a calendar handing the contact "kate"'s birthday
  worded "Kate Bell's 48th Birthday" on 14 November 2026; and the first idea Kate's line gives back
  is changed through it to a text of blank space alone with an empty link
- **THEN** the change is refused as an idea that says nothing
- **AND** the first changed to the text "Ceramics class voucher" with the link "ask Anna" is refused
  as a link that is not a web address
- **AND** the content at that place is byte-for-byte what it was before, and Kate's line gives back
  "Ceramics class voucher" with the link "https://amazon.de/xyz"

### Requirement: A Birthdays screen deletes a line's idea only once the deletion is confirmed

A Birthdays screen asked to delete the idea standing at a position among those it gives back for a
line SHALL change nothing but hold that idea awaiting deletion, replacing any idea awaiting it, and
asked about a position naming none of them SHALL leave none awaiting. A cancel SHALL change nothing
but leave none awaiting, and so SHALL its being shown again. A confirmed deletion SHALL leave none
awaiting and SHALL be kept at its present-idea place before the screen reports it kept, the line's
other ideas staying in their order, and every line of that contact SHALL then say its new count at
once, without its calendar being asked again. A confirmation with nothing awaiting SHALL do nothing.

#### Scenario: asking to delete an idea changes nothing until it is confirmed, and a cancel changes nothing

- **WHEN** a present-idea place holds the ideas "Ceramics class voucher" and "Book voucher" against
  the contact "kate"; a Birthdays screen is opened at it as of Tuesday 13 October 2026 with
  birthdays on and a calendar handing the contact "kate"'s birthday worded "Kate Bell's 48th
  Birthday" on 14 November 2026; the content at that place is read; and the screen is asked to
  delete the second idea Kate's line gives back
- **THEN** "Book voucher" awaits deletion, and Kate's line still gives back both and says "2 ideas"
- **AND** once the deletion is cancelled nothing awaits deletion
- **AND** asked again and then shown again on that day, nothing awaits deletion, and a confirmation
  then does nothing
- **AND** asked to delete the second idea again and then the third idea Kate's line gives back,
  nothing awaits deletion, and a confirmation then does nothing
- **AND** the content at that place is byte-for-byte what was read

#### Scenario: a confirmed deletion removes the idea where it stood, and its line's count drops at once

- **WHEN** a present-idea place holds the ideas "Book voucher", "Ceramics class voucher" and "Hiking
  socks, size 38" against the contact "kate", the first given; a Birthdays screen is opened at it as
  of Tuesday 13 October 2026 with birthdays on and a calendar that records every ask and hands,
  whatever it is asked for, the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on
  14 November 2026; and it is asked to delete the first idea Kate's line gives back, "Ceramics class
  voucher", and the deletion is confirmed
- **THEN** the deletion is not refused, and nothing awaits deletion
- **AND** Kate's line gives back "Hiking socks, size 38", then "Book voucher", given, and says
  "1 idea"
- **AND** its calendar has been asked once in all
- **AND** once "Book voucher", the second idea Kate's line then gives back, is deleted the same way,
  Kate's line gives back "Hiking socks, size 38" alone and still says "1 idea"
- **AND** a Birthdays screen opened afterwards at that place gives back "Hiking socks, size 38" alone
  for Kate's line

### Requirement: A Birthdays screen marks a line's idea given and takes the mark back, and a mark lasts until it is taken back

A Birthdays screen SHALL mark given the idea standing at a position among those it gives back for a
line, and SHALL take back the mark of one given, each kept at its present-idea place before the
screen reports it kept, and every line of that contact SHALL then say its new count at once, without
its calendar being asked again. Marking an idea already given, and taking back a mark an idea does
not have, SHALL NOT be refused and SHALL write nothing. A mark SHALL last until it is taken back or
the idea deleted, whatever day the screen is opened or shown on.

#### Scenario: an idea marked given through a Birthdays screen is kept given past its contact's birthday, and its line's count drops at once

- **WHEN** a present-idea place holds the ideas "Ceramics class voucher", "Hiking socks, size 38" and
  "Book voucher" against the contact "kate"; a Birthdays screen is opened at it as of Tuesday
  13 October 2026 with birthdays on and a calendar that records every ask and hands, whatever it is
  asked for, the contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026;
  and the first idea Kate's line gives back is marked given through it
- **THEN** the mark is not refused
- **AND** Kate's line says "2 ideas" and gives back "Ceramics class voucher" last, given
- **AND** its calendar has been asked once in all
- **AND** a Birthdays screen opened afterwards at that place as of Monday 16 November 2026 with
  birthdays on and a calendar handing the contact "kate"'s birthday worded "Kate Bell's 49th
  Birthday" on 14 November 2027 gives back "Ceramics class voucher" last on Kate's line, given, and
  that line says "2 ideas"

#### Scenario: taking back an idea's mark through a Birthdays screen returns it where it was added, and its line's count rises at once

- **WHEN** a present-idea place holds the ideas "Ceramics class voucher" and "Book voucher" against
  the contact "kate", the first given; a Birthdays screen is opened at it as of Tuesday 13 October
  2026 with birthdays on and a calendar handing the contact "kate"'s birthday worded "Kate Bell's
  48th Birthday" on 14 November 2026; and the mark of the second idea Kate's line gives back,
  "Ceramics class voucher", is taken back through it
- **THEN** taking it back is not refused
- **AND** Kate's line says "2 ideas" and gives back "Ceramics class voucher", then "Book voucher",
  neither given
- **AND** once the second, "Book voucher", is marked given through it and the content at that place
  is read, marking it given again and taking back the mark of the first are each not refused, and the
  content at that place is byte-for-byte what was read
- **AND** a Birthdays screen opened afterwards at that place gives back "Ceramics class voucher", not
  given, then "Book voucher", given, for Kate's line

### Requirement: A change, deletion or mark a Birthdays screen cannot keep, or that names no idea, is refused as not kept and changes nothing

A Birthdays screen SHALL refuse as not kept a change, a confirmed deletion or a mark that its
present-idea place cannot keep, holding nothing of it, so that the line SHALL give back its ideas and
say its count as before. It SHALL refuse as not kept, writing nothing, a change or a mark at a
position naming none of the ideas it gives back for the line, which SHALL be every position while it
cannot read its present-idea place.

#### Scenario: a change, deletion or mark a Birthdays screen cannot keep is refused as not kept and not held

- **WHEN** a present-idea place holds the ideas "Ceramics class voucher" and "Book voucher" against
  the contact "kate", the second given; a Birthdays screen is opened at it as of Tuesday 13 October
  2026 with birthdays on and a calendar handing the contact "kate"'s birthday worded "Kate Bell's
  48th Birthday" on 14 November 2026; the place is then made so that it can be read from but not
  written to; and the first idea Kate's line gives back is changed through it to the text "Hiking
  socks"
- **THEN** the change is refused as not kept
- **AND** marking the first given, taking back the mark of the second, and deleting the first once
  the deletion is confirmed are each refused as not kept
- **AND** Kate's line gives back "Ceramics class voucher", then "Book voucher", given, and says
  "1 idea"
- **AND** a Birthdays screen opened afterwards at that place gives back the same for Kate's line

#### Scenario: a change or mark naming no idea of a line is refused as not kept and writes nothing

- **WHEN** a present-idea place holds the idea "Book voucher" against the contact "kate"; a Birthdays
  screen is opened at it as of Tuesday 13 October 2026 with birthdays on and a calendar handing the
  contact "kate"'s birthday worded "Kate Bell's 48th Birthday" on 14 November 2026; the content at
  that place is read; and the second idea Kate's line gives back is changed through it to the text
  "Hiking socks"
- **THEN** the change is refused as not kept
- **AND** marking the second given is refused as not kept
- **AND** the content at that place is byte-for-byte what was read
- **AND** at a place holding a run of bytes that is not a present-idea store, a Birthdays screen
  opened the same way refuses as not kept a change and a mark of the first idea Kate's line gives
  back, leaves nothing awaiting deletion when asked to delete it, and leaves that content
  byte-for-byte as it was
