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
    }

    enum Action: Equatable {
        case onAppear
        case didReceiveHolidays(TaskResult<[Holiday]>)
        case didTapHoliday(Holiday)
    }

    @Dependency(\.currentHolidayClient) var currentHolidayClient
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
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
                return .none
            }
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
                        HolidayWatchListView(holidays: viewStore.holidays)
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

struct HolidayWatchListView: View {
    var holidays: [Holiday]
    
    var body: some View {
        List(holidays) { holiday in
            if holiday.url == "" {
                Text("\(holiday.name)")
                    .font(.title)
                    .fontWeight(.semibold)
            } else {
                let split = holiday.name.components(separatedBy: "–")
                let firstPart = split.last
                let secondPart = split.first
                NavigationLink(destination: HolidayWatchDetailView(holiday: holiday)) {
                    VStack(alignment: .leading) {
                        Text(firstPart ?? "")
                            .font(.body)
                                            }
                }
            }
        }
    }
}
