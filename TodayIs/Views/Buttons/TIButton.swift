//
//  TIButton.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/18/21.
//

import SwiftUI

struct TIButton: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .frame(width: 260, height: 50)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
    }
}

struct TIButton_Previews: PreviewProvider {
    static var previews: some View {
        TIButton(title: "OK")
    }
}
