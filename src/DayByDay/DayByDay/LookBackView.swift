import SwiftUI
import Charts
import UIKit
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
        let rawLowest = (graph.lowest as NSDecimalNumber).doubleValue
        let rawHighest = (graph.highest as NSDecimalNumber).doubleValue
        // A graph of one point, or a range the kit declares with equal ends, answers the same
        // value for both bounds — a zero-width `chartYScale` domain, which draws nothing and
        // stacks the two axis labels on each other. Widened here only for the plotted scale and
        // the axis ticks' own positions; `graph.lowestInWords`/`highestInWords`, what each label
        // says, are untouched.
        let isDegenerate = rawHighest == rawLowest
        let yPadding = isDegenerate ? max(abs(rawLowest), 1) * 0.1 : 0
        let lowest = rawLowest - yPadding
        let highest = rawHighest + yPadding
        let visibleDayCount = span.lengthInDays ?? graph.days.count
        // A day is a point, not a bar: showing `visibleDayCount` of them is a continuous domain
        // span one unit narrower than the count itself (day 0 through day 30 is 31 points over a
        // span of 30). `chartXVisibleDomain(length:)` takes that span, not the count — passing
        // the count left the window one unit wider than its own content, which is what the
        // trailing gap after the newest day actually was. Floored at 1, not 0: "All" derives
        // `visibleDayCount` from the history itself, and a history of exactly one real day would
        // otherwise hand both `chartXVisibleDomain` and `chartXScale` a zero-width span — the
        // same defect the values axis has just been widened against, on the other axis.
        let visibleSpan = Double(max(visibleDayCount - 1, 1))
        let showsMonths = span == .year || span == .all
        // The last real day sits at `domainEnd`; for it to draw flush at the plot's own right
        // edge on opening, the visible window's own right edge must land exactly there too —
        // `openingPosition + visibleSpan == domainEnd`. A history shorter than the span's own
        // length has nowhere to scroll to, so the domain's start is widened to the span's own
        // length the same way, rather than leaving the trace anchored at the oldest day.
        let domainEnd = Double(max(graph.days.count - 1, 0))
        let openingPosition = domainEnd - visibleSpan
        let domainStart = min(openingPosition, 0)
        // Three day labels at the sixths of the fixed-length window (so a label centred on the
        // window's own first or last day is not half clipped by the chart's own edge), keeping
        // only the ones landing on a real day — a history shorter than the window leaves the
        // rest as blank space, so early on this says one day or two rather than crowding three
        // dates that would otherwise overlap. `design.md` § *What the shell draws*'s designer
        // note: "about three across the width", true once the window is full.
        let dayTickValues: [Int] = {
            let sampled = (0..<3).compactMap { step -> Int? in
                let day = Int((openingPosition + visibleSpan * (Double(step) + 0.5) / 3).rounded())
                return graph.days.indices.contains(day) ? day : nil
            }
            // A history short enough against the window's own length can miss all three sixths
            // — a one-day history under "Month" always does — leaving the page saying no day at
            // all. The newest real day is the fallback: it is what the trace's own rightmost
            // point already sits on.
            guard sampled.isEmpty, let newestRealDay = graph.days.indices.last else {
                return sampled
            }
            return [newestRealDay]
        }()

        Chart {
            ForEach(graph.points, id: \.day) { point in
                // `.symbol(.circle)` marks every point along the trace — without it a `LineMark`
                // draws only the segments between points, so a graph of exactly one point, with
                // no segment to stroke, drew nothing at all.
                LineMark(
                    x: .value("Day", point.day),
                    y: .value("Value", (point.value as NSDecimalNumber).doubleValue)
                )
                .foregroundStyle(Color.secondary)
                .symbol(.circle)
                .symbolSize(20)
            }
            ForEach(graph.rules, id: \.day) { rule in
                RuleMark(x: .value("Boundary", rule.day))
                    .foregroundStyle(Color.secondary)
                    .lineStyle(StrokeStyle(dash: [4, 4]))
            }
        }
        .chartYScale(domain: lowest...highest)
        .chartYAxis {
            // Gridlines only — the values themselves draw in the overlay below, inset from the
            // card's own edge the way the dates card's labels are, which `chartPlotStyle` also
            // achieves but was measured to clip a lone point's own symbol on a one-day history:
            // narrowing the plot area changed how a mark with no line to anchor it to the visible
            // region was clipped, even though the plot's own trailing edge was untouched.
            AxisMarks(position: .leading, values: [lowest, highest]) { _ in
                AxisGridLine()
            }
        }
        .chartXAxis {
            AxisMarks(values: showsMonths ? graph.months.map(\.day) : dayTickValues) { _ in
                AxisGridLine()
            }
        }
        // `range: .plotDimension(padding:)` — Swift Charts otherwise reserves a percentage of the
        // plot's own width as padding around whatever domain is given, on both ends, which is
        // what kept the newest real day short of the plot's own right edge. Zero padding in turn
        // clips a point's own symbol in half where it sits exactly on the domain's edge, which the
        // newest real day always does — 4pt is enough to hold the whole symbol
        // (`.symbolSize(20)`'s own diameter is about 5pt) clear of that edge without reading as a
        // gap the way the default percentage-based padding did.
        .chartXScale(domain: domainStart...domainEnd, range: .plotDimension(padding: 4))
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: visibleSpan)
        .chartScrollPosition(initialX: openingPosition)
        // The values-axis labels, the dates-axis labels and the era label lane are drawn here
        // rather than as each `AxisMark`'s own `AxisValueLabel` or a `RuleMark`'s `.annotation`:
        // all three were measured to either clip a label the card's own edge sits under, distort
        // the chart's own x-scale when a label ran wide, or (the values axis specifically) clip a
        // lone point's own symbol on a one-day history. `Self.measuredWidth(...)` reads each
        // label's own rendered size rather than estimating it from its character count, since
        // nothing here otherwise stops one sliding past the card. The dates-axis labels'
        // `trailingInset` matches the values-axis label's own fixed 16pt leading inset and the
        // dates card's own inset, so a label sitting near the newest day — which the trace itself
        // still runs flush to, finding 5 — reads inset from the card's edge rather than touching
        // it.
        .chartOverlay { proxy in
            GeometryReader { geometry in
                if let plotFrame = proxy.plotFrame {
                    let frame = geometry[plotFrame]
                    if let lowestY = proxy.position(forY: lowest) {
                        Text(graph.lowestInWords)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .fixedSize()
                            .position(
                                x: frame.minX + 16 + Self.measuredWidth(graph.lowestInWords) / 2,
                                y: frame.minY + lowestY)
                    }
                    if let highestY = proxy.position(forY: highest) {
                        Text(graph.highestInWords)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .fixedSize()
                            .position(
                                x: frame.minX + 16 + Self.measuredWidth(graph.highestInWords) / 2,
                                y: frame.minY + highestY)
                    }
                    if showsMonths {
                        ForEach(graph.months, id: \.day) { month in
                            if let x = proxy.position(forX: month.day) {
                                Text(month.inWords)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .fixedSize()
                                    .position(
                                        x: Self.clampedCenterX(
                                            frame.minX + x, in: frame,
                                            width: Self.measuredWidth(month.inWords), trailingInset: 16),
                                        y: frame.maxY + 14)
                            }
                        }
                    } else {
                        ForEach(dayTickValues, id: \.self) { day in
                            if let x = proxy.position(forX: day) {
                                Text(graph.days[day])
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .fixedSize()
                                    .position(
                                        x: Self.clampedCenterX(
                                            frame.minX + x, in: frame,
                                            width: Self.measuredWidth(graph.days[day]), trailingInset: 16),
                                        y: frame.maxY + 14)
                            }
                        }
                    }
                    // Left-aligned to its own rule, `design.md` § *What the shell draws*, rather
                    // than centred on it like the dates-axis labels above — shunted left only
                    // where the rule sits close enough to the plot's trailing edge that the label
                    // would otherwise overhang the card.
                    ForEach(graph.rules, id: \.day) { rule in
                        if let x = proxy.position(forX: rule.day) {
                            let label = "\(rule.rhythmInWords) · \(rule.fromInWords)"
                            Text(label)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .fixedSize()
                                .position(
                                    x: Self.leftAlignedCenterX(
                                        frame.minX + x, in: frame, width: Self.measuredWidth(label),
                                        trailingInset: 16),
                                    y: frame.maxY + 30)
                        }
                    }
                }
            }
        }
        .frame(height: 220)
        // No horizontal padding: the trace runs off the left edge and stops flush at the right,
        // `design.md` § *What the shell draws* — a leading or trailing inset here is exactly the
        // gap after the newest day the reviewer measured, the outer padding rather than anything
        // left unused by the domain itself.
        .padding(.top)
        .padding(.bottom, 48)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    /// `text`'s own rendered width at the `.caption2` size every overlay label in `graphCard(_:)`
    /// draws at — measured rather than estimated from its character count, which a proportional
    /// font makes an unreliable guide to how wide a label actually is.
    private static func measuredWidth(_ text: String) -> CGFloat {
        (text as NSString).size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: .caption2)])
            .width
    }

    /// `x`, the centre a label of `width` would need to sit fully inside `frame` — pulled inward
    /// from either edge only enough that the label does not overhang the card, which nothing else
    /// stops since these labels draw with no layout system reserving room for them, unlike a
    /// native `AxisValueLabel`. `trailingInset` widens the trailing bound only, so a label near
    /// the newest day reads inset from the card's edge the way the dates card's own labels are,
    /// without moving the trace or the rule themselves off the flush edge finding 5 puts them at.
    private static func clampedCenterX(
        _ x: CGFloat, in frame: CGRect, width: CGFloat, trailingInset: CGFloat = 0
    ) -> CGFloat {
        let halfWidth = width / 2
        return min(max(x, frame.minX + halfWidth), frame.maxX - trailingInset - halfWidth)
    }

    /// The centre a label of `width` needs to sit with its own leading edge at `x` — left-aligned
    /// to the rule it names, `design.md` § *What the shell draws* — shunted left only where that
    /// would run the label past `frame`'s trailing edge, `trailingInset` inward.
    private static func leftAlignedCenterX(
        _ x: CGFloat, in frame: CGRect, width: CGFloat, trailingInset: CGFloat = 0
    ) -> CGFloat {
        let leadingX = min(x, frame.maxX - trailingInset - width)
        return max(leadingX, frame.minX) + width / 2
    }
}
