//
//  ViewController.swift
//  PubSub
//
//  Created by Steven on 10/3/17.
//  Copyright © 2017 Deeber. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let urlPrimary = URL(string: "http://weeklyad.publix.com/PublixAccessibility/BrowseByListing/ByCategory/?ListingSort=8&StoreID=2650275&CategoryID=5117860"){
            
            let request = NSMutableURLRequest(url: urlPrimary)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                if error != nil{
                    print(error)
                    //add code to display error to user even though we shouldnt have an error
                }else{
                    
                    if let unwrappedData = data {
                    
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        print(dataString)
                        
                        }
                    
                    }
                    
                }
            
                task.resume()
            
            }
            
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

