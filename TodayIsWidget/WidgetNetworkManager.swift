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
                let price: Element = try doc.getElementsByClass("ndc-text-national-day-today-text-list").first()! // eventon_events_list
                let links: [Element] = try price.select("h3").array() //p
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

