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
    public var getCurrentHoliday:() async throws -> [Holiday]?
}

extension HolidayClient: DependencyKey {
    public static let baseURL = "https://www.esbnyc.com"
    public static let calendarEndPoint = "/about/tower-lights"

    public static var liveValue = HolidayClient(
        getCurrentHoliday: {
            guard let url = URL(string: baseURL + calendarEndPoint) else { throw NetworkError.invalidURL }

            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print(" ❌ Invalid Response")
                throw NetworkError.invalidResponse
            }
            guard let htmlString = String(data: data, encoding: .utf8) else { return [] }

            var holidays = [Holiday]()

            do {
                let html: String = htmlString
                let doc: Document = try SwiftSoup.parse(html)
                let notToday: [Element] = try doc.getElementsByClass("not-today").array()
                var todayImage: String = try doc.getElementsByClass("background-image-wrapper").attr("style")
                todayImage = todayImage.slice(from: "(", to: ")") ?? ""
                let today: [Element]? = try doc.getElementsByClass("is-today").array()
                var dayLight: String? = try today?.first?.select("h3").text()
                let dayDate: String? = try today?.first?.select("h2").text()
                let dayDescription: String? = try today?.first?.select("p").text()

                for today in notToday {
                    let img: String? = try today.select("img").attr("src")
                    var light: String = try today.select("h3").text()
                    let day: String = try today.select("h2").text()
                    let content: String = try today.select("p").text()

                    holidays.append(Holiday(name: "", url: ""))
                }

                if dayLight?.byWords.last?.lowercased() == "color" {
                    dayLight = dayLight?.components(separatedBy: " ").dropLast().joined(separator: " ")
                }
                holidays.insert(Holiday(name: "", url: ""), at: 1)

                return holidays
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    )
}

extension HolidayClient: TestDependencyKey {
    public static var previewValue = HolidayClient(getCurrentHoliday: {
        return [
           Holiday(name: "Holiday 1", url: ""),
           Holiday(name: "Holiday 2", url: ""),
           Holiday(name: "Holiday 3", url: "")
        ]
    })

    public static var testValue = HolidayClient(getCurrentHoliday: {
        return [
            Holiday(name: "Holiday 1", url: ""),
            Holiday(name: "Holiday 2", url: ""),
            Holiday(name: "Holiday 3", url: "")
        ]
    })

}

extension DependencyValues {
    public var currentTowerClient: HolidayClient {
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
