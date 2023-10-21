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
    public var getCurrentHoliday:() async throws -> Result<[Holiday], Error>
}

extension HolidayClient: DependencyKey {
    public static let baseURL = "https://www.holidaycalendar.io"
    public static let TodaysHoliday = "/what-holiday-is-today"

    public static var liveValue = HolidayClient(
        getCurrentHoliday: {
            guard let url = URL(string: baseURL + TodaysHoliday) else { throw NetworkError.invalidURL }

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
                let todaysHolidays: Elements = try doc.getElementsByClass("card") // w-dyn-item w-inline-block
                for holiday in try todaysHolidays.select("a.card-link-image---image-wrapper").array() {
                    print(try holiday.select("img").attr("alt"))
                    //.select("img").attr("alt") title
                    //.select("a").attr("href") link
                }


//                holidays.insert(Holiday(name: "", url: ""), at: 1)

                return .success(holidays)
            } catch {
                print(error.localizedDescription)
                return .failure(error.localizedDescription as! Error)
            }
        }
    )
}

extension HolidayClient: TestDependencyKey {
    public static var previewValue = HolidayClient(getCurrentHoliday: {
        .success([
           Holiday(name: "Holiday 1", url: ""),
           Holiday(name: "Holiday 2", url: ""),
           Holiday(name: "Holiday 3", url: "")
        ])
    })

    public static var testValue = HolidayClient(getCurrentHoliday: {
        .success([
            Holiday(name: "Holiday 1", url: ""),
            Holiday(name: "Holiday 2", url: ""),
            Holiday(name: "Holiday 3", url: "")
        ])
    })

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