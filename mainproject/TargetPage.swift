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

class targetPage: UIViewController {
    
    var database: Connection!
    
    @IBOutlet weak var background: UIImageView!
    let usersTable = Table("targetPage1")
    let usersTable2 = Table("notification")
    let usersTableUpload = Table("AccountingPage1")
    let id = Expression<Int>("id")
    let budget = Expression<Int>("budget")
    let turnSwitch = Expression<Int>("switch")
    let sqDate = Expression<String>("date")
    let sqName = Expression<String>("name")
    let sqPrice = Expression<Int>("price")
    
    
    // MARK:--view didLoad-
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                showTarget.text = "\((user[(self.budget)]))"
                print("userId: \(user[self.id]), budget: \((user[self.budget]))")
            }
        } catch {
            print(error)
        }
    }
// MARK: view didload end
    
    
    @IBAction func test2(_ sender: Any) {
        self.performSegue(withIdentifier: "goToPCTest", sender: nil)
    }
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
            let users = try self.database.prepare(self.usersTableUpload)
            for user in users {
                
                print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])")
             
                let daily = "userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])"
                
                uploadArr.append(daily)
            }
            
        } catch {
            print(error)
        }
        print(uploadArr)
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
 // MARK:  target update
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
                showTarget.text = "\((user[self.budget]))"
                print("userId: \(user[self.id]), budget: \(user[self.budget])")
            }
        } catch {
            print(error)
        }
    }
    
    @IBOutlet weak var update: UITextField!
 
    
    // MARK:-notification--
    

    let userNotification = UserDefaults.standard
    var alertCheck = true
    
    var controll:UNNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
    var controllContent:UNMutableNotificationContent = UNMutableNotificationContent()
       
    @IBOutlet weak var alertView: UIImageView!

    @IBAction func dailyNotification(_ sender: Any) {
        
        let content = UNMutableNotificationContent()
        content.title = "發大財"
        //        content.subtitle = "subtitle："
        content.body = "記一筆？ 台灣發大財關心您"
        content.badge = 0
        content.sound = UNNotificationSound.default
        
        let content2 = UNMutableNotificationContent()
        content2.title = "發大財"
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
//  MARK:- Alert View image -
    
    func alertImageControll(){
        
        let noticifationValue = userNotification.value(forKey: "userNotificationValue")
        
        if noticifationValue as! Bool? == true{
            alertView.image = UIImage(named: "alertOn")
                            }else{
            alertView.image = UIImage(named: "alertOff")
            
        }
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
    
    




