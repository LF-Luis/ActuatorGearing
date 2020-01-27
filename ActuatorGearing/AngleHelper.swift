//
//  File.swift
//  ActuatorGearing
//
//  Created by Luis Fernandez on 10/13/17.
//  Copyright © 2017 Luis Fernandez. All rights reserved.
//

import Foundation

/**
Returns angle in degrees
     
 - Author:
 Luis Fernandez
 
 - returns:
 Returns angle in degrees
 
 */
func arcTanD(value v: Double) -> Double {
    return (atan(v) * 180 / Double.pi)
}

func arcSinD(value v: Double) -> Double {
    return (asin(v) * 180 / Double.pi)
}

func tanD(degrees d: Double) -> Double {
    let t1 = __tanpi(d/180)
    if t1 == Double.infinity {
        print("Error: Double.infinity with angle \(d)!")
    }
    return t1
}

func cosD(degrees d: Double) -> Double {
    return ( __cospi(d/180.0) )
}

func cosDSquare(degrees d: Double) -> Double {
    let t1 = __cospi(d/180.0)
    return pow(t1, 2)
}

func sinD(degrees d: Double) -> Double {
    return ( __sinpi(d/180.0) )
}
