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
        var monthDay: Months?
        @BindingState var isShowingDays = false
        @BindingState var selectedDay = "1"
        @PresentationState var nationalDayDetailState: NationalDayDomain.State?


       public enum Months: String, Equatable, CaseIterable {
//            var description: (str)

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

    enum Action: Equatable {
//        case binding(BindingAction<State>)
        case nationalDayDetail(PresentationAction<NationalDayDomain.Action>)
        case didTapHoliday(MonthDomain.State.Months)
        case didTapDay(String)
    }

    @Dependency(\.currentHolidayClient) var currentHolidayClient
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .nationalDayDetail:
                return .none

            case let .didTapHoliday(holiday):
                state.monthDay = holiday
                return .none
            
            case let .didTapDay(day):
                state.selectedDay = day
                print(day)
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
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(MonthDomain.State.Months.allCases, id: \.self) { month in
                        
                        Button {
                            viewStore.send(.didTapHoliday(month))
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
                        .padding()
                    }
                }.navigationTitle("Months")
            }
//            .navigationDestination(store: .init(initialState: .init(), reducer: {
//                MonthDomain()
//            }), destination: MonthDayFeature(store: viewStore))
        }
    }
}

#Preview {
    MonthFeature(store: .init(initialState: .init()) {
        MonthDomain()
    })
}


//TODO: Make mini Domain

struct MonthDayFeature: View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let store: StoreOf<MonthDomain>
    @State var date = Date()
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(1..<(viewStore.monthDay?.description.days ?? 30) + 1) { day in
                            Button {
                                viewStore.send(.didTapDay("\(day)"))
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
        }
    }
}

#Preview {
    MonthDayFeature(store: .init(initialState: .init()) {
        MonthDomain()
    })
}
