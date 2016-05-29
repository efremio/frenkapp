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
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var statusMenu: NSMenu!
    var settingsWindow = NSWindowController()
    var aboutWindow = NSWindowController()
    
    
    let widthSetup : CGFloat = 450
    let heightSetup : CGFloat = 300
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1) //get the system status bar
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        settingsWindow = SetupWindowController(windowNibName: "SetupWindowController")
        aboutWindow = AboutWindowController(windowNibName: "AboutWindowController")
        
    }
    @IBAction func openAbout(sender: AnyObject) {
        aboutWindow.showWindow(sender)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
    }
    
    @IBAction func nemuQuit(sender: NSMenuItem) {
        exit(0)
    }
    
    @IBAction func openSettings(sender: AnyObject) {
        settingsWindow.showWindow(sender)
    
    }
    

    /*let checkURL = NSURL(string: "http://www.google.com")
     NSWorkspace.sharedWorkspace().openURL(checkURL!)*/
    
    
}

