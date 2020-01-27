//
//  GearEquation.swift
//  ActuatorGearing
//
//  Created by Luis Fernandez on 9/7/17.
//  Copyright © 2017 Luis Fernandez. All rights reserved.
//

import Foundation

class GearEq {
    
    class func module(teethCount: Double, mmPitchDiam: Double) -> Double {
        return (mmPitchDiam/teethCount)
    }
    
    class func module(fromDiametralPitch dP: Double) -> Double {
        return ( 25.4 / dP)
    }
    
    class func diametralPitch(fromModule m: Double) -> Double {
        return ( 25.4 / m)
    }
    
    class func diametralPitch(teethCount: Double, inPitchDiameter: Double) -> Double {
        return (teethCount / inPitchDiameter)
    }
    
    /** Needs to have
     press angle
     helical angle
     teeth count
     outside diam
     pitch diam
     */
    class func efficiency(coeffFrctn cF: Double, gear: Gear, pinion: Gear) -> Double {
        
        var phi = Double()
        var pressureAng = Double()
        var rgSign = gear.teethCount! / pinion.teethCount!
        let rg = rgSign
        
        // Calculating phi and Rg sign term (depends if it is helical or spur gear)
        if
            gear is HelicalGear,
            pinion is HelicalGear
        {
            // phi
            let g = gear as! HelicalGear
            let t1 = tanD(degrees: g.dRadialPressAng!) * cosD(degrees: g.dHelicalAngle!)
            let t2 = arcTanD(value: t1)
            phi = cosD(degrees: t2) / cosDSquare(degrees: g.dHelicalAngle!)
            
            // rgSign
            rgSign = rgSign + 1
            
            // pressure angle
            pressureAng = g.dRadialPressAng!
        }
        else if
            gear is SpurGear,
            pinion is SpurGear
        {
            // phi
            let g = gear as! SpurGear
            phi = cosD(degrees: g.dPressureAngle!)
            
            // rgSign
            rgSign = rgSign + 1
            
            // pressure angle
            pressureAng = g .dPressureAngle!
        }
        else {
            print("Error: GearEq.efficiency Gear obejct must be Helical or Spur type")
        }
        
        // Getting hS and hT
        let gears = [gear, pinion]
        var hS = Double()
        var hT = Double()
        var hVars = [hS, hT]
        
        for i in 0 ..< gears.count {
            let gg = gears[i]
            
            let a = pow(gg.outsideDiam! / gg.pitchDiam!, 2)
            let b = cosDSquare(degrees: pressureAng)
            let c = pow(a - b, 0.5) - sinD(degrees: pressureAng)
            
            hVars[i] = c * rgSign
            
        }
        
        hS = hVars[0]
        hT = hVars[1] / rg
        
       // print(hS)
       // print(hT)
       // print(phi)
        
        let a = 50 * cF * ( pow(hS, 2) + pow(hT, 2) )
        let b = phi * ( hS + hT )
        
        return ( 100 - ( a / b ) )
        // tested this far
    }
    
}
