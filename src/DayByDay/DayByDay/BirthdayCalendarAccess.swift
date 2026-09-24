import EventKit
import DayByDayKit

/// The adapter between the phone's own calendar permission and the Kit's `CalendarAccess` —
/// `openspec/changes/turn-birthdays-on/design.md` § *The phone's five answers reach the Kit
/// unjudged*: every `EKAuthorizationStatus` maps onto the case of the same meaning, and
/// `@unknown default` onto `.denied`. Which of these count as a refusal is judged in
/// `BirthdaySwitch`, in the Kit, not here.
func currentCalendarAccess() -> CalendarAccess {
    switch EKEventStore.authorizationStatus(for: .event) {
    case .notDetermined:
        return .notAsked
    case .fullAccess:
        return .full
    case .writeOnly:
        return .writeOnly
    case .denied:
        return .denied
    case .restricted:
        return .restricted
    @unknown default:
        return .denied
    }
}

/// Asks the phone for full calendar access — `EKEventStore.requestFullAccessToEvents()`, whose
/// thrown error is ignored: `BirthdaySwitch.turnOn()` reads `currentCalendarAccess()` again once
/// this returns, so nothing here needs to say why an ask failed.
func askForCalendarAccess() async {
    _ = try? await EKEventStore().requestFullAccessToEvents()
}

/// Thrown by `makeBirthdayCalendar()`'s own reader whenever the phone no longer gives full
/// calendar access — `design.md` § *The shell*: "throws unless access is full."
struct BirthdayCalendarReadError: Error {}

/// The `BirthdayCalendar` `ContentView` hands its `DayScreen` — `design.md` § *The shell* and
/// § *The calendar is handed in, and the Kit orders by the collation it is handed*: this is the
/// one place `EventKit` and a locale are read, and the Kit itself reads neither.
func makeBirthdayCalendar() -> BirthdayCalendar {
    BirthdayCalendar(
        reading: { first, last in try readBirthdays(from: first, through: last) },
        collating: { words, before in
            words.localizedStandardCompare(before) == .orderedAscending
        })
}

/// Reads the birthdays falling from `first` through `last`, both included, through a fresh
/// `EKEventStore` — "an `EKEventStore` made or reset after access is given" (`design.md` §
/// Risks): a read only ever happens once the switch is on, so access has already been granted
/// by the time this runs, and a store made now is never the stale one that risk names. Throws
/// unless access is full. Reads calendars of type `.birthday`, matching a contact by
/// `birthdayContactIdentifier` and skipping an event with none — never by a stored calendar or
/// event identifier, both of which change when the Birthdays calendar is rebuilt (`grill.md`
/// § *Left open*).
@MainActor
private func readBirthdays(from first: CalendarDate, through last: CalendarDate) throws -> [Birthday]
{
    guard currentCalendarAccess() == .full else {
        throw BirthdayCalendarReadError()
    }

    let store = EKEventStore()
    let birthdayCalendars = store.calendars(for: .event).filter { $0.type == .birthday }
    guard !birthdayCalendars.isEmpty else {
        return []
    }

    let predicate = store.predicateForEvents(
        withStart: startOfDay(first), end: endOfDay(last), calendars: birthdayCalendars)

    return store.events(matching: predicate).compactMap { event in
        guard let contact = event.birthdayContactIdentifier else {
            return nil
        }
        guard let day = calendarDate(from: event.startDate) else {
            return nil
        }
        return Birthday(contact: contact, words: event.title, day: day)
    }
}

/// `calendarDate`'s own date, at midnight in the device's own calendar — the earlier end of the
/// span `readBirthdays(from:through:)` asks EventKit for.
private func startOfDay(_ calendarDate: CalendarDate) -> Date {
    var components = DateComponents()
    components.year = calendarDate.year
    components.month = calendarDate.month
    components.day = calendarDate.day
    return Calendar.current.date(from: components)!
}

/// `calendarDate`'s own date, one second before its midnight the day after — the later end of
/// the span `readBirthdays(from:through:)` asks EventKit for, so an event anywhere within
/// `calendarDate`'s own day is included.
private func endOfDay(_ calendarDate: CalendarDate) -> Date {
    Calendar.current.date(
        byAdding: DateComponents(day: 1, second: -1), to: startOfDay(calendarDate))!
}

/// The reverse of `startOfDay(_:)`: `date`'s own year, month and day in the device's own
/// calendar, or `nil` where that does not form a `CalendarDate` at all — the edge conversion
/// ADR-1004 keeps out of the Kit, mirroring `ContentView.today()`'s own.
private func calendarDate(from date: Date) -> CalendarDate? {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
    guard let year = components.year, let month = components.month, let day = components.day
    else {
        return nil
    }
    return CalendarDate(year: year, month: month, day: day)
}
