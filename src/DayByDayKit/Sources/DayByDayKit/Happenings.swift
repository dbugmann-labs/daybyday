public struct Happenings: Hashable, Sendable {
    public private(set) var all: [Happening]

    public init() {
        all = []
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
    }

    public func hash(into hasher: inout Hasher) {
        for happening in all {
            hasher.combine(happening.identity)
            hasher.combine(happening.name)
        }
    }
}
