//
//  EmotionPin.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 23/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import MapKit

class EmotionPin{
    
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var id: String?
    var tags: [String] = []
    var icon: String
    var color: String?
    var testimonial: String?
    var user: String
    var userName: String
    
    init(){
        self.icon = ""
        self.user = ""
        self.userName = ""
    }
    
    init?(snapshot: NSDictionary){
        guard
            let id: String = Self.snapshotReader(snapshot,.id),
            let icon: String = Self.snapshotReader(snapshot,.icon),
            let tags: [String] = Self.snapshotReader(snapshot,.tags),
            let location: GeoPoint = Self.snapshotReader(snapshot,.location) ,
            let userID: String = Self.snapshotReader(snapshot,.userID),
            let userName: String = Self.snapshotReader(snapshot,.userName)
            else{ return nil }
        
        self.id = id
        self.icon = icon
        self.tags = tags
        self.location = CLLocationCoordinate2D.fromGeoPoint(value: location)
        self.user = userID
        self.userName = userName
        
        if let color: String = Self.snapshotReader(snapshot,.color){
            self.color = color
        }
        
        if let testimonial: String = Self.snapshotReader(snapshot,.testimonial){
            self.testimonial = testimonial
        }
    }
}
extension EmotionPin: DictionaryInterpreter {
    
    static func interpret(data: NSDictionary) -> Self? {
        return EmotionPin(snapshot: data) as? Self
    }
}
extension EmotionPin: DatabaseRepresentation{
    typealias fieldsEnum = EmotionPinFields
    
    static func snapshotReader<T>(_ snapshot: NSDictionary, _ field: EmotionPinFields) -> T? {
        return snapshot[field.rawValue] as? T
    }
    
    var representation: [String : Any] {
        var rep: [EmotionPinFields: Any] = [
            .id: id!,
            .userID: user,
            .userName: userName,
            .icon: icon,
            .tags: tags,
            .location: location.toGeoPoint()
        ]
        
        if let testimonial = self.testimonial {
            rep[.testimonial] = testimonial
        }
        if let color = self.color {
            rep[.color] = color
        }
        return Dictionary(uniqueKeysWithValues: rep.map({ (key,value) in
            (key.rawValue,value)
        }))
    }
    
    
}

enum EmotionPinFields: String, Hashable {
    case id = "id"
    case icon = "icon"
    case color = "color"
    case tags = "tags"
    case userName = "userName"
    case location = "location"
    case testimonial = "testimonial"
    case userID = "userID"
}
