//
//  CenterLeftCell.swift
//  mainproject
//
//  Created by Benson Yang on 2019/7/30.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit

class CenterLeftCell: UITableViewCell {

    @IBOutlet weak var clDate: UILabel!
    @IBOutlet weak var clName: UILabel!
    @IBOutlet weak var clPrice: UILabel!
    @IBOutlet weak var clCoupon: UILabel!
    
    func setCenterLeftList(centerLeftList: DailyDetailForm){
        clName.text = centerLeftList.Name
        clPrice.text = centerLeftList.Price
        clDate.text = centerLeftList.Date
        clCoupon.text = centerLeftList.Coupon
    }
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            var frame = newValue
            //frame.origin.x += 15
            //frame.size.width -= 2 * 15
            frame.origin.x = 0;//这里间距为10，可以根据自己的情况调整
            frame.size.width -= 2 * frame.origin.x;
            frame.size.height = 55;
            super.frame = frame
        }
    }

}
