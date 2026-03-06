//
//  SelectedMonthView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/1/22.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct SelectedMonthDomain {
    @ObservableState
    struct State {
        init(dayNumber: Int, month: MonthDomain.State.Months) {
            self.dayNumber = dayNumber
            self.month = month
        }

        var isLoading = false
        var dayNumber: Int
        var month: MonthDomain.State.Months
        var holidays = [Holiday]()
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
                return .run { [state] send in
                    await send(
                        .didReceiveHolidays(
                            Result {
                                try await currentHolidayClient.getMonthsHolidays(state.month.rawValue, state.dayNumber)
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

struct SelectedMonthView: View {
    @Bindable var store: StoreOf<SelectedMonthDomain>
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack {
            if store.isLoading {
                ProgressView().controlSize(.large)
            }
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(store.holidays, id: \.self) { holiday in
                        Button {
                            store.send(.didTapHoliday(holiday))
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
        }
        .navigationTitle("\(store.month.description.month) \(store.dayNumber) Holidays")
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

struct SelectedMonthView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedMonthView(store: .init(initialState: .init(dayNumber: 1, month: .january)) {
            SelectedMonthDomain()
        })
    }
}

//class SelectedMonthViewModel: ObservableObject {
//    @Published var holidayDictionary = [Dictionary<Int, [Holiday]>.Element]()
//    @Published var holiday = [Holiday]()
//    @Published var alertItem: AlertItem?
//    @Published var isLoading = false
//    @Published var isHolidaysEmpty = false
//    
//    func getHolidays(for selectedMonth: String) {
//        isLoading = true
//        NetworkManager.shared.getHolidaysForMonth(selectedMonth) { result in
//            DispatchQueue.main.async { [weak self] in
//                self?.isLoading = false
//                switch result {
//                case .success(let holidays):
//                    if holidays.isEmpty {
//                        self?.isHolidaysEmpty = true
//                    } else {
//                        self?.holiday = holidays
//                        self?.isHolidaysEmpty = false
//                    }
//                case .failure(let error):
//                    switch error {
//                    case .invalidData:
//                        self?.alertItem = AlertContext.invalidData
//                        
//                    case .invalidURL:
//                        self?.alertItem = AlertContext.invalidURL
//                        
//                    case .invalidResponse:
//                        self?.alertItem = AlertContext.invalidResponse
//                        
//                    case .unableToComplete:
//                        self?.alertItem = AlertContext.unableToComplete
//                    }
//                }
//            }
//        }
//    }
//    
//    func sortHolidaysIntoSection(holidays: [Holiday]) -> [Dictionary<Int, [Holiday]>.Element] {
//        let groupByCategory = Dictionary(grouping: holidays) { (device) -> Int in
//            return device.section!
//        }
//        return groupByCategory.sorted{ $0.key < $1.key }
//    }
//}
