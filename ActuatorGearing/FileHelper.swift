//
//  FileHelper.swift
//  ActuatorGearing
//
//  Created by Luis Fernandez on 9/25/17.
//  Copyright © 2017 Luis Fernandez. All rights reserved.
//

import Foundation

class FileHelper {
    
    /**
     - parameters:
     - csvString: Must be a String, comma separated, included \n at end if line (i.e.: "Date, Time Ended\n")
     */
    class func writeCSVFile(csvString: String, fileName: String) {
        
        let fileURLPath: String = "."
        let path = NSURL(fileURLWithPath: fileURLPath).appendingPathComponent(fileName)

        do {
            try csvString.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
    }
    
    class func getJSONdataString(filePath: String, fileName: String) -> String? {
        
        var result: String?
        
        let path = NSURL(fileURLWithPath: filePath).appendingPathComponent(fileName)
        
        do {
            result = try String(contentsOf: path!, encoding: .utf8)
        } catch {
            print("Failed to load JSON data.")
            print("\(error)")
        }
        
        return(result)
        
    }
    
    class func getJSONdata(filePath: String, fileName: String) -> Data? {
        
        var result: Data?
        
        let path = NSURL(fileURLWithPath: filePath).appendingPathComponent(fileName)
        
        do {
            result = try Data(contentsOf:path!)
        } catch {
            print("Failed to load JSON data.")
            print("\(error)")
        }
        
        return(result)
        
    }
    
}
