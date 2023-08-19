//
//  MyWidget.swift
//  MyWidget
//
//  Created by Dermot Boyle on 3/4/23.
//

import WidgetKit
import SwiftUI

let someText = "You have 1 project Invite"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), someText: someText)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), someText: someText)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, someText: someText)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let someText: String
}

struct MyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack{
            Image("weaverLogo")
                .resizable()
                .frame(width: 122.0, height: 32.0)

            Text(entry.someText)
                .foregroundColor(Color("WeaverGreen"))
                .bold()
                .padding(.top, 16)
        }
    }
}

struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MyWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyWidgetEntryView(entry: SimpleEntry(date: Date(), someText: someText))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color("WeaverGreen"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
