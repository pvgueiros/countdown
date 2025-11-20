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
                    title: "Countdown",
                    dateText: DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none),
                    countdownText: "0",
                    iconSymbolName: "calendar",
                    eventColorHex: "#3B82F6")
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
                title: "No date selected",
                dateText: "",
                countdownText: "—",
                iconSymbolName: "calendar",
                eventColorHex: "#3B82F6"
            )
        }
        // Calculate display strings matching app semantics
        let now = Date()
        let cal = Calendar.current
        let startOfToday = cal.startOfDay(for: now)
        let startTarget = cal.startOfDay(for: selected.date)
        let delta = cal.dateComponents([.day], from: startOfToday, to: startTarget).day ?? 0
        let isToday = startTarget == startOfToday
        let isFuture = delta > 0
        let daysNumber = isToday ? 0 : abs(delta)
        let countdownText = isToday ? "Today" : (isFuture ? "\(daysNumber)" : "- \(daysNumber)")
        let dateText = DateFormatter.localizedString(from: selected.date, dateStyle: .medium, timeStyle: .none)

        // Persist snapshots keyed by selected date id (supports multiple widgets via AppIntent config)
        let widgetId = selected.id.uuidString
        let suite = UserDefaults(suiteName: "group.com.bluecode.CountdownApp") ?? .standard
        suite.set(selected.id.uuidString, forKey: "widget.selection.\(widgetId).eventId")
        suite.set(selected.title, forKey: "widget.selection.\(widgetId).title")
        suite.set(dateText, forKey: "widget.selection.\(widgetId).dateString")

        return SimpleEntry(
            date: now,
            title: selected.title,
            dateText: dateText,
            countdownText: countdownText,
            iconSymbolName: selected.iconSymbolName,
            eventColorHex: selected.eventColorHex
        )
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let dateText: String
    let countdownText: String
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
        let isPastEvent = entry.countdownText.contains("-")
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
    SimpleEntry(date: .now, title: "Summer Vacation", dateText: "Jul 14, 2025", countdownText: "- 129", iconSymbolName: "airplane", eventColorHex: "#3B82F6")
    SimpleEntry(date: .now, title: "Important Meeting", dateText: "Nov 20, 2025", countdownText: "Today", iconSymbolName: "briefcase", eventColorHex: "#A855F7")
    SimpleEntry(date: .now, title: "Birthday Party", dateText: "Dec 24, 2025", countdownText: "34", iconSymbolName: "birthday.cake", eventColorHex: "#EC4899")
}
