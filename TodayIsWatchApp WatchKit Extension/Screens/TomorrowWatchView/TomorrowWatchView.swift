//
//  TomorrowWatchView.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/24/21.
//

import SwiftUI
import ComposableArchitecture

struct TomorrowWatchDomain: Reducer {
    struct State: Equatable {

    }

    enum Action: Equatable {

    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}

struct TomorrowWatchView: View {
    @StateObject var viewModel = TomorrowWatchViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            VStack {
                if !viewModel.isHolidaysEmpty {
//                    HolidayWatchListView(holidays: viewModel.holidays)
                } else {
                    EmptyState(message: "There was an issue loading Tomorrow's Holidays!\n Try again later")
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .active {
                    viewModel.getTomorrowsHolidays()
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
