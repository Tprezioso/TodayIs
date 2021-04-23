//
//  NationalDayViewModel.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/11/21.
//

import SwiftUI
import EventKit

final class NationalDayViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    @Published var detailHoliday = DetailHoliday(imageURL: "", description: "")
    @Published var imageLoader = ImageLoader()
    @Published var image: Image? = nil
    @Published var eventStore = EKEventStore()
    
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
    
    func addToCalendar() {
        switch EKEventStore.authorizationStatus(for: .event) {
            case .authorized:
                insertEvent(store: eventStore)
                case .denied:
                    print("Access denied")
                case .notDetermined:
                // 3
                    eventStore.requestAccess(to: .event, completion:
                      {[weak self] (granted: Bool, error: Error?) -> Void in
                          if granted {
                            self!.insertEvent(store: self!.eventStore)
                          } else {
                                print("Access denied")
                          }
                    })
                    default:
                        print("Case default")
            }
    }

    func insertEvent(store: EKEventStore) {
        // 1
        let calendars = store.calendars(for: .event)
            
        for calendar in calendars {
            // 2
            if calendar.title == "Calendar" {
                // 3
                let startDate = Date()
                // 2 hours
                let endDate = startDate.addingTimeInterval(2 * 60 * 60)
                    
                // 4
                let event = EKEvent(eventStore: store)
                event.calendar = calendar
                    
                event.title = "New Meeting"
                event.startDate = startDate
                event.endDate = endDate
                    
                // 5
                do {
                    try store.save(event, span: .thisEvent)
                }
                catch {
                   print("Error saving event in calendar")             }
                }
        }
    }

}
