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
    var timeStart : TimeInterval
    var timeEnd : TimeInterval
    
    init(xPoints: [CGFloat], yPoints: [CGFloat], timeStart: TimeInterval, timeEnd: TimeInterval) {
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
        self.timeStart = TimeInterval.init()
        self.timeEnd = TimeInterval.init()

        
        super.init()
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(xPoints, forKey: PropertyKeyGesture.xPointsKey)
        aCoder.encode(yPoints, forKey: PropertyKeyGesture.yPointsKey)
        aCoder.encode(timeStart, forKey: PropertyKeyGesture.timeStartKey)
        aCoder.encode(timeEnd, forKey: PropertyKeyGesture.timeEndKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let xPoints = aDecoder.decodeObject(forKey: PropertyKeyGesture.xPointsKey) as! [CGFloat]
        let yPoints = aDecoder.decodeObject(forKey: PropertyKeyGesture.yPointsKey) as! [CGFloat]
        let timeStart = aDecoder.decodeObject(forKey: PropertyKeyGesture.timeStartKey) as! TimeInterval
        let timeEnd = aDecoder.decodeObject(forKey: PropertyKeyGesture.timeEndKey) as! TimeInterval
        
        self.init(xPoints: xPoints, yPoints: yPoints, timeStart: timeStart, timeEnd: timeEnd)
    }

}

struct PropertyKeyGesture {
    static let xPointsKey = "xPoints"
    static let yPointsKey = "yPoints"
    static let timeStartKey = "timeStart"
    static let timeEndKey = "timeEnd"
}
