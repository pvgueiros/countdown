import SwiftUI
import WidgetKit

struct CountdownWidgetEntryView: View {
    var entry: SimpleEntry
    
    var body: some View {
        eventView
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Countdown widget for \(entry.title ?? "No event selected"), \(formattedDate), \(countdownText) \(countdownSubtext)")
    }
    
    // MARK: - Past Event Layout
    
    private var eventView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                // Icon in rounded rectangle
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
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
            Text(entry.title ?? "No event selected")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(eventTitleColor)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .truncationMode(.tail)
                .accessibilityLabel("Event: \(entry.title ?? "No event selected")")
            
            Spacer()
            
            // Date and countdown row
            HStack(alignment: .bottom) {
                // Month and day
                if !isNoDateSelected {
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
                }
                
                Spacer()
                
                // Countdown number and label
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
    
    private var isNoDateSelected: Bool {
        entry.title == nil || entry.eventDate == nil
    }
    
    private var isPastEvent: Bool {
        guard let countdownDays = entry.countdownDays else { return false }
        return countdownDays < 0
    }
    
    private var isToday: Bool {
        guard let countdownDays = entry.countdownDays else { return false }
        return countdownDays == 0
    }
    
    private var isFutureEvent: Bool {
        guard let countdownDays = entry.countdownDays else { return false }
        return countdownDays > 0
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
    
    private var formattedDate: String {
        guard let eventDate = entry.eventDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: eventDate)
    }
    
    private var monthAbbreviation: String {
        guard let eventDate = entry.eventDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: eventDate).uppercased()
    }
    
    private var monthTextColor: Color? {
        isPastEvent ? Color(hex: "#9CA3AF") : Color.white.opacity(0.6)
    }
    
    private var dayOfMonth: String {
        guard let eventDate = entry.eventDate else { return "" }
        let calendar = Calendar.current
        let day = calendar.component(.day, from: eventDate)
        return "\(day)"
    }
    
    private var dayOfMonthTextColor: Color? {
        isPastEvent ? Color(hex: "#6B7280") : Color.white
    }

    private var countdownText: String {
        if isToday {
            return "TODAY"
        } else if let countdownDays = entry.countdownDays {
            return "\(abs(countdownDays))"
        } else {
            return "--"
        }
    }
    
    private var countdownTextSize: CGFloat {
        isToday ? 26 : 30
    }
    
    private var countdownSubtext: String {
        if isToday {
            return "✨"
        } else if isPastEvent {
            return "days ago"
        } else {
            return "days left"
        }
    }
    
    private var countdownTextColor: Color? {
        isPastEvent ? Color(hex: "#9CA3AF") : Color.white
    }
}

struct CountdownWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        let pastDate = calendar.date(byAdding: .day, value: -129, to: Date()) ?? Date()
        let futureDate = calendar.date(byAdding: .day, value: 34, to: Date()) ?? Date()
        
        Group {
            CountdownWidgetEntryView(entry: SimpleEntry(date: .now, title: "Birthday Party", eventDate: futureDate, countdownDays: 34, iconSymbolName: "birthday.cake", eventColorHex: "#EC4899"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .containerBackground(Color(hex: "#EC4899") ?? .blue, for: .widget)
                .previewDisplayName("Future Event")
            CountdownWidgetEntryView(entry: SimpleEntry(date: .now, title: "Summer Vacation", eventDate: pastDate, countdownDays: -129, iconSymbolName: "airplane", eventColorHex: "#3B82F6"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .containerBackground(Color(hex: "#F3F4F6") ?? .secondary, for: .widget)
                .previewDisplayName("Past Event")
            CountdownWidgetEntryView(entry: SimpleEntry(date: .now, title: "Important Meeting", eventDate: Date(), countdownDays: 0, iconSymbolName: "briefcase", eventColorHex: "#A855F7"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .containerBackground(Color(hex: "#A855F7") ?? .purple, for: .widget)
                .previewDisplayName("Today Event")
            CountdownWidgetEntryView(entry: SimpleEntry(date: .now, title: nil, eventDate: nil, countdownDays: nil, iconSymbolName: "calendar", eventColorHex: "#3B82F6"))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .containerBackground(Color(hex: "#3B82F6") ?? .blue, for: .widget)
                .previewDisplayName("No Event Selected")
        }
    }
}


