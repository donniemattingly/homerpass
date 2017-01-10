//
//  ViewController.swift
//  Homer Pass
//
//  Created by Donnie Mattingly on 1/6/17.
//  Copyright © 2017 Donnie Mattingly. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UITableViewController {

    @IBOutlet weak var barcodeImageView: UIImageView!
    @IBOutlet weak var cardBalanceLabel: UILabel!
    @IBOutlet weak var addCardButton: DepotButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("refreshing")
        if let cardNumber = UserDefaults.standard.string(forKey: "card_number"){
            updateCardBalance(cardNumber: cardNumber)
        }
        refreshControl.endRefreshing()
    }
    
    func updateCardBalance(cardNumber:String) {
        let baseUrl = "https://secure.alohaenterprise.com/servlet/MemberLinkSVServlet?companyID=thd01&requestType=checkSVCardForEPin&cardNumber="
        let url = baseUrl + cardNumber
        Alamofire.request(url)
            .responseJSON() { (response) in
                if let anError = response.result.error {
                    print("error getting balance")
                    print(anError)
                }
                
                if let result = response.result.value {
                    let balance: Float = (result as! NSDictionary)["cardBalance"]! as! Float
                    print("Setting balance to: " + balance.description)
                    self.cardBalanceLabel.text = "$" + balance.description
                }
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let cardNumber = UserDefaults.standard.string(forKey: "card_number"){
            print("got card number from user defaults")
            let barcodeString = ";" + cardNumber + "?"
            addCardButton.setTitle("Update Card", for: .normal)
            barcodeImageView.image = Barcode.fromString(string: barcodeString)
            print(cardNumber)
            updateCardBalance(cardNumber: cardNumber)
        } else{
            print("No card saved, one will need to be added")
            addCardButton.setTitle("Add Card", for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "historySegue"){
            if let cardNumber = UserDefaults.standard.string(forKey: "card_number"){
                 (segue.destination as? HistoryViewController)?.cardNumber = cardNumber
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }


}

