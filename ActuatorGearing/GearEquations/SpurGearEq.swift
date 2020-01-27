//
//  SpurGearEquation.swift
//  ActuatorGearing
//
//  Created by Luis Fernandez on 9/7/17.
//  Copyright © 2017 Luis Fernandez. All rights reserved.
//

import Foundation

class SpurGearEq: GearEq {
    
    // MARK: - Friction Torques
    
    class func frictionTorque(
        d1: Double,
        d2: Double,
        dimtrlPitch dP: Double,
        pressAng a: Double,
        frictionCoeff u: Double
        ) -> Double {
        
        // pitch radius
        let r1 = d1 / 2
        let r2 = d2 / 2
        
        // outer radius
//        let r1a = r1 + ( 1 / dP )
        let r2a = r2 + ( 1 / dP )
        
        // base radius
        let r1b = r1 * cosD(degrees: a)
        let r2b = r2 * cosD(degrees: a)
        
        let c1 = (pow(r2a, 2) - pow(r2b, 2)).squareRoot()
//        let c2 = (pow(r1a, 2) - pow(r1b, 2)).squareRoot()
        let c3 = (r1 + r2) * sinD(degrees: a)
        
        let l2Max_u = c1 * u
        let l1Min_u = (c3 - c1) * u
        
//        let t1T2Max = ( r1b - l1Min_u ) / ( r2b - l2Max_u )
        
//        let t1T2 = r1b / r2b    // no friction
        
        //let delta1 = (t1T2Max - t1T2) / t1T2
        //return delta1
        
        // let delta2 = l2Max_u / r2b   // old delta2
        
        // NEW DELTAS:
        
        // new delta 1
        let delta1 = ( (r2 / r1) * (r1b + l1Min_u) / (r2b - l2Max_u) ) - 1
        
        // new delta 2
//         let delta2 = l2Max_u / r2b
        
        /******************/
        
        let result = delta1
        
        /******************/
        if result.isNaN {
            print(" delta is NaN")
        }
        if result <= 0 {
            print("delta is less than zero")
        }
        return result
        /******************/
    }
    
    /**
     - returns:
     Extra needed friction torque, lb.in
     
     - parameters:
     - d1: Pitch diameter of driving gear
     - d2: Pitch diameter of driven gear
     - dimtrlPitch: Diametral Pitch (1/in.)
     - pressAng: Pressure Angle (Degrees)
     - tangtlLoad: Tangential Load (lb)
     - frictionCoeff: Friction Coefficient (decimal form)
     */
    class func frictionTorque(
        d1: Double,
        d2: Double,
        dimtrlPitch dP: Double,
        pressAng a: Double,
        tangtlLoad fT: Double,
        frictionCoeff u: Double
        ) -> Double {
        
        let r1 = d1 / 2
        let r2 = d2 / 2
        let r2O = r2 + (1 / dP)
        
        let lA = (r1 + r2) * sinD(degrees: a)
        let y = arcTanD(value: u)
        let w = arcSinD(value: lA / r2O)
        
        
        let o = w - y
        print("-------------")
        print(y)
        print(w)
        print(o)
        
        
        let r_2S = r2O * sinD(degrees: o)
        let r_2 = r2O * sinD(degrees: w)
        
        //if r_2S > r_2Max {
          //  r_2Max = r_2S
        //}
        //if r_2S < r_2Min {
          //  r_2Min = r_2S
        //}
        
        
        //print(r_2Max)
        //print(r_2Min)
        
        
        let t1 = sinD(degrees: w)
        let t2 = sinD(degrees: o)
        //let r = ( (r1 / r2) * (t1 - t2) ) / t1
        let r = ((t1 - t2) ) / t1
        
        if r.isNaN {
            print("--------")
            print("--------")
            print("--------")
            print("NAN")
            print("--------")
            print("--------")
            print("--------")
        }
        print(r)
        print("-------------")
        return r
        //return ((r_2 - r_2S) / r_2)
        
        
        
    }
    static var r_2Min = 3.3
    static var r_2Max = 0.0
    
    // MARK: - Mesh Stiffness
    
    class func meshStiffness(
        youngsModulus e: Double,
        faceWidth w: Double,
        diametralPitch dP: Double,
        numTeeth n: Double
        ) -> Double {
        
        let c = 0.000032
        
        return c * e * w * pow((1/dP), 2) * pow(n, 2.2)
        
    }
    
    // MARK: - Sliding Efficiency
    
    class func slidingEfficiency(
        drivingPDiam d1: Double,
        drivenPDiam d2: Double,
        diametralPitch DP: Double,
        pressDAngle a: Double,
        coeffFrict f:Double
        ) -> Double {
        
        // Arguments needed:
        // pitch diameter 1 and 2
        // diametral pitch
        // pressure angle (degrees)
        // efficieny (decimal)
        
        // Set up:
        
        let g = d2/d1
        
        let sA = sinD(degrees: a)
        let c2A = cosDSquare(degrees: a)
        
        let hT = ( ( g + 1 ) / g ) * simpleH(pitchDiam: d1, diametralPitch: DP, sA: sA, c2A: c2A)
        let hS = ( g + 1 ) * simpleH(pitchDiam: d2, diametralPitch: DP, sA: sA, c2A: c2A)
        
        // calculation
        
        let nominator = 50 * f * ( pow(hS, 2) + pow(hT, 2) )
        let denominator = cosD(degrees: a) * ( hS + hT )
        
        return ( nominator / denominator )
        
    }
    
    fileprivate class func simpleH(pitchDiam d: Double, diametralPitch DP: Double, sA: Double, c2A: Double) -> Double {
        
        // This function exists only to aid slidingEfficiency() function
        
        let r = d / 2     // pitch radius
        let rO = r + ( 1 / DP )   // outside diameter
        
        return (pow(( rO / r ), 2) - c2A).squareRoot() - sA
        
    }
    
    class func contactRatio(
        
        // All calculations are done in millimeters
        
        teethCount1 tC1: Double,
        teethCount2 tC2: Double,
        dPressAngle dPA: Double,
        module m: Double
        ) -> Double {
        
        let pD1 = m * tC1  // pitch diameter 1
        let pD2 = m * tC2
        
        return contactRatio(pitchDiam1: pD1, pitchDiam2: pD2, dPressAngle: dPA, module: m)
        
    }
    
    class func contactRatio(
        pitchDiam1 pD1: Double,
        pitchDiam2 pD2: Double,
        dPressAngle dPA: Double,
        module m: Double
    ) -> Double {
        
        // All calculations are done in millimeters
        
        // outside radius of gear 1 and 2
        let rO_1 = pow(outDiam(pitchDiam: pD1, module: m) / 2, 2)
        let rO_2 = pow(outDiam(pitchDiam: pD2, module: m) / 2, 2)
        
        // base radius of gear 1 and 2
        let rB_1 = pow(baseDiam(pitchDiam: pD1, dPressAng: dPA) / 2, 2)
        let rB_2 = pow(baseDiam(pitchDiam: pD2, dPressAng: dPA) / 2, 2)
        
        // center distance
        let c = centerDistance(pitchDiam1: pD1, pitchDiam2: pD2)

        let t1 = (rO_1 - rB_1).squareRoot()
        let t2 = (rO_2 - rB_2).squareRoot()
        let t3 = c * sinD(degrees: dPA)
        let t4 = m * Double.pi * cosD(degrees: dPA)

//        print("*******")
//        print(t1)
//        print(t2)
//        print(t3)
//        print(t4)
//        print(__sinpi(dPA/180.0))
//        print("*******")
        
        return ( ( t1 + t2 - t3 ) / t4 )
        
    }
    
    // MARK: - Diameters
    
    /**
     - parameters:
        - pitchDiam: Pitch diameter of gear. Cannot be nil.
        - dPressAng: Pressure angle, in degrees. Cannot be nil.
     */
    
    class func baseDiam(pitchDiam: Double, dPressAng: Double) -> Double {
        return ( pitchDiam * cosD(degrees: dPressAng) )
    }
    
    class func outDiam(pitchDiam: Double, module: Double) -> Double {
        return ( pitchDiam + ( 2 * module ) )
    }
    
    class func outDiam(teethCount: Double, module: Double) -> Double {
        return ( module * ( teethCount + 2 ) )
    }
    
    class func pitchDiam(module: Double, teethCount: Double) -> Double {
        return (module * teethCount)
    }
    
    // MARK: - Center Distance
    
    class func centerDistance(
        teethCount1: Double,
        teethCount2: Double,
        module: Double
    ) -> Double {
        
        return ( ( module * ( teethCount1 + teethCount2 ) ) / 2 )
        
    }
    
    class func centerDistance(
        pitchDiam1: Double,
        pitchDiam2: Double
    ) -> Double {
        return ( ( pitchDiam1 + pitchDiam2 ) / 2 )
    }
    
}

