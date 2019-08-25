//
//  EmotionPin.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 23/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation
import CoreLocation

class EmotionPin {
    private var _location: CLLocationCoordinate2D = CLLocationCoordinate2D()
    private var _id: Int = 0
    private var _tags: [EmotionTag] = []
    private var _icon: String = ""
    private var _color: String = ""
    private var _testimonial: String = ""
    private var _user: User?
    
    var location: CLLocationCoordinate2D {
        get {
            return _location
        }
        set {
            _location = newValue
        }
    }
    
    var id: Int{
        get{
            return _id
        }
        set{
            _id = newValue
        }
    }
    
    var tags: [EmotionTag] {
        get {
            return _tags
        }
        set {
            _tags = newValue
            
        }
    }
    var icon: String {
        get {
            return _icon
        }
        set {
            _icon = newValue
        }
    }
    var color: String {
        get {
            return _color
        }
        set {
            _color = newValue
        }
    }
    
    var testimonial: String {
        get {
            return _testimonial
        }
        set {
            _testimonial = newValue
        }
    }
    
    var user: User {
        get {
            return _user ?? User()
        }
        set {
            if newValue != nil{
                self._user = User.init(user: newValue)!
            }
        }
    }
}
