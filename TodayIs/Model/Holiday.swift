//
//  Holiday.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/10/21.
//

import SwiftUI

struct Holiday: Identifiable {
    let id = UUID()
    let name: String
    let url: String
}

struct DetailHoliday: Identifiable {
    let id = UUID()
    let image: String
    let description: String
}
