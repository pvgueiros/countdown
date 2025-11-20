import Foundation

public struct AddEventUseCase {
    private let repository: EventRepository
    
    public init(repository: EventRepository) {
        self.repository = repository
    }
    
    public func execute(
        title: String,
        date: Date,
        iconSymbolName: String,
        eventColorHex: String,
        createdAt: Date = Date()
    ) async throws {
        let event = Event(
            title: title,
            date: date,
            iconSymbolName: iconSymbolName,
            eventColorHex: eventColorHex,
            createdAt: createdAt
        )
        try await repository.add(event)
    }
}
    
    

