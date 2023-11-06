//
//  AtAGlanceView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/1/22.
//

import SwiftUI

struct YearView: View {
    
    let months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    var body: some View {
        List {
            ForEach(months, id: \.self) { month in
                NavigationLink(destination: SelectedMonthView(selectedMonth: month)) {
                    Text(month)
                        .font(.title2)
                }
            }
        }.navigationTitle("Year")
    }
}

struct AtAGlanceView_Previews: PreviewProvider {
    static var previews: some View {
        YearView()
    }
}
