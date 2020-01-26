//
//  NewEmotionPinDAO.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 20/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

class EmotionPinDAO: GenericDAO {
    
    func listAll(completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ()) {
        genericGet(to: apiURL.getPins,completion: completion)
    }
    
    func save(jsonData: Data, completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ()) {
        genericPost(with: jsonData, to: apiURL.savePin, completion: completion)
    }
    
    
}
