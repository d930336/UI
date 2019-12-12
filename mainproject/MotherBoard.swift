//
//  MotherBoard.swift
//  mainproject
//
//  Created by Benson Yang on 2019/10/17.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit

class MotherBoard: UIViewController {

    var alertControll:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
      // MARK: Alert
func showAlertMessageMP(title: String, message: String) {
        let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
        let okAction = UIAlertAction(title: "確認", style: .default, handler: nil) // 產生確認按鍵
        inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController
        self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
    }
    
}
