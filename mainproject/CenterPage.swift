//
//  CenterPage.swift
//  mainproject
//
//  Created by Benson Yang on 2019/4/11.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit
import SwiftCharts
import SQLite
import PieCharts

class CenterPage: UIViewController, PieChartDelegate {

    var database: Connection!
   
    //MARK:target page sq var
    
    let usersTableTP = Table("targetPage1")
    let id = Expression<Int>("id")
    let budget = Expression<Int>("budget")
    
    //MARK:daily detail sq var

    let sqDate = Expression<String>("date")
    let sqName = Expression<String>("name")
    let sqPrice = Expression<Int>("price")
    
    //MARK:pie chart
    
    @IBOutlet weak var pie: PieChart!
    static let alpha: CGFloat = 0.8
    let colors = [
        UIColor(red: 0.06, green: 0.23, blue: 0.31, alpha: 1).withAlphaComponent(alpha),
        
        UIColor(red: 1, green: 0.69, blue: 0.13, alpha: 1).withAlphaComponent(alpha),
               
        UIColor(red: 1, green: 0.81, blue: 0.62, alpha: 1).withAlphaComponent(alpha),
        
        UIColor(red: 0.98, green: 0.95, blue: 0.93, alpha: 1).withAlphaComponent(alpha),
        UIColor(red: 1, green: 0.42, blue: 0, alpha: 1),
        UIColor(red: 1, green: 0.56, blue: 0.24, alpha: 1),
        UIColor(red: 1, green: 0.68, blue: 0.39, alpha: 1),
        UIColor(red: 1, green: 0.81, blue: 0.62, alpha: 1),
        UIColor(red: 1, green: 0.86, blue: 0.7, alpha: 1),
        UIColor(red: 1, green: 0.91, blue: 0.77, alpha: 1),
        UIColor(red: 0.98, green: 0.95, blue: 0.93, alpha: 1)
    ]
    
    @IBOutlet weak var showNumber: UILabel!

    var showingNumber : Int = 0
    var accountingSum : Int = 0
    var targetBudget : Int = 0
    
    @IBOutlet weak var LastMouth: UIImageView!

    @IBAction func couponPage(_ sender: Any) {
        self.performSegue(withIdentifier: "goToPC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToPC" {
            
            let secondVC = segue.destination as! pageviewcontroller
            
            secondVC.received = 2
            
        }
    }
    
    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
    }
    
    @IBOutlet weak var loginButtonView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
            if firstCheck == "1" {
            loginButtonView.image = UIImage(named: "UserOnLine")
            }else{
                loginButtonView.image = UIImage(named: "UserOffLine")
            }
        
        
//    override func viewDidAppear(_ animated: Bool) {
//            if firstCheck == 1{
//            //  if loginViewControll != ""{
//                if firstCheck == 1 {
//                loginButtonView.image = UIImage(named: "UserOnLine")
//                }else{
//                    loginButtonView.image = UIImage(named: "UserOffLine")
//                }
//        }
        
        //MARK:pie chart set up
        
        pie.layers = [createCustomViewsLayer(), createTextWithLinesLayer(),createPlainTextLayer()]
        pie.delegate = self
        pie.models = createModels()
        
       //MARK: sqlite connect
        
        connectDataBase()
        do {

            //MARK: - get month data -
            let todaysDate =  Calendar.current.date(byAdding: .month, value: 0, to: Date())
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MM"
            let monthString = monthFormatter.string(from: todaysDate!)
            let monthdata = monthString
            
      
            let lastMonthSum = usersTableAP
                .filter(sqMonth == monthdata)
                .select(self.sqPrice.sum,sqMonth).group(sqMonth)
            if firstCheck == "1" {
                if secondCheck == true{
                for user  in (try? databaseCon.prepare(lastMonthSum))! {
                      
                        if user[self.sqPrice.sum] != 0 ,"\(user[sqMonth])" != nil{
                        print("\(user[sqPrice.sum]!)","\(user[sqMonth])")
                            
                            let showingNumber = Float(accountingSum)
                            showNumber.text! = String("\(user[sqPrice.sum]!)")
                            }else{
                                print("dateSum: "+"0")
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
        
     //MARK:- block layout -
        
        self.LastMouth.layer.shadowOpacity = 1
        self.LastMouth.layer.shadowColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        self.LastMouth.layer.shadowOffset = CGSize(width: 5 ,height: 5)
        self.LastMouth.layer.shadowRadius = 5
        self.LastMouth.layer.cornerRadius = 100

}
    //MARK: - connect SQlite -
//    func connectSqlite(){
//        do {
//                   let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//                   let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
//                    let database = try Connection(fileUrl.path)
//                    self.database = database
//                  } catch {
//                      print("connect error")
//                  }
//    }
            //MARK: - insert pie -
   func createModels() -> [PieSliceModel] {
          
    var models: [PieSliceModel] = []

           connectDataBase()

           do {
                //MARK: - get month data -
                let todaysDate =  Calendar.current.date(byAdding: .month, value: 0, to: Date())
                let monthFormatter = DateFormatter()
                monthFormatter.dateFormat = "MM"
                let monthString = monthFormatter.string(from: todaysDate!)
                let monthdata = monthString
            if secondCheck == true{
                let lastMonthKind = usersTableAP
                           .filter(sqMonth == monthdata)
                           .select(self.sqPrice.sum,sqName).group(sqName)
                for user  in (try! databaseCon.prepare(lastMonthKind)) {
                                                
                        let randomColor = Int.random(in: 0...10)
                        let model =
                            PieSliceModel(
                                value:Double(user[sqPrice.sum]!)
                                ,color: colors[randomColor]
                                ,obj:String("\(user[sqName])")
                            )
                        models.append(model)
                    }
                }
           } catch {
               print(error)
           }
    
            print(models)
           return models
       }
    
        // MARK: - pie Layers
        
         func createPlainTextLayer() -> PiePlainTextLayer {

            let textLayerSettings = PiePlainTextLayerSettings()
            textLayerSettings.viewRadius = 90
            textLayerSettings.hideOnOverflow = true
            textLayerSettings.label.font = UIFont.systemFont(ofSize: 10)

            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            textLayerSettings.label.textGenerator = {slice in
                return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
            }

            let textLayer = PiePlainTextLayer()
            textLayer.settings = textLayerSettings
            return textLayer
        }
        
        func createCustomViewsLayer() -> PieCustomViewsLayer {
            let viewLayer = PieCustomViewsLayer()
            
            let settings = PieCustomViewsLayerSettings()
            settings.viewRadius = 135
            settings.hideOnOverflow = true
            viewLayer.settings = settings
            
            viewLayer.viewGenerator = createViewGenerator()
            
            return viewLayer
        }
    
        func createTextWithLinesLayer() -> PieLineTextLayer {
            let lineTextLayer = PieLineTextLayer()
            var lineTextLayerSettings = PieLineTextLayerSettings()
            lineTextLayerSettings.lineColor = UIColor.lightGray
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 14)
            lineTextLayerSettings.label.textGenerator = {slice in
                return formatter.string(from: slice.data.model.value as NSNumber).map{"\($0)"} ?? ""
            }

            lineTextLayer.settings = lineTextLayerSettings
            return lineTextLayer

        }
        func createViewGenerator() -> (PieSlice, CGPoint) -> UIView {
        return {slice, center in
            
            let container = UIView()
            container.frame.size = CGSize(width: 100, height: 40)
            container.center = center
            let view = UIImageView()
            view.frame = CGRect(x: 30, y: 0, width: 40, height: 40)
            container.addSubview(view)
            
            let tranObj = slice.data.model.obj as! String
            
//            if tran == "Food" || slice.data.id == 1 {
                           let specialTextLabel = UILabel()
                           specialTextLabel.textAlignment = .center
               
                if tranObj == "食物"{
                               specialTextLabel.text = "食物"
                           }else if tranObj == "其他" {
                               specialTextLabel.text = "其他"
                           }else if tranObj == "土地" {
                               specialTextLabel.text = "土地"
                           }else if tranObj == "零食" {
                               specialTextLabel.text = "零食"
                           }else if tranObj == "工具" {
                               specialTextLabel.text = "工具"
                           }else if tranObj == "交通" {
                               specialTextLabel.text = "交通"
                           }else if tranObj == "飲料" {
                               specialTextLabel.text = "飲料"
                           }
                           specialTextLabel.sizeToFit()
                           specialTextLabel.font = UIFont.boldSystemFont(ofSize: 10)
                           specialTextLabel.frame = CGRect(x: 0, y: 40, width: 100, height: 20)
                           container.addSubview(specialTextLabel)
                           container.frame.size = CGSize(width: 100, height: 60)
//                       }
            return container
                }
            
        }
//      @IBAction func onPlusTap(sender: UIButton) {
//        let newModel = PieSliceModel(value: 4 * Double(CGFloat.random()), color: colors[currentColorIndex])
//        pie.insertSlice(index: 0, model: newModel)
//        currentColorIndex = (currentColorIndex + 1) % colors.count
//        if currentColorIndex == 2 {currentColorIndex += 1} // avoid same contiguous color
//    }
   
    
        // MARK: Alert
    func showAlertMessage(title: String, message: String) {
            let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
            let okAction = UIAlertAction(title: "確認", style: .default, handler: nil) // 產生確認按鍵
            inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController
            self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
        }
}
