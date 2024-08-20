//
//  ComplicationWidget.swift
//  ComplicationWidget
//
//  Created by Natasha Hartanti Winata on 20/08/24.
//

import WidgetKit
import SwiftUI

@main
struct MyComplicationWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "com.besafe.complication", provider: SimpleComplicationProvider()) { entry in
            SimpleComplicationView(entry: entry)
        }
        .supportedFamilies([.accessoryCorner])
        .configurationDisplayName("Safe Navigation")
        .description("Quick access to navigate to safe places.")
    }
}

struct SimpleComplicationProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleComplicationEntry {
        SimpleComplicationEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleComplicationEntry) -> Void) {
        let entry = SimpleComplicationEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleComplicationEntry>) -> Void) {
        let timeline = Timeline(entries: [SimpleComplicationEntry(date: Date())], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleComplicationEntry: TimelineEntry {
    let date: Date
}

struct SimpleComplicationView: View {
    let entry: SimpleComplicationEntry
    @Environment(\.openURL) var openURL
    
    var body: some View {
        // MARK: Image for the complication
        Image(systemName: "paperplane.fill")
            .resizable()
            .scaledToFit()
            .padding(10)

            .widgetURL(URL(string: "besafe://open"))
            .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct SimpleComplicationView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleComplicationView(entry: SimpleComplicationEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .accessoryCorner))
            .containerBackground(.fill.tertiary, for: .widget)
    }
}
