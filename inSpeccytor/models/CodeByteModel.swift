//
//  CodeByteModel.swift
//  inSpeccytor
//
//  Created by Mike Hall on 10/10/2020.
//

import Foundation

class CodeByteModel: Codable {
    var lineNumber: Int32
    var hexValue: String
    var intValue: Int16
    
    init(withHex: String, line: Int32){
        hexValue = withHex
        lineNumber = line
        if let inty = Int16(withHex, radix: 16){
            intValue = inty
        } else {
            intValue = -1
        }
    }
    
    
}
