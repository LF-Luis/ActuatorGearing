//
//  HelicalGearEq.swift
//  ActuatorGearing
//
//  Created by Luis Fernandez on 9/7/17.
//  Copyright © 2017 Luis Fernandez. All rights reserved.
//

import Foundation

class HelicalGearEq: GearEq {
    
    // MARK: - Contact Ratio
    
    // All calculations in Metric (mm)
    
    class func totalContactRatio(pressureAngle: Double, smallGearTeethCnt: Double, largeGearTeethCnt: Double, module: Double, inchFaceWidth: Double, helixAngle: Double) -> Double {
        
        let radialCoeffProfShift = 0.0
        
        let smallGear = HelicalGear()
        let largeGear = HelicalGear()
        
        smallGear.teethCount = smallGearTeethCnt
        largeGear.teethCount = largeGearTeethCnt
        let mmFaceWidths = inchFaceWidth * 25.4     // face width in mm
        let mod = module
        
        // no addedum changes, working pressure angle is radial pressure angle
        smallGear.dRadialPressAng = pressureAngle
        largeGear.dRadialPressAng = pressureAngle
        
        let dWorkingPressureAngle = HelicalGearEq.dWorkingPressAngl(teethCount1: smallGear.teethCount!, teethCount2: largeGear.teethCount!, radialCoeffProfShift1: radialCoeffProfShift, radialCoeffProfShift2: 0.0, dRadialPressAng: smallGear.dRadialPressAng!)
        
        smallGear.dWorkingPressAng = dWorkingPressureAngle
        largeGear.dWorkingPressAng = dWorkingPressureAngle
        
        let cntrDistIncrmntFactr = HelicalGearEq.cntrDistIncrmntFactr(teethCount1: smallGear.teethCount!, teetCount2: largeGear.teethCount!, dRadialPressAng: smallGear.dRadialPressAng!, dWorkingPressAng: smallGear.dWorkingPressAng!)
        
        smallGear.cntrDistIncrmntFactr = cntrDistIncrmntFactr
        largeGear.cntrDistIncrmntFactr = cntrDistIncrmntFactr
        
        let gears = [smallGear, largeGear]
        
        for gear in gears {
            gear.radialModule = mod
            gear.normalModule = HelicalGearEq.normalModule(radialModule: gear.radialModule!, helicalAngle: helixAngle)
            gear.pitchDiam = HelicalGearEq.pitchDiam(radialModule: gear.radialModule!, teethCount: gear.teethCount!)
            gear.baseDiam = HelicalGearEq.baseDiam(pitchDiam: gear.pitchDiam!, dRadialPressAng: gear.dRadialPressAng!)
        }
        
        let centerDistance = HelicalGearEq.centerDist(teethCount1: smallGear.teethCount!, teethCount2: largeGear.teethCount!, cntrDistIncrmntFactr: smallGear.cntrDistIncrmntFactr!, radialModule: smallGear.radialModule!)
        
        // note, for addendum use the radialCoeffProfShift of the other gear
        smallGear.addendum = HelicalGearEq.addendum(cntrDistIncrmntFactr: smallGear.cntrDistIncrmntFactr!, radialCoeffProfShift: 0.0, radialMod: smallGear.radialModule!)
        largeGear.addendum = HelicalGearEq.addendum(cntrDistIncrmntFactr: smallGear.cntrDistIncrmntFactr!, radialCoeffProfShift: radialCoeffProfShift, radialMod: largeGear.radialModule!)
        
        for gear in gears {
            gear.outsideDiam = HelicalGearEq.outsideDiam(pitchDiam: gear.pitchDiam!, addendum: gear.addendum!)
        }
        
        let transCR = HelicalGearEq.transverseContactRatio(outDiam1: smallGear.outsideDiam!, outDiam2: largeGear.outsideDiam!, baseDiam1: smallGear.baseDiam!, baseDiam2: largeGear.baseDiam!, cntrDist: centerDistance, dWorkngPrssAng: smallGear.dWorkingPressAng!, radialMod: smallGear.radialModule!, dRadialPrssAng: smallGear.dRadialPressAng!)
        
        let axialCR = HelicalGearEq.axialContactRatio(faceWidth: mmFaceWidths, dHelicalAng: helixAngle, normalMod: smallGear.normalModule!)
        
        return (axialCR + transCR)
    }

    
    // In the radial direction
    class func transverseContactRatio(
        outDiam1: Double,
        outDiam2: Double,
        baseDiam1: Double,
        baseDiam2: Double,
        cntrDist: Double,
        dWorkngPrssAng: Double,
        radialMod: Double,
        dRadialPrssAng: Double
    ) -> Double {
        
        let t1 = ( pow((outDiam1/2), 2.0) - pow((baseDiam1/2), 2.0) ).squareRoot()
        let t2 = ( pow((outDiam2/2), 2.0) - pow((baseDiam2/2), 2.0) ).squareRoot()
        let t3 = cntrDist * __sinpi(dWorkngPrssAng/180.0)
        let t4 = Double.pi * radialMod * __cospi(dRadialPrssAng/180.0)
        
        return ( t1 + t2 - t3 ) / t4
        
    }
    
    class func axialContactRatio(faceWidth: Double, dHelicalAng: Double, normalMod: Double) -> Double {
        let t1 = faceWidth * __sinpi(dHelicalAng/180.0)
        let t2 = Double.pi * normalMod
        return ( t1 / t2 )
    }
    
    // MARK: - Diameters
    
    // radialModule is m_t
    class func pitchDiam(radialModule: Double, teethCount: Double) -> Double {
        return (radialModule * teethCount)
    }
    
    class func outsideDiam(pitchDiam: Double, addendum: Double) -> Double {
        return ( pitchDiam + ( 2 * addendum ) )
    }
    
    class func baseDiam(pitchDiam: Double, dRadialPressAng: Double) -> Double {
        return pitchDiam * __cospi(dRadialPressAng/180.0)
    }
    
    // MARK: - Module
    
    class func normalModule(radialModule: Double, helicalAngle: Double) -> Double {
        return ( radialModule * __cospi(helicalAngle/180.0) )
    }
    
    // MARK: - Center Distance
    
    class func centerDist(teethCount1: Double, teethCount2: Double, cntrDistIncrmntFactr: Double, radialModule: Double) -> Double {
        
        return ( ( (teethCount1 + teethCount2) / 2 ) + cntrDistIncrmntFactr ) * radialModule
    
    }
    
    class func cntrDistIncrmntFactr(teethCount1: Double, teetCount2: Double, dRadialPressAng: Double, dWorkingPressAng: Double) -> Double {
        
        let t1 = __cospi(dRadialPressAng/180.0)
        let t2 = __cospi(dWorkingPressAng/180.0)
        
        let t3 = ( teethCount1 + teetCount2 ) * 0.5 * ( ( t1 / t2 ) - 1 )
        
        return t3
    }
    
    // MARK: - Pressure Angles
    
    // returns in degrees
    class func dWorkingPressAngl(baseDiam1: Double, baseDiam2: Double, centrDist: Double) -> Double {
        let a = (baseDiam1 + baseDiam2) / ( 2 * centrDist )
        return acos(a)*180.0/Double.pi
    }
    
    class func dWorkingPressAngl(teethCount1 tC1: Double, teethCount2 tC2: Double, radialCoeffProfShift1 rCPS1: Double, radialCoeffProfShift2 rCPS2: Double, dRadialPressAng: Double) -> Double {
        
        let e1Main = InvoluteFunction.involuteFunction(angle: dRadialPressAng)
        let e2 = __tanpi(dRadialPressAng/180)
        let e3Main = 2 * e2 * ( (rCPS1 + rCPS2) / (tC1 + tC2) )
        let e4 = e3Main + e1Main
        
        let res = InvoluteFunction.inverseInvoluteFunction(functionResult: e4)
        
        return res
    }
    
    // MARK: - Addendum
    
    class func addendum(cntrDistIncrmntFactr y: Double, radialCoeffProfShift xT: Double, radialMod mT: Double) -> Double {
        return ( (1 + y - xT) * mT )
    }
    
}







