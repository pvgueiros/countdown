import Foundation

public enum CountdownFormatter {
    public static func string(for targetDate: Date, calendar: Calendar = .current) -> String {
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfTarget = calendar.startOfDay(for: targetDate)
        if startOfTarget == startOfToday {
            return "Today"
        }
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfTarget)
        let days = components.day ?? 0
        if days > 0 {
            return "\(days) days left"
        } else {
            return "\(-days) days ago"
        }
    }
}


