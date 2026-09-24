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
    /// 2 as of this Story: a copy now nests the birthday ticks beside the other three.
    /// `design.md` § *The copy's form moves to 2, and form 1 holds no ticks*.
    static let currentVersion = 2

    var version: Int
    var moment: MomentRecord
    var record: RecordDocument
    var roster: RosterDocument
    var oneOffs: OneOffDocument
    /// `nil` where this document was read at form 1, before a copy held birthday ticks at all —
    /// told apart from a form-2 document whose ticks fail to form, which is a damaged copy.
    var birthdayTicks: BirthdayDocument?

    /// Builds the document that exactly represents `copy`, each of the four stores written in
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
        birthdayTicks = BirthdayDocument(copy.birthdayTicks)
    }

    /// Re-forms `moment`, and the record, the roster, the one-offs and the birthday ticks this
    /// document holds, through the same re-forming each of their own documents already does.
    /// `nil` if the moment or any one of the four could not be formed. A document at form 1, from
    /// before a copy held birthday ticks, forms as holding none — `design.md` § *The copy's form
    /// moves to 2, and form 1 holds no ticks*; a document at form 2 or later with no birthday
    /// ticks, or ticks that do not form, forms as `nil`.
    func formCopy() -> Copy? {
        guard let formedMoment = moment.moment() else {
            return nil
        }
        guard let ticks = record.formTicks(), let numbers = record.formNumbers(),
            let notes = record.formNotes(), let additions = record.formAdditions()
        else {
            return nil
        }
        guard let formedRoster = roster.formRoster()?.roster else {
            return nil
        }
        guard let formedOneOffs = oneOffs.formOneOffs() else {
            return nil
        }

        let formedBirthdayTicks: BirthdayTicks
        if version >= 2 {
            guard let birthdayTicks, let formed = BirthdayStore.formed(from: birthdayTicks) else {
                return nil
            }
            formedBirthdayTicks = formed
        } else {
            formedBirthdayTicks = BirthdayTicks()
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
            oneOffs: formedOneOffs, birthdayTicks: formedBirthdayTicks)
    }

    /// Reads `data` as a copy — `openspec/changes/restore-from-a-copy/design.md` § *Reading a
    /// copy: the envelope decides, and a later version outranks damage*. Reads an envelope of
    /// this document's own `version` and `moment` first: where that does not read, or its form is
    /// below 1, `data` is not a copy; where it is above `currentVersion`, it is from a later
    /// version. Next come the envelopes of the three nested stores, read independently of one
    /// another and of the rest of the document — any one of them holding a later form than that
    /// store reads makes the whole copy one from a later version, whatever state the other two are
    /// in. Only then is the whole document decoded and each store's own shape checked against its
    /// declared form, exactly as that store's `init(at:)` checks its own place; any failure there
    /// is a damaged copy.
    static func read(_ data: Data) -> Result<Copy, CommitmentsScreen.Refusal> {
        struct Envelope: Decodable {
            var version: Int
            var moment: MomentRecord
        }
        guard let envelope = try? JSONDecoder().decode(Envelope.self, from: data),
            envelope.version >= 1, let moment = envelope.moment.moment()
        else {
            return .failure(.notACopy)
        }
        guard envelope.version <= Self.currentVersion else {
            return .failure(.copyFromALaterVersion)
        }

        let storeEnvelopes = try? JSONDecoder().decode(StoreEnvelopes.self, from: data)
        if let recordVersion = storeEnvelopes?.record?.version,
            recordVersion > RecordDocument.currentVersion
        {
            return .failure(.copyFromALaterVersion)
        }
        if let rosterVersion = storeEnvelopes?.roster?.version,
            rosterVersion > RosterDocument.currentVersion
        {
            return .failure(.copyFromALaterVersion)
        }
        if let oneOffsVersion = storeEnvelopes?.oneOffs?.version,
            oneOffsVersion > OneOffDocument.currentVersion
        {
            return .failure(.copyFromALaterVersion)
        }
        if let birthdayTicksVersion = storeEnvelopes?.birthdayTicks?.version,
            birthdayTicksVersion > BirthdayDocument.currentVersion
        {
            return .failure(.copyFromALaterVersion)
        }

        guard let document = try? JSONDecoder().decode(CopyDocument.self, from: data),
            let formedRecord = RecordStore.formed(from: document.record),
            let formedRoster = RosterStore.formed(from: document.roster),
            let formedOneOffs = OneOffStore.formed(from: document.oneOffs)
        else {
            return .failure(.damagedCopy)
        }

        // A document at form 1, from before a copy held birthday ticks, holds none — `design.md`
        // § *The copy's form moves to 2, and form 1 holds no ticks*. A document at form 2 or
        // later with no birthday ticks, or ticks that do not form as their own shape, is damaged.
        let formedBirthdayTicks: BirthdayTicks
        if envelope.version >= 2 {
            guard let birthdayTicks = document.birthdayTicks,
                let formed = BirthdayStore.formed(from: birthdayTicks)
            else {
                return .failure(.damagedCopy)
            }
            formedBirthdayTicks = formed
        } else {
            formedBirthdayTicks = BirthdayTicks()
        }

        // A commitment the nested roster held removed, in a form written before a commitment
        // could be deleted, is read as deleted — its records go with it, exactly as they would
        // reading that roster at its own place. `design.md` § *Migration*.
        var history = formedRecord.history
        _ = history.erase(formedRoster.erased)

        return .success(
            Copy(
                moment: moment, history: history, roster: formedRoster.roster,
                oneOffs: formedOneOffs, birthdayTicks: formedBirthdayTicks))
    }

    /// The four nested stores' own envelopes, each read independently — a store whose object is
    /// missing, or is not an object at all, answers `nil` for that store alone rather than failing
    /// the whole decode, so a broken record does not hide a roster written in a later form.
    private struct StoreEnvelopes: Decodable {
        var record: RecordDocumentEnvelope?
        var roster: RosterDocumentEnvelope?
        var oneOffs: OneOffDocumentEnvelope?
        var birthdayTicks: BirthdayDocumentEnvelope?

        private enum CodingKeys: String, CodingKey {
            case record, roster, oneOffs, birthdayTicks
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            record = try? container.decode(RecordDocumentEnvelope.self, forKey: .record)
            roster = try? container.decode(RosterDocumentEnvelope.self, forKey: .roster)
            oneOffs = try? container.decode(OneOffDocumentEnvelope.self, forKey: .oneOffs)
            birthdayTicks = try? container.decode(
                BirthdayDocumentEnvelope.self, forKey: .birthdayTicks)
        }
    }
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
