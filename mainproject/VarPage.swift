//
//  URLPage.swift
//  mainproject
//
//  Created by Benson Yang on 2019/10/3.
//  Copyright © 2019 Benson Yang. All rights reserved.
//

import Foundation
import UIKit
import SQLite

//MARK:common
public class common{
    var UrlId :String = "de94cb8f"
    
    init(UrlId:String) {
        self.UrlId = UrlId
    }
}

public var UrlId :String = "de94cb8f"
public var userToken = UserDefaults.standard
public var firstCheck:String = "0"
public var secondCheck:Bool = false
public var logoutCheck:Bool = false
public var couponListUrl : String = ""
public var couponTitle : String = ""
public var couponDiscount : String = "0"
public var couponSave : Int = 0
public func resetTheCouponValue(){
    couponDiscount = "0"
    couponTitle = ""
    couponSave = 0
}

//MARK:store

public var Token = userToken.value(forKey: "Token")
public var sqliteCheck = Bool("\(userToken.bool(forKey: "sqliteCheck"))") ?? false
public var getUserId = String("\(userToken.value(forKey: "userId")!)")
public var getUserPassword = String("\(userToken.value(forKey: "userPassword")!)")
public var firstCheckStore:String = String("\(userToken.value(forKey: "firstCheck") ?? "0")")

//MARK:SQlite

public var usersTableAP = Table("AccountingPage2")
public var id = Expression<Int>("id")
public var sqDate = Expression<String>("date")
public var sqName = Expression<String>("name")
public var sqPrice = Expression<Int>("price")
public var sqMonth = Expression<String>("month")
public var sqCoupon = Expression<String>("coupon")
public var sqDiscount = Expression<Int>("discount")
public var sqSave = Expression<Int>("save")
var databaseCon: Connection!
public func connectDataBase(){
    do {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileUrl = documentDirectory.appendingPathComponent("users").appendingPathExtension("sqlite3")
        let database = try Connection(fileUrl.path)
        databaseCon = database
        print("connected")
    } catch {
        print(error)
    }
}
