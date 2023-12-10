//
//  TabBarView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 5/29/21.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {   
            NavigationView {
                NationalDayListView()
                    .navigationBarTitle("Today is...", displayMode: .large)
                    .listStyle(.plain)
            }
            .tabItem {
                Label("Today", systemImage: "calendar")
            }
            .tag(1)
            
            NavigationView {
                TomorrowListView()
                    .listStyle(.plain)
                    .navigationBarTitle("Tomorrow is...")
            }
            .tabItem {
                Label("Tomorrow", systemImage: "calendar.badge.clock")
            }
            .tag(2)
            
            NavigationView {
                YearView()
                    .listStyle(PlainListStyle())
                    .navigationBarTitle("Year")
                
            }
            .tabItem {
                Label("Year", systemImage: "magnifyingglass")
            }
            .tag(3)
            
            NavigationView {
                MoreView()
                    .navigationTitle("More")
            }
            .tabItem {
                Label("More", systemImage: "ellipsis")
            }
            .tag(4)
        }
        .accentColor(.red)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
