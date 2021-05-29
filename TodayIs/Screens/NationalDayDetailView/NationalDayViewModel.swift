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
    
    func addToCalendar(holidayName: String) {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            insertEvent(store: eventStore, holidayName: holidayName)
            alertItem = AlertContext.savedHoliday
        case .denied:
            //TODO: - added new error handling
            alertItem = AlertContext.invalidData
        case .notDetermined:
            eventStore.requestAccess(to: .event) { [weak self] (granted: Bool, error: Error?) -> Void in
                if granted {
                    self!.insertEvent(store: self!.eventStore,holidayName: holidayName)
                    self!.alertItem = AlertContext.savedHoliday
                    
                } else {
                    self!.alertItem = AlertContext.calendarAccessDenied
                }
            }
        default:
            print("Case default")
        }
    }
    
    func insertEvent(store: EKEventStore, holidayName: String) {
        let calendars = store.calendars(for: .event)
        
        for calendar in calendars {
            if calendar.title == "Calendar" {
                let startDate = Date()
                let endDate = Date()
                let event = EKEvent(eventStore: store)
                event.calendar = calendar
                event.title = holidayName
                event.startDate = startDate
                event.endDate = endDate
                event.isAllDay = true
                do {
                    try store.save(event, span: .thisEvent)
                }
                catch {
                    alertItem = AlertContext.savedError
                }
            }
        }
    }
    
}
