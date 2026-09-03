public struct Roster: Hashable, Sendable {
    /// A roster holding no commitments.
    public init() {
        commitments = []
    }

    /// The commitments this roster holds, in the order they were added.
    public private(set) var commitments: [Commitment]

    /// Adds `commitment` after every commitment already held, and answers `true`. Answers
    /// `false` and changes nothing when this roster already holds it.
    public mutating func add(_ commitment: Commitment) -> Bool {
        guard !commitments.contains(commitment) else {
            return false
        }

        commitments.append(commitment)
        return true
    }
}
