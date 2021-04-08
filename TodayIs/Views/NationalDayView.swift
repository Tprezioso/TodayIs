//
//  ContentView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 3/8/21.
//

import SwiftUI

struct NationalDayView: View {
    var body: some View {
        VStack {
            Image("PlaceholderImage")
                .resizable()
                .scaledToFit()
            Text("Hello, world!")
            

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NationalDayView()
    }
}
