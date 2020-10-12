//
//  RegisterModel.swift
//  inSpeccytor
//
//  Created by Mike Hall on 11/10/2020.
//

import Foundation

class RegisterModel: Codable {
    // 8 Bit registers
    var registerA: Int16
    var registerB: Int16
    var registerC: Int16
    var registerD: Int16
    var registerE: Int16
    var registerH: Int16
    var registerL: Int16
    var registerF: Int16
    
    // 8 Bit swap registers
    var registerA2: Int16
    var registerB2: Int16
    var registerC2: Int16
    var registerD2: Int16
    var registerE2: Int16
    var registerH2: Int16
    var registerL2: Int16
    var registerF2: Int16
    
    // 16 Bit register pairs
    var registerAF: Int16
    var registerBC: Int16
    var registerDE: Int16
    var registerHL: Int16
    
    // 16 Bit swap register pairs
    var registerAF2: Int16
    var registerBC2: Int16
    var registerDE2: Int16
    var registerHL2: Int16
    
    // 8 Bit other registers
    var registerI: Int16
    var registerR: Int16
    
    // 16 Bit other registers
    var registerSP: Int16 // Stack pointer
    var registerPC: Int16 // Program counter
    
}
