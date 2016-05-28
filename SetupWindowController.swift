//
//  SetupWindowController.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 27/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Cocoa

class SetupWindowController: NSWindowController {
    
    let defaultTime : Int32 = 450
    
    @IBOutlet var settingsWindow: NSWindow!
    @IBOutlet var prova: NSView!
    @IBOutlet var timeTextField: NSTextField!
    
    @IBOutlet var logoImageView: NSImageView!
    
    override func showWindow(sender: AnyObject?) {
        if(settingsWindow != nil && settingsWindow.miniaturized) { //if it is miniaturized, deminiaturize
            print("was miniaturized")
            settingsWindow.deminiaturize(settingsWindow)
            settingsWindow.orderFrontRegardless()
        } else if(settingsWindow != nil && settingsWindow.visible){ //if it is somewhere already open, show to the front
            print("was visible but in culo")
            settingsWindow.collectionBehavior = .MoveToActiveSpace
            settingsWindow.orderFrontRegardless()
        } else {
            super.showWindow(sender)
            settingsWindow.orderFrontRegardless()
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        print("fanculo")
        
        let darkMode = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") == "Dark"
        
        let visualEffectView = NSVisualEffectView(frame: NSMakeRect(0, 0, 0, 0))
        darkMode == true ? (visualEffectView.material = NSVisualEffectMaterial.UltraDark) : (visualEffectView.material = NSVisualEffectMaterial.MediumLight)
        visualEffectView.blendingMode = NSVisualEffectBlendingMode.BehindWindow
        visualEffectView.state = NSVisualEffectState.Active
        
        let previousContentView = settingsWindow.contentView
        settingsWindow.contentView = visualEffectView //add the visual effect
        settingsWindow.contentView?.addSubview(previousContentView!)
        
        settingsWindow.styleMask = NSFullSizeContentViewWindowMask | NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask
        settingsWindow.titleVisibility = .Hidden
        settingsWindow.titlebarAppearsTransparent = true
        settingsWindow.movableByWindowBackground = true
        settingsWindow.releasedWhenClosed = false
 

        addLogo(darkMode)
        
        
        
        ////////////
        updateTimeLabel(defaultTime)
        
    }
    
    
    func addLogo(darkMode : Bool) {
        //tint the logo
        let logo = logoImageView.image
        logo!.lockFocus()
        darkMode == false ? (NSColor(red: 0.25, green: 0.75, blue: 0.793, alpha: 1).set()) : (NSColor(red: 0.75, green: 0.25, blue: 0.193, alpha: 1).set())
        let imageRect = NSRect(origin: NSZeroPoint, size: logo!.size)
        NSRectFillUsingOperation(imageRect, NSCompositingOperation.CompositeSourceAtop)
        logo?.unlockFocus()
        //the logo is tinted
        
        logoImageView.image = logo
        logoImageView.imageScaling = .ScaleProportionallyUpOrDown
    }
    
    @IBAction func timeChanged(sender: NSSlider) {
        updateTimeLabel(sender.intValue) //update label
        if(NSApplication.sharedApplication().currentEvent?.type == NSEventType.LeftMouseUp) {
            print("salva valore")
        }
    }
    
    func updateTimeLabel(time: Int32) {
        timeTextField.stringValue = "Now: "+time.description+" ms"
    }
    
}
