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
        ZStack {
            NavigationView {
                List(viewModel.holidays) { holiday in
                    NavigationLink(holiday.name, destination: NationalDayView(holiday: holiday))
                    
//                    Text("\(holiday.name)")
//                        .onTapGesture {
//                            viewModel.selectedHoliday = holiday
//                            viewModel.isShowingDetail = true
//                        }
                }.navigationTitle("Today is...")
                
            }
        }.onAppear {
            viewModel.getHolidays()
        }
//        if viewModel.isShowingDetail {
//            NationalDayView(holiday: viewModel.selectedHoliday!,
//                            isShowingDetailView: $viewModel.isShowingDetailView)
//        }
        
        if viewModel.isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                .scaleEffect(2, anchor: .center)
        }
    }
}


struct NationalDayListView_Previews: PreviewProvider {
    static var previews: some View {
        NationalDayListView()
    }
}
