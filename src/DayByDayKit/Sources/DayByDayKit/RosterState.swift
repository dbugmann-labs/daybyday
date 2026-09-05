/// What a screen is doing with the roster at its place.
public enum RosterState: Equatable, Sendable {
    /// The roster was read, and this screen draws what it keeps.
    case kept
    /// The roster could not be read or could not be written, for a reason a person cannot act
    /// on differently.
    case notKept
    /// The roster was written by a later version of DayByDay. It is whole; the app is what is
    /// behind, and what is at the place must not be replaced.
    case writtenByALaterVersion
}
