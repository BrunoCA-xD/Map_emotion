//
//  ProfileViewController.swift
//  Sens
//
//  Created by César Ganimi Machado on 29/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ProfileViewController: UIViewController {
    //MARK: Atributtes
    var user: User! = nil
    let userDataAccess = UserDAO()
    var i = 0
    
    
    let db = Firestore.firestore()
    
    //MARK: Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var profileDataView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var pinsCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        // Profile Data View Shadow
        profileDataView.layer.shadowColor = UIColor.black.cgColor
        profileDataView.layer.shadowOpacity = 0.1
        profileDataView.layer.shadowOffset = .zero
        profileDataView.layer.shadowRadius = 20
        
        profileDataView.layer.shadowPath = UIBezierPath(rect: profileDataView.bounds).cgPath
        profileDataView.layer.shouldRasterize = true
        profileDataView.layer.rasterizationScale = UIScreen.main.scale
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.activityIndicator.startAnimating()
        self.userDataAccess.retriveCurrUser(completion: { (user, error) in
            if error != nil {
                //Tratar error
            } else {
                self.user = user
                OperationQueue.main.addOperation {
                    self.nameLabel.text = "\(self.user.fullName)"
                    self.emailLabel.text = self.user.email
                    let dateformatter = DateFormatter()
                    dateformatter.dateStyle = .short
                    dateformatter.timeStyle = .none
                    self.birthDateLabel.text = dateformatter.string(from: self.user.birthDate)
                    self.activityIndicator.stopAnimating()
                }
            }
        })
        
    }
    
    
}

