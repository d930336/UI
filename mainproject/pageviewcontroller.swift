//
//  pageviewcontroller.swift
//  mainproject
//
//  Created by Benson Yang on 2019/3/14.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit
import UserNotifications
import BWWalkthrough

class pageviewcontroller: UIPageViewController , UIPageViewControllerDataSource,BWWalkthroughViewControllerDelegate{
    
    var list = [UIViewController]()
    var received : Int = 1
    var testValue = false
    var userDefaults = UserDefaults.standard
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if testValue == true{
             showWalkthrough()
            userDefaults.set(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
        
        if !userDefaults.bool(forKey: "walkthroughPresented") {
            
            showWalkthrough()
            
            userDefaults.set(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
    }
    
    func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "welcomePage", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewController(withIdentifier: "walk0")
        let page_one = stb.instantiateViewController(withIdentifier: "walk1")
        let page_two = stb.instantiateViewController(withIdentifier: "walk2")
        let page_three = stb.instantiateViewController(withIdentifier: "walk3")
        let page_four = stb.instantiateViewController(withIdentifier: "walk4")

        
        // Attach the pages to the master
        walkthrough.delegate = self as BWWalkthroughViewControllerDelegate
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        walkthrough.add(viewController:page_zero)
        walkthrough.add(viewController:page_four)

        
        self.present(walkthrough, animated: true, completion: nil)
    }
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK:- viewDidload Begin -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(firstCheck)
        
        if !userToken.bool(forKey: "fisrtCheck"){
            if firstCheck == "0" && logoutCheck == false{
                firstCheck = firstCheckStore
            }else if firstCheck == "0"{
                self.showAlertMessage(title: "省錢生活", message: "登入以開啟其餘功能")
            }
        }
        
//        if !userToken.bool(forKey: "sqliteCheck"){
            if secondCheck == false{
                secondCheck = sqliteCheck
            }
//        }
        
        print(firstCheck)
        print(secondCheck)
        
// MARK:--page controll--
        let p0 = storyboard?.instantiateViewController(withIdentifier: "p0")
        let p1 = storyboard?.instantiateViewController(withIdentifier: "p1")
        let p2 = storyboard?.instantiateViewController(withIdentifier: "p2")
        
        list.append(p0!)
        list.append(p1!)
        list.append(p2!)
        
        setViewControllers([list[received]], direction: .forward, animated: true, completion: nil)
        

        dataSource = self
    }
    
// MARK: view didload end
  
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

    // MARK: Alert
      func showAlertMessage(title: String, message: String) {
              let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
              let okAction = UIAlertAction(title: "確認", style: .default, handler: nil) // 產生確認按鍵
              inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController
              self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
          }
//
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return list.count
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return 1
//    }
    
    
 
    
    /*
    // MARK: - Navigation

     
     
     
     
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
