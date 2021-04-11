//
//  NationalDayListViewModel.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/11/21.
//

import SwiftUI

final class NationalDayListViewModel: ObservableObject {
    @Published var holidays = [Holiday]()
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    @Published var isShowingDetail = false
    @Published var isShowingDetailView = false
    @Published var selectedHoliday: Holiday?

    func getHolidays() {
        isLoading = true
        NetworkManager.shared.getHolidayData { [self] result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let holidays):
                    self.holidays = holidays
                
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
