import Foundation

public actor UserDefaultsEventRepository: EventRepository {
    private let key = "events"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.encoder.dateEncodingStrategy = .iso8601
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    public func fetchAll() async throws -> [Event] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        let dtos = try decoder.decode([EventMapper.DTO].self, from: data)
        return dtos.map { EventMapper.fromDTO($0) }
    }
    
    private func saveAll(_ items: [Event]) throws {
        let dtos = items.map { EventMapper.toDTO($0) }
        let data = try encoder.encode(dtos)
        userDefaults.set(data, forKey: key)
    }
    
    public func add(_ event: Event) async throws {
        var items = try await fetchAll()
        items.append(event)
        try saveAll(items)
    }
    
    public func update(_ event: Event) async throws {
        var items = try await fetchAll()
        if let idx = items.firstIndex(where: { $0.id == event.id }) {
            items[idx] = event
            try saveAll(items)
        }
    }
    
    public func delete(_ id: UUID) async throws {
        var items = try await fetchAll()
        items.removeAll { $0.id == id }
        try saveAll(items)
    }
}
    
    

