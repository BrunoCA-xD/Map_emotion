//
//  Date+extensions.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 15/11/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

extension Date{
    func toString() ->String {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .none
        let result = dateformatter.string(from: self)
        
        return result
    }
    
    static func fromString(dateString string:String, withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        dateFormatter.dateStyle = .medium
        let date = dateFormatter.date(from: string)
        
        return date
        
    }
}
