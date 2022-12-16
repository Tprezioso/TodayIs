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
                
//                var split = holiday.name.split(separator: " ")
//                if let range = holiday.name.range(of: "All Day") {
//                    let firstPart = holiday.name[holiday.name.startIndex..<range.lowerBound]
//                    let secondPart = holiday.name[range.upperBound..<holiday.name.endIndex]
//                var date = split.suffix(2).joined(separator: " ")
//               let day = split.dropLast(3)
                    NavigationLink(destination: NationalDayView(holiday: holiday)) {
//                        VStack(alignment: .leading) {
//                            Text(date ?? "")
//                                .font(.headline)
//
//                            Text(day.joined(separator: " "))
//                                .font(.title2)
//                        }
                        Text(holiday.name)
                    }
            }
        }
    }
}
