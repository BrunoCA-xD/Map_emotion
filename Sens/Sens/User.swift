//
//  File.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 21/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

class User{
    
    public private(set) var id: Int
    
   
    
    var ID: Int{
        get{
            return self._id
        }
        set(newId){
            if newId > 0{
                self._id = newId
            }
        }
    }

    private var _id: Int

    init(id:Int) {
        self._id = id
    }

    
}
