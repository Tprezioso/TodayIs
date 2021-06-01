//
//  SearchView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 5/29/21.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        VStack {
            SearchBar(viewModel: viewModel)
                .padding()
              Spacer()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
