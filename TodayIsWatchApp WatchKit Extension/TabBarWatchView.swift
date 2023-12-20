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
       var todayViewTab = HolidayWatchDomain.State()
       var tomorrowViewTab = HolidayWatchDomain.State(isTodayView: false)
       var selectedTab: Tab = .today
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

public enum Tab {
    case today, tomorrow, monthly, more
}

struct TabBarWatchView: View {
    let store: StoreOf<TabBarFeature>
    @State var selection = 0
    
    var body: some View {
        WithViewStore(self.store, observe: \.selectedTab) { viewStore in
            TabView(selection: $selection) {
                NavigationStack {
                    HolidayWatchView(store: .init(initialState: .init()) {
                        HolidayWatchDomain()
                    })
                    .tag(Tab.today)
                }
                NavigationStack {
                    HolidayWatchView(store: .init(initialState: .init(isTodayView: false)) {
                        HolidayWatchDomain()
                    })
                    .tag(Tab.tomorrow)
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
    }
}

struct TabBarWatchView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarWatchView(store: .init(initialState: .init()) {
            TabBarFeature()
        })
    }
}
