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
//    @StateObject var viewModel = NationalDayListViewModel()
   
    var body: some Scene {
        WindowGroup {
            NationalDayListView()
        }
//        .onChange(of: scenePhase) { newScenePhase in
//              switch newScenePhase {
//              case .active:
//                print("App is active")
//                viewModel.getHolidays()
//              case .inactive:
//                print("App is inactive")
//              case .background:
//                print("App is in background")
//              @unknown default:
//                print("Oh - interesting: I received an unexpected new value.")
//              }
//            }
    }
}
