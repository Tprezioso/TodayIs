//
//  ContentView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 3/8/21.
//

import SwiftUI
import URLImage

struct NationalDayView: View {
    var holiday: Holiday
    @StateObject var viewModel = NationalDayViewModel()
    
    var body: some View {
        VStack {
            Image(viewModel.detailHoliday.image ?? "PlaceholderImage")
                .resizable()
                .scaledToFit()
            Text(viewModel.detailHoliday.description)

            Spacer()
            Button {
                
            } label: {
                Text("Share")
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert.init(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
        .onAppear {
            viewModel.getHoliday(url: holiday.url)
        }
        .navigationTitle(holiday.name)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}
