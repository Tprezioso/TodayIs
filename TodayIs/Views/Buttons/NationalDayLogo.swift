//
//  NationalDayLogo.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/21/21.
//

import SwiftUI

struct NationalDayLogo: View {
    var body: some View {
        VStack {
            Text("Powered by:")
                .foregroundColor(.primary)
            Image("NationalDayLogo")
                .resizable()
                .frame(width: 75, height: 50)
                .scaledToFit()
        }
    }
}

struct NationalDayLogo_Previews: PreviewProvider {
    static var previews: some View {
        NationalDayLogo()
    }
}
