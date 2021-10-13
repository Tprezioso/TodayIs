//
//  TipJarView.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/2/21.
//
//
//import SwiftUI
//import Purchases
//
//struct TipJarView: View {
//    @EnvironmentObject private var subscriptionManager: IAPManager
//
//        var body: some View {
//            VStack {
//                Text("Tip Jar")
//                    .font(.largeTitle)
//                    .padding(.horizontal)
//
//                VStack(alignment: .leading) {
//                    Text("If you love this app, you can leave a tip to cover development cost! Any tip at all helps a lot!")
//                        .fontWeight(.semibold)
//                }
//                .padding()
//
//                ScrollView {
//                    ForEach(subscriptionManager.packages, id: \.identifier) { product in
//                        Button(action: {
//                            subscriptionManager.purchase(product: product)
//                        }) {
//                            IAPRow(product: product)
////                            APRow(title: "Coffee", description: "Buy me a coffee")
//                        }
//                    }
//                    .padding(.vertical)
//                }
//            }
//        }
//}
//
//struct TipJarView_Previews: PreviewProvider {
//    static var previews: some View {
//        TipJarView()
//    }
//}
//
//struct IAPRow: View {
//    var product: Purchases.Package
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(product.product.localizedTitle).bold()
//                Text(product.product.localizedDescription)
//            }
//
//            Spacer()
//
//            Text(product.localizedPriceString).bold()
//        }
//        .foregroundColor(.primary)
//        .padding(8)
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding(.horizontal)
//    }
//}
