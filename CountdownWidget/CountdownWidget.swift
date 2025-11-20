//
//  CountdownWidget.swift
//  CountdownWidget
//
//  Created by Paula Vasconcelos Gueiros on 19/11/25.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            title: "Select a Date",
            dateText: "Jul 24, 2025",
            countdownNumber: 10,
            mode: .future,
            eventColorHex: "#0A84FF"
        )
    }

    func snapshot(for configuration: SelectEventIntent, in context: Context) async -> SimpleEntry {
        await entry(for: configuration)
    }
    
    func timeline(for configuration: SelectEventIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let entry = await entry(for: configuration)
        // Update daily at midnight for days-only countdown (avoid cross-target dependency)
        let cal = Calendar.current
        let startOfToday = cal.startOfDay(for: Date())
        let nextMidnight = cal.date(byAdding: .day, value: 1, to: startOfToday) ?? Date().addingTimeInterval(60 * 60 * 24)
        return Timeline(entries: [entry], policy: .after(nextMidnight))
    }
    
    private func entry(for configuration: SelectEventIntent) async -> SimpleEntry {
        guard let selected = configuration.selected else {
            return SimpleEntry(
                date: Date(),
                title: "Select a Date",
                dateText: "",
                countdownNumber: 0,
                mode: .future,
                eventColorHex: "#808080"
            )
        }

        let now = Date()
        let cal = Calendar.current
        let startOfToday = cal.startOfDay(for: now)
        let startTarget = cal.startOfDay(for: selected.date)
        let delta = cal.dateComponents([.day], from: startOfToday, to: startTarget).day ?? 0

        let mode: SimpleEntry.Mode
        let number: Int

        if startTarget == startOfToday {
            mode = .today
            number = 0
        } else if delta > 0 {
            mode = .future
            number = delta
        } else {
            mode = .past
            number = abs(delta)
        }

        let dateText = DateFormatter.localizedString(from: selected.date, dateStyle: .medium, timeStyle: .none)

        // Persist snapshots keyed by selected date id (supports multiple widgets via AppIntent config)
        let widgetId = selected.id.uuidString
        let suite = UserDefaults(suiteName: "group.com.bluecode.CountdownApp") ?? .standard
        suite.set(selected.id.uuidString, forKey: "widget.selection.\(widgetId).eventId")
        suite.set(selected.title, forKey: "widget.selection.\(widgetId).title")
        suite.set(dateText, forKey: "widget.selection.\(widgetId).dateString")

        // Use the event color from the app; if missing or invalid, fall back to a neutral blue
        let rawColorHex = selected.eventColorHex
        let colorHex = rawColorHex.isEmpty ? "#0A84FF" : rawColorHex

        return SimpleEntry(
            date: now,
            title: selected.title,
            dateText: dateText,
            countdownNumber: number,
            mode: mode,
            eventColorHex: colorHex
        )
    }
}

struct SimpleEntry: TimelineEntry {
    enum Mode {
        case past
        case future
        case today
    }

    let date: Date
    let title: String
    let dateText: String

    /// Absolute number of days between today and the event.
    /// - For `today`, this will be 0.
    let countdownNumber: Int

    /// Visual mode: past / future / today.
    let mode: Mode

    /// Hex string for the event color chosen in the app.
    let eventColorHex: String
}

// Entry view is defined in Views/CountdownWidgetEntryView.swift

struct CountdownWidget: Widget {
    let kind: String = "CountdownWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SelectEventIntent.self, provider: Provider()) { entry in
            CountdownWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Countdown")
        .description("Shows a countdown for a selected date.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    CountdownWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        title: "Vacation",
        dateText: "Nov 19, 2025",
        countdownNumber: 10,
        mode: .future,
        eventColorHex: "#0A84FF"
    )
    SimpleEntry(
        date: .now,
        title: "Today",
        dateText: "Nov 19, 2025",
        countdownNumber: 0,
        mode: .today,
        eventColorHex: "#FF4D9F"
    )
    SimpleEntry(
        date: .now,
        title: "Conference (Past)",
        dateText: "Nov 10, 2025",
        countdownNumber: 9,
        mode: .past,
        eventColorHex: "#808080"
    )
}
