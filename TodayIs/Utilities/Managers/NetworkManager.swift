//
//  NetworkManager.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/8/21.
//

import UIKit


final class NetworkManager {
    
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    private init() {}

    private let baseURL = "https://nationaldaycalendar.com/what-day-is-it/"
    
//    func getTodaysHoliday(completed: @escaping (Result<[Appetizer], TIError>) -> Void) {
//        guard let url = URL(string: baseURL) else {
//            completed(.failure(TIError.invalidURL))
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
//            if let _ = error {
//                completed(.failure(TIError.unableToComplete))
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(.failure(TIError.invalidResponse))
//                return
//            }
//
//            guard let data = data else {
//                completed(.failure(TIError.invalidData))
//                return
//            }
//
//            do {
//                let decoder = try JSONDecoder().decode(AppetizerResponse.self, from: data)
//                completed(.success(decoder.request))
//            } catch {
//                completed(.failure(TIError.invalidData))
//            }
//
//        }
//        task.resume()
//    }
    
    func findData() {
        let url = URL(string: baseURL)!
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
          guard let data = data else {
            print("data was nil")
            return
          }
          guard let htmlString = String(data: data, encoding: .utf8) else {
            print("couldn't cast data into String")
            return
          }
          print(htmlString)
        }
        task.resume()

    }
    
}
