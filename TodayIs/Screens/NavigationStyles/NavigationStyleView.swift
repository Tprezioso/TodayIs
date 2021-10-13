//
//  NavigationStyleView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/12/21.
//

import SwiftUI

struct NavigationStyleView: View {
    
#if os(iOS)
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  #endif
    @ViewBuilder
    var body: some View {
#if os(iOS)
    if horizontalSizeClass == .compact {
      TabBarView()  // For iPhone
    }
    else {
      SidebarNavigationView()  // For iPad
    }
    #else
    SidebarNavigationView()  // For mac
      .frame(minWidth: 900, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
    #endif
    }
}

struct NavigationStyleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStyleView()
    }
}
