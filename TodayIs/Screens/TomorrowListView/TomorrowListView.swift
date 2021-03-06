//
//  TomorrowListView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 5/4/21.
//

import SwiftUI

struct TomorrowListView: View {
    @StateObject var viewModel = TomorrowListViewModel()
    @Environment(\.scenePhase) var scenePhase
    
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
                            NavigationLink(holiday.name, destination: NationalDayView(holiday: holiday))
                        }
                    }.pullToRefresh(isShowing: $viewModel.isShowing) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            viewModel.getTomorrowsHolidays()
                            self.viewModel.isShowing = false
                        }
                    }
                } else {
                    EmptyState(message: "There was an issue loading Tomorrow's Holidays!\n Try again later")
                }
                NationalHolidayLinkLogo()
                    .alert(item: $viewModel.alertItem) { alertItem in
                        Alert.init(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                    }
                    .onAppear {
                        viewModel.getTomorrowsHolidays()
                    }
                    .onChange(of: scenePhase) { newPhase in
                        if newPhase == .inactive {
                            print("Inactive")
                        } else if newPhase == .active {
                            viewModel.getTomorrowsHolidays()
                            print("Active")
                        } else if newPhase == .background {
                            print("Background")
                        }
                    }
            }
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(2, anchor: .center)
            }
        }
        
    }
}

struct TomorrowListView_Previews: PreviewProvider {
    static var previews: some View {
        TomorrowListView()
    }
}
