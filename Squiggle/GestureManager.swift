//
//  GestureManager.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 15/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Cocoa
import Foundation
import Security

class GestureManager : NSObject {
    //variables initialization
    var gestures = [Gesture]()
    
    private var isScreenLocked = false
    var lastGestureTimer = NSTimer.init()
    let dataShare = DataShare.sharedInstance
    
    var x : CGFloat = 0
    var y : CGFloat = 0
    
    /*init(referenceGestures : [Gesture]) {
     self.referenceGestures = referenceGestures
     }*/
    
    //used to record the gesture
    func scrollLocal(event : NSEvent) -> NSEvent {
        if dataShare.canRecord {
            if event.phase == NSEventPhase.Began {
                let newGesture = Gesture()
                newGesture.timeStart = event.timestamp
                gestures.append(newGesture)
                lastGestureTimer.invalidate()
                x = 0
                y = 0
            } else if event.phase == NSEventPhase.Changed {
                x += event.deltaX
                y += event.deltaY
                gestures.last?.xPoints.append(x)
                gestures.last?.yPoints.append(y)
                
            } else if event.phase == NSEventPhase.Ended {
                gestures.last?.timeEnd = event.timestamp
                
                //update the graphics
                dataShare.setupWindowControllerInstance!.updateGestureNumber(gestures.count)
                
                
                //gesture ended, last one?
                lastGestureTimer.invalidate()
                lastGestureTimer = NSTimer.scheduledTimerWithTimeInterval((KeychainManager.getGestureTime() as! Double)/1000, target: self, selector: #selector(self.lastGestureRecordingTimerFired(_:)), userInfo: nil, repeats: false)
            }
        }
        return event
    }
    
    func scroll(event : NSEvent) {
        if isScreenLocked {
            if event.phase == NSEventPhase.Began {
                let newGesture = Gesture()
                newGesture.timeStart = event.timestamp
                gestures.append(newGesture)
                lastGestureTimer.invalidate()
                x = 0
                y = 0
            } else if event.phase == NSEventPhase.Changed {
                
                x += event.deltaX
                y += event.deltaY
                gestures.last?.xPoints.append(x)
                gestures.last?.yPoints.append(y)
                
            } else if event.phase == NSEventPhase.Ended {
                gestures.last?.timeEnd = event.timestamp
                
                //anticipate the unlock
                if KeychainManager.areGesturesSet() && gestures.count == KeychainManager.getGestures()!.count {
                    manageUnlock()
                } else {
                    
                    //gesture ended, last one?
                    lastGestureTimer.invalidate()
                    lastGestureTimer = NSTimer.scheduledTimerWithTimeInterval((KeychainManager.getGestureTime() as! Double)/1000, target: self, selector: #selector(self.lastGestureUnlockTimerFired(_:)), userInfo: nil, repeats: false)
                    
                }
            }
        }
    }
    
    @objc private func lastGestureUnlockTimerFired(timer : NSTimer!) {
        manageUnlock()
    }
    
    func manageUnlock() {
        //it was the last gesture
        
        if isScreenLocked {
            if areGesturesCorrelated() {
                unlock()
            }
        }
        
        //delete gestures
        gestures.removeAll()
    }
    
    //used to save a new gesture
    @objc private func lastGestureRecordingTimerFired(timer : NSTimer!) {
        //it was the last gesture
        
        let messages = checkSequenceValidity() //it returns warnings and errors about the sequence
        //sort the messages in errors and warnings
        var errors = [Message]()
        var warnings = [Message]()
        for m in messages {
            if m.messageType == MessageType.errorMEssage {
                errors.append(m)
            } else if m.messageType == MessageType.warningMessage {
                warnings.append(m)
            }
        }
        
        if errors.count > 0 { //if messages array contains at least one error
            //KeychainManager.setGestures(gestures) must be called after password check
            
            //notify the graphics
            dataShare.setupWindowControllerInstance!.errorsInGestureSequence(errors)
        } else if warnings.count > 0 { //if messages array contains at least one warning
            //notify the graphics
            dataShare.setupWindowControllerInstance!.warningsInGestureSequence(warnings)
        } else {
            //notify the graphics
            
            dataShare.sequenceBeingRecorded = gestures
            dataShare.setupWindowControllerInstance!.gestureIsValid()
        }
        
        
        //delete gestures
        gestures.removeAll()
        
        //update the graphics
        dataShare.setupWindowControllerInstance!.updateGestureNumber(gestures.count)
    }
    
    private func checkSequenceValidity() -> [Message] {
        var messages = [Message]()
        
        //check length
        if gestures.count < 1 {
            messages.append(Message(messageType: MessageType.errorMEssage, string: "The sequence must contain at least one gesture."))
        } else if gestures.count == 1 {
            messages.append(Message(messageType: MessageType.warningMessage, string: "Frenk recommends to use at least two gestures in your sequence"))
        }
        
        //todo other checks
        
        return messages
    }
    
    func setScreenLocked(locked : Bool) {
        isScreenLocked = locked
    }
    
    private func areGesturesCorrelated() -> Bool {
        if !KeychainManager.areGesturesSet() { //no gestures saved, no correlation!
            return false
        }
        
        if gestures.count == KeychainManager.getGestures()!.count {
            //TODO optimize: break the loop!
            var correlated = true
            for index in 0...(gestures.count-1) {
                if !(getCorrelation(gestures[index].xPoints, s2: KeychainManager.getGestures()![index].xPoints) > 0.83)
                    || !(getCorrelation(gestures[index].yPoints, s2: KeychainManager.getGestures()![index].yPoints) > 0.83) {
                    correlated = false
                }
                print("DEBUG: gesture #", index)
                print(getCorrelation(gestures[index].xPoints, s2: KeychainManager.getGestures()![index].xPoints))
                print(getCorrelation(gestures[index].yPoints, s2: KeychainManager.getGestures()![index].yPoints))
            }
            if correlated {
                return true
            }
        }
        return false
    }
    
    private func unlock() {
        if KeychainManager.isPasswordSet() { //unlock if password was set
            let pwd = KeychainManager.getPassword()
            
            let unlockScript = "tell application \"System Events\"\n if name of every process contains \"ScreenSaverEngine\" then\n tell application \"ScreenSaverEngine\"\n quit\n end tell\n end if\n set pword to \""+(pwd as! String)+"\"\nrepeat 40 times\n tell application \"System Events\" to keystroke (ASCII character 8)\n end repeat\n tell application \"System Events\"\n keystroke pword\n keystroke return\n end tell\n end tell"
            
            let scriptObject = NSAppleScript(source: unlockScript)
            scriptObject?.executeAndReturnError(nil)
        }
        
    }
    
}