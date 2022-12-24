//
//  TomorrowWatchViewModel.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/24/21.
//

import SwiftUI

final class TomorrowWatchViewModel: ObservableObject {
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
        NetworkManager.shared.getTomorrowsHolidayData() { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let holidays):
                    if holidays.isEmpty {
                        self?.isHolidaysEmpty = true
                    } else {
                        self?.holidays.removeAll()
                        self?.holidays = holidays
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
}
