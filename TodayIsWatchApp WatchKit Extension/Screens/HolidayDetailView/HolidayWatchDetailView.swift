//
//  HolidayWatchDetailView.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/24/21.
//

import SwiftUI

struct HolidayWatchDetailView: View {
    var holiday: Holiday
    var navigationTitle: String {
        var title = ""
        if let range = holiday.name.range(of: "All Day") {
            title = String(holiday.name[range.upperBound..<holiday.name.endIndex])
        }
        return title
    }
    @StateObject var viewModel = HolidayWatchDetailViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                if #available(watchOSApplicationExtension 9.0, *) {
                    ShareLink(item: holiday.url)
                } else {
                    // Fallback on earlier versions
                }
                AsyncImage(url: URL(string: viewModel.detailHoliday.imageURL ?? "")) { image in
                    image
                        .resizable()
                } placeholder: {
                    Image("PlaceholderImage")
                        .resizable()
                }.scaledToFit()
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
        .navigationTitle(navigationTitle)
    }
}

struct HolidayWatchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HolidayWatchDetailView(holiday: Holiday(name: "Tom's Day", url: "http://www.swifttom.com"))
    }
}
