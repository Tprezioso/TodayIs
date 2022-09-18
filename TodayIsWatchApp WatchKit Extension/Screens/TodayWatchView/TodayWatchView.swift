//
//  TodayWatchView.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/10/21.
//

import SwiftUI

struct TodayWatchView: View {
    @StateObject var viewModel = TodayWatchViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            VStack {
                if !viewModel.isHolidaysEmpty {
                    HolidayWatchListView(holidays: viewModel.holidays)
                } else {
                    EmptyState(message: "There was an issue loading Today's Holidays!\n Try again later")
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .active {
                    viewModel.getHolidays()
                } else if newPhase == .background {
                    print("Background")
                }
            }
            .navigationTitle("Today Is....")
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

struct HolidayWatchListView: View {
    var holidays: [Holiday]
    
    var body: some View {
        List(holidays) { holiday in
            if holiday.url == "" {
                Text("\(holiday.name)")
                    .font(.title)
                    .fontWeight(.semibold)
            } else {
                if let range = holiday.name.range(of: "All Day") {
                    let firstPart = holiday.name[holiday.name.startIndex..<range.lowerBound]
                    let secondPart = holiday.name[range.upperBound..<holiday.name.endIndex]
                    NavigationLink(destination: HolidayWatchDetailView(holiday: holiday)) {
                        VStack(alignment: .leading) {
                            Text(firstPart)
                                .font(.subheadline)
                            
                            Text(secondPart)
                                .font(.headline)
                        }
                    }
                }
            }
        }
    }
}
