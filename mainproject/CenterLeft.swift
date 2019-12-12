import UIKit
import SQLite

class CenterLeft: UIViewController {
    
    //---------------sqlite--------------------
    
    var database: Connection!
    
    
    let id = Expression<Int>("id")
    let sqDate = Expression<String>("date")
    let sqName = Expression<String>("name")
    let sqPrice = Expression<Int>("price")

 
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var background: UIImageView!
    
    let cellSpacingHeight: CGFloat = 0
    
    let selectedBackgroundView = UIView()
    
//------------array---------------------
    var centerLeftList : [DailyDetailForm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        centerLeftList = createArray()
        
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
        print("LIST TAPPED")
        
        do {
            let listQuery = usersTableAP.order(sqDate,sqName)
            let users = try self.database.prepare(listQuery)
            for user in users {
                var getSqCoupon = "\(user[sqCoupon])"
                var getsqSave = "-\(user[sqSave])"
                               if "\(user[sqCoupon])" == ""{
                                    getSqCoupon = "none"
                                    getsqSave = ""
                               }
                print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])")
             
                let daily = DailyDetailForm(Date: "\(user[self.sqDate])", Name: " \(user[self.sqName])", Price: "\(user[self.sqPrice])", Coupon: getSqCoupon,id:"\(user[self.id])",save: getsqSave)
                
                centerLeftList.append(daily)
                
                
                let indexPath = IndexPath(row: centerLeftList.count - 1,section :0)
                tableView.beginUpdates()
                tableView.insertRows(at:[indexPath], with: .automatic)
                tableView.endUpdates()
                
                }
            }catch {
                print(error)
            }
        
         selectedBackgroundView.backgroundColor = UIColor.clear
        self.background.layer.shadowOpacity = 1
        self.background.layer.shadowColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        self.background.layer.shadowOffset = CGSize(width: 5 ,height: 5)
        self.background.layer.shadowRadius = 5
        
        
    }
    
//MARK:-view didlord end--
 
    
    
//MARK:-search bar-
 
    var buttonCheck = true
    
    @IBOutlet weak var buttonView: UIButton!
    
    @IBAction func beginEdit(_ sender: Any) {
        
        buttonView.flash()        
        buttonView.setImage(UIImage(named: "searchReload")?.withRenderingMode(.alwaysOriginal), for:[])
        buttonCheck = false
    }
   
    @IBAction func endEdit(_ sender: Any) {
       
        buttonView.flash()
        buttonView.setImage(UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), for:[])
        buttonCheck = true

    }
    
    
    @IBAction func submit(_ sender: Any) {
      
    if buttonCheck == true {
           
        if searchBar.text != ""{
           
            centerLeftList.removeAll()
            tableView.reloadData()

            var searchControll = usersTableAP.filter(sqMonth == "\(searchBar.text ?? "")")
           
            if (searchBar.text?.count ?? 0 ) == 4{
                searchControll = usersTableAP.filter(sqDate == "\(searchBar.text ?? "")")
            }else{
                searchControll = usersTableAP.filter(sqMonth == "\(searchBar.text ?? "")")
            }
        do {
            
            let users = try self.database.prepare(searchControll)
            for user in users {

                print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice]), month: \(user[sqMonth])")

                let daily = DailyDetailForm(Date: "\(user[self.sqDate])", Name: " \(user[self.sqName])", Price: "\(user[self.sqPrice])", Coupon: " \(user[sqCoupon])",id: "\(user[self.id])",save:"-\(user[sqSave])")
 
                centerLeftList.append(daily)

                let indexPath = IndexPath(row: centerLeftList.count - 1,section :0)
                tableView.insertRows(at:[indexPath], with: .automatic)
                tableView.reloadData()

                }
            }catch {
                print(error)
            }
        }else{
           
             centerLeftList.removeAll()
             tableView.reloadData()
            do {
                print("2")
                let users = try self.database.prepare(usersTableAP)
                for user in users {
                    var getSqCoupon = "\(user[sqCoupon])"
                    var getsqSave = "-\(user[sqSave])"
                                                  if "\(user[sqCoupon])" == ""{
                                                        getSqCoupon = "none"
                                                        getsqSave = ""
                                                  }
                    print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])")
                    
                    let daily = DailyDetailForm(Date: "\(user[self.sqDate])", Name: " \(user[self.sqName])", Price: "\(user[self.sqPrice])", Coupon: getSqCoupon,id:"\(user[self.id])",save: getsqSave)
                    
                    centerLeftList.append(daily)
                    
                    
                    let indexPath = IndexPath(row: centerLeftList.count - 1,section :0)
                    tableView.insertRows(at:[indexPath], with: .automatic)
                    tableView.reloadData()
                    
                }
            }catch {
                print(error)
            }
        }
        }
//MARK: --search cancel--
        else{
        
            centerLeftList.removeAll()
            tableView.reloadData()
            searchBar.text = ""
            do {
                let users = try self.database.prepare(usersTableAP)
                for user in users {
                    var getSqCoupon = "\(user[sqCoupon])"
                    var getsqSave = "-\(user[sqSave])"
                        if "\(user[sqCoupon])" == ""{
                            getSqCoupon = "none"
                            getsqSave = ""
                            }
                    print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])")
                    
                    let daily = DailyDetailForm(Date: "\(user[self.sqDate])", Name: " \(user[self.sqName])", Price: "\(user[self.sqPrice])", Coupon: getSqCoupon,id: "\(user[self.id])",save: getsqSave)
                    
                    centerLeftList.append(daily)
                    
                    
                    let indexPath = IndexPath(row: centerLeftList.count - 1,section :0)
                    tableView.beginUpdates()
                    tableView.insertRows(at:[indexPath], with: .automatic)
                    tableView.endUpdates()
                }
            }catch {
                print(error)
            }
        searchBar.endEditing(true)
        }
    }
    
    //MARK: -  set max lengh to text  -
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard let textFieldText = searchBar.text,
               let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                   return false
           }
           let substringToReplace = textFieldText[rangeOfTextToReplace]
           let count = textFieldText.count - substringToReplace.count + string.count
           return count <= 4
       }
    
    //MARK:--touching return--
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func textFeildAction(_ sender: Any) {
    
    print("1")
        tableView.reloadData()
        if searchBar.text != ""{
            
            centerLeftList.removeAll()
            tableView.reloadData()
            var searchControll = usersTableAP.filter(sqMonth == "\(searchBar.text ?? "")")
                      
                if (searchBar.text?.count ?? 0 ) == 4{
                    searchControll = usersTableAP.filter(sqDate == "\(searchBar.text ?? "")")
                }else{
                    searchControll = usersTableAP.filter(sqMonth == "\(searchBar.text ?? "")")
                }
            do {
                
                let users = try self.database.prepare(searchControll)
                for user in users {
                    var getSqCoupon = "\(user[sqCoupon])"
                    var getSqSave = "-\(user[sqSave])"
                        if "\(user[sqCoupon])" == ""{
                            getSqCoupon = "none"
                            getSqSave = ""
                        }
                    print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice]), month: \(user[sqMonth])")
                    
                    let daily = DailyDetailForm(Date: "\(user[self.sqDate])", Name: " \(user[self.sqName])", Price: "\(user[self.sqPrice])", Coupon: getSqCoupon,id:"\(user[self.id])", save: getSqSave)
                    
                    centerLeftList.append(daily)
                    
                    let indexPath = IndexPath(row: centerLeftList.count - 1,section :0)
                    tableView.insertRows(at:[indexPath], with: .automatic)
                    tableView.reloadData()
                    
                }
            }catch {
                print(error)
            }
        }else{
            
            centerLeftList.removeAll()
            tableView.reloadData()
            do {
                print("2")
                let users = try self.database.prepare(usersTableAP)
                for user in users {
                    
                    var getSqCoupon = "\(user[sqCoupon])"
                    var getSqSave = "-\(user[sqSave])"
                            if "\(user[sqCoupon])" == ""{
                                getSqCoupon = "none"
                                getSqSave = ""
                            }
                    
                    print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])")
                    
                    let daily = DailyDetailForm(Date: "\(user[self.sqDate])", Name: " \(user[self.sqName])", Price: "\(user[self.sqPrice])", Coupon: getSqCoupon,id: "\(user[self.id])",save:getSqSave)
                    
                    centerLeftList.append(daily)
                    
                    
                    let indexPath = IndexPath(row: centerLeftList.count - 1,section :0)
                    tableView.insertRows(at:[indexPath], with: .automatic)
                    tableView.reloadData()
                    
                }
            }catch {
                print(error)
            }
        }
    }
  
    
//    func createArray() -> [DailyDetailForm]{
//
//        var tempDetail: [DailyDetailForm] = []
//        return tempDetail
//
//    }
    
    func tableView(_ tableView: UITableView, heightForFootererInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFootererInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
}

extension CenterLeft:UITableViewDataSource,UITableViewDelegate {



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return centerLeftList.count
        
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      

        let cell = tableView.dequeueReusableCell(withIdentifier: "CenterLeftCell") as! CenterLeftCell

      
        let centerLeftLists = centerLeftList[indexPath.row]

        cell.setCenterLeftList(centerLeftList: centerLeftLists)
        cell.selectedBackgroundView = selectedBackgroundView

        return cell
    }
    
}
