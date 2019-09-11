//
//  EmotiPinAnnotationView.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 06/09/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit
import MapKit

class EmotiPinAnnotationView: MKAnnotationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var emotionPin: EmotionPin? = nil
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.image = "❔".image(sizeSquare: 50)
    }

}
