//
//  RightChartPage.swift
//  mainproject
//
//  Created by Benson Yang on 2019/10/9.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit
import SwiftCharts
import SQLite

class RightChartPage: UIViewController {
    var chartViewLeft : BarsChart!
    
    //---------------sqlite--------------------
    
    var database: Connection!
    
    let id = Expression<Int>("id")
    let sqDate = Expression<String>("date")
    let sqName = Expression<String>("name")
    let sqPrice = Expression<Int>("price")

    
    override func viewDidLoad() {
        super.viewDidLoad()
            sqliteConnect()
        
        
    //MARK: -bar chart-
   
            let chartConfig = BarsChartConfig(
                valsAxisConfig : ChartAxisConfig(from:0 , to:100 ,by:10)
            )
            
            let frameLeft = CGRect(x : 0 , y : 100 ,width:350,height:300)
             
            let  chartLeft = BarsChart(
                frame : frameLeft,
                chartConfig : chartConfig,
                xTitle : "",
                yTitle : "",
                bars :[
                    ("9",50),
                    ("10",30)
                ],
                color:UIColor.init(displayP3Red: 1, green: 0.81, blue: 0.62, alpha: 1),
                barWidth: 25
                
            )
           
            _ = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.clear, linesWidth: 0)
            // let guidelinesLayer = ChartGuideLinesDottedLayer(xAxisLayer: ChartAxisLayer, yAxisLayer: ChartAxisLayer, settings: guidelinesLayerSettings)
        
            self.view.addSubview(chartLeft.view)
            self.chartViewLeft = chartLeft
            
        }

    //MARK: - sqlite connect  -
    func sqliteConnect(){
        do {
              let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
              let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
              let database = try Connection(fileUrl.path)
              
              self.database = database
              print("connected")
          } catch {
              print(error)
          }
    }
    
    }
    

    

