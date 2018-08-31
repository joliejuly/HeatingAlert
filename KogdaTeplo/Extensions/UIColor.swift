//
//  UIColor.swift
//  KogdaTeplo
//
//  Created by Yulia Taranova on 08.04.2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: String) {
        
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
                
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static let mainYellow: UIColor = {
        return UIColor(hex: "FCD16D")
    }()
    
    static let mainBlue: UIColor = {
        return UIColor(hex: "433E50")
    }()
}
