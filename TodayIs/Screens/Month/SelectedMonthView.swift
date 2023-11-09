//
//  SelectedMonthView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/1/22.
//

import SwiftUI
import ComposableArchitecture

struct SelectedMonthDomain: Reducer {
    struct State: Equatable {
        init(dayNumber: Int, month: MonthDomain.State.Months) {
            self.dayNumber = dayNumber
            self.month = month
        }
        // TODO: - Need to add loading
        var dayNumber: Int
        var month: MonthDomain.State.Months
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
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [state] send in
                    let response = try await currentHolidayClient.getMonthsHolidays(state.month.rawValue, state.dayNumber)
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

struct SelectedMonthView: View {
    let store: StoreOf<SelectedMonthDomain>
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
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
            .navigationTitle("\(viewStore.month.description.month) \(viewStore.dayNumber) Holidays")
            .onAppear { viewStore.send(.onAppear) }
            .foregroundColor(.white)
            .padding()
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
