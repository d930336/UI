//
//  WebView.swift
//  mainproject
//
//  Created by Benson Yang on 2019/3/20.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit
import WebKit
class WebView: UIViewController {
    
    var receivedUrl:String = ""
    
    @IBAction func nextPage(_ sender: Any) {
        self.performSegue(withIdentifier: "goToPC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "goToPC" {

            let secondVC = segue.destination as! pageviewcontroller

            secondVC.received = 2

        }
    }
    
    @IBAction func back(_ sender: Any) {
        resetTheCouponValue()
    }
    
    @IBOutlet weak var WebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: couponListUrl)
        let request = URLRequest(url :url!)
        
        WebView.load(request)
    
    }

}
