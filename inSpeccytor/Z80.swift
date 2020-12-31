//
//  Z80.swift
//  inSpeccytor
//
//  Created by Mike Hall on 18/12/2020.
//

import Foundation

protocol Z80Delegate {
    func updateView(bitmap: Bitmap?)
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
    var R: Register = Register()
    
    var PC: UInt16 = 0
    var SP: UInt16 = 0
    
    var interuptMode = 1
    
    var screenWriteComplete = true
    
    var ram: Array<UInt8> = []
    
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
    
    init() {
        ram = Array(repeating: 0, count: 65536)
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
        bc().ld(value: 1257)
        print("B: \(b())")
        print("C: \(c())")
        dR().ld(value: 12)
        print("DC: \(de().value())")
        print("A: \(a()) (pre add)")
        aR().add(diff: 50)
        print("A: \(a()) (post add)")
        Z80.F.ld(value: 255)
        print("F: \(Z80.F.value()) (pre clear)")
        //Z80.F.clearBit(bit: 2)
        Z80.F.byteValue.set(bit: Flag.ZERO, value: false)
        print("F: \(Z80.F.value()) (post clear)")
        Z80.F.byteValue.set(bit: Flag.ZERO, value: true)
        print("F: \(Z80.F.value()) (post post clear)")
        print ("twos of 250 = \(UInt8(250).twosCompliment())")
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
        aR().ld(value: UInt8(header.registerA))
        Z80.fR().ld(value: UInt8(header.registerF))
        bc().ld(value: UInt16(header.registerBC))
        de().ld(value: UInt16(header.registerDE))
        hl().ld(value: UInt16(header.registerHL))
        

        SP = UInt16(header.registerSP)
        ret()
       // PC = 0x9a2d  //UInt16(header.registerPC)
        ix().ld(value: UInt16(header.registerIX))
        iy().ld(value: UInt16(header.registerIY))
        
        af2().high.ld(value: UInt8(header.registerA2))
        af2().low.ld(value: UInt8(header.registerF2))
        bc2().ld(value: UInt16(header.registerBC2))
        de2().ld(value: UInt16(header.registerDE2))
        hl2().ld(value: UInt16(header.registerHL2))
        
    }
    
    func writeRAM(dataModel: Array<CodeByteModel>, ignoreHeader: Bool, startAddress: Int = 0){
        var count = startAddress
        dataModel.forEach { byte in
            ram[count] = UInt8(byte.intValue)
            count += 1
        }
    }
    
    func renderFrame(){
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
    
    func process() {
        currentTStates = 0
        var canLog = false
        var myCount = 0
       // PC = 49999
        while true {
            if (!frameEnds) {
                if (shouldRunInterupt){
                    push(value: PC)
                    switch interuptMode {
                    case 0:
                        PC = 0x0066
                    case 1:
                        PC = 0x0038
                    default:
                        PC = UInt16(I.byteValue) * 256 // TODO: This needs to react to a low byte from a peripheral occasionally?
                    }
                    halt = false
                    shouldRunInterupt = false
                }
                    if (halt){
                        instructionComplete(states: 4, length: 0)
                        halt = false
                    } else {
                let byte = ram[Int(PC)]
      //                  print("Processing line \(PC) (\(String(PC, radix: 16).padded(size: 4))) - \(String(byte, radix: 16)) - hl: \(hl().value())"  )// - a: \(a()) - b: \(b())")
                        
 //  print("Processing line \(String(PC, radix: 16)) - \(String(byte, radix: 16)) - hl: \(hl().value()) - b: \(b())"  ) //- SP: \(SP)"  )// - a: \(a()) - b: \(b())")   //  ")//
                        
    
                        let executed = PC
 //                      print("Processing line \(String(PC, radix: 16)) - \(String(byte, radix: 16))")
//                        if (executed == 0x0c4c){
//                            print("Executing....")
//
//                        }
  //                         print("\(String(executed, radix: 16))")
          opCode(byte: byte)
        
                        //                       opCode(byte: 3)
 //                      print("\(String(executed, radix: 16))")

//                        print("PC: \(String(executed, radix:16)) a: \(String(a(), radix: 16)) F: \(String(f(), radix: 16)) (\(String(f(), radix: 2))) HL: \(String(HL.value(), radix: 16))  BC: \(String(BC.value(), radix: 16)) DE: \(String(DE.value(), radix: 16)) HL2: \(String(HL2.value(), radix: 16)) BC2: \(String(BC2.value(), radix: 16)) DE2: \(String(DE2.value(), radix: 16))")
//                        if (canLog){
//                        print("PC: \(String(executed, radix:16)) Next: \(String(PC, radix:16)) Opcode: \(String(byte, radix:16)) A: \(String(a(), radix: 16)) F: \(String(f(), radix: 16)) (\(String(f(), radix: 2))) HL: \(String(HL.value(), radix: 16))  BC: \(String(BC.value(), radix: 16)) DE: \(String(DE.value(), radix: 16))")
//                        }
//                        if (PC == 0x0010 && a() > 0){
//                            canLog = true
//                                   print("....... \(String(UnicodeScalar(a()))) .........")
//                                }
    //                    ..                     print(".")
                }
                
                if currentTStates >= tStatesPerFrame {
                    currentTStates = 0
                    renderFrame()
  //                  print("Rendering")
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
//        if currentTStates >= tStatesPerFrame {
//            currentTStates = 0
//            renderFrame()
//        }
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
  //      print ("PC: \(String(PC, radix:16)) Pushing \(value) (l:\(value.lowBit()) h:\(value.highBit())) to stack position \(SP) (\(String(SP, radix: 16)) - Stacksize:\(stackSize)")
    }
    
    func pop() -> UInt16 {
  //      if (stackSize > 0){
        let value = fetchRamWord(location: SP)
            stackSize -= 1
   //     print ("PC: \(String(PC, radix:16)) Popping \(value) (l:\(value.lowBit()) h:\(value.highBit())) from stack position \(SP) (\(String(SP, radix: 16)) - Stacksize:\(stackSize)")
        SP = SP &+ 2
        return value
//        }
//        else {
//            print("Stack discrepancy - more pops than pushes!")
//            return 0
//        }
    }
    
    func ret(){
        PC = pop()
    }
    
    func decRam(location: Int){
        let oldValue = ram[location]
        ldRam(location: Int(location), value: ram[location] &- 1)
        ram[location].s53()
        Z80.F.byteValue.set(bit: Flag.ZERO, value: ram[location] == 0)
        Z80.F.byteValue.set(bit: Flag.OVERFLOW, value: oldValue.isSet(bit: 7) != ram[location].isSet(bit: 7))
        Z80.F.byteValue.set(bit: Flag.HALF_CARRY, value: oldValue.isSet(bit: 4) != ram[location].isSet(bit: 4))
        Z80.F.byteValue.set(bit: Flag.SUBTRACT)
    }
    
    func incRam(location: Int){
        let oldValue = ram[location]
        ldRam(location: Int(location), value: ram[location] &+ 1)
        ram[location].s53()
        Z80.F.byteValue.set(bit: Flag.ZERO, value: ram[location] == 0)
        Z80.F.byteValue.set(bit: Flag.OVERFLOW, value: oldValue.isSet(bit: 7) != ram[location].isSet(bit: 7))
        Z80.F.byteValue.set(bit: Flag.HALF_CARRY, value: oldValue.isSet(bit: 4) != ram[location].isSet(bit: 4))
        Z80.F.byteValue.clear(bit: Flag.SUBTRACT)
    }
    
    func ldRam(location: Int, value: UInt8){
//        if (location < 0x4000){
//            print("location \(location) is being changed, that's not right!")
//        } else {
        ram[location] = value
//        }
    }
    
    func ldRam(location: Int, value: UInt16){
        ldRam(location: location, value: value.lowBit())
        ldRam(location: location &+ 1, value: value.highBit())
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
        let subt = twos.isSet(bit: 7)
        let comp = twos.twosCompliment()
        if subt{
            PC = PC &- UInt16(comp)
        } else {
        PC = PC &+ UInt16(twos)
        }
//        print ("TC of \(twos) = \(subt ? "-" :  "")\(comp)")
    }
    
    
    
    
    func iYOffset(twos: UInt8) -> UInt16 {
        let subt = twos.isSet(bit: 7)
        let comp = twos.twosCompliment()
        if subt{
//        print ("IY TC of \(twos) = -\(comp)")
            return iy().value() &- UInt16(comp)
        } else {
//    print ("IY TC of \(twos) = \(comp)")
            return iy().value() &+ UInt16(comp)
        }
    }
    
}
