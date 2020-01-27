//
//  main.swift
//  ActuatorGearing
//
//  Created by Luis Fernandez on 9/7/17.
//  Copyright © 2017 Luis Fernandez. All rights reserved.
//

import Foundation

/*
 E.g. calculating total contact ratio of helical gears unsing radial and normal notation.
*/

// Setup
let pressureAngle: Double = 25.0
let helicalAngle: Double = 30.0
let inFaceWidth: Double = 0.5
// small gear is the driving gear (i.e. pinion)
let smallGearTeethCnt: Double = 18
let smallGearPitchDiameter: Double = 1.22
let largeGearTeethCnt: Double = 28

// Calculations
let diametralPitch: Double = GearEq.diametralPitch(teethCount: smallGearTeethCnt,
                                                   inPitchDiameter: smallGearPitchDiameter)
let largeGearPitchDiameter: Double = largeGearTeethCnt / diametralPitch
let module: Double = GearEq.module(fromDiametralPitch: diametralPitch)

// normal pressure angle
let aN = arcTanD(value: tanD(degrees: pressureAngle) * cosD(degrees: helicalAngle))

// normal module
let inToMm: Double = 25.4 // inches to mm convertion
let radialMod = inToMm / diametralPitch
let normMod = radialMod * cosD(degrees: helicalAngle)

// Output
let radialCR = HelicalGearEq.totalContactRatio(pressureAngle: pressureAngle,
                                               smallGearTeethCnt: smallGearTeethCnt,
                                               largeGearTeethCnt: largeGearTeethCnt,
                                               module: module,
                                               inchFaceWidth: inFaceWidth,
                                               helixAngle: helicalAngle)

let normalCR = NormalHelicalGearEq.totalContactRatio(pitchDiam1: smallGearPitchDiameter * 25.4,
                                                     pitchDiam2: largeGearPitchDiameter * 25.4,
                                                     normaPressAngl: aN,
                                                     helical: helicalAngle,
                                                     normalModule: normMod,
                                                     faceWidth: inFaceWidth * 25.4)

print("Radial contact ratio: ", radialCR)
print("Normal contact ratio: ", normalCR)
