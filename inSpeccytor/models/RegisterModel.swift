//
//  RegisterModel.swift
//  inSpeccytor
//
//  Created by Mike Hall on 11/10/2020.
//

import Foundation

struct RegisterModel: Codable {
    // 8 Bit registers
    var registerA: Int = -1
    var registerB: Int = -1
    var registerC: Int = -1
    var registerD: Int = -1
    var registerE: Int = -1
    var registerH: Int = -1
    var registerL: Int = -1
    var registerF: Int = -1
    
    // 8 Bit swap registers
    var registerA2: Int = -1
    var registerB2: Int = -1
    var registerC2: Int = -1
    var registerD2: Int = -1
    var registerE2: Int = -1
    var registerH2: Int = -1
    var registerL2: Int = -1
    var registerF2: Int = -1
    
    // 16 Bit register pairs
    var registerAF: Int = -1
    var registerBC: Int = -1
    var registerDE: Int = -1
    var registerHL: Int = -1
    
    // 16 Bit swap register pairs
    var registerAF2: Int = -1
    var registerBC2: Int = -1
    var registerDE2: Int = -1
    var registerHL2: Int = -1
    
    // 8 Bit other registers
    var registerI: Int = -1
    var registerR: Int = -1
    
    // 16 Bit other registers
    var registerIX: Int = -1
    var registerIY: Int = -1
    var registerSP: Int = -1 // Stack pointer
    var registerPC: Int = 0 // Program counter
    
    var interupt: Int = -1
    
    init() {
        
    }
    
    init(header:Array<CodeByteModel>) {
        registerI = header[0].intValue
        registerL2 = header[1].intValue
        registerH2 = header[2].intValue
        registerE2 = header[3].intValue
        registerD2 = header[4].intValue
        registerC2 = header[5].intValue
        registerB2 = header[6].intValue
        registerF2 = header[7].intValue
        registerA2 = header[8].intValue
        registerL = header[9].intValue
        registerH = header[10].intValue
        registerE = header[11].intValue
        registerD = header[12].intValue
        registerC = header[13].intValue
        registerB = header[14].intValue
        registerIY = registerPair(l:header[15].intValue, h:header[16].intValue)
        registerIX = registerPair(l:header[17].intValue, h:header[18].intValue)
        interupt = header[19].intValue
        registerR = header[20].intValue
        registerF = header[21].intValue
        registerA = header[22].intValue
        registerSP = registerPair(l:header[23].intValue, h:header[24].intValue)

        registerHL = registerPair(l: registerL, h: registerH)
        registerDE = registerPair(l: registerE, h: registerD)
        registerBC = registerPair(l: registerC, h: registerB)
        registerAF = registerPair(l: registerF, h: registerA)
        registerHL2 = registerPair(l: registerL2, h: registerH2)
        registerDE2 = registerPair(l: registerE2, h: registerD2)
        registerBC2 = registerPair(l: registerC2, h: registerB2)
        registerAF2 = registerPair(l: registerF2, h: registerA2)

        if let stackStart = header.firstIndex(where: {$0.lineNumber == registerSP}){
            registerPC = registerPair(l: header[stackStart].intValue, h: header[stackStart+1].intValue)//Int(stackStart.intValue)
        }
        
        
    }
    
    func registerPair(l: Int, h: Int) -> Int{
        return (h * 256) + l
    }
    
    /*
        0        1      byte   I
        1        8      word   HL',DE',BC',AF'
        9        10     word   HL,DE,BC,IY,IX
        19       1      byte   Interrupt (bit 2 contains IFF2, 1=EI/0=DI)
        20       1      byte   R
        21       4      words  AF,SP
        25       1      byte   IntMode (0=IM0/1=IM1/2=IM2)
        26       1      byte   BorderColor (0..7, not used by Spectrum 1.7)
        27       49152  bytes  RAM dump 16384..65535
     */
}
