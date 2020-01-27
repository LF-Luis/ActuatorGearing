//
//  NormalHelicalGearEq.swift
//  ActuatorGearing
//
//  Created by Luis Fernandez on 10/21/17.
//  Copyright © 2017 Luis Fernandez. All rights reserved.
//

import Foundation

// METRIC UNITS (millimeters)

class NormalHelicalGearEq: GearEq {
    
    class func totalContactRatio(
        pitchDiam1 d1: Double,
        pitchDiam2 d2: Double,
        normaPressAngl aN: Double,
        helical B: Double,
        normalModule mN: Double,
        faceWidth w: Double
        ) -> Double {
        
        let xN1 = 0.0   // normal coeff of profile shift
        let xN2 = 0.0
        
        let z1 = d1 * cosD(degrees: B) / mN // number of teeth
        let z2 = d2 * cosD(degrees: B) / mN
        
        // radial module
        let mT = mN / cosD(degrees: B)
        
        // radial pressure angle
        let aT = arcTanD(value: tanD(degrees: aN) / cosD(degrees: B))
        
        // radial working pressure angle
        let aWT = radialWorkingPressAnglViaInvolute(xN1: xN1, xN2: xN2, z1: z1, z2: z2, radialPrssAng: aT, normPressAng: aN)
        
        // center distance increment factor
        let y = cntrDstIncrmntFctr(z1: z1, z2: z2, helicalAng: B, radialPrssAng: aT, radialWrknPrssAng: aWT)
        
        // center distance
        let aX = centrDstnc(z1: z1, z2: z2, helical: B, cntrIncrmtFct: y, normMod: mN)
        
        // addendums
        let h1 = (1 + y - xN2) * mN
        let h2 = (1 + y - xN1) * mN
        
        // outside diameters
        let dA1 = d1 + ( 2 * h1 )
        let dA2 = d2 + ( 2 * h2 )
        
        // base diameters
        let dB1 = d1 * cosD(degrees: aT)
        let dB2 = d2 * cosD(degrees: aT)
        
        // transverse conatact ratio
        let tCR = transverseCR(baseDiam1: dB1, outDiam1: dA1, baseDiam2: dB2, outDiam2: dA2, cntrDist: aX, radialWorkingPressAngle: aWT, radialModule: mT, radialPressAngl: aT)
        
        // axial contact ratio
        let aCr = axialCR(faceWidth: w, helix: B, normalModule: mN)
        
        return tCR + aCr
    }

    // test equations with http://www.tribology-abc.com/calculators/e2_6b.htm
    
    class func axialCR(faceWidth W: Double, helix B: Double, normalModule mN: Double) -> Double {
        let temp1 = W * sinD(degrees: B)
        let temp2 = Double.pi * mN
        
        return ( temp1 / temp2 )
    }
    
    class func transverseCR(
        baseDiam1 dB1: Double,
        outDiam1 dA1: Double,
        baseDiam2 dB2: Double,
        outDiam2 dA2: Double,
        cntrDist aX: Double,
        radialWorkingPressAngle aWT: Double,
        radialModule mT: Double,
        radialPressAngl aT: Double
        ) -> Double {
        
        let t1 = (pow((dA1/2), 2) - pow((dB1/2), 2)).squareRoot()
        let t2 = (pow((dA2/2), 2) - pow((dB2/2), 2)).squareRoot()
        let t3 = aX * sinD(degrees: aWT)
        let t4 = Double.pi * mT * cosD(degrees: aT)
        
        return ( ( t1 + t2 - t3 ) / t4 )
    }
    
    class func radialWorkingPressAnglViaInvolute(xN1: Double, xN2: Double, z1: Double, z2: Double, radialPrssAng aT: Double, normPressAng aN: Double) -> Double {
        
        let temp1 = (xN1 + xN2) / (z1 + z2)
        let temp2 = InvoluteFunction.involuteFunction(angle: aT)
        let temp3 = ( 2 * tanD(degrees: aN) * temp1 ) + temp2
        
        return InvoluteFunction.inverseInvoluteFunction(functionResult: temp3)
    }
    
    class func cntrDstIncrmntFctr(z1: Double, z2: Double, helicalAng B: Double, radialPrssAng aT: Double, radialWrknPrssAng aWT: Double) -> Double {
        
        let t1 = cosD(degrees: aT) / cosD(degrees: aWT)
        let temp1 = ( t1 - 1 )
        let temp2 = ( z1 + z2 ) / ( 2 * cosD(degrees: B) )
        return (temp1 * temp2)
        
    }
    
    class func centrDstnc(z1: Double, z2: Double, helical B: Double, cntrIncrmtFct y: Double, normMod mN: Double) -> Double {
        
        let temp1 = ( z1 + z2 ) / ( 2 * cosD(degrees: B) )
        return (temp1 + y) * mN
        
    }
    
}
