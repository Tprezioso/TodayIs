//
//  TodayIsApp.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 3/8/21.
//

import SwiftUI

@main
struct TodayIsApp: App {
    @Environment(\.scenePhase) var scenePhase
   
    var body: some Scene {
        WindowGroup {
            NavigationStyleView()
                .environmentObject(IconNames())
        }
    }
}


