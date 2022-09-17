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
        VStack {
            Text(holiday.name)
                .lineLimit(3)
                    
            ScrollView {
                if #available(watchOSApplicationExtension 9.0, *) {
                    ShareLink(item: holiday.url)
                } else {
                    // Fallback on earlier versions
                }
                RemoteImage(image: viewModel.image)
                    .scaledToFit()
                    .padding(.bottom)
                Text(viewModel.detailHoliday.description)
                    .lineLimit(nil)
            }
            .onAppear {
                viewModel.getHoliday(url: holiday.url)
            }
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
