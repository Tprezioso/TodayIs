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
        init(isTodayView: Bool = true) {
            self.isTodayView = isTodayView
        }
        // TODO: - Need to add loading
        var isTodayView: Bool
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

    @Dependency(\.currentHolidayClient) var currentHolidayClient
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .run { [isToday = state.isTodayView] send in
                    let response = try await currentHolidayClient.getCurrentHoliday(isToday)
                    return await send(.didReceiveHolidays(TaskResult(response)))
                }
            case let .didReceiveHolidays(holidays):
                switch holidays {
                case let .success(holidays):
                    state.holidays = holidays
                    return .none

                case .failure(_):
                    return .none

                }
            case .nationalDayDetail:
                return .none
            
            case let .didTapHoliday(holiday):
                state.nationalDayDetailState = .init(holiday: holiday)
                return .none
            }
        }
        .ifLet(\.$nationalDayDetailState , action: /Action.nationalDayDetail) {
            NationalDayDomain()
        }
    }
}

struct NationalDayListFeature: View {
    let store: StoreOf<NationalDayListDomain>
        @Environment(\.scenePhase) private var scenePhase

        var body: some View {
            WithViewStore(store, observe: { $0 }) { viewStore in
//                NavigationStack {
                    VStack {
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(viewStore.holidays, id: \.self) { holiday in
                                    Button {
                                        viewStore.send(.didTapHoliday(holiday))
                                    } label: {
                                        HolidayView(holiday: holiday)
                                    }
                                    .scrollTransition(.interactive, axis: .vertical) { view, phase in
                                        view.opacity(phase.value > 0 ? 0.1 : 1)
                                            .blur(radius: phase.value > 0 ? 5 : 0)
                                    }
                                }
                            }.scrollTargetLayout()
                        }.scrollTargetBehavior(.viewAligned)
                        Spacer()
                    }
                    .navigationTitle(viewStore.isTodayView ? "Today's Holidays" : "Tomorrow's Holidays")
                    .onAppear { viewStore.send(.onAppear) }
                    .foregroundColor(.white)
                    .padding()
//                }
                .navigationDestination(store: self.store.scope(state: \.$nationalDayDetailState, action: { .nationalDayDetail($0) })) { store in
                    NationalDayDetailFeature(store: store)
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

