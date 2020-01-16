//
//  RootTabBarController.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 13/09/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        do {
            let color = try Utilities.hexStringToUIColor(hex: "FFFFFF")
            self.tabBar.unselectedItemTintColor = color.withAlphaComponent(0.5)
        } catch  {
            
        }
        
        
    }
}
