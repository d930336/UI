import UIKit
import Foundation


class SignUp: UIViewController {
    

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var eamil: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    
    
    @IBAction func signup(_ sender: Any) {
    
    
    
    print("1")
        
        
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
            } catch {
                print("无法连接到服务器")
                print("張詠峻喔")
                return
            }
        }
        task.resume()
        
        
        print("3")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
