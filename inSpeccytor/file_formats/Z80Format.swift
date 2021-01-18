//
//  Z80Format.swift
//  inSpeccytor
//
//  Created by Mike Hall on 17/01/2021.
//

import Foundation
class Z80Format: BaseFileFormat {
    var snaData: [UInt8] = []
    var hasCompressedData = false
    init(data: [UInt8]){
        super.init()
        snaData = data
        process()
    }
    
    init(data: String?){
        super.init()
        guard let dataString = data else{
            importSuccessful = false
            return
        }
        
        importDataFromString(data: dataString)
        process()
        registers.shouldReturn = true
    }
    
    
    
    init(fileName: String){
        super.init()
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "z80"){
            print("File found - \(filePath)")
            let contents = NSData(contentsOfFile: filePath)
            let data = contents! as Data
            let dataString = data.hexString
            if let dataString = dataString{
            importDataFromString(data: dataString)
            }
            process()
        } else {
            print("file not found")
        }
    }
    
    func process(){
        sortHeaderData()
        ramBanks = [[]]
        addDataToRam()
        importSuccessful = true
    }
    
    func importDataFromString(data: String){
            data.splitToBytes(separator: " ").forEach {byte in
                snaData.append(UInt8(byte, radix: 16) ?? 0x00)
            }
    }
    
    func sortHeaderData(){
        
        // FirstBlock
        
        /*
         
             0       1       A register
             1       1       F register
             2       2       BC register pair (LSB, i.e. C, first)
             4       2       HL register pair
             6       2       Program counter
             8       2       Stack pointer
             10      1       Interrupt register
             11      1       Refresh register (Bit 7 is not significant!)
             12      1       Bit 0  : Bit 7 of the R-register
                             Bit 1-3: Border colour
                             Bit 4  : 1=Basic SamRom switched in
                             Bit 5  : 1=Block of data is compressed
                             Bit 6-7: No meaning
             13      2       DE register pair
             15      2       BC' register pair
             17      2       DE' register pair
             19      2       HL' register pair
             21      1       A' register
             22      1       F' register
             23      2       IY register (Again LSB first)
             25      2       IX register
             27      1       Interrupt flipflop, 0=DI, otherwise EI
             28      1       IFF2 (not particularly important...)
             29      1       Bit 0-1: Interrupt mode (0, 1 or 2)
                             Bit 2  : 1=Issue 2 emulation
                             Bit 3  : 1=Double interrupt frequency
                             Bit 4-5: 1=High video synchronisation
                                      3=Low video synchronisation
                                      0,2=Normal
                             Bit 6-7: 0=Cursor/Protek/AGF joystick
                                      1=Kempston joystick
                                      2=Sinclair 2 Left joystick (or user
                                        defined, for version 3 .z80 files)
                                      3=Sinclair 2 Right joystick
         
         */
        

        registers.primary.registerA = snaData[0]
        registers.primary.registerF = snaData[1]
        registers.primary.registerC = snaData[2]
        registers.primary.registerB = snaData[3]
        registers.primary.registerL = snaData[4]
        registers.primary.registerH = snaData[5]
        registers.registerPC = registers.registerPair(l: snaData[6], h: snaData[7])
        registers.registerSP = registers.registerPair(l: snaData[8], h: snaData[9])
        registers.registerI = snaData[10]
        registers.registerR = snaData[11]
        registers.registerR.clear(bit: 7)
        let flagByte = snaData[12]
        hasCompressedData = flagByte.isSet(bit: 5)
        registers.borderColour = (flagByte & 14) >> 1
        registers.primary.registerE = snaData[13]
        registers.primary.registerD = snaData[14]

        registers.swap.registerC = snaData[15]
        registers.swap.registerB = snaData[16]
        registers.swap.registerE = snaData[17]
        registers.swap.registerD = snaData[18]
        registers.swap.registerL = snaData[19]
        registers.swap.registerH = snaData[20]
        registers.swap.registerA = snaData[21]
        registers.swap.registerF = snaData[22]
        
        registers.registerIY = registers.registerPair(l:snaData[23], h:snaData[24])
        registers.registerIX = registers.registerPair(l:snaData[25], h:snaData[26])
        let interuptFlag = snaData[27]
        registers.interuptEnabled = interuptFlag > 0x00
        // Byte 28 - not needed yet?
        let multiFlag = snaData[29]
        registers.interuptMode = Int(multiFlag & 0x03)
        registers.shouldReturn = false
        dataStart = 30
        // End of V1 header - Check for V2 header:
        
        if (registers.registerPC == 0x00){
            // Signifies V 2 or 3
            let additionalLength = registers.registerPair(l: snaData[30], h: snaData[31])
            registers.registerPC = registers.registerPair(l: snaData[32], h: snaData[33])
            dataStart += Int(additionalLength &+ 1)
            
        }
        
        
        
        
        
        }
        
    func addDataToRam(){
        
        if hasCompressedData {
            var currentByte = dataStart
            while currentByte < snaData.count {
                let thisByte = snaData[currentByte]
                if currentByte + 3 < snaData.count {
                let nextByte = snaData[currentByte + 1]
                if thisByte != 0xED && nextByte != 0xED{
                    ramBanks[0].append(thisByte)
                    currentByte = currentByte &+ 1
                } else {
                    let countByte = snaData[currentByte + 2]
                    let repeatedByte = snaData[currentByte + 3]
                    for _ in 0..<Int(countByte) {
                        ramBanks[0].append(repeatedByte)
                    }
                    currentByte = currentByte &+ 4
                }
                } else {
                    ramBanks[0].append(thisByte)
                    currentByte = currentByte &+ 1
                }
            }
            
        } else {
            ramBanks[0].append(contentsOf: snaData[dataStart...])
        }
    }
    
    
    
    
}
