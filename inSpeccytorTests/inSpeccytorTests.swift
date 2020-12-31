//
//  inSpeccytorTests.swift
//  inSpeccytorTests
//
//  Created by Mike Hall on 10/10/2020.
//

import XCTest
@testable import inSpeccytor

class inSpeccytorTests: XCTestCase {
    
    let z80 = Z80()

    override func setUpWithError() throws {
resetRegisters()
    }

    override func tearDownWithError() throws {
        print ("AF: \(z80.af().hex())")
        print ("BC: \(z80.bc().hex())")
        print ("DE: \(z80.de().hex())")
        print ("HL: \(z80.hl().hex())")
        print ("IY: \(z80.iy().hex())")
        print ("IX: \(z80.ix().hex())")
        print ("PC: \(z80.PC.hex())")
        print ("SP: \(z80.SP.hex())")
        print ("F: \(Z80.F.byteValue.bin())")
    }
    
    func resetRegisters(){
        z80.af().ld(value: 0)
        z80.bc().ld(value: 0)
        z80.de().ld(value: 0)
        z80.hl().ld(value: 0)
        z80.ix().ld(value: 0)
        z80.iy().ld(value: 0)
        z80.PC = 0
        z80.SP = 0
    //    print("Set up complete")
    }
    
    func loadRam(location: Int = 0, data:[UInt8]){
        var count = location
        for dat in data {
            z80.ldRam(location: count, value: dat)
            count += 1
        }
  //      print ("Data: \(z80.ram[location...location &+ data.count])")
    }
    
    func testNop() throws {
        
        self.measure {
            resetRegisters()
        z80.opCode(byte: 0)
        }
        XCTAssert(z80.af().value() == 0x0000)
        XCTAssert(z80.bc().value() == 0x0000)
        XCTAssert(z80.de().value() == 0x0000)
        XCTAssert(z80.hl().value() == 0x0000)
        XCTAssert(z80.ix().value() == 0x0000)
        XCTAssert(z80.iy().value() == 0x0000)
        XCTAssert(z80.PC == 1)
        XCTAssert(z80.SP == 0)
    }
    
    func testLoadBC() throws {
        loadRam(data: [0x01,0x12,0x34])
        self.measure {
            resetRegisters()
        z80.opCode(byte: 1)
        }
             XCTAssert(z80.af().value() == 0x0000)
             XCTAssert(z80.bc().value() == 0x3412)
             XCTAssert(z80.de().value() == 0x0000)
             XCTAssert(z80.hl().value() == 0x0000)
             XCTAssert(z80.ix().value() == 0x0000)
             XCTAssert(z80.iy().value() == 0x0000)
             XCTAssert(z80.PC == 3)
             XCTAssert(z80.SP == 0)
    }
    
    func testLoadBCNN() throws {
        loadRam(data: [0x01,0x12,0x34])
        self.measure {
            resetRegisters()
        z80.opCode(byte: 1)
        }
             XCTAssert(z80.af().value() == 0x0000)
             XCTAssert(z80.bc().value() == 0x3412)
             XCTAssert(z80.de().value() == 0x0000)
             XCTAssert(z80.hl().value() == 0x0000)
             XCTAssert(z80.ix().value() == 0x0000)
             XCTAssert(z80.iy().value() == 0x0000)
             XCTAssert(z80.PC == 3)
             XCTAssert(z80.SP == 0)
    }
    
    func testLoadRAMBCA() throws {
        z80.af().ld(value: 0x5600)
        z80.bc().ld(value: 0x0001)
        self.measure {
            z80.PC = 0
        z80.opCode(byte: 2)
        }
             XCTAssert(z80.af().value() == 0x5600)
             XCTAssert(z80.bc().value() == 0x0001)
             XCTAssert(z80.de().value() == 0x0000)
             XCTAssert(z80.hl().value() == 0x0000)
             XCTAssert(z80.ix().value() == 0x0000)
             XCTAssert(z80.iy().value() == 0x0000)
             XCTAssert(z80.PC == 1)
             XCTAssert(z80.SP == 0)
        XCTAssert(z80.fetchRam(location: 0x01) == 0x56)
    }
    
    func testLoadRAMBCA_2() throws {
        z80.af().ld(value: 0x1300)
        z80.bc().ld(value: 0x6b65)
        self.measure {
            z80.PC = 0
        z80.opCode(byte: 2)
        }
             XCTAssert(z80.af().value() == 0x1300)
             XCTAssert(z80.bc().value() == 0x6b65)
             XCTAssert(z80.de().value() == 0x0000)
             XCTAssert(z80.hl().value() == 0x0000)
             XCTAssert(z80.ix().value() == 0x0000)
             XCTAssert(z80.iy().value() == 0x0000)
             XCTAssert(z80.PC == 1)
             XCTAssert(z80.SP == 0)
        XCTAssert(z80.fetchRam(location: 0x6b65) == 0x13)
    }
    
    func testRLCA() throws {
            print ("A: \(z80.a().hex())")
            z80.PC = 0
        z80.opCode(byte: 7)
             XCTAssert(z80.af().value() == 0x1101)
             XCTAssert(z80.bc().value() == 0x0000)
             XCTAssert(z80.de().value() == 0x0000)
             XCTAssert(z80.hl().value() == 0x0000)
             XCTAssert(z80.ix().value() == 0x0000)
             XCTAssert(z80.iy().value() == 0x0000)
             XCTAssert(z80.PC == 1)
             XCTAssert(z80.SP == 0)
    }
    
    func testAddHLBC() throws {
        z80.bc().ld(value: 0x5678)
        z80.hl().ld(value: 0x9abc)
        z80.PC = 0
    z80.opCode(byte: 0x09)
         XCTAssert(z80.af().value() == 0x0030)
         XCTAssert(z80.bc().value() == 0x5678)
         XCTAssert(z80.de().value() == 0x0000)
         XCTAssert(z80.hl().value() == 0xf134)
         XCTAssert(z80.ix().value() == 0x0000)
         XCTAssert(z80.iy().value() == 0x0000)
         XCTAssert(z80.PC == 1)
         XCTAssert(z80.SP == 0)
    }
    
    func testRRCA() throws {
            z80.af().ld(value: 0x4100)
            z80.PC = 0
            z80.opCode(byte: 0x0f)
             XCTAssert(z80.af().value() == 0xa021)
             XCTAssert(z80.bc().value() == 0x0000)
             XCTAssert(z80.de().value() == 0x0000)
             XCTAssert(z80.hl().value() == 0x0000)
             XCTAssert(z80.ix().value() == 0x0000)
             XCTAssert(z80.iy().value() == 0x0000)
             XCTAssert(z80.PC == 1)
             XCTAssert(z80.SP == 0)
    }
    
    func testRLA() throws {
            z80.af().ld(value: 0x0801)
            print ("A: \(z80.a().hex())")
            z80.PC = 0
        z80.opCode(byte: 0x17)
            print ("AF: \(z80.af().hex())")
             XCTAssert(z80.af().value() == 0x1100)
             XCTAssert(z80.bc().value() == 0x0000)
             XCTAssert(z80.de().value() == 0x0000)
             XCTAssert(z80.hl().value() == 0x0000)
             XCTAssert(z80.ix().value() == 0x0000)
             XCTAssert(z80.iy().value() == 0x0000)
             XCTAssert(z80.PC == 1)
             XCTAssert(z80.SP == 0)
    }
    
    func testRRA() throws {
            z80.af().ld(value: 0x01c4)
            z80.PC = 0
            z80.opCode(byte: 0x1f)
             XCTAssert(z80.af().value() == 0x00c5)
             XCTAssert(z80.bc().value() == 0x0000)
             XCTAssert(z80.de().value() == 0x0000)
             XCTAssert(z80.hl().value() == 0x0000)
             XCTAssert(z80.ix().value() == 0x0000)
             XCTAssert(z80.iy().value() == 0x0000)
             XCTAssert(z80.PC == 1)
             XCTAssert(z80.SP == 0)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
