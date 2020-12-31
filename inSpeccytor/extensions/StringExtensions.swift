//
//  StringExtensions.swift
//  inSpeccytor
//
//  Created by Mike Hall on 10/10/2020.
//

import Foundation
extension String {
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self)
        stride(from: 0, to: characters.count, by: n).forEach {
            result += String(characters[$0..<min($0+n, characters.count)])
            if $0+n < characters.count {
                result += separator
            }
        }
        return result
    }
    
    func splitToBytes(separator: Character, startFrom: Int = 0) -> [CodeByteModel] {
        let subStringArray = self.split(separator: separator)
        var stringArray: [CodeByteModel] = []
        var lineNumber: Int = 0
        for subString in subStringArray {
            stringArray.append(CodeByteModel(withHex: "\(subString.uppercased())", line: lineNumber))
            lineNumber+=1
//            if (lineNumber == 27){
//                lineNumber = 16384
//            }
        }
        return stringArray
    }
    
    func splitToHeader(separator: Character) -> [CodeByteModel] {
        let subStringArray = self.split(separator: separator)
        var stringArray: [CodeByteModel] = []
        var lineNumber: Int = 0
        for subString in subStringArray {
            stringArray.append(CodeByteModel(withHex: "\(subString.uppercased())", line: lineNumber))
            lineNumber+=1
//            if (lineNumber == 27){
//                break
//            }
            
            if (lineNumber == 27){
                lineNumber = 16384
            }
        }
        return stringArray
    }
    
    func padded(size: Int = 2) -> String {
        let len = self.count
        var rtrn = self
        for _ in len..<size{
            rtrn = "0\(rtrn)"
        }
        return rtrn
    }
}
