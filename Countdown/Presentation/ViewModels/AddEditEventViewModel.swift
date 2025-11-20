import Foundation
import Combine
internal import os

@MainActor
public final class AddEditEventViewModel: ObservableObject {
    public enum Mode {
        case add
        case edit(Event)
    }

    // Inputs
    @Published public var title: String = ""
    @Published public var date: Date = Date()
    @Published public var hasCustomDate: Bool = false
    @Published public var iconSymbolName: String = "star"
    @Published public var eventColorHex: String = "#FF9500"

    // State
    @Published public private(set) var isSubmitting: Bool = false

    private let repository: any EventRepository
    private let addUseCase: AddEventUseCase
    private let updateUseCase: UpdateEventUseCase
    private let mode: Mode
    private let onCompleted: () -> Void

    public init(
        repository: any EventRepository,
        mode: Mode,
        onCompleted: @escaping () -> Void
    ) {
        self.repository = repository
        self.addUseCase = AddEventUseCase(repository: repository)
        self.updateUseCase = UpdateEventUseCase(repository: repository)
        self.mode = mode
        self.onCompleted = onCompleted

        switch mode {
        case .add:
            // Accept today's date by default for add mode
            self.hasCustomDate = true
        case .edit(let event):
            self.title = event.title
            self.date = event.date
            self.hasCustomDate = true
            self.iconSymbolName = event.iconSymbolName
            self.eventColorHex = event.eventColorHex
        }
    }

    public var isEditMode: Bool {
        if case .edit = mode { return true }
        return false
    }

    public var headerTitle: String { isEditMode ? "Edit Event" : "New Event" }
    public var ctaTitle: String { isSubmitting ? (isEditMode ? "Saving..." : "Adding...") : (isEditMode ? "Save Changes" : "Add Event") }

    public var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && hasCustomDate
    }

    public func submit() async {
        guard isValid else { return }
        isSubmitting = true
        defer { isSubmitting = false }
        switch mode {
        case .add:
            do {
                try await addUseCase.execute(
                    title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                    date: date,
                    iconSymbolName: iconSymbolName,
                    eventColorHex: eventColorHex
                )
                onCompleted()
            } catch {
                Log.general.error("Failed to add item: \(String(describing: error), privacy: .public)")
            }
        case .edit(let existing):
            do {
                let updated = Event(
                    id: existing.id,
                    title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                    date: date,
                    iconSymbolName: iconSymbolName,
                    eventColorHex: eventColorHex,
                    createdAt: existing.createdAt
                )
                try await updateUseCase.execute(updated)
                onCompleted()
            } catch {
                Log.general.error("Failed to update item: \(String(describing: error), privacy: .public)")
            }
        }
    }
}


