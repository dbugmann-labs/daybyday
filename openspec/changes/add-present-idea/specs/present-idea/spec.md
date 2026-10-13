## ADDED Requirements

### Requirement: A present idea is a text, a link or both, each trimmed, and nothing else

A present idea SHALL be made from a typed text and a typed link, each with the blank space at both
ends trimmed first, and SHALL hold the text where it says anything, the link where it says anything,
and nothing else. A text or a link that says nothing SHALL be held as none, whether it says nothing
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
idea added there, under the contact it was added to, each contact's ideas in the order added, the
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
say how many ideas that place holds against its birthday's contact: "1 idea" for one, the number
followed by a space and "ideas" for more, and nothing for none, so every line of one contact SHALL
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

### Requirement: A Birthdays screen gives back a line's present ideas and adds one to its contact

A Birthdays screen SHALL give back the ideas its present-idea place holds against a line's contact,
in the order added, whatever else the line says. It SHALL add an idea made from a typed text and a
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

### Requirement: What a Birthdays screen tells about a present idea lasts until a field is edited, the next add, the sheet closing or the screen being shown again

A Birthdays screen SHALL hold the refusal of the last idea added through it until a field of the
idea sheet is told edited, until the next idea is added through it, until that sheet is told
closed, or until the screen is shown again, and SHALL then hold none; nothing else SHALL end it. An
add that is kept SHALL end it and an add that is refused SHALL replace it. Giving back a line's ideas
SHALL NOT end it.

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
