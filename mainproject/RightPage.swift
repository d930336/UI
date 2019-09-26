//
//  CouponList.swift
//  mainproject
//
//  Created by Benson Yang on 2019/3/14.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit
import SQLite


//--------------------------------------------

class RightPage: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellSpacingHeight: CGFloat = 10
    let selectedBackgroundView = UIView()
    
    var couponList : [CouponArrayFormat] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        selectedBackgroundView.backgroundColor = UIColor.clear
        
        couponList = createArray()
      
    
    func tableView(_ tableView: UITableView, heightForFootererInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFootererInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    

}
    
    
    
    
    
    
    
    func createArray() -> [CouponArrayFormat]{
        
        var tempCoupon: [CouponArrayFormat] = []
        
        let coupon1 = CouponArrayFormat(Store: "KFC", Content:"10%OFF",Kind:"food")
        let coupon2 = CouponArrayFormat(Store: "MOS", Content:"20%OFF",Kind:"food")
        let coupon3 = CouponArrayFormat(Store: "StarBucks", Content:"100%OFF",Kind:"food")
        let coupon4 = CouponArrayFormat(Store: "7-11", Content:"45%OFF",Kind:"food")
        
        tempCoupon.append(coupon1)
        tempCoupon.append(coupon2)
        tempCoupon.append(coupon3)
        tempCoupon.append(coupon4)
        let indexPath = IndexPath(row: couponList.count - 1,section :0)
        
        return tempCoupon
    }
    
}

extension RightPage:UITableViewDataSource,UITableViewDelegate {
    
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponList.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let couponLists = couponList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCellFormat") as! CouponCellFormat

        cell.setCoupon(coupon: couponLists)
        cell.selectedBackgroundView = selectedBackgroundView

        // note that indexPath.section is used rather than indexPath.row
        //cell.textLabel?.text = self.animals[indexPath.section]

        // add border and color
        cell.backgroundColor = UIColor.init(white: 1, alpha: 0.75)
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.masksToBounds = false
        cell.layer.shadowOpacity = 0.75
        cell.layer.shadowOffset = CGSize(width: 5, height: 5)
        cell.layer.shadowRadius = 5
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = false

        return cell



    }
    
    
    
}
