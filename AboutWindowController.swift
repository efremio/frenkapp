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
    
    let checkURL = URL(string: GlobalConstants.AppSettings.urlWeb)
    
    override func showWindow(_ sender: Any?) {
        if aboutWindow != nil && aboutWindow.isMiniaturized { //if it is miniaturized, deminiaturize
            aboutWindow.deminiaturize(aboutWindow)
            aboutWindow.orderFrontRegardless()
        } else if aboutWindow != nil && aboutWindow.isVisible { //if it is somewhere already open, show to the front
            aboutWindow.collectionBehavior = .moveToActiveSpace
            aboutWindow.orderFrontRegardless()
        } else {
            super.showWindow(sender)
            aboutWindow.orderFrontRegardless()
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        let visualEffectView = NSVisualEffectView(frame: NSMakeRect(0, 0, 0, 0))
        visualEffectView.material = NSVisualEffectMaterial.dark
        visualEffectView.blendingMode = NSVisualEffectBlendingMode.behindWindow
        visualEffectView.state = NSVisualEffectState.active
        
        let previousContentView = aboutWindow.contentView
        aboutWindow.contentView = visualEffectView //add the visual effect
        aboutWindow.contentView?.addSubview(previousContentView!)
        
        /*aboutWindow.contentView!.wantsLayer = true
        
        let layer = CAGradientLayer()
        layer.frame = aboutWindow.contentLayoutRect //CGRect(x: 0, y: 0, width: 160, height: 160)
        layer.colors = [
            /*NSColor(red: 107/255, green: 210/255, blue: 118/255, alpha: 1).CGColor,*/
            NSColor(red: 60/255, green: 205/255, blue: 150/255, alpha: 1).CGColor,
            NSColor(red: 33/255, green: 184/255, blue: 232/255, alpha: 1).CGColor
            
        ]
        layer.startPoint = NSPoint(x: 0, y: 0)
        layer.endPoint = NSPoint(x: 1, y: 0.3)
        layer.zPosition = -1
        aboutWindow.contentView?.layer?.addSublayer(layer)*/
        
        /*aboutWindow.contentView!.wantsLayer = true
        aboutWindow.contentView?.layer?.contents = NSImage(named: "background3.png")*/
        
        
        aboutWindow.styleMask = [NSFullSizeContentViewWindowMask, NSTitledWindowMask, NSClosableWindowMask]
        //aboutWindow.styleMask = NSFullSizeContentViewWindowMask | NSTitledWindowMask | NSClosableWindowMask
        aboutWindow.titleVisibility = .hidden
        aboutWindow.titlebarAppearsTransparent = true
        aboutWindow.isMovableByWindowBackground = true
        aboutWindow.isReleasedWhenClosed = false
        
        
        addLogo()
        
        //modify about text
        var rawText = aboutTextField.stringValue
        rawText = rawText.replacingOccurrences(of: "%VERSION%", with: GlobalConstants.AppSettings.versionNumber!)
        
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        
        rawText = rawText.replacingOccurrences(of: "%YEAR%", with: (components.year?.description)!)

        aboutTextField.stringValue = rawText
        
    }
    
    func addLogo() {
        //tint the logo
        let logo = logoImageView.image
        logo!.lockFocus()
        GlobalConstants.Colors.green.set()
        //NSColor.whiteColor().set()
        let imageRect = NSRect(origin: NSZeroPoint, size: logo!.size)
        NSRectFillUsingOperation(imageRect, NSCompositingOperation.sourceAtop)
        logo?.unlockFocus()
        //the logo is tinted
        
        logoImageView.image = logo
        logoImageView.imageScaling = .scaleProportionallyUpOrDown
    }
    
    @IBAction func goToURL(_ sender: AnyObject) {
        NSWorkspace.shared().open(checkURL!)
    }
    
}
