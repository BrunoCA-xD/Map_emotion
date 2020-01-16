//
//  Date+ExtensionsTest.swift
//  SensTests
//
//  Created by Bruno Cardoso Ambrosio on 15/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import XCTest
@testable import Sens
@testable import FirebaseFirestore

class UserTests: XCTestCase {
    
    
    func dicfix(_ rep: [UserFields: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: rep.map{ (key,value) in
            (key.rawValue,value)
        })
    }
    
    
    var dictionary: [UserFields: Any]!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dictionary = [:]
        dictionary[.id] = nil
        dictionary[.name] = nil
        dictionary[.lastname] = nil
        dictionary[.email] = nil
        dictionary[.birthDate] = nil
        dictionary[.profilePic] = nil
        
    }
    
    override func tearDown() {
        dictionary = nil
        // Put teardowncode here. This method is called after the invocation of each test method in the class.
    }
    
    func testUserMandatoryFieldsWithNonNilValuesOnInit() {

        XCTAssert(User(snapshot: dicfix(dictionary) as! NSDictionary) == nil)//ID nil
        dictionary[.id] = "as12"
        XCTAssert(User(snapshot: dicfix(dictionary) as! NSDictionary) == nil)//name nil
        dictionary[.name] = "John"
        XCTAssert(User(snapshot: dicfix(dictionary) as! NSDictionary) == nil)//lastName nil
        dictionary[.lastname] = "Doe"
        XCTAssert(User(snapshot: dicfix(dictionary) as! NSDictionary) == nil)//email nil
        dictionary[.email] = "johndoe@gmail.com"
        
    }
    
    func testUserInitializingWithDictionary() {
        //Não consegui 'mockar' corretamente a data que viria do firebase
//        guard let date:Date = Date.fromString(dateString: "2001-01-01 10:00:00" ) else {
//            XCTFail()
//            return
//        }
//        let timestamp = Timestamp.init(date: date)
//        if date != timestamp.dateValue() {
//            XCTFail()
//        }
        dictionary[.id] = "as12"
        dictionary[.name] = "Bruno"
        dictionary[.lastname] = "Ambrosio"
        dictionary[.email] = "bruno@gmail.com"
        dictionary[.profilePic] = "profile1"
//        dictionary[.birthDate] = timestamp.seconds
        
        let user = User(snapshot: dicfix(dictionary) as! NSDictionary)
        
        guard let id = user?.representation["uid"] as? String,
            id == "as12" else {
                XCTFail()
                return
        }
        guard let name = user?.representation["firstname"] as? String,
            name == "Bruno" else {
                XCTFail()
                return
        }
        guard let lastname = user?.representation["lastname"] as? String,
            lastname == "Ambrosio" else {
                XCTFail()
                return
        }
        guard let email = user?.representation["email"] as? String,
            email == "bruno@gmail.com" else {
                XCTFail()
                return
        }
        guard let profPic = user?.representation["profilePic"] as? String,
            profPic == "profile1" else {
                XCTFail()
                return
        }
        //Não consegui 'mockar' corretamente a data que viria do firebase
//        guard let birthDate = user?.representation["birthDate"] as? Timestamp,
//        birthDate.dateValue() == date else {
//                XCTFail()
//                return
//        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
