import Foundation
import AppIntents

struct EventAppEntity: AppEntity, Identifiable {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Event"

    static var defaultQuery = EventQuery()

    let id: UUID
    let title: String
    let date: Date

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
}

struct EventQuery: EntityQuery {
    struct DTO: Codable, Identifiable {
        let id: UUID
        let title: String
        let date: Date
    }

    func entities(for identifiers: [UUID]) async throws -> [EventAppEntity] {
        let all = try await suggestedEntities()
        let set = Set(identifiers)
        return all.filter { set.contains($0.id) }
    }

    func suggestedEntities() async throws -> [EventAppEntity] {
        // Read from shared App Group storage
        let suite = UserDefaults(suiteName: "group.com.bluecode.CountdownApp") ?? .standard
        guard let data = suite.data(forKey: "events") else { return [] }
        // Decode only fields we need
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let dtos = try? decoder.decode([DTO].self, from: data) else { return [] }
        return dtos.map { dto in
            EventAppEntity(id: dto.id, title: dto.title, date: dto.date)
        }
    }
}



