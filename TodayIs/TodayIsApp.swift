//
//  TodayIsApp.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 3/8/21.
//

import SwiftUI
import Dependencies
import IssueReporting

@main
struct TodayIsApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        withErrorReporting {
            try prepareDependencies {
                try $0.bootstrapDatabase()
            }
        }
    }
   
    var body: some Scene {
        WindowGroup {
            TabBarFeatureView(store: .init(initialState: .init()) {
                TabBarFeature()
            })
            .environmentObject(IconNames())
        }
    }
}


