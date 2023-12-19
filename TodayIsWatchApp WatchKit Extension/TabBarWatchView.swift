//
//  TabBarWatchView.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/10/21.
//

import SwiftUI
import ComposableArchitecture


public struct TabBarFeature: Reducer {
   public struct State: Equatable {
//       var todayViewTab = NationalDayListDomain.State()
//       var tomorrowViewTab = NationalDayListDomain.State(isTodayView: false)
    }

    public enum Action: Equatable {

    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}

struct TabBarWatchView: View {
    @State var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                HolidayWatchView(store: .init(initialState: .init()) {
                    HolidayWatchDomain()
                })
                    .tag(0)
            }
            NavigationView {
                HolidayWatchView(store: .init(initialState: .init(isTodayView: false)) {
                    HolidayWatchDomain()
                })
                    .tag(1)
            }
        }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}

struct TabBarWatchView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarWatchView()
    }
}
