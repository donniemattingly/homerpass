//
//  DepotButton.swift
//  Homer Pass
//
//  Created by Donnie Mattingly on 1/8/17.
//  Copyright © 2017 Donnie Mattingly. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    @objc convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    @objc convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class DepotButton : UIButton {
    @objc let baseBackgroundColor = UIColor(netHex: 0xfd751c)
    @objc let highlightedBackgroundColor = UIColor(netHex: 0xf96302)
    override var isHighlighted: Bool {
        didSet {
            switch isHighlighted {
            case true:
                backgroundColor = highlightedBackgroundColor
            case false:
                backgroundColor = baseBackgroundColor
            }
        }
    }
}
