//
//  GlobalConstants.swift
//  Frenk
//
//  Created by Efrem Agnilleri on 21/06/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Foundation

struct GlobalConstants {
    struct Labels {
        static let test = "test label"
    }
    
    struct AppSettings {
        static let defaultGestureTime = NSNumber(int: 800)
        static let defaultSoundsEnabled = false
        static let gesturePrecision: CGFloat = 0.8 //Pearson linear correlation. Close to 1 means that the two series are strongly linear correlated
        static let minPointsForGesture = 10
        //static let urlWeb = "http://www.frenkapp.com"
        //static let urlWebVersionCheck = "http://www.frenkapp.com/update/?myVersion=" + versionNumber!
        static let urlWeb = "http://epo90.altervista.org/frenk/"
        static let urlWebVersionCheck = "http://epo90.altervista.org/frenk/update/?version=" + versionNumber!
        
        static let versionNumber = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
    }
}