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
    let defaultGestureTime = NSNumber(int: 800)
    
    override init() {
        //set the delault values
        if !KeychainManager.isGestureTimeSet() {
            KeychainManager.setGestureTime(defaultGestureTime)
        }
        
        if !KeychainManager.isLaunchAtLoginSet() {
            LaunchAtLoginManager.setLaunchAtStartup(true) //this will update KeyChainManager as well
        }
        
        //todo delete
        /*if KeychainManager.areGesturesSet() {
            print("Reference gesture")
            print(KeychainManager.getGestures()![0].xPoints)
            print(KeychainManager.getGestures()![0].yPoints)
        }*/
        
        
        gestureManager = GestureManager()
        
        super.init()
        
        acquirePrivileges()
        
        //listeners for scroll
        NSEvent.addGlobalMonitorForEventsMatchingMask(
            NSEventMask.ScrollWheelMask, handler: {(event: NSEvent) in
                self.gestureManager.scroll(event)
        })
        
        NSEvent.addLocalMonitorForEventsMatchingMask(
            NSEventMask.ScrollWheelMask, handler: {(event: NSEvent) in
                self.gestureManager.scrollLocal(event)
        })
        
        //listeners for lock/unlock
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
        gestureManager.setScreenLocked(true)
    }
    
    func unlockedEvent() {
        gestureManager.setScreenLocked(false)
        
        
        
        let notification = NSUserNotification()
        notification.title = "Sbiriguda"
        notification.informativeText = "Todo: display a notification if lots of tentatives were made."
        
        let notificationcenter = NSUserNotificationCenter.defaultUserNotificationCenter()
        notificationcenter.deliverNotification(notification)

        
        
        
    }
    
    internal func getGestureManagerInstance() -> GestureManager {
        return gestureManager
    }
}

