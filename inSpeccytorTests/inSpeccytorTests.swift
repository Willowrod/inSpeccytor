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
    
    func testADC8Bit() throws {
            z80.af().ld(value: 0xf500)
        z80.bc().ld(value: 0x0f3b)
        z80.de().ld(value: 0x200d)
        z80.hl().ld(value: 0xdac6)
            z80.PC = 0
            z80.opCode(byte: 0x88)
             XCTAssert(z80.af().value() == 0x0411)
             XCTAssert(z80.bc().value() == 0x0f3b)
             XCTAssert(z80.de().value() == 0x200d)
             XCTAssert(z80.hl().value() == 0xdac6)
             XCTAssert(z80.ix().value() == 0x0000)
             XCTAssert(z80.iy().value() == 0x0000)
             XCTAssert(z80.PC == 1)
             XCTAssert(z80.SP == 0)
    }
    
    func testSBC8Bit() throws {
            z80.af().ld(value: 0xf500)
        z80.bc().ld(value: 0x0f3b)
        z80.de().ld(value: 0x200d)
        z80.hl().ld(value: 0xdac6)
            z80.PC = 0
            z80.opCode(byte: 0x98)
             XCTAssert(z80.af().value() == 0xe6b2)
             XCTAssert(z80.bc().value() == 0x0f3b)
             XCTAssert(z80.de().value() == 0x200d)
             XCTAssert(z80.hl().value() == 0xdac6)
             XCTAssert(z80.ix().value() == 0x0000)
             XCTAssert(z80.iy().value() == 0x0000)
             XCTAssert(z80.PC == 1)
             XCTAssert(z80.SP == 0)
    }
    
    func testADC16Bit() throws {
        loadRam(data: [0xed,0x4b,0x1a,0xa4])
        loadRam(location: 0xa41a, data: [0xf3,0xd4])
            z80.af().ld(value: 0x650c)
        z80.bc().ld(value: 0xd74d)
        z80.de().ld(value: 0x0448)
        z80.hl().ld(value: 0xa3b9)
            z80.PC = 0
        z80.SP = 0xb554
            z80.opCode(byte: 0xed)
             XCTAssert(z80.af().value() == 0x650c)
             XCTAssert(z80.bc().value() == 0xd4f3)
             XCTAssert(z80.de().value() == 0x0448)
             XCTAssert(z80.hl().value() == 0xa3b9)
             XCTAssert(z80.ix().value() == 0x0000)
             XCTAssert(z80.iy().value() == 0x0000)
             XCTAssert(z80.PC == 4)
             XCTAssert(z80.SP == 0xb554)
    }
    
    func testSBC16Bit() throws {
        loadRam(data: [0xed,0x42])
            z80.af().ld(value: 0xcbd3)
        z80.bc().ld(value: 0x1c8f)
        z80.de().ld(value: 0xd456)
        z80.hl().ld(value: 0x315e)
            z80.PC = 0
        z80.SP = 0
            z80.opCode(byte: 0xed)
             XCTAssert(z80.af().value() == 0xcb12)
             XCTAssert(z80.bc().value() == 0x1c8f)
             XCTAssert(z80.de().value() == 0xd456)
             XCTAssert(z80.hl().value() == 0x14ce)
             XCTAssert(z80.ix().value() == 0x0000)
             XCTAssert(z80.iy().value() == 0x0000)
             XCTAssert(z80.PC == 2)
             XCTAssert(z80.SP == 0)
    }
    
    func testInAC() throws {
        loadRam(data: [0xed,0x78])
        z80.af().ld(value: 0x58dd)
        z80.bc().ld(value: 0xf206)
        z80.de().ld(value: 0x2d6a)
        z80.hl().ld(value: 0xaf16)
            z80.PC = 0
        z80.SP = 0
            z80.opCode(byte: 0xed)
//             XCTAssert(z80.af().value() == 0xf2a1)
             XCTAssert(z80.bc().value() == 0xf206)
             XCTAssert(z80.de().value() == 0x2d6a)
             XCTAssert(z80.hl().value() == 0xaf16)
             XCTAssert(z80.ix().value() == 0x0000)
             XCTAssert(z80.iy().value() == 0x0000)
             XCTAssert(z80.PC == 2)
             XCTAssert(z80.SP == 0)
    }
    
    
    func testff() throws {
    loadRam(location: 27955, data:[255])
    z80.af().ld(value: 0)
    z80.bc().ld(value: 0)
    z80.de().ld(value: 0)
    z80.hl().ld(value: 0)
    z80.af2().ld(value: 0)
    z80.bc2().ld(value: 0)
    z80.de2().ld(value: 0)
    z80.hl2().ld(value: 0)
    z80.ix().ld(value: 0)
    z80.iy().ld(value: 0)
    z80.PC = 27955
    z80.SP = 21767
    z80.opCode(byte: 0xff)
    XCTAssert(z80.af().value() == 0)
    XCTAssert(z80.bc().value() == 0)
    XCTAssert(z80.de().value() == 0)
    XCTAssert(z80.hl().value() == 0)
    XCTAssert(z80.af2().value() == 0)
    XCTAssert(z80.bc2().value() == 0)
    XCTAssert(z80.de2().value() == 0)
    XCTAssert(z80.hl2().value() == 0)
    XCTAssert(z80.ix().value() == 0)
    XCTAssert(z80.iy().value() == 0)
    XCTAssert(z80.PC == 56)
    XCTAssert(z80.SP == 21765)
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
