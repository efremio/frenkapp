//
//  SetupWindowController.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 27/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Cocoa
import Collaboration

class SetupWindowController: NSWindowController, NSWindowDelegate {
    
    @IBOutlet var settingsWindow: NSWindow!
    @IBOutlet var prova: NSView!
    @IBOutlet var timeTextField: NSTextField!
    @IBOutlet var setGestureImage: NSButton!
    @IBOutlet var gestureTimeSliderCell: NSSliderCell!
    @IBOutlet var updatePasswordButton: NSButtonCell!
    
    @IBOutlet var launchAtLoginButton: NSButton!
    
    //tab view
    @IBOutlet var tabView: NSTabView!
    
    //tab view items
    @IBOutlet var passwordTabViewItem: NSTabViewItem!
    @IBOutlet var gesturesTabViewItem: NSTabViewItem!
    
    @IBOutlet var passwordField: NSSecureTextField!
    @IBOutlet var logoImageView: NSImageView!
    @IBOutlet var passwordAlertTextField: NSTextField!
    @IBOutlet var passwordOkField: NSTextField!
    
    @IBOutlet var thumbsUpImageView: NSImageView!
    @IBOutlet var thumbsDownImageView: NSImageView!
    @IBOutlet var mouseImageView: NSImageView!
    @IBOutlet var scrollImageView: NSImageView!
    
    @IBOutlet var countGesturesButton: NSButton!
    @IBOutlet var countGesturesLabel: NSTextField!
    
    let dataShare = DataShare.sharedInstance
    
    override func showWindow(sender: AnyObject?) {
        if(settingsWindow != nil && settingsWindow.miniaturized) { //if it is miniaturized, deminiaturize
            settingsWindow.deminiaturize(settingsWindow)
            settingsWindow.orderFrontRegardless()
        } else if(settingsWindow != nil && settingsWindow.visible){ //if it is somewhere already open, show to the front
            settingsWindow.collectionBehavior = .MoveToActiveSpace
            settingsWindow.orderFrontRegardless()
        } else {
            super.showWindow(sender)
            settingsWindow.orderFrontRegardless()
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        //register itself
        dataShare.setupWindowControllerInstance = self
        
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
        
        thumbsUpImageView.hidden = true
        thumbsDownImageView.hidden = true
        passwordField.bezeled = false
        passwordField.bezelStyle = NSTextFieldBezelStyle.SquareBezel
        
        
        tabView.selectFirstTabViewItem(self)
        
        
        
        let bounds = gesturesTabViewItem.view?.bounds
        gesturesTabViewItem.view?.addTrackingRect(bounds!, owner: self, userData: nil, assumeInside: true)
        
        
        
        
        //get gesture time
        let time = KeychainManager.getGestureTime()
        updateTimeLabel(time!)
        gestureTimeSliderCell.integerValue = time as! Int
        
        //init
        passwordAlertTextField.stringValue = ""
        passwordOkField.stringValue = ""
        scrollImageView.hidden = true
        countGesturesButton.hidden = true
        countGesturesLabel.hidden = true
        countGesturesButton.title = "0"
        countGesturesLabel.stringValue = "gestures"
        if KeychainManager.isLaunchAtLoginSet() && KeychainManager.getLaunchAtLogin() == true {
            launchAtLoginButton.state = NSOnState
        } else {
            launchAtLoginButton.state = NSOffState
        }
        
        
        //labels
        if(KeychainManager.isPasswordSet()) {
            passwordTabViewItem.label = "Update password"
            updatePasswordButton.title = "Update password"
        } else {
            passwordTabViewItem.label = "Set password"
            updatePasswordButton.title = "Set password"
        }
        
        if(KeychainManager.areGesturesSet()) {
            gesturesTabViewItem.label = "Update gestures"
        } else {
            gesturesTabViewItem.label = "Set gestures"
        }
    }
    
    func windowWillClose(notification: NSNotification) {
        //reset stuff, otherwise everything is like the last time when opening the window again
        windowDidLoad()
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
        updateTimeLabel(NSNumber(int: sender.intValue)) //update label
        
        //if mouseUp
        if(NSApplication.sharedApplication().currentEvent?.type == NSEventType.LeftMouseUp) {
            KeychainManager.setGestureTime(NSNumber(int: sender.intValue))
        }
    }
    
    func updateTimeLabel(time: NSNumber) {
        timeTextField.stringValue = "Now: "+time.description+" ms"
    }
    
    @IBAction func mouseOverSettingGesture(sender: AnyObject) {
        print("erbwbwbwbwbww")
    }
   
    @IBAction func updatePassword(sender: AnyObject) {
        //check if the password is correct
        let identity = CBUserIdentity(posixUID: getuid(), authority: CBIdentityAuthority.defaultIdentityAuthority())
        let passOk = identity?.authenticateWithPassword(passwordField.stringValue)
        
        if(passOk == true) {
            KeychainManager.setPassword(NSString(string: passwordField.stringValue)) //store the password
            
            //update labels
            passwordAlertTextField.stringValue = ""
            passwordOkField.stringValue = "Your password has been securely saved. It will be used only to unlock your Mac."
            
            //update buttons
            passwordTabViewItem.label = "Update password"
            updatePasswordButton.title = "Update password"
            
            //thumbs up!
            thumbsUpImageView.hidden = false
            thumbsDownImageView.hidden = true
        } else {
            //update labels
            passwordAlertTextField.stringValue = "The given password is not the current user's one."
            passwordOkField.stringValue = ""
            
            //thumbs up!
            thumbsUpImageView.hidden = true
            thumbsDownImageView.hidden = false
            
            //update buttons
            if(KeychainManager.isPasswordSet()) {
                passwordTabViewItem.label = "Update password"
                updatePasswordButton.title = "Update password"
            } else {
                passwordTabViewItem.label = "Set password"
                updatePasswordButton.title = "Set password"
            }
        }
        
        //clean
        passwordField.stringValue = ""
        
    }
    
    //it's a precondition for recording the gesture
    override func mouseEntered(theEvent: NSEvent) {
        dataShare.canRecord = true
        
        mouseImageView.hidden = true
        scrollImageView.hidden = false
        countGesturesButton.hidden = false
        countGesturesLabel.hidden = false
    }
    
    override func mouseExited(theEvent: NSEvent) {
        dataShare.canRecord = false
        
        
        
        mouseImageView.hidden = false
        scrollImageView.hidden = true
        countGesturesButton.hidden = true
        countGesturesLabel.hidden = true
        
    }
    
    func updateGestureNumber(number: NSNumber) {
        countGesturesButton.title = number.description
        if(number == 1) {
            countGesturesLabel.stringValue = "gesture"
        } else {
            countGesturesLabel.stringValue = "gestures"
        }
    }
    
    @IBAction func startAtLoginToggle(sender: NSButton) {        
        if launchAtLoginButton.state == NSOnState {
            LaunchAtLoginManager.setLaunchAtStartup(true)
        } else {
            LaunchAtLoginManager.setLaunchAtStartup(false)
        }
    }
    
}
