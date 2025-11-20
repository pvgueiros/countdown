import AppIntents

struct SelectDateIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Select Date" }
    static var description: IntentDescription { "Choose a saved date of interest to display." }

    @Parameter(title: "Date")
    var selected: DateOfInterestAppEntity?
}


