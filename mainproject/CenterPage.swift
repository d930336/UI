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

class CenterPage: UIViewController {
    
    
    var database: Connection!
    //-------------------target page sq var----------------
    
    let usersTableTP = Table("targetPage1")
    let id = Expression<Int>("id")
    let budget = Expression<Int>("budget")
    
    //----------------daily detail sq var-----------------
    
    let usersTableAP = Table("AccountingPage1")
    let sqDate = Expression<String>("date")
    let sqName = Expression<String>("name")
    let sqPrice = Expression<Int>("price")
    
    var showingNumber : Int = 0
    var accountingSum : Int = 0
    var targetBudget : Int = 0
    var chartViewLeft : BarsChart!
    var chartViewRight : BarsChart!
    @IBOutlet weak var LastMouth: UIImageView!
    
    @IBOutlet weak var ThisMouth: UIImageView!
    
    @IBAction func couponPage(_ sender: Any) {
        self.performSegue(withIdentifier: "goToPC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToPC" {
            
            let secondVC = segue.destination as! pageviewcontroller
            
            secondVC.received = 2
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        //----------------sqlite connect---------------------
//        do {
//            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
//            let database = try Connection(fileUrl.path)
//            self.database = database
//        } catch {
//            print(error)
//        }
//
//
//        //------------------target page sq--------------
//
//        print("TPLIST TAPPED")
//
//        do {
//            let users1 = try self.database.prepare(self.usersTableTP)
//            for user in users1 {
//
//                print("userId: \(user[self.id]), budget: \(user[self.budget])")
//                targetBudget = Int(user[self.budget])
//            }
//
//            //----------------daily detail sq---------------
//            print("APLIST TAPPED")
//
//            let users2 = try self.database.prepare(self.usersTableAP)
//            for user in users2 {
//
//                print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])")
//            }
//            let query = usersTableAP.select(self.sqPrice.sum,sqName)
//            for user  in (try? database?.prepare(query))!! {
//                if user[self.sqPrice.sum] ?? 0 > 0 {
//                    accountingSum = user[self.sqPrice.sum]!
//                    print("Accounting sum:  \(user[self.sqPrice.sum]!)")
//                }else{
//                    print("0")
//                }
//
//            }
//
//            let numberTrans = String(format: "%.2f", Float(accountingSum)/Float(targetBudget)*100)
//            let showingNumber = Float(numberTrans)
//            print(showingNumber!,"\(accountingSum),\(targetBudget)")
//        } catch {
//            print(error)
//        }
        
        //----------------bar chart----------
        self.LastMouth.layer.shadowOpacity = 1
        self.LastMouth.layer.shadowColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        self.LastMouth.layer.shadowOffset = CGSize(width: 5 ,height: 5)
        self.LastMouth.layer.shadowRadius = 5
        self.LastMouth.layer.cornerRadius = 15
        
        self.ThisMouth.layer.shadowOpacity = 1
        self.ThisMouth.layer.shadowColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        self.ThisMouth.layer.shadowOffset = CGSize(width: 5 ,height: 5)
        self.ThisMouth.layer.shadowRadius = 5
        self.ThisMouth.layer.cornerRadius = 15
        
    
    
    let chartConfig = BarsChartConfig(
        valsAxisConfig : ChartAxisConfig(from:0 , to:100 ,by:10)
    )
    
    let frameLeft = CGRect(x : 30 , y : 630 ,width:138,height:31)
    let frameRight = CGRect(x : 210 , y : 630 ,width:138,height:31)
        
        
    let  chartLeft = BarsChart(
        frame : frameLeft,
        chartConfig : chartConfig,
        xTitle : "",
        yTitle : "",
        bars :[
            ("",50)
        ],
        color:UIColor.init(displayP3Red: 1, green: 0.81, blue: 0.62, alpha: 1),
        barWidth: 30
        
    )
    let  chartRight = BarsChart(
            frame : frameRight,
            chartConfig : chartConfig,
            xTitle : "",
            yTitle : "",
            bars :[
                ("",50)
            ],
            color:UIColor.init(displayP3Red: 1, green: 0.81, blue: 0.62, alpha: 1),
            barWidth: 30
            
        )
        
        
    _ = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.clear, linesWidth: 0)
    // let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: ChartAxisLayer, yAxisLayer: ChartAxisLayer, settings: guidelinesLayerSettings)
    
    
    self.view.addSubview(chartLeft.view)
    self.chartViewLeft = chartLeft
        
    self.view.addSubview(chartRight.view)
    self.chartViewRight = chartRight
    
}

   
}
