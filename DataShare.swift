//
//  DataShare.swift
//  Frenk
//
//  Created by Efrem Agnilleri on 31/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Foundation

class DataShare {
    class var sharedInstance: DataShare {
        struct Static {
            static var instance: DataShare?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DataShare()
        }
        
        return Static.instance!
    }
    
    var canRecord: Bool = false
    var setupWindowControllerInstance: SetupWindowController? = nil
    var sequenceBeingRecorded: [Gesture]? = nil
    var failedAttempts: Int = 0
}
