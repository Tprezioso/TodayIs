//
//  NationalDayListView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/8/21.
//

import SwiftUI

struct NationalDayListView: View {
    @State private var isShowingDetailView = false
    
    var body: some View {
        NavigationView {
            List() {
                NavigationLink(destination: NationalDayView(), isActive: $isShowingDetailView) {
                    Text("Hello")
                    
                }
                           
            }.navigationTitle("Today's Day is...")
        }.onAppear {
            NetworkManager.shared.findData()
        }
    }
}

struct NationalDayListView_Previews: PreviewProvider {
    static var previews: some View {
        NationalDayListView()
    }
}
