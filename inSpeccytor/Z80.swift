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
    static var F: Register = Register()
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
    
    init() {
        ram = Array(repeating: 0, count: 65536)
        A.byteValue = a()
        Z80.F.byteValue = f()
        bc().setPairs(h: b(), l: c())
        de().setPairs(h: d(), l: e())
        hl().setPairs(h: h(), l: l())
        af().setAF(h: A)
        iy().ld(value: 23610)
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
    
    func pc() -> UInt16{
         return PC
    }
    
    func sp() -> UInt16{
         return SP
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
        exchange(working: AF, spare: AF2)
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
        PC = UInt16(header.registerPC)
        SP = UInt16(header.registerSP)
        ix().ld(value: UInt16(header.registerIX))
        iy().ld(value: UInt16(header.registerIY))
        
        af2().high.ld(value: UInt8(header.registerA2))
        af2().low.ld(value: UInt8(header.registerF2))
        bc2().ld(value: UInt16(header.registerBC2))
        de2().ld(value: UInt16(header.registerDE2))
        hl2().ld(value: UInt16(header.registerHL2))
        
    }
    
    func writeRAM(dataModel: Array<CodeByteModel>, ignoreHeader: Bool, startAddress: Int = 0){
        print ("Starting Ram size = \(ram.count)")
        print ("Ram Model size = \(dataModel.count)")
        var count = startAddress
        dataModel.forEach { byte in
          //  if (!ignoreHeader || byte.lineNumber > 100){
               // ram.append(UInt8(byte.intValue))
            ram[count] = UInt8(byte.intValue)
            count += 1
//            } else {
//                print("Ignoring line \(byte.lineNumber)")
//            }
        }
        print ("Ram size = \(ram.count)")
    }
    
    func renderFrame(){
     //   print("Flash is \(flashOn) - \(flashCount)")
        flashCount += 1
        if (flashCount >= 16){
            flashCount = 0
            flashOn = !flashOn
        }
      //  print("Attempting to Render")



        DispatchQueue.main.sync {

            self.blitMeAScreen()
        //    print("Rendering")
            self.delegate?.updateView(bitmap: self.screenBuffer)
        }
        frameEnds = true
    }
    
    func blitMeAScreen(){
        screenBuffer.setAttributes(bytes: ram[22528...23295], flashing: flashOn)
       screenBuffer.blit(bytes: ram[16384...22527])
    }
    
    func process() {
        currentTStates = 0
        PC = 0
        while true {
            if (!frameEnds) {
                
                let byte = ram[Int(PC)]
                print("Processing line \(PC) (\(String(PC, radix: 16).padded(size: 4))) - \(String(byte, radix: 16))")
                opCode(byte: byte)

                
            } else {
                let time = Date().timeIntervalSince1970
                if (frameStarted + 0.02 <= time){
                    frameStarted = time
                    frameEnds = false
                }
            }
        }
        
        
        
//        pc().ld(value: 0)
//        let ops = OpCodeDefs()
//        while pc().value() < 65540 {
//            let count = pc().value()
//            let opCd = ram[Int(count)]
//
//            var code = ops.opCode(code: String(opCd, radix: 16).padded())
//
//            if code.isPreCode {
//                let opCd2 = ram[Int(count+1)]
//                code = ops.opCode(code: "\(code.value)\(String(opCd2, radix: 16).padded())")
//                pc().ld(value: UInt(count) + 1)
//            }
//            print("\(count) - \(code.code)")
//            pc().ld(value: UInt(count) + UInt(code.length))
//            if (pc().value() >= 65535){
//                pc().ld(value: 0)
//                a().ld(value: a().value() + 1)
//            }
//        }
    }
    
    func instructionComplete(states: Int, length: UInt16 = 1) {
        currentTStates += states
        PC = PC &+ length
        if currentTStates >= tStatesPerFrame {
            currentTStates = 0
            renderFrame()
        }
    }
    
    func decRam(location: Int){
        ram[location] = ram[location] &- 1
    }
    
    func incRam(location: Int){
        ram[location] = ram[location] &+ 1
    }
    
    func relativeJump(twos: UInt8) {
        let subt = twos.isSet(bit: 7)
        let comp = twos.twosCompliment()
        if subt{
            PC = PC &- UInt16(comp)
        } else {
        PC = PC &+ UInt16(comp)
        }
        print ("TC of \(twos) = \(subt ? "-" :  "")\(comp)")
    }
    
    
    
    func iYOffset(twos: UInt8) -> UInt16 {
        let subt = twos.isSet(bit: 7)
        let comp = twos.twosCompliment()
        if subt{
        print ("IY TC of \(twos) = -\(comp)")
            return iy().value() &- UInt16(comp)
        } else {
    print ("IY TC of \(twos) = \(comp)")
            return iy().value() &+ UInt16(comp)
        }
    }
    
}
