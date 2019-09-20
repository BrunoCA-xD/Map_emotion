//
//  RootTabBarController.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 13/09/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var user: User! = nil
    let userDataAccess = UserDAO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        userDataAccess.retriveCurrUser(completion: { (user, error) in
            //
        })
        
    }
    

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        
        if  let navigationController = viewController as? UINavigationController,
            let homeViewController = navigationController.viewControllers.first as? HomeViewController {
//            homeViewController.user = self.user
            print("home:\(homeViewController)")
            
        } else if let profileViewController = viewController as? ProfileViewController {
//            profileViewController.user = self.user
            print("perfil: \(profileViewController)")
        }
        
        
    }

    
    
}
