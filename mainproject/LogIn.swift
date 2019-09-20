//
//  LogIn.swift
//  mainproject
//
//  Created by Benson Yang on 2019/6/11.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class LogIn: UIViewController {
   

    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
   
    @IBAction func login(_ sender: Any) {
  
        print("1")
        print("INSERT TAPPED")
        
        

        
        // 这个session可以使用刚才创建的。
        let session = URLSession(configuration: .default)
        // 设置URL
        let url = "https://1e70f92c.ngrok.io/api-token-auth/"
        var request = URLRequest(url:URL(string:"https://1e70f92c.ngrok.io/api-token-auth/")!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 设置要post的内容，字典格式
        
        let postData = ["username":"\(String(username.text!))"
            ,"password":"\(String(password.text!))"
            ]
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)

        print("3")
        let task = session.dataTask(with: request) {(data, response, error) in
            do {
               
                let r = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print(r)
                print("2")
                let rToken = "1"
                let rerror =  "2"
                
                if r["token"] != nil{
                    let rToken =  r["token"]as! String
                    let insertUser =
                        self.usersTable.insert(
                            self.token <- rToken as! String
                    )
                    do {
                        try self.database.run(insertUser)
                        print("INSERTED USER")
                        
                    }catch {
                        print(error)
                    }
                }
               
                if r["non_field_errors"] != nil{
                     let rerror =  r["non_field_errors"]as! String
                    
                }
               
//                    let insertUser =
//                    self.usersTable.insert(
//                        self.token <- rToken as! String
//                    )
//                    do {
//                        try self.database.run(insertUser)
//                        print("INSERTED USER")
//
//                    }catch {
//                        print(error)
//                    }
                
                
            } catch {
                print("无法连接到服务器")
                print("張詠峻喔")
                return
            }
        }
        task.resume()
        
        
        print("2")
//-------------------------------get------------------------------------
//    // 创建一个会话，这个会话可以复用
//    let session = URLSession(configuration: .default)
//    // 设置URL
//    let url = "https://ae225c0c.ngrok.io/users/login/"
//    var UrlRequest = URLRequest(url: URL(string:"https://ae225c0c.ngrok.io/users/login/")!)
//    // 创建一个网络任务
//    let task = session.dataTask(with: UrlRequest) {(data, response, error) in
//        do {
//            // 返回的是一个json，将返回的json转成字典r
//            let r = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
//            print(r)
//        } catch {
//            // 如果连接失败就...
//            print("无法连接到服务器")
//            return
//        }
//    }
//    // 运行此任务
//    task.resume()
//-----------------------------------------------------------------------
  
}
    var database: Connection!
    let usersTable = Table("Token1")
    let id = Expression<Int>("id")
    let token = Expression<String>("token")

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            
            self.database = database
            print("connected")
        } catch {
            print(error)
        }
        
        print("CREATE TAPPED")
        
        let createTable = self.usersTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.token, unique: false)
        }
        do {
            try self.database.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

            textField.resignFirstResponder()
        return true
    }


}
