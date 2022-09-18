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
        NetworkManager.shared.getTomorrowsHolidayData() { result in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                switch result {
                case .success(let holidays):
                    if holidays.isEmpty {
                        self?.isHolidaysEmpty = true
                    } else {
                        self?.holidays.removeAll()
                        self?.holidays = holidays
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
}
