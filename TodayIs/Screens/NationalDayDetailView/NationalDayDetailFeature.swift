//
//  NationalDayDetailFeature.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/24/23.
//

import SwiftUI
import ComposableArchitecture

struct NationalDayDomain: Reducer {
    struct State: Equatable {
        init(holiday: Holiday) {
            self.holiday = holiday
        }
        var holiday: Holiday
        var detailHoliday: DetailHoliday?
        @BindingState var isLoading = false
    }

    enum Action: Equatable {
        case onAppear
        case receivedDetailHoliday(TaskResult<DetailHoliday>)
    }

    @Dependency(\.currentHolidayClient) var currentHolidayClient
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { [url = state.holiday.url] send in
                    let response = try await currentHolidayClient.getCurrentHolidayDetail(url)
                    await send(.receivedDetailHoliday(TaskResult(response)))
                }
            case let .receivedDetailHoliday(response):
                switch response {
                case let .success(detailHoliday):
                    state.isLoading = false
                    state.detailHoliday = detailHoliday
                    return .none

                case .failure:
                    state.isLoading = false
                    return .none
                }

            }
        }
    }
}

struct NationalDayDetailFeature: View {
    let store: StoreOf<NationalDayDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                if viewStore.isLoading {
                    ProgressView().controlSize(.large)
                }
                AsyncImage(url: URL(string: viewStore.holiday.imageURL ?? "")) { phase in
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
                        Text(viewStore.holiday.description ?? "")
                            .font(.title3)
                            .bold()
                            .multilineTextAlignment(.leading)
                        Text(viewStore.detailHoliday?.description ?? "")
                            .font(.headline)
                            .bold()
                    }
                    Link(destination: URL(string: viewStore.holiday.url)!) {
                        TIButton(title: "Learn More")
                    }
                    ShareLink(item: URL(string: viewStore.holiday.url)!) {
                        TIButton(title: "Share")
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle(viewStore.holiday.name)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    NationalDayDetailFeature(store: .init(initialState: .init(holiday: .init(name: "Test", url: "https://www.google.com"))) {
        NationalDayDomain()
    })
}
