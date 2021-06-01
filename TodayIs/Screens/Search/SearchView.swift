//
//  SearchView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 5/29/21.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @State private var wakeUp = Date()
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                DatePicker(
                    "Select A date", selection: $wakeUp, displayedComponents: .date)
                    .frame(height: 170)
                    .padding()
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                Button {
                    let dateSelected = wakeUp.getFormattedDate(format: "MMMM dd")
                    print(dateSelected)
                    viewModel.getHolidays(searchDate: dateSelected)
                } label: {
                    TIButton(title: "Search")
                }
            }
            
            List(viewModel.holidays) { holiday in
                    NavigationLink(holiday.name, destination: NationalDayView(holiday: holiday))
            }.listStyle(PlainListStyle())
            Spacer()
//            SearchBar(viewModel: viewModel)
//                .padding()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
