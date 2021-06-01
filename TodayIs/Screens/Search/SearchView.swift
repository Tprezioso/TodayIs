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
            DatePicker(
                "Select A date", selection: $wakeUp, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()

            Button {
                let dateSelected = wakeUp.getFormattedDate(format: "MMMM dd")
                print(dateSelected)
                viewModel.getHolidays(searchDate: dateSelected)
            } label: {
                TIButton(title: "Search")
            }
            List(viewModel.holidays) { holiday in
                if holiday.url == "" {
                    Text("\(holiday.name)")
                        .font(.title)
                        .fontWeight(.semibold)
                } else {
                    NavigationLink(holiday.name, destination: NationalDayView(holiday: holiday))
                }
            }

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
