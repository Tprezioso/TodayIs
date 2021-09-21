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
            Text("First View")
                        .padding()
                        .tabItem {
                            Image(systemName: "1.circle")
                            Text("First")
                        }
                        .tag(1)
                    Text("Second View")
                        .padding()
                        .tabItem {
                            Image(systemName: "2.circle")
                            Text("Second")
                        }
                        .tag(2)
                }
    }
}

struct TabBarWatchView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarWatchView()
    }
}
