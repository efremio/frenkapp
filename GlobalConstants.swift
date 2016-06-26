//
//  GlobalConstants.swift
//  Frenk
//
//  Created by Efrem Agnilleri on 21/06/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Foundation
import Cocoa

struct GlobalConstants {
    struct Colors {
        static let yellow = NSColor(red: 251/255, green: 230/255, blue: 186/255, alpha: 1).CGColor
        static let pink = NSColor(red: 250/255, green: 195/255, blue: 184/255, alpha: 1).CGColor
        static let lightPurple = NSColor(red: 240/255, green: 153/255, blue: 162/255, alpha: 1).CGColor
        static let purple = NSColor(red: 174/255, green: 139/255, blue: 193/255, alpha: 1).CGColor
    }
    
    struct AppSettings {
        static let defaultGestureTime = NSNumber(int: 800)
        static let defaultSoundsEnabled = false
        static let gesturePrecision: CGFloat = 0.88 //Pearson linear correlation. Close to 1 means that the two series are strongly linear correlated
        static let minPointsForGesture = 10
        //static let urlWeb = "http://www.frenkapp.com"
        //static let urlWebVersionCheck = "http://www.frenkapp.com/update/?myVersion=" + versionNumber!
        static let urlWeb = "http://epo90.altervista.org/frenk/"
        static let urlWebVersionCheck = "http://epo90.altervista.org/frenk/update/?version=" + versionNumber!
        
        static let versionNumber = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
    }
}