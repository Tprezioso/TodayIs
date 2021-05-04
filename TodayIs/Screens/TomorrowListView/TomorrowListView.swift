//
//  TomorrowListView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 5/4/21.
//

import SwiftUI

struct TomorrowListView: View {
    @StateObject var viewModel = TomorrowListViewModel()
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
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
            .listStyle(PlainListStyle())
            .navigationTitle("Tomorrow is...")
            Button {
                openURL(URL(string: "https://nationaldaycalendar.com/")!)
            } label: {
                NationalDayLogo()
            }
        }
        .accentColor(.red)
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert.init(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
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

struct TomorrowListView_Previews: PreviewProvider {
    static var previews: some View {
        TomorrowListView()
    }
}
