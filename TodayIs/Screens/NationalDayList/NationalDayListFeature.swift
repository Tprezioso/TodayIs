//
//  NationalDayListFeature.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/18/23.
//

import SwiftUI
import ComposableArchitecture

struct NationalDayListDomain: Reducer {
    struct State: Equatable {
        var holidays = [Holiday]()
        var isLoading = false
    }

    enum Action: Equatable {
        case onAppear
    }

    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}

struct NationalDayListFeature: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    NationalDayListFeature()
}
