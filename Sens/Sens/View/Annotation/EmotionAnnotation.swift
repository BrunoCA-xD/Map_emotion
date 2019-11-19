//
//  EmotionAnnotation.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 06/09/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit
import MapKit

class EmotionAnnotation: MKPointAnnotation {
    
    var pin: EmotionPin?
    
    override init() {
        super.init()
    }
    
    init(pin: EmotionPin){
        super.init()
        self.pin = pin
        self.title = pin.userName.capitalized
        self.subtitle = pin.tags[0].capitalized
        self.coordinate = pin.location
    }
}
