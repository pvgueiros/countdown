import SwiftUI
import WidgetKit

struct CountdownWidgetEntryView: View {
    var entry: SimpleEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.title)
                .font(.headline.weight(.semibold))
                .foregroundColor(titleColor)
                .lineLimit(1)
                .truncationMode(.tail)
                .accessibilityLabel("Event: \(entry.title)")
            
            Spacer()
            
            Text(entry.dateText)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .accessibilityLabel("Date: \(entry.dateText)")
            
            HStack {
                Text(entry.countdownText)
                    .font(.title2.weight(.bold))
                    .foregroundColor(countdownColor)
                    .accessibilityLabel("Countdown: \(entry.countdownText) days")
                
                Spacer()
                
                if !entry.countdownText.contains("-") && entry.countdownText != "Today" {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .accessibilityHidden(true)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(backgroundColor)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Countdown widget for \(entry.title), \(entry.dateText), \(entry.countdownText) days remaining")
    }
    
    private var titleColor: Color {
        if entry.title == "Select a Date" { return .secondary }
        return .primary
    }
    
    private var countdownColor: Color {
        if entry.countdownText.contains("-") { return Color(hex: "#808080") ?? .secondary }
        return .primary
    }
    
    private var backgroundColor: Color {
        if entry.countdownText.contains("-") { return Color(hex: "#808080")?.opacity(0.1) ?? Color.secondary.opacity(0.1) }
        return Color.clear
    }
}

struct CountdownWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountdownWidgetEntryView(entry: SimpleEntry(date: .now, title: "Birthday Party", dateText: "Dec 25, 2025", countdownText: "36"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Future Event")
            CountdownWidgetEntryView(entry: SimpleEntry(date: .now, title: "Conference Talk", dateText: "Nov 15, 2025", countdownText: "- 4"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Past Event")
            CountdownWidgetEntryView(entry: SimpleEntry(date: .now, title: "Very Long Event Title That Should Truncate", dateText: "Jan 1, 2026", countdownText: "43"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Long Title")
        }
    }
}


