//
//  CouponPage.swift
//  mainproject
//
//  Created by Benson Yang on 2019/11/8.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import Foundation
import UIKit
import SQLite

//--------------------------------------------

public var usersTableCP = Table("CouponPage")
public var sqcouponListUrl = Expression<String>("url")
public var sqcouponDiscount = Expression<String>("discount")
public var sqcouponTitle = Expression<String>("title")
public var sqcouponSave = Expression<Int>("save")

        
public func getToSqlite(){
       DispatchQueue.main.async {

        // 创建一个会话，这个会话可以复用
        let session = URLSession(configuration: .default)
        // 设置URL

        var request = URLRequest(url:URL(string:"https://"+UrlId+".ngrok.io/coupon/?page=3")!)
        // 创建一个网络任务
//       if userToken.bool(forKey: "Token") == true{
        request.setValue("JWT "+String(Token as! String) ?? "", forHTTPHeaderField: "Authorization")
//       }
        request.httpMethod = "GET"

        let task = session.dataTask(with: request) {(data, response, error) in
            do {
                // 返回的是一个json，将返回的json转成字典r
                let r = try JSONSerialization.jsonObject(with: data!,  options:JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
//                let jsonString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
              
                let rArray = (r["results"]as! NSArray)
                           
                for i in rArray{
                    
                let couponBook = i as! NSDictionary
                    
//                guard let store = "\(couponBook["coupon_title"]!)",
//                        let content = "\(couponBook["coupon_note"]!)"
//                        
//                    else { return }
//                          
//                           let user = usersTableCP
//                           let updateUser = user.update(self.budget <- budget)
//                           do {
//                               try self.database.run(updateUser)
//                           } catch {
//                               print(error)
//                           }
                    
                    let coupon1 = CouponArrayFormat(Store: "\(couponBook["coupon_title"]!)", Content:"\(couponBook["coupon_note"]!)",Kind:"\(couponBook["coupon_class"]!)", url:"\(couponBook["coupon_img"]!)",discount:"\(couponBook["coupon_price"]!)",save:"\(couponBook["coupon_saving"]!)")
                   print("\(couponBook["coupon_class"]!)","\(couponBook["coupon_class"]!)","\(couponBook["coupon_class"]!)","\(couponBook["coupon_img"]!)")
                }

            }catch {
                // 如果连接失败就...
                print("无法连接到服务器coupon")

                return
            }
            
        }
        // 运行此任务
        task.resume()
        }
    
   
    
}

