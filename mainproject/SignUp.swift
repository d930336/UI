import UIKit
import Foundation


class SignUp: UIViewController,UITextFieldDelegate {
    

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var eamil: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    var sentUsername:String = ""
    var sentPassword:String = ""
    
    @IBAction func signup(_ sender: Any) {
    
        
        
        // 这个session可以使用刚才创建的。
        let session = URLSession(configuration: .default)
        // 设置URL
        var request = URLRequest(url: URL(string: "https://"+UrlId+".ngrok.io/rest-auth/registration/")!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // 设置要post的内容，字典格式
        
        let postData = ["username":"\(String(username.text!))"
            ,"email":"\(String(eamil.text!))"
            ,"password1":"\(String(password1.text!))"
            ,"password2":"\(String(password2.text!))"]
        
        sentUsername="\(String(username.text!))"
        sentPassword="\(String(password1.text!))"
        
        let postString = postData.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)
        // 后面不解释了，和GET的注释一样
        print("5")
        let task = session.dataTask(with: request) {(data, response, error) in
            do {
                let r = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                print(r)
                print("2")
                
                DispatchQueue.main.async {
                    self.showAlertMessage(title: "註冊成功", message: "已發送認證信")
                }
            } catch {
                print("无法连接到服务器")
                print("張詠峻喔")
                print(error)
                DispatchQueue.main.async {
                    self.showAlertMessage(title: "註冊失敗", message: "\(error)")
                }
                
                return
            }
        }
        task.resume()
    
        
//        self.performSegue(withIdentifier: "sentToLogin", sender: nil)
//        print("3")
    }
    
    //MARK: - view did load -
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
              edgePan.edges = .right
              
              view.addGestureRecognizer(edgePan)
        
        
    }
    //MARK:- end of view did load -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
          if segue.identifier == "sentToLogin" {

              let secondVC = segue.destination as! LogIn
                
                sentUsername="\(String(username.text!))"
                sentPassword="\(String(password1.text!))"
            secondVC.receiveUsername = sentUsername
            secondVC.receivePassword = sentPassword
                
          }
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
                    let vc = (storyboard?.instantiateViewController(withIdentifier: "logIn"))
                    vc?.modalPresentationStyle = .fullScreen
                    vc?.modalTransitionStyle = .crossDissolve
            
            
            
            
            
            
            
            
            
            
            
            
            
            present(vc!, animated: true )

        //            show((storyboard?.instantiateViewController(withIdentifier: "pageController"))! , sender: nil)
                }
    }
    
   // MARK: Alert
     func showAlertMessage(title: String, message: String) {
        let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
        let okAction = UIAlertAction(title: "確定", style: .cancel, handler: nil) // 產生確認按鍵
         inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController
         DispatchQueue.main.async {
         self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
         }
     }
    
}
