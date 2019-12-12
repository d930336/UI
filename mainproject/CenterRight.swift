import UIKit
import PieCharts
import SQLite


class CenterRight: UIViewController, PieChartDelegate {
   
    @IBOutlet weak var pie: PieChart!
    var models: [PieSliceModel] = []

    @IBOutlet weak var ButtonView: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var background: UIImageView!
    
    static let alpha: CGFloat = 0.8
    let colors = [
        UIColor(red: 0.06, green: 0.23, blue: 0.31, alpha: 1).withAlphaComponent(alpha),
        
        UIColor(red: 1, green: 0.69, blue: 0.13, alpha: 1).withAlphaComponent(alpha),
               
        UIColor(red: 1, green: 0.81, blue: 0.62, alpha: 1).withAlphaComponent(alpha),
        
        UIColor(red: 0.98, green: 0.95, blue: 0.93, alpha: 1).withAlphaComponent(alpha),
        
        UIColor(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(alpha)
    ]
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        pie.delegate = self
        pie.layers = [createPlainTextLayer(),createTextWithLinesLayer(),createCustomViewsLayer()]
        
        self.background.layer.shadowOpacity = 1
        self.background.layer.shadowColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        self.background.layer.shadowOffset = CGSize(width: 5 ,height: 5)
        self.background.layer.shadowRadius = 5
        
        pie.models = createModels()
//--------------------------sqlite viewdidload---------------

    }

//--------------------------sqlite---------------------------
    var database: Connection!
    
    let id = Expression<Int>("id")
    let sqDate = Expression<String>("date")
    let sqName = Expression<String>("name")
    let sqPrice = Expression<Int>("price")

//-------------------------pie chart ------------------------
    var currentColorIndex = 0
    
    @IBOutlet weak var monthNumber: UILabel!
    @IBOutlet weak var preview: UILabel!
    @IBOutlet weak var save: UILabel!
    
    //MARK:-search bar-
     var buttonCheck = true

    @IBAction func textFieldAction(_ sender: Any) {
            preview.textColor = UIColor.clear
                    if searchBar.text != ""{
                        models.removeAll()
                        pie.clear()
                        do {
                              let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                              let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
                              let database = try Connection(fileUrl.path)
                              self.database = database
                              print("connected")
                        
                              
                              let thisMonthKind = usersTableAP
                                .filter(sqMonth == searchBar.text!)
                                         .select(self.sqPrice.sum,sqName).group(sqName)
                              let users = try self.database.prepare(thisMonthKind)
                            
                                let thisMonthSave = usersTableAP
                                    .filter(sqMonth == searchBar.text!)
                                        .select(sqSave.sum,sqMonth).group(sqMonth)
                                let usersSave = try self.database.prepare(thisMonthSave)
                            
                              for user in users {
                                
                                  let randomColor = Int.random(in: 0...4)
                                  let model = PieSliceModel(value:Double(user[sqPrice.sum]!), color: colors[randomColor],obj:String("\(user[sqName])"))
                                  
                                 models.append(model)
                                  
                                  }
                            
                            for user in usersSave {
                                
                                save.text! = "已省下 \(user[sqSave.sum]!)"
                                  
                                  }
                              
                          } catch {
                              print(error)
                        }
                        save.textColor = UIColor(red: 0.06, green: 0.23, blue: 0.31, alpha: 1)
                        monthNumber.textColor = UIColor(red: 0.06, green: 0.23, blue: 0.31, alpha: 1)
                                                       
                                                       if searchBar.text! == "01"{
                                                           monthNumber.text! = "1月"
                                                       }else if searchBar.text! == "02"{
                                                           monthNumber.text! = "2月"
                                                       }else if searchBar.text! == "03"{
                                                           monthNumber.text! = "3月"
                                                       }else if searchBar.text! == "04"{
                                                           monthNumber.text! = "4月"
                                                       }else if searchBar.text! == "05"{
                                                           monthNumber.text! = "5月"
                                                       }else if searchBar.text! == "06"{
                                                           monthNumber.text! = "6月"
                                                       }else if searchBar.text! == "07"{
                                                           monthNumber.text! = "7月"
                                                       }else if searchBar.text! == "08"{
                                                           monthNumber.text! = "8月"
                                                       }else if searchBar.text! == "09"{
                                                           monthNumber.text! = "9月"
                                                       }else if searchBar.text! == "10"{
                                                           monthNumber.text! = "10月"
                                                       }else if searchBar.text! == "11"{
                                                           monthNumber.text! = "11月"
                                                       }else if searchBar.text! == "12"{
                                                           monthNumber.text! = "12月"
                                                       }
                        searchBar.text! = ""
                        
                    }
        viewDidLoad()
        searchBar.endEditing(true)
        
    }
    
    
    @IBAction func beginEdit(_ sender: Any) {
         
         ButtonView.flash()
         ButtonView.setImage(UIImage(named: "searchReload")?.withRenderingMode(.alwaysOriginal), for:[])
         buttonCheck = false
     }
    
  
    @IBAction func endEdit(_ sender: Any) {

         ButtonView.flash()
         ButtonView.setImage(UIImage(named: "search")?.withRenderingMode(.alwaysOriginal), for:[])
         buttonCheck = true

     }
    
    //MARK:--touching return--
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
     }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         
         return true
     }
    
    
    @IBAction func submit(_ sender: Any) {
         if buttonCheck == true {
                               
                            models.removeAll()
                            
                            if searchBar.text != ""{
                           
                                do {
                                      let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                                      let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
                                      let database = try Connection(fileUrl.path)
                                      self.database = database
                                      print("connected")
                                
                                    let thisMonthSave = usersTableAP
                                        .filter(sqMonth == searchBar.text!)
                                            .select(sqSave.sum,sqMonth).group(sqMonth)
                                    let usersSave = try self.database.prepare(thisMonthSave)
                                    
                                      let thisMonthKind = usersTableAP
                                        .filter(sqMonth == searchBar.text!)
                                                 .select(self.sqPrice.sum,sqName).group(sqName)
                                      let users = try self.database.prepare(thisMonthKind)
                                      for user in users {
                                        
                                          let randomColor = Int.random(in: 0...4)
                                          let model = PieSliceModel(value:Double(user[sqPrice.sum]!), color: colors[randomColor],obj:String("\(user[sqName])"))
                                          
                                         models.append(model)
                                          
                                          }
                                      
                                    for user in usersSave {
                                                                   
                                        save.text! = "已省下 \(user[sqSave.sum]!)"
                                                                     
                                    }
                                  } catch {
                                      print(error)
                                  }
//                                viewDidLoad()
                                save.textColor = UIColor(red: 0.06, green: 0.23, blue: 0.31, alpha: 1)
                                preview.textColor = UIColor.clear
                                monthNumber.textColor = UIColor(red: 0.06, green: 0.23, blue: 0.31, alpha: 1)
                                
                                if searchBar.text! == "01"{
                                    monthNumber.text! = "1月"
                                }else if searchBar.text! == "02"{
                                    monthNumber.text! = "2月"
                                }else if searchBar.text! == "03"{
                                    monthNumber.text! = "3月"
                                }else if searchBar.text! == "04"{
                                    monthNumber.text! = "4月"
                                }else if searchBar.text! == "05"{
                                    monthNumber.text! = "5月"
                                }else if searchBar.text! == "06"{
                                    monthNumber.text! = "6月"
                                }else if searchBar.text! == "07"{
                                    monthNumber.text! = "7月"
                                }else if searchBar.text! == "08"{
                                    monthNumber.text! = "8月"
                                }else if searchBar.text! == "09"{
                                    monthNumber.text! = "9月"
                                }else if searchBar.text! == "10"{
                                    monthNumber.text! = "10月"
                                }else if searchBar.text! == "11"{
                                    monthNumber.text! = "11月"
                                }else if searchBar.text! == "12"{
                                    monthNumber.text! = "12月"
                                }
                                viewDidLoad()
                }
         } else{
                                searchBar.text = ""
                                searchBar.endEditing(true)
                                models.removeAll()
                                pie.clear()
            preview.textColor = UIColor(red: 0.06, green: 0.23, blue: 0.31, alpha: 1)
            monthNumber.textColor = UIColor.clear
            save.textColor = UIColor.clear
                            }
            
        
    }
       
        
    func imageFadeIn(imageView: UIImageView) {
            
        let secondImageView = UIImageView(image: UIImage(named: "bg02.png"))
            
        view.insertSubview(secondImageView, aboveSubview: imageView)
            
        UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseOut, animations: {
            secondImageView.alpha = 1.0
            }, completion: {_ in
                imageView.image = secondImageView.image
                secondImageView.removeFromSuperview()
        })
            
    }
    
    //MARK:- pie chart  -
    
    func createModels() -> [PieSliceModel] {

//        do {
//            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
//            let database = try Connection(fileUrl.path)
//            self.database = database
//            print("connected")
//
//            let todaysDate =  Calendar.current.date(byAdding: .month, value: -1, to: Date())
//            let monthFormatter = DateFormatter()
//            monthFormatter.dateFormat = "MM"
//            let monthString = monthFormatter.string(from: todaysDate!)
//            let monthdata = monthString
//
//            let thisMonthKind = usersTableAP
//                       .filter(sqMonth == monthdata)
//                       .select(self.sqPrice.sum,sqName).group(sqName)
//            let users = try self.database.prepare(thisMonthKind)
//            for user in users {
//
//                let randomColor = Int.random(in: 0...4)
//                let model = PieSliceModel(value:Double(user[sqPrice.sum]!), color: colors[randomColor],obj:String("\(user[sqName])"))
//
//               models.append(model)
//
//                }
//
//        } catch {
//            print(error)
//        }

        return models
    }
    
    func cancelPiechart() -> [PieSliceModel]{
                       do {
                                  let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                                  let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
                                  let database = try Connection(fileUrl.path)
                                  self.database = database
                                  print("connected")
                              
                                  let todaysDate =  Calendar.current.date(byAdding: .month, value: 0, to: Date())
                                  let monthFormatter = DateFormatter()
                                  monthFormatter.dateFormat = "MM"
                                  let monthString = monthFormatter.string(from: todaysDate!)
                                  let monthdata = monthString
                                  
                                  let thisMonthKind = usersTableAP
                                             .filter(sqMonth == monthdata)
                                             .select(self.sqPrice.sum,sqName).group(sqName)
                                  let users = try self.database.prepare(thisMonthKind)
                                  for user in users {
                                    
                                      let randomColor = Int.random(in: 0...4)
                                      let model = PieSliceModel(value:Double(user[sqPrice.sum]!), color: colors[randomColor],obj:String("\(user[sqName])"))
                                      
                                     models.append(model)
                                      
                                      }
                               
                              } catch {
                                  print(error)
                              }
        return models
    }
    
    func onSelected(slice: PieSlice, selected: Bool) {
        print("Selected: \(selected), slice: \(slice)")
       
        
    }
    
    //MARK: -  set max lengh to text  -
//       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//           guard let textFieldText = textField.text,
//               let rangeOfTextToReplace = Range(range, in: textFieldText) else {
//                   return false
//           }
//           let substringToReplace = textFieldText[rangeOfTextToReplace]
//           let count = textFieldText.count - substringToReplace.count + string.count
//           return count <= 2
//       }
    
    // Use this if you have a UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under x characters
        return updatedText.count <= 4
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
       
        func createCustomViewsLayer() -> PieCustomViewsLayer {
                   let viewLayer = PieCustomViewsLayer()
                   
                   let settings = PieCustomViewsLayerSettings()
                   settings.viewRadius = 135
                   settings.hideOnOverflow = false
                   viewLayer.settings = settings
                   
                   viewLayer.viewGenerator = createViewGenerator()
                   
                   return viewLayer
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
                       
                        if tranObj == "Food"{
                                       specialTextLabel.text = "Food"
                                   }else if tranObj == "Other" {
                                       specialTextLabel.text = "Other"
                                   }else if tranObj == "Place" {
                                       specialTextLabel.text = "Place"
                                   }else if tranObj == "Sneak" {
                                       specialTextLabel.text = "Sneak"
                                   }else if tranObj == "Tools" {
                                       specialTextLabel.text = "Sneak"
                                   }else if tranObj == "Traffic" {
                                       specialTextLabel.text = "Traffic"
                                   }else if tranObj == "Beverage" {
                                       specialTextLabel.text = "Beverage"
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
      @IBAction func onPlusTap(sender: UIButton) {
        let newModel = PieSliceModel(value: 4 * Double(CGFloat.random()), color: colors[currentColorIndex],obj: "")
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
