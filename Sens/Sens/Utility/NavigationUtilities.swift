//
//  NavigationUtilities.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 17/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation
import UIKit

class NavigationUtilities {
    func navigateToStoryBoard(storyboardName: String, storyboardID: String,window: UIWindow?){
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
    
    func navigateToStoryBoard(storyboardName: String, storyboardID: String,window: UIWindow?, completion: (UIViewController)->()){
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: storyboardID)

        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
        completion(initialViewController)
    }
}
