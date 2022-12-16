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
//    private let currentDateURL = "https://nationaldaycalendar.com/?s="
    private let currentDateURL = "https://nationaldaycalendar.com/?s=december+12"
    private let tomorrowURL = "https://nationaldaycalendar.com/tomorrow/"
    
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
                    let todaysData: Element = try doc.getElementsByClass("eventon_events_list").first()! //eventon_events_list
                    let todaysHolidaysData: [Element] = try todaysData.select("p").array() //p
                    for holiday: Element in todaysHolidaysData {
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
    
    // MARK: - Get Detail for Selected Holiday
    func getDetailHoliday(url: String, completed: @escaping (Result<DetailHoliday, TIError>) -> Void) {
        guard let url = URL(string: url) else {
            completed(.failure(TIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
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
                let holidayData: Element =  try doc.getElementsByClass("site-content").first()!
                var imageLink = ""
                
                let holidayImage: Elements = try holidayData.select("img")
//                let holidayImageURL:
                for image in holidayImage {
                    if try image.attr("src").prefix(5) == "https" {
                        imageLink = try image.attr("src")
                        break
                    }
                }
                var holidayText: String = try holidayData.select("p").text()
                if holidayText == "" {
                    holidayText = "No Description Available"
                }
                
                let detailHoliday = DetailHoliday(imageURL: imageLink, description: holidayText)
                completed(.success(detailHoliday))
            } catch Exception.Error(let type, let message) {
                print(type, message)
            } catch {
                completed(.failure(TIError.invalidData))
            }
        }
        task.resume()
    }
    
    // MARK: - Get Tomorrows Holidays
    func getTomorrowsHolidayData(completed: @escaping (Result<[Holiday], TIError>) -> Void) {
        guard let url = URL(string: tomorrowURL) else {
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
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMMM dd"
                let currentDateString: String = dateFormatter.string(from: date)
                
                let doc: Document = try SwiftSoup.parse(htmlString)
//                let events: Element = try doc.getElementsByClass("eventon_events_list").first()! //eventon_events_list
//                let tomorrowHolidayData: [Element] = try events.select("p").array() //p
                let tomorrowHolidayData: [Element] = try doc.getElementsByClass("ultp-block-title").array()
                holidays.removeAll()
                if tomorrowHolidayData.isEmpty {
                    let tomorrowData: Element = try doc.getElementsByClass("ndc-text-tomorrows-celebrations").first()! //eventon_events_list
                    let holidaysData: [Element] = try tomorrowData.select("h3").array() //p
                    holidays.removeAll()
                    for holiday: Element in holidaysData {
                        let holidayTitle: String = try holiday.text()
                        var holidayLink: String = try holiday.select("a").attr("href")
                        if holidayTitle.prefix(3) == currentDateString.prefix(3) {
                            break
                        }
                        if holidayLink != "" {
                            if Array(holidayLink)[4] != "s" {
                                holidayLink.insert("s", at: holidayLink.index(holidayLink.startIndex, offsetBy: 4))
                            }
                            
                        }
                        let holiday = Holiday(name: holidayTitle, url: holidayLink)
                        if holiday.url.isEmpty {
                            break
                        } else {
                            holidays.append(holiday)
                        }
                    }
                    completed(.success(holidays))
                } else {
                    holidays.removeAll()
                    for holiday: Element in tomorrowHolidayData {
                        let holidayTitle: String = try holiday.text()
                        var holidayLink: String = try holiday.select("a").attr("href")
                        if holidayTitle.prefix(3) == currentDateString.prefix(3) {
                            break
                        }
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
    
    // MARK: - Download Image
    func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let str = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return completed(nil) }

        guard let urlImage = URL(string: str.removingPercentEncoding!) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: urlImage)) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
    
    // MARK: - Search for Holidays on a Specific Date
    
    func getHolidaysForMonth(_ month: String,completed: @escaping (Result<[Holiday], TIError>) -> Void) {
        let month = month.lowercased()
        let monthURL = "https://nationaldaycalendar.com/\(month)/"
        print("Search result: \(monthURL)")
        
        guard let url = URL(string: monthURL) else {
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
                let section: Element = try doc.getElementsByClass("ndc-column ndc_column_4_4 ").first()!
                let holidayData: [Element] = try section.select("strong, ul").array()
                holidays.removeAll()
                var date = ""
                for holidayDatum in holidayData {
                    if holidayDatum.tagName() == "strong" {
                        let holidaySection = try holidayDatum.text().components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                        if !holidaySection.isEmpty {
                            date = holidaySection
                        }
                    }
                    
                    let links: [Element] = try holidayDatum.select("a").array()
                    try links.forEach { link in
                        let linksText: String = try link.text()
                        var linksHref: String = try link.select("a").attr("href")
                        if linksHref != "" {
                            if Array(linksHref)[4] != "s" {
                                linksHref.insert("s", at: linksHref.index(linksHref.startIndex, offsetBy: 4))
                            }
                        }
                        let holiday = Holiday(name: linksText, url: linksHref, section: Int(date))
                        holidays.append(holiday)
                    }
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
