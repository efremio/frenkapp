//
//  StatusMenuController.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 10/12/15.
//  Copyright © 2015 Efrem Agnilleri. All rights reserved.
//

import Cocoa
import AppKit
import Foundation
import Security
import Collaboration
import OpenDirectory

class StatusMenuController: NSObject {
    
    var gestureManager : GestureManager
    let defaultGestureTime = NSNumber(int: 450)
    
    override init() {
        //set the delault values
        if(!KeychainManager.isGestureTimeSet()) {
            KeychainManager.setGestureTime(defaultGestureTime)
        }
               
        gestureManager = GestureManager()
        
        super.init()
        
        acquirePrivileges()
        
        NSEvent.addGlobalMonitorForEventsMatchingMask(
            NSEventMask.ScrollWheelMask, handler: {(event: NSEvent) in
                self.gestureManager.scroll(event)
        })
        
        NSEvent.addLocalMonitorForEventsMatchingMask(
            NSEventMask.ScrollWheelMask, handler: {(event: NSEvent) in
                self.gestureManager.scrollLocal(event)
        })
        
        NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.lockedEvent), name: "com.apple.screenIsLocked", object: nil)
        
        NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.unlockedEvent), name: "com.apple.screenIsUnlocked", object: nil)
    }
    
    func acquirePrivileges() -> Bool {
        let accessEnabled = AXIsProcessTrustedWithOptions(
            [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true])
        
        if accessEnabled != true {
            print("You need to enable the keylogger in the System Prefrences")
        }
        return accessEnabled == true
    }
    
    func lockedEvent() {
        gestureManager.isScreenLocked(true)
    }
    
    func unlockedEvent() {
        gestureManager.isScreenLocked(false)
    }
}

