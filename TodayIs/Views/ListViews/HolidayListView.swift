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
                
                var split = holiday.name.components(separatedBy: "–" )
                let firstPart = split.last//holiday.name[holiday.name.startIndex..<range.lowerBound]
                let secondPart = split.first//holiday.name[range.upperBound..<holiday.name.endIndex]
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
