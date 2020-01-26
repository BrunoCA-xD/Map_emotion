//
//  NewUser.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 17/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

class User: Codable {
    
    //MARK: - Attributes
    var id: Int64?
    var name: String!
    var lastName: String?
    var birthDate: Date?
    var profilePic: String?
    
    var login: Login!
    //MARK: - Calculated Attributes
    var fullName: String {
        if let name = name,
            let lastName = lastName{
            return "\(name) \(lastName)"
        }else if let name = name {
            return "\(name)"
        }else {
            return ""
        }
    }
    
    //MARK: - Init's
    init(){}
    
    init(id: Int64?, name: String, lastName: String?, birthDate:Date?, profilePic: String?, login: Login) {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.birthDate = birthDate
        self.profilePic = profilePic
        self.login = login
    }
    
    required init(from decoder: Decoder) throws {
        let dateWithoutTimeDateFormatter = DateFormatter()
        dateWithoutTimeDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int64.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        lastName = try? values.decode(String.self, forKey: .lastName)
        if let strDate = try? values.decode(String.self, forKey: .birthDate) {
            birthDate = dateWithoutTimeDateFormatter.date(from: strDate)
        }
        profilePic = try? values.decode(String.self, forKey: .profilePic)
        login = try values.decode(Login.self, forKey: .login)
        
        
    }
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case lastName
        case birthDate
        case profilePic
        case login
    }
    
    func encode (to encoder: Encoder) throws {
        let dateWithoutTimeDateFormatter = DateFormatter()
        dateWithoutTimeDateFormatter.dateFormat = "yyyy-MM-dd"
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let id = id {
            try container.encode(id, forKey: .id)
        }
        try container.encode(name, forKey: .name)
        if let lastName = lastName {
            try container.encode(lastName, forKey: .lastName)
        }
        if let birthDate = birthDate {
            try container.encode(dateWithoutTimeDateFormatter.string(from: birthDate), forKey: .birthDate)
        }
        if let profilePic = profilePic {
            try container.encode(profilePic, forKey: .profilePic)
        }
        try container.encode(login, forKey: .login)
        
    }
    
}
