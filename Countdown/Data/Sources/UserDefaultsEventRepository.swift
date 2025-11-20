import Foundation

public actor UserDefaultsEventRepository: EventRepository {
    private let key = "events"
    private nonisolated let encoder: JSONEncoder = {
        let enc = JSONEncoder()
        enc.dateEncodingStrategy = .iso8601
        return enc
    }()
    private nonisolated let decoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601
        return dec
    }()
    private nonisolated(unsafe) let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
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
    
    

