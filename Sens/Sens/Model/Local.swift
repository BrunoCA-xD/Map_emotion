//
//  Local.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 20/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

class Local {
    static private var base: UserDefaults {return UserDefaults.standard}
    
    static var userID: Int64? {
        set { base.set(newValue, forKey: "USER_ID") }
        get { return base.object(forKey: "USER_ID") as? Int64 }
    }

    static var userMail:String? {
        set { base.set(newValue, forKey: "USER_MAIL") }
        get { return base.object(forKey: "USER_MAIL") as? String }
    }
}
