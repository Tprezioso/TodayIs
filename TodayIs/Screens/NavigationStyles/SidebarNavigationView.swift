//
//  SidebarNavigationView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/12/21.
//

import SwiftUI

struct SidebarNavigationView: View {
    var body: some View {
        NavigationView {
            SidebarNavView()
                .navigationTitle("Today Is")
            NationalDayListView()
        }
        .accentColor(.red)
    }
}

struct SidebarNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarNavigationView()
    }
}

struct SidebarNavView: View {
    var body: some View {
        List {
            NavigationLink(destination: NationalDayListView()) {
                Label("Today", systemImage: "calendar")
            }
            NavigationLink(destination: TomorrowListView()) {
                Label("Tomorrow", systemImage: "calendar.badge.clock")
            }
            NavigationLink(destination: YearView()) {
                Label("Year", systemImage: "magnifyingglass")
            }
            NavigationLink(destination: MoreView()) {
                Label("More", systemImage: "ellipsis")
            }
        }
        .listStyle(SidebarListStyle())
    }
}
