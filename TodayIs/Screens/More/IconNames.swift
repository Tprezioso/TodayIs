//
//  IconNames.swift
//  TodayIs
//
//  Created by Thomas Prezioso Jr on 6/3/21.
//

import SwiftUI

class IconNames: ObservableObject {
    
    @Published var iconNames: [String?] = [nil]
    @Published var currentIndex = 0
    
    init() {
        getAlternateIconNames()
        
        if let currentIcon = UIApplication.shared.alternateIconName{
            self.currentIndex = iconNames.firstIndex(of: currentIcon) ?? 0
        }
    }
    
    func getPath() -> String {
        let plistFileName = "fileName.plist"
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0] as NSString
        let plistPath = documentPath.appendingPathComponent(plistFileName)
        return plistPath
    }
    
    func getAlternateIconNames(){
        if let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
           let alternateIcons = icons["CFBundleAlternateIcons"] as? [String: Any] {
            
            for (_, value) in alternateIcons{
                
                guard let iconList = value as? Dictionary<String,Any> else{return}
                guard let iconFiles = iconList["CFBundleIconFiles"] as? [String]
                else{return}
                
                guard let icon = iconFiles.first else{return}
                iconNames.append(icon)
            }
        }
    }
}

