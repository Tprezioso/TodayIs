//
//  HolidayListView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 9/17/22.
//

import SwiftUI

struct HolidayListView: View {
    var holidays: [Holiday]
    
    var body: some View {
        List(holidays) { holiday in
            if holiday.url == "" {
                Text("\(holiday.name)")
                    .font(.title)
                    .fontWeight(.semibold)
            } else {
                
                let split = holiday.name.components(separatedBy: "–")
                let firstPart = split.last
                let secondPart = split.first
                NavigationLink(destination: NationalDayView(holiday: holiday)) {
                    VStack(alignment: .leading) {
                        Text(firstPart ?? "")
                            .font(.headline)
                        
                        Text(secondPart ?? "")
                            .font(.title2)
                    }
                }
            }
        }
    }
}
