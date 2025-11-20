import AppIntents

struct SelectEventIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Select Event" }
    static var description: IntentDescription { "Choose a saved event to display." }

    @Parameter(title: "Select Event")
    var selected: EventAppEntity?
}



