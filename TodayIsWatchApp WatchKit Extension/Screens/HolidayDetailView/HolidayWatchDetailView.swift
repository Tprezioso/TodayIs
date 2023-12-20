//
//  HolidayWatchDetailView.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/24/21.
//

import SwiftUI
import ComposableArchitecture

public struct HolidayDetailDomain: Reducer {
    public struct State: Equatable {
        init(holiday: Holiday) {
            self.holiday = holiday
        }
        var holiday: Holiday
        var detailHoliday: DetailHoliday?
        @BindingState var isLoading = false
    }

    public enum Action: Equatable {
        case onAppear
        case receivedDetailHoliday(TaskResult<DetailHoliday>)
    }

    @Dependency(\.currentHolidayClient) var currentHolidayClient
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
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
struct HolidayWatchDetailView: View {
    let store: StoreOf<HolidayDetailDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
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
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                if viewStore.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .scaleEffect(2, anchor: .center)
                }
            }
            .navigationTitle(viewStore.holiday.name)
        }
    }
}

struct HolidayWatchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HolidayWatchDetailView(store: .init(initialState: .init(holiday: .init(name: "Christmas", url: "https://www.google.com"))) {
            HolidayDetailDomain()
        })
    }
}
