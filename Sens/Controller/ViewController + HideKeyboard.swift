//
//  ViewController + HideKeyboard.swift
//  Sens
//
//  Created by Rodrigo Takumi on 26/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
