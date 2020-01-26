//
//  LoginViewController.swift
//  Sens
//
//  Created by Rodrigo Takumi on 22/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: Variable
    let loginService = UserService()
    let navUtil = NavigationUtilities()
    
    //MARK: IBAction
    @IBAction func login(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = senhaTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        
        
        loginService.signIn(email: email, password: password) { (resultUser, error) in
            if error != nil {
                //Show message "user not exist/found or invalid credentials"
            }else {
                DispatchQueue.main.async {
                    Local.userID = resultUser?.id
                    Local.userMail = resultUser?.login.email
                    self.navUtil.navigateToStoryBoard(storyboardName: "Main", storyboardID: "mainTabBar", window: self.view.window)
                }
            }
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.isHidden = false
        
        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Keyboard
    @objc func keyboardWillShow(notification:NSNotification){
        view.frame.origin.y = -50
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        view.frame.origin.y += 50
    }
    
    //MARK: deinitializers
    deinit {
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
    }
}
