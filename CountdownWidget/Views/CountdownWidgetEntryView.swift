import SwiftUI
import WidgetKit

struct CountdownWidgetEntryView: View {
    var entry: SimpleEntry
    
    var body: some View {
        eventView
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Countdown widget for \(entry.title), \(entry.dateText), \(countdownText) \(countdownSubtext)")
    }
    
    // MARK: - Past Event Layout
    
    private var eventView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                // Icon in rounded rectangle
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconContainerColor)
                        .frame(width: 36, height: 36)
                    Image(systemName: entry.iconSymbolName)
                        .font(.system(size: 16))
                        .foregroundColor(iconColor)
                }
                Spacer()
            }
            .padding(.bottom, 8)
            
            // Event title
            Text(entry.title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(eventTitleColor)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .truncationMode(.tail)
                .accessibilityLabel("Event: \(entry.title)")
            
            Spacer()
            
            // Date and countdown row
            HStack(alignment: .bottom) {
                // Month and day
                VStack(alignment: .leading) {
                    Spacer()
                    Text(monthAbbreviation)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(monthTextColor)
                        .textCase(.uppercase)
                    Text(dayOfMonth)
                        .font(.system(size: 21, weight: .medium))
                        .foregroundColor(dayOfMonthTextColor)
                }
                
                Spacer()
                
                // Countdown number and "ago" label
                VStack(alignment: .trailing) {
                    Text(countdownText)
                        .font(.system(size: countdownTextSize, weight: .medium))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Text(countdownSubtext)
                        .font(.system(size: 10))
                }
                .foregroundColor(countdownTextColor)
            }
        }
    }
    
    // MARK: - Computed State Properties
    
    private var isPastEvent: Bool {
        entry.countdownText.contains("-")
    }
    
    private var isToday: Bool {
        entry.countdownText == "Today"
    }
    
    private var isFutureEvent: Bool {
        !isPastEvent && !isToday
    }
    
    // MARK: - Computed UI Properties
    
    private var iconContainerColor: Color {
        isPastEvent ? Color.secondary.opacity(0.2) : Color.white.opacity(0.2)
    }
    
    private var iconColor: Color {
        isPastEvent ? Color.secondary : Color.white
    }
    
    private var eventTitleColor: Color? {
        isPastEvent ? Color(hex: "#4B5563") : Color.white
    }
    
    private var monthAbbreviation: String {
        let components = entry.dateText.components(separatedBy: " ")
        return components.first?.uppercased() ?? ""
    }
    
    private var monthTextColor: Color? {
        isPastEvent ? Color(hex: "#9CA3AF") : Color.white.opacity(0.6)
    }
    
    private var dayOfMonth: String {
        let components = entry.dateText.components(separatedBy: " ")
        guard components.count >= 2 else { return "" }
        return components[1].replacingOccurrences(of: ",", with: "")
    }
    
    private var dayOfMonthTextColor: Color? {
        isPastEvent ? Color(hex: "#6B7280") : Color.white
    }

    private var countdownText: String {
        if isToday {
            return "TODAY"
        } else {
            return entry.countdownText.replacingOccurrences(of: "-", with: "").trimmingCharacters(in: .whitespaces)
        }
    }
    
    private var countdownTextSize: CGFloat {
        isToday ? 26 : 30
    }
    
    private var countdownSubtext: String {
        if isToday {
            return "✨"
        } else if isFutureEvent {
            return "days left"
        } else {
            return "days ago"
        }
    }
    
    private var countdownTextColor: Color? {
        isPastEvent ? Color(hex: "#9CA3AF") : Color.white
    }
}

struct CountdownWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountdownWidgetEntryView(entry: SimpleEntry(date: .now, title: "Birthday Party", dateText: "Dec 25, 2025", countdownText: "36", iconSymbolName: "birthday.cake", eventColorHex: "#EC4899"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .containerBackground(Color(hex: "#EC4899") ?? .blue, for: .widget)
                .previewDisplayName("Future Event")
            CountdownWidgetEntryView(entry: SimpleEntry(date: .now, title: "Summer Vacation", dateText: "Jul 14, 2025", countdownText: "- 129", iconSymbolName: "airplane", eventColorHex: "#3B82F6"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .containerBackground(Color(hex: "#F3F4F6") ?? .secondary, for: .widget)
                .previewDisplayName("Past Event")
            CountdownWidgetEntryView(entry: SimpleEntry(date: .now, title: "Important Meeting", dateText: "Nov 20, 2025", countdownText: "Today", iconSymbolName: "briefcase", eventColorHex: "#A855F7"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .containerBackground(Color(hex: "#A855F7") ?? .purple, for: .widget)
                .previewDisplayName("Today Event")
        }
    }
}


