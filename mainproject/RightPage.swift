//
//  CouponList.swift
//  mainproject
//
//  Created by Benson Yang on 2019/3/14.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit
import SQLite
import UserNotifications

//--------------------------------------------

class RightPage: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarBack: UIImageView!
    @IBOutlet weak var searchBar: UITextField!
    
//  let cellSpacingHeight: CGFloat = 10
    let selectedBackgroundView = UIView()
    
    var couponList : [CouponArrayFormat] = []
  
    var search:String = ""
    var refreshControl:UIRefreshControl!
    var customView: UIView!
    var labelsArray: Array<UILabel> = []
    var isAnimating = false
    var currentColorIndex = 0
    var currentLabelIndex = 0
    var timer: Timer!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.attributedPlaceholder = NSAttributedString(string: "search Coupon",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    
        searchBar.textColor = UIColor.white
        
       self.refreshFunc()
        
//            self.couponTest()
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
//                    flash.autoreverses = true
                    flash.repeatCount = 0
            //设置模糊视图的大小（全屏）
            blurView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
            blurView.layer.cornerRadius = 15
            blurView.layer.add(flash, forKey: nil)
            //添加模糊视图到页面view上（模糊视图下方都会有模糊效果）
            self.view.addSubview(blurView)
        }
//        if Token != nil{
//            get()
//        }else{
//            showAlertMessage(title: "台灣發大財關心您", message: "請先登入")
//        }
        self.searchBarBack.layer.cornerRadius = 10
        
//        self.searchBarBack.layer.shadowOpacity = 1
//        self.searchBarBack.layer.shadowColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
//        self.searchBarBack.layer.shadowOffset = CGSize(width: 5 ,height: 5)
//        self.searchBarBack.layer.shadowRadius = 5
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        couponListUrl = String(couponList[indexPath.row].url)
        couponDiscount = String(couponList[indexPath.row].discount)
        couponTitle = String(couponList[indexPath.row].Store)
        couponSave = Int(couponList[indexPath.row].save) ?? 0
        print("couponDis:",couponDiscount,",couponURL:",couponListUrl,",couponTitle:",couponTitle,"couponsave:",couponSave)
        
        
        let vc = (storyboard?.instantiateViewController(withIdentifier: "couponPage"))
        vc?.modalPresentationStyle = .fullScreen
        vc?.modalTransitionStyle = .crossDissolve
                present(vc!, animated: true )
    }

    //MARK: - refresh -
    
    func refreshFunc() {
       DispatchQueue.main.async {
        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(self.refreshControl)
        self.refreshControl.tintColor = UIColor.clear
        let refreshContents = Bundle.main.loadNibNamed("RefreshContents", owner: self, options: nil)
               
        self.customView = refreshContents![0] as? UIView
        self.customView.frame = self.refreshControl.bounds
               
        for i in 0..<self.customView.subviews.count {
            self.labelsArray.append(self.customView.viewWithTag(i + 1) as! UILabel)
               }
               
        self.refreshControl.addSubview(self.customView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    DispatchQueue.main.async {
        if self.refreshControl.isRefreshing {
            if !self.isAnimating {
                self.doSomething()
                self.animateRefreshStep1()
            }
        }
    //強制用main thread執行 get()
       self.get()

        }
    }
    // MARK: Custom function implementation
    
    func loadCustomRefreshContents() {
       DispatchQueue.main.async {
        let refreshContents = Bundle.main.loadNibNamed("RefreshContents", owner: self, options: nil)
        
        self.customView = refreshContents![0] as! UIView
        self.customView.frame = self.refreshControl.bounds
        
        for i in 0..<self.customView.subviews.count {
            self.labelsArray.append(self.customView.viewWithTag(i + 1) as! UILabel)
        }
        
        self.refreshControl.addSubview(self.customView)
        }
    }
    
   //MARK:- set animate -
    
    func animateRefreshStep1() {
       
        DispatchQueue.main.async {
        
            self.isAnimating = true

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: { () -> Void in
            self.labelsArray[self.currentLabelIndex].transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi/4))
            self.labelsArray[self.currentLabelIndex].textColor = self.getNextColor()
            
            }, completion: { (finished) -> Void in
                
                UIView.animate(withDuration: 0.05, delay: 0.0, options: .curveLinear, animations: { () -> Void in
                    self.labelsArray[self.currentLabelIndex].transform = CGAffineTransform.identity
                    self.labelsArray[self.currentLabelIndex].textColor = UIColor.white
                    
                    }, completion: { (finished) -> Void in
                        self.currentLabelIndex += 1
                        
                        if self.currentLabelIndex < self.labelsArray.count {
                            self.animateRefreshStep1()
                        }
                        else {
                            self.animateRefreshStep2()
                        }
                })
            })
        }
    }
    
    func animateRefreshStep2() {
        
        DispatchQueue.main.async {
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveLinear, animations: { () -> Void in
            self.labelsArray[0].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.labelsArray[1].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.labelsArray[2].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.labelsArray[3].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.labelsArray[4].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.labelsArray[5].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.labelsArray[6].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
            }, completion: { (finished) -> Void in
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: { () -> Void in
                    self.labelsArray[0].transform = CGAffineTransform.identity
                    self.labelsArray[1].transform = CGAffineTransform.identity
                    self.labelsArray[2].transform = CGAffineTransform.identity
                    self.labelsArray[3].transform = CGAffineTransform.identity
                    self.labelsArray[4].transform = CGAffineTransform.identity
                    self.labelsArray[5].transform = CGAffineTransform.identity
                    self.labelsArray[6].transform = CGAffineTransform.identity
                    
                    }, completion: { (finished) -> Void in
                        if self.refreshControl.isRefreshing {
                            self.currentLabelIndex = 0
                            self.animateRefreshStep1()
                        }
                        else {
                            self.isAnimating = false
                            self.currentLabelIndex = 0
                            for i in 0..<self.labelsArray.count {
                                self.labelsArray[i].textColor = UIColor.white
                                self.labelsArray[i].transform = CGAffineTransform.identity
                            }
                        }
                })
            })
        }
    }
//   func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//       print("end of the row")
//   }
//
    
//MARK: - set animate colors -
    
    func getNextColor() -> UIColor {
        var colorsArray: Array<UIColor> = [UIColor(red: 1, green: 0.42, blue: 0, alpha: 1),
                                           UIColor(red: 1, green: 0.56, blue: 0.24, alpha: 1),
                                           UIColor(red: 1, green: 0.68, blue: 0.39, alpha: 1),
                                           UIColor(red: 1, green: 0.81, blue: 0.62, alpha: 1),
                                           UIColor(red: 1, green: 0.86, blue: 0.7, alpha: 1),
                                           UIColor(red: 1, green: 0.91, blue: 0.77, alpha: 1),
                                           UIColor(red: 0.98, green: 0.95, blue: 0.93, alpha: 1)]
        
        if currentColorIndex == colorsArray.count {
            currentColorIndex = 0
        }
        
        let returnColor = colorsArray[currentColorIndex]
        currentColorIndex += 1
        
        return returnColor
    }
    
//MARK:-during refresh  -
    func doSomething() {
        DispatchQueue.main.async {

            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.endOfWork), userInfo: nil, repeats: true)
        }
    }
    
    
    @objc func endOfWork() {
    DispatchQueue.main.async {

        self.refreshControl.endRefreshing()
        
        self.timer.invalidate()
        self.timer = nil
        }
    }
    
 //MARK:- test tableview func -
    
    func couponTest() {
        let coupon1 = CouponArrayFormat(Store: "KFC", Content:"10%OFF",Kind:"food",url:"https://www.facebook.com/",discount:"30",save:"9")
        let coupon2 = CouponArrayFormat(Store: "GitHub", Content:"10%OFF",Kind:"???",url:"https://github.com/d930336/UI",discount:"309", save: "141")
          couponList.append(coupon1)
          couponList.append(coupon2)
          
          let indexPath = IndexPath(row: couponList.count - 1,section :0)
        
          tableView.beginUpdates()
          tableView.insertRows(at:[indexPath], with: .automatic)
          tableView.endUpdates()
    }
    
 //MARK: - get -
    
    func get(){
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
                var r = try JSONSerialization.jsonObject(with: data!,  options:JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                let jsonString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                var controll:Int = 0
                let rArray = (r["results"]as! NSArray)
                
        if r != nil{
            
                for i in rArray{
                    
                    let couponBook = i as! NSDictionary
//                    print(couponBook["coupon_class"] ?? "")
                    let coupon1 = CouponArrayFormat(Store: "\(couponBook["coupon_title"]!)", Content:"\(couponBook["coupon_note"]!)",Kind:"\(couponBook["coupon_class"]!)", url:"\(couponBook["coupon_img"]!)",discount:"\(couponBook["coupon_price"]!)",save:"\(couponBook["coupon_saving"]!)")
                   
                    self.couponList.append(coupon1)
                    
                    self.tableView.reloadData()
                    print("\(couponBook["coupon_class"]!)","\(couponBook["coupon_class"]!)","\(couponBook["coupon_class"]!)","\(couponBook["coupon_img"]!)")
                    }
                }else{
                    print("无法连接到服务器coupon")
                                   
                                   DispatchQueue.main.async {
                                       self.showAlertMessage(title: "省錢生活", message: "請重新載入")
                                   }
                }
//                let jsonArray = NSArray(object: r["results"] as! Data) as Array

//                let jsonData:NSArray = (try JSONSerialization.jsonObject(with: r["results"]! as! Data, options:JSONSerialization.ReadingOptions.mutableContainers ) as? NSArray)!
                
//                let test:Any? =  r["results"]
                    
                //                var rResults:[String:String] = (r["results"])as! AnySequence<>
            
//                for results in (rResults){
//                    print("Store:\(results[self.rTitle])",
//                   "Content: \(results[self.rTitle])",
//                    "kind:\(results[self.rTitle])"
//                    )
//
//                }

            }catch {
                // 如果连接失败就...
                print("无法连接到服务器coupon")
                
                DispatchQueue.main.async {
                    self.showAlertMessage(title: "省錢生活", message: "請重新登入")
                }
                
//                let content = UNMutableNotificationContent()
//                       content.title = "發大財"
//                       //        content.subtitle = "subtitle："
//                       content.body = "請先登入"
//                       content.badge = 0
//                       content.sound = UNNotificationSound.default
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//                let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
//                           UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
//                               print("建立通知on")
//                           })
                return               
            }
            
        }
        // 运行此任务
        task.resume()
        }
    }
   
    
//    if r["non_field_errors"] != nil{
//         let rerror =  r["non_field_errors"]as! String
//    }
    
//    func createArray() -> [CouponArrayFormat]{
//
//        var tempCoupon: [CouponArrayFormat] = []
//
//        let coupon1 = CouponArrayFormat(Store: "KFC", Content:"10%OFF",Kind:"food")
//        let coupon2 = CouponArrayFormat(Store: "MOS", Content:"20%OFF",Kind:"food")
//        let coupon3 = CouponArrayFormat(Store: "StarBucks", Content:"100%OFF",Kind:"food")
//        let coupon4 = CouponArrayFormat(Store: "7-11", Content:"45%OFF",Kind:"food")
//
//        tempCoupon.append(coupon1)
//        tempCoupon.append(coupon2)
//        tempCoupon.append(coupon3)
//        tempCoupon.append(coupon4)
//
//        return tempCoupon
//    }
    
    //MARK: - search func -
    
    @IBAction func searchBoutton(_ sender: Any) {
       
        DispatchQueue.main.async {
        
            self.search = self.searchBar.text!
        
            // 创建一个会话，这个会话可以复用
            let session = URLSession(configuration: .default)
            // 设置URL
            if self.searchBar.text != ""{
            
            var request = URLRequest(url:URL(string:"https://"+UrlId+".ngrok.io/coupon/?search=\(self.search)")!)
                       // 创建一个网络任务
               //       if userToken.bool(forKey: "Token") == true{
                       request.setValue("JWT "+String(Token as! String) ?? "", forHTTPHeaderField: "Authorization")
               //       }
                       request.httpMethod = "GET"

                       let task = session.dataTask(with: request) {(data, response, error) in
                           do {
                               // 返回的是一个json，将返回的json转成字典r
                               var r = try JSONSerialization.jsonObject(with: data!,  options:JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                               
                               let jsonString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                             
                               let rArray = (r["results"]as! NSArray)
                               
                        if r != nil{
                            
                               for i in rArray{
                                   
                                   let couponBook = i as! NSDictionary
               //                    print(couponBook["coupon_class"] ?? "")
                                   let coupon1 = CouponArrayFormat(Store: "\(couponBook["coupon_title"]!)", Content:"\(couponBook["coupon_note"]!)",Kind:"\(couponBook["coupon_class"]!)", url:"\(couponBook["coupon_img"]!)",discount:"\(couponBook["coupon_price"]!)",save:"\(couponBook["coupon_saving"]!)")
                                  
                                   self.couponList.append(coupon1)
                                   
                                   self.tableView.reloadData()
                                   print("\(couponBook["coupon_class"]!)","\(couponBook["coupon_class"]!)","\(couponBook["coupon_class"]!)","\(couponBook["coupon_img"]!)")
                                }
                        }else{
                            
                            }

                           }catch {
                               // 如果连接失败就...
                               print("无法连接到服务器coupon")
                               return
                           }
                           
                       }
                
                       // 运行此任务
                       task.resume()
                  
                   }else{
                    self.searchBar.endEditing(true)
                   }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

            textField.resignFirstResponder()
        return true
    }

//
           // MARK: Alert
    
    func showAlertMessage(title: String, message: String) {
        

        let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
        let okAction = UIAlertAction(title: "確認", style: .default, handler: nil) // 產生確認按鍵
        inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController
        self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
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
        cell.url.text = couponLists.url
        cell.discount.text = couponLists.discount
        cell.Store.text = couponLists.Store
        cell.save.text = couponLists.save
        
        return cell

    }
    
    
    
}
