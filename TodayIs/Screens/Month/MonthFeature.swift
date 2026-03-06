//
//  MonthFeature.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 11/2/23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct MonthDomain {
    @ObservableState
    struct State {
        var isLoading = false
        var isShowingDays = false
        @Presents var monthDayFeature: DayDomain.State?


       public enum Months: String, Equatable, CaseIterable {
           case january, february, march, april, may, june, july, august, september, october, november, december
           public var description: (month: String, days: Int) {
                switch self {
                case .january:
                    return ("January", 31)
                case .february:
                    return ("February", 28)
                case .march:
                    return ("March", 31)
                case .april:
                    return ("April", 30)
                case .may:
                    return ("May", 31)
                case .june:
                    return ("June", 30)
                case .july:
                    return ("July", 31)
                case .august:
                    return ("August", 31)
                case .september:
                    return ("September", 30)
                case .october:
                    return ("October", 31)
                case .november:
                    return ("November", 30)
                case .december:
                    return ("December", 31)
                }
            }
        }
    }

    enum Action {
        case monthDayFeature(PresentationAction<DayDomain.Action>)
        case didTapHoliday(MonthDomain.State.Months)
    }

    @Dependency(\.currentHolidayClient) var currentHolidayClient
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .didTapHoliday(holiday):
                state.monthDayFeature = .init(day: holiday)
                return .none
            
            case .monthDayFeature:
                return .none
            }
        }
        .ifLet(\.$monthDayFeature, action: \.monthDayFeature) {
            DayDomain()
        }
    }
}

struct MonthFeature: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    @Bindable var store: StoreOf<MonthDomain>
    @State var date = Date()
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 50) {
                ForEach(MonthDomain.State.Months.allCases, id: \.self) { month in
                    Button {
                        store.send(.didTapHoliday(month))
                    } label: {
                        Text(month.description.month)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.accentColor)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                                    .stroke(Color.accentColor, lineWidth: 3)
                            }
                    }

                }
            }.padding(.vertical)
            .navigationTitle("Months")
        }
        .navigationDestination(item: $store.scope(state: \.monthDayFeature, action: \.monthDayFeature)) { store in
            DayFeature(store: store)
        }
    }
}

#Preview {
    MonthFeature(store: .init(initialState: .init()) {
        MonthDomain()
    })
}


//TODO: Make mini Domain


@Reducer
struct DayDomain {
    @ObservableState
    struct State {
        init(day: MonthDomain.State.Months) {
            self.day = day
        }
        var day: MonthDomain.State.Months
        var selectedDay = "1"
        @Presents var selectedMonthState: SelectedMonthDomain.State?
    }

    enum Action {
        case selectedMonth(PresentationAction<SelectedMonthDomain.Action>)
        case didTapDay(Int)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            
            case .selectedMonth:
                return .none

            case let .didTapDay(number):
                state.selectedMonthState = .init(dayNumber: number, month: state.day)
                return .none

            }
        }
        .ifLet(\.$selectedMonthState, action: \.selectedMonth) {
            SelectedMonthDomain()
        }
    }
}

struct DayFeature: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @Bindable var store: StoreOf<DayDomain>
    @State var date = Date()
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(1..<(store.day.description.days) + 1, id: \.self) { day in
                    Button {
                        store.send(.didTapDay(day))
                    } label: {
                        Text("\(day)")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.accentColor)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                                    .stroke(Color.accentColor, lineWidth: 3)
                            }
                    }
                }
            }.navigationTitle("Months")
        }
        .navigationDestination(item: $store.scope(state: \.selectedMonthState, action: \.selectedMonth)) { store in
            SelectedMonthView(store: store)
        }
    }
}

#Preview {
    DayFeature(store: .init(initialState: .init(day: MonthDomain.State.Months.january)) {
        DayDomain()
    })
}
