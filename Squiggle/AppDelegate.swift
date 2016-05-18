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
    let gestureWindow = NSWindow()
    let darkMode = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") == "Dark"

    
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
        //+++++++++++++ VISUAL EFFECTS +++++++++++++++++++++++++++++++++
        let visualEffectView = NSVisualEffectView(frame: NSMakeRect(0, 0, 0, 0))
        darkMode == true ? (visualEffectView.material = NSVisualEffectMaterial.UltraDark) : (visualEffectView.material = NSVisualEffectMaterial.Light)
        visualEffectView.blendingMode = NSVisualEffectBlendingMode.BehindWindow
        visualEffectView.state = NSVisualEffectState.Active
        gestureWindow.contentView = visualEffectView //add the visual effect
        gestureWindow.styleMask = NSFullSizeContentViewWindowMask | NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask
        gestureWindow.titleVisibility = .Hidden
        gestureWindow.titlebarAppearsTransparent = true
        gestureWindow.movableByWindowBackground = true
        gestureWindow.setContentSize(NSSize(width:450, height:300))
        gestureWindow.center()
        gestureWindow.releasedWhenClosed = false
        
        
        
        
        let textField = NSTextView(frame: NSMakeRect(0, 0, 180, 30))
        
        textField.string = "Some Text"
        textField.editable = false
        textField.backgroundColor = NSColor.brownColor()
        textField.selectable = false
        gestureWindow.contentView!.addSubview(textField)
        
        
        
        
        
        
        gestureWindow.makeKeyAndOrderFront(nil) //show itself and make it the frontmost window
        
        
    }
    
}

