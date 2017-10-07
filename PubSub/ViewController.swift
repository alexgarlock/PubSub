//
//  ViewController.swift
//  PubSub
//
//  Created by Steven on 10/3/17.
//  Copyright © 2017 Deeber. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let urlPrimary = URL(string: "http://weeklyad.publix.com/PublixAccessibility/BrowseByListing/ByCategory/?ListingSort=8&StoreID=2650275&CategoryID=5117860"){
            
            let request = NSMutableURLRequest(url: urlPrimary)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                   var message = ""
                
                if error != nil{
                    print(error!)
                    //add code to display error to user even though we shouldnt have an error
                }else{
                    
                    if let unwrappedData = data {
                    
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        var stringSeparator = "Whole"
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            
                            if contentArray.count > 1 {
                                
                                stringSeparator = "title="
                                
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                
                                if newContentArray.count > 1 {
                                    
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    
                                    print(message)
                                }
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
                
                if message == "" {
                    
                    message = "The sub couldn't be found. Please try again."
                    
                }
                
                DispatchQueue.main.sync(execute: {
                    
                    self.resultsLabel.text = message
                    
                })
                
            }
            
            task.resume()
            
        } else {
            
            resultsLabel.text = "The sub couldn't be found. Please try again."
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

