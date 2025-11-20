import Foundation

public struct UpdateEventUseCase {
    private let repository: EventRepository
    
    public init(repository: EventRepository) {
        self.repository = repository
    }
    
    public func execute(_ event: Event) async throws {
        try await repository.update(event)
    }
}
    
    

