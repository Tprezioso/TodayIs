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

