//
//  DeveloperView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/2/21.
//

import SwiftUI

struct DeveloperView: View {
    var body: some View {
        VStack() {
            Image("Me")
                .resizable()
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .scaledToFit()
            Text("Tommy Prezioso")
                .font(.title)
            Spacer()
            VStack() {
                LinkButtons(url: "https://www.twitter.com/tommyprezioso", image: "twitter-512", title: "Twitter")
                LinkButtons(url: "https://www.github.com/tprezioso", image: "GitHub", title: "Github")
                LinkButtons(url: "https://www.swifttom.com/", image: "Swift", title: "SwiftTom.com")
                
            }
            Spacer()
            
        }
    }
}

struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperView()
    }
}

struct LinkButtons: View {
    var url: String
    var image: String
    var title: String
    
    var body: some View {
        Link(destination: URL(string: url)!) {
            VStack(alignment: .leading) {
                HStack() {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                    Text(title)
                        .font(.title)
                        .foregroundColor(.black)
                }.frame(width: 250 ,height: 30)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2)
                )
            }
        }
    }
}
