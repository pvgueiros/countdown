import Foundation

public struct GetDatesPartitionedUseCase {
    public init() {}

    public func execute(
        items: [DateOfInterest],
        calendar: Calendar = .current
    ) -> (upcoming: [DateOfInterest], past: [DateOfInterest]) {
        let startOfToday = calendar.startOfDay(for: Date())
        func startOfDay(_ date: Date) -> Date { calendar.startOfDay(for: date) }

        var upcoming: [DateOfInterest] = []
        var past: [DateOfInterest] = []

        for item in items {
            let d = startOfDay(item.date)
            if d >= startOfToday {
                upcoming.append(item)
            } else {
                past.append(item)
            }
        }

        upcoming.sort {
            let d0 = startOfDay($0.date)
            let d1 = startOfDay($1.date)
            if d0 != d1 { return d0 < d1 }
            return $0.createdAt < $1.createdAt
        }
        past.sort {
            let d0 = startOfDay($0.date)
            let d1 = startOfDay($1.date)
            if d0 != d1 { return d0 > d1 }
            return $0.createdAt < $1.createdAt
        }
        return (upcoming, past)
    }
}


