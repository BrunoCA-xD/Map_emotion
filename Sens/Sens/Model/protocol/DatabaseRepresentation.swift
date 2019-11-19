//
//  DatabaseRepresentation.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 14/11/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation


protocol DatabaseRepresentation {
    associatedtype fieldsEnum
    
    
    var representation: [String: Any] { get }
    static func snapshotReader<T>(_ snapshot: NSDictionary,_ field: fieldsEnum) -> T?
}
