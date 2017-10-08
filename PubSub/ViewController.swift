//
//  ViewController.swift
//  PubSub
//
//  Created by SA Studios on 10/3/17.
//  Copyright © 2017. All rights reserved.
//
//Test AG

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//    Do any additional setup after loading the view, typically from a nib.
        
        if let urlPrimary = URL(string: "http://weeklyad.publix.com/PublixAccessibility/BrowseByListing/ByCategory/?ListingSort=8&StoreID=2650275&CategoryID=5117860"){
            
            let request = NSMutableURLRequest(url: urlPrimary)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                   var message = ""
                   var messageSubPrice = ""
                
                if error != nil{
                    print(error!)
//  add code to display error to user even though we shouldnt have an error
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

                                let stringSeparatorSubPrice = "ellipsis_text\">"
                                
                                if contentArray.count > 1 {
                                    
                                    let newContentPriceArray = contentArray[2].components(separatedBy: stringSeparatorSubPrice)
                                    
                                    if newContentPriceArray.count > 1 {
                                        
                                        let stringPrice = NSString(string: newContentPriceArray[1])

                                        messageSubPrice = stringPrice.substring(to: 4)
                                        
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

