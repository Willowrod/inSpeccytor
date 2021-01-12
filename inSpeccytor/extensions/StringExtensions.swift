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
    
    func splitToCodeByteModel(separator: Character, startFrom: Int = 0) -> [CodeByteModel] {
        let subStringArray = self.split(separator: separator)
        var stringArray: [CodeByteModel] = []
        var lineNumber: Int = 0
        for subString in subStringArray {
            stringArray.append(CodeByteModel(withHex: "\(subString.uppercased())", line: lineNumber))
            lineNumber+=1
            if (lineNumber == 27){
                lineNumber = 16384
            }
        }
        return stringArray
    }
    
    func splitToBytes(separator: Character, startFrom: Int = 0) -> [Substring] {
        let subStringArray = self.split(separator: separator)
//        var stringArray: [CodeByteModel] = []
//        var lineNumber: Int = 0
//        for subString in subStringArray {
//            stringArray.append(CodeByteModel(withHex: "\(subString.uppercased())", line: lineNumber))
//            lineNumber+=1
//            if (lineNumber == 27){
//                lineNumber = 16384
//            }
//        }
        return subStringArray
    }
    
//    func splitToBytesROM(separator: Character, startFrom: Int = 0) -> [CodeByteModel] {
//        let subStringArray = self.split(separator: separator)
//        var stringArray: [CodeByteModel] = []
//        var lineNumber: Int = 0
//        for subString in subStringArray {
//            stringArray.append(CodeByteModel(withHex: "\(subString.uppercased())", line: lineNumber))
//            lineNumber+=1
//        }
//        return stringArray
//    }
    
    func splitToBytesROM(separator: Character, startFrom: Int = 0) -> [UInt8] {
        let subStringArray = self.split(separator: separator)
        var rom: [UInt8] = []
        for subString in subStringArray {
            rom.append(UInt8(subString, radix: 16) ?? 0x00)
        }
        return rom
    }
    
    func splitToHeader(separator: Character) -> [CodeByteModel] {
        let subStringArray = self.split(separator: separator)
        var stringArray: [CodeByteModel] = []
        var lineNumber: Int = 0
        for subString in subStringArray {
            stringArray.append(CodeByteModel(withHex: "\(subString.uppercased())", line: lineNumber))
            lineNumber+=1
            if (lineNumber == 27){
                break
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
