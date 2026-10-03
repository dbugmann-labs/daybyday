public struct Happenings: Hashable, Sendable {
    public private(set) var all: [Happening]

    /// Every occurrence noted, in the order noted, the newest last.
    public private(set) var occurrences: [Occurrence]

    /// The identities of the happenings held that are stopped.
    private var stopped: Set<Happening.Identity>

    public init() {
        all = []
        occurrences = []
        stopped = []
    }

    /// Holds `occurrence` last, however many alike are held, and `false` without changing
    /// anything where the happening it is of is not held or is stopped.
    public mutating func note(_ occurrence: Occurrence) -> Bool {
        guard all.contains(where: { $0.identity == occurrence.happening }),
            !stopped.contains(occurrence.happening)
        else {
            return false
        }

        occurrences.append(occurrence)
        return true
    }

    /// Gives the earliest noted occurrence alike to `occurrence` the time and note given.
    public mutating func change(
        _ occurrence: Occurrence, to time: TimeOfDay?, saying note: String?
    ) -> Bool {
        guard let index = occurrences.firstIndex(of: occurrence) else {
            return false
        }
        let changed = Occurrence(
            ofIdentity: occurrence.happening, on: occurrence.day, at: time, saying: note)
        occurrences[index] = changed
        return true
    }

    /// Removes the earliest noted occurrence alike to `occurrence`.
    public mutating func takeBack(_ occurrence: Occurrence) -> Bool {
        guard let index = occurrences.firstIndex(of: occurrence) else {
            return false
        }
        occurrences.remove(at: index)
        return true
    }

    /// Whether `happening` is held and stopped.
    public func isStopped(_ happening: Happening) -> Bool {
        stopped.contains(happening.identity) && all.contains(happening)
    }

    /// Stops `happening`.
    public mutating func stop(_ happening: Happening) -> Bool {
        guard all.contains(happening), !stopped.contains(happening.identity) else {
            return false
        }

        stopped.insert(happening.identity)
        return true
    }

    /// Resumes `happening`.
    public mutating func resume(_ happening: Happening) -> Bool {
        guard all.contains(happening), stopped.contains(happening.identity) else {
            return false
        }

        stopped.remove(happening.identity)
        return true
    }

    /// Deletes `happening` and every occurrence of it.
    public mutating func delete(_ happening: Happening) -> Bool {
        guard let index = all.firstIndex(of: happening) else {
            return false
        }

        all.remove(at: index)
        occurrences.removeAll { $0.happening == happening.identity }
        stopped.remove(happening.identity)
        return true
    }

    public func holding(name: String) -> Happening? {
        let wanted = Blank.trimmed(name).lowercased()
        return all.first { Blank.trimmed($0.name).lowercased() == wanted }
    }

    public mutating func add(_ happening: Happening) -> Bool {
        guard holding(name: happening.name) == nil, !all.contains(happening) else {
            return false
        }

        all.append(happening)
        return true
    }

    public mutating func rename(_ happening: Happening, to name: String) -> Bool {
        guard let index = all.firstIndex(of: happening), !Blank.saysNothing(name) else {
            return false
        }
        let wanted = Blank.trimmed(name).lowercased()
        guard !all.contains(where: { $0 != happening && Blank.trimmed($0.name).lowercased() == wanted })
        else {
            return false
        }

        all[index] = Happening(identity: happening.identity, name: name)
        return true
    }

    public static func == (lhs: Happenings, rhs: Happenings) -> Bool {
        lhs.all.count == rhs.all.count
            && zip(lhs.all, rhs.all).allSatisfy { $0.identity == $1.identity && $0.name == $1.name }
            && lhs.occurrences == rhs.occurrences && lhs.stopped == rhs.stopped
    }

    public func hash(into hasher: inout Hasher) {
        for happening in all {
            hasher.combine(happening.identity)
            hasher.combine(happening.name)
        }
        for occurrence in occurrences {
            hasher.combine(occurrence)
        }
        for happening in all where stopped.contains(happening.identity) {
            hasher.combine(happening.identity)
        }
    }
}

extension Happenings {
    /// The occurrences of `happening` on `day` in a row's order: those with a time first, earliest
    /// first, then those with none, each run in the order noted.
    func occurrences(of happening: Happening, on day: CalendarDate) -> [Occurrence] {
        let came = occurrences.filter { $0.happening == happening.identity && $0.day == day }
        let timed = came.enumerated().compactMap { offset, occurrence in
            occurrence.time.map { (time: $0, offset: offset, occurrence: occurrence) }
        }.sorted { ($0.time, $0.offset) < ($1.time, $1.offset) }.map(\.occurrence)
        return timed + came.filter { $0.time == nil }
    }
}
