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
/// another row. Every card and row draws exactly what `LookBack` hands it — nothing here composes
/// a string of its own, `say-nothing-where-the-rhythm-changed` (#300) having taken the one line
/// that did.
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
    // Where the two values-axis labels sit in the lane beside the chart — read once from the
    // chart's own `ChartProxy` inside `graphCard(_:)` and cached here, since the lane is a
    // sibling view of the `Chart` with no access to the proxy itself. Third G7 round, finding 3.
    @State private var lowestLabelY: CGFloat?
    @State private var highestLabelY: CGFloat?
    // The card's own rendered width, read once the same way — fourth G7 round, finding E: the
    // values-axis lane is clamped to a fraction of this rather than left free to swallow the
    // plot down to a sliver on an extreme value.
    @State private var cardWidth: CGFloat?
    // How far the plot's own bottom edge sits above the chart's fixed 220pt frame — 0 here,
    // architecturally: neither axis draws a value label that would reserve room below the plot,
    // so the chart's own frame and its plot area share one bottom edge. Read off the chart's own
    // geometry in `updateValueLabelPositions(...)` rather than assumed, in case that ever stops
    // holding, but — unlike the dates-axis label's own offset and rendered height, below — it
    // does not depend on text size, so it alone is what the card's bottom padding caches. G7
    // second fix round, finding 1a: caching the *whole* padding, offset and height included,
    // left it stale through a Dynamic Type change made while this view stayed on screen, since
    // neither of `updateValueLabelPositions`'s own triggers — the chart's geometry, and whether
    // its plot frame has resolved — moves on that change; the label's own font does, immediately,
    // because `.font(.caption2)` reads it inline on every redraw. The offset and the measured
    // height join this at the padding's own call site instead, read inline the same way, so nothing
    // needs a new trigger to keep them current.
    @State private var plotBottomInset: CGFloat = 0
    // The day of the point a tap picked, whose value draws in a callout above it — shell drawing
    // state, crossing no seam: the point already says its value in words, the graph only never
    // showed it. Cleared by a second tap on the same point, a tap away from every point, or a
    // change of span.
    @State private var selectedDay: Int?
    // The plot's own leading edge inside the chart, cached beside the values-axis labels'
    // positions — a tap arrives in the chart's own space, `proxy.position(forX:)` answers in the
    // plot's.
    @State private var plotMinX: CGFloat = 0
    // Which notes are open — a set of places in `lookBack.notes`, empty on every visit (grill
    // decision 10). Shell drawing state, crossing no seam: `design.md` § *The fold is drawn, not
    // said*.
    @State private var openNoteIndices: Set<Int> = []
    // Whether a note is cut, keyed by its place in `lookBack.notes` — measured by `FoldMeasurer`
    // below at each card's own width and settled once its layout has run, so this starts empty
    // and fills in rather than being computed synchronously. G7 fix round, finding 3.
    @State private var isCutByIndex: [Int: Bool] = [:]

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
                    } else if case .total = commitment.kind {
                        // No graph card and no picker — `design.md` § *The shell rides this
                        // Story*, grill decisions 7 and 8: the sentence names what a person does
                        // on the day screen, which is add.
                        Text("Nothing added yet.")
                    } else if case .note = commitment.kind {
                        noteSection(lookBack)
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
            // the line labels align with the cards' text rather than the page's own edge. The
            // heading names the unit the lines below it are said in —
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
            // and a non-empty `lines` is only ever a month line or a week line, never anything
            // else — so it always holds at least one of the two this switch tests for.
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
        }
    }

    /// A note page: `noteCountInWords` as a `.headline` where the "Months" heading stands, then
    /// one card per note, newest first — `design.md` § *The shell rides this Story*. Where
    /// `notes` is empty the page says "No note yet." and draws no heading (grill decision 7). The
    /// heading alone is indented; the cards share the dates card's own edges. G7 fix round,
    /// finding 2: an extra `.padding(.horizontal)` on the `LazyVStack` used to indent the cards a
    /// second time, on top of the inset the outer `ScrollView`'s content already carries.
    @ViewBuilder
    private func noteSection(_ lookBack: LookBack) -> some View {
        if lookBack.notes.isEmpty {
            Text("No note yet.")
        } else {
            if let noteCountInWords = lookBack.noteCountInWords {
                Text(noteCountInWords)
                    .font(.headline)
                    .padding(.horizontal)
            }
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(Array(lookBack.notes.enumerated()), id: \.offset) { index, note in
                    noteCard(note, index: index)
                }
            }
        }
    }

    /// One note's card, the dates card's own fill and radius — only a note the shell measures as
    /// cut at this card's own width is a `Button`, and the whole card toggles it (grill decisions
    /// 9 and 15); a note that fits draws the same content with no button behaviour at all, never
    /// merely a disabled one, so nothing reads as tappable that is not. The card's own padding is
    /// part of the label, with `.contentShape(Rectangle())` over it — `ContentView.swift`'s tick
    /// row is the repo's own precedent — so the whole card is the hit target rather than only
    /// where the text glyphs sit. G7 fix round, finding 1: the `Button` used to wrap
    /// `noteCardContent` alone, with the padding and the background applied outside it, so a tap
    /// on the card's own margin fell through to nothing.
    @ViewBuilder
    private func noteCard(_ note: LookBack.DatedNote, index: Int) -> some View {
        let isOpen = openNoteIndices.contains(index)
        let isCut = isCutByIndex[index] ?? false
        let content = noteCardContent(note, isOpen: isOpen)
            .background(
                FoldMeasurer(text: note.text) { measuredIsCut in
                    if isCutByIndex[index] != measuredIsCut {
                        isCutByIndex[index] = measuredIsCut
                    }
                }
            )

        Group {
            if isCut {
                Button {
                    withAnimation {
                        if isOpen {
                            openNoteIndices.remove(index)
                        } else {
                            openNoteIndices.insert(index)
                        }
                    }
                } label: {
                    content
                        .padding()
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            } else {
                content
                    .padding()
            }
        }
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    /// A note card's own content: the day in `.caption` semibold, not uppercased, and the text
    /// beneath it — folded to two lines with a tail ellipsis, or unlimited and open, line breaks
    /// as written either way. `design.md` § *The shell rides this Story*.
    @ViewBuilder
    private func noteCardContent(_ note: LookBack.DatedNote, isOpen: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.dayInWords)
                .font(.caption)
                .fontWeight(.semibold)
            Text(note.text)
                .multilineTextAlignment(.leading)
                .lineLimit(isOpen ? nil : 2)
                .truncationMode(.tail)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
        .onChange(of: span) { _, _ in selectedDay = nil }

        graphCard(graph)
    }

    /// The graph card: the trace through `graph.points` in the label colour (never the accent,
    /// ADR-1045), the two bounds on a values axis pinned in a lane at the left, and a dates axis
    /// off `graph.days` and `graph.months` — `design.md` § *What the shell draws*.
    /// `chartXVisibleDomain(length:)` holds `span`'s fixed length of days in the width;
    /// `chartScrollPosition(initialX:)` opens the plot at the newest end, so the trace runs off
    /// the left edge and stops flush at the right (grill decision 8).
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

        // The values-axis lane's own fixed width: wide enough for whichever of the two bound
        // labels measures wider, plus the same 16pt inset the dates card's own labels sit at — a
        // column beside the chart rather than an inset *inside* it, so the chart's own plot
        // begins only after this lane and nothing drawn on it — gridline, trace or a lone point's
        // own symbol — can pass beneath a value label (`design.md` § *What the shell draws*:
        // "pinned in a lane at the left; it does not scroll"). A `chartPlotStyle` leading pad was
        // tried first for this and reverted (finding 3, third G7 round): narrowing the plot area
        // from *inside* the chart, rather than giving the chart itself less width, clipped a lone
        // point's own symbol out entirely on a one-day history.
        //
        // Clamped to 30% of the card's own width, finding E, fourth round: `graph.lowestInWords`/
        // `highestInWords` come from `TypedNumber.read`, which hands back a thirty-eight-digit
        // whole plainly (`design.md` § *Context*) — unclamped, that reads as roughly two thirds of
        // a phone-width card, leaving the plot a sliver. `cardWidth` is read the same way the
        // label positions are, below, and stands unclamped for the one frame before it is known.
        let unclampedLaneWidth = max(
            Self.measuredWidth(graph.lowestInWords),
            Self.measuredWidth(graph.highestInWords)
        ) + 16
        let valueLabelLaneWidth =
            cardWidth.map { min(unclampedLaneWidth, max($0 * 0.3, 60)) } ?? unclampedLaneWidth
        // The space left for a label's own ink once the lane's fixed 16pt inset is spent — finding
        // A, fourth round: centring each label in the lane split that inset 8/8, reading short of
        // the dates card's own 16pt, and let the two bounds' ink land on different edges depending
        // on which read wider. Trailing-aligned in this width instead, both labels' ink now meets
        // the same edge — the axis, `design.md` § *What the shell draws* draws them against it —
        // with the inset never less than 16pt regardless of which bound is the narrower string.
        // `.lineLimit(1)` in place of `.fixedSize()` is what lets a label wider than the clamped
        // lane truncate rather than overflow it.
        let valueLabelContentWidth = max(valueLabelLaneWidth - 16, 0)

        HStack(alignment: .top, spacing: 8) {
            ZStack(alignment: .topLeading) {
                if let lowestLabelY {
                    Text(graph.lowestInWords)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .frame(width: valueLabelContentWidth, alignment: .trailing)
                        .position(x: 16 + valueLabelContentWidth / 2, y: lowestLabelY)
                }
                if let highestLabelY {
                    Text(graph.highestInWords)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .frame(width: valueLabelContentWidth, alignment: .trailing)
                        .position(x: 16 + valueLabelContentWidth / 2, y: highestLabelY)
                }
            }
            .frame(width: valueLabelLaneWidth, height: 220)

            Chart {
                ForEach(graph.points, id: \.day) { point in
                    // `.symbol(.circle)` marks every point along the trace — without it a
                    // `LineMark` draws only the segments between points, so a graph of exactly
                    // one point, with no segment to stroke, drew nothing at all. A number's point
                    // draws exactly as it did — `design.md` § *The shell rides this Story*.
                    LineMark(
                        x: .value("Day", point.day),
                        y: .value("Value", (point.value as NSDecimalNumber).doubleValue)
                    )
                    .foregroundStyle(Color.secondary)
                    .symbol(.circle)
                    .symbolSize(20)
                }

                // A total's kept point is ringed, its dot in the label colour rather than the
                // secondary colour every other dot draws in — a solid fill laid over the shipped
                // dot to recolour it, plus the ring around it, both in `Color.primary`, so a
                // not-kept point stays exactly the secondary dot above with no ring.
                // `design.md` § *What the shell draws*.
                ForEach(graph.points.filter { $0.isKept == true }, id: \.day) { point in
                    PointMark(
                        x: .value("Day", point.day),
                        y: .value("Value", (point.value as NSDecimalNumber).doubleValue)
                    )
                    .symbol {
                        ZStack {
                            Circle()
                                .fill(Color.primary)
                                .frame(width: 6, height: 6)
                            Circle()
                                .strokeBorder(Color.primary, lineWidth: 1.5)
                                .frame(width: 10, height: 10)
                        }
                    }
                }

                // The target rule: one dashed secondary segment per stretch, from half a day
                // before `from` through half a day past `through` at its own `target`, with no
                // riser between two — each stretch its own `series`, so Swift Charts never joins
                // one stretch's end to the next one's start. The half-day extension on both ends
                // is what gives a one-day stretch (`from == through`, a target changed today
                // through the edit sheet) a segment with real width to draw rather than the
                // zero-length line two marks at the same point make; it also meets the next
                // stretch's own half-day extension exactly at their shared boundary, so every day
                // of the graph carries its target's rule with nothing left between two stretches.
                // `design.md` § *The rule is stretches, not a target per day*.
                // The tapped point's marker: a thin vertical rule through its day, under the
                // callout the overlay draws above the point.
                if let selectedDay, graph.points.contains(where: { $0.day == selectedDay }) {
                    RuleMark(x: .value("Day", selectedDay))
                        .foregroundStyle(Color.secondary.opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 1))
                }

                ForEach(Array(graph.targetRule.enumerated()), id: \.offset) { index, stretch in
                    let target = (stretch.target as NSDecimalNumber).doubleValue
                    LineMark(
                        x: .value("Day", Double(stretch.from) - 0.5), y: .value("Target", target),
                        series: .value("Stretch", index)
                    )
                    .foregroundStyle(Color.secondary)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                    LineMark(
                        x: .value("Day", Double(stretch.through) + 0.5),
                        y: .value("Target", target),
                        series: .value("Stretch", index)
                    )
                    .foregroundStyle(Color.secondary)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                }
            }
            .modifier(
                ValuesAxisPadding(
                    domain: lowest...highest, drawsTargetRule: !graph.targetRule.isEmpty))
            .chartYAxis {
                // Gridlines only — the values themselves draw in the lane beside the chart.
                AxisMarks(position: .leading, values: [lowest, highest]) { _ in
                    AxisGridLine()
                }
            }
            .chartXAxis {
                AxisMarks(values: showsMonths ? graph.months.map(\.day) : dayTickValues) { _ in
                    AxisGridLine()
                }
            }
            // `range: .plotDimension(padding:)` — Swift Charts otherwise reserves a percentage of
            // the plot's own width as padding around whatever domain is given, on both ends,
            // which is what kept the newest real day short of the plot's own right edge. Zero
            // padding in turn clips a point's own symbol in half where it sits exactly on the
            // domain's edge, which the newest real day always does — 4pt is enough to hold the
            // whole symbol (`.symbolSize(20)`'s own diameter is about 5pt) clear of that edge
            // without reading as a gap the way the default percentage-based padding did.
            .chartXScale(domain: domainStart...domainEnd, range: .plotDimension(padding: 4))
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: visibleSpan)
            .chartScrollPosition(initialX: openingPosition)
            // A tap picks the point nearest it across the dates axis, within a fingertip's
            // reach; a tap on the picked point again, or away from every point, clears it. A tap
            // rather than `chartXSelection`'s own gesture, which on a horizontally scrollable
            // chart waits for a long press.
            .chartGesture { proxy in
                SpatialTapGesture().onEnded { value in
                    let tapX = value.location.x - plotMinX
                    let nearest = graph.points
                        .compactMap { point -> (day: Int, distance: CGFloat)? in
                            guard let x = proxy.position(forX: point.day) else { return nil }
                            return (point.day, abs(x - tapX))
                        }
                        .min { $0.distance < $1.distance }
                    guard let nearest, nearest.distance <= 22, nearest.day != selectedDay else {
                        selectedDay = nil
                        return
                    }
                    selectedDay = nearest.day
                }
            }
            // The dates-axis labels and the era label are drawn here rather than as each
            // `AxisMark`'s own `AxisValueLabel` or a `RuleMark`'s `.annotation`: both were
            // measured to either clip a label the card's own edge sits under or distort the
            // chart's own x-scale when a label ran wide. `Self.measuredWidth(...)` reads each
            // label's own rendered size rather than estimating it from its character count, since
            // nothing here otherwise stops one sliding past the card. Their `trailingInset`
            // matches the dates card's own inset, so a label sitting near the newest day — which
            // the trace itself still runs flush to, finding 5 — reads inset from the card's edge
            // rather than touching it. The values-axis labels draw in the lane beside the chart
            // instead, since they have no x-position to read off this proxy — only their own
            // fixed y-position, cached in state below and read by the lane.
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            updateValueLabelPositions(
                                proxy: proxy, geometry: geometry, lowest: lowest, highest: highest)
                        }
                        .onChange(of: geometry.size) { _, _ in
                            updateValueLabelPositions(
                                proxy: proxy, geometry: geometry, lowest: lowest, highest: highest)
                        }
                        // Finding D, fourth round: `proxy.plotFrame` read `nil` at `onAppear` on
                        // occasion, and `geometry.size` never changing again afterwards left the
                        // two values labels undrawn for good — neither event was ever going to
                        // fire a retry. `plotFrame` resolving from `nil` to a real rect between
                        // one render of this overlay and the next *is* a change this view goes
                        // through, so it is what this retries on instead.
                        .onChange(of: proxy.plotFrame != nil) { _, resolved in
                            guard resolved else { return }
                            updateValueLabelPositions(
                                proxy: proxy, geometry: geometry, lowest: lowest, highest: highest)
                        }
                    if let plotFrame = proxy.plotFrame {
                        let frame = geometry[plotFrame]
                        // Finding B, fourth round: `Self.clampedCenterX` alone only keeps a label
                        // inside the card's own edges, not clear of its neighbour — the values-axis
                        // lane (finding 3) narrowed the plot enough that the three-sixths day
                        // sampling's own labels could abut. `Self.degapped` drops whichever
                        // candidate would touch the last one already kept, reading left to right,
                        // so the month-span page still says two dates where two do fit — off each
                        // candidate's own `naturalX`, fifth round, so the trailing clamp below
                        // cannot manufacture a collision between two labels that do not touch at
                        // their own positions.
                        if showsMonths {
                            let candidates = graph.months.compactMap { month -> XAxisTick? in
                                guard let x = proxy.position(forX: month.day) else { return nil }
                                let width = Self.measuredWidth(month.inWords)
                                let naturalX = frame.minX + x
                                return XAxisTick(
                                    day: month.day, text: month.inWords,
                                    naturalX: naturalX,
                                    x: Self.clampedCenterX(
                                        naturalX, in: frame, width: width, trailingInset: 16),
                                    width: width)
                            }
                            ForEach(Self.degapped(candidates), id: \.day) { tick in
                                Text(tick.text)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .fixedSize()
                                    .position(x: tick.x, y: frame.maxY + Self.datesLabelOffset)
                            }
                        } else {
                            let candidates = dayTickValues.compactMap { day -> XAxisTick? in
                                guard let x = proxy.position(forX: day) else { return nil }
                                let text = graph.days[day]
                                let width = Self.measuredWidth(text)
                                let naturalX = frame.minX + x
                                return XAxisTick(
                                    day: day, text: text,
                                    naturalX: naturalX,
                                    x: Self.clampedCenterX(
                                        naturalX, in: frame, width: width, trailingInset: 16),
                                    width: width)
                            }
                            ForEach(Self.degapped(candidates), id: \.day) { tick in
                                Text(tick.text)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .fixedSize()
                                    .position(x: tick.x, y: frame.maxY + Self.datesLabelOffset)
                            }
                        }

                        if let selectedDay,
                            let point = graph.points.first(where: { $0.day == selectedDay }),
                            let x = proxy.position(forX: point.day),
                            let y = proxy.position(forY: (point.value as NSDecimalNumber).doubleValue)
                        {
                            let naturalX = frame.minX + x
                            if naturalX >= frame.minX && naturalX <= frame.maxX {
                                selectionCallout(
                                    point, on: graph.days[point.day],
                                    atX: naturalX, pointY: frame.minY + y, in: frame)
                            }
                        }

                        // Each stretch's own label, at its last day — the newest at the rule's
                        // newest end, each earlier one where the rule steps (grill decision 14).
                        // `design.md` § *The shell rides this Story*. Drawn only where `through`'s
                        // own natural position already falls inside the visible plot: unlike the
                        // dates-axis candidates above, `graph.targetRule` is not sampled from the
                        // visible window, so a stretch scrolled out of view — its own last day
                        // beyond either edge — would otherwise have `Self.clampedCenterX` pull its
                        // label back onto the frame's edge and pin it there under the wrong rule,
                        // or none at all where only an older stretch's line still crosses the
                        // window (W.5).
                        ForEach(Array(graph.targetRule.enumerated()), id: \.offset) { _, stretch in
                            if let x = proxy.position(forX: stretch.through),
                                let y = proxy.position(
                                    forY: (stretch.target as NSDecimalNumber).doubleValue)
                            {
                                let naturalX = frame.minX + x
                                if naturalX >= frame.minX && naturalX <= frame.maxX {
                                    let width = Self.measuredWidth(stretch.inWords)
                                    Text(stretch.inWords)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                        .fixedSize()
                                        .position(
                                            x: Self.clampedCenterX(
                                                naturalX, in: frame, width: width,
                                                trailingInset: 16),
                                            y: frame.minY + y - 10)
                                }
                            }
                        }
                    }
                }
            }
            .frame(height: 220)
        }
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear { cardWidth = geometry.size.width }
                    .onChange(of: geometry.size) { _, newSize in cardWidth = newSize.width }
            }
        )
        // No horizontal padding beyond the lane's own width: the trace runs off the left edge of
        // the plot and stops flush at the right, `design.md` § *What the shell draws* — a leading
        // or trailing inset on the chart itself here is exactly the gap after the newest day the
        // reviewer measured, the outer padding rather than anything left unused by the domain
        // itself.
        //
        // Not the 48pt a second, lower label lane once needed: the dates-axis labels alone draw
        // at `frame.maxY + Self.datesLabelOffset`, and this follows the dates lane at every text
        // size rather than a constant read once off the walk's third picture at the default one —
        // G7 fix round, finding 1: that constant cleared the axis labels at the default size with
        // nothing to spare, so it overflowed as soon as `.caption2`'s line height, at a larger
        // accessibility size, exceeded it. `Self.datesLabelOffset + Self.measuredHeight() / 2` is
        // read inline here, every time this card redraws, rather than cached — G7 second fix
        // round, finding 1a: cached, it went stale through a Dynamic Type change made while this
        // view stayed on screen, since nothing about that change touches `plotBottomInset`'s own
        // triggers. Reading it inline is what already keeps `Self.measuredWidth(...)` current for
        // the labels themselves, so the same read here needs no trigger of its own — it is simply
        // part of evaluating this card, which a Dynamic Type change already does.
        .padding(.top)
        .padding(.bottom, plotBottomInset + Self.datesLabelOffset + Self.measuredHeight() / 2)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    /// Where the two values-axis labels sit in the lane beside the chart — read once from the
    /// chart's own `ChartProxy`, since the lane is a sibling view of the `Chart` with no access to
    /// the proxy itself. `lowest`/`highest` never move once the graph loads (`span` changes only
    /// the x-domain), so `onAppear`, an `onChange` of the chart's own geometry size (covering the
    /// one Dynamic Type or rotation case that would move them), and an `onChange` of whether
    /// `proxy.plotFrame` has resolved yet (finding D, fourth G7 round) between them call this
    /// however this state gets to the point where the two labels can draw at all.
    private func updateValueLabelPositions(
        proxy: ChartProxy, geometry: GeometryProxy, lowest: Double, highest: Double
    ) {
        guard let plotFrame = proxy.plotFrame else { return }
        let frame = geometry[plotFrame]
        plotMinX = frame.minX
        lowestLabelY = proxy.position(forY: lowest).map { frame.minY + $0 }
        highestLabelY = proxy.position(forY: highest).map { frame.minY + $0 }
        // Text-size-independent, so this alone is safe to cache against these triggers — see
        // `plotBottomInset`'s own doc comment. Never negative: a plot frame that already reaches
        // the chart's own bottom edge needs none.
        plotBottomInset = max(0, frame.maxY - geometry.size.height)
    }

    /// The tapped point's callout: its value as the point says it — a total's "150 of 120", a
    /// number's "72.5" — over the day it was kept on, in a small card of the page's own fill,
    /// centred over the point and clamped inside the plot like every other overlay label. Drawn
    /// above the point, or below it where the point sits too near the plot's top for the callout
    /// to fit.
    private func selectionCallout(
        _ point: LookBack.Graph.Point, on day: String, atX x: CGFloat, pointY: CGFloat,
        in frame: CGRect
    ) -> some View {
        let valueFont = UIFont.preferredFont(forTextStyle: .footnote)
        let width = max(
            (point.inWords as NSString).size(withAttributes: [.font: valueFont]).width,
            Self.measuredWidth(day)
        ) + 16
        let height = valueFont.lineHeight + Self.measuredHeight() + 10
        let gap: CGFloat = 12
        let fitsAbove = pointY - gap - height >= frame.minY
        let centerY = fitsAbove ? pointY - gap - height / 2 : pointY + gap + height / 2
        return VStack(spacing: 2) {
            Text(point.inWords)
                .font(.footnote.weight(.semibold))
            Text(day)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .lineLimit(1)
        .fixedSize()
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(
            Color(.systemGroupedBackground), in: RoundedRectangle(cornerRadius: 8)
        )
        .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.secondary.opacity(0.3)))
        .position(x: Self.clampedCenterX(x, in: frame, width: width), y: centerY)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("LookBackGraphCallout")
    }

    /// The fixed offset, in points, from the plot's own bottom edge to a dates-axis label's
    /// centre — shared by where `graphCard(_:)` draws each label and where
    /// `updateValueLabelPositions(...)` derives the padding that keeps it inside the card, so the
    /// two stay tied by the same value rather than by a comment repeating it in both places
    /// (G7 fix round, finding 1).
    private static let datesLabelOffset: CGFloat = 14

    /// `text`'s own rendered width at the `.caption2` size every overlay label in `graphCard(_:)`
    /// draws at — measured rather than estimated from its character count, which a proportional
    /// font makes an unreliable guide to how wide a label actually is.
    private static func measuredWidth(_ text: String) -> CGFloat {
        (text as NSString).size(withAttributes: [.font: UIFont.preferredFont(forTextStyle: .caption2)])
            .width
    }

    /// A `.caption2` line's own rendered height at the system's current text size — `UIFont`
    /// already answers this scaled for whatever Dynamic Type or accessibility size is active, the
    /// same source `measuredWidth(_:)` reads for a label's width.
    private static func measuredHeight() -> CGFloat {
        UIFont.preferredFont(forTextStyle: .caption2).lineHeight
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

    /// A candidate dates-axis label at both its own natural centre (`naturalX`, before the
    /// trailing clamp) and where it actually draws (`x`, after it) — fifth G7 round: the newest
    /// candidate's natural centre can sit close enough to the plot's trailing edge that
    /// `Self.clampedCenterX` pulls it back toward its neighbour, and comparing *clamped* centres
    /// in `Self.degapped` then reads that clamp-induced closeness as a real collision between two
    /// labels that do not in fact touch at their own positions. `Self.degapped` reads `naturalX`;
    /// only the rendered `Text` reads `x`. `day` is either a real day index or a month's own, and
    /// is unique either way, so it doubles as `ForEach`'s `id`.
    private struct XAxisTick: Identifiable {
        var id: Int { day }
        let day: Int
        let text: String
        let naturalX: CGFloat
        let x: CGFloat
        let width: CGFloat
    }

    /// Keeps a candidate only where it would not touch the last one already kept, reading left to
    /// right — finding B, fourth G7 round: `Self.clampedCenterX` alone only keeps a label inside
    /// the card's own edges, not clear of its neighbour, and the values-axis lane (finding 3)
    /// narrowed the plot enough that the three-sixths day sampling's own labels could abut.
    /// Compares `naturalX`, each candidate's own unclamped position, rather than `x` — fifth G7
    /// round: comparing the clamped `x` instead let the trailing clamp manufacture a collision
    /// between the newest candidate and its neighbour that was not there at their own positions,
    /// dropping the newest day's label under exactly the month spans this exists to serve. On a
    /// genuine collision the *older* of the pair is dropped, replacing it in `kept` rather than
    /// skipping the newer one, so a chain of near candidates still settles on the newest — the
    /// newest real day is always the last candidate `candidates` hands this, and never loses a
    /// collision to an older one.
    private static func degapped(_ candidates: [XAxisTick], minimumGap: CGFloat = 8) -> [XAxisTick]
    {
        var kept: [XAxisTick] = []
        for candidate in candidates {
            if let last = kept.last,
                candidate.naturalX - candidate.width / 2
                    < last.naturalX + last.width / 2 + minimumGap
            {
                kept[kept.count - 1] = candidate
                continue
            }
            kept.append(candidate)
        }
        return kept
    }
}

/// The values-axis padding `graphCard(_:)` applies to its `Chart`: a kept point's ring, drawn at
/// `highest`, would sit on the plot's own top edge and draw half clipped, so a total's graph — the
/// only graph that rings a kept point — gets 6pt of `range:` padding around the numeric domain,
/// which the values axis itself still reads and labels. A number's graph keeps the shipped
/// `.chartYScale(domain:)` call, with no `range:` at all — `chartYScale(domain:range:)` and
/// `chartYScale(domain:)` are two separate overloads with no shared spelling for "no range", so
/// this branches on which one is called rather than choosing a value for a shared parameter.
private struct ValuesAxisPadding: ViewModifier {
    let domain: ClosedRange<Double>
    let drawsTargetRule: Bool

    func body(content: Content) -> some View {
        if drawsTargetRule {
            content.chartYScale(domain: domain, range: .plotDimension(padding: 6))
        } else {
            content.chartYScale(domain: domain)
        }
    }
}

/// Whether a note runs past two lines, measured `design.md`'s own way — § *The fold is drawn,
/// not said*: "the text at two lines against the same text unlimited, at the card's width." Two
/// copies of `text`, one folded and one open, laid out by SwiftUI itself at whatever width this
/// view is given (the card's own content width, since `noteCard(_:index:)` attaches this to
/// `noteCardContent(_:isOpen:)`'s own background, before the card's padding is added) — so the
/// fold and the tap read the same layout SwiftUI is about to draw, rather than a UIKit font
/// metric estimating it. G7 fix round, finding 3: `NSString.boundingRect` against `UIFont`,
/// measured at the stack's width less a hard-coded 32, could disagree with what `.lineLimit(2)`
/// actually drew.
///
/// Hidden rather than absent: `.hidden()` still takes part in layout, so each `Text` receives the
/// same width `noteCardContent`'s own does, but is neither drawn nor hit-tested. `isCut` settles
/// once both heights have resolved, which is before any tap can land — nothing here is on the
/// path a visit takes before it can be measured.
private struct FoldMeasurer: View {
    let text: String
    let onMeasured: (Bool) -> Void

    @State private var twoLineHeight: CGFloat?
    @State private var fullHeight: CGFloat?

    var body: some View {
        ZStack(alignment: .topLeading) {
            Text(text)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .background(heightReader { twoLineHeight = $0 })
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
                .background(heightReader { fullHeight = $0 })
        }
        .hidden()
        .onChange(of: twoLineHeight) { _, _ in reportIfReady() }
        .onChange(of: fullHeight) { _, _ in reportIfReady() }
    }

    private func heightReader(_ report: @escaping (CGFloat) -> Void) -> some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear { report(geometry.size.height) }
                .onChange(of: geometry.size) { _, newSize in report(newSize.height) }
        }
    }

    private func reportIfReady() {
        guard let twoLineHeight, let fullHeight else { return }
        // A point of slack against floating-point rounding between the two passes — a note that
        // fits exactly at two lines must read as not cut, since folding it would show nothing an
        // opening tap could add.
        onMeasured(fullHeight > twoLineHeight + 1)
    }
}
