//
//  Z80.swift
//  inSpeccytor
//
//  Created by Mike Hall on 18/12/2020.
//

import Foundation
import AVFoundation

protocol TapeDelegate {
    func callNextBlock() -> BaseTZXBlock?
}


class Z80: CPU {
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
    var SP: UInt16 = 0
    var MEMPTR: UInt16 = 0
    var pagingByte: UInt8 = 0
    var interuptMode = 1
    var screenWriteComplete = true
   // var ram: Array<UInt8> = []
    var screenBuffer = Bitmap(width: 256, height: 192, color: .white)
    let tStatesPerFrame = 69888
    var currentTStates = 0
    var frameEnds = true
    var frameStarted: TimeInterval = Date().timeIntervalSince1970
    var flashCount = 0
    var flashOn = false
    var stackSize = 0
    var pauseProcessor = false
    var clicks: UInt8 = 0
    var header: RegisterModel = RegisterModel()
    
    override init() {
        super.init()
        allocateMemory()
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
        pagingByte = header.ramBankSetting
        delegate?.updateBorder(colour: header.borderColour.border())
        //spareRegister.ld(value: header.borderColour)
        //performOut(port: 0xfe, map: 0x00, source: spareRegister)
        
    }
    
    
       
       func writeRAMBanks(dataModel: [[UInt8]]){
   print("Writing nothing to 128K RAM....")
       }
    
    func writeRAM(dataModel: Array<UInt8>, startAddress: Int = 0){
print("Writing nothing to RAM....")
    }
    
    func renderFrame(){

    }
    
    func blitScreen(){
    }
    
    func performIn(port: UInt8, map: UInt8, destination: Register){
       
    }
    
    func performOut(port: UInt8, map: UInt8, source: Register) {
       
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
