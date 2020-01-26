//
//  NewEmotionPin.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 18/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation
import CoreLocation

class EmotionPin: Codable {
    var id: Int64?
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var tags: [EmotionTag] = []
    var icon: String?
    var color: String?
    var testimonial: String?
    var user: User!
    var anonymous: Bool!
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case tags
        case icon
        case color
        case testimonial
        case user
        case location
        case anonymous
    }
    
    enum LocationKeys: CodingKey {
        case latitude
        case longitude
    }
    
    init() {}
    
    init(id: Int64?, location: CLLocationCoordinate2D, icon: String?, color: String?, testimonial: String?, user: User, anonymous: Bool = false){
        self.id = id
        self.location = location
        self.icon = icon
        self.color = color
        self.testimonial = testimonial
        self.user = user
        self.anonymous = anonymous
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int64.self, forKey: .id)
        tags = try values.decode(Array.self, forKey: .tags)
        icon = try? values.decode(String.self, forKey: .icon)
        color = try? values.decode(String.self, forKey: .color)
        testimonial = try? values.decode(String.self, forKey: .testimonial)
        user = try values.decode(User.self, forKey: .user)
        anonymous = try? values.decode(Bool.self, forKey: .anonymous)
        
        if  let locationValues = try? values.nestedContainer(keyedBy:LocationKeys.self, forKey: .location),
            let lat = try? locationValues.decode(Double.self, forKey: .latitude),
            let long = try? locationValues.decode(Double.self, forKey: .longitude) {
            
            location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        
        
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let id = id {
            try container.encode(id, forKey: .id)
        }
        if let icon = icon{
            try container.encode(icon, forKey: .icon)
        }
        try container.encode(tags, forKey: .tags)
        if let color = color {
            try container.encode(color, forKey: .color)
        }
        if let testimonial = testimonial {
            try container.encode(testimonial, forKey: .testimonial)
        }
        try container.encode(anonymous, forKey: .anonymous)
        try container.encode(user, forKey: .user)
                
        var locationContainer = container.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        try locationContainer.encode(location.latitude, forKey: .latitude)
        try locationContainer.encode(location.longitude, forKey: .longitude)
        
    }
}
