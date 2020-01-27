//
//  RunCalculations.swift
//  ActuatorGearing
//
//  Created by Luis Fernandez on 9/25/17.
//  Copyright © 2017 Luis Fernandez. All rights reserved.
//

import Foundation

enum Amplification {
    case torque
    case velocity
    case both
}

class RunCalculations {

    /**
     - returns:
     first item is driven gear diameter range
     second item is diametral pitch range
     */
    class func getParameter(amplificationType: Amplification) -> ([Double], [Double]) {
        
        var drivenGearDiams: [Double]
        var diametralPitch: [Double]
        
        switch amplificationType {
        case .velocity:
            // velocity amplification
            drivenGearDiams = Array(stride(from: 2, through: 10, by: 0.5))
            diametralPitch = Array(stride(from: 7, through: 15, by: 0.5))
        case .torque:
            // torque amplification
            drivenGearDiams = Array(stride(from: 10, through: 50, by: 1))
            diametralPitch = Array(stride(from: 2, through: 10, by: 1))
        case .both:
            // entire spectrum
            drivenGearDiams = Array(stride(from: 2, through: 50, by: 1))
            diametralPitch = Array(stride(from: 2, through: 15, by: 1))

        }
        
        return (drivenGearDiams, diametralPitch)
        
    }
    
    // MARM: - Friction Torques in Spur Gears
    
    class func frictionTorques() {
        
        let pressAng = 25.0
//        let pressAngArr = [25.0]
        let frictCoeff = [0.01, 0.05, 0.1]
        
        let drivingDiam = 10.0  // in.
        
        let amplificationType: Amplification = .torque
        
        /*--------------------------------------------------------------------------------*/
        
        var drivenDiams: [Double]
        var diamtrlPitch: [Double]
        
        (drivenDiams, diamtrlPitch) = getParameter(amplificationType: amplificationType)
        
        // printing
        var count = 0
        let fileNames: [String] = ["data.csv", "data2.csv", "data3.csv"]
        
//        let u: Double = 0.05
        for u in frictCoeff {
//        for a in pressAngArr {
            
            var csvString = String()
            
            for dP in diamtrlPitch {
                for drivenDiam in drivenDiams {
                    let frictionTorque = SpurGearEq.frictionTorque(d1: drivingDiam, d2: drivenDiam, dimtrlPitch: dP, pressAng: pressAng, frictionCoeff: u)
                    
                    // velocity amplification
//                    let newDiam = pow(drivenDiam, -1) * 10
                    
                    // torque amplification
//                    let newDiam = drivenDiam / 10
                    
                    csvString.append("\(dP), \(drivenDiam), \(frictionTorque) \n")
                }
            }
            
            let fileName = fileNames[count]
            FileHelper.writeCSVFile(csvString: csvString, fileName: fileName)
            count = 1 + count
            
        }
        
    }
    
    // MARK: - Mesh Stiffness
    
    class func meshStiffness() {
        
        let faceWidth: [Double] = [ 1, 3, 5 ]
        
        let step: Double = 0.5
        
        let diamtrlPitch: [Double] = Array(stride(from: 2, through: 15, by: step))
        
        let pinionDiamtrs: [Double] = Array(stride(from: 2, through: 10, by: step))
        
        let youngMod: Double = 29 * pow(10, 6)  // Young's Modulus
        
        var count = 0
        
        let fileNames: [String] = ["data.csv", "data2.csv", "data3.csv"]
        
        for fW in faceWidth {
            
            var csvString = String()
            
            for dP in diamtrlPitch {
                for diam2 in pinionDiamtrs {
                
                    let n = dP * diam2
                    
                    if n < 12 || n > 400 {
                        continue
                    }

                    let stifness = SpurGearEq.meshStiffness(youngsModulus: youngMod, faceWidth: fW, diametralPitch: dP, numTeeth: n)
                    
                    csvString.append("\(dP), \(diam2), \(stifness) \n")
                    
                }
            }
            
            let fileName = fileNames[count]
            FileHelper.writeCSVFile(csvString: csvString, fileName: fileName)
            count = 1 + count
            
        }
        
    }
    
    // MARK: - Efficiency
    
    class func spurEfficiency() {
        
        let coeffFrict = 0.1
        let pressureAngle = [20.0, 25.0]
        
        let drivingGearDiam = 10.0  // inches
        
        let amplificationType: Amplification = .velocity
        
        /*--------------------------------------------------------------------------------*/
        
        var diamtrlPitch: [Double]
        var diam2Range: [Double]
        
        (diam2Range, diamtrlPitch) = getParameter(amplificationType: amplificationType)
        
        var count = 0
        let fileNames: [String] = ["data.csv", "data2.csv"]
        
        for a in pressureAngle {
            
            var csvString = String()
            
            for dP in diamtrlPitch {
                for diam2 in diam2Range {
                    
                  //  let n = dP * diam2
                    
                //    if n < 12 || n > 400 {
                  //      continue
                    //}
                    
                    let eff = SpurGearEq.slidingEfficiency(drivingPDiam: drivingGearDiam, drivenPDiam: diam2, diametralPitch: dP, pressDAngle: a, coeffFrict: coeffFrict)
                    
                    csvString.append("\(dP), \(diam2), \(eff) \n")
                    
                }
            }
            
            let fileName = fileNames[count]
            FileHelper.writeCSVFile(csvString: csvString, fileName: fileName)
            count = 1 + count
            
        }
        
    }
    
    // MARK: - Efficiency - WRONG
    
    class func testingEfficiency() {
        
        var count = 0
        let fileNames: [String] = ["data.csv", "data2.csv", "data3.csv"]
        
        let pressureAngle = 20.0 //25.0
        let smallGearTeethCount = 27.0 // 15.0
        let coefficientFrict = 0.1
        
        let modules: [Double] = [1, 3, 4, 5, 6, 8, 10]
        let largeGearTeethCount: [Double] = [27, 40, 54, 67]
        let helixAngles: [Double] = [5, 15, 30] // [ 5, 10, 15, 20 ,30 ]

        for hA in helixAngles {
            
            var csvString = String()
    
            for mod in modules {
                for lGTC in largeGearTeethCount {
                   
                    let pinion = HelicalGear()
                    let gear = HelicalGear()
                    pinion.teethCount = smallGearTeethCount
                    gear.teethCount = lGTC
                    
                    let gears = [pinion, gear]
                    
                    for gg in gears {
                        gg.pitchDiam = mod * gg.teethCount!
                        gg.outsideDiam = gg.pitchDiam! + ( 2 * mod )
                        gg.dRadialPressAng = pressureAngle
                        gg.dHelicalAngle = hA
                    }
                    
                    let eff = GearEq.efficiency(coeffFrctn: coefficientFrict, gear: gear, pinion: pinion)
                    
                    csvString.append("\(mod), \(lGTC), \(eff), \(hA) \n")
                }
            }
    
            let fileName = fileNames[count]
            FileHelper.writeCSVFile(csvString: csvString, fileName: fileName)
            count = 1 + count
    
        }
        
    }
    
    // MARK: - Stresses
    
    class func contactStress() {
        
        let stressEq = StressEquations()
        
        // setting stress modification factors
        stressEq.dynamicFactor = 1
        stressEq.loadDistrFctr = 1
        stressEq.elasticCoefficient = 2300  // for steel-on-steel gearing (psi)
        let tangentialLoad = 1000.0
        
        let pressureAngle = 20.0 //25.0
        let smallDiameter: [Double] = [10, 9, 8, 7, 6, 5, 4, 3, 2]
        let inchFaceWidths: [Double] = [1, 1.25, 1.5, 1.75, 2, 2.25, 2.5, 2.75, 3, 3.25, 3.5, 3.75, 4, 4.25, 4.5, 4.75, 5]
        let helixAngles: [Double] = [5, 15, 30] // [ 5, 10, 15, 20 ,30 ]
        
        var count = 0
        let fileNames: [String] = ["data.csv", "data2.csv", "data3.csv"]
        
        /* ---------------------------- */
        
        
        for hA in helixAngles {
            
            var csvString = String()
            
            for g2d in smallDiameter {
                
                for fW_in in inchFaceWidths {
                        
                    // set I
                    stressEq.geometricSurfaceFctr = getI(prssrAng: pressureAngle, helicalAng: hA)
                        
                    // set J
                    stressEq.geometricBendingFctr = getJ(prssrAng: pressureAngle, helicalAng: hA)
            
                    let contactStress = stressEq.contactStress(tangentialLoad: tangentialLoad, faceWidth: fW_in, pinionPtchDiamtr: g2d)
                    
                    //csvString.append("\(fW_in), \(String(describing: contactStress!)) \n")
                    csvString.append("\(g2d), \(fW_in), \(String(describing: contactStress!)) \n")
                    
                }
            }
            
            let fileName = fileNames[count]
            FileHelper.writeCSVFile(csvString: csvString, fileName: fileName)
            count = 1 + count
        }
        
    }

    
    class func bendingStress() {
        
        let stressEq = StressEquations()
        
        // setting stress modification factors
        stressEq.dynamicFactor = 1
        stressEq.loadDistrFctr = 1
        stressEq.elasticCoefficient = 2300  // for steel-on-steel gearing (psi)
        
        let tangentialLoad = 1000.0
        
        let pressureAngle = 25.0 //25.0
        
        let diamtrlPitch: [Double] = Array(stride(from: 2, through: 15, by: 0.5))
        let inchFaceWidths: [Double] = Array(stride(from: 1, through: 5, by: 0.5))
        let helixAngles: [Double] = [5, 15, 30]
        
        var count = 0
        let fileNames: [String] = ["data.csv", "data2.csv", "data3.csv"]
        
        /* ---------------------------- */
        
        for hA in helixAngles {
            
            var csvString = String()
            
            for dP in diamtrlPitch {
                for fW_in in inchFaceWidths {
                        
                    // set I
                    stressEq.geometricSurfaceFctr = getI(prssrAng: pressureAngle, helicalAng: hA)
                    
                    // set J
                    stressEq.geometricBendingFctr = getJ(prssrAng: pressureAngle, helicalAng: hA)
                    
                    let bendStrss = stressEq.bendingStress(tangentialLoad: tangentialLoad, faceWidth: fW_in, diametralPitch: dP)
                
                    csvString.append("\(dP), \(fW_in), \(String(describing: bendStrss!)) \n")
                    
                }
            }
            
            let fileName = fileNames[count]
            FileHelper.writeCSVFile(csvString: csvString, fileName: fileName)
            count = 1 + count
        }

    }
    
    fileprivate class func getI(prssrAng a: Double, helicalAng b: Double) -> Double {
        switch a {
        case 20.0:
            switch b {
            case 5:
                return 0.14
            case 15:
                return 0.173
            case 30:
                return 0.175333
            default:
                return 0
            }
        case 25.0:
            switch b {
            case 5:
                return 0.141
            case 15:
                return 0.1803
            case 30:
                return 0.18
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    fileprivate class func getJ(prssrAng a: Double, helicalAng b: Double) -> Double {
        switch a {
        case 20.0:
            switch b {
            case 5:
                return 0.3775
            case 15:
                return 0.52
            case 30:
                return 0.46
            default:
                return 0
            }
        case 25.0:
            switch b {
            case 5:
                return 0.594
            case 15:
                return 0.6
            case 30:
                return 0.5467
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    // MARK: - Wind Turbine Stresses

    class func windTurbineGearing() {
        
        var csvString = String()
        
        let stressEq1 = StressEquations()
        stressEq1.dynamicFactor = 1.1
        stressEq1.loadDistrFctr = 1.35
        stressEq1.elasticCoefficient = 2300.0
        
        let fileName = "GearData.json"
        let fileURLPath: String = "."
        
        if
            let jsonData = FileHelper.getJSONdata(filePath: fileURLPath, fileName: fileName) as Data?,
            let indexedData = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
            let meshData = indexedData["TurbineGearing"] as? [[String: Any]]
        {
            
            var meshCount = 1
            
            for mesh in meshData {
                if
                    let gear1Teeth = mesh["gear1Teeth"] as? Double,
                    let gear1PitchDiam = mesh["gear1PitchDiam"] as? Double,
                    let gear2Teeth = mesh["gear2Teeth"] as? Double,
                    let gear2PitchDiam = mesh["gear2PitchDiam"] as? Double,
                    let tangentialLoad = mesh["tangentialLoad"] as? Double,
                    let faceWidth = mesh["faceWidth"] as? Double,
                    let bendingGeometricFactor = mesh["bendingGeometricFactor"] as? Double,
                    let contactGeometricFactor = mesh["contactGeometricFactor"] as? Double
                {
                    
                    // Stresses
                    stressEq1.tangentialLoad = tangentialLoad
                    stressEq1.faceWidth = faceWidth
                    stressEq1.diametralPitch = gear1Teeth / gear1PitchDiam
                    stressEq1.pinionPtchDiamtr = gear1PitchDiam
                    stressEq1.geometricBendingFctr = bendingGeometricFactor
                    stressEq1.geometricSurfaceFctr = contactGeometricFactor
                    let bendingStress = stressEq1.bendingStress()
                    let contactStress = stressEq1.contactStress()
                    
                    // Contact Ratio
                    let module1 = GearEq.module(fromDiametralPitch: gear1Teeth / gear1PitchDiam)
                    let contactRatio = HelicalGearEq.totalContactRatio(pressureAngle: 25.0, smallGearTeethCnt: gear1Teeth, largeGearTeethCnt: gear2Teeth, module: module1, inchFaceWidth: faceWidth, helixAngle: 30.0)
                    
                    // Print Out Data
                    
//                    let printOut: String = "\(meshCount), \(gear1Teeth), \(gear1PitchDiam), \(gear2Teeth), \(gear2PitchDiam), \(faceWidth), \(stressEq1.diametralPitch!), \(module1), \(contactRatio) \n"
//                    let printOut: String = "\(meshCount), \(bendingGeometricFactor), \(contactGeometricFactor) \n"
//                    let printOut: String = "\(meshCount), \(tangentialLoad), \(bendingStress!), \(contactStress!) \n"
                    
                    let floorContactRatio = Int(contactRatio)
                    
                    let printOut: String = "\(meshCount), \(floorContactRatio), \(tangentialLoad), \(Int(bendingStress!)/floorContactRatio), \(Int(contactStress!)/floorContactRatio) \n"
                    
                    csvString.append(printOut)
                    meshCount = meshCount + 1
                    
                }
                
            }
            
        }
        let fileNameOut = "data.csv"
        FileHelper.writeCSVFile(csvString: csvString, fileName: fileNameOut)
        
    }
    
    // MARK: - Contact Ratio Spur Gear
    
    class func spurGearContactRatio() {
        
        // inches to mm convertion
        let inToMm: Double = 25.4
        
        // Setup
        let pressureAngle: [Double] = [20, 25]   // degrees
        
        let drivingDiam = 10.0     // fixed pitch diameter of driving gear
        
        // velocity amplification
        // let drivenGearDiams: [Double] = Array(stride(from: 2, through: 10, by: 0.5))
        // let diametralPitch: [Double] = Array(stride(from: 7, through: 15, by: 0.5))
        
        // torque amplification
        let drivenGearDiams: [Double] = Array(stride(from: 10, through: 50, by: 1))
        let diametralPitch: [Double] = Array(stride(from: 2, through: 10, by: 1))
        
        // metric units conversion (for constant only)
        let drivingDiamMM = drivingDiam * inToMm
        
        // printing
        var count = 0
        let fileNames: [String] = ["data.csv", "data2.csv"]
        
        for pressAng in pressureAngle {
        
            var csvString = String()
            
            for dGD_in in drivenGearDiams {
                for dP in diametralPitch {
                    
                    let dGD = dGD_in * inToMm
                    let mod = pow(dP, -1) * inToMm
                    
                    // Contact ratio
                    let cR = SpurGearEq.contactRatio(pitchDiam1: drivingDiamMM, pitchDiam2: dGD, dPressAngle: pressAng, module: mod)
                    
                    csvString.append("\(dP), \(dGD_in), \(cR) \n")
                    
                }
                
            }
            
            let fileName = fileNames[count]
            FileHelper.writeCSVFile(csvString: csvString, fileName: fileName)
            count = 1 + count
        }
        
    }
    
    // MARK: - Contact Ratio Helical Gear
    
    class func helicalGears() {
        
        let maxContactRatio = 100.0
        
        // inches to mm convertion
        let inToMm: Double = 25.4
        
        // Setup
        let pressureAngle: Double = 25 // [20, 25]   // degrees
        let drivingDiam = 10.0     // fixed pitch diameter of driving gear
        let inFaceWidths: [Double] = Array(stride(from: 1, through: 5, by: 0.25))
        let helixAngles: [Double] = [5, 15, 30]
        
        let choice = 3
        
        var drivenGearDiams: [Double]
        var diametralPitch: [Double]
        
        switch choice {
        case 0:
            // velocity amplification
            drivenGearDiams = Array(stride(from: 2, through: 10, by: 0.5))
            diametralPitch = Array(stride(from: 7, through: 15, by: 0.5))
        case 1:
            // torque amplification
            drivenGearDiams = Array(stride(from: 10, through: 50, by: 1))
            diametralPitch = Array(stride(from: 2, through: 10, by: 1))
        case 2:
            // entire spectrum
            drivenGearDiams = Array(stride(from: 2, through: 50, by: 1))
            diametralPitch = Array(stride(from: 2, through: 15, by: 1))
        case 3:
            // only changes in diametral pitch
            drivenGearDiams = [10]
            diametralPitch = Array(stride(from: 2, through: 15, by: 0.25))
        default:
            return 
        }
    
    
        // metric units conversion (for constant only)
        let drivingDiamMM = drivingDiam * inToMm
    
        // to print
        var count = 0
        let fileNames: [String] = ["data.csv", "data2.csv", "data3.csv"]
        
        for hA in helixAngles {
            
            var csvString = String()
            
            for d2In in drivenGearDiams {
                for dP in diametralPitch {
                    for fW_in in inFaceWidths {
                    
                        // normal pressure angle
                        let aN = arcTanD(value: tanD(degrees: pressureAngle) * cosD(degrees: hA))
                        
                        // normal module
                        let radialMod = inToMm / dP
                        let normMod = radialMod * cosD(degrees: hA)
                        
                        // mm face width
                        let mmW = fW_in * inToMm
                        
                        // mm d2
                        let d2Mm = d2In * inToMm
                        
                        let cR = NormalHelicalGearEq.totalContactRatio(pitchDiam1: drivingDiamMM, pitchDiam2: d2Mm, normaPressAngl: aN, helical: hA, normalModule: normMod, faceWidth: mmW)
                        
                        if cR >= maxContactRatio {
                            continue
                        }
  
                        csvString.append("\(dP), \(fW_in), \(cR) \n")
                      
                    }
                }
            }
            
            let fileName = fileNames[count]
            FileHelper.writeCSVFile(csvString: csvString, fileName: fileName)
            count = 1 + count
        }
        
    }
}

















