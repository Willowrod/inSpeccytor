//
//  Z80.swift
//  inSpeccytor
//
//  Created by Mike Hall on 18/12/2020.
//

import Foundation
import AVFoundation

protocol Z80Delegate {
    func updateView(bitmap: Bitmap?)
    func updateDebug(line: UInt16)
    func updateRegisters()
}

class Z80 {
    var A: Accumilator = Accumilator()
    static var F: FlagRegister = FlagRegister()
    var AF: RegisterPair = RegisterPair()
    var HL: RegisterPair = RegisterPair()
    var BC: RegisterPair = RegisterPair()
    var DE: RegisterPair = RegisterPair()
    var IX: RegisterPair = RegisterPair()
    var IY: RegisterPair = RegisterPair()
    var AF2: RegisterPair = RegisterPair()
    var HL2: RegisterPair = RegisterPair()
    var BC2: RegisterPair = RegisterPair()
    var DE2: RegisterPair = RegisterPair()
    var I: Register = Register()
    var interupt: Bool = true
    var interupt2: Bool = true
    var R: Register = Refresh()
    var PC: UInt16 = 0
    var SP: UInt16 = 0
    var MEMPTR: UInt16 = 0
    var interuptMode = 1
    var screenWriteComplete = true
    var ram: Array<UInt8> = []
    var keyboard: Array<UInt8> = []
    var screenBuffer = Bitmap(width: 256, height: 192, color: .white)
    let tStatesPerFrame = 69888
    var currentTStates = 0
    var frameEnds = true
    var frameStarted: TimeInterval = Date().timeIntervalSince1970
    var flashCount = 0
    var flashOn = false
    var delegate: Z80Delegate?
    var halt = false
    var stackSize = 0
    var shouldRunInterupt = false
    var shouldBreak = false
    var shouldStep = false
    var shouldForceBreak = false
    var breakPoints: Array<UInt16> = []
    let beeper = AudioStreamer()
    var pauseProcessor = false
    var clicks: UInt8 = 0
    
    init() {
        ram = Array(repeating: 0, count: 65536)
        keyboard = Array(repeating: 0xff, count: 8)
        breakPoints = Array()
        A.byteValue = a()
        Z80.F.byteValue = f()
        bc().setPairs(h: b(), l: c())
        de().setPairs(h: d(), l: e())
        hl().setPairs(h: h(), l: l())
        af().setAF(h: A, l: Z80.F)
        iy().ld(value: 23610)
        PC = 0
        SP = 0
        
        beeper.ticksPerFrame = tStatesPerFrame

        
        
    }
    
    func accumilator() -> Accumilator{
        return A
    }
    
    static func flag() -> Register{
        return F
    }
    
    func aR() -> Accumilator{
        return A
    }
    
    static func fR() -> Register{
        return F
    }
    
    func hR() -> Register{
        return HL.high
    }
    
    func lR() -> Register{
        return HL.low
    }
    
    func bR() -> Register{
        return BC.high
    }
    
    func cR() -> Register{
        return BC.low
    }
    
    func dR() -> Register{
        return DE.high
    }
    
    func eR() -> Register{
        return DE.low
    }
    
    func a() -> UInt8{
        return A.byteValue
    }
    
    func f() -> UInt8{
        return Z80.F.byteValue
    }
    
    func h() -> UInt8{
        return HL.high.byteValue
    }
    
    func l() -> UInt8{
        return HL.low.byteValue
    }
    
    func b() -> UInt8{
        return BC.high.byteValue
    }
    
    func c() -> UInt8{
        return BC.low.byteValue
    }
    
    func d() -> UInt8{
        return DE.high.byteValue
    }
    
    func e() -> UInt8{
        return DE.low.byteValue
    }
    
    func af() -> RegisterPair{
        return AF
    }
    
    func hl() -> RegisterPair{
        return HL
    }
    
    func bc() -> RegisterPair{
        return BC
    }
    
    func de() -> RegisterPair{
        return DE
    }
    
    func af2() -> RegisterPair{
        return AF2
    }
    
    func hl2() -> RegisterPair{
        return HL2
    }
    
    func bc2() -> RegisterPair{
        return BC2
    }
    
    func de2() -> RegisterPair{
        return DE2
    }
    
    func ix() -> RegisterPair{
        return IX
    }
    
    func iy() -> RegisterPair{
        return IY
    }
    
    func testRegisters(){
        
    }
    
    func exchange(working: RegisterPair, spare: RegisterPair){
        let sparePair = RegisterPair()
        sparePair.swap(spare: working)
        working.swap(spare: spare)
        spare.swap(spare: sparePair)
    }
    
    func exchangeAll(){
        exchange(working: BC, spare: BC2)
        exchange(working: DE, spare: DE2)
        exchange(working: HL, spare: HL2)
    }
    
    func initialiseRegisters(header: RegisterModel){
        testRegisters()
        aR().ld(value:header.primary.registerA)
        Z80.fR().ld(value:header.primary.registerF)
        bR().ld(value:header.primary.registerB)
        cR().ld(value:header.primary.registerC)
        dR().ld(value:header.primary.registerD)
        eR().ld(value:header.primary.registerE)
        hR().ld(value:header.primary.registerH)
        lR().ld(value:header.primary.registerL)
        
        BC2.ld(value:header.registerPair(l: header.swap.registerC, h: header.swap.registerB))
        DE2.ld(value:header.registerPair(l: header.swap.registerE, h: header.swap.registerD))
        HL2.ld(value:header.registerPair(l: header.swap.registerL, h: header.swap.registerH))
        AF2.ld(value:header.registerPair(l: header.swap.registerF, h: header.swap.registerA))

        SP = header.registerSP
        ix().ld(value: header.registerIX)
        iy().ld(value: header.registerIY)
        
        I.ld(value: header.registerI)
        R.ld(value: header.registerR)
        
        interuptMode = header.interuptMode
        interupt = header.interuptEnabled
        interupt2 = interupt
        
        if (header.shouldReturn){
        ret()
        } else {
            PC = header.registerPC
        }
    }
    
    func writeRAM(dataModel: Array<UInt8>, startAddress: Int = 0){
        pauseProcessor = true
        interupt = false
        var count = startAddress
        dataModel.forEach { byte in
            ram[count] = byte
            count += 1
        }
        pauseProcessor = false
    }
    
    func renderFrame(){
        beeper.endFrame()
        flashCount += 1
        if (flashCount >= 16){
            flashCount = 0
            flashOn = !flashOn
        }
        DispatchQueue.main.sync {
            self.blitMeAScreen()
            self.delegate?.updateView(bitmap: self.screenBuffer)
        }
        frameEnds = true
        runInterupt()
    }
    
    func blitMeAScreen(){
        screenBuffer.setAttributes(bytes: ram[22528...23295], flashing: flashOn)
        screenBuffer.blit(bytes: ram[16384...22527])
    }
    
    func performIn(port: UInt8, map: UInt8, destination: Register){
        if (port == 0xfe){
        switch map{
        case 0x28...0x28 &+ 7:
            destination.inCommand(byte: keyboard[Int(l() &- 0x28)])
            
        default:
            print("checking Keyboard for \(map.hex())")
        }
        } else if port == 0x7f {
            print("Checking for Kempston Joystick")
        } else if port == 0x1f {
            print("Checking for Fuller Joystick")
        } else {
            print("Checking port \(port.hex())")
        }
    }
    
    func process() {
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
                    PC = (UInt16(I.byteValue) * 256) + UInt16(R.byteValue)
                }
                halt = false
                shouldRunInterupt = false
            }
            if (halt){
                instructionComplete(states: 4, length: 0)
                halt = false
            } else {
                let byte = ram[Int(PC)]
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
    //            print("Next: \(String(PC, radix:16)) Opcode: \(String(byte, radix:16)) A: \(String(a(), radix: 16)) F: \(String(f(), radix: 16)) (\(String(f(), radix: 2))) HL: \(String(HL.value(), radix: 16))  BC: \(String(BC.value(), radix: 16)) DE: \(String(DE.value(), radix: 16))")
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
    
    func instructionComplete(states: Int, length: UInt16 = 1) {
        currentTStates += states
        PC = PC &+ length
    }
    
    func call(location: UInt16, length: UInt16 = 1){
        PC = PC &+ length
        push(value: PC)
        PC = location
    }
    
    func jump(location: UInt16){
        PC = location
    }
    
    func push(value: UInt16){
        SP = SP &- 2
        ldRam(location: SP, value: value)
        stackSize += 1
    }
    
    func pop() -> UInt16 {
        let value = fetchRamWord(location: SP)
        stackSize -= 1
        SP = SP &+ 2
        return value
    }
    
    func ret(){
        PC = pop()
    }
    
    func decRam(location: Int){
        var ramByte: UInt8 = fetchRam(location: location)
        ramByte.dec()
        ldRam(location: location, value: ramByte)
    }
    
    func incRam(location: Int){
        var ramByte: UInt8 = fetchRam(location: location)
        ramByte.inc()
        ldRam(location: location, value: ramByte)
    }
    
    func ldRam(location: Int, value: UInt8){
        if location >= 0x4000 && location <= 0xFFFF{
        ram[location] = value
        } else {
            print("Attempting to write to invalid memory location \(String(location, radix: 16))")
        }
    }
    
    func ldRam(location: Int, value: UInt16){
        ldRam(location: location, value: value.lowBit())
        ldRam(location: location &+ 1, value: value.highByte())
    }
    
    func ldRam(location: UInt16, value: UInt8){
        ldRam(location: Int(location), value: value)
    }
    
    func ldRam(location: UInt16, value: UInt16){
        ldRam(location: Int(location), value: value)
    }
    
    func fetchRam(location: Int) -> UInt8 {
        return ram[location]
    }
    
    func fetchRamWord(location: Int) -> UInt16 {
        
        return UInt16(ram[location]) &+ (UInt16(ram[location &+ 1]) * 256)
    }
    
    func fetchRam(location: UInt16) -> UInt8 {
        return fetchRam(location: Int(location))
    }
    
    func fetchRamWord(location: UInt16) -> UInt16 {
        return fetchRamWord(location: Int(location))
    }
    
    func relativeJump(twos: UInt8) {
        PC = PC &+ 2
        let subt = twos.isSet(bit: 7)
        let comp = twos.twosCompliment()
        if subt{
            PC = PC &- UInt16(comp)
        } else {
            PC = PC &+ UInt16(twos)
        }
    }
    
    func iYOffset(twos: UInt8) -> UInt16 {
        let subt = twos.isSet(bit: 7)
        let comp = twos.twosCompliment()
        if subt{
            return iy().value() &- UInt16(comp)
        } else {
            return iy().value() &+ UInt16(comp)
        }
    }
    
}
