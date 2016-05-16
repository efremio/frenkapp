//
//  AppDelegate.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 09/12/15.
//  Copyright © 2015 Efrem Agnilleri. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
   
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1) //get the system status bar
    
    let myNewWindow = NSWindow(contentRect: NSMakeRect(0,0,640,480), styleMask: NSBorderlessWindowMask, backing: NSBackingStoreType.Buffered, defer: false)
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        let icon = NSImage(named: "statusIcon")
        icon?.template = true
        
        statusItem.image = icon
        statusItem.menu = statusMenu
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }
    
    @IBAction func nemuQuit(sender: NSMenuItem) {
        exit(0)
    }
    
    @IBAction func menuSetGesture(sender: NSMenuItem) {
        myNewWindow.opaque = false
        myNewWindow.movableByWindowBackground = true
        myNewWindow.backgroundColor = NSColor(hue: 0, saturation: 1, brightness: 0, alpha: 0.7)
        myNewWindow.makeKeyAndOrderFront(nil)
    }
    
}

