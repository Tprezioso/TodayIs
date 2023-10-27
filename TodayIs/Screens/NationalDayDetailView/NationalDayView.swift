//
//  ContentView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 3/8/21.
//

import SwiftUI

struct NationalDayView: View {
    var holiday: Holiday
    var navigationTitle: String {
        var title = ""
        if let range = holiday.name.range(of: "All Day") {
            title = String(holiday.name[range.upperBound..<holiday.name.endIndex])
        } else {
            title = holiday.name
        }
        return title
    }
    @StateObject var viewModel = NationalDayViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                VStack {
                    ScrollView {
                        AsyncImage(url: URL(string: viewModel.detailHoliday.imageURL ?? "")) { image in
                            image
                                .resizable()
                                .cornerRadius(10)
                        } placeholder: {
                            Image("PlaceholderImage")
                                .resizable()
                                .cornerRadius(10)
                        }
                        .scaledToFit()
                        .padding(.bottom)
                        Text(viewModel.detailHoliday.description)
                            .lineLimit(nil)
                        VStack(spacing: 20) {
                            Button {
                                viewModel.addToCalendar(holidayName: holiday.name)
                            } label: {
                                TIButton(title: "Add to Calendar")
                            }
                            
                            Link(destination: URL(string: "\(holiday.url)") ?? URL(string:"https://nationaldaycalendar.com/")!, label: {
                                TIButton(title: "Learn More")
                            })
                        }
                    }
                }
                Spacer()
            } .toolbar {
                if #available(iOS 16.0, *) {
                    ShareLink(item: holiday.url)
                } else {
                    // Fallback on earlier versions
                    Button() {
                        viewModel.shareButton(urlString: holiday.url)
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(Color(.systemPink))
                    }
                }
            }
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert.init(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            }
            
            .onAppear {
                viewModel.getHoliday(url: holiday.url)
                
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(2, anchor: .center)
            }
        }
    }
    
    struct NationalDayView_Previews: PreviewProvider {
        static var previews: some View {
            let holiday = Holiday(name: "Holiday", url: "https://www.swifttom.com")
            NavigationView {
                NationalDayView(holiday: holiday)
            }
        }
    }
}
