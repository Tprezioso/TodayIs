//
//  TodayIsWidget.swift
//  TodayIsWidget
//
//  Created by Thomas Prezioso Jr on 6/22/21.
//

import WidgetKit
import SwiftUI
import Intents
import SwiftSoup
import ComposableArchitecture

struct TodayIsTimelineProvider: TimelineProvider {
    @Dependency(\.currentHolidayClient) var currentHolidayClient
    func placeholder(in context: Context) -> TodayIsTimelineEntry {
        TodayIsTimelineEntry(date: Date(), holidays: [Holiday(name:"Holiday", url:"")])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TodayIsTimelineEntry) -> ()) {
        let entry = TodayIsTimelineEntry(date: Date(), holidays: [Holiday(name:"Holiday", url:"")])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task { @MainActor in
            var entries: [TodayIsTimelineEntry] = []
            var entry: TodayIsTimelineEntry
            let policy: TimelineReloadPolicy = .atEnd

            let result = try await currentHolidayClient.getCurrentHoliday(true)
            switch result {
            case .success(let holidays):
                entry = TodayIsTimelineEntry(date: Date(), holidays: holidays)
                print(holidays)
            case .failure(let error):
                entry = TodayIsTimelineEntry(date: Date(), holidays: [Holiday(name:"Error", url:"")])
                print(error)

            }
            entries.append(entry)

            let timeline = Timeline(entries: entries, policy: policy)
            completion(timeline)
        }
    }
}

struct TodayIsTimelineEntry: TimelineEntry {
    let date: Date
    let holidays: [Holiday]
}

struct TodayIsWidgetEntryView : View {
    var entry: TodayIsTimelineProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        ZStack {

            switch widgetFamily {
            case .systemSmall:
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(Date().formatted(.dateTime.month(.abbreviated).day(.defaultDigits).year(.defaultDigits)))")
                        .font(.subheadline)
                        .bold()

                    Text(entry.holidays[0].name)
                        .bold()
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.red, lineWidth: 5)

                        )
                }

            case .systemMedium:
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(Date().formatted(.dateTime.month(.abbreviated).day(.defaultDigits).year(.defaultDigits)))")
                        .font(.subheadline)
                        .bold()
                    ForEach(entry.holidays.prefix(4), id: \.self) { index in
                        Text(index.name)
                            .bold()
                            .padding(.horizontal)
                            .padding(.vertical, 3)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.red, lineWidth: 2)

                            )
                    }
                }
                
            case .systemLarge, .systemExtraLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline: 
                EmptyView()

            @unknown default:
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(Date().formatted(.dateTime.month(.abbreviated).day(.defaultDigits).year(.defaultDigits)))")
                        .font(.subheadline)
                        .bold()

                    Text(entry.holidays[0].name)
                        .bold()
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.red, lineWidth: 5)

                        )
                }
            }
        }
    }
}

@main
struct TodayIsWidget: Widget {
    let kind: String = "TodayIsWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TodayIsTimelineProvider()) { entry in
            TodayIsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Today Is....")
        .description("This is will show the national holidays for today.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

struct TodayIsWidget_Previews: PreviewProvider {
    static var previews: some View {
        TodayIsWidgetEntryView(entry: TodayIsTimelineEntry(date: Date(), holidays: [Holiday(name:"Test", url:"")]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
