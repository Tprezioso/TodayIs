//
//  NationalDayViewModel.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/11/21.
//

import SwiftUI

final class NationalDayViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    @Published var detailHoliday = DetailHoliday(image: "", description: "")
    
    func getHoliday(url: String) {
        isLoading = true
        NetworkManager.shared.getDetailHoliday(url: url) { [self] result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let detailHoliday):
                    self.detailHoliday = detailHoliday
                    
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
