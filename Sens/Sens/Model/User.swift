//
//  File.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 21/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation
import FirebaseFirestore

class User{
    
    var id: String?
    var name: String
    var lastName: String?
    var email: String
    var birthDate: Date?
    var profilePic: String?
    
    
    var fullName: String {
        if let lastName = lastName{
            return "\(name) \(lastName)"
        }else {
            return "\(name)"
        }
    }
    
    init(){
        self.name = ""
        self.email = ""
    }
    
    
    //Copy initializer
    convenience init(user: User){
        self.init()
        self.id = user.id
        self.name = user.name
        self.lastName = user.lastName
        self.birthDate = user.birthDate
        self.email = user.email
        self.profilePic = user.profilePic
    }
    
    init?(snapshot: NSDictionary){
        guard
            let id: String = Self.snapshotReader(snapshot, .id),
            let name: String = Self.snapshotReader(snapshot, .name),
            let lastName: String = Self.snapshotReader(snapshot, .lastname),
            let email: String = Self.snapshotReader(snapshot, .email)
            else{ return nil}
        
        self.id = id
        self.name = name
        self.lastName = lastName
        self.email = email
        
        if let timestamp:Timestamp = Self.snapshotReader(snapshot, .birthDate){
            self.birthDate = timestamp.dateValue()
        }
        
        self.profilePic = Self.snapshotReader(snapshot, .profilePic)
        
    }
}

extension User: DictionaryInterpreter{
    static func interpret(data: NSDictionary) -> Self? {
        return User(snapshot: data) as? Self
    }
}

extension User: DatabaseRepresentation{
    typealias fieldsEnum = UserFields
    
    static func snapshotReader<T>(_ snapshot: NSDictionary,_ field: UserFields) -> T? {
        return snapshot[field.rawValue] as? T
    }
    
    var representation: [String : Any] {
        var rep: [UserFields : Any] = [
            .id: id!,
            .name: name,
            .email: email
        ]
        
        if let lastName = lastName{
            rep[.lastname] = lastName
        }
        if let birthDate = birthDate {
            rep[.birthDate] = birthDate
        }
        if let profilePic = profilePic {
            rep[.profilePic] = profilePic
        }
        
        return Dictionary(uniqueKeysWithValues: rep.map{ (key,value) in
            (key.rawValue,value)
        })
    }
}

enum UserFields: String,Hashable {
    case id = "uid"
    case name = "firstname"
    case lastname = "lastname"
    case email = "email"
    case birthDate = "birthDate"
    case profilePic = "profilePic"
}
