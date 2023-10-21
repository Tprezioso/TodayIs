//
//  NationalDayListFeature.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/18/23.
//

import SwiftUI
import ComposableArchitecture

struct NationalDayListDomain: Reducer {
    struct State: Equatable {
        var holidays = [Holiday]()
        var isLoading = false
    }

    enum Action: Equatable {
        case onAppear
        case didRecieveHolidays(TaskResult<[Holiday]>)
    }

    @Dependency(\.currentHolidayClient) var currentHolidayClient
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let response = try await currentHolidayClient.getCurrentHoliday()
                    return await send(.didRecieveHolidays(TaskResult(response)))
                }
            case let .didRecieveHolidays(holidays):
                switch holidays {
                case .success(_):
                    return .none

                case .failure(_):
                    return .none

                }
            }
        }
    }
}

struct NationalDayListFeature: View {
    let store: StoreOf<NationalDayListDomain>
        @Environment(\.scenePhase) private var scenePhase
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

        var body: some View {
            WithViewStore(store, observe: { $0 }) { viewStore in
                NavigationStack {
                    VStack {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(viewStore.holidays, id: \.self) { holiday in
                                    Text(holiday.name)
                                }
                            }
                        }
                        Spacer()
                    }
                    .navigationTitle("")
                    .onAppear { viewStore.send(.onAppear) }
                    .foregroundColor(.white)
                    .padding()
                }
//                .alert(store: self.store.scope(state: \.$alert, action: {.alert($0)}))
                .onChange(of: scenePhase) {
                    switch scenePhase {
                    case .background:
                        break
                    case .inactive:
                        break
                    case .active:
                        viewStore.send(.onAppear)
                    @unknown default:
                        break
                    }
                }
            }
        }
}

#Preview {
    NationalDayListFeature(store: .init(initialState: .init()) {
        NationalDayListDomain()
    })
}
