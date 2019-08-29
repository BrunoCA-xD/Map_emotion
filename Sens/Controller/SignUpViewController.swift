//
//  SignUpViewController.swift
//  Sens
//
//  Created by Rodrigo Takumi on 22/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SingUpViewController: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var birthDateDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            print(error!)
        }
        else {
            // Create cleaned versions of the data
            var user = User()
            user.name = self.firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            user.lastName = self.lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            user.email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            user.password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            user.birthDate = birthDateDatePicker.date
            // Create the user
            Auth.auth().createUser(withEmail: user.email, password: user.password) { (result, err) in
                // Check for errors
                if err != nil {
                    // There was an error creating the user
                    print("Error creating user")
                }
                else {
                    user.id = result!.user.uid
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(user.id).setData(
                        ["firstname":user.name, "lastname":user.lastName, "uid": user.id , "birthDate":user.birthDate])
                    
                   
                    // Transition to the home screen
                    self.transitionToHome()
                }
            }
        }
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier:
            "mainTabBar") as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
