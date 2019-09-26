import UIKit
import PieCharts
import SQLite


class CenterRight: UIViewController {
    
    @IBOutlet weak var pie: PieChart!
    
    @IBOutlet weak var background: UIImageView!
    
    static let alpha: CGFloat = 0.8
    let colors = [
        UIColor(red: 0.06, green: 0.23, blue: 0.31, alpha: 1).withAlphaComponent(alpha),
        
        UIColor(red: 1, green: 0.69, blue: 0.13, alpha: 1).withAlphaComponent(alpha),
               
        UIColor(red: 1, green: 0.81, blue: 0.62, alpha: 1).withAlphaComponent(alpha),
        
        UIColor(red: 0.98, green: 0.95, blue: 0.93, alpha: 1).withAlphaComponent(alpha),
        
        UIColor(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(alpha)
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pie.layers = [createPlainTextLayer(), createTextWithLinesLayer()]
        
        self.background.layer.shadowOpacity = 1
        self.background.layer.shadowColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        self.background.layer.shadowOffset = CGSize(width: 5 ,height: 5)
        self.background.layer.shadowRadius = 5
        
        pie.models = createModels()
//--------------------------sqlite viewdidload---------------
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
        
//        do {
//            let users = try self.database.prepare(self.usersTable)
//            for user in users {
//                print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])")
//                let model = PieSliceModel(value:Double(user[self.sqPrice]), color: colors[0])
//
//
//                pie.insertSlice(index: Int(user[self.sqPrice]), model: PieSliceModel(value:Double(user[self.sqPrice]), color: colors[0]))
//
//                pie.models.append(model)
//
//                pie.reloadInputViews()
//
//                }
//
//        } catch {
//            print(error)
//        }

    }
//--------------------------sqlite---------------------------
    var database: Connection!
    
    let usersTable = Table("AccountingPage1")
    let id = Expression<Int>("id")
    let sqDate = Expression<String>("date")
    let sqName = Expression<String>("name")
    let sqPrice = Expression<Int>("price")

//-------------------------pie chart ------------------------
    var currentColorIndex = 0
    
    func createModels() -> [PieSliceModel] {
        var models: [PieSliceModel] = []

        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            print("connected")
        } catch {
            print(error)
        }
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                print("userId: \(user[self.id]), date: \(user[self.sqDate]),name: \(user[self.sqName]),price: \(user[self.sqPrice])")
                let randomColor = Int.random(in: 0...4)
                let model = PieSliceModel(value:Double(user[self.sqPrice]), color: colors[randomColor])
                //                pie.insertSlice(index: Int(user[self.sqPrice]), model: PieSliceModel(value:Double(user[self.sqPrice]), color: colors[0]))
                
               models.append(model)
                
                }
            
        } catch {
            print(error)
        }
//        return pie.models
//        return generateModels
        
//        currentColorIndex = models.count
        return models
    }
    
    func onGenerateSlice(slice: PieSlice){
        
    }
    
    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
       
        
    }
    
    
        // MARK: - Layers
        
         func createPlainTextLayer() -> PiePlainTextLayer {
            
            let textLayerSettings = PiePlainTextLayerSettings()
            textLayerSettings.viewRadius = 55
            textLayerSettings.hideOnOverflow = true
            textLayerSettings.label.font = UIFont.systemFont(ofSize: 8)
            
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            textLayerSettings.label.textGenerator = {slice in
                return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
            }
            
            let textLayer = PiePlainTextLayer()
            textLayer.settings = textLayerSettings
            return textLayer
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
    
      @IBAction func onPlusTap(sender: UIButton) {
        let newModel = PieSliceModel(value: 4 * Double(CGFloat.random()), color: colors[currentColorIndex])
        pie.insertSlice(index: 0, model: newModel)
        currentColorIndex = (currentColorIndex + 1) % colors.count
        if currentColorIndex == 2 {currentColorIndex += 1} // avoid same contiguous color
    }

}
    

    extension CGFloat {
        static func random() -> CGFloat {
            return CGFloat(arc4random()) / CGFloat(UInt32.max)
        }
    }

    extension UIColor {
        static func randomColor() -> UIColor {
            return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
        }
    }
