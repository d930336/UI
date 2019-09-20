//
//  CouponList.swift
//  mainproject
//
//  Created by Benson Yang on 2019/3/14.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit
import SQLite

//connection
struct WebSiteDescription:Decodable{
    let count:Int
//    let next:Int
//    let previous:Int
    let results:[Result]
}


struct Result: Decodable{
    
    //Due to prevent data missing field
    let coupon_id:String
    let coupon_content:String
    //    let link:String?
    //    let imageUrl:String?
}
//-------------previous-------------
//struct CouponsList:Decodable{
//    let count:Int
//    let next:Int
//    let previous:String
//}

//--------------------------------------------

class CouponList: UITableViewController {
    
    @IBOutlet var tableview: UITableView!
    
    let cellSpacingHeight: CGFloat = 10
    let selectedBackgroundView = UIView()
    
    var coupon : [Coupon] = []
    
    var database: Connection!
    let usersTable = Table("Token1")
    let id = Expression<Int>("id")
    let token = Expression<String>("token")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedBackgroundView.backgroundColor = UIColor.clear
        
        coupon = createArray()
//_______________sqlite connect______________
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            
            self.database = database
            print("connected")
        } catch {
            print(error)
        }
        
//        print("CREATE TAPPED")
//
//        let createTable = self.usersTable.create { (table) in
//            table.column(self.id, primaryKey: true)
//            table.column(self.token, unique: true)
//        }
//        do {
//            try self.database.run(createTable)
//            print("Created Table")
//        } catch {
//            print(error)
//        }
        
        print("LIST TAPPED")
        
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
               
                print("token: \(user[self.token])")
                print("tokenId: \(user[self.id])")
            }
        } catch {
            print(error)
        }
//---------------connection------------------
        let JsonURL = "http://4bf3838d.ngrok.io/coupons/"
        
        guard let url = URL(string: JsonURL) else {return}
        
        URLSession.shared.dataTask(with: url){  (data,response,err)in
            
            
            guard let data = data else {return}
            //            let dataString = String(data: data,encoding: .utf8)
            //            print("dataString:",dataString)
            //
            
            do{
                
                //data inconsistent(missing field)
                let webSiteDescription = try JSONDecoder().decode(WebSiteDescription.self, from: data)
                let web = webSiteDescription.results
                
                for i in web{
                    print(i)
                }
                
//                let CouponId = results.coupon_id
//
//                let CouponCotent = results.coupon_content
                
//                print("coursers",CouponId)
//                print("users",CouponCotent)
            }catch let jsonErr{
                print("Error",jsonErr)
            }
            
            
            
            }.resume()
        
        
    }

    
    
    func tableView(_ tableView: UITableView, heightForFootererInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFootererInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    // Set the spacing between sections
    /*override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    */
    // Make the background color show through
     override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let headerView = UIView()
     headerView.backgroundColor = UIColor.clear
     return headerView
     }
 
    //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
    
   
    
    
    
    
    
    
    func createArray() -> [Coupon]{
        
        var tempCoupon: [Coupon] = []
        
        let coupon1 = Coupon(Store: "KFC", Discount :"10%OFF")
        let coupon2 = Coupon(Store: "MOS", Discount :"10%OFF")
        let coupon3 = Coupon(Store: "StarBucks", Discount :"10%OFF")
        let coupon4 = Coupon(Store: "7-11", Discount :"10%OFF")
        let coupon5 = Coupon(Store: "Family", Discount :"10%OFF")
        let coupon6 = Coupon(Store: "OK", Discount :"10%OFF")
        
        tempCoupon.append(coupon1)
        tempCoupon.append(coupon2)
        tempCoupon.append(coupon3)
        tempCoupon.append(coupon4)
        tempCoupon.append(coupon5)
        tempCoupon.append(coupon6)
        
        return tempCoupon
    }
    
}

extension CouponList {
    
 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coupon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coupons = coupon[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell") as! CouponCell
        
        cell.setCoupon(coupon: coupons)
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
