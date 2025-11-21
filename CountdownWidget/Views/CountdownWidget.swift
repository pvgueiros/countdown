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
        SimpleEntry(date: Date(),
                    title: nil,
                    eventDate: nil,
                    countdownDays: nil,
                    iconSymbolName: "calendar",
                    eventColorHex: "#3B82F6")
    }

    func snapshot(for configuration: SelectEventIntent, in context: Context) async -> SimpleEntry {
        await entry(for: configuration, at: Date())
    }
    
    func timeline(for configuration: SelectEventIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let now = Date()
        let cal = Calendar.current
        let startOfToday = cal.startOfDay(for: now)
        let nextMidnight = cal.date(byAdding: .day, value: 1, to: startOfToday) ?? now.addingTimeInterval(60 * 60 * 24)
        
        // Generate entries for now and midnight to ensure accurate countdown updates
        let currentEntry = await entry(for: configuration, at: now)
        let midnightEntry = await entry(for: configuration, at: nextMidnight)
        
        // Request reload after midnight for the next day's countdown
        return Timeline(entries: [currentEntry, midnightEntry], policy: .after(nextMidnight))
    }

    private func entry(for configuration: SelectEventIntent, at date: Date) async -> SimpleEntry {
        guard let selected = configuration.selected else {
            return SimpleEntry(
                date: date,
                title: nil,
                eventDate: nil,
                countdownDays: nil,
                iconSymbolName: "calendar",
                eventColorHex: "#3B82F6"
            )
        }
        // Calculate countdown days
        let cal = Calendar.current
        let startOfReferenceDay = cal.startOfDay(for: date)
        let startTarget = cal.startOfDay(for: selected.date)
        let countdownDays = cal.dateComponents([.day], from: startOfReferenceDay, to: startTarget).day ?? 0

        // Persist snapshots keyed by selected date id (supports multiple widgets via AppIntent config)
        let widgetId = selected.id.uuidString
        let suite = UserDefaults(suiteName: "group.com.bluecode.CountdownApp") ?? .standard
        suite.set(selected.id.uuidString, forKey: "widget.selection.\(widgetId).eventId")
        suite.set(selected.title, forKey: "widget.selection.\(widgetId).title")
        let dateText = DateFormatter.localizedString(from: selected.date, dateStyle: .medium, timeStyle: .none)
        suite.set(dateText, forKey: "widget.selection.\(widgetId).dateString")

        return SimpleEntry(
            date: date,
            title: selected.title,
            eventDate: selected.date,
            countdownDays: countdownDays,
            iconSymbolName: selected.iconSymbolName,
            eventColorHex: selected.eventColorHex
        )
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String?
    let eventDate: Date?
    let countdownDays: Int?
    let iconSymbolName: String
    let eventColorHex: String
}

// Entry view is defined in Views/CountdownWidgetEntryView.swift

struct CountdownWidget: Widget {
    let kind: String = "CountdownWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SelectEventIntent.self, provider: Provider()) { entry in
            CountdownWidgetEntryView(entry: entry)
                .containerBackground(containerBackground(for: entry), for: .widget)
        }
        .configurationDisplayName("Countdown")
        .description("Shows a countdown for a selected event.")
        .supportedFamilies([.systemSmall])
    }
    
    private func containerBackground(for entry: SimpleEntry) -> Color {
        guard let countdownDays = entry.countdownDays else {
            return Color(hex: entry.eventColorHex) ?? .black
        }
        let isPastEvent = countdownDays < 0
        if isPastEvent {
            return Color(hex: "#F3F4F6") ?? .red
        } else {
            return Color(hex: entry.eventColorHex) ?? .black
        }
    }
}

#Preview(as: .systemSmall) {
    CountdownWidget()
} timeline: {
    let calendar = Calendar.current
    let pastDate = calendar.date(byAdding: .day, value: -129, to: Date()) ?? Date()
    let futureDate = calendar.date(byAdding: .day, value: 34, to: Date()) ?? Date()
    
    SimpleEntry(date: .now, title: "Summer Vacation", eventDate: pastDate, countdownDays: -129, iconSymbolName: "airplane", eventColorHex: "#3B82F6")
    SimpleEntry(date: .now, title: "Important Meeting", eventDate: Date(), countdownDays: 0, iconSymbolName: "briefcase", eventColorHex: "#A855F7")
    SimpleEntry(date: .now, title: "Birthday Party", eventDate: futureDate, countdownDays: 34, iconSymbolName: "birthday.cake", eventColorHex: "#EC4899")
    SimpleEntry(date: .now, title: nil, eventDate: nil, countdownDays: nil, iconSymbolName: "calendar", eventColorHex: "3B82F6")
}
