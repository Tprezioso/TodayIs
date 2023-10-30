//
//  TomorrowListFeature.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/30/23.
//

import SwiftUI
import ComposableArchitecture

struct TomorrowListDomain: Reducer {
    struct State: Equatable {
        // TODO: - Need to add loading
        var holidays = [Holiday]()
        var isLoading = false
        @PresentationState var nationalDayDetailState: NationalDayDomain.State?

    }

    enum Action: Equatable {

    }

    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            }
        }
    }
}

struct TomorrowListFeature: View {
    let store: StoreOf<TomorrowListDomain>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    TomorrowListFeature(store: .init(initialState: .init()) {
        TomorrowListDomain()
    })
}
