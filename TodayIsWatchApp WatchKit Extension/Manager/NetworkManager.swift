//
//  NetworkManager.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/22/21.
//

import UIKit
import SwiftSoup

final class NetworkManager {
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    private init() {}
    private let baseURL = "https://nationaldaycalendar.com/what-day-is-it/"
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
                let tomorrowHolidayData: [Element] = try doc.getElementsByClass("ultp-block-title").array()
                holidays.removeAll()
                if tomorrowHolidayData.isEmpty {
                    let todaysData: [Element] = try doc.getElementsByClass("ultp-block-title").array()
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
                let tomorrowHolidayData: [Element] = try doc.getElementsByClass("ultp-block-title").array()
                holidays.removeAll()
                if tomorrowHolidayData.isEmpty {
                    let todaysData: [Element] = try doc.getElementsByClass("ultp-block-title").array()
                    for holiday: Element in todaysData {
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
}
