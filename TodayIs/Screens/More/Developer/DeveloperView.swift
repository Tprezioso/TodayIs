//
//  DeveloperView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/2/21.
//

import SwiftUI

struct DeveloperView: View {
    var body: some View {
        VStack {
            Image("Me")
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .scaledToFit()
            Text("Tommy Prezioso")
                .font(.title)
                .bold()
            VStack() {
                LinkButtons(url: "https://www.twitter.com/tommyprezioso", title: "Twitter")
                LinkButtons(url: "https://www.github.com/tprezioso",  title: "Github")
                LinkButtons(url: "https://www.swifttom.com/",  title: "Blog")
            }
            Spacer()
        }
    }
}

struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DeveloperView()
            DeveloperView()
                .preferredColorScheme(.dark)
        }
    }
}

struct LinkButtons: View {
    var url: String
    var title: String
    
    var body: some View {
        Link(destination: URL(string: url)!) {
            Text(title)
                .fontWeight(.semibold)
                .font(.title3)
                    .frame(width: 260, height: 55)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(5)
        }
    }
}
