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
                    countdownText: "0")
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

//    func relevances() async -> WidgetRelevances<SelectEventIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
    
    private func entry(for configuration: SelectEventIntent) async -> SimpleEntry {
        guard let selected = configuration.selected else {
            return SimpleEntry(
                date: Date(),
                title: "No date selected",
                dateText: "",
                countdownText: "—"
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
        let countdownText = isToday ? localized("widget.countdown.today", default: "Today")
            : (isFuture ? "\(daysNumber)" : "- \(daysNumber)")
        let dateText = DateFormatter.localizedString(from: selected.date, dateStyle: .medium, timeStyle: .none)
        
        // Classification and labels
        let classification: SimpleEntry.Classification = isToday ? .today : (isFuture ? .future : .past)
        let labelText: String = {
            switch classification {
            case .past:
                return localized("widget.countdown.ago", default: "ago")
            case .future:
                return localized("widget.countdown.days", default: "days")
            case .today:
                return localized("widget.countdown.today", default: "Today")
            }
        }()

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
            eventColorHex: selected.eventColorHex,
            classification: classification,
            labelText: labelText,
            dayCount: daysNumber
        )
    }
    
    private func localized(_ key: String, default fallback: String) -> String {
        let value = NSLocalizedString(key, comment: "")
        if value == key { return fallback }
        return value
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let dateText: String
    let countdownText: String
    var iconSymbolName: String = "calendar"
    var eventColorHex: String = "#808080"
    enum Classification: String { case past, today, future }
    var classification: Classification = .future
    var labelText: String = ""
    var dayCount: Int = 0
}

// Entry view is defined in Views/CountdownWidgetEntryView.swift

struct CountdownWidget: Widget {
    let kind: String = "CountdownWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SelectEventIntent.self, provider: Provider()) { entry in
            CountdownWidgetEntryView(entry: entry)
                .containerBackground(.fill.secondary, for: .widget)
        }
        .configurationDisplayName("Countdown")
        .description("Shows a countdown for a selected date.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    CountdownWidget()
} timeline: {
    SimpleEntry(date: .now, title: "Vacation", dateText: "Nov 19, 2025", countdownText: "10")
    SimpleEntry(date: .now, title: "Today", dateText: "Nov 19, 2025", countdownText: "Today")
}
