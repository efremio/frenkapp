//
//  AppDelegate.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 09/12/15.
//  Copyright © 2015 Efrem Agnilleri. All rights reserved.
//

import Cocoa
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    var settingsWindow = NSWindowController()
    var aboutWindow = NSWindowController()
    
    let statusItem = NSStatusBar.system().statusItem(withLength: -2) //get the system status bar
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        NSUserNotificationCenter.default.delegate = self
    
        // Insert code here to initialize your application
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true
        
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        settingsWindow = SetupWindowController(windowNibName: "SetupWindowController")
        aboutWindow = AboutWindowController(windowNibName: "AboutWindowController")
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    @IBAction func openSettings(_ sender: AnyObject) {
        settingsWindow.showWindow(sender)
    }
    
    @IBAction func openAbout(_ sender: AnyObject) {
        aboutWindow.showWindow(sender)
    }
    
    @IBAction func checkForUpdates(_ sender: NSMenuItem) {
        let stringUrl = GlobalConstants.AppSettings.urlWebVersionCheck
        let checkURL = URL(string: stringUrl)
        
        NSWorkspace.shared().open(checkURL!)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    @IBAction func menuQuit(_ sender: NSMenuItem) {
        exit(0)
    }
}

