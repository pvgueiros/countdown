import Foundation

public protocol EventRepository {
    func fetchAll() async throws -> [Event]
    func add(_ event: Event) async throws
    func update(_ event: Event) async throws
    func delete(_ id: UUID) async throws
}



