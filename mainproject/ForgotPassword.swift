//
//  ForgotPassword.swift
//  mainproject
//
//  Created by Benson Yang on 2019/8/18.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit
import WebKit

class ForgotPassword: UIViewController {

    @IBOutlet weak var WebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://"+UrlId+".ngrok.io/accounts/password/reset/")
        let request = URLRequest(url :url!)
        
        WebView.load(request)
        
    }
    

    

}
