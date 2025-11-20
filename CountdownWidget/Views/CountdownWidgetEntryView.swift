import SwiftUI
import WidgetKit

struct CountdownWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownWidgetEntryView(entry: SimpleEntry(date: .now, title: "Sample", dateText: "Nov 19, 2025", countdownText: "7"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


