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
    var R: Register = Register()
    
    var PC: RegisterPair = RegisterPair()
    var SP: RegisterPair = RegisterPair()
    
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
        af().setAF(h: A)
    }
    
    func accumilator() -> Accumilator{
         return A
    }
    
    static func flag() -> Register{
     return F
    }
    
    func a() -> Accumilator{
         return A
    }
    
    static func f() -> Register{
         return F
    }
    
    func h() -> Register{
         return HL.high
    }
    
    func l() -> Register{
         return HL.low
    }
    
    func b() -> Register{
         return BC.high
    }
    
    func c() -> Register{
         return BC.low
    }
    
    func d() -> Register{
         return DE.high
    }
    
    func e() -> Register{
         return DE.low
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
    
    func pc() -> RegisterPair{
         return PC
    }
    
    func sp() -> RegisterPair{
         return SP
    }
    
    func testRegisters(){
        bc().ld(value: 1257)
        print("B: \(b().value())")
        print("C: \(c().value())")
        d().ld(value: 12)
        print("DC: \(de().value())")
        print("A: \(a().value()) (pre add)")
        a().add(diff: 50)
        print("A: \(a().value()) (post add)")
        Z80.F.ld(value: 15)
        print("F: \(Z80.F.value()) (pre clear)")
        Z80.F.clearBit(bit: 2)
        print("F: \(Z80.F.value()) (post clear)")
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
        a().ld(value: header.registerA)
        Z80.f().ld(value: header.registerF)
        bc().ld(value: UInt(header.registerBC))
        de().ld(value: UInt(header.registerDE))
        hl().ld(value: UInt(header.registerHL))
        pc().ld(value: UInt(header.registerPC))
        sp().ld(value: UInt(header.registerSP))
        ix().ld(value: UInt(header.registerIX))
        iy().ld(value: UInt(header.registerIY))
        
        af2().high.ld(value: header.registerA2)
        af2().low.ld(value: header.registerF2)
        bc2().ld(value: UInt(header.registerBC2))
        de2().ld(value: UInt(header.registerDE2))
        hl2().ld(value: UInt(header.registerHL2))
        
    }
    
    func writeRAM(dataModel: Array<CodeByteModel>, ignoreHeader: Bool){
        print ("Starting Ram size = \(ram.count)")
        print ("Ram Model size = \(dataModel.count)")
        dataModel.forEach { byte in
          //  if (!ignoreHeader || byte.lineNumber > 100){
                ram.append(UInt8(byte.intValue))
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
        pc().ld(value: 4565)
        while true {
            if (!frameEnds) {
                            let count = pc().value()
                let bytes = ram[Int(count)]
                opCode(code: opCd)

                
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
    
    func t(states: Int) {
        currentTStates += states
        if currentTStates >= tStatesPerFrame {
            currentTStates = 0
            renderFrame()
        }
    }
    
    func opCode(code: UInt8){
        switch code {
        case 0:
            t(states: 4)
        default:
            print("Unknown code \(code)")
        }
    }
    
    
    func opCode(code: String) {
        switch(code.uppercased()){
         case"00":
            // NOP = 4 TStates
            t(states: 4)
            // returnOpCode(v: code, c: "NOP", m: "No Operation", l: 1)
        // case"01":
            // returnOpCode(v: code, c: "LD BC,$$", m: "Load register pair BC with the value $$", l: 3, t: .DATA)
        // case"02":
            // returnOpCode(v: code, c: "LD (BC),A", m: "Load the contents of the memory address stored in BC with the value of register A", l: 1)
            
        // case"18":
            // returnOpCode(v: code, c: "JR ##", m: "Jump to routine at memory offset 2s $$ (##)", l: 2, e: true, t: .RELATIVE)
            
        // case"21":
            // returnOpCode(v: code, c: "LD HL,$$", m: "Load the register pair HL with the value $$", l: 3, t: .DATA)
            
            
        // case"28":
            // returnOpCode(v: code, c: "JR Z, ##", m: "If the Zero flag is set in register F, jump to routine at memory offset 2s $$ (##)", l: 2, t: .RELATIVE)
            
        // case"3E":
            // returnOpCode(v: code, c: "LD A,$$", m: "Load register A with the value $$", l: 2, t: .DATA)
            
        // case"47":
            // returnOpCode(v: code, c: "LD B,A", m: "Load register B with the value of register A", l: 1)
            
        // case"78":
            // returnOpCode(v: code, c: "LD A,B", m: "Load register A with the value of register B", l: 1)
            
        // case"C3":
            // returnOpCode(v: code, c: "JP $$", m: "Jump to routine at memory location $$", l: 3, e: true, t: .CODE)
            
        // case"CA":
            // returnOpCode(v: code, c: "JP Z, $$", m: "If the Zero flag is set in register F, jump to routine at memory location $$", l: 3, t: .CODE)
        // case"CB":
            // returnOpCode(v: code, c: "PreCode", m: "", l: 0)
            
        // case"DB":
            // returnOpCode(v: code, c: "IN A,(±)", m: "Load register A with an input defined by the current value of A from port $$ (Generally keyboard input) ", l: 2, t: .VALUE)
            
        // case"DD":
            // returnOpCode(v: code, c: "PreCode", m: "", l: 0)
            
        // case"E6":
            // returnOpCode(v: code, c: "AND ±", m: "Update A to only contain bytes set in both A and the value ±", l: 2)
            
        // case"ED":
            // returnOpCode(v: code, c: "PreCode", m: "", l: 0)
            
        // case"FD":
            // returnOpCode(v: code, c: "PreCode", m: "", l: 0)
            
            //DD Op codes
        // case"DD21":
            // returnOpCode(v: code, c: "LD IX,$$", m: "Load the memory location IX with the value $$", l: 3, t: .DATA)
        // case"DD36":
            // returnOpCode(v: code, c: "LD (IX+$1),$2", m: "Load the contents of the memory address stored in (IX + $1) with the value $2", l: 3, t: .DATA)
        // case"03":
        // returnOpCode(v: code, c: "INC BC", m: " ", l: 1)
        // case"04":
        // returnOpCode(v: code, c: "INC B", m: " ", l: 1)
        // case"05":
        // returnOpCode(v: code, c: "DEC B", m: " ", l: 1)
        // case"06":
        // returnOpCode(v: code, c: "LD B,±", m: " ", l: 2)
        // case"07":
        // returnOpCode(v: code, c: "RLC A", m: " ", l: 1)
        // case"08":
        // returnOpCode(v: code, c: "EX AF,AF'", m: " ", l: 1)
        // case"09":
        // returnOpCode(v: code, c: "ADD HL,BC", m: " ", l: 1)
        // case"0A":
        // returnOpCode(v: code, c: "LD A,(BC)", m: " ", l: 1)
        // case"0B":
        // returnOpCode(v: code, c: "DEC BC", m: " ", l: 1)
        // case"0C":
        // returnOpCode(v: code, c: "INC C", m: " ", l: 1)
        // case"0D":
        // returnOpCode(v: code, c: "DEC C", m: " ", l: 1)
        // case"0E":
        // returnOpCode(v: code, c: "LD C,±", m: " ", l: 2)
        // case"0F":
        // returnOpCode(v: code, c: "RRC A", m: " ", l: 1)
        // case"10":
        // returnOpCode(v: code, c: "DJNZ##", m: " ", l: 2, t: .RELATIVE)
        // case"11":
        // returnOpCode(v: code, c: "LD DE,$$", m: " ", l: 3, t: .DATA)
        // case"12":
        // returnOpCode(v: code, c: "LD (DE),A", m: " ", l: 1)
        // case"13":
        // returnOpCode(v: code, c: "INC DE", m: " ", l: 1)
        // case"14":
        // returnOpCode(v: code, c: "INC D", m: " ", l: 1)
        // case"15":
        // returnOpCode(v: code, c: "DEC D", m: " ", l: 1)
        // case"16":
        // returnOpCode(v: code, c: "LD D,±", m: " ", l: 2)
        // case"17":
        // returnOpCode(v: code, c: "RL A", m: " ", l: 1)
        // case"19":
        // returnOpCode(v: code, c: "ADD HL,DE", m: " ", l: 1)
        // case"1A":
        // returnOpCode(v: code, c: "LD A,(DE)", m: " ", l: 1)
        // case"1B":
        // returnOpCode(v: code, c: "DEC DE", m: " ", l: 1)
        // case"1C":
        // returnOpCode(v: code, c: "INC E", m: " ", l: 1)
        // case"1D":
        // returnOpCode(v: code, c: "DEC E", m: " ", l: 1)
        // case"1E":
        // returnOpCode(v: code, c: "LD E,±", m: " ", l: 2)
        // case"1F":
        // returnOpCode(v: code, c: "RRA", m: " ", l: 1)
        // case"20":
        // returnOpCode(v: code, c: "JR NZ, ##", m: "If the Zero flag is not set in register F, jump to routine at memory offset 2s $$ (##)", l: 2, t: .RELATIVE)
        // case"22":
        // returnOpCode(v: code, c: "LD ($$),HL", m: " ", l: 3, t: .DATA)
        // case"23":
        // returnOpCode(v: code, c: "INC HL", m: " ", l: 1)
        // case"24":
        // returnOpCode(v: code, c: "INC H", m: " ", l: 1)
        // case"25":
        // returnOpCode(v: code, c: "DEC H", m: " ", l: 1)
        // case"26":
        // returnOpCode(v: code, c: "LD H,$$", m: " ", l: 2, t: .DATA)
        // case"27":
        // returnOpCode(v: code, c: "DAA", m: " ", l: 1)
        // case"29":
        // returnOpCode(v: code, c: "ADD HL,HL", m: " ", l: 1)
        // case"2A":
        // returnOpCode(v: code, c: "LD HL,($$)", m: " ", l: 3, t: .DATA)
        // case"2B":
        // returnOpCode(v: code, c: "DEC HL", m: " ", l: 1)
        // case"2C":
        // returnOpCode(v: code, c: "INC L", m: " ", l: 1)
        // case"2D":
        // returnOpCode(v: code, c: "DEC L", m: " ", l: 1)
        // case"2E":
        // returnOpCode(v: code, c: "LD L,±", m: " ", l: 2)
        // case"2F":
        // returnOpCode(v: code, c: "CP L", m: " ", l: 1)
        // case"30":
        // returnOpCode(v: code, c: "JR NC, ##", m: "If the Carry flag is not set in register F, jump to routine at memory offset 2s $$ (##)", l: 2, t: .RELATIVE)
        // case"31":
        // returnOpCode(v: code, c: "LD SP,$$", m: " ", l: 3, t: .DATA)
        // case"32":
        // returnOpCode(v: code, c: "LD ($$),A", m: " ", l: 3, t: .DATA)
        // case"33":
        // returnOpCode(v: code, c: "INC SP", m: " ", l: 1)
        // case"34":
        // returnOpCode(v: code, c: "INC (HL)", m: " ", l: 1)
        // case"35":
        // returnOpCode(v: code, c: "DEC (HL)", m: " ", l: 1)
        // case"36":
        // returnOpCode(v: code, c: "LD (HL),$$", m: " ", l: 3, t: .DATA)
        // case"37":
        // returnOpCode(v: code, c: "SCF", m: " ", l: 1)
        // case"38":
        // returnOpCode(v: code, c: "JR C, ##", m: "If the Carry flag is set in register F, jump to routine at memory offset 2s $$ (##)", l: 2, t: .RELATIVE)
        // case"39":
        // returnOpCode(v: code, c: "ADD HL,SP", m: " ", l: 1)
        // case"3A":
        // returnOpCode(v: code, c: "LD A,($$)", m: " ", l: 3, t: .DATA)
        // case"3B":
        // returnOpCode(v: code, c: "DEC SP", m: " ", l: 1)
        // case"3C":
        // returnOpCode(v: code, c: "INC A", m: " ", l: 1)
        // case"3D":
        // returnOpCode(v: code, c: "DEC A", m: " ", l: 1)
        // case"3F":
        // returnOpCode(v: code, c: "CCF", m: " ", l: 1)
        // case"40":
        // returnOpCode(v: code, c: "LD B,B", m: " ", l: 1)
        // case"41":
        // returnOpCode(v: code, c: "LD B,C", m: " ", l: 1)
        // case"42":
        // returnOpCode(v: code, c: "LD B,D", m: " ", l: 1)
        // case"43":
        // returnOpCode(v: code, c: "LD B,E", m: " ", l: 1)
        // case"44":
        // returnOpCode(v: code, c: "LD B,H", m: " ", l: 1)
        // case"45":
        // returnOpCode(v: code, c: "LD B,L", m: " ", l: 1)
        // case"46":
        // returnOpCode(v: code, c: "LD B,(HL)", m: " ", l: 1)
        // case"48":
        // returnOpCode(v: code, c: "LD C,B", m: " ", l: 1)
        // case"49":
        // returnOpCode(v: code, c: "LD C,C", m: " ", l: 1)
        // case"4A":
        // returnOpCode(v: code, c: "LD C,D", m: " ", l: 1)
        // case"4B":
        // returnOpCode(v: code, c: "LD C,E", m: " ", l: 1)
        // case"4C":
        // returnOpCode(v: code, c: "LD C,H", m: " ", l: 1)
        // case"4D":
        // returnOpCode(v: code, c: "LD C,L", m: " ", l: 1)
        // case"4E":
        // returnOpCode(v: code, c: "LD C,(HL)", m: " ", l: 1)
        // case"4F":
        // returnOpCode(v: code, c: "LD C,A", m: " ", l: 1)
        // case"50":
        // returnOpCode(v: code, c: "LD D,B", m: " ", l: 1)
        // case"51":
        // returnOpCode(v: code, c: "LD D,C", m: " ", l: 1)
        // case"52":
        // returnOpCode(v: code, c: "LD D,D", m: " ", l: 1)
        // case"53":
        // returnOpCode(v: code, c: "LD D,E", m: " ", l: 1)
        // case"54":
        // returnOpCode(v: code, c: "LD D,H", m: " ", l: 1)
        // case"55":
        // returnOpCode(v: code, c: "LD D,L", m: " ", l: 1)
        // case"56":
        // returnOpCode(v: code, c: "LD D,(HL)", m: " ", l: 1)
        // case"57":
        // returnOpCode(v: code, c: "LD D,A", m: " ", l: 1)
        // case"58":
        // returnOpCode(v: code, c: "LD E,B", m: " ", l: 1)
        // case"59":
        // returnOpCode(v: code, c: "LD E,C", m: " ", l: 1)
        // case"5A":
        // returnOpCode(v: code, c: "LD E,D", m: " ", l: 1)
        // case"5B":
        // returnOpCode(v: code, c: "LD E,E", m: " ", l: 1)
        // case"5C":
        // returnOpCode(v: code, c: "LD E,H", m: " ", l: 1)
        // case"5D":
        // returnOpCode(v: code, c: "LD E,L", m: " ", l: 1)
        // case"5E":
        // returnOpCode(v: code, c: "LD E,(HL)", m: " ", l: 1)
        // case"5F":
        // returnOpCode(v: code, c: "LD E,A", m: " ", l: 1)
        // case"60":
        // returnOpCode(v: code, c: "LD H,B", m: " ", l: 1)
        // case"61":
        // returnOpCode(v: code, c: "LD H,C", m: " ", l: 1)
        // case"62":
        // returnOpCode(v: code, c: "LD H,D", m: " ", l: 1)
        // case"63":
        // returnOpCode(v: code, c: "LD H,E", m: " ", l: 1)
        // case"64":
        // returnOpCode(v: code, c: "LD H,H", m: " ", l: 1)
        // case"65":
        // returnOpCode(v: code, c: "LD H,L", m: " ", l: 1)
        // case"66":
        // returnOpCode(v: code, c: "LD H,(HL)", m: " ", l: 1)
        // case"67":
        // returnOpCode(v: code, c: "LD H,A", m: " ", l: 1)
        // case"68":
        // returnOpCode(v: code, c: "LD L,B", m: " ", l: 1)
        // case"69":
        // returnOpCode(v: code, c: "LD L,C", m: " ", l: 1)
        // case"6A":
        // returnOpCode(v: code, c: "LD L,D", m: " ", l: 1)
        // case"6B":
        // returnOpCode(v: code, c: "LD L,E", m: " ", l: 1)
        // case"6C":
        // returnOpCode(v: code, c: "LD L,H", m: " ", l: 1)
        // case"6D":
        // returnOpCode(v: code, c: "LD L,L", m: " ", l: 1)
        // case"6E":
        // returnOpCode(v: code, c: "LD L,(HL)", m: " ", l: 1)
        // case"6F":
        // returnOpCode(v: code, c: "LD L,A", m: " ", l: 1)
        // case"70":
        // returnOpCode(v: code, c: "LD (HL),B", m: " ", l: 1)
        // case"71":
        // returnOpCode(v: code, c: "LD (HL),C", m: " ", l: 1)
        // case"72":
        // returnOpCode(v: code, c: "LD (HL),D", m: " ", l: 1)
        // case"73":
        // returnOpCode(v: code, c: "LD (HL),E", m: " ", l: 1)
        // case"74":
        // returnOpCode(v: code, c: "LD (HL),H", m: " ", l: 1)
        // case"75":
        // returnOpCode(v: code, c: "LD (HL),L", m: " ", l: 1)
        // case"76":
        // returnOpCode(v: code, c: "HALT", m: " ", l: 1)
        // case"77":
        // returnOpCode(v: code, c: "LD (HL),A", m: " ", l: 1)
        // case"79":
        // returnOpCode(v: code, c: "LD A,C", m: " ", l: 1)
        // case"7A":
        // returnOpCode(v: code, c: "LD A,D", m: " ", l: 1)
        // case"7B":
        // returnOpCode(v: code, c: "LD A,E", m: " ", l: 1)
        // case"7C":
        // returnOpCode(v: code, c: "LD A,H", m: " ", l: 1)
        // case"7D":
        // returnOpCode(v: code, c: "LD A,L", m: " ", l: 1)
        // case"7E":
        // returnOpCode(v: code, c: "LD A,(HL)", m: " ", l: 1)
        // case"7F":
        // returnOpCode(v: code, c: "LD A,A", m: " ", l: 1)
        // case"80":
        // returnOpCode(v: code, c: "ADD A,B", m: " ", l: 1)
        // case"81":
        // returnOpCode(v: code, c: "ADD A,C", m: " ", l: 1)
        // case"82":
        // returnOpCode(v: code, c: "ADD A,D", m: " ", l: 1)
        // case"83":
        // returnOpCode(v: code, c: "ADD A,E", m: " ", l: 1)
        // case"84":
        // returnOpCode(v: code, c: "ADD A,H", m: " ", l: 1)
        // case"85":
        // returnOpCode(v: code, c: "ADD A,L", m: " ", l: 1)
        // case"86":
        // returnOpCode(v: code, c: "ADD A,(HL)", m: " ", l: 1)
        // case"87":
        // returnOpCode(v: code, c: "ADD A,A", m: " ", l: 1)
        // case"88":
        // returnOpCode(v: code, c: "ADC A,B", m: " ", l: 1)
        // case"89":
        // returnOpCode(v: code, c: "ADC A,C", m: " ", l: 1)
        // case"8A":
        // returnOpCode(v: code, c: "ADC A,D", m: " ", l: 1)
        // case"8B":
        // returnOpCode(v: code, c: "ADC A,E", m: " ", l: 1)
        // case"8C":
        // returnOpCode(v: code, c: "ADC A,H", m: " ", l: 1)
        // case"8D":
        // returnOpCode(v: code, c: "ADC A,L", m: " ", l: 1)
        // case"8E":
        // returnOpCode(v: code, c: "ADC A,(HL)", m: " ", l: 1)
        // case"8F":
        // returnOpCode(v: code, c: "ADC A,A", m: " ", l: 1)
        // case"90":
        // returnOpCode(v: code, c: "SUB A,B", m: " ", l: 1)
        // case"91":
        // returnOpCode(v: code, c: "SUB A,C", m: " ", l: 1)
        // case"92":
        // returnOpCode(v: code, c: "SUB A,D", m: " ", l: 1)
        // case"93":
        // returnOpCode(v: code, c: "SUB A,E", m: " ", l: 1)
        // case"94":
        // returnOpCode(v: code, c: "SUB A,H", m: " ", l: 1)
        // case"95":
        // returnOpCode(v: code, c: "SUB A,L", m: " ", l: 1)
        // case"96":
        // returnOpCode(v: code, c: "SUB A,(HL)", m: " ", l: 1)
        // case"97":
        // returnOpCode(v: code, c: "SUB A,A", m: " ", l: 1)
        // case"98":
        // returnOpCode(v: code, c: "SBC A,B", m: " ", l: 1)
        // case"99":
        // returnOpCode(v: code, c: "SBC A,C", m: " ", l: 1)
        // case"9A":
        // returnOpCode(v: code, c: "SBC A,D", m: " ", l: 1)
        // case"9B":
        // returnOpCode(v: code, c: "SBC A,E", m: " ", l: 1)
        // case"9C":
        // returnOpCode(v: code, c: "SBC A,H", m: " ", l: 1)
        // case"9D":
        // returnOpCode(v: code, c: "SBC A,L", m: " ", l: 1)
        // case"9E":
        // returnOpCode(v: code, c: "SBC A,(HL)", m: " ", l: 1)
        // case"9F":
        // returnOpCode(v: code, c: "SBC A,A", m: " ", l: 1)
        // case"A0":
        // returnOpCode(v: code, c: "AND B", m: " ", l: 1)
        // case"A1":
        // returnOpCode(v: code, c: "AND C", m: " ", l: 1)
        // case"A2":
        // returnOpCode(v: code, c: "AND D", m: " ", l: 1)
        // case"A3":
        // returnOpCode(v: code, c: "AND E", m: " ", l: 1)
        // case"A4":
        // returnOpCode(v: code, c: "AND H", m: " ", l: 1)
        // case"A5":
        // returnOpCode(v: code, c: "AND L", m: " ", l: 1)
        // case"A6":
        // returnOpCode(v: code, c: "AND (HL)", m: " ", l: 1)
        // case"A7":
        // returnOpCode(v: code, c: "AND A", m: " ", l: 1)
        // case"A8":
        // returnOpCode(v: code, c: "XOR B", m: " ", l: 1)
        // case"A9":
        // returnOpCode(v: code, c: "XOR C", m: " ", l: 1)
        // case"AA":
        // returnOpCode(v: code, c: "XOR D", m: " ", l: 1)
        // case"AB":
        // returnOpCode(v: code, c: "XOR E", m: " ", l: 1)
        // case"AC":
        // returnOpCode(v: code, c: "XOR H", m: " ", l: 1)
        // case"AD":
        // returnOpCode(v: code, c: "XOR L", m: " ", l: 1)
        // case"AE":
        // returnOpCode(v: code, c: "XOR (HL)", m: " ", l: 1)
        // case"AF":
        // returnOpCode(v: code, c: "XOR A", m: " ", l: 1)
        // case"B0":
        // returnOpCode(v: code, c: "OR B", m: " ", l: 1)
        // case"B1":
        // returnOpCode(v: code, c: "OR C", m: " ", l: 1)
        // case"B2":
        // returnOpCode(v: code, c: "OR D", m: " ", l: 1)
        // case"B3":
        // returnOpCode(v: code, c: "OR E", m: " ", l: 1)
        // case"B4":
        // returnOpCode(v: code, c: "OR H", m: " ", l: 1)
        // case"B5":
        // returnOpCode(v: code, c: "OR L", m: " ", l: 1)
        // case"B6":
        // returnOpCode(v: code, c: "OR (HL)", m: " ", l: 1)
        // case"B7":
        // returnOpCode(v: code, c: "OR A", m: " ", l: 1)
        // case"B8":
        // returnOpCode(v: code, c: "CP B", m: " ", l: 1)
        // case"B9":
        // returnOpCode(v: code, c: "CP C", m: " ", l: 1)
        // case"BA":
        // returnOpCode(v: code, c: "CP D", m: " ", l: 1)
        // case"BB":
        // returnOpCode(v: code, c: "CP E", m: " ", l: 1)
        // case"BC":
        // returnOpCode(v: code, c: "CP H", m: " ", l: 1)
        // case"BD":
        // returnOpCode(v: code, c: "CP L", m: " ", l: 1)
        // case"BE":
        // returnOpCode(v: code, c: "CP (HL)", m: " ", l: 1)
        // case"BF":
        // returnOpCode(v: code, c: "CP A", m: " ", l: 1)
        // case"C0":
        // returnOpCode(v: code, c: "RET NZ", m: " ", l: 1)
        // case"C1":
        // returnOpCode(v: code, c: "POP BC", m: " ", l: 1)
        // case"C2":
        // returnOpCode(v: code, c: "JP NZ,$$", m: " ", l: 3, t: .CODE)
        // case"C4":
        // returnOpCode(v: code, c: "CALL NZ,$$", m: " ", l: 3, t: .CODE)
        // case"C5":
        // returnOpCode(v: code, c: "PUSH BC", m: " ", l: 1)
        // case"C6":
        // returnOpCode(v: code, c: "ADD A,±", m: " ", l: 2)
        // case"C7":
        // returnOpCode(v: code, c: "RST 0", m: " ", l: 1)
        // case"C8":
            // returnOpCode(v: code, c: "RET Z", m: " ", l: 1)
        // case"C9":
        // returnOpCode(v: code, c: "RET", m: " ", l: 1, e: true)
        // case"CC":
        // returnOpCode(v: code, c: "CALL Z,$$", m: " ", l: 3, t: .CODE)
        // case"CD":
        // returnOpCode(v: code, c: "CALL $$", m: " ", l: 3, t: .CODE)
        // case"CE":
        // returnOpCode(v: code, c: "ADC A,±", m: " ", l: 2)
        // case"CF":
        // returnOpCode(v: code, c: "RST &08", m: " ", l: 1)
        // case"D0":
        // returnOpCode(v: code, c: "RET NC", m: " ", l: 1)
        // case"D1":
        // returnOpCode(v: code, c: "POP DE", m: " ", l: 1)
        // case"D2":
        // returnOpCode(v: code, c: "JP NC,$$", m: " ", l: 3, t: .CODE)
        // case"D3":
        // returnOpCode(v: code, c: "OUT (±),A", m: " ", l: 2)
        // case"D4":
        // returnOpCode(v: code, c: "CALL NC,$$", m: " ", l: 3, t: .CODE)
        // case"D5":
        // returnOpCode(v: code, c: "PUSH DE", m: " ", l: 1)
        // case"D6":
        // returnOpCode(v: code, c: "SUB A,±", m: " ", l: 2)
        // case"D7":
        // returnOpCode(v: code, c: "RST &10", m: " ", l: 1)
        // case"D8":
        // returnOpCode(v: code, c: "RET C", m: " ", l: 1)
        // case"D9":
        // returnOpCode(v: code, c: "EXX", m: " ", l: 1)
        // case"DA":
        // returnOpCode(v: code, c: "JP C,$$", m: " ", l: 3, t: .CODE)
        // case"DC":
        // returnOpCode(v: code, c: "CALL C,$$", m: " ", l: 3, t: .CODE)
        // case"DE":
        // returnOpCode(v: code, c: "SBC A,±", m: " ", l: 2)
        // case"DF":
        // returnOpCode(v: code, c: "RST &18", m: " ", l: 1)
        // case"E0":
        // returnOpCode(v: code, c: "RET PO", m: " ", l: 1)
        // case"E1":
        // returnOpCode(v: code, c: "POP HL", m: " ", l: 1)
        // case"E2":
        // returnOpCode(v: code, c: "JP PO,$$", m: " ", l: 3, t: .CODE)
        // case"E3":
        // returnOpCode(v: code, c: "EX (SP),HL", m: " ", l: 1)
        // case"E4":
        // returnOpCode(v: code, c: "CALL PO,$$", m: " ", l: 3, t: .CODE)
        // case"E5":
        // returnOpCode(v: code, c: "PUSH HL", m: " ", l: 1)
        // case"E7":
        // returnOpCode(v: code, c: "RST &20", m: " ", l: 1)
        // case"E8":
        // returnOpCode(v: code, c: "RET PE", m: " ", l: 1)
        // case"E9":
        // returnOpCode(v: code, c: "JP (HL)", m: " ", l: 1)
        // case"EA":
        // returnOpCode(v: code, c: "JP PE,$$", m: " ", l: 3, t: .CODE)
        // case"EB":
        // returnOpCode(v: code, c: "EX DE,HL", m: " ", l: 1)
        // case"EC":
        // returnOpCode(v: code, c: "CALL PE,$$", m: " ", l: 3, t: .CODE)
        // case"EE":
        // returnOpCode(v: code, c: "XOR ±", m: " ", l: 2)
        // case"EF":
        // returnOpCode(v: code, c: "RST &28", m: " ", l: 1)
        // case"F0":
        // returnOpCode(v: code, c: "RET P", m: " ", l: 1)
        // case"F1":
        // returnOpCode(v: code, c: "POP AF", m: " ", l: 1)
        // case"F2":
        // returnOpCode(v: code, c: "JP P,$$", m: " ", l: 3, t: .CODE)
        // case"F3":
        // returnOpCode(v: code, c: "DI", m: " ", l: 1)
        // case"F4":
        // returnOpCode(v: code, c: "CALL P,$$", m: " ", l: 3, t: .CODE)
        // case"F5":
        // returnOpCode(v: code, c: "PUSH AF", m: " ", l: 1)
        // case"F6":
        // returnOpCode(v: code, c: "OR ±", m: " ", l: 2)
        // case"F7":
        // returnOpCode(v: code, c: "RST &30", m: " ", l: 1)
        // case"F8":
        // returnOpCode(v: code, c: "RET M", m: " ", l: 1)
        // case"F9":
        // returnOpCode(v: code, c: "LD SP,HL", m: " ", l: 1)
        // case"FA":
        // returnOpCode(v: code, c: "JP M,$$", m: " ", l: 3, t: .CODE)
        // case"FB":
        // returnOpCode(v: code, c: "EI", m: " ", l: 1)
        // case"FC":
        // returnOpCode(v: code, c: "CALL M,$$", m: " ", l: 3, t: .CODE)
        // case"FE":
        // returnOpCode(v: code, c: "CP ±", m: " ", l: 2)
        // case"FF":
        // returnOpCode(v: code, c: "RST &38", m: " ", l: 1)
        // case"DD09":
        // returnOpCode(v: code, c: "ADD IX,BC", m: " ", l: 1)
        // case"DD19":
        // returnOpCode(v: code, c: "ADD IX,DE", m: " ", l: 1)
        // case"DD22":
        // returnOpCode(v: code, c: "LD ($$),IX", m: " ", l: 3, t: .DATA)
        // case"DD23":
        // returnOpCode(v: code, c: "INC IX", m: " ", l: 1)
        // case"DD24":
        // returnOpCode(v: code, c: "INC IXH", m: " ", l: 1)
        // case"DD25":
        // returnOpCode(v: code, c: "DEC IXH", m: " ", l: 1)
        // case"DD26":
        // returnOpCode(v: code, c: "LD IXH,±", m: " ", l: 2)
        // case"DD29":
        // returnOpCode(v: code, c: "ADD IX,IX", m: " ", l: 1)
        // case"DD2A":
        // returnOpCode(v: code, c: "LD IX,($$)", m: " ", l: 3, t: .DATA)
        // case"DD2B":
        // returnOpCode(v: code, c: "DEC IX", m: " ", l: 1)
        // case"DD2C":
        // returnOpCode(v: code, c: "INC IXL", m: " ", l: 1)
        // case"DD2D":
        // returnOpCode(v: code, c: "DEC IXL", m: " ", l: 1)
        // case"DD2E":
        // returnOpCode(v: code, c: "LD IXL,±", m: " ", l: 2)
        // case"DD34":
        // returnOpCode(v: code, c: "INC (IX+0)", m: " ", l: 1)
        // case"DD35":
        // returnOpCode(v: code, c: "DEC (IX+0)", m: " ", l: 1)
        // case"DD39":
        // returnOpCode(v: code, c: "ADD IX,SP", m: " ", l: 1)
        // case"DD44":
        // returnOpCode(v: code, c: "LD B,IXH", m: " ", l: 1)
        // case"DD45":
        // returnOpCode(v: code, c: "LD B,IXL", m: " ", l: 1)
        // case"DD46":
        // returnOpCode(v: code, c: "LD B,(IX+0)", m: " ", l: 1)
        // case"DD4C":
        // returnOpCode(v: code, c: "LD C,IXH", m: " ", l: 1)
        // case"DD4D":
        // returnOpCode(v: code, c: "LD C,IXL", m: " ", l: 1)
        // case"DD4E":
        // returnOpCode(v: code, c: "LD C,(IX+0)", m: " ", l: 1)
        // case"DD54":
        // returnOpCode(v: code, c: "LD D,IXH", m: " ", l: 1)
        // case"DD55":
        // returnOpCode(v: code, c: "LD D,IXL", m: " ", l: 1)
        // case"DD56":
        // returnOpCode(v: code, c: "LD D,(IX+0)", m: " ", l: 1)
        // case"DD5C":
        // returnOpCode(v: code, c: "LD E,IXH", m: " ", l: 1)
        // case"DD5D":
        // returnOpCode(v: code, c: "LD E,IXL", m: " ", l: 1)
        // case"DD5E":
        // returnOpCode(v: code, c: "LD E,(IX+0)", m: " ", l: 1)
        // case"DD60":
        // returnOpCode(v: code, c: "LD IXH,B", m: " ", l: 1)
        // case"DD61":
        // returnOpCode(v: code, c: "LD IXH,C", m: " ", l: 1)
        // case"DD62":
        // returnOpCode(v: code, c: "LD IXH,D", m: " ", l: 1)
        // case"DD63":
        // returnOpCode(v: code, c: "LD IXH,E", m: " ", l: 1)
        // case"DD64":
        // returnOpCode(v: code, c: "LD IXH,IXH", m: " ", l: 1)
        // case"DD65":
        // returnOpCode(v: code, c: "LD IXH,IXL", m: " ", l: 1)
        // case"DD66":
        // returnOpCode(v: code, c: "LD H,(IX+0)", m: " ", l: 1)
        // case"DD67":
        // returnOpCode(v: code, c: "LD IXH,A", m: " ", l: 1)
        // case"DD68":
        // returnOpCode(v: code, c: "LD IXL,B", m: " ", l: 1)
        // case"DD69":
        // returnOpCode(v: code, c: "LD IXL,C", m: " ", l: 1)
        // case"DD6A":
        // returnOpCode(v: code, c: "LD IXL,D", m: " ", l: 1)
        // case"DD6B":
        // returnOpCode(v: code, c: "LD IXL,E", m: " ", l: 1)
        // case"DD6C":
        // returnOpCode(v: code, c: "LD IXL,IXH", m: " ", l: 1)
        // case"DD6D":
        // returnOpCode(v: code, c: "LD IXL,IXL", m: " ", l: 1)
        // case"DD6E":
        // returnOpCode(v: code, c: "LD L,(IX+0)", m: " ", l: 1)
        // case"DD6F":
        // returnOpCode(v: code, c: "LD IXL,A", m: " ", l: 1)
        // case"DD70":
        // returnOpCode(v: code, c: "LD (IX+0),B", m: " ", l: 1)
        // case"DD71":
        // returnOpCode(v: code, c: "LD (IX+0),C", m: " ", l: 1)
        // case"DD72":
        // returnOpCode(v: code, c: "LD (IX+0),D", m: " ", l: 1)
        // case"DD73":
        // returnOpCode(v: code, c: "LD (IX+0),E", m: " ", l: 1)
        // case"DD74":
        // returnOpCode(v: code, c: "LD (IX+0),H", m: " ", l: 1)
        // case"DD75":
        // returnOpCode(v: code, c: "LD (IX+0),L", m: " ", l: 1)
        // case"DD77":
        // returnOpCode(v: code, c: "LD (IX+0),A", m: " ", l: 1)
        // case"DD7C":
        // returnOpCode(v: code, c: "LD A,IXH", m: " ", l: 1)
        // case"DD7D":
        // returnOpCode(v: code, c: "LD A,IXL", m: " ", l: 1)
        // case"DD7E":
        // returnOpCode(v: code, c: "LD A,(IX+0)", m: " ", l: 1)
        // case"DD84":
        // returnOpCode(v: code, c: "ADD A,IXH", m: " ", l: 1)
        // case"DD85":
        // returnOpCode(v: code, c: "ADD A,IXL", m: " ", l: 1)
        // case"DD86":
        // returnOpCode(v: code, c: "ADD A,(IX+0)", m: " ", l: 1)
        // case"DD8C":
        // returnOpCode(v: code, c: "ADC A,IXH", m: " ", l: 1)
        // case"DD8D":
        // returnOpCode(v: code, c: "ADC A,IXL", m: " ", l: 1)
        // case"DD8E":
        // returnOpCode(v: code, c: "ADC A,(IX+0)", m: " ", l: 1)
        // case"DD94":
        // returnOpCode(v: code, c: "SUB A,IXH", m: " ", l: 1)
        // case"DD95":
        // returnOpCode(v: code, c: "SUB A,IXL", m: " ", l: 1)
        // case"DD96":
        // returnOpCode(v: code, c: "SUB A,(IX+0)", m: " ", l: 1)
        // case"DD9C":
        // returnOpCode(v: code, c: "SBC A,IXH", m: " ", l: 1)
        // case"DD9D":
        // returnOpCode(v: code, c: "SBC A,IXL", m: " ", l: 1)
        // case"DD9E":
        // returnOpCode(v: code, c: "SBC A,(IX+0)", m: " ", l: 1)
        // case"DDA4":
        // returnOpCode(v: code, c: "AND IXH", m: " ", l: 1)
        // case"DDA5":
        // returnOpCode(v: code, c: "AND IXL", m: " ", l: 1)
        // case"DDA6":
        // returnOpCode(v: code, c: "AND (IX+0)", m: " ", l: 1)
        // case"DDAC":
        // returnOpCode(v: code, c: "XOR IXH", m: " ", l: 1)
        // case"DDAD":
        // returnOpCode(v: code, c: "XOR IXL", m: " ", l: 1)
        // case"DDAE":
        // returnOpCode(v: code, c: "XOR (IX+0)", m: " ", l: 1)
        // case"DDB4":
        // returnOpCode(v: code, c: "OR IXH", m: " ", l: 1)
        // case"DDB5":
        // returnOpCode(v: code, c: "OR IXL", m: " ", l: 1)
        // case"DDB6":
        // returnOpCode(v: code, c: "OR (IX+0)", m: " ", l: 1)
        // case"DDBC":
        // returnOpCode(v: code, c: "CP IXH", m: " ", l: 1)
        // case"DDBD":
        // returnOpCode(v: code, c: "CP IXL", m: " ", l: 1)
        // case"DDBE":
        // returnOpCode(v: code, c: "CP (IX+0)", m: " ", l: 1)
        // case"DDE1":
        // returnOpCode(v: code, c: "POP IX", m: " ", l: 1)
        // case"DDE3":
        // returnOpCode(v: code, c: "EX (SP),IX", m: " ", l: 1)
        // case"DDE5":
        // returnOpCode(v: code, c: "PUSH IX", m: " ", l: 1)
        // case"DDE9":
        // returnOpCode(v: code, c: "JP (IX)", m: " ", l: 1)
        // case"CB00":
        // returnOpCode(v: code, c: "RLC B", m: " ", l: 1)
        // case"CB01":
        // returnOpCode(v: code, c: "RLC C", m: " ", l: 1)
        // case"CB02":
        // returnOpCode(v: code, c: "RLC D", m: " ", l: 1)
        // case"CB03":
        // returnOpCode(v: code, c: "RLC E", m: " ", l: 1)
        // case"CB04":
        // returnOpCode(v: code, c: "RLC H", m: " ", l: 1)
        // case"CB05":
        // returnOpCode(v: code, c: "RLC L", m: " ", l: 1)
        // case"CB06":
        // returnOpCode(v: code, c: "RLC (HL)", m: " ", l: 1)
        // case"CB07":
        // returnOpCode(v: code, c: "RLC A", m: " ", l: 1)
        // case"CB08":
        // returnOpCode(v: code, c: "RRC B", m: " ", l: 1)
        // case"CB09":
        // returnOpCode(v: code, c: "RRC C", m: " ", l: 1)
        // case"CB0A":
        // returnOpCode(v: code, c: "RRC D", m: " ", l: 1)
        // case"CB0B":
        // returnOpCode(v: code, c: "RRC E", m: " ", l: 1)
        // case"CB0C":
        // returnOpCode(v: code, c: "RRC H", m: " ", l: 1)
        // case"CB0D":
        // returnOpCode(v: code, c: "RRC L", m: " ", l: 1)
        // case"CB0E":
        // returnOpCode(v: code, c: "RRC (HL)", m: " ", l: 1)
        // case"CB0F":
        // returnOpCode(v: code, c: "RRC A", m: " ", l: 1)
        // case"CB10":
        // returnOpCode(v: code, c: "RL B", m: " ", l: 1)
        // case"CB11":
        // returnOpCode(v: code, c: "RL C ", m: " ", l: 1)
        // case"CB12":
        // returnOpCode(v: code, c: "RL D", m: " ", l: 1)
        // case"CB13":
        // returnOpCode(v: code, c: "RL E", m: " ", l: 1)
        // case"CB14":
        // returnOpCode(v: code, c: "RL H", m: " ", l: 1)
        // case"CB15":
        // returnOpCode(v: code, c: "RL L", m: " ", l: 1)
        // case"CB16":
        // returnOpCode(v: code, c: "RL (HL)", m: " ", l: 1)
        // case"CB17":
        // returnOpCode(v: code, c: "RL A", m: " ", l: 1)
        // case"CB18":
        // returnOpCode(v: code, c: "RR B", m: " ", l: 1)
        // case"CB19":
        // returnOpCode(v: code, c: "RR C ", m: " ", l: 1)
        // case"CB1A":
        // returnOpCode(v: code, c: "RR D", m: " ", l: 1)
        // case"CB1B":
        // returnOpCode(v: code, c: "RR E", m: " ", l: 1)
        // case"CB1C":
        // returnOpCode(v: code, c: "RR H", m: " ", l: 1)
        // case"CB1D":
        // returnOpCode(v: code, c: "RR L", m: " ", l: 1)
        // case"CB1E":
        // returnOpCode(v: code, c: "RR (HL)", m: " ", l: 1)
        // case"CB1F":
        // returnOpCode(v: code, c: "RR A", m: " ", l: 1)
        // case"CB20":
        // returnOpCode(v: code, c: "SLA B", m: " ", l: 1)
        // case"CB21":
        // returnOpCode(v: code, c: "SLA C", m: " ", l: 1)
        // case"CB22":
        // returnOpCode(v: code, c: "SLA D", m: " ", l: 1)
        // case"CB23":
        // returnOpCode(v: code, c: "SLA E", m: " ", l: 1)
        // case"CB24":
        // returnOpCode(v: code, c: "SLA H", m: " ", l: 1)
        // case"CB25":
        // returnOpCode(v: code, c: "SLA L", m: " ", l: 1)
        // case"CB26":
        // returnOpCode(v: code, c: "SLA (HL)", m: " ", l: 1)
        // case"CB27":
        // returnOpCode(v: code, c: "SLA A", m: " ", l: 1)
        // case"CB28":
        // returnOpCode(v: code, c: "SRA B", m: " ", l: 1)
        // case"CB29":
        // returnOpCode(v: code, c: "SRA C", m: " ", l: 1)
        // case"CB2A":
        // returnOpCode(v: code, c: "SRA D", m: " ", l: 1)
        // case"CB2B":
        // returnOpCode(v: code, c: "SRA E", m: " ", l: 1)
        // case"CB2C":
        // returnOpCode(v: code, c: "SRA H", m: " ", l: 1)
        // case"CB2D":
        // returnOpCode(v: code, c: "SRA L", m: " ", l: 1)
        // case"CB2E":
        // returnOpCode(v: code, c: "SRA (HL)", m: " ", l: 1)
        // case"CB2F":
        // returnOpCode(v: code, c: "SRA A", m: " ", l: 1)
        // case"CB30":
        // returnOpCode(v: code, c: "SLS B", m: " ", l: 1)
        // case"CB31":
        // returnOpCode(v: code, c: "SLS C", m: " ", l: 1)
        // case"CB32":
        // returnOpCode(v: code, c: "SLS D", m: " ", l: 1)
        // case"CB33":
        // returnOpCode(v: code, c: "SLS E", m: " ", l: 1)
        // case"CB34":
        // returnOpCode(v: code, c: "SLS H", m: " ", l: 1)
        // case"CB35":
        // returnOpCode(v: code, c: "SLS L", m: " ", l: 1)
        // case"CB36":
        // returnOpCode(v: code, c: "SLS (HL)", m: " ", l: 1)
        // case"CB37":
        // returnOpCode(v: code, c: "SLS A", m: " ", l: 1)
        // case"CB38":
        // returnOpCode(v: code, c: "SRL B", m: " ", l: 1)
        // case"CB39":
        // returnOpCode(v: code, c: "SRL C", m: " ", l: 1)
        // case"CB3A":
        // returnOpCode(v: code, c: "SRL D", m: " ", l: 1)
        // case"CB3B":
        // returnOpCode(v: code, c: "SRL E", m: " ", l: 1)
        // case"CB3C":
        // returnOpCode(v: code, c: "SRL H", m: " ", l: 1)
        // case"CB3D":
        // returnOpCode(v: code, c: "SRL L", m: " ", l: 1)
        // case"CB3E":
        // returnOpCode(v: code, c: "SRL (HL)", m: " ", l: 1)
        // case"CB3F":
        // returnOpCode(v: code, c: "SRL A", m: " ", l: 1)
        // case"CB40":
        // returnOpCode(v: code, c: "BIT 0,B", m: " ", l: 1)
        // case"CB41":
        // returnOpCode(v: code, c: "BIT 0,C", m: " ", l: 1)
        // case"CB42":
        // returnOpCode(v: code, c: "BIT 0,D", m: " ", l: 1)
        // case"CB43":
        // returnOpCode(v: code, c: "BIT 0,E", m: " ", l: 1)
        // case"CB44":
        // returnOpCode(v: code, c: "BIT 0,H", m: " ", l: 1)
        // case"CB45":
        // returnOpCode(v: code, c: "BIT 0,L", m: " ", l: 1)
        // case"CB46":
        // returnOpCode(v: code, c: "BIT 0,(HL)", m: " ", l: 1)
        // case"CB47":
        // returnOpCode(v: code, c: "BIT 0,A", m: " ", l: 1)
        // case"CB48":
        // returnOpCode(v: code, c: "BIT 1,B", m: " ", l: 1)
        // case"CB49":
        // returnOpCode(v: code, c: "BIT 1,C", m: " ", l: 1)
        // case"CB4A":
        // returnOpCode(v: code, c: "BIT 1,D", m: " ", l: 1)
        // case"CB4B":
        // returnOpCode(v: code, c: "BIT 1,E", m: " ", l: 1)
        // case"CB4C":
        // returnOpCode(v: code, c: "BIT 1,H", m: " ", l: 1)
        // case"CB4D":
        // returnOpCode(v: code, c: "BIT 1,L", m: " ", l: 1)
        // case"CB4E":
        // returnOpCode(v: code, c: "BIT 1,(HL)", m: " ", l: 1)
        // case"CB4F":
        // returnOpCode(v: code, c: "BIT 1,A", m: " ", l: 1)
        // case"CB50":
        // returnOpCode(v: code, c: "BIT 2,B", m: " ", l: 1)
        // case"CB51":
        // returnOpCode(v: code, c: "BIT 2,C", m: " ", l: 1)
        // case"CB52":
        // returnOpCode(v: code, c: "BIT 2,D", m: " ", l: 1)
        // case"CB53":
        // returnOpCode(v: code, c: "BIT 2,E", m: " ", l: 1)
        // case"CB54":
        // returnOpCode(v: code, c: "BIT 2,H", m: " ", l: 1)
        // case"CB55":
        // returnOpCode(v: code, c: "BIT 2,L", m: " ", l: 1)
        // case"CB56":
        // returnOpCode(v: code, c: "BIT 2,(HL)", m: " ", l: 1)
        // case"CB57":
        // returnOpCode(v: code, c: "BIT 2,A", m: " ", l: 1)
        // case"CB58":
        // returnOpCode(v: code, c: "BIT 3,B", m: " ", l: 1)
        // case"CB59":
        // returnOpCode(v: code, c: "BIT 3,C", m: " ", l: 1)
        // case"CB5A":
        // returnOpCode(v: code, c: "BIT 3,D", m: " ", l: 1)
        // case"CB5B":
        // returnOpCode(v: code, c: "BIT 3,E", m: " ", l: 1)
        // case"CB5C":
        // returnOpCode(v: code, c: "BIT 3,H", m: " ", l: 1)
        // case"CB5D":
        // returnOpCode(v: code, c: "BIT 3,L", m: " ", l: 1)
        // case"CB5E":
        // returnOpCode(v: code, c: "BIT 3,(HL)", m: " ", l: 1)
        // case"CB5F":
        // returnOpCode(v: code, c: "BIT 3,A", m: " ", l: 1)
        // case"CB60":
        // returnOpCode(v: code, c: "BIT 4,B", m: " ", l: 1)
        // case"CB61":
        // returnOpCode(v: code, c: "BIT 4,C", m: " ", l: 1)
        // case"CB62":
        // returnOpCode(v: code, c: "BIT 4,D", m: " ", l: 1)
        // case"CB63":
        // returnOpCode(v: code, c: "BIT 4,E", m: " ", l: 1)
        // case"CB64":
        // returnOpCode(v: code, c: "BIT 4,H", m: " ", l: 1)
        // case"CB65":
        // returnOpCode(v: code, c: "BIT 4,L", m: " ", l: 1)
        // case"CB66":
        // returnOpCode(v: code, c: "BIT 4,(HL)", m: " ", l: 1)
        // case"CB67":
        // returnOpCode(v: code, c: "BIT 4,A", m: " ", l: 1)
        // case"CB68":
        // returnOpCode(v: code, c: "BIT 5,B", m: " ", l: 1)
        // case"CB69":
        // returnOpCode(v: code, c: "BIT 5,C", m: " ", l: 1)
        // case"CB6A":
        // returnOpCode(v: code, c: "BIT 5,D", m: " ", l: 1)
        // case"CB6B":
        // returnOpCode(v: code, c: "BIT 5,E", m: " ", l: 1)
        // case"CB6C":
        // returnOpCode(v: code, c: "BIT 5,H", m: " ", l: 1)
        // case"CB6D":
        // returnOpCode(v: code, c: "BIT 5,L", m: " ", l: 1)
        // case"CB6E":
        // returnOpCode(v: code, c: "BIT 5,(HL)", m: " ", l: 1)
        // case"CB6F":
        // returnOpCode(v: code, c: "BIT 5,A", m: " ", l: 1)
        // case"CB70":
        // returnOpCode(v: code, c: "BIT 6,B", m: " ", l: 1)
        // case"CB71":
        // returnOpCode(v: code, c: "BIT 6,C", m: " ", l: 1)
        // case"CB72":
        // returnOpCode(v: code, c: "BIT 6,D", m: " ", l: 1)
        // case"CB73":
        // returnOpCode(v: code, c: "BIT 6,E", m: " ", l: 1)
        // case"CB74":
        // returnOpCode(v: code, c: "BIT 6,H", m: " ", l: 1)
        // case"CB75":
        // returnOpCode(v: code, c: "BIT 6,L", m: " ", l: 1)
        // case"CB76":
        // returnOpCode(v: code, c: "BIT 6,(HL)", m: " ", l: 1)
        // case"CB77":
        // returnOpCode(v: code, c: "BIT 6,A", m: " ", l: 1)
        // case"CB78":
        // returnOpCode(v: code, c: "BIT 7,B", m: " ", l: 1)
        // case"CB79":
        // returnOpCode(v: code, c: "BIT 7,C", m: " ", l: 1)
        // case"CB7A":
        // returnOpCode(v: code, c: "BIT 7,D", m: " ", l: 1)
        // case"CB7B":
        // returnOpCode(v: code, c: "BIT 7,E", m: " ", l: 1)
        // case"CB7C":
        // returnOpCode(v: code, c: "BIT 7,H", m: " ", l: 1)
        // case"CB7D":
        // returnOpCode(v: code, c: "BIT 7,L", m: " ", l: 1)
        // case"CB7E":
        // returnOpCode(v: code, c: "BIT 7,(HL)", m: " ", l: 1)
        // case"CB7F":
        // returnOpCode(v: code, c: "BIT 7,A", m: " ", l: 1)
        // case"CB80":
        // returnOpCode(v: code, c: "RES 0,B", m: " ", l: 1)
        // case"CB81":
        // returnOpCode(v: code, c: "RES 0,C", m: " ", l: 1)
        // case"CB82":
        // returnOpCode(v: code, c: "RES 0,D", m: " ", l: 1)
        // case"CB83":
        // returnOpCode(v: code, c: "RES 0,E", m: " ", l: 1)
        // case"CB84":
        // returnOpCode(v: code, c: "RES 0,H", m: " ", l: 1)
        // case"CB85":
        // returnOpCode(v: code, c: "RES 0,L", m: " ", l: 1)
        // case"CB86":
        // returnOpCode(v: code, c: "RES 0,(HL)", m: " ", l: 1)
        // case"CB87":
        // returnOpCode(v: code, c: "RES 0,A", m: " ", l: 1)
        // case"CB88":
        // returnOpCode(v: code, c: "RES 1,B", m: " ", l: 1)
        // case"CB89":
        // returnOpCode(v: code, c: "RES 1,C", m: " ", l: 1)
        // case"CB8A":
        // returnOpCode(v: code, c: "RES 1,D", m: " ", l: 1)
        // case"CB8B":
        // returnOpCode(v: code, c: "RES 1,E", m: " ", l: 1)
        // case"CB8C":
        // returnOpCode(v: code, c: "RES 1,H", m: " ", l: 1)
        // case"CB8D":
        // returnOpCode(v: code, c: "RES 1,L", m: " ", l: 1)
        // case"CB8E":
        // returnOpCode(v: code, c: "RES 1,(HL)", m: " ", l: 1)
        // case"CB8F":
        // returnOpCode(v: code, c: "RES 1,A", m: " ", l: 1)
        // case"CB90":
        // returnOpCode(v: code, c: "RES 2,B", m: " ", l: 1)
        // case"CB91":
        // returnOpCode(v: code, c: "RES 2,C", m: " ", l: 1)
        // case"CB92":
        // returnOpCode(v: code, c: "RES 2,D", m: " ", l: 1)
        // case"CB93":
        // returnOpCode(v: code, c: "RES 2,E", m: " ", l: 1)
        // case"CB94":
        // returnOpCode(v: code, c: "RES 2,H", m: " ", l: 1)
        // case"CB95":
        // returnOpCode(v: code, c: "RES 2,L", m: " ", l: 1)
        // case"CB96":
        // returnOpCode(v: code, c: "RES 2,(HL)", m: " ", l: 1)
        // case"CB97":
        // returnOpCode(v: code, c: "RES 2,A", m: " ", l: 1)
        // case"CB98":
        // returnOpCode(v: code, c: "RES 3,B", m: " ", l: 1)
        // case"CB99":
        // returnOpCode(v: code, c: "RES 3,C", m: " ", l: 1)
        // case"CB9A":
        // returnOpCode(v: code, c: "RES 3,D", m: " ", l: 1)
        // case"CB9B":
        // returnOpCode(v: code, c: "RES 3,E", m: " ", l: 1)
        // case"CB9C":
        // returnOpCode(v: code, c: "RES 3,H", m: " ", l: 1)
        // case"CB9D":
        // returnOpCode(v: code, c: "RES 3,L", m: " ", l: 1)
        // case"CB9E":
        // returnOpCode(v: code, c: "RES 3,(HL)", m: " ", l: 1)
        // case"CB9F":
        // returnOpCode(v: code, c: "RES 3,A", m: " ", l: 1)
        // case"CBA0":
        // returnOpCode(v: code, c: "RES 4,B", m: " ", l: 1)
        // case"CBA1":
        // returnOpCode(v: code, c: "RES 4,C", m: " ", l: 1)
        // case"CBA2":
        // returnOpCode(v: code, c: "RES 4,D", m: " ", l: 1)
        // case"CBA3":
        // returnOpCode(v: code, c: "RES 4,E", m: " ", l: 1)
        // case"CBA4":
        // returnOpCode(v: code, c: "RES 4,H", m: " ", l: 1)
        // case"CBA5":
        // returnOpCode(v: code, c: "RES 4,L", m: " ", l: 1)
        // case"CBA6":
        // returnOpCode(v: code, c: "RES 4,(HL)", m: " ", l: 1)
        // case"CBA7":
        // returnOpCode(v: code, c: "RES 4,A", m: " ", l: 1)
        // case"CBA8":
        // returnOpCode(v: code, c: "RES 5,B", m: " ", l: 1)
        // case"CBA9":
        // returnOpCode(v: code, c: "RES 5,C", m: " ", l: 1)
        // case"CBAA":
        // returnOpCode(v: code, c: "RES 5,D", m: " ", l: 1)
        // case"CBAB":
        // returnOpCode(v: code, c: "RES 5,E", m: " ", l: 1)
        // case"CBAC":
        // returnOpCode(v: code, c: "RES 5,H", m: " ", l: 1)
        // case"CBAD":
        // returnOpCode(v: code, c: "RES 5,L", m: " ", l: 1)
        // case"CBAE":
        // returnOpCode(v: code, c: "RES 5,(HL)", m: " ", l: 1)
        // case"CBAF":
        // returnOpCode(v: code, c: "RES 5,A", m: " ", l: 1)
        // case"CBB0":
        // returnOpCode(v: code, c: "RES 6,B", m: " ", l: 1)
        // case"CBB1":
        // returnOpCode(v: code, c: "RES 6,C", m: " ", l: 1)
        // case"CBB2":
        // returnOpCode(v: code, c: "RES 6,D", m: " ", l: 1)
        // case"CBB3":
        // returnOpCode(v: code, c: "RES 6,E", m: " ", l: 1)
        // case"CBB4":
        // returnOpCode(v: code, c: "RES 6,H", m: " ", l: 1)
        // case"CBB5":
        // returnOpCode(v: code, c: "RES 6,L", m: " ", l: 1)
        // case"CBB6":
        // returnOpCode(v: code, c: "RES 6,(HL)", m: " ", l: 1)
        // case"CBB7":
        // returnOpCode(v: code, c: "RES 6,A", m: " ", l: 1)
        // case"CBB8":
        // returnOpCode(v: code, c: "RES 7,B", m: " ", l: 1)
        // case"CBB9":
        // returnOpCode(v: code, c: "RES 7,C", m: " ", l: 1)
        // case"CBBA":
        // returnOpCode(v: code, c: "RES 7,D", m: " ", l: 1)
        // case"CBBB":
        // returnOpCode(v: code, c: "RES 7,E", m: " ", l: 1)
        // case"CBBC":
        // returnOpCode(v: code, c: "RES 7,H", m: " ", l: 1)
        // case"CBBD":
        // returnOpCode(v: code, c: "RES 7,L", m: " ", l: 1)
        // case"CBBE":
        // returnOpCode(v: code, c: "RES 7,(HL)", m: " ", l: 1)
        // case"CBBF":
        // returnOpCode(v: code, c: "RES 7,A", m: " ", l: 1)
        // case"CBC0":
        // returnOpCode(v: code, c: "SET 0,B", m: " ", l: 1)
        // case"CBC1":
        // returnOpCode(v: code, c: "SET 0,C", m: " ", l: 1)
        // case"CBC2":
        // returnOpCode(v: code, c: "SET 0,D", m: " ", l: 1)
        // case"CBC3":
        // returnOpCode(v: code, c: "SET 0,E", m: " ", l: 1)
        // case"CBC4":
        // returnOpCode(v: code, c: "SET 0,H", m: " ", l: 1)
        // case"CBC5":
        // returnOpCode(v: code, c: "SET 0,L", m: " ", l: 1)
        // case"CBC6":
        // returnOpCode(v: code, c: "SET 0,(HL)", m: " ", l: 1)
        // case"CBC7":
        // returnOpCode(v: code, c: "SET 0,A", m: " ", l: 1)
        // case"CBC8":
        // returnOpCode(v: code, c: "SET 1,B", m: " ", l: 1)
        // case"CBC9":
        // returnOpCode(v: code, c: "SET 1,C", m: " ", l: 1)
        // case"CBCA":
        // returnOpCode(v: code, c: "SET 1,D", m: " ", l: 1)
        // case"CBCB":
        // returnOpCode(v: code, c: "SET 1,E", m: " ", l: 1)
        // case"CBCC":
        // returnOpCode(v: code, c: "SET 1,H", m: " ", l: 1)
        // case"CBCD":
        // returnOpCode(v: code, c: "SET 1,L", m: " ", l: 1)
        // case"CBCE":
        // returnOpCode(v: code, c: "SET 1,(HL)", m: " ", l: 1)
        // case"CBCF":
        // returnOpCode(v: code, c: "SET 1,A", m: " ", l: 1)
        // case"CBD0":
        // returnOpCode(v: code, c: "SET 2,B", m: " ", l: 1)
        // case"CBD1":
        // returnOpCode(v: code, c: "SET 2,C", m: " ", l: 1)
        // case"CBD2":
        // returnOpCode(v: code, c: "SET 2,D", m: " ", l: 1)
        // case"CBD3":
        // returnOpCode(v: code, c: "SET 2,E", m: " ", l: 1)
        // case"CBD4":
        // returnOpCode(v: code, c: "SET 2,H", m: " ", l: 1)
        // case"CBD5":
        // returnOpCode(v: code, c: "SET 2,L", m: " ", l: 1)
        // case"CBD6":
        // returnOpCode(v: code, c: "SET 2,(HL)", m: " ", l: 1)
        // case"CBD7":
        // returnOpCode(v: code, c: "SET 2,A", m: " ", l: 1)
        // case"CBD8":
        // returnOpCode(v: code, c: "SET 3,B", m: " ", l: 1)
        // case"CBD9":
        // returnOpCode(v: code, c: "SET 3,C", m: " ", l: 1)
        // case"CBDA":
        // returnOpCode(v: code, c: "SET 3,D", m: " ", l: 1)
        // case"CBDB":
        // returnOpCode(v: code, c: "SET 3,E", m: " ", l: 1)
        // case"CBDC":
        // returnOpCode(v: code, c: "SET 3,H", m: " ", l: 1)
        // case"CBDD":
        // returnOpCode(v: code, c: "SET 3,L", m: " ", l: 1)
        // case"CBDE":
        // returnOpCode(v: code, c: "SET 3,(HL)", m: " ", l: 1)
        // case"CBDF":
        // returnOpCode(v: code, c: "SET 3,A", m: " ", l: 1)
        // case"CBE0":
        // returnOpCode(v: code, c: "SET 4,B", m: " ", l: 1)
        // case"CBE1":
        // returnOpCode(v: code, c: "SET 4,C", m: " ", l: 1)
        // case"CBE2":
        // returnOpCode(v: code, c: "SET 4,D", m: " ", l: 1)
        // case"CBE3":
        // returnOpCode(v: code, c: "SET 4,E", m: " ", l: 1)
        // case"CBE4":
        // returnOpCode(v: code, c: "SET 4,H", m: " ", l: 1)
        // case"CBE5":
        // returnOpCode(v: code, c: "SET 4,L", m: " ", l: 1)
        // case"CBE6":
        // returnOpCode(v: code, c: "SET 4,(HL)", m: " ", l: 1)
        // case"CBE7":
        // returnOpCode(v: code, c: "SET 4,A", m: " ", l: 1)
        // case"CBE8":
        // returnOpCode(v: code, c: "SET 5,B", m: " ", l: 1)
        // case"CBE9":
        // returnOpCode(v: code, c: "SET 5,C", m: " ", l: 1)
        // case"CBEA":
        // returnOpCode(v: code, c: "SET 5,D", m: " ", l: 1)
        // case"CBEB":
        // returnOpCode(v: code, c: "SET 5,E", m: " ", l: 1)
        // case"CBEC":
        // returnOpCode(v: code, c: "SET 5,H", m: " ", l: 1)
        // case"CBED":
        // returnOpCode(v: code, c: "SET 5,L", m: " ", l: 1)
        // case"CBEE":
        // returnOpCode(v: code, c: "SET 5,(HL)", m: " ", l: 1)
        // case"CBEF":
        // returnOpCode(v: code, c: "SET 5,A", m: " ", l: 1)
        // case"CBF0":
        // returnOpCode(v: code, c: "SET 6,B", m: " ", l: 1)
        // case"CBF1":
        // returnOpCode(v: code, c: "SET 6,C", m: " ", l: 1)
        // case"CBF2":
        // returnOpCode(v: code, c: "SET 6,D", m: " ", l: 1)
        // case"CBF3":
        // returnOpCode(v: code, c: "SET 6,E", m: " ", l: 1)
        // case"CBF4":
        // returnOpCode(v: code, c: "SET 6,H", m: " ", l: 1)
        // case"CBF5":
        // returnOpCode(v: code, c: "SET 6,L", m: " ", l: 1)
        // case"CBF6":
        // returnOpCode(v: code, c: "SET 6,(HL)", m: " ", l: 1)
        // case"CBF7":
        // returnOpCode(v: code, c: "SET 6,A", m: " ", l: 1)
        // case"CBF8":
        // returnOpCode(v: code, c: "SET 7,B", m: " ", l: 1)
        // case"CBF9":
        // returnOpCode(v: code, c: "SET 7,C", m: " ", l: 1)
        // case"CBFA":
        // returnOpCode(v: code, c: "SET 7,D", m: " ", l: 1)
        // case"CBFB":
        // returnOpCode(v: code, c: "SET 7,E", m: " ", l: 1)
        // case"CBFC":
        // returnOpCode(v: code, c: "SET 7,H", m: " ", l: 1)
        // case"CBFD":
        // returnOpCode(v: code, c: "SET 7,L", m: " ", l: 1)
        // case"CBFE":
        // returnOpCode(v: code, c: "SET 7,(HL)", m: " ", l: 1)
        // case"CBFF":
        // returnOpCode(v: code, c: "SET 7,A", m: " ", l: 1)
        // case"FD00":
        // returnOpCode(v: code, c: "RLC (iy+0)->b", m: " ", l: 1)
        // case"FD01":
        // returnOpCode(v: code, c: "RLC (iy+0)->c", m: " ", l: 1)
        // case"FD02":
        // returnOpCode(v: code, c: "RLC (iy+0)->d", m: " ", l: 1)
        // case"FD03":
        // returnOpCode(v: code, c: "RLC (iy+0)->e", m: " ", l: 1)
        // case"FD04":
        // returnOpCode(v: code, c: "RLC (iy+0)->h", m: " ", l: 1)
        // case"FD05":
        // returnOpCode(v: code, c: "RLC (iy+0)->l", m: " ", l: 1)
        // case"FD06":
        // returnOpCode(v: code, c: "RLC (IY+0)", m: " ", l: 1)
        // case"FD07":
        // returnOpCode(v: code, c: "RLC (iy+0)->a", m: " ", l: 1)
        // case"FD08":
        // returnOpCode(v: code, c: "RRC (iy+0)->b", m: " ", l: 1)
        // case"FD09":
        // returnOpCode(v: code, c: "RRC (iy+0)->c", m: " ", l: 1)
        // case"FD0A":
        // returnOpCode(v: code, c: "RRC (iy+0)->d", m: " ", l: 1)
        // case"FD0B":
        // returnOpCode(v: code, c: "RRC (iy+0)->e", m: " ", l: 1)
        // case"FD0C":
        // returnOpCode(v: code, c: "RRC (iy+0)->h", m: " ", l: 1)
        // case"FD0D":
        // returnOpCode(v: code, c: "RRC (iy+0)->l", m: " ", l: 1)
        // case"FD0E":
        // returnOpCode(v: code, c: "RRC (IY+0)", m: " ", l: 1)
        // case"FD0F":
        // returnOpCode(v: code, c: "RRC (iy+0)->a", m: " ", l: 1)
        // case"FD10":
        // returnOpCode(v: code, c: "RL (iy+0)->b", m: " ", l: 1)
        // case"FD11":
        // returnOpCode(v: code, c: "RL (iy+0)->c", m: " ", l: 1)
        // case"FD12":
        // returnOpCode(v: code, c: "RL (iy+0)->d", m: " ", l: 1)
        // case"FD13":
        // returnOpCode(v: code, c: "RL (iy+0)->e", m: " ", l: 1)
        // case"FD14":
        // returnOpCode(v: code, c: "RL (iy+0)->h", m: " ", l: 1)
        // case"FD15":
        // returnOpCode(v: code, c: "RL (iy+0)->l", m: " ", l: 1)
        // case"FD16":
        // returnOpCode(v: code, c: "RL (IY+0)", m: " ", l: 1)
        // case"FD17":
        // returnOpCode(v: code, c: "RL (iy+0)->a", m: " ", l: 1)
        // case"FD18":
        // returnOpCode(v: code, c: "RR (iy+0)->b", m: " ", l: 1)
        // case"FD19":
        // returnOpCode(v: code, c: "RR (iy+0)->c", m: " ", l: 1)
        // case"FD1A":
        // returnOpCode(v: code, c: "RR (iy+0)->d", m: " ", l: 1)
        // case"FD1B":
        // returnOpCode(v: code, c: "RR (iy+0)->e", m: " ", l: 1)
        // case"FD1C":
        // returnOpCode(v: code, c: "RR (iy+0)->h", m: " ", l: 1)
        // case"FD1D":
        // returnOpCode(v: code, c: "RR (iy+0)->l", m: " ", l: 1)
        // case"FD1E":
        // returnOpCode(v: code, c: "RR (IY+0)", m: " ", l: 1)
        // case"FD1F":
        // returnOpCode(v: code, c: "RR (iy+0)->a", m: " ", l: 1)
        // case"FD20":
        // returnOpCode(v: code, c: "SLA (iy+0)->b", m: " ", l: 1)
        // case"FD21":
        // returnOpCode(v: code, c: "SLA (iy+0)->c", m: " ", l: 1)
        // case"FD22":
        // returnOpCode(v: code, c: "SLA (iy+0)->d", m: " ", l: 1)
        // case"FD23":
        // returnOpCode(v: code, c: "SLA (iy+0)->e", m: " ", l: 1)
        // case"FD24":
        // returnOpCode(v: code, c: "SLA (iy+0)->h", m: " ", l: 1)
        // case"FD25":
        // returnOpCode(v: code, c: "SLA (iy+0)->l", m: " ", l: 1)
        // case"FD26":
        // returnOpCode(v: code, c: "SLA (IY+0)", m: " ", l: 1)
        // case"FD27":
        // returnOpCode(v: code, c: "SLA (iy+0)->a", m: " ", l: 1)
        // case"FD28":
        // returnOpCode(v: code, c: "SRA (iy+0)->b", m: " ", l: 1)
        // case"FD29":
        // returnOpCode(v: code, c: "SRA (iy+0)->c", m: " ", l: 1)
        // case"FD2A":
        // returnOpCode(v: code, c: "SRA (iy+0)->d", m: " ", l: 1)
        // case"FD2B":
        // returnOpCode(v: code, c: "SRA (iy+0)->e", m: " ", l: 1)
        // case"FD2C":
        // returnOpCode(v: code, c: "SRA (iy+0)->h", m: " ", l: 1)
        // case"FD2D":
        // returnOpCode(v: code, c: "SRA (iy+0)->l", m: " ", l: 1)
        // case"FD2E":
        // returnOpCode(v: code, c: "SRA (IY+0)", m: " ", l: 1)
        // case"FD2F":
        // returnOpCode(v: code, c: "SRA (iy+0)->a", m: " ", l: 1)
        // case"FD30":
        // returnOpCode(v: code, c: "SLS (iy+0)->b", m: " ", l: 1)
        // case"FD31":
        // returnOpCode(v: code, c: "SLS (iy+0)->c", m: " ", l: 1)
        // case"FD32":
        // returnOpCode(v: code, c: "SLS (iy+0)->d", m: " ", l: 1)
        // case"FD33":
        // returnOpCode(v: code, c: "SLS (iy+0)->e", m: " ", l: 1)
        // case"FD34":
        // returnOpCode(v: code, c: "SLS (iy+0)->h", m: " ", l: 1)
        // case"FD35":
        // returnOpCode(v: code, c: "SLS (iy+0)->l", m: " ", l: 1)
        // case"FD36":
        // returnOpCode(v: code, c: "SLS (IY+0)", m: " ", l: 1)
        // case"FD37":
        // returnOpCode(v: code, c: "SLS (iy+0)->a", m: " ", l: 1)
        // case"FD38":
        // returnOpCode(v: code, c: "SRL (iy+0)->b", m: " ", l: 1)
        // case"FD39":
        // returnOpCode(v: code, c: "SRL (iy+0)->c", m: " ", l: 1)
        // case"FD3A":
        // returnOpCode(v: code, c: "SRL (iy+0)->d", m: " ", l: 1)
        // case"FD3B":
        // returnOpCode(v: code, c: "SRL (iy+0)->e", m: " ", l: 1)
        // case"FD3C":
        // returnOpCode(v: code, c: "SRL (iy+0)->h", m: " ", l: 1)
        // case"FD3D":
        // returnOpCode(v: code, c: "SRL (iy+0)->l", m: " ", l: 1)
        // case"FD3E":
        // returnOpCode(v: code, c: "SRL (IY+0)", m: " ", l: 1)
        // case"FD3F":
        // returnOpCode(v: code, c: "SRL (iy+0)->a", m: " ", l: 1)
        // case"FD40":
        // returnOpCode(v: code, c: "BIT 0,(iy+0)->b", m: " ", l: 1)
        // case"FD41":
        // returnOpCode(v: code, c: "BIT 0,(iy+0)->c", m: " ", l: 1)
        // case"FD42":
        // returnOpCode(v: code, c: "BIT 0,(iy+0)->d", m: " ", l: 1)
        // case"FD43":
        // returnOpCode(v: code, c: "BIT 0,(iy+0)->e", m: " ", l: 1)
        // case"FD44":
        // returnOpCode(v: code, c: "BIT 0,(iy+0)->h", m: " ", l: 1)
        // case"FD45":
        // returnOpCode(v: code, c: "BIT 0,(iy+0)->l", m: " ", l: 1)
        // case"FD46":
        // returnOpCode(v: code, c: "BIT 0,(IY+0)", m: " ", l: 1)
        // case"FD47":
        // returnOpCode(v: code, c: "BIT 0,(iy+0)->a", m: " ", l: 1)
        // case"FD48":
        // returnOpCode(v: code, c: "BIT 1,(iy+0)->b", m: " ", l: 1)
        // case"FD49":
        // returnOpCode(v: code, c: "BIT 1,(iy+0)->c", m: " ", l: 1)
        // case"FD4A":
        // returnOpCode(v: code, c: "BIT 1,(iy+0)->d", m: " ", l: 1)
        // case"FD4B":
        // returnOpCode(v: code, c: "BIT 1,(iy+0)->e", m: " ", l: 1)
        // case"FD4C":
        // returnOpCode(v: code, c: "BIT 1,(iy+0)->h", m: " ", l: 1)
        // case"FD4D":
        // returnOpCode(v: code, c: "BIT 1,(iy+0)->l", m: " ", l: 1)
        // case"FD4E":
        // returnOpCode(v: code, c: "BIT 1,(IY+0)", m: " ", l: 1)
        // case"FD4F":
        // returnOpCode(v: code, c: "BIT 1,(iy+0)->a", m: " ", l: 1)
        // case"FD50":
        // returnOpCode(v: code, c: "BIT 2,(iy+0)->b", m: " ", l: 1)
        // case"FD51":
        // returnOpCode(v: code, c: "BIT 2,(iy+0)->c", m: " ", l: 1)
        // case"FD52":
        // returnOpCode(v: code, c: "BIT 2,(iy+0)->d", m: " ", l: 1)
        // case"FD53":
        // returnOpCode(v: code, c: "BIT 2,(iy+0)->e", m: " ", l: 1)
        // case"FD54":
        // returnOpCode(v: code, c: "BIT 2,(iy+0)->h", m: " ", l: 1)
        // case"FD55":
        // returnOpCode(v: code, c: "BIT 2,(iy+0)->l", m: " ", l: 1)
        // case"FD56":
        // returnOpCode(v: code, c: "BIT 2,(IY+0)", m: " ", l: 1)
        // case"FD57":
        // returnOpCode(v: code, c: "BIT 2,(iy+0)->a", m: " ", l: 1)
        // case"FD58":
        // returnOpCode(v: code, c: "BIT 3,(iy+0)->b", m: " ", l: 1)
        // case"FD59":
        // returnOpCode(v: code, c: "BIT 3,(iy+0)->c", m: " ", l: 1)
        // case"FD5A":
        // returnOpCode(v: code, c: "BIT 3,(iy+0)->d", m: " ", l: 1)
        // case"FD5B":
        // returnOpCode(v: code, c: "BIT 3,(iy+0)->e", m: " ", l: 1)
        // case"FD5C":
        // returnOpCode(v: code, c: "BIT 3,(iy+0)->h", m: " ", l: 1)
        // case"FD5D":
        // returnOpCode(v: code, c: "BIT 3,(iy+0)->l", m: " ", l: 1)
        // case"FD5E":
        // returnOpCode(v: code, c: "BIT 3,(IY+0)", m: " ", l: 1)
        // case"FD5F":
        // returnOpCode(v: code, c: "BIT 3,(iy+0)->a", m: " ", l: 1)
        // case"FD60":
        // returnOpCode(v: code, c: "BIT 4,(iy+0)->b", m: " ", l: 1)
        // case"FD61":
        // returnOpCode(v: code, c: "BIT 4,(iy+0)->c", m: " ", l: 1)
        // case"FD62":
        // returnOpCode(v: code, c: "BIT 4,(iy+0)->d", m: " ", l: 1)
        // case"FD63":
        // returnOpCode(v: code, c: "BIT 4,(iy+0)->e", m: " ", l: 1)
        // case"FD64":
        // returnOpCode(v: code, c: "BIT 4,(iy+0)->h", m: " ", l: 1)
        // case"FD65":
        // returnOpCode(v: code, c: "BIT 4,(iy+0)->l", m: " ", l: 1)
        // case"FD66":
        // returnOpCode(v: code, c: "BIT 4,(IY+0)", m: " ", l: 1)
        // case"FD67":
        // returnOpCode(v: code, c: "BIT 4,(iy+0)->a", m: " ", l: 1)
        // case"FD68":
        // returnOpCode(v: code, c: "BIT 5,(iy+0)->b", m: " ", l: 1)
        // case"FD69":
        // returnOpCode(v: code, c: "BIT 5,(iy+0)->c", m: " ", l: 1)
        // case"FD6A":
        // returnOpCode(v: code, c: "BIT 5,(iy+0)->d", m: " ", l: 1)
        // case"FD6B":
        // returnOpCode(v: code, c: "BIT 5,(iy+0)->e", m: " ", l: 1)
        // case"FD6C":
        // returnOpCode(v: code, c: "BIT 5,(iy+0)->h", m: " ", l: 1)
        // case"FD6D":
        // returnOpCode(v: code, c: "BIT 5,(iy+0)->l", m: " ", l: 1)
        // case"FD6E":
        // returnOpCode(v: code, c: "BIT 5,(IY+0)", m: " ", l: 1)
        // case"FD6F":
        // returnOpCode(v: code, c: "BIT  5,(iy+0)->a", m: " ", l: 1)
        // case"FD70":
        // returnOpCode(v: code, c: "BIT 6,(iy+0)->b", m: " ", l: 1)
        // case"FD71":
        // returnOpCode(v: code, c: "BIT 6,(iy+0)->c", m: " ", l: 1)
        // case"FD72":
        // returnOpCode(v: code, c: "BIT 6,(iy+0)->d", m: " ", l: 1)
        // case"FD73":
        // returnOpCode(v: code, c: "BIT 6,(iy+0)->e", m: " ", l: 1)
        // case"FD74":
        // returnOpCode(v: code, c: "BIT 6,(iy+0)->h", m: " ", l: 1)
        // case"FD75":
        // returnOpCode(v: code, c: "BIT 6,(iy+0)->l", m: " ", l: 1)
        // case"FD76":
        // returnOpCode(v: code, c: "BIT 6,(IY+0)", m: " ", l: 1)
        // case"FD77":
        // returnOpCode(v: code, c: "BIT 6,(iy+0)->a", m: " ", l: 1)
        // case"FD78":
        // returnOpCode(v: code, c: "BIT 7,(iy+0)->b", m: " ", l: 1)
        // case"FD79":
        // returnOpCode(v: code, c: "BIT 7,(iy+0)->c", m: " ", l: 1)
        // case"FD7A":
        // returnOpCode(v: code, c: "BIT 7,(iy+0)->d", m: " ", l: 1)
        // case"FD7B":
        // returnOpCode(v: code, c: "BIT 7,(iy+0)->e", m: " ", l: 1)
        // case"FD7C":
        // returnOpCode(v: code, c: "BIT 7,(iy+0)->h", m: " ", l: 1)
        // case"FD7D":
        // returnOpCode(v: code, c: "BIT 7,(iy+0)->l", m: " ", l: 1)
        // case"FD7E":
        // returnOpCode(v: code, c: "BIT 7,(IY+0)", m: " ", l: 1)
        // case"FD7F":
        // returnOpCode(v: code, c: "BIT 7,(iy+0)->a", m: " ", l: 1)
        // case"FD80":
        // returnOpCode(v: code, c: "RES 0,(iy+0)->b", m: " ", l: 1)
        // case"FD81":
        // returnOpCode(v: code, c: "RES 0,(iy+0)->c", m: " ", l: 1)
        // case"FD82":
        // returnOpCode(v: code, c: "RES 0,(iy+0)->d", m: " ", l: 1)
        // case"FD83":
        // returnOpCode(v: code, c: "RES 0,(iy+0)->e", m: " ", l: 1)
        // case"FD84":
        // returnOpCode(v: code, c: "RES 0,(iy+0)->h", m: " ", l: 1)
        // case"FD85":
        // returnOpCode(v: code, c: "RES 0,(iy+0)->l", m: " ", l: 1)
        // case"FD86":
        // returnOpCode(v: code, c: "RES 0,(IY+0)", m: " ", l: 1)
        // case"FD87":
        // returnOpCode(v: code, c: "RES 0,(iy+0)->a", m: " ", l: 1)
        // case"FD88":
        // returnOpCode(v: code, c: "RES 1,(iy+0)->b", m: " ", l: 1)
        // case"FD89":
        // returnOpCode(v: code, c: "RES 1,(iy+0)->c", m: " ", l: 1)
        // case"FD8A":
        // returnOpCode(v: code, c: "RES 1,(iy+0)->d", m: " ", l: 1)
        // case"FD8B":
        // returnOpCode(v: code, c: "RES 1,(iy+0)->e", m: " ", l: 1)
        // case"FD8C":
        // returnOpCode(v: code, c: "RES 1,(iy+0)->h", m: " ", l: 1)
        // case"FD8D":
        // returnOpCode(v: code, c: "RES 1,(iy+0)->l", m: " ", l: 1)
        // case"FD8E":
        // returnOpCode(v: code, c: "RES 1,(IY+0)", m: " ", l: 1)
        // case"FD8F":
        // returnOpCode(v: code, c: "RES 1,(iy+0)->a", m: " ", l: 1)
        // case"FD90":
        // returnOpCode(v: code, c: "RES 2,(iy+0)->b", m: " ", l: 1)
        // case"FD91":
        // returnOpCode(v: code, c: "RES 2,(iy+0)->c", m: " ", l: 1)
        // case"FD92":
        // returnOpCode(v: code, c: "RES 2,(iy+0)->d", m: " ", l: 1)
        // case"FD93":
        // returnOpCode(v: code, c: "RES 2,(iy+0)->e", m: " ", l: 1)
        // case"FD94":
        // returnOpCode(v: code, c: "RES 2,(iy+0)->h", m: " ", l: 1)
        // case"FD95":
        // returnOpCode(v: code, c: "RES 2,(iy+0)->l", m: " ", l: 1)
        // case"FD96":
        // returnOpCode(v: code, c: "RES 2,(IY+0)", m: " ", l: 1)
        // case"FD97":
        // returnOpCode(v: code, c: "RES 2,(iy+0)->a", m: " ", l: 1)
        // case"FD98":
        // returnOpCode(v: code, c: "RES 3,(iy+0)->b", m: " ", l: 1)
        // case"FD99":
        // returnOpCode(v: code, c: "RES 3,(iy+0)->c", m: " ", l: 1)
        // case"FD9A":
        // returnOpCode(v: code, c: "RES 3,(iy+0)->d", m: " ", l: 1)
        // case"FD9B":
        // returnOpCode(v: code, c: "RES 3,(iy+0)->e", m: " ", l: 1)
        // case"FD9C":
        // returnOpCode(v: code, c: "RES 3,(iy+0)->h", m: " ", l: 1)
        // case"FD9D":
        // returnOpCode(v: code, c: "RES 3,(iy+0)->l", m: " ", l: 1)
        // case"FD9E":
        // returnOpCode(v: code, c: "RES 3,(IY+0)", m: " ", l: 1)
        // case"FD9F":
        // returnOpCode(v: code, c: "RES 3,(iy+0)->a", m: " ", l: 1)
        // case"FDA0":
        // returnOpCode(v: code, c: "RES 4,(iy+0)->b", m: " ", l: 1)
        // case"FDA1":
        // returnOpCode(v: code, c: "RES 4,(iy+0)->c", m: " ", l: 1)
        // case"FDA2":
        // returnOpCode(v: code, c: "RES 4,(iy+0)->d", m: " ", l: 1)
        // case"FDA3":
        // returnOpCode(v: code, c: "RES 4,(iy+0)->e", m: " ", l: 1)
        // case"FDA4":
        // returnOpCode(v: code, c: "RES 4,(iy+0)->h", m: " ", l: 1)
        // case"FDA5":
        // returnOpCode(v: code, c: "RES 4,(iy+0)->l", m: " ", l: 1)
        // case"FDA6":
        // returnOpCode(v: code, c: "RES 4,(IY+0)", m: " ", l: 1)
        // case"FDA7":
        // returnOpCode(v: code, c: "RES 4,(iy+0)->a", m: " ", l: 1)
        // case"FDA8":
        // returnOpCode(v: code, c: "RES 5,(iy+0)->b", m: " ", l: 1)
        // case"FDA9":
        // returnOpCode(v: code, c: "RES 5,(iy+0)->c", m: " ", l: 1)
        // case"FDAA":
        // returnOpCode(v: code, c: "RES 5,(iy+0)->d", m: " ", l: 1)
        // case"FDAB":
        // returnOpCode(v: code, c: "RES 5,(iy+0)->e", m: " ", l: 1)
        // case"FDAC":
        // returnOpCode(v: code, c: "RES 5,(iy+0)->h", m: " ", l: 1)
        // case"FDAD":
        // returnOpCode(v: code, c: "RES 5,(iy+0)->l", m: " ", l: 1)
        // case"FDAE":
        // returnOpCode(v: code, c: "RES 5,(IY+0)", m: " ", l: 1)
        // case"FDAF":
        // returnOpCode(v: code, c: "RES 5,(iy+0)->a", m: " ", l: 1)
        // case"FDB0":
        // returnOpCode(v: code, c: "RES 6,(iy+0)->b", m: " ", l: 1)
        // case"FDB1":
        // returnOpCode(v: code, c: "RES 6,(iy+0)->c", m: " ", l: 1)
        // case"FDB2":
        // returnOpCode(v: code, c: "RES 6,(iy+0)->d", m: " ", l: 1)
        // case"FDB3":
        // returnOpCode(v: code, c: "RES 6,(iy+0)->e", m: " ", l: 1)
        // case"FDB4":
        // returnOpCode(v: code, c: "RES 6,(iy+0)->h", m: " ", l: 1)
        // case"FDB5":
        // returnOpCode(v: code, c: "RES 6,(iy+0)->l", m: " ", l: 1)
        // case"FDB6":
        // returnOpCode(v: code, c: "RES 6,(IY+0)", m: " ", l: 1)
        // case"FDB7":
        // returnOpCode(v: code, c: "RES 6,(iy+0)->a", m: " ", l: 1)
        // case"FDB8":
        // returnOpCode(v: code, c: "RES 7,(iy+0)->b", m: " ", l: 1)
        // case"FDB9":
        // returnOpCode(v: code, c: "RES 7,(iy+0)->c", m: " ", l: 1)
        // case"FDBA":
        // returnOpCode(v: code, c: "RES 7,(iy+0)->d", m: " ", l: 1)
        // case"FDBB":
        // returnOpCode(v: code, c: "RES 7,(iy+0)->e", m: " ", l: 1)
        // case"FDBC":
        // returnOpCode(v: code, c: "RES 7,(iy+0)->h", m: " ", l: 1)
        // case"FDBD":
        // returnOpCode(v: code, c: "RES 7,(iy+0)->l", m: " ", l: 1)
        // case"FDBE":
        // returnOpCode(v: code, c: "RES 7,(IY+0)", m: " ", l: 1)
        // case"FDBF":
        // returnOpCode(v: code, c: "RES 7,(iy+0)->a", m: " ", l: 1)
        // case"FDC0":
        // returnOpCode(v: code, c: "SET 0,(iy+0)->b", m: " ", l: 1)
        // case"FDC1":
        // returnOpCode(v: code, c: "SET 0,(iy+0)->c", m: " ", l: 1)
        // case"FDC2":
        // returnOpCode(v: code, c: "SET 0,(iy+0)->d", m: " ", l: 1)
        // case"FDC3":
        // returnOpCode(v: code, c: "SET 0,(iy+0)->e", m: " ", l: 1)
        // case"FDC4":
        // returnOpCode(v: code, c: "SET 0,(iy+0)->h", m: " ", l: 1)
        // case"FDC5":
        // returnOpCode(v: code, c: "SET 0,(iy+0)->l", m: " ", l: 1)
        // case"FDC6":
        // returnOpCode(v: code, c: "SET 0,(IY+0)", m: " ", l: 1)
        // case"FDC7":
        // returnOpCode(v: code, c: "SET 0,(iy+0)->a", m: " ", l: 1)
        // case"FDC8":
        // returnOpCode(v: code, c: "SET 1,(iy+0)->b", m: " ", l: 1)
        // case"FDC9":
        // returnOpCode(v: code, c: "SET 1,(iy+0)->c", m: " ", l: 1)
        // case"FDCA":
        // returnOpCode(v: code, c: "SET 1,(iy+0)->d", m: " ", l: 1)
        // case"FDCB":
        // returnOpCode(v: code, c: "SET 1,(iy+0)->e", m: " ", l: 1)
        // case"FDCC":
        // returnOpCode(v: code, c: "SET 1,(iy+0)->h", m: " ", l: 1)
        // case"FDCD":
        // returnOpCode(v: code, c: "SET 1,(iy+0)->l", m: " ", l: 1)
        // case"FDCE":
        // returnOpCode(v: code, c: "SET 1,(IY+0)", m: " ", l: 1)
        // case"FDCF":
        // returnOpCode(v: code, c: "SET 1,(iy+0)->a", m: " ", l: 1)
        // case"FDD0":
        // returnOpCode(v: code, c: "SET 2,(iy+0)->b", m: " ", l: 1)
        // case"FDD1":
        // returnOpCode(v: code, c: "SET 2,(iy+0)->c", m: " ", l: 1)
        // case"FDD2":
        // returnOpCode(v: code, c: "SET 2,(iy+0)->d", m: " ", l: 1)
        // case"FDD3":
        // returnOpCode(v: code, c: "SET 2,(iy+0)->e", m: " ", l: 1)
        // case"FDD4":
        // returnOpCode(v: code, c: "SET 2,(iy+0)->h", m: " ", l: 1)
        // case"FDD5":
        // returnOpCode(v: code, c: "SET 2,(iy+0)->l", m: " ", l: 1)
        // case"FDD6":
        // returnOpCode(v: code, c: "SET 2,(IY+0)", m: " ", l: 1)
        // case"FDD7":
        // returnOpCode(v: code, c: "SET 2,(iy+0)->a", m: " ", l: 1)
        // case"FDD8":
        // returnOpCode(v: code, c: "SET 3,(iy+0)->b", m: " ", l: 1)
        // case"FDD9":
        // returnOpCode(v: code, c: "SET 3,(iy+0)->c", m: " ", l: 1)
        // case"FDDA":
        // returnOpCode(v: code, c: "SET 3,(iy+0)->d", m: " ", l: 1)
        // case"FDDB":
        // returnOpCode(v: code, c: "SET 3,(iy+0)->e", m: " ", l: 1)
        // case"FDDC":
        // returnOpCode(v: code, c: "SET 3,(iy+0)->h", m: " ", l: 1)
        // case"FDDD":
        // returnOpCode(v: code, c: "SET 3,(iy+0)->l", m: " ", l: 1)
        // case"FDDE":
        // returnOpCode(v: code, c: "SET 3,(IY+0)", m: " ", l: 1)
        // case"FDDF":
        // returnOpCode(v: code, c: "SET 3,(iy+0)->a", m: " ", l: 1)
        // case"FDE0":
        // returnOpCode(v: code, c: "SET 4,(iy+0)->b", m: " ", l: 1)
        // case"FDE1":
        // returnOpCode(v: code, c: "SET 4,(iy+0)->c", m: " ", l: 1)
        // case"FDE2":
        // returnOpCode(v: code, c: "SET 4,(iy+0)->d", m: " ", l: 1)
        // case"FDE3":
        // returnOpCode(v: code, c: "SET 4,(iy+0)->e", m: " ", l: 1)
        // case"FDE4":
        // returnOpCode(v: code, c: "SET 4,(iy+0)->h", m: " ", l: 1)
        // case"FDE5":
        // returnOpCode(v: code, c: "SET 4,(iy+0)->l", m: " ", l: 1)
        // case"FDE6":
        // returnOpCode(v: code, c: "SET 4,(IY+0)", m: " ", l: 1)
        // case"FDE7":
        // returnOpCode(v: code, c: "SET 4,(iy+0)->a", m: " ", l: 1)
        // case"FDE8":
        // returnOpCode(v: code, c: "SET 5,(iy+0)->b", m: " ", l: 1)
        // case"FDE9":
        // returnOpCode(v: code, c: "SET 5,(iy+0)->c", m: " ", l: 1)
        // case"FDEA":
        // returnOpCode(v: code, c: "SET 5,(iy+0)->d", m: " ", l: 1)
        // case"FDEB":
        // returnOpCode(v: code, c: "SET 5,(iy+0)->e", m: " ", l: 1)
        // case"FDEC":
        // returnOpCode(v: code, c: "SET 5,(iy+0)->h", m: " ", l: 1)
        // case"FDED":
        // returnOpCode(v: code, c: "SET 5,(iy+0)->l", m: " ", l: 1)
        // case"FDEE":
        // returnOpCode(v: code, c: "SET 5,(IY+0)", m: " ", l: 1)
        // case"FDEF":
        // returnOpCode(v: code, c: "SET 5,(iy+0)->a", m: " ", l: 1)
        // case"FDF0":
        // returnOpCode(v: code, c: "SET 6,(iy+0)->b", m: " ", l: 1)
        // case"FDF1":
        // returnOpCode(v: code, c: "SET 6,(iy+0)->c", m: " ", l: 1)
        // case"FDF2":
        // returnOpCode(v: code, c: "SET 6,(iy+0)->d", m: " ", l: 1)
        // case"FDF3":
        // returnOpCode(v: code, c: "SET 6,(iy+0)->e", m: " ", l: 1)
        // case"FDF4":
        // returnOpCode(v: code, c: "SET 6,(iy+0)->h", m: " ", l: 1)
        // case"FDF5":
        // returnOpCode(v: code, c: "SET 6,(iy+0)->l", m: " ", l: 1)
        // case"FDF6":
        // returnOpCode(v: code, c: "SET 6,(IY+0)", m: " ", l: 1)
        // case"FDF7":
        // returnOpCode(v: code, c: "SET 6,(iy+0)->a", m: " ", l: 1)
        // case"FDF8":
        // returnOpCode(v: code, c: "SET 7,(iy+0)->b", m: " ", l: 1)
        // case"FDF9":
        // returnOpCode(v: code, c: "SET 7,(iy+0)->c", m: " ", l: 1)
        // case"FDFA":
        // returnOpCode(v: code, c: "SET 7,(iy+0)->d", m: " ", l: 1)
        // case"FDFB":
        // returnOpCode(v: code, c: "SET 7,(iy+0)->e", m: " ", l: 1)
        // case"FDFC":
        // returnOpCode(v: code, c: "SET 7,(iy+0)->h", m: " ", l: 1)
        // case"FDFD":
        // returnOpCode(v: code, c: "SET 7,(iy+0)->l", m: " ", l: 1)
        // case"FDFE":
        // returnOpCode(v: code, c: "SET 7,(IY+0)", m: " ", l: 1)
        // case"FDFF":
        // returnOpCode(v: code, c: "SET 7,(iy+0)->a", m: " ", l: 1)
        // case"ED00":
        // returnOpCode(v: code, c: "MOS_QUIT", m: " ", l: 1)
        // case"ED01":
        // returnOpCode(v: code, c: "MOS_CLI", m: " ", l: 1)
        // case"ED02":
        // returnOpCode(v: code, c: "MOS_BYTE", m: " ", l: 1)
        // case"ED03":
        // returnOpCode(v: code, c: "MOS_WORD", m: " ", l: 1)
        // case"ED04":
        // returnOpCode(v: code, c: "MOS_WRCH", m: " ", l: 1)
        // case"ED05":
        // returnOpCode(v: code, c: "MOS_RDCH", m: " ", l: 1)
        // case"ED06":
        // returnOpCode(v: code, c: "MOS_FILE", m: " ", l: 1)
        // case"ED07":
        // returnOpCode(v: code, c: "MOS_ARGS", m: " ", l: 1)
        // case"ED08":
        // returnOpCode(v: code, c: "MOS_BGET", m: " ", l: 1)
        // case"ED09":
        // returnOpCode(v: code, c: "MOS_BPUT", m: " ", l: 1)
        // case"ED0A":
        // returnOpCode(v: code, c: "MOS_GBPB", m: " ", l: 1)
        // case"ED0B":
        // returnOpCode(v: code, c: "MOS_FIND", m: " ", l: 1)
        // case"ED0C":
        // returnOpCode(v: code, c: "MOS_FF0C", m: " ", l: 1)
        // case"ED0D":
        // returnOpCode(v: code, c: "MOS_FF0D", m: " ", l: 1)
        // case"ED0E":
        // returnOpCode(v: code, c: "MOS_FF0E", m: " ", l: 1)
        // case"ED0F":
        // returnOpCode(v: code, c: "MOS_FF0F", m: " ", l: 1)
        // case"ED40":
        // returnOpCode(v: code, c: "IN B,(C)", m: " ", l: 1)
        // case"ED41":
        // returnOpCode(v: code, c: "OUT (C),B", m: " ", l: 1)
        // case"ED42":
        // returnOpCode(v: code, c: "SBC HL,BC", m: " ", l: 1)
        // case"ED43":
        // returnOpCode(v: code, c: "LD ($$),BC", m: " ", l: 3, t: .DATA)
        // case"ED44":
        // returnOpCode(v: code, c: "NEG", m: " ", l: 1)
        // case"ED45":
        // returnOpCode(v: code, c: "RET N", m: " ", l: 1)
        // case"ED46":
        // returnOpCode(v: code, c: "IM0", m: " ", l: 1)
        // case"ED47":
        // returnOpCode(v: code, c: "LD I,A", m: " ", l: 1)
        // case"ED48":
        // returnOpCode(v: code, c: "INC ,(C)", m: " ", l: 1)
        // case"ED49":
        // returnOpCode(v: code, c: "OUT (C),C", m: " ", l: 1)
        // case"ED4A":
        // returnOpCode(v: code, c: "ADC HL,BC", m: " ", l: 1)
        // case"ED4B":
        // returnOpCode(v: code, c: "LD BC,($$)", m: " ", l: 3, t: .DATA)
        // case"ED4C":
        // returnOpCode(v: code, c: "[neg]", m: " ", l: 1)
        // case"ED4D":
        // returnOpCode(v: code, c: "RET I", m: " ", l: 1)
        // case"ED4E":
        // returnOpCode(v: code, c: "[im0]", m: " ", l: 1)
        // case"ED4F":
        // returnOpCode(v: code, c: "LD R,A", m: " ", l: 1)
        // case"ED50":
        // returnOpCode(v: code, c: "IN D,(C)", m: " ", l: 1)
        // case"ED51":
        // returnOpCode(v: code, c: "OUT (C),D", m: " ", l: 1)
        // case"ED52":
        // returnOpCode(v: code, c: "SBC HL,DE", m: " ", l: 1)
        // case"ED53":
        // returnOpCode(v: code, c: "LD ($$),DE", m: " ", l: 3, t: .DATA)
        // case"ED54":
        // returnOpCode(v: code, c: "[neg]", m: " ", l: 1)
        // case"ED55":
        // returnOpCode(v: code, c: "[retn]", m: " ", l: 1)
        // case"ED56":
        // returnOpCode(v: code, c: "IM1", m: " ", l: 1)
        // case"ED57":
        // returnOpCode(v: code, c: "LD A,I", m: " ", l: 1)
        // case"ED58":
        // returnOpCode(v: code, c: "IN E,(C)", m: " ", l: 1)
        // case"ED59":
        // returnOpCode(v: code, c: "OUT (C),E", m: " ", l: 1)
        // case"ED5A":
        // returnOpCode(v: code, c: "ADC HL,DE", m: " ", l: 1)
        // case"ED5B":
        // returnOpCode(v: code, c: "LD DE,($$)", m: " ", l: 3, t: .DATA)
        // case"ED5C":
        // returnOpCode(v: code, c: "[neg]", m: " ", l: 1)
        // case"ED5D":
        // returnOpCode(v: code, c: "[reti]", m: " ", l: 1)
        // case"ED5E":
        // returnOpCode(v: code, c: "IM2", m: " ", l: 1)
        // case"ED5F":
        // returnOpCode(v: code, c: "LD A,R", m: " ", l: 1)
        // case"ED60":
        // returnOpCode(v: code, c: "IN H,(C)", m: " ", l: 1)
        // case"ED61":
        // returnOpCode(v: code, c: "OUT (C),H", m: " ", l: 1)
        // case"ED62":
        // returnOpCode(v: code, c: "SBC HL,HL", m: " ", l: 1)
        // case"ED63":
        // returnOpCode(v: code, c: "LD ($$),HL", m: " ", l: 3, t: .DATA)
        // case"ED64":
        // returnOpCode(v: code, c: "[neg]", m: " ", l: 1)
        // case"ED65":
        // returnOpCode(v: code, c: "[retn]", m: " ", l: 1)
        // case"ED66":
        // returnOpCode(v: code, c: "[im0]", m: " ", l: 1)
        // case"ED67":
        // returnOpCode(v: code, c: "RRD", m: " ", l: 1)
        // case"ED68":
        // returnOpCode(v: code, c: "IN L,(C)", m: " ", l: 1)
        // case"ED69":
        // returnOpCode(v: code, c: "OUT (C),L", m: " ", l: 1)
        // case"ED6A":
        // returnOpCode(v: code, c: "ADC HL,HL", m: " ", l: 1)
        // case"ED6B":
        // returnOpCode(v: code, c: "LD HL,($$)", m: " ", l: 3, t: .DATA)
        // case"ED6C":
        // returnOpCode(v: code, c: "[neg]", m: " ", l: 1)
        // case"ED6D":
        // returnOpCode(v: code, c: "[reti]", m: " ", l: 1)
        // case"ED6E":
        // returnOpCode(v: code, c: "[im0]", m: " ", l: 1)
        // case"ED6F":
        // returnOpCode(v: code, c: "BIT 5,(iy+0)->a", m: " ", l: 1)
        // case"ED70":
        // returnOpCode(v: code, c: "IN F,(C)", m: " ", l: 1)
        // case"ED71":
        // returnOpCode(v: code, c: "OUT (C),F", m: " ", l: 1)
        // case"ED72":
        // returnOpCode(v: code, c: "SBC HL,SP", m: " ", l: 1)
        // case"ED73":
        // returnOpCode(v: code, c: "LD ($$),SP", m: " ", l: 3, t: .DATA)
        // case"ED74":
        // returnOpCode(v: code, c: "[neg]", m: " ", l: 1)
        // case"ED75":
        // returnOpCode(v: code, c: "[retn]", m: " ", l: 1)
        // case"ED76":
        // returnOpCode(v: code, c: "[im1]", m: " ", l: 1)
        // case"ED77":
        // returnOpCode(v: code, c: "[ldi,i?]", m: " ", l: 1)
        // case"ED78":
        // returnOpCode(v: code, c: "IN A,(C)", m: " ", l: 1)
        // case"ED79":
        // returnOpCode(v: code, c: "OUT (C),A", m: " ", l: 1)
        // case"ED7A":
        // returnOpCode(v: code, c: "ADC HL,SP", m: " ", l: 1)
        // case"ED7B":
        // returnOpCode(v: code, c: "LD SP,($$)", m: " ", l: 3)
        // case"ED7C":
        // returnOpCode(v: code, c: "[neg]", m: " ", l: 1)
        // case"ED7D":
        // returnOpCode(v: code, c: "[reti]", m: " ", l: 1)
        // case"ED7E":
        // returnOpCode(v: code, c: "[im2]", m: " ", l: 1)
        // case"ED7F":
        // returnOpCode(v: code, c: "[ldr,r?]", m: " ", l: 1)
        // case"EDA0":
        // returnOpCode(v: code, c: "LD I", m: " ", l: 1)
        // case"EDA1":
        // returnOpCode(v: code, c: "CP I", m: " ", l: 1)
        // case"EDA2":
        // returnOpCode(v: code, c: "IN I", m: " ", l: 1)
        // case"EDA3":
        // returnOpCode(v: code, c: "OTI", m: " ", l: 1)
        // case"EDA8":
        // returnOpCode(v: code, c: "LD D", m: " ", l: 1)
        // case"EDA9":
        // returnOpCode(v: code, c: "CP D", m: " ", l: 1)
        // case"EDAA":
        // returnOpCode(v: code, c: "IN D", m: " ", l: 1)
        // case"EDAB":
        // returnOpCode(v: code, c: "OTD", m: " ", l: 1)
        // case"EDB0":
        // returnOpCode(v: code, c: "LD IR", m: " ", l: 1)
        // case"EDB1":
        // returnOpCode(v: code, c: "CP IR", m: " ", l: 1)
        // case"EDB2":
        // returnOpCode(v: code, c: "IN IR", m: " ", l: 1)
        // case"EDB3":
        // returnOpCode(v: code, c: "OTIR", m: " ", l: 1)
        // case"EDB8":
        // returnOpCode(v: code, c: "LD DR", m: " ", l: 1)
        // case"EDB9":
        // returnOpCode(v: code, c: "CP DR", m: " ", l: 1)
        // case"EDBA":
        // returnOpCode(v: code, c: "IN DR", m: " ", l: 1)
        // case"EDBB":
        // returnOpCode(v: code, c: "OTDR", m: " ", l: 1)
        // case"EDF8":
        // returnOpCode(v: code, c: "[z80]", m: " ", l: 1)
        // case"EDF9":
        // returnOpCode(v: code, c: "[z80]", m: " ", l: 1)
        // case"EDFA":
        // returnOpCode(v: code, c: "[z80]", m: " ", l: 1)
        // case"EDFB":
        // returnOpCode(v: code, c: "ED_LOAD", m: " ", l: 1)
        // case"EDFC":
        // returnOpCode(v: code, c: "[z80]", m: " ", l: 1)
        // case"EDFD":
        // returnOpCode(v: code, c: "[z80]", m: " ", l: 1)
        // case"EDFE":
        // returnOpCode(v: code, c: "[z80]", m: " ", l: 1)
        // case"EDFF":
        // returnOpCode(v: code, c: "ED_DOS", m: " ", l: 1)
            
            
        default:
            print (code)
            // returnOpCode(v: code, c: "Unknown", m: "Value is not known", l: -1, e: true)

        }
        
    }
    
    
}
