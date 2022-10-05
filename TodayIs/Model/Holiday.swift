//
//  Holiday.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/10/21.
//

import SwiftUI

struct Holiday: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var url: String
    var section: Int?
}

struct DetailHoliday: Identifiable {
    let id = UUID()
    var imageURL: String
    let description: String
}
