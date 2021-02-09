//
//  Z80Assembler+BitShift.swift
//  inSpeccytor
//
//  Created by Mike Hall on 09/02/2021.
//

import Foundation
extension Z80Assembler {
    func rl(secondPart: String, opCode: String) -> String {
        if secondPart == "(HL)"{
            return "CB 16"
        }
        if let offset = secondPart.regOffset() {
            return "CB \((0x10 &+ offset).hex())"
        }

            
            if let offset = secondPart.validUInt8() {
                return "EE \(offset.hex())"
            }
            if let displacement = secondPart.displacement(){
                if secondPart.contains("IX+") {
                    return "DD CB \(displacement) 16"
                }
                if secondPart.contains("IY+") {
                    return "FD CB \(displacement) 16"
                }
            }
            
        print("RL did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
}
