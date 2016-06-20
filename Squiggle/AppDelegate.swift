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
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1) //get the system status bar
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        NSUserNotificationCenter.defaultUserNotificationCenter().delegate = self
    
    
    
        // Insert code here to initialize your application
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        settingsWindow = SetupWindowController(windowNibName: "SetupWindowController")
        aboutWindow = AboutWindowController(windowNibName: "AboutWindowController")
    }
    
    func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        return true
    }
    
    @IBAction func openSettings(sender: AnyObject) {
        settingsWindow.showWindow(sender)
    }
    
    @IBAction func openAbout(sender: AnyObject) {
        aboutWindow.showWindow(sender)
    }
    
    @IBAction func checkForUpdates(sender: NSMenuItem) {
        let versionNumber = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
        let stringUrl = "http://www.frenkapp.com/update.php?myVersion=" + versionNumber!
        let checkURL = NSURL(string: stringUrl)
        
        NSWorkspace.sharedWorkspace().openURL(checkURL!)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
    }
    
    @IBAction func menuQuit(sender: NSMenuItem) {
        exit(0)
    }
}

