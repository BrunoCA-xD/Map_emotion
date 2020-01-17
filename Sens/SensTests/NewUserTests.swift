//
//  NewUserTests.swift
//  SensTests
//
//  Created by Bruno Cardoso Ambrosio on 17/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import XCTest
@testable import Sens

class NewUserTests: XCTestCase {
    
    var jsonUser: String!
    
    override func setUp() {
        
        jsonUser = "{\"id\":1,\"lastName\":\"Ambrosio\",\"login\":{\"id\":1,\"email\":\"bruno@gmail.com\",\"password\":\"qwerty\"},\"name\":\"Bruno\",\"birthDate\":\"1998-12-11\",\"profilePic\":\"profile1.jpg\"}"
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        jsonUser = nil
    }
    
    func testEncode() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let login = Login(id: nil, email: "bruno@gmail.com", password: "qwerty")
        let user = NewUser(id: nil, name: "Bruno", lastName: "Ambrosio", birthDate: dateFormatter.date(from: "1998-12-11"), profilePic: nil, login: login)
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(user)
            let s = String(data: jsonData, encoding: .utf8)
            print(s!)
        } catch  {
            XCTFail()
        }
        
    }
    func testDecode() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        do {
            let dec = JSONDecoder()
            guard let data = jsonUser.data(using: .utf8) else { XCTFail();return }
            let user = try dec.decode(NewUser.self, from: data)
            XCTAssert(user.id == 1)
            XCTAssert(user.name == "Bruno" )
            XCTAssert(user.lastName == "Ambrosio" )
            XCTAssert(user.birthDate == dateFormatter.date(from: "1998-12-11") )
            XCTAssert(user.profilePic == "profile1.jpg")
            XCTAssert(user.login.id == 1 )
            XCTAssert(user.login.email == "bruno@gmail.com")
            XCTAssert(user.login.password == "qwerty")
            
        } catch  {
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
