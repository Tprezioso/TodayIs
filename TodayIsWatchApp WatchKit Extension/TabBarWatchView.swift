//
//  TabBarWatchView.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/10/21.
//

import SwiftUI

struct TabBarWatchView: View {
    var body: some View {
        TabView {
                TodayWatchView()
                .tag(1)
            
            TomorrowWatchView()
                .tag(2)
        }
        .navigationTitle("Today Is....")
    }
}

struct TabBarWatchView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarWatchView()
    }
}
