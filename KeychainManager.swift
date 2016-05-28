//
//  KeychainManager.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 28/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Foundation
import Locksmith

class KeychainManager {
    static private let userAccount = "frenkapp"
    
    static func setGestureTime(time : NSNumber) {
        try! Locksmith.updateData(["gestureTime": time], forUserAccount: userAccount)
    }
    
    static func isGestureTimeSet() -> Bool {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount)
        for obj in dictionary! {
            if(obj.0 == "gestureTime") {
                return true
            }
        }
        return false
    }
    
    static func getGestureTime() -> NSNumber! {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount)
        for obj in dictionary! {
            if(obj.0 == "gestureTime") {
                return obj.1 as! NSNumber
            }
        }
        return nil
    }
    
}