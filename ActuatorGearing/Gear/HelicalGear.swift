//
//  HelicalGear.swift
//  ActuatorGearing
//
//  Created by Luis Fernandez on 9/7/17.
//  Copyright © 2017 Luis Fernandez. All rights reserved.
//

import Foundation

class HelicalGear: Gear {

    var dHelicalAngle: Double?  //degrees
    
    var normalModule: Double?    //m_n
    var radialModule: Double?    //m_t, same as module in Spur gears
    
    // Correction factors
    var normCoeffProfShift: Double?     // Normal Coefficient of Profile Shift
    var cntrDistIncrmntFactr: Double?     // Center Distance Increment Factor
    
    // Pressure Angle
    var dWorkingPressAng: Double?
    var dRadialPressAng: Double?   // same as just pressure angle for Spur gear
    
}
