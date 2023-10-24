//
//  HolidayView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 10/23/23.
//

import SwiftUI

public struct HolidayView: View {
    public init(holiday: Holiday) {
        self.holiday = holiday
    }
    public var holiday: Holiday

    public var body: some View {
        ZStack {
            AsyncImage(url: URL(string: holiday.imageURL ?? "PlaceholderImage")) { phase in
                if let image = phase.image {
                    GeometryReader { geo in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                } else if phase.error != nil {
                    Image(systemName: "building")
                } else {
                    ProgressView().progressViewStyle(.circular)
                        .controlSize(.large)
                }
            }

            VStack(alignment: .leading) {
                Spacer()
                VStack(alignment: .leading, spacing: 12) {
                    Text(holiday.name)
                        .font(.title)

                    Text(holiday.description ?? "")
                        .font(.subheadline)
                }
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }.frame(height: 200)
                .frame(maxWidth: .infinity)
                .background(
                    Color.black.opacity(0.3)
                )
        }
    }
}

#Preview {
    HolidayView(holiday: .init(name: "asdf", url: "asdf"))
}
