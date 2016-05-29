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
    
    var x : CGFloat = 0
    var y : CGFloat = 0
    
    /*init(referenceGestures : [Gesture]) {
     self.referenceGestures = referenceGestures
     }*/
    
    //used to record the gesture
    func scrollLocal(event : NSEvent) -> NSEvent {
        if(event.phase == NSEventPhase.Began) {
            let newGesture = Gesture()
            newGesture.timeStart = event.timestamp
            gestures.append(newGesture)
            lastGestureTimer.invalidate()
            x = 0
            y = 0
            print("gesture recording started")
        } else if(event.phase == NSEventPhase.Changed) {
            x += event.deltaX
            y += event.deltaY
            gestures.last?.xPoints.append(x)
            gestures.last?.yPoints.append(y)
            
        } else if(event.phase == NSEventPhase.Ended) {
            gestures.last?.timeEnd = event.timestamp
            print("gesture recording ended, last one?")
            
            //gesture ended, last one?
            lastGestureTimer.invalidate()
            lastGestureTimer = NSTimer.scheduledTimerWithTimeInterval((KeychainManager.getGestureTime() as! Double)/1000, target: self, selector: #selector(self.lastGestureRecordingTimerFired(_:)), userInfo: nil, repeats: false)
        }
        
        return event
    }
    
    func scroll(event : NSEvent) {
        if(isScreenLocked) {
            if(event.phase == NSEventPhase.Began) {
                let newGesture = Gesture()
                newGesture.timeStart = event.timestamp
                gestures.append(newGesture)
                lastGestureTimer.invalidate()
                x = 0
                y = 0
                print("gesture started")
            } else if(event.phase == NSEventPhase.Changed) {
                
                x += event.deltaX
                y += event.deltaY
                gestures.last?.xPoints.append(x)
                gestures.last?.yPoints.append(y)
                
            } else if(event.phase == NSEventPhase.Ended) {
                gestures.last?.timeEnd = event.timestamp
                print("gesture ended, last one?")
                
                //anticipate the unlock
                if(gestures.count == KeychainManager.getGestures()!.count) {
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
        print(" yes, last gesture")
        //it was the last gesture
        
        print("is the screen locked?")
        if(isScreenLocked) {
            print(" yes, the screen is locked")
            print("are the gestures matching the stored ones?")
            if(areGesturesCorrelated()) {
                print(" yes, unlocking...")
                unlock()
            } else {
                print(" no")
            }
        } else {
            print("  no, the screen is not locked")
        }
        
        //delete gestures
        gestures.removeAll()
    }
    
    //used to save a new gesture
    @objc private func lastGestureRecordingTimerFired(timer : NSTimer!) {
        print(" yes, last gesture recording")
        //it was the last gesture
        
        //store gestures... TODO
        KeychainManager.setGestures(gestures)
        
        //delete gestures
        gestures.removeAll()
    }
    
    func isScreenLocked(locked : Bool) {
        print("screen locked = " + locked.description)
        isScreenLocked = locked
    }
    
    private func areGesturesCorrelated() -> Bool {
        if(gestures.count == KeychainManager.getGestures()!.count) {
            var correlated = true
            for index in 0...(gestures.count-1) {
                if(!(getCorrelation(gestures[index].xPoints, s2: KeychainManager.getGestures()![index].xPoints) > 0.85)
                    || !(getCorrelation(gestures[index].yPoints, s2: KeychainManager.getGestures()![index].yPoints) > 0.85)) {
                    correlated = false
                }
                print("gesture #", index)
                print(getCorrelation(gestures[index].xPoints, s2: KeychainManager.getGestures()![index].xPoints))
                print(getCorrelation(gestures[index].yPoints, s2: KeychainManager.getGestures()![index].yPoints))
            }
            if(correlated) {
                return true
            }
        }
        return false
    }
    
    private func unlock() {
        //get password
        let pwd = KeychainManager.getPassword()
        
        if(pwd != nil) {
            
            let unlockScript = "tell application \"System Events\"\n if name of every process contains \"ScreenSaverEngine\" then\n tell application \"ScreenSaverEngine\"\n quit\n end tell\n end if\n set pword to \""+(pwd as! String)+"\"\nrepeat 40 times\n tell application \"System Events\" to keystroke (ASCII character 8)\n end repeat\n tell application \"System Events\"\n keystroke pword\n keystroke return\n end tell\n end tell"
            
            let scriptObject = NSAppleScript(source: unlockScript)
            scriptObject?.executeAndReturnError(nil)
        }
        
    }
    
}