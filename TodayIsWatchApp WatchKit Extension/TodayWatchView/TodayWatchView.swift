//
//  TodayWatchView.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/10/21.
//

import SwiftUI

struct TodayWatchView: View {
    @StateObject var viewModel = TodayWatchViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                if !viewModel.isHolidaysEmpty {
                    List(viewModel.holidays) { holiday in
                        if holiday.url == "" {
                            Text("\(holiday.name)")
                                .font(.title)
                                .fontWeight(.semibold)
                        } else {
                            NavigationLink(holiday.name, destination: HolidayWatchDetailView(holiday: holiday))
                        }
                    }
                } else {
                    EmptyState(message: "There was an issue loading Today's Holidays!\n Try again later")
                }
            }
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert.init(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            
            .onAppear {
                viewModel.getHolidays()
            }
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(2, anchor: .center)
            }
        }
    }
}

struct TodayWatchView_Previews: PreviewProvider {
    static var previews: some View {
        TodayWatchView()
    }
}
