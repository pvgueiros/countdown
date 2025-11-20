import Foundation

public struct WidgetDisplayFormatter {
    public struct Display {
        public let title: String
        public let dateText: String
        public let countdownText: String
    }

    public init() {}

    public static func nextMidnight(after now: Date, calendar: Calendar = .current) -> Date {
        let startOfToday = calendar.startOfDay(for: now)
        return calendar.date(byAdding: .day, value: 1, to: startOfToday) ?? now.addingTimeInterval(60 * 60 * 24)
    }

    public func makeDisplay(for item: DateOfInterest, now: Date = Date(), calendar: Calendar = .current) -> Display {
        let startOfToday = calendar.startOfDay(for: now)
        let startTarget = calendar.startOfDay(for: item.date)
        let delta = calendar.dateComponents([.day], from: startOfToday, to: startTarget).day ?? 0

        let isToday = startTarget == startOfToday
        let isFuture = delta > 0
        let daysNumber = isToday ? 0 : abs(delta)

        let countdownText: String
        if isToday {
            countdownText = "Today"
        } else if isFuture {
            countdownText = "\(daysNumber)"
        } else {
            countdownText = "- \(daysNumber)"
        }

        let df = DateFormatterProvider.mediumLocaleFormatter()
        let dateText = df.string(from: item.date)

        return Display(
            title: item.title,
            dateText: dateText,
            countdownText: countdownText
        )
    }
}


