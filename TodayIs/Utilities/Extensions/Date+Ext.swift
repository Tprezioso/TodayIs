//
//  Date+Ext.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/1/21.
//

import UIKit

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
