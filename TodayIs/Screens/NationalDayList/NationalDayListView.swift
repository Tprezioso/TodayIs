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
            VStack {
                NavigationView {
                    List(viewModel.holidays) { holiday in
                        NavigationLink(holiday.name, destination: NationalDayView(holiday: holiday))
                    }.navigationTitle("Today is...")
                    
                }
                .accentColor(.green)
                .alert(item: $viewModel.alertItem) { alertItem in
                    Alert.init(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                }
                .onAppear {
                    viewModel.getHolidays()
                }
                VStack {
                    Text("Powered by:")
                    Image("NationalDayLogo")
                        .resizable()
                        .frame(width: 75, height: 50)
                        .scaledToFit()
                }
                //Image logo to be but in soon
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
