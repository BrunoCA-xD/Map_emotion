//
//  EmotionTag.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 25/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

class EmotionTag: Codable {
    
    var id: Int64?
    var tag: String!
    
    init() {}
    
    init(id: Int64?, tag: String) {
        self.id = id
        self.tag = tag
    }
    
}
