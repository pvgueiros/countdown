import XCTest
@testable import Countdown

@MainActor
final class EventListViewModelIPadTests: XCTestCase {
    
    var sut: EventListViewModel!
    fileprivate var mockRepository: MockEventRepository!
    
    override func setUp() async throws {
        try await super.setUp()
        mockRepository = MockEventRepository()
        sut = EventListViewModel(repository: mockRepository)
    }
    
    override func tearDown() async throws {
        sut = nil
        mockRepository = nil
        try await super.tearDown()
    }
    
    // MARK: - T010: selectEvent with valid ID
    
    func testSelectEvent_WithValidId_SetsSelection() async {
        // Given: ViewModel has loaded events
        let event1 = Event(title: "Event 1", date: Date(), iconSymbolName: "calendar", eventColorHex: "#FF0000")
        let event2 = Event(title: "Event 2", date: Date(), iconSymbolName: "gift", eventColorHex: "#00FF00")
        await mockRepository.setEvents([event1, event2])
        await sut.load()
        
        // When: Selecting an event with valid ID
        sut.selectEvent(id: event1.id)
        
        // Then: selectedEventId is set
        XCTAssertEqual(sut.selectedEventId, event1.id, "selectedEventId should be set to the selected event's ID")
    }
    
    // MARK: - T011: selectEvent with invalid ID
    
    func testSelectEvent_WithInvalidId_ClearsSelection() async {
        // Given: ViewModel has loaded events and has a selection
        let event = Event(title: "Event", date: Date(), iconSymbolName: "calendar", eventColorHex: "#FF0000")
        await mockRepository.setEvents([event])
        await sut.load()
        sut.selectEvent(id: event.id)
        XCTAssertNotNil(sut.selectedEventId, "Precondition: selection should be set")
        
        // When: Selecting an event with invalid ID
        let invalidId = UUID()
        sut.selectEvent(id: invalidId)
        
        // Then: selectedEventId is cleared
        XCTAssertNil(sut.selectedEventId, "selectedEventId should be nil when selecting invalid ID")
    }
    
    func testSelectEvent_WithInvalidId_WhenNoSelection_KeepsNil() async {
        // Given: ViewModel has loaded events but no selection
        let event = Event(title: "Event", date: Date(), iconSymbolName: "calendar", eventColorHex: "#FF0000")
        await mockRepository.setEvents([event])
        await sut.load()
        XCTAssertNil(sut.selectedEventId, "Precondition: no selection")
        
        // When: Selecting with invalid ID
        let invalidId = UUID()
        sut.selectEvent(id: invalidId)
        
        // Then: selectedEventId remains nil
        XCTAssertNil(sut.selectedEventId, "selectedEventId should remain nil")
    }
    
    // MARK: - T012: clearSelection
    
    func testClearSelection_RemovesSelection() async {
        // Given: ViewModel has a selected event
        let event = Event(title: "Event", date: Date(), iconSymbolName: "calendar", eventColorHex: "#FF0000")
        await mockRepository.setEvents([event])
        await sut.load()
        sut.selectEvent(id: event.id)
        XCTAssertNotNil(sut.selectedEventId, "Precondition: selection should be set")
        
        // When: Clearing selection
        sut.clearSelection()
        
        // Then: selectedEventId is nil
        XCTAssertNil(sut.selectedEventId, "selectedEventId should be nil after clearing")
    }
    
    func testClearSelection_WhenNoSelection_KeepsNil() async {
        // Given: ViewModel has no selection
        XCTAssertNil(sut.selectedEventId, "Precondition: no selection")
        
        // When: Clearing selection
        sut.clearSelection()
        
        // Then: selectedEventId remains nil
        XCTAssertNil(sut.selectedEventId, "selectedEventId should remain nil")
    }
    
    // MARK: - T013: selectedEvent query
    
    func testSelectedEvent_ReturnsCorrectEvent() async {
        // Given: ViewModel has loaded events and selected one
        let event1 = Event(title: "Event 1", date: Date(), iconSymbolName: "calendar", eventColorHex: "#FF0000")
        let event2 = Event(title: "Event 2", date: Date(), iconSymbolName: "gift", eventColorHex: "#00FF00")
        await mockRepository.setEvents([event1, event2])
        await sut.load()
        sut.selectEvent(id: event2.id)
        
        // When: Querying selected event
        let selectedEvent = sut.selectedEvent()
        
        // Then: Returns the correct event
        XCTAssertNotNil(selectedEvent, "selectedEvent should return an event")
        XCTAssertEqual(selectedEvent?.id, event2.id, "selectedEvent should return event2")
        XCTAssertEqual(selectedEvent?.title, "Event 2", "selectedEvent should have correct title")
    }
    
    func testSelectedEvent_WhenNoSelection_ReturnsNil() async {
        // Given: ViewModel has loaded events but no selection
        let event = Event(title: "Event", date: Date(), iconSymbolName: "calendar", eventColorHex: "#FF0000")
        await mockRepository.setEvents([event])
        await sut.load()
        XCTAssertNil(sut.selectedEventId, "Precondition: no selection")
        
        // When: Querying selected event
        let selectedEvent = sut.selectedEvent()
        
        // Then: Returns nil
        XCTAssertNil(selectedEvent, "selectedEvent should return nil when no selection")
    }
    
    func testSelectedEvent_AfterEventDeleted_ReturnsNil() async {
        // Given: ViewModel has loaded events and selected one
        let event = Event(title: "Event", date: Date(), iconSymbolName: "calendar", eventColorHex: "#FF0000")
        await mockRepository.setEvents([event])
        await sut.load()
        sut.selectEvent(id: event.id)
        XCTAssertNotNil(sut.selectedEvent(), "Precondition: event should be selected")
        
        // When: Event is deleted and list reloaded
        await mockRepository.setEvents([])
        await sut.load()
        
        // Then: selectedEvent returns nil (event no longer exists)
        let selectedEvent = sut.selectedEvent()
        XCTAssertNil(selectedEvent, "selectedEvent should return nil after event deleted")
    }
    
    // MARK: - Additional test: Selection persists across load
    
    func testLoadEvents_PreservesSelection_IfEventStillExists() async {
        // Given: ViewModel has loaded events and selected one
        let event1 = Event(title: "Event 1", date: Date(), iconSymbolName: "calendar", eventColorHex: "#FF0000")
        let event2 = Event(title: "Event 2", date: Date(), iconSymbolName: "gift", eventColorHex: "#00FF00")
        await mockRepository.setEvents([event1, event2])
        await sut.load()
        sut.selectEvent(id: event1.id)
        
        // When: Events are reloaded (same events)
        await sut.load()
        
        // Then: Selection is preserved
        XCTAssertEqual(sut.selectedEventId, event1.id, "selectedEventId should persist across load")
        XCTAssertNotNil(sut.selectedEvent(), "selectedEvent should still return the event")
    }
}

// MARK: - Mock Repository

private actor MockEventRepository: EventRepository {
    var events: [Event] = []
    
    func fetchAll() async throws -> [Event] {
        return events
    }
    
    func add(_ event: Event) async throws {
        events.append(event)
    }
    
    func update(_ event: Event) async throws {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
        }
    }
    
    func delete(_ id: UUID) async throws {
        events.removeAll { $0.id == id }
    }
    
    // Helper used by tests to set the list atomically
    func setEvents(_ newEvents: [Event]) async {
        events = newEvents
    }
}
