import UIKit
import SQLite
import SQLite3

class CenterLeft: UIViewController {
    
    //---------------sqlite--------------------
    
    var database: Connection!
    
    let usersTable = Table("AccountingPage1")
    let id = Expression<Int>("id")
    let sqDate = Expression<String>("date")
    let sqName = Expression<String>("name")
    let sqPrice = Expression<Int>("price")

 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var background: UIImageView!
    
    let cellSpacingHeight: CGFloat = 10
    
    let selectedBackgroundView = UIView()
    
    var centerLeftList : [DailyDetailForm] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerLeftList = createArray()
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
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                
                print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])")
                let daily1 = DailyDetailForm(Date: "\(user[self.sqDate])", Name: " \(user[self.sqName])", Price: "\(user[self.sqPrice])", Coupon: "none")
                
                centerLeftList.append(daily1)
                
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
    
    func createArray() -> [DailyDetailForm]{
        
        var tempDetail: [DailyDetailForm] = []
        
        let daily1 = DailyDetailForm(Date: "4/20", Name: "KFC", Price: "199", Coupon: "20%")
        tempDetail.append(daily1)
        
        
        return tempDetail
        
    }
    
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
        let centerLeftLists = centerLeftList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "CenterLeftCell") as! CenterLeftCell


        cell.setCenterLeftList(centerLeftList: centerLeftLists)
        cell.selectedBackgroundView = selectedBackgroundView

        // note that indexPath.section is used rather than indexPath.row
        //cell.textLabel?.text = self.animals[indexPath.section]

        // add border and color
//        cell.backgroundColor = UIColor.init(white: 1, alpha: 0.75)
//        cell.layer.shadowColor = UIColor.lightGray.cgColor
//        cell.layer.masksToBounds = false
//        cell.layer.shadowOpacity = 0.75
//        cell.layer.shadowOffset = CGSize(width: 5, height: 5)
//        cell.layer.shadowRadius = 5
//        cell.layer.cornerRadius = 12
//        cell.clipsToBounds = false

        return cell



    }


}

