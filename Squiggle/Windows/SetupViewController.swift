//
//  SetupViewController.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 27/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Cocoa

class SetupViewController: NSViewController {

    @IBOutlet var settingsWindow: NSWindow!
    let widthSetup : CGFloat = 450
    let heightSetup : CGFloat = 300

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
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
        settingsWindow.setContentSize(NSSize(width:widthSetup, height:heightSetup))
        settingsWindow.center()
        settingsWindow.releasedWhenClosed = false
        
        
        
        addSetupElements(darkMode)
        
        
        

    }
    
    
    func addSetupElements(darkMode : Bool) {
        //adding the logo
        let widthLogo : CGFloat = 60
        let heightLogo : CGFloat = 60
        let logoView = NSImageView(frame: NSRect(x: widthSetup/2-widthLogo/2, y: heightSetup-widthLogo-30, width: widthLogo, height: heightLogo))
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
        
        
        //adding the labelsc
        /*let textField = NSTextView(frame: NSMakeRect(0, heightSetup-60, widthSetup, 30))
         
         textField.string = "Password:"
         textField.editable = false
         //textField.backgroundColor = NSColor.clearColor()
         
         darkMode == true ? (textField.textColor = NSColor.whiteColor()) : (textField.textColor = NSColor.blackColor())
         //textField.textColor = NSColor(red: 0.25, green: 0.75, blue: 0.793, alpha: 1)
         textField.font = NSFont(name: "Helvetica", size: 30)
         textField.selectable = false
         gestureWindow.contentView!.addSubview(textField)*/
    }

    
}
