//
//  TomorrowListViewModel.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 5/4/21.
//

import SwiftUI
import SwiftUIRefresh

final class TomorrowListViewModel: ObservableObject {
    @Published var holidays = [Holiday]()
    @Published var selectedHoliday: Holiday?
    @Published var alertItem: AlertItem?
    @Published var isShowing = false
    @Published var isLoading = false
    @Published var isShowingDetail = false
    @Published var isShowingDetailView = false
    @Published var isHolidaysEmpty = false
    
    func getTomorrowsHolidays() {
        isLoading = true
        NetworkManager.shared.getTomorrowsHolidayData() { [self] result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let holidays):
                    if holidays.isEmpty {
                        isHolidaysEmpty = true
                    } else {
                        self.holidays.removeAll()
                        self.holidays = holidays
                        self.holidays.removeFirst()
                        isHolidaysEmpty = false
                    }
                case .failure(let error):
                    switch error {
                    case .invalidData:
                        alertItem = AlertContext.invalidData
                        
                    case .invalidURL:
                        alertItem = AlertContext.invalidURL
                        
                    case .invalidResponse:
                        alertItem = AlertContext.invalidResponse
                        
                    case .unableToComplete:
                        alertItem = AlertContext.unableToComplete
                    }
                }
            }
        }
    }
}
