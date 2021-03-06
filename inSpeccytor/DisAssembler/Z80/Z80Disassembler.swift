//
//  Z80Disassembler.swift
//  inSpeccytor
//
//  Created by Mike Hall on 03/03/2021.
//

import Foundation

protocol DisassemblyDelegate {
    func disassemblyComplete(disassembly: [OpCode])
    func disassemblyComplete(codeRoutines: [CodeRoutine])
}

class Z80Disassembler {
    
    var currentPC: Int = 0
    var memoryDump: [UInt8] = []
    var disassembly: [OpCode] = []
    var entryPoints: [Int] = []
    var alreadyAdded: [Int] = []
    var linesAdded: [Int] = []
    var allRoutines: [CodeRoutine] = []
    var currentEntryPoint = 0
    let opcodeLookup = OpCodeDefs()
    var delegate: DisassemblyDelegate? = nil
    var isCalc = false
    
    init(withData: [UInt8], knownJumpPoints: [Int], fromPC: Int, delegate: DisassemblyDelegate, shouldIncludeRom: Bool = false, shouldIncludeScreen: Bool = false){
        memoryDump = withData
        currentPC = fromPC
        self.delegate = delegate
        entryPoints.append(fromPC)
        entryPoints.append(contentsOf: knownJumpPoints)
        if !shouldIncludeRom {
            for a in 0x0000...0x3FFF {
            alreadyAdded.append(a)
                linesAdded.append(a)
            }
        }
        disassemble(shouldIncludeScreen: shouldIncludeScreen)
    }
    
    func disassemble(shouldIncludeScreen: Bool){
        // Zeroth sweep - Screen and attributes
        if shouldIncludeScreen {
        sweep0()
        }
        // First sweep - Add all known opcodes
        sweep1()
        disassembly.sort{$0.line < $1.line}
        allRoutines.sort{$0.startLine < $1.startLine}
        // Second Sweep - try to find unclaimed sections of data
        sweep2()
        allRoutines.sort{$0.startLine < $1.startLine}
        // Third sweep - compile 'allRoutines' array
        sweep3()
        // Send result back to delegate
        //delegate?.disassemblyComplete(disassembly: disassembly)
        delegate?.disassemblyComplete(codeRoutines: allRoutines)
    }
    
    func increasePC(){
        if !alreadyAdded.contains(currentPC){
            alreadyAdded.append(currentPC)
        }
        currentPC += 1
    }
    
    func getCodeByte() -> CodeByteModel {
        let modelPosition = currentPC
        if (modelPosition < memoryDump.count){
            let byte = memoryDump[modelPosition]
            return CodeByteModel.init(withHex: byte.hex(), line: currentPC)
            
        } else {
            return CodeByteModel(withHex: "00", line: modelPosition)
        }
    }

    func getCodeByteValue() -> UInt8 {
        let modelPosition = currentPC
        if (modelPosition < memoryDump.count){
            return memoryDump[modelPosition]
        }
        return 0
    }

    func sweep0(){
        var currentPoint = 0x4000
        let step = 32
        var graphicSet: [OpCode] = []
        while currentPoint < 0x5800 {
            let thisLineOfGraphics = memoryDump[currentPoint..<currentPoint+step]
            var code = ""
            thisLineOfGraphics.forEach{ byte in
                code = "\(code)\(byte) "
            }
            var graphicalOpCode = OpCode(v: "GFX", c: "SCR$", m: code, l: 32)
            graphicalOpCode.line = currentPoint
            graphicalOpCode.lineType = .GRAPHICS
            graphicSet.append(graphicalOpCode)
            currentPoint += step
        }
        var title = "ScreenGraphics"
        allRoutines.append(CodeRoutine(startLine: 0x4000, length: graphicSet.count * 32, code: graphicSet, description: "Screen Graphics at snap shot point", title: title, type: .GRAPHICS))
        graphicSet = []
        while currentPoint < 0x5B00 {
            let thisLineOfGraphics = memoryDump[currentPoint..<currentPoint+step]
            var code = ""
            thisLineOfGraphics.forEach{ byte in
                code = "\(code)\(byte) "
            }
            var graphicalOpCode = OpCode(v: "ATTR", c: "Attribs", m: code, l: 32)
            graphicalOpCode.lineType = .GRAPHICS
            graphicalOpCode.line = currentPoint
            graphicSet.append(graphicalOpCode)
            currentPoint += step
        }
        title = "Attributes"
        allRoutines.append(CodeRoutine(startLine: 0x5800, length: graphicSet.count * 32, code: graphicSet, description: "Screen Attributes at snap shot point", title: title, type: .GRAPHICS))
        
        
        
    }
    
    func sweep1(){
        var runLoop = true
        var count = 0
    //    var lineCount = 0
        var currentLine = -1
        var routineCodes: [OpCode] = []
        var thisLine = 0
        while runLoop{
          //  lineCount = 0
            let lineAsInt = currentPC
            var opCode = opcodeLookup.opCode(code: getCodeByte().hexValue)
            increasePC()
            if (!isCalc){
            if opCode.isPreCode {
                let thisCode = getCodeByte().hexValue
                increasePC()
                let extra = getCodeByte().hexValue
                increasePC()
                var secondextra = ""
                secondextra = getCodeByteValue().hex()
                currentPC -= 1
                opCode = opcodeLookup.opCode(code: "\(opCode.value)\(thisCode)", extra: getCodeByte().hexValue, secondExtra: secondextra)
            }
            if opCode.length == 2 {
                let byte = getCodeByteValue()
                if opCode.code.contains("±"){
                    opCode.code = opCode.code.replacingOccurrences(of: "±", with: "$\(UInt8(byte).hex().padded(size: 2))")
                } else if opCode.code.contains("$$"){
                    opCode.code = opCode.code.replacingOccurrences(of: "$$", with: "$\(UInt8(byte).hex().padded(size: 2))")
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "$$", with: "\(byte)")
                    //opCode.code = "###\(opCode.code)"
                } else if opCode.code.contains("##"){ // Two's compliment
                    let subt = byte.isSet(bit: 7)
                    var comp: Int = -Int(byte.twosCompliment())
                    if !subt{
                        comp = Int(byte)
                    }
                    opCode.target = currentPC + comp + 1 //Add 1 to make PC correct before comp
                    if opCode.target > 0xffff {
                        opCode.code = opCode.code.replacingOccurrences(of: "##", with: "\(byte.hex()) - OVERFLOW!")
                        opCode.meaning = opCode.meaning.replacingOccurrences(of: "##", with: "\(comp) (\(String(opCode.target, radix: 16)) - OVERFLOW!")
                    } else {
                    opCode.code = opCode.code.replacingOccurrences(of: "##", with: "$\(byte.hex())")
                        opCode.meaning = opCode.meaning.replacingOccurrences(of: "##", with: "\(comp) (\(UInt16(opCode.target).hex()))")
                    }
                } else if opCode.code.contains("§§"){ // Two's compliment
                    let subt = byte.isSet(bit: 7)
                    var comp: Int = -Int(byte.twosCompliment())
                    if !subt{
                        comp = Int(byte)
                    }
                    opCode.target = currentPC + comp + 1 //Add 1 to make PC correct before comp
                    opCode.code = opCode.code.replacingOccurrences(of: "§§", with: "$\(byte.hex())")
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "§§", with: "\(comp)")
                }

                opCode.meaning = opCode.meaning.replacingOccurrences(of: "±", with: "\(byte)")
                increasePC()
            } else if opCode.length == 3 {
                let low = getCodeByte().intValue
                increasePC()
                let high = getCodeByte().intValue

                if (opCode.code.contains("$$")){
                    let word = (high * 256) + low
                    opCode.target = word
                    opCode.code = opCode.code.replacingOccurrences(of: "$$", with: "$\(UInt16(word).hex().padded(size: 4))")
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "$$", with: "$\(UInt16(word).hex().padded(size: 4))")
                } else {
                    opCode.code = opCode.code.replacingOccurrences(of: "¢1", with: "$\(UInt8(low).hex().padded(size: 2))").replacingOccurrences(of: "¢2", with: "$\(UInt8(high).hex().padded(size: 2))")
                    opCode.meaning = opCode.meaning.replacingOccurrences(of: "¢1", with: "$\(UInt8(low).hex().padded(size: 2))").replacingOccurrences(of: "¢2", with: "$\(UInt8(high).hex().padded(size: 2))")
                }
                increasePC()
            }
                opCode.line = Int(lineAsInt)
            if (!linesAdded.contains(opCode.line)){
                disassembly.append(opCode)
                linesAdded.append(opCode.line)
            }
            
            if (opCode.isJumpTarget()){
                if opCode.targetType == .RST {
                    switch opCode.value.uppercased() {
                    case "C7":
                        opCode.target = 0
                    case "CF":
                        opCode.target = 0x08
                    case "D7":
                        opCode.target = 0x10
                    case "DF":
                        opCode.target = 0x18
                    case "E7":
                        opCode.target = 0x20
                    case "EF":
                        opCode.target = 0x28
                    case "F7":
                        opCode.target = 0x30
                    case "FF":
                        opCode.target = 0x38
                    default:
                        opCode.target = 0
                    }
                }
                
                if (!entryPoints.contains(opCode.target) && !alreadyAdded.contains(opCode.target)){
   //                     print("Adding jump to \(String(opCode.target, radix: 16)) from \(String(opCode.line, radix: 16))")
                    entryPoints.append(opCode.target)
                }
            }
            
            
            if opCode.value.count == 6 {
                increasePC()
            }
            
                if opCode.value.uppercased() == "EF" {
                    isCalc = true
                }
                
             //   lineCount += 1
                count += opCode.length
                thisLine = opCode.line
                if currentLine == -1 {
                    currentLine = opCode.line
                //    lineCount = 1
                }
                routineCodes.append(opCode)
                if opCode.isEndOfRoutine {
                    let title = "\(UInt16(currentLine).hex()) - \(UInt16(thisLine).hex())"
                    allRoutines.append(CodeRoutine(startLine: currentLine, length: count, code: routineCodes, description: "", title: title, type: .CODE))
                    currentLine = -1
                    count = 0
                    print("Found routine \(title)")
                    routineCodes.removeAll()
//                }
//
//
//
//                if (opCode.isEndOfRoutine){
                        runLoop = sortNextOpCode()
                    }

            if (currentPC >= memoryDump.count){
                //             print("End Of File")
  //                runLoop = false
  //                //header.registerPC -= 1
  //                updatePCUI()
  //                opCodes.sort{$0.line < ¢1.line}
  //                mainTableView.reloadData()
  //              markPositions()
                runLoop = sortNextOpCode()
            }
            } else {
                if opCode.value.uppercased() == "38"{
                    opCode.code = "End Calc"
                    isCalc = false
                } else if opCode.value.uppercased() == "3B"{
                    opCode.code = "Single Calc Function"
                    isCalc = false
                } else {
                    opCode.code = "Calc \(opCode.value)"
                }
                opCode.line = Int(lineAsInt)
                if (!linesAdded.contains(opCode.line)){
                    opCode.meaning = "Calculator Function"
                disassembly.append(opCode)
                    alreadyAdded.append(opCode.line)
                    linesAdded.append(opCode.line)
                }
            }
            
      //      print("Adding line \(opCode.line): \(opCode.code) - \(opCode.opCodeString)")
            
        }
    }
    
    func sweep2(){
var currentStartLine = 0x5B01
        allRoutines.forEach{routine in
           // currentStartLine += 1
            if routine.startLine > currentStartLine {
                var opCodeSet: [OpCode] = []
                let unknownCode = memoryDump[currentStartLine..<routine.startLine]
                var code = ""
                unknownCode.forEach{ byte in
                    code = "\(code)\(byte) "
                }
                var unknownOpCode = OpCode(v: "UNKNOWN", c: "UNKNOWN", m: code, l: code.count)
                unknownOpCode.line = currentStartLine
                unknownOpCode.lineType = .EMPTY
                opCodeSet.append(unknownOpCode)
                let title = "\(UInt16(currentStartLine).hex()) - \(UInt16(routine.startLine - 1).hex()) - Undefined"
                allRoutines.append(CodeRoutine(startLine: currentStartLine, length: unknownCode.count, code: opCodeSet, description: "", title: title, type: .UNDEFINED))
                print("Found routine \(title)")
            }
            currentStartLine = routine.startLine + routine.length
        }
    }
    
    func sweep3(){
        
    }
    
    
    
    
    
    func sortNextOpCode() -> Bool {
        currentEntryPoint += 1
        while currentEntryPoint < entryPoints.count {
            let nextEP = entryPoints[currentEntryPoint]
            if nextEP > 0xffff {
                print("Bad EP \(String(nextEP, radix: 16))")
                return false
            } else
  //            if nextEP < 0x4000 {
  //
  //                } else
            if !alreadyAdded.contains(nextEP){
            currentPC = entryPoints[currentEntryPoint]
            return true
            }
            currentEntryPoint += 1
        }
        print("Processing completed")
        return false
    }
    
    func markPositions(){
        let tempCodes = disassembly
        tempCodes.forEach({ opCode in
            if (opCode.target > 0){
                if let target = self.disassembly.firstIndex(where: {$0.line == opCode.target}) {
                    // print("Target: \(target.line) is jump position")
                    //                    let jumpPos = opCodes[target]
                    //                    print("Target: \(jumpPos.line) is jump position")
                    //opCodes[target].isJumpPosition = true
                    disassembly[target].lineType = opCode.targetType
                }
            }
        })
    }
}
