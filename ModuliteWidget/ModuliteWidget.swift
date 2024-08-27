//
//  ModuliteWidget.swift
//  ModuliteWidget
//
//  Created by André Wozniack on 27/08/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), buttons: Array(repeating: WidgetButtonView(image: .analogKnob, url: "youtube://"), count: 6))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let buttons = fetchButtonsFromData()
        let entry = SimpleEntry(date: Date(), buttons: buttons)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let buttons = fetchButtonsFromData()
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate, buttons: buttons)

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
    
    private func fetchButtonsFromData() -> [WidgetButtonView] {
        // TODO: Make this function recive Data from SwiftData
        return [
            WidgetButtonView(image: .analogKnob, url: "spotify://"),
            WidgetButtonView(image: .analogRegular, url: "google://"),
            WidgetButtonView(image: .analogScreen, url: "youtube://"),
            WidgetButtonView(image: .analogSound, url: "whatsapp://"),
            WidgetButtonView(image: .analogSwitch, url: "waze://"),
            WidgetButtonView(image: .analogKnob, url: "googlemaps://")
        ]
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let buttons: [WidgetButtonView]
}

struct ModuliteWidgetEntryView: View {
    var entry: Provider.Entry
    
    let buttons = [
        WidgetButtonView(image: .analogKnob, url: "spotify://"),
        WidgetButtonView(image: .analogRegular, url: "google://"),
        WidgetButtonView(image: .analogScreen, url: "youtube://"),
        WidgetButtonView(image: .analogSound, url: "whatsapp://"),
        WidgetButtonView(image: .analogSwitch, url: "waze://"),
        WidgetButtonView(image: .analogKnob, url: "googlemaps://")
    ]

    var body: some View {
        WidgetButtonLabelView(buttons: buttons )
    }
}

struct ModuliteWidget: Widget {
    let kind: String = "ModuliteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ModuliteWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ModuliteWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}


#Preview(as: .systemLarge) {
    ModuliteWidget()
} timeline: {
    SimpleEntry(date: .now, buttons: [
        WidgetButtonView(image: .analogKnob, url: "spotify://"),
        WidgetButtonView(image: .analogRegular, url: "google://"),
        WidgetButtonView(image: .analogScreen, url: "youtube://"),
        WidgetButtonView(image: .analogSound, url: "whatsapp://"),
        WidgetButtonView(image: .analogSwitch, url: "waze://"),
        WidgetButtonView(image: .analogKnob, url: "googlemaps://")
    ])
}
