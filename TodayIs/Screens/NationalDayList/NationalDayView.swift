//
//  ContentView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 3/8/21.
//

import SwiftUI

struct NationalDayView: View {
    let holiday: Holiday
//    @Binding var isShowingDetailView: Bool
    
    var body: some View {
        VStack {
            Image("PlaceholderImage")
                .resizable()
                .scaledToFit()
            Text("akjsdfhlajfhlakjfhlaskjhflsadkjfhdslkjfhdslkfjahsdlfkjdshflksdajhfdlksjfhlsadkjfhasldkjfhsadlkjfhdskjfhaslkdjfhalsjkdfhlaskjdfhlaskjfh")

            Spacer()
            Button {
                
            } label: {
                Text("Share")
            }
        }.onAppear {
            NetworkManager.shared.getDetailHoliday(url: "https://nationaldaycalendar.com/days-2/national-barbershop-quartet-day-april-11/") { [self] result in
                print(result)
            }
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
