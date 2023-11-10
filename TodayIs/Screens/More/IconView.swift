//
//  IconView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/3/21.
//

import SwiftUI

struct IconView: View {
    @EnvironmentObject var iconSettings: IconNames
    
    var body: some View {
        NavigationView {
            Form {
                Picker(selection: $iconSettings.currentIndex, label: Text("Icons")) {
                    ForEach(0..<iconSettings.iconNames.count, id: \.self) {
                        Text(self.iconSettings.iconNames[$0] ?? "Default")
                    }
                }.onReceive([self.iconSettings.currentIndex].publisher.first()) { (value) in
                    let index = self.iconSettings.iconNames.firstIndex(of: UIApplication.shared.alternateIconName) ?? 0
                    
                    if index != value{
                        UIApplication.shared.setAlternateIconName(self.iconSettings.iconNames[value]){ error in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                print("Success!")
                            }
                        }
                    }
                }
            }
        }.navigationBarTitle("Alternate Icons", displayMode: .large)
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
    }
}
