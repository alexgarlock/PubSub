//
//  ViewController.swift
//  PubSub
//
//  Created by SA Studios on 10/3/17.
//  Copyright © 2017. All rights reserved.
//
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var dealLabel: UILabel!
    
    @IBOutlet weak var dateRangeLabel: UILabel!
    
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet weak var OrderNow: UILabel! 
    
    override func viewDidLoad() {
        super.viewDidLoad()
//    Do any additional setup after loading the view, typically from a nib.
        
        
        if let urlPrimary = URL(string: "http://weeklyad.publix.com/PublixAccessibility/BrowseByListing/ByCategory/?ListingSort=8&StoreID=2650275&CategoryID=5117860"){
            
            let request = NSMutableURLRequest(url: urlPrimary)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
//   Start message as empty
                   var message = ""
                   var messageSubPrice = ""
                   var messageSubDeal = ""
                   var messageDealDate = ""
                
                if error != nil{
                    print(error!)
                    
//  added code to display error to user if we cannot load website or website has changed
                    
                    let alert = UIAlertController(title: "Pub Sub Error", message: "We are having a hard time load. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    
                    if let unwrappedData = data {
                    
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
//  Find Sub on Sale
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
                                            
//Find Length of Deal
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
                
        if message == "" {
                    
            message = "The sub couldn't be found. 1"
        }
                DispatchQueue.main.sync(execute: {
                    
                    self.resultsLabel.text = message + "Whole Sub"
                    
                    self.priceLabel.text = "$" + messageSubPrice
                    
                    self.dealLabel.text = messageSubDeal
                    
                    self.dateRangeLabel.text = messageDealDate
                    
                })
            }
    task.resume()
            } else {
            resultsLabel.text = "The sub couldn't be found. 2"
            }
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

