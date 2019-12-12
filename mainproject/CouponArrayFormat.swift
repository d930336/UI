//
//  CouponArrayFormat.swift
//  mainproject
//
//  Created by Benson Yang on 2019/9/22.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import Foundation

import UIKit

class CouponArrayFormat {
    
    var Store : String
    var Content : String
    var Kind : String
    var url: String
    var discount : String
    var save:String
        
    init(Store: String, Content: String, Kind: String,url:String,discount:String,save:String){
        self.Store = Store
        self.Content = Content
        self.Kind = Kind
        self.url = url
        self.discount = discount
        self.save = save
    }
}
