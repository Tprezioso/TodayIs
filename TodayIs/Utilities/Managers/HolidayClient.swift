//
//  HolidayClient.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/19/23.
//

import Foundation
import Dependencies
import GRDB

public struct HolidayClient {
    public var getCurrentHoliday:(_ isToday: Bool) async throws -> [Holiday]
    public var getCurrentHolidayDetail:(_ url: String) async throws -> DetailHoliday
    public var getMonthsHolidays:(_ month: String, _ day: Int) async throws -> [Holiday]
}

extension HolidayClient: DependencyKey {
    public static var liveValue: HolidayClient {
        @Dependency(\.defaultDatabase) var database
        @Dependency(\.calendar) var calendar
        @Dependency(\.date.now) var now
        
        return HolidayClient(
            getCurrentHoliday: { isToday in
                let targetDate = isToday ? now : calendar.date(byAdding: .day, value: 1, to: now)!
                let month = calendar.component(.month, from: targetDate)
                let day = calendar.component(.day, from: targetDate)
                
                return try await database.read { db in
                    try Holiday
                        .filter(Column("month") == month && Column("day") == day)
                        .order(Column("name"))
                        .fetchAll(db)
                }
            }, 
            getCurrentHolidayDetail: { url in
                // For now, return a simple detail with the URL
                // In the future, you could scrape the URL or store more detailed info in the database
                return DetailHoliday(description: "Visit the link to learn more about this holiday!")
            }, 
            getMonthsHolidays: { monthName, day in
                let monthNumber = monthNameToNumber(monthName)
                
                return try await database.read { db in
                    try Holiday
                        .filter(Column("month") == monthNumber && Column("day") == day)
                        .order(Column("name"))
                        .fetchAll(db)
                }
            }
        )
    }
    
    private static func monthNameToNumber(_ monthName: String) -> Int {
        let months = [
            "january": 1, "february": 2, "march": 3, "april": 4,
            "may": 5, "june": 6, "july": 7, "august": 8,
            "september": 9, "october": 10, "november": 11, "december": 12
        ]
        return months[monthName.lowercased()] ?? 1
    }
}

extension HolidayClient: TestDependencyKey {
    public static var previewValue = HolidayClient(
        getCurrentHoliday: { _ in
            [
                Holiday(name: "National Pizza Day", month: 2, day: 9, url: "https://nationaltoday.com/national-pizza-day/", holidayDescription: "Celebrate America's favorite food"),
                Holiday(name: "Valentine's Day", month: 2, day: 14, url: "https://nationaltoday.com/valentines-day/", holidayDescription: "Celebrate love and affection"),
                Holiday(name: "Random Acts of Kindness Day", month: 2, day: 17, url: "https://nationaltoday.com/random-acts-of-kindness-day/", holidayDescription: "Spread kindness")
            ]
        },
                                                   
        getCurrentHolidayDetail: { _ in
            DetailHoliday(description: "This is a preview holiday!")
        }, 
        getMonthsHolidays: { _, _ in
            [
                Holiday(name: "National Pizza Day", month: 2, day: 9, url: "https://nationaltoday.com/national-pizza-day/", holidayDescription: "Celebrate America's favorite food"),
                Holiday(name: "Valentine's Day", month: 2, day: 14, url: "https://nationaltoday.com/valentines-day/", holidayDescription: "Celebrate love and affection")
            ]
        }
    )

    public static var testValue = HolidayClient(
        getCurrentHoliday: { _ in
            [
                Holiday(name: "Test Holiday 1", month: 1, day: 1, url: "https://example.com", holidayDescription: "Test description 1"),
                Holiday(name: "Test Holiday 2", month: 1, day: 1, url: "https://example.com", holidayDescription: "Test description 2")
            ]
        }, 
        getCurrentHolidayDetail: { _ in
            DetailHoliday(description: "Test detail description")
        }, 
        getMonthsHolidays: { _, _ in
            [
                Holiday(name: "Test Holiday 1", month: 1, day: 1, url: "https://example.com", holidayDescription: "Test description 1")
            ]
        }
    )
}

extension DependencyValues {
    public var currentHolidayClient: HolidayClient {
        get { self[HolidayClient.self] }
        set { self[HolidayClient.self] = newValue }
    }
}

