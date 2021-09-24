//
//  EmptyState.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/24/21.
//

import SwiftUI

struct EmptyState: View {
    let message: String
    var body: some View {
        ZStack {
            VStack {
                Text(message)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
            }
        }
    }
}

struct EmptyState_Previews: PreviewProvider {
    static var previews: some View {
        EmptyState(message: "Hello")
    }
}
