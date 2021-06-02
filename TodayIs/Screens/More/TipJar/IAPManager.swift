//
//  IAPManager.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/2/21.
//

import Purchases
import SwiftUI

class IAPManager: ObservableObject {
    static let shared = IAPManager()

    @Published var packages: [Purchases.Package] = []
    @Published var inPaymentProgress = false

    init() {
        Purchases.debugLogsEnabled = true
        Purchases.configure(withAPIKey: "API KEY")
        Purchases.shared.offerings { (offerings, _) in
            if let packages = offerings?.current?.availablePackages {
                self.packages = packages
            }
        }
    }

    func purchase(product: Purchases.Package) {
        guard !inPaymentProgress else { return }
        inPaymentProgress = true
        Purchases.shared.purchasePackage(product) { (_, purchaserInfo, _, _) in
            self.inPaymentProgress = false
        }
    }
}
