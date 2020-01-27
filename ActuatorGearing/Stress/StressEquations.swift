//
//  StressEquations.swift
//  ActuatorGearing
//
//  Created by Luis Fernandez on 9/29/17.
//  Copyright © 2017 Luis Fernandez. All rights reserved.
//

import Foundation

class StressEquations {
    
    // NOTE: For this class, mustset inital properties.
    
    // MARK: - Stress Modificantion Factors
    
    var dynamicFactor: Double?  // Kv
    var loadDistrFctr: Double?  // Km
    var geometricBendingFctr: Double?    // J
    var geometricSurfaceFctr: Double?    // I
    var elasticCoefficient: Double?     // Cp
    
    var tangentialLoad: Double?
    var faceWidth: Double?
    var diametralPitch: Double?
    var pinionPtchDiamtr: Double?
    
    // MARK: - Stress Equations
    
    func bendingStress(tangentialLoad tL: Double, faceWidth fW: Double, diametralPitch dP: Double) -> Double? {
        
        if dynamicFactor != nil && loadDistrFctr != nil && geometricBendingFctr != nil {
            return ( tL * dynamicFactor! * loadDistrFctr! * dP ) / ( fW * geometricBendingFctr! )
        }
        
        // error: Did not set required properties
        
        print( "Error at StressEquations.bendingStress. Set initial properties of class." )
        
        return nil
        
    }
    
    func bendingStress() -> Double? {
        
        if
            dynamicFactor != nil,
            loadDistrFctr != nil,
            geometricBendingFctr != nil,
            tangentialLoad != nil,
            faceWidth != nil,
            diametralPitch != nil
        {
            return ( tangentialLoad! * dynamicFactor! * loadDistrFctr! * diametralPitch! ) / ( faceWidth! * geometricBendingFctr! )
        }
        
        // error: Did not set required properties
        
        print( "Error at StressEquations.bendingStress. Some properties were not set and are currently nil." )
        
        return nil
        
    }
    
    func contactStress(tangentialLoad tL: Double, faceWidth fW: Double, pinionPtchDiamtr pPD: Double) -> Double? {

        if elasticCoefficient != nil && dynamicFactor != nil && loadDistrFctr != nil && geometricSurfaceFctr != nil {
            
            return elasticCoefficient! * ( ( tL * dynamicFactor! * loadDistrFctr! ) / ( pPD * fW * geometricSurfaceFctr! ) ).squareRoot()
            
        }
        
        // error: Did not set required properties
        
        print( "Error at StressEquations.contactStress. Some properties were not set and are currently nil." )
        
        return nil
        
    }
    
    func contactStress() -> Double? {
        
        if
            elasticCoefficient != nil,
            dynamicFactor != nil,
            loadDistrFctr != nil,
            geometricSurfaceFctr != nil,
            tangentialLoad != nil,
            faceWidth != nil,
            pinionPtchDiamtr != nil
        {
            
            return elasticCoefficient! * ( ( tangentialLoad! * dynamicFactor! * loadDistrFctr! ) / ( pinionPtchDiamtr! * faceWidth! * geometricSurfaceFctr! ) ).squareRoot()
            
        }
        
        // error: Did not set required properties
        
        print( "Error at StressEquations.contactStress. Some properties were not set and are currently nil." )
        
        return nil
        
    }
    
}
