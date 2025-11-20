import SwiftUI
import WidgetKit

struct CountdownWidgetEntryView: View {
    var entry: SimpleEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: entry.iconSymbolName)
                .font(.title3.weight(.semibold))
                .foregroundColor(iconColor)
                .accessibilityHidden(true)
            
            Text(entry.title)
                .font(.headline.weight(.semibold))
                .foregroundColor(titleColor)
                .lineLimit(1)
                .truncationMode(.tail)
                .accessibilityLabel("Event: \(entry.title)")
            
            Spacer()
            
            HStack(alignment: .lastTextBaseline) {
                Text(entry.dateText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Date: \(entry.dateText)")
                
                Spacer(minLength: 4)
                
                countdownView
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilitySummary)
    }
    
    private var iconColor: Color {
        switch entry.classification {
        case .past: return grayColor
        case .today, .future: return eventColor
        }
    }
    
    private var titleColor: Color {
        .primary
    }
    
    private var grayColor: Color {
        Color(hex: "#808080") ?? .secondary
    }
    
    private var eventColor: Color {
        Color(hex: entry.eventColorHex) ?? .primary
    }
    
    @ViewBuilder
    private var countdownView: some View {
        switch entry.classification {
        case .past:
            VStack(alignment: .trailing, spacing: 0) {
                Text("\(entry.dayCount)")
                    .font(.title2.weight(.bold))
                    .foregroundColor(grayColor)
                Text(entry.labelText)
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(grayColor)
            }
            .accessibilityLabel(pastAccessibilityLabel)
        case .future:
            VStack(alignment: .trailing, spacing: 0) {
                Text("\(entry.dayCount)")
                    .font(.title2.weight(.bold))
                    .foregroundColor(eventColor)
                Text(entry.labelText)
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(eventColor)
            }
            .accessibilityLabel(futureAccessibilityLabel)
        case .today:
            VStack(alignment: .trailing, spacing: 0) {
                Text(entry.labelText)
                    .font(.title2.weight(.bold))
                    .foregroundColor(eventColor)
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(eventColor)
                    .accessibilityHidden(true)
            }
            .accessibilityLabel(todayAccessibilityLabel)
        }
    }
    
    private var pastAccessibilityLabel: String {
        // e.g., "3 days ago"
        let daysWord = NSLocalizedString("widget.countdown.days", comment: "")
        let agoWord = NSLocalizedString("widget.countdown.ago", comment: "")
        return "\(entry.dayCount) \(daysWord) \(agoWord)"
    }
    
    private var futureAccessibilityLabel: String {
        // e.g., "3 days"
        let daysWord = NSLocalizedString("widget.countdown.days", comment: "")
        return "\(entry.dayCount) \(daysWord)"
    }
    
    private var todayAccessibilityLabel: String {
        NSLocalizedString("widget.countdown.today", comment: "")
    }
    
    private var accessibilitySummary: String {
        switch entry.classification {
        case .past:
            return "Event: \(entry.title). Date: \(entry.dateText). \(pastAccessibilityLabel)."
        case .future:
            return "Event: \(entry.title). Date: \(entry.dateText). \(futureAccessibilityLabel)."
        case .today:
            return "Event: \(entry.title). Date: \(entry.dateText). \(todayAccessibilityLabel)."
        }
    }
}

struct CountdownWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Future
            CountdownWidgetEntryView(entry: SimpleEntry(
                date: .now,
                title: "Birthday Party",
                dateText: "Dec 25, 2025",
                countdownText: "36",
                iconSymbolName: "gift.fill",
                eventColorHex: "#0EA5E9",
                classification: .future,
                labelText: "days",
                dayCount: 36
            ))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .containerBackground(.fill.secondary, for: .widget)
                .previewDisplayName("Future Event")
            // Past
            CountdownWidgetEntryView(entry: SimpleEntry(
                date: .now,
                title: "Conference Talk",
                dateText: "Nov 15, 2025",
                countdownText: "- 4",
                iconSymbolName: "mic.fill",
                eventColorHex: "#22C55E",
                classification: .past,
                labelText: "ago",
                dayCount: 4
            ))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .containerBackground(.fill.secondary, for: .widget)
                .previewDisplayName("Past Event")
            // Today
            CountdownWidgetEntryView(entry: SimpleEntry(
                date: .now,
                title: "Very Long Event Title That Should Truncate",
                dateText: "Jan 1, 2026",
                countdownText: "Today",
                iconSymbolName: "sparkles",
                eventColorHex: "#F97316",
                classification: .today,
                labelText: "Today",
                dayCount: 0
            ))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .containerBackground(.fill.secondary, for: .widget)
                .previewDisplayName("Long Title")
        }
    }
}


