//
//  SearchListView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/5/21.
//

import SwiftUI

struct SearchListView: View {
    var searchedHoliday: [Holiday]
    
    var body: some View {
        List(searchedHoliday) { holiday in
            NavigationLink(holiday.name, destination: NationalDayView(holiday: holiday))
        }.listStyle(PlainListStyle())
    }
}

