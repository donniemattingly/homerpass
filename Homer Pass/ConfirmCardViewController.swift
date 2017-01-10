//
//  ConfirmCardViewController.swift
//  Homer Pass
//
//  Created by Donnie Mattingly on 1/7/17.
//  Copyright © 2017 Donnie Mattingly. All rights reserved.
//

import UIKit

class ConfirmCardViewController: UIViewController {
    
    @IBOutlet weak var cardNumberLabel: UILabel!
    var code:String?
    @IBOutlet weak var barcodeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let _ = code {
            let start = code?.index(code!.startIndex, offsetBy: 1)
            let end = code?.index(code!.endIndex, offsetBy: -1)
            let truncatedCode = code?.substring(with: start!..<end!)
            UserDefaults.standard.setValue(truncatedCode, forKey: "card_number")
            cardNumberLabel.text = truncatedCode
        
            barcodeImageView.image = Barcode.fromString(string: code!)
        }
    }
    
    @IBAction func okButtonTriggered(_ sender: Any) {
        let _  = self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
}
