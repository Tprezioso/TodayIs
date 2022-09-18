//
//  Navigation+Ext.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 9/18/22.
//

import UIKit

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
