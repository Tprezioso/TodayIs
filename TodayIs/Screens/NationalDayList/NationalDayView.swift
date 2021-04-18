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
        VStack(spacing: 5) {
            VStack {
                RemoteImage(image: viewModel.image)
                    .scaledToFit()
                    .padding(.bottom)
                Text(viewModel.detailHoliday.description)
            }
            Spacer()
            Button {
                print("Share Button Tapped")
            } label: {
                Text("Share")
            }
            Button {
                print("Calendar button tapped")
            } label: {
                Text("Add to Calendar")
            }
            Spacer()
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
