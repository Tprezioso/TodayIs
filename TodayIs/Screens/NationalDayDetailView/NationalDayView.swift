//
//  ContentView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 3/8/21.
//

import SwiftUI

struct NationalDayView: View {
    var holiday: Holiday
    @StateObject var viewModel = NationalDayViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                VStack {
                    RemoteImage(image: viewModel.image)
                        .scaledToFit()
                        .padding(.bottom)
                    Text(viewModel.detailHoliday.description)
                }
                VStack(spacing: 20) {
                    Button {
                        viewModel.shareButton(urlString: holiday.url)
                    } label: {
                        TIButton(title: "Share")
                    }
                    
                    Button {
                        viewModel.addToCalendar(holidayName: holiday.name)
                    } label: {
                        TIButton(title: "Add to Calendar")
                    }
                }.padding()
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
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(2, anchor: .center)
            }
        }
    }
    
}
