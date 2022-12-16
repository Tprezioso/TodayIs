//
//  SelectedMonthView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/1/22.
//

import SwiftUI

struct SelectedMonthView: View {
    var selectedMonth: String
    @StateObject var viewModel = SelectedMonthViewModel()
    
    var body: some View {
        ZStack {
            if !viewModel.isHolidaysEmpty {
                List {
//                    ForEach(viewModel.holidayDictionary, id: \.key) { section in
//                        Section {
                    ForEach(viewModel.holiday, id: \.self) { holiday in
                                NavigationLink(destination: NationalDayView(holiday: holiday)) {
                                    Text(holiday.name)
                                        .font(.title2)
                                }
                            }
//                        } header: {
//                            Text("\(section.key)")
//                                .font(.headline)
//                        }
//                    }
                }.alert(item: $viewModel.alertItem) { alertItem in
                    Alert.init(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                }
                .onAppear {
                    viewModel.getHolidays(for: selectedMonth)
                }
                .navigationTitle(selectedMonth)
            } else {
                EmptyState(message: "There was an issue loading Today's Holidays!\n Try again later")
            }
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
                    .scaleEffect(2, anchor: .center)
            }
        }
    }
}

struct SelectedMonthView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedMonthView(selectedMonth: "June")
    }
}

class SelectedMonthViewModel: ObservableObject {
    @Published var holidayDictionary = [Dictionary<Int, [Holiday]>.Element]()
    @Published var holiday = [Holiday]()
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    @Published var isHolidaysEmpty = false
    
    func getHolidays(for selectedMonth: String) {
        isLoading = true
        NetworkManager.shared.getHolidaysForMonth(selectedMonth) { result in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                switch result {
                case .success(let holidays):
                    if holidays.isEmpty {
                        self?.isHolidaysEmpty = true
                    } else {
                        self?.holiday = holidays
//                        self?.holidayDictionary = (self?.sortHolidaysIntoSection(holidays: holidays))!
                        
                        self?.isHolidaysEmpty = false
                    }
                case .failure(let error):
                    switch error {
                    case .invalidData:
                        self?.alertItem = AlertContext.invalidData
                        
                    case .invalidURL:
                        self?.alertItem = AlertContext.invalidURL
                        
                    case .invalidResponse:
                        self?.alertItem = AlertContext.invalidResponse
                        
                    case .unableToComplete:
                        self?.alertItem = AlertContext.unableToComplete
                    }
                }
            }
        }
    }
    
    func sortHolidaysIntoSection(holidays: [Holiday]) -> [Dictionary<Int, [Holiday]>.Element] {
        let groupByCategory = Dictionary(grouping: holidays) { (device) -> Int in
            return device.section!
        }
        return groupByCategory.sorted{ $0.key < $1.key }
    }
    
}
