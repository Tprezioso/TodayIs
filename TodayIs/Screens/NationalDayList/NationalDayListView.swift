//
//  NationalDayListView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/8/21.
//

import SwiftUI

struct NationalDayListView: View {
    @StateObject var viewModel = NationalDayListViewModel()
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ZStack {
            NavigationView {
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
                            viewModel.getHolidays()
                            self.viewModel.isShowing = false
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink("Tomorrow", destination: TomorrowListView())

                        }
                            
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Today is...")
                    Button {
                        openURL(URL(string: "https://nationaldaycalendar.com/")!)
                    } label: {
                        NationalDayLogo()
                    }
                }
            }
            .accentColor(.red)
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


struct NationalDayListView_Previews: PreviewProvider {
    static var previews: some View {
        NationalDayListView()
    }
}
