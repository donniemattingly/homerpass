//
//  HistoryViewController.swift
//  Homer Pass
//
//  Created by Donnie Mattingly on 1/8/17.
//  Copyright © 2017 Donnie Mattingly. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HistoryViewController: UITableViewController {
    
    var cardNumber: String?
    var historyItems = [(date: String, time:String, balance: String, amount: String)]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let number = cardNumber {
            self.updateHistory(cardNumber: number)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: #selector(HistoryViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("refreshing")
        if let cardNumber = UserDefaults.standard.string(forKey: "card_number"){
            updateHistory(cardNumber: cardNumber)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HistoryCell
        let historyItem = historyItems[indexPath.item]
        cell.balanceLabel.text = historyItem.balance
        cell.dateLabel.text = historyItem.date
        cell.transactionAmountLabel.text = historyItem.amount
        return cell
    }
    
    
    func updateHistory(cardNumber:String){
        let baseUrl = "https://secure.alohaenterprise.com/servlet/MemberLinkSVServlet?companyID=thd01&requestType=checkSVCardForEPin&cardNumber="
        let url = baseUrl + cardNumber
        Alamofire.request(url)
            .responseJSON() { (response) in
                if let anError = response.result.error {
                    print("error getting balance")
                    print(anError)
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, y"
                
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "h:mm a"
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .currency
                
                self.historyItems = [(date: String, time:String, balance: String, amount: String)]()
                if let result = response.result.value {
                    let resultJSON = JSON(result)
                    let svHistoryItems = resultJSON["svHistory"].arrayValue
                    for item in svHistoryItems{
                        let timestamp = item["transactionDateTime"]["time"].double! / 1000
                        let date = Date(timeIntervalSince1970: timestamp)
                        let dateString = dateFormatter.string(from: date)
                        let timeString = timeFormatter.string(from:date)
                        let balance = numberFormatter.string(from: NSNumber(floatLiteral: item["cardBalance"].double!))
                        let amount = numberFormatter.string(from: NSNumber(floatLiteral: item["amount"].double!))
                        self.historyItems.append((date: dateString,time: timeString, balance: balance!, amount: amount!))
                    }
                    self.historyItems.reverse()
                    self.tableView.reloadData()
                    if let _ = self.refreshControl{
                        if(self.refreshControl!.isRefreshing){
                            self.refreshControl!.endRefreshing()
                        }
                    }
                }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
