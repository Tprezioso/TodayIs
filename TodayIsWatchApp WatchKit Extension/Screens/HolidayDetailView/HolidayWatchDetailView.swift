//
//  HolidayWatchDetailView.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/24/21.
//

import SwiftUI

struct HolidayWatchDetailView: View {
    var holiday: Holiday
    @StateObject var viewModel = HolidayWatchDetailViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                RemoteImage(image: viewModel.image)
                    .scaledToFit()
                    .padding(.bottom)
                Text(viewModel.detailHoliday.description)
                    .lineLimit(nil)
            }
            .onAppear {
                viewModel.getHoliday(url: holiday.url)
            }
            .navigationTitle(holiday.name)
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(2, anchor: .center)
            }
        }
    }
}

struct HolidayWatchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HolidayWatchDetailView(holiday: Holiday(name: "Tom's Day", url: "http://www.swifttom.com"))
    }
}
