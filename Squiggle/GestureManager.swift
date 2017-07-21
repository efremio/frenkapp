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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class GestureManager : NSObject {
    //variables initialization
    var gestures = [Gesture]()
    
    fileprivate var isScreenLocked = false
    var lastGestureTimer = Timer.init()
    let dataShare = DataShare.shared
    
    var x : CGFloat = 0
    var y : CGFloat = 0
    
    /*init(referenceGestures : [Gesture]) {
     self.referenceGestures = referenceGestures
     }*/
    
    //used to record the gesture
    func scrollLocal(_ event : NSEvent) -> NSEvent {
        if dataShare.canRecord {
            if event.phase == NSEventPhase.began {
                let newGesture = Gesture()
                newGesture.timeStart = event.timestamp
                gestures.append(newGesture)
                lastGestureTimer.invalidate()
                x = 0
                y = 0
            } else if event.phase == NSEventPhase.changed {
                x += event.deltaX
                y += event.deltaY
                gestures.last?.xPoints.append(x)
                gestures.last?.yPoints.append(y)
                
            } else if event.phase == NSEventPhase.ended {
                gestures.last?.timeEnd = event.timestamp
                
                //update the graphics
                dataShare.setupWindowControllerInstance!.updateGestureNumber(gestures.count)
                
                //gesture ended, last one?
                lastGestureTimer.invalidate()
                lastGestureTimer = Timer.scheduledTimer(timeInterval: (KeychainManager.getGestureTime() as! Double)/1000, target: self, selector: #selector(self.lastGestureRecordingTimerFired(_:)), userInfo: nil, repeats: false)
            }
        }
        return event
    }
    
    func scroll(_ event : NSEvent) {
        if isScreenLocked {
            if event.phase == NSEventPhase.began {
                let newGesture = Gesture()
                newGesture.timeStart = event.timestamp
                gestures.append(newGesture)
                lastGestureTimer.invalidate()
                x = 0
                y = 0
            } else if event.phase == NSEventPhase.changed {
                
                x += event.deltaX
                y += event.deltaY
                gestures.last?.xPoints.append(x)
                gestures.last?.yPoints.append(y)
                
            } else if event.phase == NSEventPhase.ended {
                gestures.last?.timeEnd = event.timestamp
                
                //print("------------------------ debug ------------------------")
                //print(gestures.last?.xPoints)
                //print(gestures.last?.yPoints)
                
                //anticipate the unlock
                if KeychainManager.isSequenceSet()
                    && gestures.count == KeychainManager.getSequence()!.count {
                    manageUnlock(true)
                } //else { removed, otherwise the "no" sound is not played if the user puts a wrong sequence with the same number of gestures of the correct sequence
                    
                    //gesture ended, last one?
                    lastGestureTimer.invalidate()
                    lastGestureTimer = Timer.scheduledTimer(timeInterval: (KeychainManager.getGestureTime() as! Double)/1000, target: self, selector: #selector(self.lastGestureUnlockTimerFired(_:)), userInfo: nil, repeats: false)
                    
                //}
            }
        }
    }
    
    @objc fileprivate func lastGestureUnlockTimerFired(_ timer : Timer!) {
        manageUnlock(false)
    }
    
    func manageUnlock(_ fastCheck: Bool) {
        //it was the last gesture (or maybe it's a fast check)
        
        if isScreenLocked {
            if dataShare.failedAttempts < GlobalConstants.AppSettings.maxFailedAttempts && areGesturesCorrelated() {
                unlock()
            } else {
                if !fastCheck {
                    SoundManager.noSound()
                    dataShare.failedAttempts += 1
                }
            }
        }
        
        //delete gestures
        gestures.removeAll() //in case of fast check the sequence is cut even before the user completes it. Never mind, it's wrong!
    }
    
    //used to save a new gesture
    @objc fileprivate func lastGestureRecordingTimerFired(_ timer : Timer!) {
        //it was the last gesture
        
        let messages = checkSequenceValidity() //it returns warnings and errors about the sequence
        //sort the messages in errors and warnings
        var errors = [Message]()
        var warnings = [Message]()
        for m in messages {
            if m.messageType as String == MessageType.errorMEssage {
                errors.append(m)
            } else if m.messageType as String == MessageType.warningMessage {
                warnings.append(m)
            }
        }
        
        if errors.count > 0 { //if messages array contains at least one error
            //KeychainManager.setGestures(gestures) must be called after password check
            
            //notify the graphics
            dataShare.setupWindowControllerInstance!.errorsInGestureSequence(errors)
        } else if warnings.count > 0 { //if messages array contains at least one warning
            //notify the graphics
            dataShare.sequenceBeingRecorded = gestures
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
    
    fileprivate func checkSequenceValidity() -> [Message] {
        var messages = [Message]()
        
        //check length
        if gestures.count < 1 {
            messages.append(Message(messageType: MessageType.errorMEssage as NSString, string: "The sequence must contain at least one gesture."))
        } else if gestures.count == 1 {
            messages.append(Message(messageType: MessageType.warningMessage as NSString, string: "Frenk recommends to use at least two gestures in your sequence."))
        }
        
        //gesture too short
        var notEnoughPoints = false
        for g in gestures {
            if g.xPoints.count <= GlobalConstants.AppSettings.minPointsForGesture
                || g.yPoints.count <= GlobalConstants.AppSettings.minPointsForGesture {
                notEnoughPoints = true
            }
        }
        
        if notEnoughPoints {
            messages.append(Message(messageType: MessageType.errorMEssage as NSString, string: "One or more gestures are too short."))
        }
        
        return messages
    }
    
    func setScreenLocked(_ locked : Bool) {
        isScreenLocked = locked
    }
    
    fileprivate func areGesturesCorrelated() -> Bool {
        if !KeychainManager.isSequenceSet() || !KeychainManager.isPrecisionSet() { //no gestures or precision saved, no correlation!
            return false
        }
        
        if gestures.count == KeychainManager.getSequence()!.count {
            //TODO optimize: break the loop!
            var correlated = true
            for index in 0...(gestures.count-1) {
                let correlationX = getCorrelation(gestures[index].xPoints, s2: KeychainManager.getSequence()![index].xPoints)
                let correlationY = getCorrelation(gestures[index].yPoints, s2: KeychainManager.getSequence()![index].yPoints)
                if !(correlationX > KeychainManager.getPrecision()) || !(correlationY > KeychainManager.getPrecision()) {
                    correlated = false
                    return false //remove when debugging
                }
                /*print("DEBUG: gesture #", index)
                print(correlationX)
                print(correlationY)*/
            }
            if correlated {
                return true
            }
        }
        return false
    }
    
    fileprivate func unlock() {
        if KeychainManager.isPasswordSet() { //unlock if password was set
            let pwd = KeychainManager.getPassword()
            
            //let unlockScript = "tell application \"System Events\"\n if name of every process contains \"ScreenSaverEngine\" then\n tell application \"ScreenSaverEngine\"\n quit\n end tell\n end if\n set pword to \""+(pwd as! String)+"\"\nrepeat 40 times\n tell application \"System Events\" to keystroke (ASCII character 8)\n end repeat\n tell application \"System Events\"\n keystroke pword\n keystroke return\n end tell\n end tell"
            
            let unlockScript = "set my_password to \""+(pwd as! String)+"\"\n tell application \"System Events\"\n keystroke \"a\" using command down\n keystroke my_password\n delay 0.3\n key code 52\n end tell"
            
            let scriptObject = NSAppleScript(source: unlockScript)
            scriptObject?.executeAndReturnError(nil)
        }
        
    }
    
}
