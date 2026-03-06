//
//  Holiday.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/10/21.
//

import Foundation
import GRDB

public struct Holiday: Identifiable, Hashable, Sendable, Codable {
    public var id: String
    public var name: String
    public var month: Int
    public var day: Int
    public var url: String
    public var imageURL: String?
    public var holidayDescription: String?
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        month: Int,
        day: Int,
        url: String,
        imageURL: String? = nil,
        holidayDescription: String? = nil
    ) {
        self.id = id
        self.name = name
        self.month = month
        self.day = day
        self.url = url
        self.imageURL = imageURL
        self.holidayDescription = holidayDescription
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case month
        case day
        case url
        case imageURL = "image_url"
        case holidayDescription = "description"
    }
}

extension Holiday: FetchableRecord, PersistableRecord {
    public static var databaseTableName: String { "holidays" }
}

public struct DetailHoliday: Identifiable, Equatable, Sendable {
    public let id = UUID()
    public var imageURL: String?
    public let description: String
    public let facts: [Fact]?

    public init(imageURL: String? = nil, description: String, facts: [Fact]? = nil) {
        self.imageURL = imageURL
        self.description = description
        self.facts = facts
    }
}

public struct Fact: Equatable, Sendable {
    public let title: String
    public let celebration: String
}
