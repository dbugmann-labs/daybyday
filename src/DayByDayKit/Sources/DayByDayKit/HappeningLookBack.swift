/// One happening seen on its own, over every occurrence of it noted. A value: asking twice for the
/// same happening answers the same one. `openspec/changes/add-happening-look-back/design.md`
/// § *The seam*.
public struct HappeningLookBack: Hashable, Sendable {
    public struct Month: Hashable, Sendable {
        public let inWords: String
        public let countInWords: String
    }

    public struct SaidOccurrence: Hashable, Sendable {
        public let dayInWords: String
        public let timeInWords: String
        public let note: String?
    }

    public let name: String
    public let sinceInWords: String?
    public let countInWords: String?
    public let months: [Month]
    public let occurrences: [SaidOccurrence]
}
