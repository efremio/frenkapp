//
//  AboutWindowController.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 28/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Cocoa

class AboutWindowController: NSWindowController {
    
    @IBOutlet var aboutWindow: NSWindow!
    @IBOutlet var logoImageView: NSImageView!
    @IBOutlet var scrollView: NSScrollView!
    @IBOutlet var aboutTextField: NSTextField!
    
    let checkURL = NSURL(string: "http://www.frenkapp.com")
    let versionNumber = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
    
    override func showWindow(sender: AnyObject?) {
        if aboutWindow != nil && aboutWindow.miniaturized { //if it is miniaturized, deminiaturize
            aboutWindow.deminiaturize(aboutWindow)
            aboutWindow.orderFrontRegardless()
        } else if aboutWindow != nil && aboutWindow.visible { //if it is somewhere already open, show to the front
            aboutWindow.collectionBehavior = .MoveToActiveSpace
            aboutWindow.orderFrontRegardless()
        } else {
            super.showWindow(sender)
            aboutWindow.orderFrontRegardless()
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        //let darkMode = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") == "Dark"
        
        let visualEffectView = NSVisualEffectView(frame: NSMakeRect(0, 0, 0, 0))
        visualEffectView.material = NSVisualEffectMaterial.MediumLight
        visualEffectView.blendingMode = NSVisualEffectBlendingMode.BehindWindow
        visualEffectView.state = NSVisualEffectState.Active
        
        let previousContentView = aboutWindow.contentView
        aboutWindow.contentView = visualEffectView //add the visual effect
        aboutWindow.contentView?.addSubview(previousContentView!)
        
        aboutWindow.styleMask = NSFullSizeContentViewWindowMask | NSTitledWindowMask | NSClosableWindowMask
        aboutWindow.titleVisibility = .Hidden
        aboutWindow.titlebarAppearsTransparent = true
        aboutWindow.movableByWindowBackground = true
        aboutWindow.releasedWhenClosed = false
        
        
        addLogo()
        
        //modify about text
        var rawText = aboutTextField.stringValue
        rawText = rawText.stringByReplacingOccurrencesOfString("%VERSION%", withString: versionNumber!)
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        rawText = rawText.stringByReplacingOccurrencesOfString("%YEAR%", withString: components.year.description)

        aboutTextField.stringValue = rawText
        
    }
    
    func addLogo() {
        //tint the logo
        let logo = logoImageView.image
        logo!.lockFocus()
        NSColor(red: 0.25, green: 0.75, blue: 0.793, alpha: 1).set()
        let imageRect = NSRect(origin: NSZeroPoint, size: logo!.size)
        NSRectFillUsingOperation(imageRect, NSCompositingOperation.CompositeSourceAtop)
        logo?.unlockFocus()
        //the logo is tinted
        
        logoImageView.image = logo
        logoImageView.imageScaling = .ScaleProportionallyUpOrDown
    }
    
    @IBAction func goToURL(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().openURL(checkURL!)
    }
    
}
