//
//  Message.swift
//  Frenk
//
//  Created by Efrem Agnilleri on 06/06/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Foundation

class Message: NSObject {
    //variables initialization
    var messageType : NSString
    var string : NSString
    
    init(messageType: NSString, string: NSString) {
        self.messageType = messageType
        self.string = string
    }
}

struct MessageType {
    static let errorMEssage = "error"
    static let warningMessage = "warning"
}