import SwiftUI
import WidgetKit

struct CountdownWidgetEntryView: View {
    var entry: SimpleEntry
    
    var body: some View {
        ZStack {
            backgroundColor

            HStack(alignment: .top, spacing: 10) {
                iconView

                VStack(alignment: .leading, spacing: 6) {
                    titleView

                    calendarView
                }

                Spacer(minLength: 4)

                countdownView
            }
            .padding(12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
    }

    // MARK: - Subviews

    private var iconView: some View {
        let containerSize: CGFloat = 28
        let padding: CGFloat = 10

        return ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(iconContainerBackground)

            Image(systemName: "calendar")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(iconColor)
        }
        .frame(width: containerSize + padding * 2,
               height: containerSize + padding * 2)
    }

    private var titleView: some View {
        Text(entry.title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(titleColor)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineSpacing(0)
    }

    /// Small calendar-style month and day, using your specified sizes.
    private var calendarView: some View {
        let date = parsedEventDate ?? Date()
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.month, .day], from: date)

        let month = monthFormatter.string(from: date).uppercased()
        let day = comps.day ?? 1

        return VStack(alignment: .leading, spacing: 0) {
            Text(month)
                .font(.system(size: 9, weight: .semibold))
                .tracking(0.8)
                .foregroundStyle(monthColor)
                .lineLimit(1)

            Text("\(day)")
                .font(.system(size: 20, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(calendarDayColor)
                .lineLimit(1)
        }
        .frame(alignment: .leading)
    }

    private var countdownView: some View {
        switch entry.mode {
        case .today:
            return AnyView(todayCountdownView)
        case .future:
            return AnyView(futureCountdownView)
        case .past:
            return AnyView(pastCountdownView)
        }
    }

    private var futureCountdownView: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text("\(entry.countdownNumber)")
                .font(.system(size: 30, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(countdownNumberColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .lineSpacing(0)

            Text("days")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(countdownLabelColor)
                .lineLimit(1)
        }
        .frame(alignment: .trailing)
    }

    private var pastCountdownView: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text("\(entry.countdownNumber)")
                .font(.system(size: 30, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(countdownNumberColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .lineSpacing(0)

            Text("ago")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(countdownLabelColor)
                .lineLimit(1)
        }
        .frame(alignment: .trailing)
    }

    private var todayCountdownView: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text("TODAY")
                .font(.system(size: 24, weight: .bold))
                .tracking(0.5)
                .foregroundStyle(countdownNumberColor)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .lineSpacing(0)

            Text("✨")
                .font(.system(size: 10))
                .foregroundStyle(countdownLabelColor)
        }
        .frame(alignment: .trailing)
    }

    // MARK: - Colors

    private var isPast: Bool { entry.mode == .past }
    private var isToday: Bool { entry.mode == .today }

    private var eventColor: Color {
        Color(hex: entry.eventColorHex) ?? Color.blue
    }

    private var backgroundColor: Color {
        if isPast {
            // Equivalent to Tailwind bg-gray-100
            return Color(.systemGray6)
        } else {
            // Solid event color
            return eventColor
        }
    }

    private var iconContainerBackground: Color {
        if isPast {
            // Tailwind bg-gray-300
            return Color(.systemGray3)
        } else {
            // White with 20% opacity over solid color
            return Color.white.opacity(0.2)
        }
    }

    private var iconColor: Color {
        if isPast {
            return Color(.systemGray5)
        } else {
            return .white
        }
    }

    private var titleColor: Color {
        if isPast {
            return Color(.systemGray)
        } else {
            return .white
        }
    }

    private var monthColor: Color {
        if isPast {
            return Color(.systemGray3)
        } else {
            return Color.white.opacity(0.7)
        }
    }

    private var calendarDayColor: Color {
        if isPast {
            return Color(.systemGray2)
        } else {
            return .white
        }
    }

    private var countdownNumberColor: Color {
        if isPast {
            return Color(.systemGray3)
        } else {
            return .white
        }
    }

    private var countdownLabelColor: Color {
        if isPast {
            return Color(.systemGray3)
        } else {
            return Color.white.opacity(0.7)
        }
    }

    // MARK: - Date parsing helpers

    /// Best-effort re-parse of the medium style dateText just to get the month/day.
    /// If this fails, we fall back to `entry.date`.
    private var parsedEventDate: Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.date(from: entry.dateText) ?? entry.date
    }

    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter
    }

    // MARK: - Accessibility

    private var accessibilityDescription: String {
        switch entry.mode {
        case .today:
            return "Countdown widget for \(entry.title), today."
        case .future:
            return "Countdown widget for \(entry.title), on \(entry.dateText), \(entry.countdownNumber) days remaining."
        case .past:
            return "Countdown widget for \(entry.title), on \(entry.dateText), \(entry.countdownNumber) days ago."
        }
    }
}

struct CountdownWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountdownWidgetEntryView(
                entry: SimpleEntry(
                    date: .now,
                    title: "Conference Talk",
                    dateText: "Dec 25, 2025",
                    countdownNumber: 36,
                    mode: .future,
                    eventColorHex: "#0A84FF"
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Future Event")

            CountdownWidgetEntryView(
                entry: SimpleEntry(
                    date: .now,
                    title: "Trip to the Mountains",
                    dateText: "Nov 15, 2024",
                    countdownNumber: 4,
                    mode: .past,
                    eventColorHex: "#808080"
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Past Event")

            CountdownWidgetEntryView(
                entry: SimpleEntry(
                    date: .now,
                    title: "Anniversary Dinner",
                    dateText: "Nov 19, 2025",
                    countdownNumber: 0,
                    mode: .today,
                    eventColorHex: "#FF4D9F"
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Today Event")
        }
    }
}
