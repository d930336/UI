//
//  DailyDetail.swift
//  mainproject
//
//  Created by Benson Yang on 2019/4/12.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit
import SQLite
import SQLite3
import UserNotifications

enum OperationType{
    case add
    case substract
    case none
}

class DailyDetail: UIViewController ,UIPickerViewDataSource,UIPickerViewDelegate{
    //tableview
    //detail
    var typeShow : String!
   
    //account
   
    var numberOnScreen:Double = 0
    var previousNumber:Double = 0
    var performingMath = false
    var operation:OperationType = .none
    var startNew = true
    
    
    @IBAction func CouponPage(_ sender: Any) {
        self.performSegue(withIdentifier: "goToPC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToPC" {
            
            let secondVC = segue.destination as! pageviewcontroller
            
            secondVC.received = 2
            
        }
    }
    
    //---------------sqlite--------------------
    
    var database: Connection!
    
    let usersTable = Table("AccountingPage1")
    let id = Expression<Int>("id")
    let sqDate = Expression<String>("date")
    let sqName = Expression<String>("name")
    let sqPrice = Expression<Int>("price")

    
    
    //----------------type---------------------
    
    @IBOutlet weak var pickerView: UIPickerView!
  
    @IBOutlet weak var tableView: UITableView!
    
    
    let types = ["","Tools","Traffic","beverage","Place","Food","Sneak","Other"]
    
    
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    
 
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeShow = types[row]
    }
 
  //--------------------date picker-----------------------------
    var datedata : String!
    @IBOutlet weak var getDateValue: UIDatePicker!
    
    @IBAction func dateAction(_ sender: UIDatePicker) {
        let dateValue = DateFormatter()
        dateValue.dateFormat = "MMdd" // 設定要顯示在Text Field的日期時間格式
        datedata = dateValue.string(from: getDateValue.date) // 更新Text Field的內容
 
    }
    
    
    
    
  //--------------------calculator-------------------------------
    
    @IBOutlet weak var total: UILabel!
    
    @IBAction func numbers(_ sender: UIButton) {
        let inputNumber=sender.tag-1
        if total.text != nil {
            if total.text == "0"||total.text == "+"||total.text == "-"{
            total.text = "\(inputNumber)"
            }else{
                total.text = total.text!+"\(inputNumber)"
            }
        }
        numberOnScreen =  Double(total.text!) ?? 0
    }
    
    
    @IBAction func clean(_ sender: UIButton) {
        total.text = "0"
        numberOnScreen = 0
        previousNumber = 0
        performingMath = false
        operation = .none
        startNew = true
    }
    
    
    @IBAction func add(_ sender: UIButton) {
        total.text = "+"
        previousNumber = numberOnScreen
        performingMath = true
        operation = .add
    }
    
    @IBAction func substract(_ sender: UIButton) {
        total.text = "-"
        previousNumber = numberOnScreen
        performingMath = true
        operation = .substract
    }
    
    
    @IBAction func answer(_ sender: Any) {
        if performingMath == true{
            switch operation{
                case .add:
                    numberOnScreen = previousNumber+numberOnScreen
                    makeOkNumberString(from: numberOnScreen)
                case .substract:
                    numberOnScreen = previousNumber-numberOnScreen
                    makeOkNumberString(from: numberOnScreen)
                case .none:
                    total.text = "0"
            }
            performingMath = false
            startNew = true
        }
    }
    
    func makeOkNumberString(from number:Double) {
        if floor(number) == number{
            total.text = "\(Int(number))"
        }else{
            total.text = "\(number)"
        }
    }
    
   //--------------------------------------------
    let cellSpacingHeight: CGFloat = 10
    
    let selectedBackgroundView = UIView()
    
    var dailyDetailForm : [DailyDetailForm] = []

    //-------------------viewdidload-------------------------
    override func viewDidLoad() {
       
        super.viewDidLoad()
   
//        tableView.transform = CGAffineTransform(rotationAngle: .pi) ㄓ反方向
        
//------------------------make table be bottom---------------
   
    //-------------------initiate the date to today----------
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMdd"
        let dateString = dateFormatter.string(from: todaysDate)
        datedata = dateString
    
    //-------------------initiate the picker value-----------
        pickerView.selectRow(0, inComponent: 0, animated: true) //initiate the value of picker
        
      
        selectedBackgroundView.backgroundColor = UIColor.clear
        
        dailyDetailForm = createArray()
        
        
        //-----------sqlite view didlord-------
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
            table.column(self.sqDate, unique: false)
            table.column(self.sqName, unique: false)
            table.column(self.sqPrice, unique: false)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
        
        
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                
                print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])")
                let daily1 = DailyDetailForm(Date: "\(user[self.sqDate])", Name: " \(user[self.sqName])", Price: "\(user[self.sqPrice])", Coupon: "none")
                
                dailyDetailForm.append(daily1)
                
                let indexPath = IndexPath(row: dailyDetailForm.count - 1,section :0)
                tableView.beginUpdates()
                tableView.insertRows(at:[indexPath], with: .automatic)
                tableView.endUpdates()
                
                }
            
             let query = usersTable.select(self.sqPrice.sum,sqName)
                for user  in (try? database?.prepare(query))!! {
                    if user[self.sqPrice.sum] ?? 0 > 0 {
                    print("\(user[self.sqPrice.sum]! )")
                    }else{
                        print("0")
                    }
            }
            
        } catch {
            print(error)
        }
//---------------swipe--------------------
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .right
        
        view.addGestureRecognizer(edgePan)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            print("Screen edge swiped!")
            show((storyboard?.instantiateViewController(withIdentifier: "pageController"))! , sender: nil)
        }
    }
    
    
 
 //----------------delete row---------------------------
    
    @IBAction func deleteAll(_ sender: Any) {
        
        let del = usersTable
        
                if let count = try? self.database.run(del.delete()) {
                    print("删除的条数为：\(count)")
                } else {
                    print("删除失败")
                }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dailyDetailForm.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .bottom)
        tableView.endUpdates()
//----------------delete from sqlite-------------------
      
//        let del = usersTable
//
//        if let count = try? self.database.run(del.delete()) {
//            print("删除的条数为：\(count)")
//        } else {
//            print("删除失败")
//        }
        
    
        let firstDel = usersTable.filter(id == indexPath.row+1)
        if let count = try? self.database.run(firstDel.delete()) {
            print("删除的条数为：\(count)")
        } else {
            print("删除失败")
        }
        
    }
 //------------setting margin---------------------
    func tableView(_ tableView: UITableView, heightForFootererInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFootererInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    // Set the spacing between sections
    /*func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return cellSpacingHeight
     }
 */
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    //去除tableView 多余行的方法 添加一个tableFooterView 后面多余行不再显示
    
    //----------------------insert row-------------------------------
    
    @IBAction func insert(_ sender: UIButton) {
        insertNewRow()
    }
  
    func insertNewRow() {
        
//--------------sqlite insert---------------
        
        print("INSERT TAPPED")
        
            guard let sqDate = datedata,
                  let sqName = typeShow,
                let sqPrice = Int(total.text ?? "0")
                else { return }
            print(sqDate)
            print(sqName)
            print(sqPrice)
            let insertUser = self.usersTable.insert(self.sqDate <- sqDate, self.sqName <- sqName, self.sqPrice <- sqPrice)
            
            do {
                try self.database.run(insertUser)
                print("INSERTED USER")
                
                let dailyInsert = DailyDetailForm(Date: "\(sqDate)", Name: " \(sqName)", Price: "\(sqPrice)", Coupon: "none")
                
                dailyDetailForm.append(dailyInsert)
                
                let indexPath = IndexPath(row: dailyDetailForm.count - 1,section :0)
                tableView.beginUpdates()
                tableView.insertRows(at:[indexPath], with: .automatic)
                tableView.endUpdates()
            } catch {
                print(error)
            }
        

        
//        print("LIST TAPPED")
//
//        do {
//            let users = try self.database.prepare(self.usersTable)
//            for user in users {
//
//                print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])")
//
//
//            }
//        } catch {
//            print(error)
//        }
       
    }
    
   
    func createArray() -> [DailyDetailForm]{
        
        var tempDetail: [DailyDetailForm] = []
        
//        let daily1 = DailyDetailForm(Date: "4/20", Name: "KFC", Price: "199", Coupon: "20%")
//        tempDetail.append(daily1)
     
        
        return tempDetail
        
    }
  
    
}

extension DailyDetail:UITableViewDataSource,UITableViewDelegate {
    
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyDetailForm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dailyDetailForms = dailyDetailForm[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyDetailCell") as! DailyDetailCell
     
        
        cell.setDailyDetailForm(dailyDetailForm: dailyDetailForms)
        cell.selectedBackgroundView = selectedBackgroundView
        
        // note that indexPath.section is used rather than indexPath.row
        //cell.textLabel?.text = self.animals[indexPath.section]
        
        // add border and color
//        cell.contentView.transform = CGAffineTransform(rotationAngle: .pi)
        cell.backgroundColor = UIColor.init(white: 1, alpha: 0.75)
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.masksToBounds = false
        cell.layer.shadowOpacity = 0.75
        cell.layer.shadowOffset = CGSize(width: 5, height: 5)
        cell.layer.shadowRadius = 5
        cell.layer.cornerRadius = 12
        cell.clipsToBounds = false
        
        return cell
        
    }
    
   
    
}


