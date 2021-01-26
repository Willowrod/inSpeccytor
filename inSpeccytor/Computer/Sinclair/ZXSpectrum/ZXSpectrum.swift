//
//  ZXSpectrum.swift
//  inSpeccytor
//
//  Created by Mike Hall on 25/01/2021.
//

import Foundation
class ZXSpectrum : Z80 {
    
    let beeper = AudioStreamer()
    var keyboard: Array<UInt8> = []
    var kempston: UInt8 = 0x00
    
    override init() {
        super.init()
        keyboard = Array(repeating: 0xff, count: 8)
        beeper.ticksPerFrame = tStatesPerFrame
        loadROM()
    }
    
    func loadROM(){

    }
    
    func expandROM(data: String?){

    }
    
    override func blitScreen(){
        screenBuffer.setAttributes(bytes: memory[1][6144...6911], flashing: flashOn)
        screenBuffer.blit(bytes: memory[1][0...6143])
    }
    
    override func performIn(port: UInt8, map: UInt8, destination: Register){
        if (port == 0xfe){
        switch map{
//        case 0x28...0x28 &+ 7:
//            destination.inCommand(byte: keyboard[Int(l() &- 0x28)])
            
        case 0xfe:
            destination.inCommand(byte: keyboard[7])
        case 0xfd:
            destination.inCommand(byte: keyboard[6])
        case 0xfb:
            destination.inCommand(byte: keyboard[5])
        case 0xf7:
            destination.inCommand(byte: keyboard[4])
        case 0xef:
            destination.inCommand(byte: keyboard[3])
        case 0xdf:
            destination.inCommand(byte: keyboard[2])
        case 0xbf:
            destination.inCommand(byte: keyboard[1])
        case 0x7f:
            destination.inCommand(byte: keyboard[0])
        default:
            break
        }
        } else if port == 0x7f {
 //           print("Checking for Fuller Joystick")
            //             destination.inCommand(byte: kempston)
        } else if port == 0x1f {
          destination.inCommand(byte: kempston)
 //          print("Checking for Kempston Joystick")
        } else {
 //           print("Checking port \(port.hex())")
        }
    }
    
    override func performOut(port: UInt8, map: UInt8, source: Register) {
        if (port == 0xfe){ // Change the border colour
                DispatchQueue.main.sync {
            delegate?.updateBorder(colour: source.byteValue.border())
                }
        }
        if (port == 0xfd){ // 128k paging
      //      delegate?.updateBorder(colour: source.byteValue.border())
        }
    }
    
    override func process() {
        currentTStates = 0
        while true {
            if pauseProcessor {
                break
            }
                        if (!frameEnds) {
            if (shouldRunInterupt){
                interupt = false
                interupt2 = false
                push(value: PC)
                switch interuptMode {
                case 0:
                    PC = 0x0066
                case 1:
                    PC = 0x0038
                default:
                    let intAddress = (UInt16(I.byteValue) * 256) + UInt16(R.byteValue)
                    PC = fetchRamWord(location: intAddress)
                    
                }
                halt = false
                shouldRunInterupt = false
            }
            if (halt){
                instructionComplete(states: 4, length: 0)
                halt = false
            } else {
                let byte = fetchRam(location: PC)
                shouldBreak = breakPoints.contains(PC) || shouldStep || shouldForceBreak
                if (shouldBreak){
                    DispatchQueue.main.sync {
                        delegate?.updateRegisters()
                        delegate?.updateDebug(line: PC)
                    }
                    while shouldBreak {
                    }
                }
                
                shouldForceBreak = false
           //   print("Next: \(String(PC, radix:16)) Opcode: \(String(byte, radix:16)) \(byte) A: \(String(a(), radix: 16)) F: \(String(f(), radix: 16)) (\(String(f(), radix: 2))) HL: \(String(HL.value(), radix: 16))  BC: \(String(BC.value(), radix: 16)) DE: \(String(DE.value(), radix: 16))")
//                if PC >= 0x00f0 {
//                    print("Breaking here")
//                }
                
                opCode(byte: byte)
                beeper.updateSample(UInt32(currentTStates), beep: clicks)
        
            }
            if currentTStates >= tStatesPerFrame {
                currentTStates = 0
                renderFrame()
            }
            
                        }
                        else {
                            let time = Date().timeIntervalSince1970
                            if (frameStarted + 0.02 <= time){
                                frameStarted = time
                                frameEnds = false
                            }
                        }
        }
    }
    
    func runInterupt() {
        if (interupt){
            shouldRunInterupt = true
        }
    }
    
    override func renderFrame(){
        beeper.endFrame()
        flashCount += 1
        if (flashCount >= 16){
            flashCount = 0
            flashOn = !flashOn
        }
        DispatchQueue.main.sync {
            self.blitScreen()
            self.delegate?.updateView(bitmap: self.screenBuffer)
        }
        frameEnds = true
        runInterupt()
    }
    
    func keyboardInteraction(key: Int, pressed: Bool){
        var bank = -1
        var bit = -1
        switch key{
        case 4: // a
            bank = 6
            bit = 0
        case 5: // b
            bank = 0
            bit = 4
        case 6: // c
            bank = 7
            bit = 3
        case 7: // d
            bank = 6
            bit = 2
        case 8: // e
            bank = 5
            bit = 2
        case 9: // f
            bank = 6
            bit = 3
        case 10: // g
            bank = 6
            bit = 4
        case 11: // h
            bank = 1
            bit = 4
        case 12: // i
            bank = 2
            bit = 2
        case 13: // j
            bank = 1
            bit = 3
        case 14: // k
            bank = 1
            bit = 2
        case 15: // l
            bank = 1
            bit = 1
        case 16: // m
            bank = 0
            bit = 2
        case 17: // n
            bank = 0
            bit = 3
        case 18: // o
            bank = 2
            bit = 1
        case 19: // p
            bank = 2
            bit = 0
        case 20: // q
            bank = 5
            bit = 0
        case 21: // r
            bank = 5
            bit = 3
        case 22: // s
            bank = 6
            bit = 1
        case 23: // t
            bank = 5
            bit = 4
        case 24: // u
            bank = 2
            bit = 3
        case 25: // v
            bank = 7
            bit = 4
        case 26: // w
            bank = 5
            bit = 1
        case 27: // x
            bank = 7
            bit = 2
        case 28: // y
            bank = 2
            bit = 4
        case 29: // z
            bank = 7
            bit = 1
        case 30: // 1
            bank = 4
            bit = 0
        case 31: // 2
            bank = 4
            bit = 1
        case 32: // 3
            bank = 4
            bit = 2
        case 33: // 4
            bank = 4
            bit = 3
        case 34: // 5
            bank = 4
            bit = 4
        case 35: // 6
            bank = 3
            bit = 4
        case 36: // 7
            bank = 3
            bit = 3
        case 37: // 8
            bank = 3
            bit = 2
        case 38: // 9
            bank = 3
            bit = 1
        case 39: // 0
            bank = 3
            bit = 0
        case 40: // enter
            bank = 1
            bit = 0
        case 44: // space
            bank = 0
            bit = 0
        case 225: // LShift (CS)
            bank = 7
            bit = 0
        case 224: // LCnt (SS)
            bank = 0
            bit = 1
            
        default:
            bank = -1
            bit = -1
        }
        if bank >= 0 && bit >= 0 {
            pressed ? keyboard[bank].clear(bit: bit) : keyboard[bank].set(bit: bit)
        }
    }
    
    func joystickInteraction(key: Int, pressed: Bool){
        // Kempston 000FUDLR
        switch key{
        case 1: // Left
            pressed ? kempston.set(bit: 1) : kempston.clear(bit: 1)
        case 2: // Right
            pressed ? kempston.set(bit: 0) : kempston.clear(bit: 0)
        case 3: // Up
            pressed ? kempston.set(bit: 3) : kempston.clear(bit: 3)
        case 4: // Down
            pressed ? kempston.set(bit: 2) : kempston.clear(bit: 2)
        case 5: // LFire
            pressed ? kempston.set(bit: 4) : kempston.clear(bit: 4)
        case 6: // RFire
            pressed ? kempston.set(bit: 4) : kempston.clear(bit: 4)
        default:
         break
        }
        
        
    }
    
    override func load(file: String){
       var fileStruct = file.split(separator: ".")
        
        if fileStruct.count > 1{
            let fileType = fileStruct.last
            fileStruct.removeLast()
            let name = fileStruct.joined(separator: ".")
            delegate?.updateTitle(title: name)
            switch fileType {
            case "sna":
                loadSnapshot(sna: name)
            case "z80":
                loadZ80(z80Snap: name)
            case "tzx":
                importTZX(tzxFile: name)
            default:
                print("Unknown file type = \(file)")
            }
        } else {
            print("Unknown or bad file = \(file)")
        }
    }
    
    func loadSnapshot(sna: String){
            let snapShot = SNAFormat(fileName: sna)
        writeRAM(dataModel: snapShot.ramBanks[0], startAddress: 16384)
        initialiseRegisters(header: snapShot.registers)
        header = snapShot.registers
        writeCodeBytes()
    }
    
    func loadZ80(z80Snap: String){
        let snapShot = Z80Format(fileName: z80Snap)
        let banks = snapShot.retrieveRam()
        if (banks.count > 0){
            if banks.count == 1{
        writeRAM(dataModel: banks[0], startAddress: 16384)
            } else {
                writeRAMBanks(dataModel: banks)
            }
    initialiseRegisters(header: snapShot.registers)
        header = snapShot.registers
        writeCodeBytes()
        }
    }
    
    func importTZX(tzxFile: String){
        if let filePath = Bundle.main.path(forResource: tzxFile, ofType: "tzx"){
            print("File found - \(filePath)")
            if let index = filePath.lastIndex(of: "/"){
                let name = filePath.substring(from: index)
                delegate?.updateTitle(title: name)
            } else {
                delegate?.updateTitle(title: "Unknown Snapshot")
                //hexView.text = "- - - - - - - -"
            }
            let contents = NSData(contentsOfFile: filePath)
            let data = contents! as Data
            let dataString = data.hexString
            let tzx = TZXFormat.init(data: dataString)
        } else {
            delegate?.updateTitle(title: "Snapshot failed to load")
            //hexView.text = "- - - - - - - -"
            print("file not found")
        }
    }
    
    func writeCodeBytes(){
        var model: Array<CodeByteModel> = []
        var id = 0x4000
        memory[1].forEach{byte in
            model.append(byte.createCodeByte(lineNumber: id))
            id += 1
        }
        delegate?.updateCodeByteModel(model: model)
    }
    
}
