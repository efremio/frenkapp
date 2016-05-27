//
//  Settings.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 22/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//


import Cocoa
import AppKit

@NSApplicationMain
class Settings: NSObject, NSApplicationDelegate {

    let settingsWindow = NSWindow()
    
    override init() {
        
        print("start started!")
        let darkMode = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") == "Dark"
        
        let visualEffectView = NSVisualEffectView(frame: NSMakeRect(0, 0, 0, 0))
        darkMode == true ? (visualEffectView.material = NSVisualEffectMaterial.UltraDark) : (visualEffectView.material = NSVisualEffectMaterial.Light)
        visualEffectView.blendingMode = NSVisualEffectBlendingMode.BehindWindow
        visualEffectView.state = NSVisualEffectState.Active
        settingsWindow.contentView = visualEffectView //add the visual effect
        
        settingsWindow.styleMask = NSFullSizeContentViewWindowMask | NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask
        settingsWindow.titleVisibility = .Hidden
        settingsWindow.titlebarAppearsTransparent = true
        settingsWindow.movableByWindowBackground = true
        settingsWindow.setContentSize(NSSize(width:200, height:200))
        settingsWindow.center()
        settingsWindow.releasedWhenClosed = false
        
        //adding the logo
        let widthLogo : CGFloat = 60
        let heightLogo : CGFloat = 60
        let logoView = NSImageView(frame: NSRect(x: 200/2-widthLogo/2, y: 200-widthLogo-30, width: widthLogo, height: heightLogo))
        //tint the logo
        let logo = NSImage(named: "frenk_logo.png")
        logo!.lockFocus()
        darkMode == true ? (NSColor(red: 0.25, green: 0.75, blue: 0.793, alpha: 1).set()) : (NSColor(red: 0.75, green: 0.25, blue: 0.193, alpha: 1).set())
        let imageRect = NSRect(origin: NSZeroPoint, size: logo!.size)
        NSRectFillUsingOperation(imageRect, NSCompositingOperation.CompositeSourceAtop)
        logo?.unlockFocus()
        //the logo is tinted
        
        logoView.image = logo
        logoView.imageScaling = .ScaleProportionallyUpOrDown
        settingsWindow.contentView!.addSubview(logoView)
        
        
        
        settingsWindow.orderFrontRegardless() //show itself and make it the frontmost window
    }
    
}