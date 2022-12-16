//
//  NetworkManager.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/22/21.
//

import UIKit
import SwiftUI
import SwiftSoup

class WidgetNetworkManager {
    static let shared = WidgetNetworkManager()
    private init() {}
    private let baseURL = "https://nationaldaycalendar.com/what-day-is-it/"
    var holidays = [Holiday]()
    
    // MARK: - Get Todays Holidays
    func getHolidayData(completed: @escaping (Result<[Holiday], TIError>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completed(.failure(TIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [self] (data, response, error) in
            guard let data = data else {
                completed(.failure(TIError.invalidData))
                return
            }
            
            guard let htmlString = String(data: data, encoding: .utf8) else {
                completed(.failure(TIError.invalidData))
                return
            }
            
            do {
                let doc: Document = try SwiftSoup.parse(htmlString)
                let tomorrowHolidayData: [Element] = try doc.getElementsByClass("ultp-block-title").array() //eventon_events_list
//                let tomorrowHolidayData: [Element] = try events.select("a").array() //p
                holidays.removeAll()
                if tomorrowHolidayData.isEmpty {
                    let todaysData: [Element] = try doc.getElementsByClass("ultp-block-title").array() //eventon_events_list
//                    let todaysHolidaysData: [Element] = try todaysData.select("p").array() //p
                    for holiday: Element in todaysData {
                        let holidayTitle: String = try holiday.text()
                        var holidayLink: String = try holiday.select("a").attr("href")
                        if holidayLink != "" {
                            if Array(holidayLink)[4] != "s" {
                                holidayLink.insert("s", at: holidayLink.index(holidayLink.startIndex, offsetBy: 4))
                            }
                        }
                        let holiday = Holiday(name: holidayTitle, url: holidayLink)
                        holidays.append(holiday)
                    }
                    completed(.success(holidays))
                } else {
                    for holiday: Element in tomorrowHolidayData {
                        let holidayTitle: String = try holiday.text()
                        var holidayLink: String = try holiday.select("a").attr("href")
                        if holidayLink != "" {
                            if Array(holidayLink)[4] != "s" {
                                holidayLink.insert("s", at: holidayLink.index(holidayLink.startIndex, offsetBy: 4))
                            }
                        }
                        let holiday = Holiday(name: holidayTitle, url: holidayLink)
                        holidays.append(holiday)
                    }
                    completed(.success(holidays))
                }
            } catch Exception.Error(let type, let message) {
                print(type, message)
            } catch {
                completed(.failure(TIError.invalidData))
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

