//
//  Z80Assembler+Ports.swift
//  inSpeccytor
//
//  Created by Mike Hall on 09/02/2021.
//

import Foundation
extension Z80Assembler {
    
    
    func portin(secondPart: String, opCode: String) -> String {
        let split = secondPart.split(separator: ",")
        if split.count == 2{
            if let byte = String(split[1]).validUInt8(){
                return "DB \(byte.hex())"
            }
            if split[1] == "(C)" {
                switch split[0] {
                case "A":
                    return "ED 78"
                case "B":
                    return "ED 40"
                case "C":
                    return "ED 48"
                case "D":
                    return "ED 50"
                case "E":
                    return "ED 58"
                case "H":
                    return "ED 60"
                case "L":
                    return "ED 68"
                default:
                    break
                }
            }
        }
        print("IN did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
    
    func portout(secondPart: String, opCode: String) -> String {
        let split = secondPart.split(separator: ",")
        if split.count == 2{
            if let byte = String(split[0]).validUInt8(){
                return "D3 \(byte.hex())"
            }
            if split[0] == "(C)" {
                switch split[1] {
                case "A":
                    return "ED 79"
                case "B":
                    return "ED 41"
                case "C":
                    return "ED 49"
                case "D":
                    return "ED 51"
                case "E":
                    return "ED 59"
                case "H":
                    return "ED 61"
                case "L":
                    return "ED 69"
                default:
                    break
                }
            }
        }
        print("IN did not conform to any known pattern for opcode \(opCode)")
        return "??"
    }
}
