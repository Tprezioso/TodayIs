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
            
//            NavigationView {
//                SearchView()
//                    .listStyle(PlainListStyle())
//                    .navigationBarTitle("Search")
//
//            }
//            .tabItem {
//                Label("Search", systemImage: "magnifyingglass")
//            }
//            .tag(3)
            NavigationView {
                AtAGlanceView()
                    .listStyle(PlainListStyle())
                    .navigationBarTitle("At A Glance")
                
            }
            .tabItem {
                Label("Glance", systemImage: "eyeglasses")
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
