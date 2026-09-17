import SwiftUI
import Charts
import DayByDayKit

/// One commitment seen on its own, over everything since the day it is kept from. Reached by a
/// `NavigationLink` on `CommitmentsView`'s kept or stopped row. Draws `lookBack`'s fields and
/// lines in the order it says them, decides nothing and offers no control — `design.md` § *The
/// shell rides this Story*: the kit already answered every rule a page shows.
///
/// **Layout is Option B of the G7 proposal** (PR #280), amended by the `look-back-layout` shell
/// chore, again by `look-back-name-twice`, and again by `look-back-at-a-quota`'s Option A (the
/// same table, with week rows added — `design.md` § *What the shell draws*). The name-twice
/// chore had the bar carry the name alone; the owner preferred it said twice, so the name is back
/// both in the navigation bar and as a `.largeTitle` in the body, with the rhythm beneath it. What
/// the first chore did to the dates stands: the two half-width "Kept from"/"Kept until" cards
/// wrapped a date like "15 September 2026" onto a second line (walk W.3 on PR #280), so they read
/// as two rows of one card, label left and value right, wide enough that no date wraps; a
/// commitment still kept draws only the "Kept from" row rather than a "—" that would say nothing.
/// The heading over the lines — "Weeks", "Months" or "Months and weeks" — and the `Grid` carry the
/// same horizontal inset as the cards' own inner padding, so the line labels and the card labels
/// share a left edge and the fractions share the cards' right edge. Still a hand-drawn
/// `ScrollView` and `Grid` rather than the platform `List` the rest of the shell is built from, so
/// the whole — the one summary figure this screen has — can read as a scoreboard rather than
/// another row. The rhythm-change line is the one composition among these seam strings: it joins
/// the rhythm and its day with a middle dot. Every other card and row draws exactly what
/// `LookBack` hands it.
///
/// Holds `screen` and `commitment` rather than an already-formed `LookBack`, so the day-by-day
/// walk `screen.lookBack(at:)` sits behind `body` and runs once per body pass — read into a
/// local at the top of `body` rather than through the computed property at every use — never
/// while `CommitmentsView`'s row is merely constructed, eagerly, on every redraw of every row on
/// both its lists. G7 finding 2 on #272.
///
/// **A number's graph is Option A of the #274 grill** (`design.md` § *What the shell draws*): a
/// segmented picker of four spans above a graph card of the dates card's own fill and radius,
/// drawn with Swift Charts — `design.md` § *The shell rides this Story*. `span` is the shell's own
/// drawing state, crossing no seam: it decides which fixed length of days is in view and where the
/// plot opens, never what the graph says. A page whose look-back says no graph, for a number
/// commitment specifically, says "No number yet." in place of the shell's sentence for a page of
/// fractions, which every other kind keeps.
struct LookBackView: View {
    let screen: CommitmentsScreen
    let commitment: Commitment

    @State private var span: Span = .month

    private var lookBack: LookBack? { screen.lookBack(at: commitment) }

    /// The four spans the picker offers, grill decision 7 — each the longest calendar month,
    /// quarter and year, so "Month" covers a month whichever month it is, and "All" the whole span
    /// in the width. Shell drawing state, not a rule: `design.md` § *The shell rides this Story*.
    private enum Span: String, CaseIterable, Hashable {
        case month = "Month"
        case threeMonths = "3 months"
        case year = "Year"
        case all = "All"

        var lengthInDays: Int? {
            switch self {
            case .month: return 31
            case .threeMonths: return 92
            case .year: return 366
            case .all: return nil
            }
        }
    }

    var body: some View {
        let lookBack = lookBack
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if let lookBack {
                    head(lookBack)
                    cards(lookBack)
                    if let graph = lookBack.graph {
                        graphSection(graph)
                    } else if case .number = commitment.kind {
                        Text("No number yet.")
                    } else {
                        linesSection(lookBack)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(lookBack?.name ?? "")
    }

    @ViewBuilder
    private func head(_ lookBack: LookBack) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(lookBack.name)
                .font(.largeTitle.bold())
            Text(lookBack.rhythmInWords)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func cards(_ lookBack: LookBack) -> some View {
        datesCard(lookBack)

        if let whole = lookBack.whole {
            card(label: "The whole") {
                Text(whole)
                    .font(.title.monospacedDigit())
            }
        }
    }

    /// "Kept from", and "Kept until" beneath it only where the commitment is no longer kept —
    /// `design.md` § *The shell rides this Story*. One card, not two: a date like
    /// "15 September 2026" does not fit a half-width card on one line.
    @ViewBuilder
    private func datesCard(_ lookBack: LookBack) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            dateRow(label: "Kept from", value: lookBack.keptFromInWords)
            if let keptUntilInWords = lookBack.keptUntilInWords {
                Divider()
                dateRow(label: "Kept until", value: keptUntilInWords)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private func dateRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Spacer()
            Text(value)
        }
        .padding(.vertical, 6)
    }

    @ViewBuilder
    private func card<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    @ViewBuilder
    private func linesSection(_ lookBack: LookBack) -> some View {
        if lookBack.lines.isEmpty {
            Text("Nothing is counted here yet.")
        } else {
            // The extra `.padding(.horizontal)` below matches the cards' own inner padding, so
            // the line labels and the rhythm-change line align with the cards' text rather than
            // the page's own edge. The heading names the unit the lines below it are said in —
            // "Weeks" where every line is a week, "Months" where every line is a month, "Months
            // and weeks" where the chain mixes — read off the cases `lookBack.lines` holds,
            // deciding nothing else. `design.md` § *What the shell draws*.
            Text(heading(for: lookBack.lines))
                .font(.headline)
                .padding(.horizontal)
            Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 6) {
                ForEach(Array(lookBack.lines.enumerated()), id: \.offset) { _, line in
                    lookBackLine(line)
                }
            }
            .padding(.horizontal)
        }
    }

    private func heading(for lines: [LookBack.Line]) -> String {
        let hasMonth = lines.contains { if case .month = $0 { return true }; return false }
        let hasWeek = lines.contains { if case .week = $0 { return true }; return false }
        switch (hasMonth, hasWeek) {
        case (true, true): return "Months and weeks"
        case (true, false): return "Months"
        case (false, true): return "Weeks"
        case (false, false):
            // Unreached: `linesSection(_:)` only calls this where `lookBack.lines` is non-empty,
            // and a `.rhythmChanged` line is only ever appended immediately above a month or a
            // week line, never on its own — so a non-empty `lines` always holds at least one of
            // the two this switch tests for.
            return ""
        }
    }

    @ViewBuilder
    private func lookBackLine(_ line: LookBack.Line) -> some View {
        switch line {
        case .month(let inWords, let fraction), .week(let inWords, let fraction):
            GridRow {
                Text(inWords)
                Text(fraction)
                    .monospacedDigit()
                    .gridColumnAlignment(.trailing)
            }
            GridRow {
                Divider()
                    .gridCellColumns(2)
            }
        case .rhythmChanged(let inWords, let from):
            GridRow {
                VStack(spacing: 6) {
                    doubleRule
                    Text("\(inWords) · \(from)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    doubleRule
                }
                .frame(maxWidth: .infinity)
                .gridCellColumns(2)
            }
        }
    }

    private var doubleRule: some View {
        VStack(spacing: 2) {
            Divider()
            Divider()
        }
    }

    /// The picker of spans above the graph card — grill decisions 6 and 7. "Month" is selected on
    /// opening (`span`'s default), and every span keeps the plot scrollable sideways.
    @ViewBuilder
    private func graphSection(_ graph: LookBack.Graph) -> some View {
        Picker("Span", selection: $span) {
            ForEach(Span.allCases, id: \.self) { span in
                Text(span.rawValue).tag(span)
            }
        }
        .pickerStyle(.segmented)

        graphCard(graph)
    }

    /// The graph card: the trace through `graph.points` in the label colour (never the accent,
    /// ADR-1045), the two bounds on a values axis pinned at the left, a dates axis off `graph.days`
    /// and `graph.months`, and an era-boundary rule for each of `graph.rules` — `design.md` § *What
    /// the shell draws*. `chartXVisibleDomain(length:)` holds `span`'s fixed length of days in the
    /// width; `chartScrollPosition(initialX:)` opens the plot at the newest end, so the trace runs
    /// off the left edge and stops flush at the right (grill decision 8).
    @ViewBuilder
    private func graphCard(_ graph: LookBack.Graph) -> some View {
        let lowest = (graph.lowest as NSDecimalNumber).doubleValue
        let highest = (graph.highest as NSDecimalNumber).doubleValue
        let visibleLength = Double(span.lengthInDays ?? graph.days.count)
        let openingPosition = Double(graph.days.count) - visibleLength
        let showsMonths = span == .year || span == .all

        Chart {
            ForEach(graph.points, id: \.day) { point in
                LineMark(
                    x: .value("Day", point.day),
                    y: .value("Value", (point.value as NSDecimalNumber).doubleValue)
                )
                .foregroundStyle(.secondary)
            }
            ForEach(graph.rules, id: \.day) { rule in
                RuleMark(x: .value("Boundary", rule.day))
                    .foregroundStyle(.secondary)
                    .lineStyle(StrokeStyle(dash: [4, 4]))
            }
        }
        .chartYScale(domain: lowest...highest)
        .chartYAxis {
            AxisMarks(position: .leading, values: [lowest, highest]) { value in
                AxisValueLabel {
                    if let raw = value.as(Double.self) {
                        Text(raw == lowest ? graph.lowestInWords : graph.highestInWords)
                    }
                }
            }
        }
        .chartXAxis {
            if showsMonths {
                AxisMarks(values: graph.months.map(\.day)) { value in
                    if let raw = value.as(Double.self), graph.months.contains(where: { $0.day == Int(raw.rounded()) }) {
                        AxisGridLine()
                        AxisValueLabel {
                            Text(graph.months.first { $0.day == Int(raw.rounded()) }!.inWords)
                        }
                    }
                }
            } else {
                AxisMarks(values: .automatic(desiredCount: 3)) { value in
                    if let raw = value.as(Double.self), graph.days.indices.contains(Int(raw.rounded())) {
                        AxisGridLine()
                        AxisValueLabel {
                            Text(graph.days[Int(raw.rounded())])
                        }
                    }
                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: visibleLength)
        .chartScrollPosition(initialX: openingPosition)
        // The era label lane: an overlay rather than each `RuleMark`'s own `.annotation`, which
        // was measured to distort the chart's own x-scale when the label text ran wide.
        .chartOverlay { proxy in
            GeometryReader { geometry in
                if let plotFrame = proxy.plotFrame {
                    let frame = geometry[plotFrame]
                    ForEach(graph.rules, id: \.day) { rule in
                        if let x = proxy.position(forX: rule.day) {
                            Text("\(rule.rhythmInWords) · \(rule.fromInWords)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .fixedSize()
                                .position(x: frame.minX + x, y: frame.maxY + 12)
                        }
                    }
                }
            }
        }
        .frame(height: 220)
        .padding()
        .padding(.bottom, 16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}
