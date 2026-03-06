//
//  NationalDayListFeature.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/18/23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct NationalDayListDomain {
    @ObservableState
    struct State {
        init(isTodayView: Bool = true) {
            self.isTodayView = isTodayView
        }

        var isTodayView: Bool
        var holidays = [Holiday]()
        var isLoading = false
        @Presents var nationalDayDetailState: NationalDayDomain.State?
    }

    enum Action {
        case onAppear
        case didReceiveHolidays(Result<[Holiday], any Error>)
        case nationalDayDetail(PresentationAction<NationalDayDomain.Action>)
        case didTapHoliday(Holiday)
    }

    @Dependency(\.currentHolidayClient) var currentHolidayClient
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { [isToday = state.isTodayView] send in
                    await send(
                        .didReceiveHolidays(
                            Result {
                                try await currentHolidayClient.getCurrentHoliday(isToday)
                            }
                        )
                    )
                }

            case let .didReceiveHolidays(result):
                state.isLoading = false
                switch result {
                case let .success(holidays):
                    state.holidays = holidays
                    return .none

                case .failure:
                    return .none
                }
                
            case .nationalDayDetail:
                return .none

            case let .didTapHoliday(holiday):
                state.nationalDayDetailState = .init(holiday: holiday)
                return .none
            }
        }
        .ifLet(\.$nationalDayDetailState, action: \.nationalDayDetail) {
            NationalDayDomain()
        }
    }
}

struct NationalDayListFeature: View {
    @Bindable var store: StoreOf<NationalDayListDomain>
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack {
            ScrollViewReader { value in
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(store.holidays, id: \.self) { holiday in
                            Button {
                                store.send(.didTapHoliday(holiday))
                            } label: {
                                HolidayView(holiday: holiday)
                            }
                            .id(holiday)
                            .scrollTransition(.interactive, axis: .vertical) { view, phase in
                                view.opacity(phase.value > 0 ? 0.1 : 1)
                                    .blur(radius: phase.value > 0 ? 5 : 0)
                            }
                        }
                    }.scrollTargetLayout()
                }.scrollTargetBehavior(.viewAligned)
                    .onChange(of: store.holidays) {
                        withAnimation {
                            value.scrollTo(store.holidays.first, anchor: .top)
                        }
                    }
            }.refreshable {
                await store.send(.onAppear).finish()
            }
        }
        .navigationTitle(store.isTodayView ? "Today's Holidays" : "Tomorrow's Holidays")
        .onAppear { store.send(.onAppear) }
        .foregroundColor(.white)
        .padding()
        .navigationDestination(item: $store.scope(state: \.nationalDayDetailState, action: \.nationalDayDetail)) { store in
            NationalDayDetailFeature(store: store)
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active:
                store.send(.onAppear)
            default:
                break
            }
        }
    }
}

#Preview {
    NationalDayListFeature(store: .init(initialState: .init()) {
        NationalDayListDomain()
    })
}

