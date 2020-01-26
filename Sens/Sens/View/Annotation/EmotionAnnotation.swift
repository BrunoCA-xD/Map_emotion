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
        if pin.anonymous {
            self.title = "Anônimo"
        }else {
            self.title = pin.user.name.capitalized
        }
        self.subtitle = pin.tags[0].tag.capitalized
        self.coordinate = pin.location
    }
}
