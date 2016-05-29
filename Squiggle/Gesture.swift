//
//  Gesture.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 15/05/16.
//  Copyright © 2016 Efrem Agnilleri. All rights reserved.
//

import Foundation

class Gesture: NSObject, NSCoding {
    //variables initialization
    var xPoints : [CGFloat]
    var yPoints : [CGFloat]
    var timeStart : NSTimeInterval
    var timeEnd : NSTimeInterval
    
    init(xPoints: [CGFloat], yPoints: [CGFloat], timeStart: NSTimeInterval, timeEnd: NSTimeInterval) {
        // Initialize stored properties.
        self.xPoints = xPoints
        self.yPoints = yPoints
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        
        super.init()
    }
    override init() {
        // Initialize stored properties.
        self.xPoints = [CGFloat]()
        self.yPoints = [CGFloat]()
        self.timeStart = NSTimeInterval.init()
        self.timeEnd = NSTimeInterval.init()

        
        super.init()
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(xPoints, forKey: PropertyKeyGesture.xPointsKey)
        aCoder.encodeObject(yPoints, forKey: PropertyKeyGesture.yPointsKey)
        aCoder.encodeObject(timeStart, forKey: PropertyKeyGesture.timeStartKey)
        aCoder.encodeObject(timeEnd, forKey: PropertyKeyGesture.timeEndKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let xPoints = aDecoder.decodeObjectForKey(PropertyKeyGesture.xPointsKey) as! [CGFloat]
        let yPoints = aDecoder.decodeObjectForKey(PropertyKeyGesture.yPointsKey) as! [CGFloat]
        let timeStart = aDecoder.decodeObjectForKey(PropertyKeyGesture.timeStartKey) as! NSTimeInterval
        let timeEnd = aDecoder.decodeObjectForKey(PropertyKeyGesture.timeEndKey) as! NSTimeInterval
        
        self.init(xPoints: xPoints, yPoints: yPoints, timeStart: timeStart, timeEnd: timeEnd)
    }

}

struct PropertyKeyGesture {
    static let xPointsKey = "xPoints"
    static let yPointsKey = "yPoints"
    static let timeStartKey = "timeStart"
    static let timeEndKey = "timeEnd"
}
