//
//  CouponCellFormat.swift
//  mainproject
//
//  Created by Benson Yang on 2019/9/22.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit

class CouponCellFormat: UITableViewCell {

    @IBOutlet weak var Store: UILabel!
    @IBOutlet weak var Content: UILabel!
    @IBOutlet weak var Kind: UILabel!
    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var save: UILabel!
    
    func setCoupon(coupon: CouponArrayFormat){
        Store.text = coupon.Store
        Content.text = coupon.Content
        Kind.text = coupon.Kind
        url.text = coupon.url
        discount.text = coupon.discount
        save.text = coupon.save
    }
    
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            //frame.origin.x += 15
            //frame.size.width -= 2 * 15
            frame.origin.x = 10;//这里间距为10，可以根据自己的情况调整
            frame.size.width -= 2 * frame.origin.x;
            frame.size.height -= 1 * frame.origin.x;
            super.frame = frame
        }
    }
    
    
    
  

}
