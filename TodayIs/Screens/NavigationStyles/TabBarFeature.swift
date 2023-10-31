//
//  TabBarFeature.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/31/23.
//

import SwiftUI
import ComposableArchitecture

struct TabBarFeature: Reducer {
    struct State: Equatable {
        var currentTowerTab = NationalDayListDomain.State()
//        var monthlyTowerTab = MonthlyTowerLightsFeature.State()
        var selectedTab: Tab = .current
    }

    enum Action: Equatable {
        case currentTowerTab(NationalDayListDomain.Action)
//        case monthlyTowerTab(MonthlyTowerLightsFeature.Action)
        case selectedTabChanged(Tab)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectedTabChanged(tab):
                state.selectedTab = tab
                return .none

            case .currentTowerTab://, .monthlyTowerTab:
                return .none
            }
        }

        Scope(state: \.currentTowerTab, action: /Action.currentTowerTab) {
            NationalDayListDomain()
        }
//        Scope(state: \.monthlyTowerTab, action: /Action.monthlyTowerTab) {
//            MonthlyTowerLightsFeature()
//        }
    }
}

enum Tab {
    case current, monthly
}

struct TabBarFeatureView: View {
    let store: StoreOf<TabBarFeature>

    var body: some View {
        WithViewStore(self.store, observe: \.selectedTab) { viewStore in
            TabView(selection: viewStore.binding(send: TabBarFeature.Action.selectedTabChanged)) {
                NationalDayListFeature(
                    store: self.store.scope(
                        state: \.currentTowerTab,
                        action: TabBarFeature.Action.currentTowerTab
                    )
                )
                .tabItem { Label("Today", systemImage: "calendar") }
                .tag(Tab.current)

//                MonthlyTowerLightsView(
//                    store: self.store.scope(
//                        state: \.monthlyTowerTab,
//                        action: TabBarFeature.Action.monthlyTowerTab
//                    )
//                )
//                .tabItem { Label("Monthly", systemImage: "calendar") }
//                .tag(Tab.monthly)
            }.tint(.red)
        }
    }
}


#Preview {
    TabBarFeatureView(store: .init(initialState: TabBarFeature.State()) {
        TabBarFeature()
    })
}
