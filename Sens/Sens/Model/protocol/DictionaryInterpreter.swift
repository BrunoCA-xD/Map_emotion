//
//  DictionaryInterpreter.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 19/11/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

protocol DictionaryInterpreter {
    static func interpret(data: NSDictionary) -> Self?
}
