//
//  File.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 21/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

class User{
    
    
    private var _id: String?
    private var _name: String?
    private var _lastName: String?
    private var _email: String?
    private var _birthDate: Date?
    private var _password: String?
    
    var id: String{
        get{
            return  _id!
        }
        set(newId){
            self._id = newId
        }
    }
    
    var name: String{
        get{
            return  _name ?? ""
        }
        set(newName){
            self._name = newName
        }
    }
    var lastName: String{
        get{
            return  _lastName ?? ""
        }
        set(newLastName){
            self._lastName = newLastName
        }
    }
    
    var fullName: String {
        return "\(name) \(lastName)"
    }
    
    var email:String{
        get{
            return  _email ?? ""
        }
        set(newEmail){
            self._email = newEmail
        }
    }
    
    var birthDate:Date{
        get{
            return  _birthDate ?? Date()
        }
        set(newBirthDate){
            self._birthDate = newBirthDate
        }
    }
    
    var password:String{
        get{
            return _password ?? ""
        }
        set(newPassword){
            self._password = newPassword
        }
    }
    
    init(){
        
    }
    
    init?(user: User){
        self.id = user.id
        self.name = user.name
        self.lastName = user.lastName
        self.birthDate = user.birthDate
        self.email = user.email
        self.password = user.password
        
    }
}
