//
//  Holiday.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/22/21.
//

import SwiftUI

struct Holiday: Identifiable {
    let id = UUID()
    var name: String
    var url: String
}

struct DetailHoliday: Identifiable {
    let id = UUID()
    var imageURL: String
    let description: String
}
