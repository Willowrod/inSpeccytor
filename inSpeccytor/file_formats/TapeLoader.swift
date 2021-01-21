//
//  TapeLoader.swift
//  inSpeccytor
//
//  Created by Mike Hall on 20/01/2021.
//

import UIKit

protocol TapeDelegate {
    func callNextBlock() -> BaseTZXBlock?
}

class TapeLoader: Z80 {

    var tapeDelegate: TapeDelegate? = nil
    var newLoad = true
    var basicBlock = false
    
    func initialiseTape (){
        IX.ld(value: 0x5ce2)
        IY.ld(value: 0x5c3a)
        newLoad = true
        PC = 0x0556
        process()
    }
    
    func loadTape(){
        if !newLoad {
            // We should get the current PC from the stack
        }
        newLoad = false
        if let currentBlock = tapeDelegate?.callNextBlock() {
            currentBlock.blockData.forEach{ byte in
                ldRam(location: IX.value(), value: byte)
                IX.inc()
            }
            if basicBlock {
                IX.ld(value: <#T##UInt16#>)
            }
            
            if (currentBlock.isHeader){
                PC = 0x0873
                basicBlock = true
            }
            
        }
    }
    
    override func performIn(port: UInt8, map: UInt8, destination: Register){
        if (port == 0xfe){
            
        }
    }
    
    override func process() {
        currentTStates = 0
        while true {
            if PC == 0x0556 {
                   // Load the next tape block
                loadTape()
            } else {
                let byte = ram[Int(PC)]
                opCode(byte: byte)
            }
            }
                        }
    
    
    override func instructionComplete(states: Int, length: UInt16 = 1) {
        PC = PC &+ length
    }
}
