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
    
    private static var cachedData : AppData?
    
    static func setGestureTime(time : NSNumber) {
        let data = getData()
        data.gestureTime = time
        saveData(data)
    }
    
    static func setPassword(password : NSString) {
        let data = getData()
        data.password = password
        saveData(data)
    }
    
    static func setGestures(gestures : [Gesture]) {
        let data = getData()
        data.gestures = gestures
        saveData(data)
    }
    
    static func setLaunchAtLogin(launchAtLogin : Bool) {
        let data = getData()
        data.launchAtLogin = launchAtLogin
        saveData(data)
    }
    
    static func isGestureTimeSet() -> Bool {
        return getData().gestureTime != nil

    }
    
    static func isPasswordSet() -> Bool {
        return getData().password != nil

    }
    
    static func areGesturesSet() -> Bool {
        return getData().gestures != nil
    }
    
    static func isLaunchAtLoginSet() -> Bool {
        return getData().launchAtLogin != nil
        
    }
    
    static func getGestureTime() -> NSNumber? {
        return getData().gestureTime
    }
    
    static func getPassword() -> NSString? {
        return getData().password
    }
    
    static func getGestures() -> [Gesture]? {
        return getData().gestures
    }
    
    static func getLaunchAtLogin() -> Bool? {
        return getData().launchAtLogin
    }
    
    private static func getData() -> AppData {
        if cachedData != nil { //cache is not empty
            return cachedData!
        } else { //cache is empty
            let dictionary = Locksmith.loadDataForUserAccount("frenkapp_data")
            if(dictionary == nil) { //no keychain
                cachedData = AppData() //create a cache
                return cachedData!
            } else { //keychain found
                for obj in dictionary! {
                    if obj.0 == "data" {
                        cachedData = obj.1 as? AppData //create a cache
                        return cachedData!
                    }
                }
                //wrong keychain
                cachedData = AppData() //create a cache
                saveData(cachedData!) //save an empty keychain
                return cachedData!
            }
        }
    }
    
    private static func saveData(data : AppData) {
        try! Locksmith.updateData(["data": data], forUserAccount: "frenkapp_data")
        cachedData = data
    }
}