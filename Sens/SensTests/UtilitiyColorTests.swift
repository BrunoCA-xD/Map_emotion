//
//  File.swift
//  SensTests
//
//  Created by Bruno Cardoso Ambrosio on 15/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import XCTest
@testable import Sens

class UtilitiyColorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIsHexStringColorFormatOk() {
        
        do {
            let colorFFF = try Utilities.hexStringToUIColor(hex: "#fff")
            let colorFFFWithoutHashTag = try Utilities.hexStringToUIColor(hex: "fff")
            let colorFFFFFF = try Utilities.hexStringToUIColor(hex: "#ffffff")
            XCTAssertEqual(colorFFF, UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            XCTAssertEqual(colorFFFFFF, UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            XCTAssertEqual(colorFFFWithoutHashTag, UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            
            XCTAssertNotEqual(colorFFFFFF, UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
        } catch {
            XCTFail()
        }
        
        
    }
    
    func testIsHexStringColorFormatWrong() {
        do {
            try Utilities.hexStringToUIColor(hex: "ff")
        } catch (let error as ColorConversionError){
            XCTAssert(error == ColorConversionError.hexCodeInvalid)
            
        }catch {
            XCTFail()
        }
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
