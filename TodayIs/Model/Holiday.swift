//
//  Holiday.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/10/21.
//

import SwiftUI

struct Holiday: Identifiable {
    let id = UUID()
    var name: String
    var url: String
    var section: String?
}

struct DetailHoliday: Identifiable {
    let id = UUID()
    var imageURL: String
    let description: String
}
