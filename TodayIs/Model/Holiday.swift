//
//  Holiday.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/10/21.
//

import SwiftUI

public struct Holiday: Identifiable, Hashable {
    public let id = UUID()
    public var name: String
    public var url: String
    public var imageURL: String?
    public var description: String?
    public var section: Int?
}

public struct DetailHoliday: Identifiable {
    public  let id = UUID()
    public var imageURL: String
    public let description: String
}
