//
//  TodayWatchView.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/10/21.
//

import SwiftUI
import ComposableArchitecture

struct HolidayWatchDomain: Reducer {
    struct State: Equatable {
        init(isTodayView: Bool = true) {
            self.isTodayView = isTodayView
        }
        var holidays = [Holiday]()
        var isTodayView: Bool
        @BindingState var isLoading = false
        @PresentationState var holidayDetailState: HolidayDetailDomain.State?
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case didReceiveHolidays(TaskResult<[Holiday]>)
        case holidayDetail(PresentationAction<HolidayDetailDomain.Action>)
        case didTapHoliday(Holiday)
    }

    @Dependency(\.currentHolidayClient) var currentHolidayClient
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .onAppear:
                return .run { [isToday = state.isTodayView] send in
                    let response = try await currentHolidayClient.getCurrentHoliday(isToday)
                    return await send(.didReceiveHolidays(TaskResult(response)))
                } catch: { error, send in
                    //TODO: - Handle error
                }

            case let .didReceiveHolidays(response):
                switch response {
                case let .success(holidays):
                    state.isLoading = false
                    state.holidays = holidays
                    return .none

                case .failure:
                    state.isLoading = false
                    return .none

                }
                
            case let .didTapHoliday(holiday):
                state.holidayDetailState = .init(holiday: holiday)
                return .none

            case .holidayDetail:
                return .none
            }
        }
        .ifLet(\.$holidayDetailState, action: /Action.holidayDetail) {
            HolidayDetailDomain()
        }
    }
}

struct HolidayWatchView: View {
    let store: StoreOf<HolidayWatchDomain>
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                VStack {
                    if !viewStore.holidays.isEmpty {
                        List(viewStore.holidays) { holiday in
                            Button {
                                viewStore.send(.didTapHoliday(holiday))
                            } label: {
                                Text("\(holiday.name)")
                                    .font(.body)
                                    .fontWeight(.semibold)
                            }
                        }
//                         HolidayWatchListView(holidays: viewStore.holidays)
                    } else {
                        EmptyState(message: "There was an issue loading Today's Holidays!\n Try again later")
                    }
                }
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .inactive {
                        print("Inactive")
                    } else if newPhase == .active {
                        viewStore.send(.onAppear)
                    } else if newPhase == .background {
                        print("Background")
                    }
                }
                .navigationTitle("Today Is....")
//                .alert(item: $viewModel.alertItem) { alertItem in
//                    Alert.init(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
//                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                if viewStore.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .scaleEffect(2, anchor: .center)
                }
            }
            .navigationDestination(store: self.store.scope(state: \.$holidayDetailState, action: { .holidayDetail($0) })) { store in
                HolidayWatchDetailView(store: store)
            }
        }
    }
}

struct TodayWatchView_Previews: PreviewProvider {
    static var previews: some View {
        HolidayWatchView(store: .init(initialState: .init()) {
            HolidayWatchDomain()
        })
    }
}

//struct HolidayWatchListView: View {
//    var holidays: [Holiday]
//    
//    var body: some View {
//        List(holidays) { holiday in
//            if holiday.url == "" {
//                Text("\(holiday.name)")
//                    .font(.title)
//                    .fontWeight(.semibold)
//            } else {
//                let split = holiday.name.components(separatedBy: "–")
//                let firstPart = split.last
//                let secondPart = split.first
//                NavigationLink(destination: HolidayWatchDetailView(holiday: holiday)) {
//                    VStack(alignment: .leading) {
//                        Text(firstPart ?? "")
//                            .font(.body)
//                                            }
//                }
//            }
//        }
//    }
//}
