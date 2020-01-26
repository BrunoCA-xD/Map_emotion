//
//  PinError.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 21/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

public class PinError: Codable {
    var error: Bool!
    var errorMessage: String!
    var errorCode: Int!

    enum id: Int, Swift.Error {
        case missingTags
        case missingUser
        case missingLocation
        case missingRepresentation
        case notFound
    }
}
