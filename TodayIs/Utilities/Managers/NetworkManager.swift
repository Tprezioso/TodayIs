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
                    var linksHref: String = try title.attr("href")
                    linksHref.insert("s", at: linksHref.index(linksHref.startIndex, offsetBy: 4))
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

    func getDetailHoliday(url: String, completed: @escaping (Result<DetailHoliday, TIError>) -> Void) {
        guard let url = URL(string: url) else {
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
                let links: Element = try doc.select("h3 a img").first()!
                let p: Element = try doc.select("p").first()!
                let pText = try p.text()
                let pLink = try links.attr("data-opt-src")
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

//    func downloadImage(fromURLString urlString: String, completed: @escaping (UIImage?) -> Void) {
//            let cacheKey = NSString(string: urlString)
//            
//            if let image = cache.object(forKey: cacheKey) {
//                completed(image)
//                return
//            }
//            
//            guard let url = URL(string:urlString) else {
//                completed(nil)
//                return
//            }
//            
//            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
//                guard let data = data, let image = UIImage(data: data) else {
//                    completed(nil)
//                    return
//                }
//                
//                self.cache.setObject(image, forKey: cacheKey)
//                completed(image)
//            }
//            task.resume()
//        }

}
