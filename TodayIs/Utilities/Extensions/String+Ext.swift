//
//  String+Ext.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/1/21.
//

import UIKit

extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: "+")
    }
}

