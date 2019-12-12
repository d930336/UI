//
//  DailyDetailCell.swift
//  mainproject
//
//  Created by Benson Yang on 2019/4/19.
//  Copyright © 2019 Benson Yang. All rights reserved.
//
//
//  CouponCell.swift
//  mainproject
//
//  Created by Benson Yang on 2019/3/14.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit

class DailyDetailCell: UITableViewCell {
    
    @IBOutlet weak var coupon: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var save: UILabel!
    
    
    func setDailyDetailForm(dailyDetailForm: DailyDetailForm){
        name.text = dailyDetailForm.Name
        price.text = dailyDetailForm.Price
        date.text = dailyDetailForm.Date
        coupon.text = dailyDetailForm.Coupon
        id.text = dailyDetailForm.id
        save.text = dailyDetailForm.save
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
            frame.size.height = 65;
            super.frame = frame
        }
    }
    
    
    
}
