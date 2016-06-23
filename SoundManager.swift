//
//  SoundManager.swift
//  Frenk
//
//  Created by Efrem Agnilleri on 23/06/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Foundation
import Cocoa

class SoundManager {
    
    static func yesSound() {
        if  KeychainManager.areSoundsEnabledSet() && KeychainManager.getSoundsEnabled()! {
            NSSound(named:"Tink")!.play()
        }
    }
    
    static func noSound() {
        if KeychainManager.areSoundsEnabledSet() && KeychainManager.getSoundsEnabled()! {
            NSSound(named:"Pop")!.play()
        }
    }

}