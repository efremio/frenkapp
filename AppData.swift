//
//  AppData.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 28/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Foundation

class AppData: NSObject, NSCoding {
    //variables initialization
    var sequence: [Gesture]?
    var password: NSString?
    var gestureTime: NSNumber?
    var launchAtLogin: Bool?
    var soundsEnabled: Bool?
    var precision: CGFloat?
    var bruteforcePrevention: Bool?
    
    init?(sequence: [Gesture]?, password: NSString?, gestureTime: NSNumber?, launchAtLogin: Bool?, soundsEnabled: Bool?, precision: CGFloat?, bruteforcePrevention: Bool?) {
        // Initialize stored properties.
        self.sequence = sequence
        self.password = password
        self.gestureTime = gestureTime
        self.launchAtLogin = launchAtLogin
        self.soundsEnabled = soundsEnabled
        self.precision = precision
        self.bruteforcePrevention = bruteforcePrevention
        
        super.init()
    }
    
    override init() {
        // Initialize stored properties.
        self.sequence = nil
        self.password = nil
        self.gestureTime = nil
        self.launchAtLogin = nil
        self.soundsEnabled = nil
        self.precision = nil
        self.bruteforcePrevention = nil
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(sequence, forKey: PropertyKeyAppData.sequenceKey)
        aCoder.encode(password, forKey: PropertyKeyAppData.passwordKey)
        aCoder.encode(gestureTime, forKey: PropertyKeyAppData.gestureTimeKey)
        aCoder.encode(launchAtLogin, forKey: PropertyKeyAppData.launchAtLoginKey)
        aCoder.encode(soundsEnabled, forKey: PropertyKeyAppData.soundsEnabledKey)
        aCoder.encode(precision, forKey: PropertyKeyAppData.precisionKey)
        aCoder.encode(bruteforcePrevention, forKey: PropertyKeyAppData.bruteforcePreventionKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let sequence = aDecoder.decodeObject(forKey: PropertyKeyAppData.sequenceKey) as? [Gesture]
        let password = aDecoder.decodeObject(forKey: PropertyKeyAppData.passwordKey) as? NSString
        let gestureTime = aDecoder.decodeObject(forKey: PropertyKeyAppData.gestureTimeKey) as? NSNumber
        let launchAtLogin = aDecoder.decodeObject(forKey: PropertyKeyAppData.launchAtLoginKey) as? Bool
        let soundsEnabled = aDecoder.decodeObject(forKey: PropertyKeyAppData.soundsEnabledKey) as? Bool
        let precision = aDecoder.decodeObject(forKey: PropertyKeyAppData.precisionKey) as? CGFloat
        let bruteforcePrevention = aDecoder.decodeObject(forKey: PropertyKeyAppData.bruteforcePreventionKey) as? Bool
        
        self.init(sequence: sequence, password: password, gestureTime: gestureTime, launchAtLogin: launchAtLogin, soundsEnabled: soundsEnabled, precision: precision, bruteforcePrevention: bruteforcePrevention)
    }
}

struct PropertyKeyAppData {
    static let sequenceKey = "sequence"
    static let passwordKey = "password"
    static let gestureTimeKey = "gestureTime"
    static let launchAtLoginKey = "launchAtLogin"
    static let soundsEnabledKey = "soundsEnabled"
    static let precisionKey = "precision"
    static let bruteforcePreventionKey = "bruteforcePrevention"
}
