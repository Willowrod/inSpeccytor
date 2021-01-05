//
//  CodeByteModel.swift
//  inSpeccytor
//
//  Created by Mike Hall on 10/10/2020.
//

import Foundation

class CodeByteModel: Codable {
    var lineNumber: Int
    var hexValue: String
    var intValue: Int
    
    init(withHex: String, line: Int){
        hexValue = withHex
        lineNumber = line
        if let inty = Int(withHex, radix: 16){
            intValue = inty
        } else {
            intValue = -1
        }
    }
}
