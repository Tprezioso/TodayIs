//
//  TomorrowWatchView.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/24/21.
//

import SwiftUI

struct TomorrowWatchView: View {
    @StateObject var viewModel = TomorrowWatchViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            VStack {
                if !viewModel.isHolidaysEmpty {
                    List(viewModel.holidays) { holiday in
                        if holiday.url == "" {
                            Text("\(holiday.name)")
                                .font(.headline)
                                .bold()
                        } else {
                            NavigationLink(holiday.name, destination: HolidayWatchDetailView(holiday: holiday))
                        }
                    }
                } else {
                    EmptyState(message: "There was an issue loading Tomorrow's Holidays!\n Try again later")
                }
            }.onChange(of: scenePhase) { newPhase in
                if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .active {
                    print("Active")
                } else if newPhase == .background {
                    print("Background")
                }
            }
            .navigationBarTitle("Tomorrow Is....")
            .onAppear {
                viewModel.getTomorrowsHolidays()
        }
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(2, anchor: .center)
            }
        }
    }
}

struct TomorrowWatchView_Previews: PreviewProvider {
    static var previews: some View {
        TomorrowWatchView()
    }
}
