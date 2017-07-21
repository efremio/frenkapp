//
//  DataShare.swift
//  Frenk
//
//  Created by Efrem Agnilleri on 31/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Foundation

/*class DataShare {
    private static var __once: () = {
            Static.instance = DataShare()
        }()
    class var sharedInstance: DataShare {
        struct Static {
            static var instance: DataShare?
            static var token: Int = 0
        }
        
        _ = DataShare.__once
        
        return Static.instance!
    }
    
    var canRecord: Bool = false
    var setupWindowControllerInstance: SetupWindowController? = nil
    var sequenceBeingRecorded: [Gesture]? = nil
    var failedAttempts: Int = 0
}*/


class DataShare {
    static let shared = DataShare()
    
    var canRecord: Bool = false
    var setupWindowControllerInstance: SetupWindowController? = nil
    var sequenceBeingRecorded: [Gesture]? = nil
    var failedAttempts: Int = 0
    
}
