//
//  UIColor.swift
//  KogdaTeplo
//
//  Created by Julia Nikitina on 08.04.2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.
//

import UIKit

//from hex to rgb conversion

extension UIColor {
    
    convenience init(hex: String) {
        
        var hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        //from #36GE45 to 36GE45
        if (hexString.hasPrefix("#")) {
            hexString.remove(at: hexString.startIndex)
        }
                
        var rgbValue: UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
