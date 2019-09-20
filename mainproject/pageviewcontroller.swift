//
//  pageviewcontroller.swift
//  mainproject
//
//  Created by Benson Yang on 2019/3/14.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit
import UserNotifications

class pageviewcontroller: UIPageViewController , UIPageViewControllerDataSource{

    
    
    var list = [UIViewController]()
    var received : Int = 1
  /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for v in view.subviews{
            if v is UIScrollView{
                v.frame = v.bounds
                break
            }
        }
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()

//------------notification-------------------
//        let content = UNMutableNotificationContent()
//        content.title = "發大財"
//        //        content.subtitle = "subtitle："
//        content.body = "記一筆？ 台灣發大財關心您"
//        content.badge = 0
//        content.sound = UNNotificationSound.default
//
//        let date = Date(timeIntervalSinceNow: 36000)
//
//      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//
//        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
//
//
//    UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
//        print("成功建立通知...")
//        })
//------------page controll------------------
        let p0 = storyboard?.instantiateViewController(withIdentifier: "p0")
        let p1 = storyboard?.instantiateViewController(withIdentifier: "p1")
        let p2 = storyboard?.instantiateViewController(withIdentifier: "p2")
        
        list.append(p0!)
        list.append(p1!)
        list.append(p2!)
        
        setViewControllers([list[received]], direction: .forward, animated: true, completion: nil)
        

        dataSource = self
        // Do any additional setup after loading the view.
    }
    
  
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index = list.index(of: viewController) , index < list.count - 1{
            return list[index + 1 ]
            
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = list.index(of: viewController) , index > 0{
            return list[index - 1 ]
            
        }
        return nil
    }

 /*
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return list.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 1
    }
    */
    
 
    
    /*
    // MARK: - Navigation

     
     
     
     
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
