//
//  GoogleLogin.swift
//  mainproject
//
//  Created by Benson Yang on 2019/7/16.
//  Copyright © 2019 Benson Yang. All rights reserved.
//import UIKit
import WebKit
class GoogleLogin: UIViewController {
    
    
    
    @IBOutlet weak var WebView: WKWebView!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
       
        let dictionaty = NSDictionary(object: "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36", forKey: "UserAgent" as NSCopying)
        UserDefaults.standard.register(defaults: dictionaty as! [String : Any])
        
        let url = URL(string: "https://1e70f92c.ngrok.io/accounts/google/login/")
        let request = URLRequest(url :url!)
        
        WebView.load(request)
        
    }
    
    
   
}
