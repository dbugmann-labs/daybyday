/// The ticks held against birthdays — keyed to the contact and the day a birthday falls on,
/// never to a `Birthday` itself, so a tick follows a rename and outlives words the calendar
/// no longer hands. `design.md` § *A birthday's equality is all of it; a tick's key is its
/// contact and its day* and ADR-1062.
public struct BirthdayTicks: Hashable, Sendable {
    struct Key: Hashable, Sendable {
        let contact: String
        let day: CalendarDate
    }

    var keys: Set<Key>

    public init() {
        keys = []
    }

    public func isTicked(_ birthday: Birthday) -> Bool {
        keys.contains(Key(contact: birthday.contact, day: birthday.day))
    }

    public mutating func tick(_ birthday: Birthday) -> Bool {
        let key = Key(contact: birthday.contact, day: birthday.day)
        guard !keys.contains(key) else {
            return false
        }

        keys.insert(key)
        return true
    }

    public mutating func takeBack(_ birthday: Birthday) -> Bool {
        let key = Key(contact: birthday.contact, day: birthday.day)
        guard keys.contains(key) else {
            return false
        }

        keys.remove(key)
        return true
    }
}
