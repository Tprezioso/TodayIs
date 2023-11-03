//
//  MonthFeature.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 11/2/23.
//

import SwiftUI
import ComposableArchitecture

struct MonthDomain: Reducer {
    struct State: Equatable {
        var holidays = [Holiday]()
        var isLoading = false
        @PresentationState var nationalDayDetailState: NationalDayDomain.State?
    }

    enum Action: Equatable {
        case onAppear
        case didReceiveHolidays(TaskResult<[Holiday]>)
        case nationalDayDetail(PresentationAction<NationalDayDomain.Action>)
        case didTapHoliday(Holiday)
    }

    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none

            case let .didReceiveHolidays(response):
                return .none

            case .nationalDayDetail:
                return .none

            case let .didTapHoliday(holiday):
                return .none
            }
        }
    }
}

struct MonthFeature: View {
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    let store: StoreOf<MonthDomain>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewStore.holidays, id: \.self) { holiday in
                        HolidayView(holiday: holiday)
                            .frame(height: 300)
                    }
                }
            }
        }
    }
}

#Preview {
    MonthFeature(store: .init(initialState: .init()) {
        MonthDomain()
    })
}
