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
    //MARK: IBOutlet
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var birthDateDatePicker: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateTextField: UITextField!
    
    //MARK: IBAction
    @IBAction func birthDateTextEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    @IBAction func signInButton(_ sender: Any) {
        
        if validateFields() {
            // Create cleaned versions of the data
            let user = User()
            user.name = self.firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            user.lastName = self.lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            user.email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if let dateText = dateTextField.text,
                let date = Date.fromString(dateString: dateText){
                user.birthDate = date
            }
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            UserDAO().signUp(user: user, password: password) { (user, error) in
                if error == nil{
                    self.transitionToHome()
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
    //MARK: deinitializers
    deinit {
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Validation
    func validateFields() -> Bool {
        var title = NSLocalizedString("mandatoryField", comment: "")
        
        // Check that all fields are filled in
        if firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(title: title, Message: NSLocalizedString("firstNameMandatory", comment: ""), field: firstName)
            return false
        }else if lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(title: title, Message: NSLocalizedString("surNameMandatory", comment: ""), field: lastName)
            return false
        }else if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            showAlert(title: title, Message: NSLocalizedString("emailMandatory", comment: ""), field: emailTextField)
            return false
            
        }else if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(title: title, Message: NSLocalizedString("passwordMandatory", comment: ""), field: passwordTextField)
            return false
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities().isPasswordValid(cleanedPassword) == false {
            title = NSLocalizedString("weakPassword",comment: "")
            showAlert(title: title, Message: NSLocalizedString("rainforcePasswordMessage", comment: ""), field: passwordTextField)
            return false
            // Password isn't secure enough
            //            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return true
    }
    
    func showAlert(title:String, Message msg: String, field: UITextField){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (act) in
            field.becomeFirstResponder()
        }
        alertController.addAction(okAction)
        present(alertController,animated: true)
        
    }
    
    //MARK: Transition
    func transitionToHome() -> () {
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier:
            "mainTabBar") as? UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    //MARK: Keyboard view
    @objc func keyboardWillShow(notification:NSNotification){
        view.frame.origin.y = -150
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        view.frame.origin.y += 150
    }
    //MARK: Datepicker
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        dateTextField.text = sender.date.toString()
        
    }
}
