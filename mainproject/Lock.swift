//
//  Lock.swift
//  mainproject
//
//  Created by Benson Yang on 2019/7/30.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import UIKit
import LocalAuthentication

class Lock: UIViewController {

    //创建一个手势密码view
    let gestureView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        //手势密码
        gestureView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:self.view.frame.height)
        view.addSubview(gestureView)
        
        //指纹识别
        let fingerPrint = UserDefaults.standard.value(forKey: "fingerPrint")
        if ((fingerPrint != nil) && fingerPrint as! Bool)
        {
            //指纹解锁
            let authenticationContext = LAContext()
            var error: NSError?
            
            //步骤1：检查Touch ID是否可用
            let isTouchIdAvailable = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,error: &error)
            //真机上可以使用,模拟器上不可使用
            if isTouchIdAvailable
            {
                print("恭喜，Touch ID可以使用！")
                //步骤2：获取指纹验证结果
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "需要验证您的指纹来确认您的身份信息", reply:
                    {
                        (success, error) -> Void in
                        if success
                        {
                            NSLog("恭喜，您通过了Touch ID指纹验证！")
                            "恭喜，您通过了Touch ID指纹验证！"
                            //回主线程去隐藏View,若是在子线程中隐藏则延迟太厉害
                            OperationQueue.main.addOperation
                                {
                                    print("当前线程是\(Thread.current)")
//                                    self.gestureView.isHidden = true
                            }
                            return
                            
                        }
                        else
                        {
                            print("抱歉，您未能通过Touch ID指纹验证！\n\(String(describing: error))")
                        }
                })
                
            }
            else
            {
                print("指纹不能用")
            }
            
            
        }
        else
        {
            print("证明没添加过")
        }
        
    }
    
    
}
