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
    
    func rlc(secondPart: String, opCode: String) -> String {
        if secondPart == "(HL)"{
            return "CB 06"
        }
        if let offset = secondPart.regOffset() {
            return "CB \((0x00 &+ offset).hex())"
        }
        if let displacement = secondPart.displacement(){
            if secondPart.contains("IX+") {
                return "DD CB \(displacement) 06"
            }
            if secondPart.contains("IY+") {
                return "FD CB \(displacement) 06"
            }
        }
        print("RLC did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func rr(secondPart: String, opCode: String) -> String {
        if secondPart == "(HL)"{
            return "CB 1E"
        }
        if let offset = secondPart.regOffset() {
            return "CB \((0x18 &+ offset).hex())"
        }
        if let displacement = secondPart.displacement(){
            if secondPart.contains("IX+") {
                return "DD 1E \(displacement) 16"
            }
            if secondPart.contains("IY+") {
                return "FD 1E \(displacement) 16"
            }
        }
        print("RR did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func rrc(secondPart: String, opCode: String) -> String {
        if secondPart == "(HL)"{
            return "CB 0E"
        }
        if let offset = secondPart.regOffset() {
            return "CB \((0x08 &+ offset).hex())"
        }
        if let displacement = secondPart.displacement(){
            if secondPart.contains("IX+") {
                return "DD 0E \(displacement) 06"
            }
            if secondPart.contains("IY+") {
                return "FD 0E \(displacement) 06"
            }
        }
        print("RRC did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func sla(secondPart: String, opCode: String) -> String {
        if secondPart == "(HL)"{
            return "CB 26"
        }
        if let offset = secondPart.regOffset() {
            return "CB \((0x20 &+ offset).hex())"
        }
        if let displacement = secondPart.displacement(){
            if secondPart.contains("IX+") {
                return "DD CB \(displacement) 26"
            }
            if secondPart.contains("IY+") {
                return "FD CB \(displacement) 26"
            }
        }
        print("SLA did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func sll(secondPart: String, opCode: String) -> String {
        if secondPart == "(HL)"{
            return "CB 36"
        }
        if let offset = secondPart.regOffset() {
            return "CB \((0x30 &+ offset).hex())"
        }
        if let displacement = secondPart.displacement(){
            if secondPart.contains("IX+") {
                return "DD CB \(displacement) 36"
            }
            if secondPart.contains("IY+") {
                return "FD CB \(displacement) 36"
            }
        }
        print("SLL did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func sra(secondPart: String, opCode: String) -> String {
        if secondPart == "(HL)"{
            return "CB 2E"
        }
        if let offset = secondPart.regOffset() {
            return "CB \((0x28 &+ offset).hex())"
        }
        if let displacement = secondPart.displacement(){
            if secondPart.contains("IX+") {
                return "DD 1E \(displacement) 2E"
            }
            if secondPart.contains("IY+") {
                return "FD 1E \(displacement) 2E"
            }
        }
        print("SRA did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func srl(secondPart: String, opCode: String) -> String {
        if secondPart == "(HL)"{
            return "CB 3E"
        }
        if let offset = secondPart.regOffset() {
            return "CB \((0x38 &+ offset).hex())"
        }
        if let displacement = secondPart.displacement(){
            if secondPart.contains("IX+") {
                return "DD 0E \(displacement) 3E"
            }
            if secondPart.contains("IY+") {
                return "FD 0E \(displacement) 3E"
            }
        }
        print("SRL did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    
}
