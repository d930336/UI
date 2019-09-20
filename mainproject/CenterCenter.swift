
import UIKit
import SwiftCharts
import SQLite
import UserNotifications

class CenterCenter: UIViewController {
    
    var chartView : BarsChart!
//----------------------balance------------------------
    
    @IBOutlet weak var todaySave: UILabel!
    @IBOutlet weak var todayBalance: UILabel!
    
//----------------------sqlite----------------------------
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
    
    @IBOutlet weak var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 //--------------notification---------------
        
    
        let content = UNMutableNotificationContent()
        content.title = "發大財"
//        content.subtitle = "subtitle："
        content.body = "本月餘額已用盡"
        content.badge = 1
        content.sound = UNNotificationSound.default
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        
        
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
//            print("成功建立通知...")
//        })
        
//----------------sqlite connect---------------------
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
 
        
        self.background.layer.shadowOpacity = 1
        self.background.layer.shadowColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        self.background.layer.shadowOffset = CGSize(width: 5 ,height: 5)
        self.background.layer.shadowRadius = 5
        
        


        _ = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.clear, linesWidth: 0)

        
//------------------target page sq--------------

        print("TPLIST TAPPED")
        
        do {
            let users1 = try self.database.prepare(self.usersTableTP)
            for user in users1 {

                print("userId: \(user[self.id]), budget: \(user[self.budget])")
                targetBudget = Int(user[self.budget])
            }
      
//----------------daily detail sq---------------
        print("APLIST TAPPED")
            
            let users2 = try self.database.prepare(self.usersTableAP)
            for user in users2 {
                
                print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])")
            }
           
            let query = usersTableAP.select(self.sqPrice.sum,sqName)
           
            for user  in (try? database?.prepare(query))!! {
               if user[self.sqPrice.sum] ?? 0 > 0 {
                
                accountingSum = user[self.sqPrice.sum]!
                print("Accounting sum:  \(user[self.sqPrice.sum]!)")
                }else{
                print("0")
                }
              
            }
           
            let numberTrans = String(format: "%.2f", Float(accountingSum)/Float(targetBudget)*100)
            let showingNumber = Float(numberTrans)
           print(showingNumber!,"\(accountingSum),\(targetBudget)")
            
            todayBalance.text! = String(targetBudget-accountingSum)
//------------------bar chart------------
            let chartConfig = BarsChartConfig(
                valsAxisConfig : ChartAxisConfig(from:0 , to:100 ,by:10)
            )
      
            let frame = CGRect(x : 50 , y : 50 ,width:self.view.frame.width/1.5,height:80)

            let show = Double(showingNumber ?? 0)
            let chart = BarsChart(
                frame : frame,
                chartConfig : chartConfig,
                xTitle : "",
                yTitle : "",
                bars :[
                    ("",show)
                ],
                color:UIColor.init(displayP3Red: 1, green: 0.81, blue: 0.62, alpha: 1),
                barWidth: 30
            )
            

            self.view.addSubview(chart.view)
            self.chartView = chart
//---------------act notification-------------
            if targetBudget-accountingSum<0{ UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                    print("成功建立通知...")
                })
            }
        } catch {
            print(error)
        }

  
    }
//--------------------alert function---------------------
    func showAlertMessage(title: String, message: String) {
        let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
        let okAction = UIAlertAction(title: "確認", style: .default, handler: nil) // 產生確認按鍵
        inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController
        self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
    }
 
    
}
