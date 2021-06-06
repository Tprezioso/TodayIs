//
//  SearchDatePicker.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/5/21.
//

import SwiftUI

struct SearchDatePicker: View {
    @State private var searchDate = Date()
    var viewModel: SearchViewModel

    var body: some View {
        VStack {
            DatePicker(
                "Select A date", selection: $searchDate, displayedComponents: .date)
                .frame(height: 170)
                .padding()
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
            Button {
                let dateSelected = searchDate.getFormattedDate(format: "MMMM dd")
                print(dateSelected)
                viewModel.getHolidays(searchDate: dateSelected)
            } label: {
                TIButton(title: "Search")
            }
        }

    }
}
