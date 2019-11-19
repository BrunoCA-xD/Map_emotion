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
import FirebaseStorage

class ProfileViewController: UIViewController {
    //MARK: Atributtes
    var user: User! = nil
    let userDataAccess = UserDAO()
    var i = 0
    
    //MARK: Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var profileDataView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var pinsCountLabel: UILabel!
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        // Profile Data View Shadow
        ViewUtilities.setupBorderShadow(inView: profileDataView)
        
        
        
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
                    self.birthDateLabel.text =   self.user.birthDate?.toString()
                    self.activityIndicator.stopAnimating()
                }
                
                if let profilePic = self.user.profilePic{
                    self.userDataAccess.recoverUserProfileImage(profilePic: profilePic) { (image, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }else if let image = image{
                            OperationQueue.main.addOperation {
                                self.profilePicImageView.image = image
                            }
                        }
                    }
                }
            }
        })
    }
}

