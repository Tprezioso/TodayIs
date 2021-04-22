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
    @Published var detailHoliday = DetailHoliday(imageURL: "", description: "")
    @Published var imageLoader = ImageLoader()
    @Published var image: Image? = nil
    
    func getHoliday(url: String) {
        isLoading = true
        NetworkManager.shared.getDetailHoliday(url: url) { [self] result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let detailHoliday):
                    self.detailHoliday = detailHoliday
                    load(fromURLString: detailHoliday.imageURL)
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
    
    func load(fromURLString urlString: String) {
        NetworkManager.shared.downloadImage(fromURLString: urlString) { uiImage in
            guard let uiImage = uiImage else { return }
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }
    }
    
    func shareButton(urlString: String) {
            let url = URL(string: urlString)
            let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)

            UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
    }

}
