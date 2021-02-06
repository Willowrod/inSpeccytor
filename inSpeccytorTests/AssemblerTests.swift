//
//  AssemblerTests.swift
//  inSpeccytorTests
//
//  Created by Mike Hall on 04/02/2021.
//

import XCTest

class AssemblerTests: XCTestCase {
    
    let assembler = Z80Assembler()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testNop(){
        XCTAssert(assembler.assemble(opCode: "NOP") == "00")
    }

    func testHex(){
        XCTAssert("AABB".isValidHex())
        XCTAssert("01".isValidHex())
        XCTAssert("01AF".isValidHex())
        XCTAssert("0123456789ABCDEF".isValidHex())
        XCTAssert("0123456789ABCDEf".isValidHex() == false)
        XCTAssert("0123456789ABCDEG".isValidHex() == false)
        
    }
    
    func testLoads(){
        XCTAssert(assembler.assemble(opCode: "LD BC,0x692b") == "01 2B 69")
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
