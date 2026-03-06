//
//  TabBarFeature.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/31/23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct TabBarFeature {
    @ObservableState
    struct State {
        var todayViewTab = NationalDayListDomain.State()
        var tomorrowViewTab = NationalDayListDomain.State(isTodayView: false)
        var monthViewTab = MonthDomain.State()
        var selectedTab: Tab = .today
    }

    enum Action {
        case todayViewTab(NationalDayListDomain.Action)
        case reloadTodayView
        case tomorrowViewTab(NationalDayListDomain.Action)
        case monthViewTab(MonthDomain.Action)
        case selectedTabChanged(Tab)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectedTabChanged(tab):
                state.selectedTab = tab
                return .none

            case .todayViewTab, .tomorrowViewTab, .monthViewTab:
                return .none
            
            case .reloadTodayView:
                switch state.selectedTab {
                case .today:
                    return .send(.todayViewTab(.onAppear))
                case .tomorrow:
                    return .send(.tomorrowViewTab(.onAppear))
                case .monthly:
                    return .none
                case .more:
                    return .none
                }
            }
        }

        Scope(state: \.todayViewTab, action: \.todayViewTab) {
            NationalDayListDomain()
        }

        Scope(state: \.tomorrowViewTab, action: \.tomorrowViewTab) {
            NationalDayListDomain()
        }

        Scope(state: \.monthViewTab, action: \.monthViewTab) {
            MonthDomain()
        }
    }
}

enum Tab {
    case today, tomorrow, monthly, more
}

struct TabBarFeatureView: View {
    @Bindable var store: StoreOf<TabBarFeature>

    var body: some View {
        TabView(selection: $store.selectedTab.sending(\.selectedTabChanged)) {
            NavigationStack {
                NationalDayListFeature(
                    store: self.store.scope(
                        state: \.todayViewTab,
                        action: \.todayViewTab
                    )
                )
            }
            .tabItem { Label("Today", systemImage: "calendar") }
            .tag(Tab.today)

            NavigationStack {
                NationalDayListFeature(
                    store: self.store.scope(
                        state: \.tomorrowViewTab,
                        action: \.tomorrowViewTab
                    )
                )
            }
            .tabItem { Label("Tomorrow", systemImage: "calendar.badge.plus") }
            .tag(Tab.tomorrow)

            NavigationStack {
                MonthFeature(
                    store: self.store.scope(
                        state: \.monthViewTab,
                        action: \.monthViewTab
                    )
                )
            }
            .tabItem { Label("Month", systemImage: "calendar.badge.clock") }
            .tag(Tab.monthly)

            NavigationView {
                MoreView()
                    .navigationTitle("More")
            }
            .tabItem {
                Label("More", systemImage: "ellipsis")
            }
            .tag(Tab.more)
        }
        .onTapGesture(count: 2) {
            store.send(.reloadTodayView)
        }
        .tint(.red)
    }
}


#Preview {
    TabBarFeatureView(store: .init(initialState: TabBarFeature.State()) {
        TabBarFeature()
    })
}
