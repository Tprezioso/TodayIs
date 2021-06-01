//
//  SearchBar.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 5/29/21.
//

import SwiftUI
 
struct SearchBar: View {
    @StateObject var viewModel = SearchViewModel()
    @State private var isEditing = false
 
    var body: some View {
        VStack {
            HStack {
                TextField("Type in a Date(ie November 29) to Search", text: $viewModel.searchText)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                     
                            if isEditing {
                                Button(action: {
                                    self.isEditing = false
                                    self.viewModel.searchText = ""
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                    }
     
                if isEditing {
                    Button(action: {
                        viewModel.getHolidays()
                        self.isEditing = false
                        self.viewModel.searchText = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Text("Search")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
            List(viewModel.holidays) { holiday in
                if holiday.url == "" {
                    Text("\(holiday.name)")
                        .font(.title)
                        .fontWeight(.semibold)
                } else {
                    NavigationLink(holiday.name, destination: NationalDayView(holiday: holiday))
                }
            }
        }
    }
}

//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar(text: .constant(""))
//    }
//}
