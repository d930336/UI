//
//  Sqlite.swift
//  mainproject
//
//  Created by Benson Yang on 2019/5/29.
//  Copyright © 2019 Benson Yang. All rights reserved.
//
//-------excample
import UIKit
import SQLite
import UserNotifications
import SwiftJWT

class targetPage: UIViewController {
    
    var database: Connection!
    
    @IBOutlet weak var background: UIImageView!
    let usersTable = Table("targetPage1")
    let usersTable2 = Table("notification")
    let id = Expression<Int>("id")
    let budget = Expression<Int>("budget")
    let turnSwitch = Expression<Int>("switch")
    let sqDate = Expression<String>("date")
    let sqName = Expression<String>("name")
    let sqMonth = Expression<String>("month")
    let sqPrice = Expression<Int>("price")
    
//    let Token = userToken.value(forKey: "Token")
  
    // MARK:--view didLoad-
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if firstCheck == "0"{
                   //首先创建一个模糊效果
                   let blurEffect = UIBlurEffect(style: .light)
                   //接着创建一个承载模糊效果的视图
                   let blurView = UIVisualEffectView(effect: blurEffect)
                   //animation
                    let flash = CABasicAnimation(keyPath: "opacity")
                            flash.duration = 5
                            flash.fromValue = 0.5
                            flash.toValue = 1
                            flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//                            flash.autoreverses = true
                            flash.repeatCount = 0
                blurView.layer.add(flash, forKey: nil)
                   //设置模糊视图的大小（全屏）
                   blurView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
                   //添加模糊视图到页面view上（模糊视图下方都会有模糊效果）
                   self.view.addSubview(blurView)
                   self.showAlertMessage(title: "省錢生活", message: "登入以開啟其餘功能")
               }
        
        self.background.layer.shadowOpacity = 1
        self.background.layer.shadowColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        self.background.layer.shadowOffset = CGSize(width: 5 ,height: 5)
        self.background.layer.shadowRadius = 5
        self.background.layer.cornerRadius = 15
        
        alertImageControll()
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
        print("CREATE TAPPED")
        
        let createTable = self.usersTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.budget, unique: true)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
        
        let insert = usersTable.insert(budget <- 0)
        if let rowId = try? database.run(insert) {
            print("插入成功：\(rowId)")
        } else {
            print("插入失败")
        }
        
       // let del = usersTable
       let firstDel = usersTable.filter(id == 2)
        if let count = try? self.database.run(firstDel.delete()) {
            print("删除的条数为：\(count)")
        } else {
            print("删除失败")
        }
       
        print("LIST TAPPED")
        
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                
                let formatter = NumberFormatter()
                formatter.locale = Locale(identifier: "zh_TW")
                formatter.numberStyle = .currencyISOCode
                formatter.maximumFractionDigits = 0
                
                showTarget.text = formatter.string(from: NSNumber(value:(user[self.budget])))
             // showTarget.text = "\((user[(self.budget)]))"
                print("userId: \(user[self.id]), budget: \((user[self.budget]))")
            }
        } catch {
            print(error)
        }
    }
    
// MARK: view didload end
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "goToPCTest" {

            let secondVC = segue.destination as! pageviewcontroller

            secondVC.testValue = true

        }
    }
    
                // MARK:   upload
    var uploadArr  = [""]
    
    @IBAction func upload(_ sender: Any) {
      
        //button feedback
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
       
        do {
            let users = try self.database.prepare(usersTableAP)
            let session = URLSession(configuration: .default)
                                    // 设置URL
            var request = URLRequest(url: URL(string: "https://"+UrlId+".ngrok.io/useraccouting/")!)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
           
            if userToken.bool(forKey: "Token") == true{
                request.setValue("JWT "+(Token as! String), forHTTPHeaderField: "Authorization")
            }
            
            var arrCheck:[String:String]=[:]
            
                for user in users {
                          // 设置要post的内容，字典格式
//
//                    print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])")
                                
//                                   let daily = "userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])"
//                                   uploadArr.append(daily)
// MARK: - upload Post -
                    request.setValue("JWT "+(Token as! String), forHTTPHeaderField: "Authorization")

                    let postData = [
                        "accounting_class":"\(user[self.sqName])"
                        ,"accounting_data":"\(user[self.sqPrice])"
                        ,"accounting_date":"\(user[self.sqDate])"
                        ,"accounting_month":"\(user[self.sqMonth])"
                        ,"accounting_coupon_name":"\(user[sqCoupon])"
                        ,"accounting_discount":"\(user[sqSave])"
                             ]
                    let postString = postData.compactMap({ (key, value) -> String in
                              return "\(key)=\(value)"
                          }).joined(separator: "&")
                          request.httpBody = postString.data(using: .utf8)
                          // 后面不解释了，和GET的注释一样
                          
                    let task = session.dataTask(with: request) {(data, response, error) in
                              do {
                                  let r = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                  print(r)
                                  print("2")
                              } catch {
                                  print("无法连接到服务器")
                                  print("張詠峻喔")
                                  return
                              }
                          }
                          task.resume()
                        
                arrCheck = postData
            }
        } catch {
            print(error)
        }
 
        showAlertMessage(title:"已成功上傳至雲端",message:"")

    }
                    
            // MARK: Alert
    func showAlertMessage(title: String, message: String) {
        let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
        let okAction = UIAlertAction(title: "確認", style: .default, handler: nil) // 產生確認按鍵
        inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController
        self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
    }
   
    
    @IBOutlet weak var showTarget: UILabel!
 // MARK:  target upload
    @IBAction func list(_ sender: Any) {

    //button feedback
    let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        print("UPDATE TAPPED")
        guard let userIdString = update.text,
            let budget = Int(update.text ?? "0")
            else { return }
        print(userIdString)
        print(budget)

        let user = self.usersTable.filter(self.id == 1)
        let updateUser = user.update(self.budget <- budget)
        do {
            try self.database.run(updateUser)
        } catch {
            print(error)
        }

        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                
            let formatter = NumberFormatter()
                formatter.locale = Locale(identifier: "zh_TW")
                formatter.numberStyle = .currencyISOCode
                formatter.maximumFractionDigits = 0
                
                showTarget.text = formatter.string(from: NSNumber(value:(user[self.budget])))
                
                print("userId: \(user[self.id]), budget: \(user[self.budget])")
            }
        } catch {
            print(error)
        }
    }
    
    @IBOutlet weak var update: UITextField! 
 
    //MARK:- Download -
    
    @IBAction func download(_ sender: Any) {
                 // 创建一个会话，这个会话可以复用
                let session = URLSession(configuration: .default)
                // 设置URL
                var request = URLRequest(url:URL(string:"https://"+UrlId+".ngrok.io/useraccouting/")!)
                // 创建一个网络任务
        //       if userToken.bool(forKey: "Token") == true{
                request.setValue("JWT "+(Token as! String), forHTTPHeaderField: "Authorization")
        //       }
                request.httpMethod = "GET"
                let task = session.dataTask(with: request) {(data, response, error) in
                    do {
                        connectDataBase()

                        let del = usersTableAP
                        
                                if let count = try? self.database.run(del.delete()) {
                                    print("删除的条数为：\(count)")
                                } else {
                                    print("删除失败")
                                }
                        
                        let r = try JSONSerialization.jsonObject(with: data!,  options:JSONSerialization.ReadingOptions.mutableContainers)
                        
                        print(r)

                        let rArray = r as! NSArray
        
                        for i in rArray{
                           
                            let download = i as! NSDictionary
                            let sqDateInsert = "\(download["accounting_date"] ?? "")"
                            let sqNameInsert = "\(download["accounting_class"] ?? "")"
                            let sqPriceInsert = "\(download["accounting_data"] ?? "")"
                            let sqPriceFinal = Int(sqPriceInsert) ?? 0
                            let sqMonthInsert = "\(download["accounting_month"] ?? "")"
                            let sqCouponInsert = "\(download["accounting_coupon_name"] ?? "")"
                            let sqSaveInsert = "\(download["accounting_discount"] ?? "")"
                            let sqSaveFinal = Int(sqSaveInsert) ?? 0
                            
                            let insertUser = usersTableAP.insert(self.sqDate <- sqDateInsert ,self.sqName <- sqNameInsert, self.sqPrice <- sqPriceFinal,self.sqMonth <- sqMonthInsert,sqCoupon <- sqCouponInsert, sqSave <- sqSaveFinal,sqDiscount <- sqPriceFinal)
                            do {
                                try self.database.run(insertUser)
                                    } catch {
                                    print(error)
                                }
                            print(sqDateInsert,sqNameInsert,sqPriceInsert,sqMonthInsert,sqSaveFinal)
                            print(type(of: sqDateInsert),type(of: sqNameInsert),type(of: sqPriceInsert),type(of: sqMonthInsert),type(of: sqSaveFinal))
                        }
                    }catch {
                        // 如果连接失败就...
                        print("无法连接到服务器download")

                        let content = UNMutableNotificationContent()
                               content.title = "發大財"
                               //        content.subtitle = "subtitle："
                               content.body = "請先登入"
                               content.badge = 0
                               content.sound = UNNotificationSound.default
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
                                   UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                                       print("建立通知on")
                                   })
                        return
                    }
                }
                task.resume()
        showAlertMessage(title:"已成功下傳至手機",message:"")

            }
    
    // MARK:-notification--
    

    let userNotification = UserDefaults.standard
    var alertCheck = true
    
    var controll:UNNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
    var controllContent:UNMutableNotificationContent = UNMutableNotificationContent()
       
    @IBOutlet weak var alertView: UIImageView!

    @IBAction func dailyNotification(_ sender: Any) {
        
        let content = UNMutableNotificationContent()
        content.title = "省錢生活"
        //        content.subtitle = "subtitle："
        content.body = "記一筆？ 台灣發大財關心您"
        content.badge = 0
        content.sound = UNNotificationSound.default
        
        let content2 = UNMutableNotificationContent()
        content2.title = "省錢生活"
        //        content.subtitle = "subtitle："
        content2.body = "關提醒了 別忘記記帳！ 台灣發大財關心您"
        content2.badge = 0
        content2.sound = UNNotificationSound.default
        
//        let date = Date(timeIntervalSinceNow: 36000)
//        let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        let triggerOn = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let triggerOff = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        if (sender as AnyObject).isOn {
            controll = triggerOn
            controllContent = content
            let request = UNNotificationRequest(identifier: "notification", content: controllContent, trigger: controll)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                print("建立通知on")
            })
            userNotification.set(alertCheck, forKey: "userNotificationValue")
            alertCheck = false
        }else{
            controll = triggerOff
            controllContent = content2
            let request = UNNotificationRequest(identifier: "notification", content: controllContent, trigger: controll)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                print("建立通知off")
            })
            userNotification.set(alertCheck, forKey: "userNotificationValue")
            alertCheck = true
        }
        alertImageControll()
        
        }
//  MARK:- Notification View image -
    
    func alertImageControll(){
        
        let noticifationValue = userNotification.value(forKey: "userNotificationValue")
        
        if noticifationValue as! Bool? == true{
            alertView.image = UIImage(named: "alertOn")
                            }else{
            alertView.image = UIImage(named: "alertOff")
            
        }
    }
 
    @IBAction func testButton(_ sender: Any) {
      
        let printToken = userToken.value(forKey: "Token") as! String ?? ""
        
        print(printToken)
        showAlertMessage(title:printToken,message:"")
        
    }
    

        
        
// MARK: -touching return---
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
      
    }
    
    




