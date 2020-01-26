//
//  NewEmotionPinTests.swift
//  SensTests
//
//  Created by Bruno Cardoso Ambrosio on 18/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import XCTest
@testable import Sens
import CoreLocation

class EmotionPinTests: XCTestCase {
    
    var jsonPin: String!
    
    override func setUp() {
        jsonPin = "{\"user\":{\"id\":1,\"lastName\":\"Ambrosio\",\"login\":{\"id\":1,\"email\":\"bruno@gmail.com\",\"password\":\"qwerty\"},\"name\":\"Bruno\",\"birthDate\":\"1998-12-11\"},\"tags\":[{\"tag\":\"haha\"},{\"tag\":\"hehe\"}],\"icon\":\"😃\",\"location\":{\"latitute\":-22,\"longitude\":-45.090000000000003},\"color\":\"#FFFFFF\",\"id\":1}"
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEncode() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let login = Login(id: nil, email: "bruno@gmail.com", password: "qwerty")
        let user = User(id: nil, name: "Bruno", lastName: "Ambrosio", birthDate: dateFormatter.date(from: "1998-12-11"), profilePic: nil, login: login)

        let pin = EmotionPin(id: nil, location: CLLocationCoordinate2D(latitude: -22.00, longitude: -45.09), icon: "😃", color: "#FFFFFF", testimonial: nil, user: user)
        pin.tags.append(EmotionTag(id: nil, tag: "haha"))
        pin.tags.append(EmotionTag(id: nil, tag: "hehe"))
        
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(pin)
        let s = String(data: jsonData, encoding: .utf8)
        let dec = JSONDecoder()
        let pin1 = try! dec.decode(EmotionPin.self, from: jsonData)
        
        print(s!)
    }
    
    func testDecode() {
        let dec = JSONDecoder()
        guard let data = jsonPin.data(using: .utf8) else { XCTFail();return }
        let pin = try! dec.decode(EmotionPin.self, from: data)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
