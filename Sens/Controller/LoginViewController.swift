//
//  LoginViewController.swift
//  Sens
//
//  Created by Rodrigo Takumi on 22/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: Variable
    let userDAO = UserDAO()
    
    //MARK: IBAction
    @IBAction func login(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = senhaTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        
        userDAO.signIn(email: email, password: password, completion: self.transitionToHome())
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
    
    //MARK: Transition
    func transitionToHome() -> (() -> ()) {
        return{
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier:
                "mainTabBar") as? UITabBarController
            
            self.view.window?.rootViewController = homeViewController
            self.view.window?.makeKeyAndVisible()
        }
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
