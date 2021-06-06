//
//  NationalHolidayLinkLogo.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/5/21.
//

import SwiftUI

struct NationalHolidayLinkLogo: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Button {
            openURL(URL(string: "https://nationaldaycalendar.com/")!)
        } label: {
            NationalDayLogo()
        }.padding(.bottom)
    }
}

struct NationalHolidayLinkLogo_Previews: PreviewProvider {
    static var previews: some View {
        NationalHolidayLinkLogo()
    }
}
