//
//  DailyDetailForm.swift
//  mainproject
//
//  Created by Benson Yang on 2019/4/19.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import Foundation
import UIKit

class DailyDetailForm {
    
    var Date : String
    var Name : String
    var Price : String
    var Coupon : String
 
    
    init(Date: String, Name: String, Price: String, Coupon: String){
        self.Date = Date
        self.Name = Name
        self.Price = Price
        self.Coupon = Coupon
        
    }
}
