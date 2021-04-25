//
//  RemoteImage.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 4/15/21.
//

import SwiftUI

final class ImageLoader: ObservableObject {
    @Published var image: Image? = nil
    
}

struct RemoteImage: View {
    var image: Image?
    
    var body: some View {
        image?.resizable() ?? Image("PlaceholderImage").resizable()
    }
}
