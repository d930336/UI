//
//  DailyDetail.swift
//  mainproject
//
//  Created by Benson Yang on 2019/4/12.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit
import SQLite
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
    
    @IBAction func back(_ sender: Any) {
        couponDiscount = "0"
    }
    
    
    // MARK: - sqlite-
    
    var database: Connection!
    
    let id = Expression<Int>("id")
    let sqDate = Expression<String>("date")
    let sqName = Expression<String>("name")
    let sqPrice = Expression<Int>("price")
    let sqCoupon = Expression<String>("coupon")
    let sqDiscount = Expression<Int>("discount")
    let sqMonth = Expression<String>("month")
    let sqSave = Expression<Int>("save")
    
 // MARK: - type---------------------
    
    @IBOutlet weak var pickerView: UIPickerView!
  
    @IBOutlet weak var tableView: UITableView!

    let types = ["工具","交通","飲料","土地","食物","零食","其他"]

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
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string:types[row] , attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
 
  // MARK: - date picker
    
    var datedata : String!
    var monthdata: String!
    
    @IBOutlet weak var getDateValue: UIDatePicker!
   
    @IBAction func dateAction(_ sender: UIDatePicker) {
        let dateValue = DateFormatter()
        dateValue.dateFormat = "MMdd" // 設定要顯示在Text Field的日期時間格式
        datedata = dateValue.string(from: getDateValue.date) // 更新Text Field的內容
//        getDateValue.setValue(UIColor.black, forKeyPath: "textColor") 轉動時變顏色
        
        let monthValue = DateFormatter()
        monthValue.dateFormat = "MM"
        monthdata = monthValue.string(from: getDateValue.date)
    }
    
    
    
    
 // MARK: - calculator -
    
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
    
    
    @IBAction func deleteNum(_ sender: Any) {
        if total.text?.count == 1{
            total.text = "0"
        }else{
            numberOnScreen = Double(total.text!.dropLast())!
            makeOkNumberString(from: numberOnScreen)
        }
        performingMath = true
        startNew = false
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

                    // MARK: - viewdidload -
    
    override func viewDidLoad() {
        
        tableView.scrollToBottomRow()
        super.viewDidLoad()
        getDateValue.setValue(UIColor.black, forKeyPath: "textColor")
//        tableView.transform = CGAffineTransform(rotationAngle: .pi) 反方向
        
        if couponDiscount != "0" {
            total.text = couponDiscount
            total.textColor = UIColor.red
        }
        
        // MARK: - ----initiate the date to today
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMdd"
        let dateString = dateFormatter.string(from: todaysDate)
        datedata = dateString
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let monthString = monthFormatter.string(from: todaysDate)
        monthdata = monthString
        
 // MARK: - ----initiate the picker value
        pickerView.selectRow(0, inComponent: 0, animated: true) //initiate the value of picker
        
        typeShow = "工具"

        selectedBackgroundView.backgroundColor = UIColor.clear
        
        dailyDetailForm = createArray()
        
        
// MARK: ----sqlite view didlord-------
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
        
        let createTable = usersTableAP.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.sqDate, unique: false)
            table.column(self.sqName, unique: false)
            table.column(self.sqPrice, unique: false)
            table.column(self.sqCoupon, unique: false)
            table.column(self.sqDiscount, unique: false)
            table.column(self.sqMonth, unique: false)
            table.column(self.sqSave, unique: false)
            
        }
        userToken.set(true, forKey: "sqliteCheck")
        secondCheck = true
        
//        let createCouponTable = usersTableCP.create { (table) in
//            table.column(self.id, primaryKey: true)
//            table.column(sqcouponListUrl, unique: false)
//            table.column(sqcouponDiscount, unique: false)
//            table.column(sqcouponTitle, unique: false)
//
//        }

        do {
            try self.database.run(createTable)
//            try self.database.run(createCouponTable)
            print("Created Table")
            userToken.set(true, forKey: "sqliteCheck")
            secondCheck = true
        } catch {
            print(error)
        }
        
        do {
            let listQuery = usersTableAP.order(sqDate,sqName)
            let users = try self.database.prepare(listQuery)
            for user in users {
                var getSqCoupon = "\(user[self.sqCoupon])"
                var getSqSave = "-\(user[sqSave])"
                if "\(user[self.sqCoupon])" == ""{
                    getSqCoupon = "none"
                    getSqSave = ""
                }
                
                print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice]),coupon:\(user[self.sqCoupon]),month: \(user[self.sqMonth])")
              
                let daily = DailyDetailForm(Date: "\(user[self.sqDate])", Name: " \(user[self.sqName])", Price: "\(user[self.sqPrice])", Coupon: getSqCoupon,id:"\(user[self.id])",save:getSqSave)
                                
                dailyDetailForm.append(daily)
                
                let indexPath = IndexPath(row: dailyDetailForm.count - 1,section :0)
                tableView.beginUpdates()
                tableView.insertRows(at:[indexPath], with: .automatic)
                tableView.endUpdates()
                
                }
            
             let query = usersTableAP.select(self.sqPrice.sum,sqName)
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
// MARK: -------swipe------
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .right
        
        view.addGestureRecognizer(edgePan)
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            let vc = (storyboard?.instantiateViewController(withIdentifier: "pageController"))
            vc?.modalPresentationStyle = .fullScreen
            vc?.modalTransitionStyle = .crossDissolve
                    present(vc!, animated: true )

        //            show((storyboard?.instantiateViewController(withIdentifier: "pageController"))! , sender: nil)
                }
    }
    
    
 
// MARK:---delete row---
    
    @IBAction func deleteAll(_ sender: Any) {
        
        let del = usersTableAP
        
                if let count = try? self.database.run(del.delete()) {
                    print("删除的条数为：\(count)")
                } else {
                    print("删除失败")
                }
        
    }
    var cellData :String = ""
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dailyDetailForm.remove(at: indexPath.row-1)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
// MARK:-delete from sqlite-------------------
      
//        let del = usersTable
//
//        if let count = try? self.database.run(del.delete()) {
//            print("删除的条数为：\(count)")
//        } else {
//            print("删除失败")
//        }
        
        let dailyDetailFormId = Int(dailyDetailForm[indexPath.row-1].id) ?? 0
        print(dailyDetailFormId)
        let firstDel = usersTableAP.filter(id == dailyDetailFormId)
        if let count = try? self.database.run(firstDel.delete()) {
            print("删除的条数为：\(count)")
        } else {
            print("删除失败")
        }
        
    }
// MARK:setting margin----
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
    
  // MARK:-insert row-
    
    @IBAction func insert(_ sender: UIButton) {
        print(cellData)
        insertNewRow()
        tableView.scrollToBottomRow()
        total.text = "0"
        total.textColor = UIColor(red: 0.048, green: 0.18, blue: 0.235, alpha: 1)
        resetTheCouponValue()
    }
    
  // MARK:---sqlite insert (save)

    func insertNewRow() {
                
        print("INSERT TAPPED")
        let getCouponTitle:String? = couponTitle
        var getCouponDiscount:Int? = 0
        var getCouponSave:Int? = 0
        if couponDiscount != "0"{
             getCouponDiscount = Int("\(couponDiscount)")
             getCouponSave = Int("\(couponSave)")
        }
            guard let sqDate = datedata,
                  let sqName = typeShow,
                let sqPrice = Int(total.text ?? "0"),
                let sqMonth = monthdata,
                let sqCoupon = getCouponTitle,
                let sqDiscount = getCouponDiscount,
                let sqSave = getCouponSave
                else { return }
           
        let insertUser = usersTableAP.insert(self.sqDate <- sqDate
            , self.sqName <- sqName
            , self.sqPrice <- sqPrice
            , self.sqCoupon <- sqCoupon
            , self.sqDiscount <- sqDiscount
            , self.sqMonth <- sqMonth
            , self.sqSave <- sqSave)
            
            do {
                try self.database.run(insertUser)
                let dailyInsert = DailyDetailForm(Date: "\(sqDate)", Name: " \(sqName)", Price: "\(sqPrice)", Coupon: "none",id:"0",save:"")
                let dailyInsertWithCoupon = DailyDetailForm(Date: "\(sqDate)", Name: " \(sqName)", Price: "\(sqPrice)", Coupon: "\(sqCoupon)",id:"0",save: "-\(sqSave)")
                
                if couponDiscount == "0"{
                dailyDetailForm.append(dailyInsert)
                }else{
                dailyDetailForm.append(dailyInsertWithCoupon)
                }
                
                let indexPath = IndexPath(row: dailyDetailForm.count - 1,section :0)
                tableView.beginUpdates()
                tableView.insertRows(at:[indexPath], with: .automatic)
                tableView.endUpdates()
            } catch {
                print(error)
            }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
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
        cell.id.text = dailyDetailForms.id
        
        return cell
        
    }
}
extension UITableView {
    func scrollToBottomRow() {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }

            // Make an attempt to use the bottom-most section with at least one row
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)

            // Ensure the index path is valid, otherwise use the section above (sections can
            // contain 0 rows which leads to an invalid index path)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)

                // If we're down to the last section, attempt to use the first row
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }

            // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
            // exception here
            guard self.indexPathIsValid(indexPath) else { return }

            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
}



