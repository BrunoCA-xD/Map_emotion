//
//  Login.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 17/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation


class Login: Codable {
    
    var id: Int64?
    var email: String!
    var password: String!
    
    init() {}
    
    init(id: Int64?, email:String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int64.self, forKey: .id)
        email = try values.decode(String.self, forKey: .email)
        password = try values.decode(String.self, forKey: .password)
        
    }
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case password
    }
    
    func encode (to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let id = id {
            try container.encode(id, forKey: .id)
        }
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
    }
    
    
    
}

