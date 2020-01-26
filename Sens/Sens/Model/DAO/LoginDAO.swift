//
//  LoginDAO.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 17/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation


protocol LoginDAO {
    func signIn(jsonData:Data, completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ())
    func signUp(jsonData:Data, completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ())
}

class LoginDAOImpl: GenericDAO, LoginDAO  {
    
    func signIn(jsonData:Data, completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ()){
        genericPost(with: jsonData, to: apiURL.signIn, completion: completion)
    }
    
    func signUp(jsonData:Data, completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ()){
        genericPost(with: jsonData, to: apiURL.signUp, completion: completion)
    }
    
}
