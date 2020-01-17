//
//  UserService.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 17/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation


class UserService {
    
    let loginDAO = LoginDAO()
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func signIn(email:String, password: String, completion: @escaping (Data?, HTTPURLResponse?,Error?) -> ()){
        let login = Login(id: nil, email: email, password: password)
        
        let jsonData = try! encoder.encode(login)
        loginDAO.signIn(jsonData:jsonData , completion: completion)
        
    }
    
    func signUp(user: NewUser, completion: @escaping (NewUser?, UserError.id?) -> ()) {
        let jsonData = try! encoder.encode(user)
        
        loginDAO.signUp(jsonData: jsonData) { (data, response, error) in
            if error == nil {
                guard let data = data else {return}
                if(response?.statusCode == 201) {
                    let user = try! self.decoder.decode(NewUser.self, from: data)
                    completion(user,nil)
                }else if (response?.statusCode == 400) {
                    let error = try! self.decoder.decode(UserError.self, from: data)
                    let errorCode = error.errorCode
                    switch errorCode {
                    case 1:
                        completion(user,.missingName)
                        break
                    case 2:
                        completion(user,.missingLogin)
                        break
                    case 3:
                        completion(user,.missingLoginEmail)
                        break
                    case 4:
                        completion(user,.missingLoginPassword)
                        break
                    case 5:
                        completion(user,.emailIsAlreadyInUse)
                        break
                    default:
                        break
                    }
                }
            }
        }
    }
}
