//
//  Log.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 24/02/2021.
//

import Foundation

import Foundation

class Log {
    
    /**
     Creates a console DEBUG message
     - Parameter message: Message that should be logged
     - Parameter file: File path (do not need to specify)
     - Parameter function: Function name (do not need to specify)
     - Parameter line: Line number (do not need to specify)
     */
    static func debug(message: String, _ userInfo: Any, file: String = #file, function: String = #function, line: Int = #line ) {   // file is #file
        let fileName = file.components(separatedBy: "/").last ?? "unknown_filename"
        print("DEBUG - [\(function) in \(fileName): Line \(line)] :  \(message) \n Dump: \(dump(userInfo))")
    }
    
    
    /**
    Creates a console EXCEPTION message
    - Parameter message: Message that should be logged
    - Parameter file: File path (do not need to specify)
    - Parameter function: Function name (do not need to specify)
    - Parameter line: Line number (do not need to specify)
    */
    static func exception(message: String, _ userInfo: Any, file: String = #file, function: String = #function, line: Int = #line ) {
        let fileName = file.components(separatedBy: "/").last ?? "unknown_filename"
        print("EXCEPTION - [\(function) in \(fileName): Line \(line)] :  \(message) \n Dump: \(dump(userInfo))")
    }
    
    
    /// Special log to use in the deinit
    /// - Parameters:
    ///   - name: name of the Object (ie "String(describing: self)" )
    ///   - file: DON'T fill (automatically gets the filename)
    static func logDeinit(_ name: String, file: String = #file) {
        let fileName = file.components(separatedBy: "/").last ?? "unknown_filename"
        print("Deinit Called - [\(fileName)]")
    }
    
}


extension Thread {
    class func printThread() {
        print("\r Thread - \(Thread.current) - QueueLabel \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
    }
}
