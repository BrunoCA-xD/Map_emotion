//
//  UtilitiesTests.swift
//  SensTests
//
//  Created by Bruno Cardoso Ambrosio on 14/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import XCTest
@testable import Sens

class UtilitiyPasswordTests: XCTestCase {
    
    private var passwordFormatCorrect: String!
    private var passwordMissingUpperCase: String!
    private var passwordMissingLowerCase: String!
    private var passwordMissingSpecialCaracter: String!
    private var passwordMissingMissingNumber: String!
    override func setUp() {
        super.setUp()
        passwordFormatCorrect = "Aasd123@"
        passwordMissingLowerCase = "AASD123@"
        passwordMissingUpperCase = "aasd123@"
        passwordMissingSpecialCaracter = "aasd123"
        passwordMissingMissingNumber = "aasd@"
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        super.tearDown()
        passwordFormatCorrect = nil
        passwordMissingLowerCase = nil
        passwordMissingUpperCase = nil
        passwordMissingSpecialCaracter = nil
        passwordMissingMissingNumber = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIsPasswordFormatOk() {
        XCTAssert(Utilities().isPasswordValid(passwordFormatCorrect))
    }
    
    func testPasswordFormatWrong() {
        XCTAssertFalse(Utilities().isPasswordValid(passwordMissingLowerCase))
        XCTAssertFalse(Utilities().isPasswordValid(passwordMissingUpperCase))
        XCTAssertFalse(Utilities().isPasswordValid(passwordMissingSpecialCaracter))
        XCTAssertFalse(Utilities().isPasswordValid(passwordMissingMissingNumber))
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
