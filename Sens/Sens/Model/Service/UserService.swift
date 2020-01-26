//
//  UserService.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 17/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation


class UserService: GenericService {
    
    let loginDAO: LoginDAO = LoginDAOImpl()
    let userDAO = UserDAO()
    
    func signIn(email:String, password: String, completion: @escaping (User?, UserError.id?) -> ()){
        let login = Login(id: nil, email: email, password: password)
        
        let jsonData = try! encoder.encode(login)
        loginDAO.signIn(jsonData:jsonData) {
            (data, response, error) in
            self.handleUser(data, response, error, completion: completion)
        }
        
    }
    
    func signUp(user: User, completion: @escaping (User?, UserError.id?) -> ()) {
        let jsonData = try! encoder.encode(user)
        
        loginDAO.signUp(jsonData: jsonData) { (data, response, error) in
            if error == nil {
                guard let data = data else {return}
                if(response?.statusCode == 201) {
                    let user = try! self.decoder.decode(User.self, from: data)
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
    
    func retriveUser(withId idReceived: Int64?, completion: @escaping (User?, UserError.id?) -> ()) {
        if idReceived == nil {
            guard let userID = Local.userID else {return}
            userDAO.retrieveUser(id: userID) { (data, response, error) in
                self.handleUser(data, response, error, completion: completion)
            }
            
        }else {
            userDAO.retrieveUser(id: idReceived!) { (data, response, error) in
                self.handleUser(data, response, error, completion: completion)
            }
        }
    }
    
    func handleUser(_ data: Data?, _ response:HTTPURLResponse?, _ error: Error?, completion:@escaping (User?, UserError.id?) -> ())  {
        if error == nil {
            guard let data = data else {return}
            
            if response?.statusCode == 200 {
                let user = try! self.decoder.decode(User.self, from: data)
                completion(user,nil)
            }else if response?.statusCode == 404 {
                completion(nil,.notFound)
            }
        }
    }
}
