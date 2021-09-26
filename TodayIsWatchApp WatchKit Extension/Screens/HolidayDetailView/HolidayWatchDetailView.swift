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
//            VStack(spacing: 5) {
                    ScrollView {
                        RemoteImage(image: viewModel.image)
                            .scaledToFit()
                            .padding(.bottom)
                        Text(viewModel.detailHoliday.description)
                            .lineLimit(nil)
                    }
//                VStack(spacing: 20) {
//                    Button {
//                        viewModel.addToCalendar(holidayName: holiday.name)
//                    } label: {
//                        TIButton(title: "Add to Calendar")
//                    }
//
//                    Link(destination: URL(string: "\(holiday.url)")!, label: {
//                        TIButton(title: "Learn More")
//                    })
//                }
//                Spacer()
//            } .toolbar {
//                Button() {
//                    viewModel.shareButton(urlString: holiday.url)
//                } label: {
//                    Image(systemName: "square.and.arrow.up")
//                        .foregroundColor(Color(.systemPink))
//                }
//            }
//            .alert(item: $viewModel.alertItem) { alertItem in
//                Alert.init(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
//            }
            
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
//        }
        
    }
}

struct HolidayWatchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HolidayWatchDetailView(holiday: Holiday(name: "Tom's Day", url: "http://www.swifttom.com"))
    }
}
