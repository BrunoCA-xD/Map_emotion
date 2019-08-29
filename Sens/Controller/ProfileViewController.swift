//
//  ProfileViewController.swift
//  Sens
//
//  Created by César Ganimi Machado on 29/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileDataView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Profile Data View Shadow
        profileDataView.layer.shadowColor = UIColor.black.cgColor
        profileDataView.layer.shadowOpacity = 0.1
        profileDataView.layer.shadowOffset = .zero
        profileDataView.layer.shadowRadius = 20
        
        profileDataView.layer.shadowPath = UIBezierPath(rect: profileDataView.bounds).cgPath
        profileDataView.layer.shouldRasterize = true
        profileDataView.layer.rasterizationScale = UIScreen.main.scale
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
