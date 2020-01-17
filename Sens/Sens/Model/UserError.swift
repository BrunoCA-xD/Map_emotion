//
//  UserError.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 17/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation



public class UserError: Codable {
    var error: Bool!
    var errorMessage: String!
    var errorCode: Int!

    enum id: Int, Swift.Error {
        case missingName
        case missingLogin
        case missingLoginEmail
        case missingLoginPassword
        case emailIsAlreadyInUse
    }
}


