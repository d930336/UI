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

class LogIn: UIViewController,UITextFieldDelegate {
   
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    var receiveUsername:String = ""
    var receivePassword:String = ""
    
    @IBAction func login(_ sender: Any) {

        userToken.set(username.text! , forKey: "userId")
        userToken.set(password.text!, forKey:"userPassword")
        firstCheck = "1"
        userToken.set(firstCheck, forKey: "firstCheck")
        userToken.synchronize()

        print("INSERT TAPPED")
//MARK: - Post -
        // 这个session可以使用刚才创建的。
        let session = URLSession(configuration: .default)
        // 设置URL
        var request = URLRequest(url:URL(string:"https://"+UrlId+".ngrok.io/api-token-auth/")!)
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
                let rToken = r["token"]as! String
                //MARK: - store the Token -
                self.showAlertMessage(title:"登入成功",message:"")

                    userToken.set(rToken , forKey: "Token")
                    userToken.synchronize()

                if r["non_field_errors"] != nil{
                     let rerror =  r["non_field_errors"]as! String
                    self.showAlertMessage(title:"登入失敗",message:rerror)
                }

        } catch {
                print("无法连接到服务器")
                print("張詠峻喔")
            self.showAlertMessage(title:"登入失敗",message:"伺服器未開")
                return
            }
        }
        task.resume()
        print("done")
    
//-------------------------------get toturial------------------------------------
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
    
    //MARK:- Log out -

    @IBAction func logOut(_ sender: Any) {
        userToken.set("" , forKey: "Token")
        userToken.set("" , forKey: "userId")
        userToken.set("", forKey: "userPassword")
        showAlertMessage(title:"登出成功",message:"")
        firstCheck = "0"
        userToken.set(0, forKey: "firstCheck")
        userToken.synchronize()
        username.text = ""
        password.text = ""
        logoutCheck = true
    }

            // MARK: Alert
    func showAlertMessage(title: String, message: String) {
        let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
        let okAction = UIAlertAction(title: "確認", style: .default, handler: nil) // 產生確認按鍵
        inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController
        DispatchQueue.main.async {
        self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
        }
    }
            
  //MARK: -  set max lengh to text  -
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 15
    }
    
    
    // MARK: - SQlite -
    var database: Connection!
    let usersTable = Table("Token1")
    let id = Expression<Int>("id")
    let token = Expression<String>("token")

    override func viewDidLoad() {
        super.viewDidLoad()
             
        if receiveUsername != ""||receivePassword != ""{
        username.text = receiveUsername
        password.text = receivePassword
        }else{
            if firstCheck == "1"{
        username.text = "\(getUserId)"
        password.text = "\(getUserPassword)"
            }
        }
        //MARK: - swipe -
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
              edgePan.edges = .right
              
              view.addGestureRecognizer(edgePan)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

            textField.resignFirstResponder()
        return true
    }


    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            let vc = (storyboard?.instantiateViewController(withIdentifier: "pageController"))
            vc?.modalPresentationStyle = .fullScreen
            vc?.modalTransitionStyle = .crossDissolve
                    present(vc!, animated: true )

                }
    }
    
}
func prepare(for segue: UIStoryboardSegue, sender: Any?) {

      if segue.identifier == "goToPC" {

          let secondVC = segue.destination as! pageviewcontroller

          secondVC.received = 1

      }
  }
