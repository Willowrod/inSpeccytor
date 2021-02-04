//
//  Z80Assembler.swift
//  inSpeccytor
//
//  Created by Mike Hall on 04/02/2021.
//

import Foundation

class Z80Assembler {
    
    func assemble(opCode: String) -> String {
        var returner = ""
        let original = opCode
        let splitOpCode = opCode.split(separator: " ")
        let firstPart = splitOpCode[0]
        switch firstPart.uppercased() {
        case "NOP":
            return "00"
        case "DI":
            return "F3"
        case "LD", "LOAD":
            return "02"
            
            
            
        default:
            print ("Opcode \(firstPart) unknown")
            return "XX"
        }
    }
    
}
