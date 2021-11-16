//
//  TabBarWatchView.swift
//  TodayIsWatchApp WatchKit Extension
//
//  Created by Thomas Prezioso Jr on 9/10/21.
//

import SwiftUI

struct TabBarWatchView: View {
    @State var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                TodayWatchView()
                    .tag(0)
            }
            NavigationView {
                TomorrowWatchView()
                    .tag(1)
            }
        }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}

struct TabBarWatchView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarWatchView()
    }
}
