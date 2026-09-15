import Foundation

/// The versioned form a copy is written to and read from disk — its own form, independent of the
/// forms the three stores below it are written in, `design.md` § *A copy is the values, not the
/// files*. Nests `RecordDocument`, `RosterDocument` and `OneOffDocument` exactly as each is
/// written at its own place today, so what a copy holds for a store is byte-for-byte what that
/// store would write for the same value.
struct CopyDocument: Codable {
    /// The form this app writes. Independent of `RecordDocument.currentVersion`,
    /// `RosterDocument.currentVersion` and `OneOffDocument.currentVersion`: a copy's own form
    /// moves on its own schedule, so a later Story can version the copy without touching a store.
    static let currentVersion = 1

    var version: Int
    var moment: MomentRecord
    var record: RecordDocument
    var roster: RosterDocument
    var oneOffs: OneOffDocument

    /// Builds the document that exactly represents `copy`, each of the three stores written in
    /// the form that store writes now.
    init(_ copy: Copy) {
        version = Self.currentVersion
        moment = MomentRecord(copy.moment)

        let parts = copy.history.recordDocumentParts()
        record = RecordDocument(
            ticks: parts.ticks, numbers: parts.numbers, notes: parts.notes,
            additions: parts.additions)
        roster = RosterDocument(copy.roster)
        oneOffs = OneOffDocument(copy.oneOffs)
    }

    /// Re-forms `moment`, and the record, the roster and the one-offs this document holds,
    /// through the same re-forming each of their own documents already does. `nil` if the moment
    /// or any one of the three could not be formed.
    func formCopy() -> Copy? {
        guard let formedMoment = moment.moment() else {
            return nil
        }
        guard let ticks = record.formTicks(), let numbers = record.formNumbers(),
            let notes = record.formNotes(), let additions = record.formAdditions()
        else {
            return nil
        }
        guard let formedRoster = roster.formRoster() else {
            return nil
        }
        guard let formedOneOffs = oneOffs.formOneOffs() else {
            return nil
        }

        var formedHistory = History()
        for tick in ticks {
            formedHistory.add(tick)
        }
        for number in numbers {
            formedHistory.add(number)
        }
        for note in notes {
            formedHistory.add(note)
        }
        for addition in additions {
            formedHistory.add(addition)
        }

        return Copy(
            moment: formedMoment, history: formedHistory, roster: formedRoster,
            oneOffs: formedOneOffs)
    }
}

/// Reads only `version`, so a later form is told apart from the body before the body is ever
/// decoded — the same guard every other document's own envelope gives.
struct CopyDocumentEnvelope: Decodable {
    var version: Int
}

/// The wire shape of a `Moment`: a `DateRecord` day beside the hour and the minute, exactly as
/// `Moment` itself holds them.
struct MomentRecord: Codable {
    var day: DateRecord
    var hour: Int
    var minute: Int

    init(_ moment: Moment) {
        day = DateRecord(moment.day)
        hour = moment.hour
        minute = moment.minute
    }

    func moment() -> Moment? {
        guard let calendarDay = day.calendarDate() else {
            return nil
        }
        return Moment(on: calendarDay, hour: hour, minute: minute)
    }
}
