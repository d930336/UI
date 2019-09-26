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
    let userTable2 = Table("notification")
    let id = Expression<Int>("id")
    let budget = Expression<Int>("budget")
    let turnSwitch = Expression<Int>("switch")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.background.layer.shadowOpacity = 1
        self.background.layer.shadowColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        self.background.layer.shadowOffset = CGSize(width: 5 ,height: 5)
        self.background.layer.shadowRadius = 5
        self.background.layer.cornerRadius = 15
        
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
    
    
    
    
  
    @IBOutlet weak var showTarget: UILabel!
    
    @IBAction func list(_ sender: Any) {
    
    
        
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
//        do {
//            let users = try self.database.prepare(self.usersTable)
//            for user in users {
//                showTarget.text = "\((user[self.budget]))"
//                print("userId: \(user[self.id]), budget: \(user[self.budget])")
//            }
//        } catch {
//            print(error)
//        }
    }
    
    @IBOutlet weak var update: UITextField!
 
    
//-------------------notification---------------------
    
    
    
    var controll:UNNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
    var controllContent:UNMutableNotificationContent = UNMutableNotificationContent()
    
    
    
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
        
        let request = UNNotificationRequest(identifier: "notification", content: controllContent, trigger: controll)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print("建立通知intial")
        })
        
        
        
        if (sender as AnyObject).isOn {
            controll = triggerOff
            controllContent = content2
            let request = UNNotificationRequest(identifier: "notification", content: controllContent, trigger: controll)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                print("建立通知off")
            })
        }else{
            
            controll = triggerOn
            controllContent = content
            let request = UNNotificationRequest(identifier: "notification", content: controllContent, trigger: controll)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                print("建立通知on")
            })
        }
        
        }
        
        //-------------------touching return-----------------------
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        //------------------delete func--------------------------
        //    @IBAction func del(_ sender: Any) {
        //
        //
        //        print("DELETE TAPPED")
        //
        //        let del = usersTable
        //        //    filter delete    let alice = usersTable.filter(id == 1)
        //        if let count = try? self.database.run(del.delete()) {
        //            print("删除的条数为：\(count)")
        //        } else {
        //            print("删除失败")
        //        }
        
        
        
        //        let alert = UIAlertController(title: "Update User", message: nil, preferredStyle: .alert)
        //        alert.addTextField { (tf) in tf.placeholder = "User ID" }
        //        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
        //            guard let userIdString = alert.textFields?.first?.text,
        //                let userId = Int(userIdString)
        //                else { return }
        //            print(userIdString)
        //
        //            let user = self.usersTable.filter(self.id == userId)
        //            let deleteUser = user.delete()
        //            do {
        //                try self.database.run(deleteUser)
        //            } catch {
        //                print(error)
        //            }
        //        }
        //        alert.addAction(action)
        //        present(alert, animated: true, completion: nil)
        //
        //
        //
    }
    
    




