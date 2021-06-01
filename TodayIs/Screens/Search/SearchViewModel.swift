//
//  SearchViewModel.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/1/21.
//

import SwiftUI

final class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var holidays = [Holiday]()
    @Published var selectedHoliday: Holiday?
    @Published var alertItem: AlertItem?
    @Published var isShowing = false
    @Published var isLoading = false
    @Published var isShowingDetail = false
    @Published var isShowingDetailView = false
    
    func getHolidays(searchDate: String) {
        isLoading = true
        NetworkManager.shared.searchForHoliday(searchTerm: searchDate.condenseWhitespace()) { [self] result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let holidays):
                    self.holidays.removeAll()
                    self.holidays = holidays
                    print(self.holidays)
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
