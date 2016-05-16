//
//  CatmullSpline.swift
//  Squiggle
//
//  Created by Efrem Agnilleri on 11/12/15.
//  Copyright © 2015 Efrem Agnilleri. All rights reserved.
//

import Foundation

func getCorrelation(s1 : [CGFloat], s2 : [CGFloat]) -> CGFloat {
    var a = s1
    var b = s2
    
    //normalize the lengths of the series
    if(a.count < 10 || b.count < 10) {
        return 0
    }
    if(a.count > b.count) {
        b = normalizeArray(b, n: a.count)
    } else if (a.count < b.count) {
        a = normalizeArray(a, n: b.count)
    }
    
    //calcolo la correlazione con l'indice di Pearson
    return getPearsonCorrelation(a, b: b)
}

func getPearsonCorrelation(a : [CGFloat], b: [CGFloat]) -> CGFloat {
    let sumXY = getSumXY(a, b : b)
    let sumX = getSumX(a)
    let sumY = getSumX(b)
    let sumXX = getSumXX(a)
    let sumYY = getSumXX(b)
    
    let numerator = sumXY - sumX * sumY / CGFloat(a.count)
    let term1 = sumXX - sumX * sumX / CGFloat(a.count)
    let term2 = sumYY - sumY * sumY / CGFloat(a.count)
    let denominator = sqrt(term1 * term2)
    
    return numerator/denominator
}

func getSumXY(a : [CGFloat], b : [CGFloat]) -> CGFloat {
    var sum : CGFloat = 0.0
    for index in 0...(a.count-1) {
        sum += a[index] * b[index]
    }
    
    return sum
}

func getSumX(a : [CGFloat]) -> CGFloat {
    var sum : CGFloat = 0.0
    for index in 0...(a.count-1) {
        sum += a[index]
    }
    
    return sum
}

func getSumXX(a : [CGFloat]) -> CGFloat {
    var sum : CGFloat = 0.0
    for index in 0...(a.count-1) {
        sum += a[index] * a[index]
    }
    
    return sum
}

func normalizeArray(s : [CGFloat], n : Int) -> [CGFloat] {
    //stretch out the array
    var givenValues = [CGFloat?](count: n, repeatedValue: nil)
    var newValues = [CGFloat](count: n, repeatedValue: 0)
    
    //distribute the points from s to givenValues
    for index in 0...(s.count-1) {
        givenValues[index*(n-1)/(s.count-1)] = s[index]
    }
    
    //find the 4 points to compute spline
    for index in 0...(givenValues.count-1) {
        if(givenValues[index] == nil) {
            //let's compute a value for this nil!
            var points = [CGFloat?](count: 4, repeatedValue: nil)
            
            //try to find the two points before
            var i = index
            while i >= 0 {
                if(givenValues[i] != nil) {
                    if(points[1] == nil) {
                        points[1] = givenValues[i]
                    } else if (points[0] == nil) {
                        points[0] = givenValues[i]
                    }
                }
                i -= 1
            }
            
            //fill if empty (at the beginning)
            if(points[1] == nil) {
                points[1] = givenValues[0]
            }
            if(points[0] == nil) {
                if(points[1] != nil) {
                    points[0] = points[1]
                } else {
                    points[0] = givenValues[0]
                }
            }
            
            //try to find the two points after
            i = index
            while i < givenValues.count {
                if(givenValues[i] != nil) {
                    if(points[2] == nil) {
                        points[2] = givenValues[i]
                    } else if (points[3] == nil) {
                        points[3] = givenValues[i]
                    }
                }
                i += 1
            }
            //fill if empty (at the end)
            if(points[2] == nil) {
                points[2] = givenValues[givenValues.count-1]
            }
            if(points[3] == nil) {
                if(points[2] != nil) {
                    points[3] = points[2]
                } else {
                    points[3] = givenValues[givenValues.count-1]
                }
            }
            
            //compute t
            var last : Int = 0
            var next : Int = 0
            i = index
            while i >= 0 {
                if(givenValues[i] != nil) {
                    last = i
                    break
                }
                i -= 1
            }
            i = index
            while i < givenValues.count {
                if(givenValues[i] != nil) {
                    next = i
                    break
                }
                i += 1
            }
            
            let t :CGFloat = (CGFloat(index)-CGFloat(last))/(CGFloat(next)-CGFloat(last))
            
            //compute interpolation value
            
            let firstTerm = 2 * points[1]!
            let secondTerm = (points[2]! - points[0]!) * t
            let thirdTerm_1 = 2 * points[0]! - 5 * points[1]!
            let thirdTerm = (thirdTerm_1 + 4 * points[2]! - points[3]!) * t * t
            let fourthTerm_1 = 3 * points[1]! - points[0]! - 3 * points[2]!
            let fourthTerm = (fourthTerm_1 + points[3]!) * t * t * t
            
            newValues[index] = 0.5 * (firstTerm + secondTerm + thirdTerm + fourthTerm)
            
        }
    }
    
    //now merge the givenValues array and the newValuewArray
    for index in 0...(newValues.count-1) {
        if(givenValues[index] != nil) {
            newValues[index] = givenValues[index]!
        }
    }
    
    return newValues
}
