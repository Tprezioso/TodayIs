//
//  SearchView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 5/29/21.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                SearchListView(searchedHoliday: viewModel.holidays)
                SearchDatePicker(viewModel: viewModel)
                Spacer()
            }
            if viewModel.holidays.isEmpty {
                EmptyState(message: "Please use the Calendar picker below to search for a holiday on a specific date")
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

struct SearchListView: View {
    var searchedHoliday: [Holiday]
    
    var body: some View {
        List(searchedHoliday) { holiday in
            NavigationLink(holiday.name, destination: NationalDayView(holiday: holiday))
        }.listStyle(PlainListStyle())
    }
}

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

struct EmptyState: View {
    let message: String
    var body: some View {
        ZStack {
            VStack {
                Text(message)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    .padding()
                Spacer()
            }
        }
    }
}
