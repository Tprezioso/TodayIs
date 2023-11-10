//
//  MoreView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 5/29/21.
//

import SwiftUI

struct MoreView: View {
    var body: some View {
        List {
            NavigationLink("Change Icon", destination: IconView())
            NavigationLink("Developer", destination: DeveloperView())
        }.listStyle(InsetGroupedListStyle())
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
