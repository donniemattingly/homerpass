//
//  barcode.swift
//  Homer Pass
//
//  Created by Donnie Mattingly on 1/7/17.
//  Copyright © 2017 Donnie Mattingly. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

class Barcode {
    
    class func fromString(string : String) -> UIImage? {
        
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CICode128BarcodeGenerator"){
            filter.setValue(data, forKey: "inputMessage")
            return UIImage(ciImage: filter.outputImage!)
        }
        return nil
    }
    
}
