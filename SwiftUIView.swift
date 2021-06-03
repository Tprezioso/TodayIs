//
//  SwiftUIView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/3/21.
//

import SwiftUI
import Purchases

struct APRow: View {
    var title: String
    var description: String
            var body: some View {
                HStack {
                    VStack(alignment: .leading) {
                        Text(title).bold()
                        Text(description)
                    }

                    Spacer()

                    Text(".99").bold()
                }
                .foregroundColor(.primary)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
        }

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        APRow(title: "Coffee", description: "Buy me a coffee")
    }
}
