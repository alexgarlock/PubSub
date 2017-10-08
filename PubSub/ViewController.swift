//
//  ViewController.swift
//  PubSub
//
//  Created by SA Studios on 10/3/17.
//  Copyright © 2017 Deeber. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var dealLabel: UILabel!
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let urlPrimary = URL(string: "http://weeklyad.publix.com/PublixAccessibility/BrowseByListing/ByCategory/?ListingSort=8&StoreID=2650275&CategoryID=5117860"){
            
            let request = NSMutableURLRequest(url: urlPrimary)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                   var message = ""
                   var messageSubPrice = ""
                   var messageSubDeal = ""
                
                if error != nil{
                    print(error!)
                    //add code to display error to user even though we shouldnt have an error
                }else{
                    
                    if let unwrappedData = data {
                    
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        var stringSeparatorSub = "Whole Sub"
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeparatorSub) {
                            
                            if contentArray.count > 1 {
                            
                                //Find Sub on Sale
                                
                                //print(contentArray[2])
                                
                                stringSeparatorSub = "Publix"
                                
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparatorSub)
                                
                                if newContentArray.count > 1 {
                                    
                                    message = newContentArray[1]
                                    
                                    print(message)
                                    
                                }
                             
                                //Find Sub Price

                                // I started here so we didnt have to reload the content Array.
                                
                                
                                let stringSeparatorEllipsisText = "ellipsis_text\">"
                                
                                if contentArray.count > 1 {
                                    
                                    let newContentPriceArray = contentArray[2].components(separatedBy: stringSeparatorEllipsisText)
                                    
                                    if newContentPriceArray.count > 1 {
                                        
                                        let stringPrice = NSString(string: newContentPriceArray[1])

                                        messageSubPrice = stringPrice.substring(to: 4)
                                        
                                        print(messageSubPrice)
                                        
                                    }
                                }
                                
                                let stringSeparatorSubDeal = "priceQualifier"
                                
                                let stringSpan = "</span>"
                                
                                if contentArray.count > 1 {
                                    
                                    let newContentDealArray1 = contentArray[2].components(separatedBy: stringSeparatorSubDeal)
                                    
                                        if newContentDealArray1.count > 1 {
                                            
                                            let newContentDealArray2 = newContentDealArray1[1].components(separatedBy: stringSeparatorEllipsisText)
                                        
                                                if newContentDealArray2.count > 1 {
                                        
                                                    let newContentDealArray3 = newContentDealArray2[1].components(separatedBy: stringSpan)

                                                    
                                                    let stringDeal = NSString(string: newContentDealArray3[0])
                                        
                                                    messageSubDeal = stringDeal as String
                                        
                                                    print(messageSubDeal)
                                        
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

