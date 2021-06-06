//
//  EmptyState.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/5/21.
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
