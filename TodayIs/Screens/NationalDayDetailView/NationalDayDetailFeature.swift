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
        var holiday: Holiday
        init(holiday: Holiday) {
            self.holiday = holiday
        }
    }

    enum Action: Equatable {
        case onAppear
    }

    @Dependency(\.currentHolidayClient) var currentHolidayClient
    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .run { [url = state.holiday.url] send in
                    let response = try await currentHolidayClient.getCurrentHolidayDetail(url)
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
                Text(viewStore.holiday.description ?? "")
            }
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
