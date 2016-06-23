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
    let dataShare = DataShare.sharedInstance
    
    override init() {
        //set the delault values
        if !KeychainManager.isGestureTimeSet() {
            KeychainManager.setGestureTime(GlobalConstants.AppSettings.defaultGestureTime)
        }
        
        if !KeychainManager.isLaunchAtLoginSet() {
            LaunchAtLoginManager.setLaunchAtStartup(true) //this will update KeyChainManager as well
        }
        
        if !KeychainManager.areSoundsEnabledSet() {
            KeychainManager.setSoundsEnabled(GlobalConstants.AppSettings.defaultSoundsEnabled)
        }
        
        gestureManager = GestureManager()
        
        super.init()
        
        /*if !acquirePrivileges() {
            let notification = NSUserNotification()
            notification.title = "Action needed"
            notification.informativeText = "Go to System Preferences ▷ Security ▷ Privacy, and allow Frenk to control your Mac."
            
            let notificationcenter = NSUserNotificationCenter.defaultUserNotificationCenter()
            notificationcenter.deliverNotification(notification)

        }*/
        
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
        
        return accessEnabled == true
    }
    
    func lockedEvent() {
        gestureManager.setScreenLocked(true)
    }
    
    func unlockedEvent() {
        gestureManager.setScreenLocked(false)
    }
    
    internal func getGestureManagerInstance() -> GestureManager {
        return gestureManager
    }
}

