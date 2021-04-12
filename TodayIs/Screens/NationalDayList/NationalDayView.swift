//
//  ContentView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 3/8/21.
//

import SwiftUI

struct NationalDayView: View {
    var holiday: Holiday
    @StateObject var viewModel = NationalDayViewModel()
    @StateObject var imageLoader = ImageLoader()
    
    var body: some View {
        VStack {
            RemoteImage(image: imageLoader.image)
                .scaledToFit()
                .frame(width: 300, height: 225)
//            Image(viewModel.detailHoliday.image ?? "PlaceholderImage")
//                .resizable()
//                .scaledToFit()
            Text(viewModel.detailHoliday.description)

            Spacer()
            Button {
                
            } label: {
                Text("Share")
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert.init(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
        .onAppear {
            viewModel.getHoliday(url: holiday.url)
            imageLoader.load(fromURLString: viewModel.detailHoliday.image)
        }
        .navigationTitle(holiday.name)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        NationalDayView(holiday: <#Holiday#>, isShowingDetailView: <#Binding<Bool>#>)
//    }
//}
