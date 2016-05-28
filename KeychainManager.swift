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
    
    static func setGestureTime(time : NSNumber) {
        try! Locksmith.updateData(["gestureTime": time], forUserAccount: "frenkapp_gestureTime")
    }
    
    static func isGestureTimeSet() -> Bool {
        let dictionary = Locksmith.loadDataForUserAccount("frenkapp_gestureTime")
        if(dictionary != nil) {
            for obj in dictionary! {
                if(obj.0 == "gestureTime") {
                    return true
                }
            }
        }
        return false
    }
    
    static func getGestureTime() -> NSNumber! {
        let dictionary = Locksmith.loadDataForUserAccount("frenkapp_gestureTime")
        if(dictionary != nil) {
            for obj in dictionary! {
                if(obj.0 == "gestureTime") {
                    return obj.1 as! NSNumber
                }
            }
        }
        return nil
    }
    
    static func setPassword(password : NSString) {
        try! Locksmith.updateData(["password": password], forUserAccount: "frenkapp_password")
    }
    
    static func isPasswordSet() -> Bool {
        let dictionary = Locksmith.loadDataForUserAccount("frenkapp_password")
        if(dictionary != nil) {
            for obj in dictionary! {
                if(obj.0 == "password") {
                    return true
                }
            }
        }
        return false
    }
    
    static func getPassword() -> NSString! {
        let dictionary = Locksmith.loadDataForUserAccount("frenkapp_password")
        if(dictionary != nil) {
            for obj in dictionary! {
                if(obj.0 == "password") {
                    return obj.1 as! NSString
                }
            }
        }
        return nil
    }
    
}