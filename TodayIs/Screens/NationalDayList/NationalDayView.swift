//
//  ContentView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 3/8/21.
//

import SwiftUI
import URLImage

struct NationalDayView: View {
    var holiday: Holiday
    @StateObject var viewModel = NationalDayViewModel()
    
    var body: some View {
        VStack(spacing: 5) {
            RemoteImage(image: viewModel.image)
                .scaledToFit()
                .padding(.bottom)
            Text(viewModel.detailHoliday.description)
            Spacer()
            Button {
                
            } label: {
                Text("Share")
            }
            Spacer()
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert.init(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }
        .onAppear {
            viewModel.getHoliday(url: holiday.url)

        }
        .navigationTitle(holiday.name)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

//class ImageLoader: ObservableObject {
//    @Published var image: UIImage?
//    private let url: URL
//    private var cancellable: AnyCancellable?
//
//    init(url: URL) {
//        self.url = url
//    }
//
//    deinit {
//        cancel()
//    }
//
//    func load() {
//        cancellable = URLSession.shared.dataTaskPublisher(for: url)
//                    .map { UIImage(data: $0.data) }
//                    .replaceError(with: nil)
//                    .receive(on: DispatchQueue.main)
//                    .sink { [weak self] in self?.image = $0 }
//    }
//
//    func cancel() {
//        cancellable?.cancel()
//    }
//}
//
//struct AsyncImage<Placeholder: View>: View {
//    @StateObject private var loader: ImageLoader
//    private let placeholder: Placeholder
//
//    init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
//        self.placeholder = placeholder()
//        _loader = StateObject(wrappedValue: ImageLoader(url: url))
//    }
//
//    var body: some View {
//        content
//            .onAppear(perform: loader.load)
//    }
//
//    private var content: some View {
//        placeholder
//    }
//}
