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
        let darkMode = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") == "Dark"
        print(darkMode)
        if(darkMode) {
            visualEffectView.material = NSVisualEffectMaterial.UltraDark
        } else {
            visualEffectView.material = NSVisualEffectMaterial.Light
        }
        visualEffectView.blendingMode = NSVisualEffectBlendingMode.BehindWindow
        visualEffectView.state = NSVisualEffectState.Active
        visualEffectView.maskImage = maskImage(cornerRadius: 8.0)
        gestureWindow.contentView = visualEffectView //add the visual effect
        
        gestureWindow.titleVisibility = .Visible
        gestureWindow.titlebarAppearsTransparent = true
        gestureWindow.movableByWindowBackground = true
        gestureWindow.styleMask = NSBorderlessWindowMask
        gestureWindow.setContentSize(NSSize(width:450, height:300))
        gestureWindow.center()
        
        
        
        
        
        
        
        gestureWindow.makeKeyAndOrderFront(nil) //tells the window to show itself and make it the frontmost window
    }
    
    func maskImage(cornerRadius cornerRadius: CGFloat) -> NSImage {
        let edgeLength = 2.0 * cornerRadius + 1.0
        let maskImage = NSImage(size: NSSize(width: edgeLength, height: edgeLength), flipped: false) { rect in
            let bezierPath = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
            NSColor.blackColor().set()
            bezierPath.fill()
            return true
        }
        maskImage.capInsets = NSEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius)
        maskImage.resizingMode = .Stretch
        return maskImage
    }
    
}

