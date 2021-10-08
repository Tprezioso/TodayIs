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
                let price: Element = try doc.getElementsByClass("ndc-text-national-day-today-text-list").first()! //eventon_events_list
                let links: [Element] = try price.select("h3").array() //p
                holidays.removeAll()
                if links.isEmpty {
                    let price: Element = try doc.getElementsByClass("eventon_events_list").first()! //eventon_events_list
                    let links: [Element] = try price.select("p").array() //p
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
                } else {
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
//                let links: Element = try doc.select("img")[4] //h3 a img
                let p: Element =  try doc.getElementsByClass("single-post").first()!
//                print(p)
                let links: Element = try p.select("img").first()!
                let plinks: String = try p.select("p").text()
//                let p1 = try p[0].text()
//                let p2 = try p[1].text()
//                let p3 = try p[2].text()
//                let p4 = try p[3].text()
                var pText = plinks
//                if p1 == "" {
//                    pText = p2 + p3
//                } else if p2 == "" {
//                    pText = p3 + p4
//                } else {
//                    pText = p1 + p2
//                }
                
                if pText == "" {
                    pText = "No Description Available"
                }
                let pLink = try links.attr("src")
                
                let detailHoliday = DetailHoliday(imageURL: pLink, description: pText)
                
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
                let price: Element = try doc.getElementsByClass("eventon_events_list").first()! //eventon_events_list
                let links: [Element] = try price.select("p").array() //p
                holidays.removeAll()
                if links.isEmpty {
                    let price: Element = try doc.getElementsByClass("ndc-text-tomorrows-celebrations").first()! //eventon_events_list
                    let links: [Element] = try price.select("h3").array() //p
                    holidays.removeAll()
                    for title: Element in links {
                        let linksText: String = try title.text()
                        var linksHref: String = try title.select("a").attr("href")
                        if linksText.prefix(3) == currentDateString.prefix(3) {
                            break
                        }
                        if linksHref != "" {
                            if Array(linksHref)[4] != "s" {
                                linksHref.insert("s", at: linksHref.index(linksHref.startIndex, offsetBy: 4))
                            }
                            
                        }
                        let holiday = Holiday(name: linksText, url: linksHref)
                        if holiday.url.isEmpty {
                            break
                        } else {
                            holidays.append(holiday)
                        }
                    }
                    completed(.success(holidays))
                } else {
                    holidays.removeAll()
                    for title: Element in links {
                        let linksText: String = try title.text()
                        var linksHref: String = try title.select("a").attr("href")
                        if linksText.prefix(3) == currentDateString.prefix(3) {
                            break
                        }
                        if linksHref != "" {
                            if Array(linksHref)[4] != "s" {
                                linksHref.insert("s", at: linksHref.index(linksHref.startIndex, offsetBy: 4))
                            }
                        }
                        let holiday = Holiday(name: linksText, url: linksHref)
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
