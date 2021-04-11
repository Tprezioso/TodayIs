//
//  NationalDayListView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/8/21.
//

import SwiftUI

struct NationalDayListView: View {
    @StateObject var viewModel = NationalDayListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.holidays) { holiday in
                NavigationLink(destination: NationalDayView(), isActive: $viewModel.isShowingDetailView) {
                    Text("\(holiday.name)")
                    
                }
                           
            }.navigationTitle("Today's Day is...")
        }.onAppear {
            viewModel.getHolidays()
        }
    }
}

struct NationalDayListView_Previews: PreviewProvider {
    static var previews: some View {
        NationalDayListView()
    }
}
