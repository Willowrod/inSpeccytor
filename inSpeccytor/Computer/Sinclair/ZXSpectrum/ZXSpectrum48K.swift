//
//  ZXSpectrum48K.swift
//  inSpeccytor
//
//  Created by Mike Hall on 25/01/2021.
//

import Foundation

class ZXSpectrum48K: ZXSpectrum {
    
    override func allocateMemory() {
        let ram = Array(repeating: UInt8(0x00), count: 0xC000)
        memory.append(ram)
    }
    
    override func loadROM(){
        if let filePath = Bundle.main.path(forResource: "48k", ofType: "rom"){
            print("File found - \(filePath)")
            let contents = NSData(contentsOfFile: filePath)
            let data = contents! as Data
            let dataString = data.hexString
            expandROM(data: dataString)
        } else {
            print("file not found")
        }
    }
    
    override func expandROM(data: String?){
        if let dataModel = data?.splitToBytesROM(separator: " "){
            writeROM(dataModel: dataModel)
        } else {
            print("Failed to create ROM")
        }
    }
    
    
    override func writeRAM(dataModel: Array<UInt8>, startAddress: Int = 0){
        pauseProcessor = true
        interupt = false
        var count = 0
        dataModel.forEach { byte in
            if (count < memory[1].count){
                memory[1][count] = byte
            count += 1
            }
        }
        pauseProcessor = false
    }
    
    func writeROM(dataModel: Array<UInt8>){
        pauseProcessor = true
        interupt = false
        memory.insert(dataModel, at: 0)
        pauseProcessor = false
    }
    
    override func findRam(data:[UInt8]) -> String{
        let len = data.count
        var count = 0
        while count < memory[1].count - len{
            let ramByte = fetchRam(location: count)
            if (ramByte == data[0]){
                var match = true
                for a in 1..<len {
                    if fetchRam(location: count + a) != data[a]{
                        match = false
                    }
                }
                if match {
                    print ("\(String(count, radix: 16)), ")
            }
        }
            count += 1
        }
        return "sweep completed"
    }
    
    override func decRam(location: Int){
        if location < 0x4000 {
            print("Cannot write to ROM")
            return
        }
        var ramByte: UInt8 = fetchRam(location: location)
        ramByte.dec()
        ldRam(location: location, value: ramByte)
    }
    
    override func incRam(location: Int){
        if location < 0x4000 {
            print("Cannot write to ROM")
            return
        }
        var ramByte: UInt8 = fetchRam(location: location)
        ramByte.inc()
        ldRam(location: location, value: ramByte)
    }
    
    override func ldRam(location: Int, value: UInt8){
        if location < 0x4000 {
            print("Cannot write to ROM")
            return
        }
        let ramLocation = location - 0x4000
        if ramLocation < memory[1].count{
            memory[1][ramLocation] = value
            ramUpdated = true
        } else {
            print("Attempting to write to invalid memory location \(String(location, radix: 16)) From \(PC.hex())")
        }
    }
    
    override func fetchRam(location: Int) -> UInt8 {
            if location < 0x4000 {
                return memory[0][location]
            }
        let ramLocation = location - 0x4000
        if ramLocation <= memory[1].count{
        return memory[1][ramLocation]
        }
        return 0x00
    }
    
    override func fetchRamWord(location: Int) -> UInt16 {
                if location < 0x4000 {
                    return UInt16(memory[0][location]) &+ (UInt16(memory[0][location &+ 1]) * 256)
                }
        let ramLocation = location - 0x4000
        if ramLocation < memory[1].count{
        return UInt16(memory[1][ramLocation]) &+ (UInt16(memory[1][ramLocation &+ 1]) * 256)
        }
        return 0x00
    }
    
    
}
