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

        enum Months: String, CaseIterable, CustomStringConvertible, Equatable {
            case january, february, march, april, may, june, july, august, september, october, november, december
            var description: String {
                switch self {
                case .january:
                    return "January"
                case .february:
                    return "February"
                case .march:
                    return "March"
                case .april:
                    return "April"
                case .may:
                    return "May"
                case .june:
                    return "June"
                case .july:
                    return "July"
                case .august:
                    return "August"
                case .september:
                    return "September"
                case .october:
                    return "October"
                case .november:
                    return "November"
                case .december:
                    return "December"
                }
            }
        }
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
                return .run { send in
                    let _ = try await currentHolidayClient.getMonthsHolidays("january")
                }
//                return .none

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
    @State var date = Date()
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            DatePicker("Picker", selection: $date)
                .datePickerStyle(.wheel)
//                .navigationDestination(isPresented: <#T##Binding<Bool>#>, destination: <#T##() -> View#>)
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 20) {
//                    ForEach(MonthDomain.State.Months.allCases, id: \.self) { month in
//                        Text(month.description)
//                    }
//                }
//            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    MonthFeature(store: .init(initialState: .init()) {
        MonthDomain()
    })
}
