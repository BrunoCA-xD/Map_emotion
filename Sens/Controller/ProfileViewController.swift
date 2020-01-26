//
//  ProfileViewController.swift
//  Sens
//
//  Created by César Ganimi Machado on 29/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit
import FirebaseStorage

class ProfileViewController: UIViewController {
    //MARK: Atributtes
    let fileDM = FileDAO()
    let userService = UserService()
    
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
        
        
        self.userService.retriveUser(withId: nil) { (user, error) in
            if error != nil {
                //Tratar error
            }else {
                guard let user = user else {return}
                OperationQueue.main.addOperation {
                    self.nameLabel.text = "\(user.fullName)"
                    self.emailLabel.text = user.login.email
                    self.birthDateLabel.text = user.birthDate?.toString()
                    self.activityIndicator.stopAnimating()
                }
                if let profilePic = user.profilePic{
                    self.fileDM.recoverProfileImage(profilePic: profilePic) { (image, error) in
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
        }
    }
}
