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
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(sequence, forKey: PropertyKeyAppData.sequenceKey)
        aCoder.encodeObject(password, forKey: PropertyKeyAppData.passwordKey)
        aCoder.encodeObject(gestureTime, forKey: PropertyKeyAppData.gestureTimeKey)
        aCoder.encodeObject(launchAtLogin, forKey: PropertyKeyAppData.launchAtLoginKey)
        aCoder.encodeObject(soundsEnabled, forKey: PropertyKeyAppData.soundsEnabledKey)
        aCoder.encodeObject(precision, forKey: PropertyKeyAppData.precisionKey)
        aCoder.encodeObject(bruteforcePrevention, forKey: PropertyKeyAppData.bruteforcePreventionKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let sequence = aDecoder.decodeObjectForKey(PropertyKeyAppData.sequenceKey) as? [Gesture]
        let password = aDecoder.decodeObjectForKey(PropertyKeyAppData.passwordKey) as? NSString
        let gestureTime = aDecoder.decodeObjectForKey(PropertyKeyAppData.gestureTimeKey) as? NSNumber
        let launchAtLogin = aDecoder.decodeObjectForKey(PropertyKeyAppData.launchAtLoginKey) as? Bool
        let soundsEnabled = aDecoder.decodeObjectForKey(PropertyKeyAppData.soundsEnabledKey) as? Bool
        let precision = aDecoder.decodeObjectForKey(PropertyKeyAppData.precisionKey) as? CGFloat
        let bruteforcePrevention = aDecoder.decodeObjectForKey(PropertyKeyAppData.bruteforcePreventionKey) as? Bool
        
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
