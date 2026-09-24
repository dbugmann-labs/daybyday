import Foundation

/// The phone's calendar access, as `BirthdaySwitch` reads it — five states, never fewer:
/// `openspec/changes/turn-birthdays-on/design.md` § *The seam*. The shell maps every
/// `EKAuthorizationStatus` onto the case of the same meaning; which of these count as a refusal
/// is judged in the Kit, not the shell — § *The phone's five answers reach the Kit unjudged*.
public enum CalendarAccess: Hashable, Sendable {
    case notAsked
    case full
    case writeOnly
    case denied
    case restricted
}

/// Whether birthdays are turned on — the app's second setting, after the copy place
/// (`grill.md` § *Settled* 7), kept at a file of its own under `ApplicationSupport/DayByDay/`.
/// `isOn` is *kept on* and *last reading full* together, never a memory of an event: turning it
/// on asks the phone for full calendar access only where the last reading was not already full,
/// and a reading that is not full while on is kept writes the switch off — `design.md` §
/// *On is a reading, not a memory*. `isRefused` is the last reading alone, so it says why the
/// switch cannot be on for as long as that reading stands, whether or not the switch was ever
/// turned on — `design.md` § *The seam* and the requirement of the same name.
@MainActor
@Observable
public final class BirthdaySwitch {
    /// The place a birthday switch keeps its own state when it is not told another: a file of
    /// its own under the platform's application-support directory, beside the record, the
    /// roster, the one-off and the copy places but none of those. `design.md` § *The form on
    /// disk, version 1*.
    public static var place: URL {
        let applicationSupport = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return applicationSupport
            .appendingPathComponent("DayByDay", isDirectory: true)
            .appendingPathComponent("birthday-switch.json")
    }

    private let statePlace: URL
    private let readAccess: @MainActor () -> CalendarAccess
    private let askForAccess: @MainActor () async -> Void

    /// Whether birthdays are on: kept on at `statePlace` and, as of the last reading taken at
    /// `init`, `shown()` or after an ask, the phone gives full calendar access.
    public private(set) var isOn: Bool

    /// Whether the phone's calendar access, as last read, falls short of full — write-only,
    /// denied or restricted. `false` where it has never been asked or already gives full access.
    public private(set) var isRefused: Bool

    /// Opens a birthday switch at `place`, reading what is kept there — off where nothing has
    /// ever been kept, or where what is kept cannot be read as a switch this app writes.
    /// `access` is asked once here for the reading `isOn` and `isRefused` are formed from;
    /// `ask` is the phone's own prompt, called at most once per `turnOn()`.
    public init(
        at place: URL = BirthdaySwitch.place,
        readingAccess access: @escaping @MainActor () -> CalendarAccess,
        askingForAccess ask: @escaping @MainActor () async -> Void
    ) {
        self.statePlace = place
        self.readAccess = access
        self.askForAccess = ask
        self.isOn = false
        self.isRefused = false
        applyReading(access(), keptOn: Self.readStoredOnFlag(at: place) ?? false)
    }

    /// Turns birthdays on: already on, this asks the phone nothing and changes nothing. Where
    /// the last reading already gives full access, this is on and kept on without asking.
    /// Otherwise this asks the phone for full access exactly once and reads again — on and kept
    /// on only where that reading is full; off and kept off otherwise. `design.md` § *On is a
    /// reading, not a memory*.
    public func turnOn() async {
        guard !isOn else {
            return
        }
        guard readAccess() != .full else {
            isOn = true
            persist()
            return
        }
        await askForAccess()
        let access = readAccess()
        applyReading(access, keptOn: true)
        if access == .full {
            persist()
        }
    }

    /// Turns birthdays off: kept off at `statePlace`, asking the phone nothing. Already off,
    /// this changes nothing at the switch's place.
    public func turnOff() {
        guard isOn else {
            return
        }
        isOn = false
        persist()
    }

    /// A visit: reads the phone's calendar access again, exactly as `init` does. Where the
    /// switch was kept on and that reading is not full, it is turned off and kept off.
    public func shown() {
        applyReading(readAccess(), keptOn: isOn)
    }

    /// Applies `access` as the current reading: sets `isRefused` from it, and sets `isOn` to
    /// `keptOn && access == .full` — persisting where `keptOn` was true but the reading is not
    /// full, so a switch kept on is turned off and kept off at its place the moment a reading
    /// says access has fallen short, per `design.md` § *Birthdays are on only while the phone
    /// gives full calendar access*. Called by `init` (`keptOn` read off `statePlace`), `shown()`
    /// (`keptOn` the switch's own current `isOn`) and after an ask in `turnOn()` (`keptOn` always
    /// `true`, since only a switch being turned on reaches there).
    private func applyReading(_ access: CalendarAccess, keptOn: Bool) {
        isRefused = access == .writeOnly || access == .denied || access == .restricted
        let full = access == .full
        isOn = keptOn && full
        if keptOn, !full {
            persist()
        }
    }

    /// What was kept at `place` — `nil` where nothing has ever been kept, or what is there
    /// cannot be read as a switch this app writes, including one written by a later version.
    private static func readStoredOnFlag(at place: URL) -> Bool? {
        guard let data = try? Data(contentsOf: place),
            let document = try? JSONDecoder().decode(StateDocument.self, from: data),
            document.version == 1
        else {
            return nil
        }
        return document.on
    }

    /// What this switch's own state file holds, on disk — `design.md` § *The form on disk,
    /// version 1*.
    private struct StateDocument: Codable {
        var on: Bool
        var version: Int
    }

    /// Writes this switch's own state to `statePlace` whole, replacing whatever was there.
    private func persist() {
        let document = StateDocument(on: isOn, version: 1)
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]
            let data = try encoder.encode(document)
            try FileManager.default.createDirectory(
                at: statePlace.deletingLastPathComponent(), withIntermediateDirectories: true)
            try data.write(to: statePlace, options: .atomic)
        } catch {
            // Held for this run and not said, exactly as `CopyPlace.persist()` does —
            // `design.md` § *The form on disk, version 1*: a judgement, since the grill did not
            // reach it and a single bit is lost.
        }
    }
}
