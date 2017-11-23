//
//  ViewController.swift
//  PubSub
//
//  Created by Taradine LLC on 10/3/17.
//  Copyright © 2017. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var dealLabel: UILabel!
    
    @IBOutlet weak var dateRangeLabel: UILabel!
    
    @IBOutlet var webView: UIWebView!
    
//  Added Order now button
    @IBAction func OrderNow(_ sender: Any) {
        let OrderNowURL = URL(string: "http://www.publix.com/product-catalog/productlisting?ch=18.2.1.&page=1&oeo=true")
        UIApplication.shared.open(OrderNowURL!, options: [:], completionHandler: nil)
    }
    
//  Added remove status bar
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//  Set the badge to reset to 0 when app is opened
        UIApplication.shared.applicationIconBadgeNumber = 0
//  User authorized the app to allow notificaitons
        UNService.shared.authorize()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAction(_:)),
                                               name: NSNotification.Name("internalNotification.handleAction"),
                                               object: nil)
        
// Setting up of the Sub loading from the website
        if let urlPrimary = URL(string: "http://weeklyad.publix.com/PublixAccessibility/BrowseByListing/ByCategory/?ListingSort=8&StoreID=2650275&CategoryID=5117860"){
            
            let request = NSMutableURLRequest(url: urlPrimary)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
//   Start message as empty we fill this below after picking info from the website
                   var message = ""
                   var messageSubPrice = ""
                   var messageSubDeal = ""
                   var messageDealDate = ""
                
                if error != nil{
                    print(error!)
                    
//  added code to display error to user if we cannot load website or website has changed
                    
                    let alert = UIAlertController(title: "Pub Sub Error", message: "We are having a hard time loading. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    
                    if let unwrappedData = data {
                    
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
//  Find Sub on Sale
//
//  Fine the word Whole sub first then work backwards to the word Publix to grab the sub of the week on their website
                        var stringSeparatorSub = "Whole Sub"
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeparatorSub) {
                            
                            if contentArray.count > 1 {
                                
                                stringSeparatorSub = "Publix"
                                
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparatorSub)
                                
                                if newContentArray.count > 1 {
                                    
                                    message = newContentArray[1]
                            
                                }
                             
//  Find Sub Price
                        let stringSeparatorEllipsisText = "ellipsis_text\">"
                                
                            if contentArray.count > 1 {
                                    
                                let newContentPriceArray = contentArray[2].components(separatedBy: stringSeparatorEllipsisText)
                                    
                                if newContentPriceArray.count > 1 {
                                        
                                    let stringPrice = NSString(string: newContentPriceArray[1])

                                    messageSubPrice = stringPrice.substring(to: 4)
                                        
                                }
                            }
// Find Sub savings amount
                        let stringSeparatorSubDeal = "priceQualifier"
                                
                        let stringSpanEnd = "</span>"
                                
                                if contentArray.count > 1 {
                                    
                                let newContentDealArray1 = contentArray[2].components(separatedBy: stringSeparatorSubDeal)
                                    
                                    if newContentDealArray1.count > 1 {
                                            
                                    let newContentDealArray2 = newContentDealArray1[1].components(separatedBy: stringSeparatorEllipsisText)
                                        
                                        if newContentDealArray2.count > 1 {
                                        
                                            let newContentDealArray3 = newContentDealArray2[1].components(separatedBy: stringSpanEnd)
                                                    
                                            let stringDeal = NSString(string: newContentDealArray3[0])
                                        
                                            messageSubDeal = stringDeal as String
                                            
//Find the date range of the Deal
                                            let stringSpanStart = "<span>"
                                            
                                            let newContentDatesArray = newContentDealArray3[1].components(separatedBy: stringSpanStart)
                                            
                                            let stringDate = NSString(string: newContentDatesArray[1])

                                            messageDealDate = stringDate as String
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
//  Error message for all if we cannot find above.
        if message == "" {
                    
            message = "The sub couldn't be found. Error 1 "
        }
                DispatchQueue.main.sync(execute: {
                    
//  Display the information as text so it is readable to the app
                    
                    self.resultsLabel.text = message + "Whole Sub"
                    self.priceLabel.text = "$" + messageSubPrice
                    self.dealLabel.text = messageSubDeal
                    self.dateRangeLabel.text = messageDealDate
                })
            }
    task.resume()
            } else {
            resultsLabel.text = "The sub couldn't be found. Error 2"
            }
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
// Dispose of any resources that can be recreated.
    }
// COMEBACK fix this we dont need the .timer in this code 
    @objc
    func handleAction(_ sender: Notification) {
        guard let action = sender.object as? NotificationActionID else { return }
        switch action {
        case .timer: print("timer logic")
        case .date: print("date logic")
        }
    }
}

