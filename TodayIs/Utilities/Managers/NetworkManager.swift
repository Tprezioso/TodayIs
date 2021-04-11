//
//  NetworkManager.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/8/21.
//

import UIKit
import SwiftSoup

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    private init() {}
    private let baseURL = "https://nationaldaycalendar.com/what-day-is-it/"
    var holidays = [Holiday]()
    
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
                print("couldn't cast data into String")
                return
            }
            
            do {
                let doc: Document = try SwiftSoup.parse(htmlString)
                let links: [Element] = try doc.select("h3 a").array()
                
                for title: Element in links {
                    let linksText: String = try title.text()
                    let linksHref: String = try title.attr("href")
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
    
}
