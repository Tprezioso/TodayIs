//
//  NationalDayDetailFeature.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/24/23.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct NationalDayDomain {
    @ObservableState
    struct State {
        init(holiday: Holiday) {
            self.holiday = holiday
        }
        var holiday: Holiday
        var detailHoliday: DetailHoliday?
        var isLoading = false
    }

    enum Action {
        case onAppear
        case receivedDetailHoliday(Result<DetailHoliday, any Error>)
    }

    @Dependency(\.currentHolidayClient) var currentHolidayClient
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { [url = state.holiday.url] send in
                    await send(
                        .receivedDetailHoliday(
                            Result {
                                try await currentHolidayClient.getCurrentHolidayDetail(url)
                            }
                        )
                    )
                }
            case let .receivedDetailHoliday(result):
                state.isLoading = false
                switch result {
                case let .success(detailHoliday):
                    state.detailHoliday = detailHoliday
                    return .none

                case .failure:
                    return .none
                }
            }
        }
    }
}

struct NationalDayDetailFeature: View {
    let store: StoreOf<NationalDayDomain>
    
    var body: some View {
        ScrollView {
            if store.isLoading {
                ProgressView().controlSize(.large)
            }
            AsyncImage(url: URL(string: store.holiday.imageURL ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else if phase.error != nil {
                    Image(systemName: "PlaceholderImage")
                } else {
                    ProgressView().progressViewStyle(.circular)
                        .controlSize(.large)
                }
            }
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(store.holiday.holidayDescription ?? "")
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.leading)
                    Text(store.detailHoliday?.description ?? "")
                        .font(.headline)
                        .bold()
                }
                Link(destination: URL(string: store.holiday.url)!) {
                    TIButton(title: "Learn More")
                }
                ShareLink(item: URL(string: store.holiday.url)!) {
                    TIButton(title: "Share")
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle(store.holiday.name)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    NationalDayDetailFeature(store: .init(initialState: .init(holiday: .init(name: "National Pizza Day", month: 2, day: 9, url: "https://nationaltoday.com/national-pizza-day/", holidayDescription: "Celebrate America's favorite food"))) {
        NationalDayDomain()
    })
}
