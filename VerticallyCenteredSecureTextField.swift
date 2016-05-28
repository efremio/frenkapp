//
//  VerticallyCenteredSecureTextField.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 28/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Foundation
import Cocoa

class VerticallyCenteredSecureTextField: NSSecureTextField {
    
    func drawingRectForBounds(theRect: NSRect) -> NSRect {
        let newRect = NSRect(x: 0, y: (theRect.size.height - 22) / 2, width: theRect.size.width, height: 22)
        return super.drawingRectForBounds(newRect)
    }
    
}