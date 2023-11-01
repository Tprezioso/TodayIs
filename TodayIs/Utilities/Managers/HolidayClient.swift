//
//  HolidayClient.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/19/23.
//

import Foundation
import SwiftSoup
import ComposableArchitecture
//import Models

public struct HolidayClient {
    public var getCurrentHoliday:(_ isToday: Bool) async throws -> Result<[Holiday], Error>
    public var getCurrentHolidayDetail:(_ url: String) async throws -> Result<DetailHoliday, Error>
}

extension HolidayClient: DependencyKey {
    public static let baseURL = "https://www.holidaycalendar.io"
    public static let todaysHoliday = "/what-holiday-is-today"
    public static let tomorrowsHoliday = "/what-holiday-is-tomorrow"

    public static var liveValue = HolidayClient(
        getCurrentHoliday: { isToday in
            guard let url = URL(string: isToday ? baseURL + todaysHoliday : baseURL + tomorrowsHoliday) else { throw NetworkError.invalidURL }

            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print(" ❌ Invalid Response")
                throw NetworkError.invalidResponse
            }
            guard let htmlString = String(data: data, encoding: .utf8) else { throw NetworkError.invalidURL }

            var holidays = [Holiday]()

            do {
                let html: String = htmlString
                let doc: Document = try SwiftSoup.parse(html)
                let todaysHolidays: Elements = try doc.getElementsByClass("card")
                for holiday in todaysHolidays {
//                    print(try holiday.select("a.card-link-image---image-wrapper").select("img").attr("src"))
//                    print(try holiday.select("p").text())
                    let title = try holiday.select("a.card-link-image---image-wrapper").select("img").attr("alt") //title
                    let link = try holiday.select("a.card-link-image---image-wrapper").select("a").attr("href") //link
                    let image = try holiday.select("a.card-link-image---image-wrapper").select("img").attr("src") //image
                    let description = try holiday.select("p").text() //description
                    holidays.append(Holiday(name: title, url: baseURL + link, imageURL: image, description: description))
                }
                return .success(holidays)
            } catch {
                print(error.localizedDescription)
                return .failure(error.localizedDescription as! Error)
            }
        }, 
        getCurrentHolidayDetail: { url in
            guard let url = URL(string: url) else { throw NetworkError.invalidURL }

            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print(" ❌ Invalid Response")
                throw NetworkError.invalidResponse
            }
            guard let htmlString = String(data: data, encoding: .utf8) else { throw NetworkError.invalidURL }
            do {
                let html: String = htmlString
                let doc: Document = try SwiftSoup.parse(html)
                let selectedHolidayDescription: String = try doc.getElementsByClass("t_holiday_intro_text").text() // description
                let selectedHolidayDetails: Elements = try doc.getElementsByClass(".facts-title")
                print(selectedHolidayDetails)

                return .success(DetailHoliday(description: selectedHolidayDescription))
            } catch {
                print(error.localizedDescription)
                return .failure(error.localizedDescription as! Error)
            }
        }
    )
}

extension HolidayClient: TestDependencyKey {
    public static var previewValue = HolidayClient(
        getCurrentHoliday: { _ in
            .success([
                Holiday(name: "Holiday 1", url: ""),
                Holiday(name: "Holiday 2", url: ""),
                Holiday(name: "Holiday 3", url: "")
            ])
        },
                                                   
        getCurrentHolidayDetail: { _ in
            .success(DetailHoliday(description: ""))
        }
    )

    public static var testValue = HolidayClient(
        getCurrentHoliday: { _ in
            .success([
                Holiday(name: "Holiday 1", url: ""),
                Holiday(name: "Holiday 2", url: ""),
                Holiday(name: "Holiday 3", url: "")
            ])
        }, 
        getCurrentHolidayDetail: { _ in
            .success(DetailHoliday(description: ""))
        }
    )
}

extension DependencyValues {
    public var currentHolidayClient: HolidayClient {
        get { self[HolidayClient.self] }
        set { self[HolidayClient.self] = newValue }
    }
}

extension String {

    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

extension StringProtocol { // for Swift 4 you need to add the constrain `where Index == String.Index`
    var byWords: [SubSequence] {
        var byWords: [SubSequence] = []
        enumerateSubstrings(in: startIndex..., options: .byWords) { _, range, _, _ in
            byWords.append(self[range])
        }
        return byWords
    }
}

public enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case invalidData
}
