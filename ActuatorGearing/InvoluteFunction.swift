//
//  InvoluteFunction.swift
//  ActuatorGearing
//
//  Created by Luis Fernandez on 9/24/17.
//  Copyright © 2017 Luis Fernandez. All rights reserved.
//

import Foundation

class InvoluteFunction {
    
    /**
     - returns:
     Involute function given some angle
     
     - parameters:
     - angle: in degrees
     */
    class func involuteFunction(angle: Double) -> Double {
        return ( __tanpi(angle/180) - ( angle * Double.pi / 180 ) )
    }
    
    /**
     This method comes from http://iel.ucdavis.edu/publication/journal/gear_tooth_geometry.pdf
     - returns:
     Angle (in degrees) of involute function (with a very small error, see link above)
     
     - parameters:
     - functionResult: result of the involute function
     */
    class func inverseInvoluteFunction(functionResult fR: Double) -> Double {
        
        //    if fR < 0.0 || fR > 0.215 {
        //        print("ERROR: InvoluteFunction.inverseInvoluteFunction")
        //    }
        //
        //    if fR <= 0.1 {
        //        return ( ( 1.441735 * pow(fR, 1/3) ) - ( 0.379223 * fR ) )
        //    }
        //
        //    // The rest of this function is only recomended when fR is less than 0.215
        //    return ( ( 1.440859183 * pow(fR, 1/3) ) - ( 0.3660584 * fR ) )
        
        // Equation 17, 4 terms accuracy
        
        let t1 = (pow(3, 1/3) * pow(fR, 1/3))
        let t2 = ( 2 * fR / 5 )
        let t3 = ( 9 * pow(3, 2/3) * pow(fR, 5/3) / 175 )
        let t4 = ( 2 * pow(3, 1/3) * pow(fR, 7/3) / 175 )
        
        return ( t1 - t2 + t3 - t4) * 180.0 / Double.pi
        
    }
    
}





