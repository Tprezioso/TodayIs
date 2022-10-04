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
        List {
            ForEach(viewModel.holidayDictionary, id: \.key) {  section in
                Section {
                    ForEach(section.value, id: \.self) { holiday in
                    NavigationLink(destination: NationalDayView(holiday: holiday)) {
                        Text(holiday.name)
                            .font(.title2)
                    }
                }
                } header: {
                    Text("\(section.key)")
                        .font(.headline)
                }
            }
        }.onAppear {
            viewModel.getHolidays(for: selectedMonth)
        }
        .navigationTitle(selectedMonth)
    }
}

struct SelectedMonthView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedMonthView(selectedMonth: "June")
    }
}

class SelectedMonthViewModel: ObservableObject {
    @Published var holidays = [Holiday]()
    @Published var holidayDictionary = [Dictionary<Int, [Holiday]>.Element]()
    @Published var selectedHoliday: Holiday?
    @Published var alertItem: AlertItem?
    @Published var isShowing = false
    @Published var isLoading = false
    @Published var isShowingDetail = false
    @Published var isShowingDetailView = false
    @Published var isHolidaysEmpty = false
    
    func getHolidays(for selectedMonth: String) {
        isLoading = true
        NetworkManager.shared.getHolidaysforMonth(selectedMonth) { result in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                switch result {
                case .success(let holidays):
                    if holidays.isEmpty {
                        self?.isHolidaysEmpty = true
                    } else {
                        self?.holidays.removeAll()
                        self?.holidays = holidays.sorted { $0.section! < $1.section!
                        }
                        self?.holidayDictionary = (self?.sortHolidaysIntoSection(holidays: self!.holidays))!
                        self?.holidays.removeFirst()
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
