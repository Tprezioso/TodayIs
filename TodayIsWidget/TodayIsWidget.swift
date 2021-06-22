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


struct TodayIsTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> TodayIsTimelineEntry {
        TodayIsTimelineEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (TodayIsTimelineEntry) -> ()) {
        let entry = TodayIsTimelineEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        WidgetNetworkManager.shared.getHolidayData { [self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let holidays):
                    print(holidays)
                case .failure(let error):
                    print(error)
                     
                }
            }
        }
                    var entries: [TodayIsTimelineEntry] = []
                    var policy: TimelineReloadPolicy = .atEnd

                   
                        let entry = TodayIsTimelineEntry(date: Date())
                        entries.append(entry)
                   
                    let timeline = Timeline(entries: entries, policy: policy)
                    completion(timeline)
    }
    
}

struct TodayIsTimelineEntry: TimelineEntry {
    let date: Date
}

struct TodayIsWidgetEntryView : View {
    var entry: TodayIsTimelineProvider.Entry

    var body: some View {
        Text(entry.date, style: .time)
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
    }
}

struct TodayIsWidget_Previews: PreviewProvider {
    static var previews: some View {
        TodayIsWidgetEntryView(entry: TodayIsTimelineEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

class WidgetNetworkManager {
    static let shared = WidgetNetworkManager()
    private init() {}
    private let baseURL = "https://nationaldaycalendar.com/what-day-is-it/"
    var holidays = [Holiday]()
    
    // MARK: - Get Todays Holidays
    func getHolidayData(completed: @escaping (Result<[Holiday], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completed(.failure(Error.self as! Error))
                    return
                }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [self] (data, response, error) in
            guard let data = data else {
                completed(.failure(Error.self as! Error))
                return
            }
            
            guard let htmlString = String(data: data, encoding: .utf8) else {
                completed(.failure(Error.self as! Error))
                return
            }
            
            do {
                let doc: Document = try SwiftSoup.parse(htmlString)
                let price: Element = try doc.getElementsByClass("et_pb_text_inner").first()!
                let links: [Element] = try price.select("h3").array()
                holidays.removeAll()
                for title: Element in links {
                    let linksText: String = try title.text()
                    var linksHref: String = try title.select("a").attr("href")
                    if linksHref != "" {
                        if Array(linksHref)[4] != "s" {
                            linksHref.insert("s", at: linksHref.index(linksHref.startIndex, offsetBy: 4))
                        }

                    }
                    let holiday = Holiday(name: linksText, url: linksHref)
                    holidays.append(holiday)
                }
                completed(.success(holidays))
            } catch Exception.Error(let type, let message) {
                print(type, message)
            } catch {
                completed(.failure(Error.self as! Error))
            }
        }
        task.resume()
    }

    struct Holiday: Identifiable {
        let id = UUID()
        var name: String
        var url: String
    }
}
