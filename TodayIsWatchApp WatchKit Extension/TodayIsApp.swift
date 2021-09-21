//
//  TodayIsApp.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/10/21.
//

import SwiftUI

@main
struct TodayIsApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                TabBarWatchView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
