import Foundation

public struct GetEventsPartitionedUseCase {
    public init() {}
    
    public func execute(
        items: [Event],
        calendar: Calendar = .current
    ) -> (upcoming: [Event], past: [Event]) {
        let startOfToday = calendar.startOfDay(for: Date())
        func startOfDay(_ date: Date) -> Date { calendar.startOfDay(for: date) }
        
        var upcoming: [Event] = []
        var past: [Event] = []
        
        for event in items {
            let d = startOfDay(event.date)
            if d >= startOfToday {
                upcoming.append(event)
            } else {
                past.append(event)
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
    
    

