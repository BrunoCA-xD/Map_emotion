//
//  ViewUtilities.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 16/11/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation
import UIKit

class ViewUtilities{
    static func setupBorderShadow(inView view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 20
        
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    static func setupBorderShadow(inViews views: [UIView]) {
        views.forEach { (view) in
            setupBorderShadow(inView: view)
        }
    }
}
