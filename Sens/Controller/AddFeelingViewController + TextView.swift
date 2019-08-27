//
//  AddFeelingViewController + TextView.swift
//  Sens
//
//  Created by Rodrigo Takumi on 26/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

extension AddFeelingViewController: UITextViewDelegate {
    
    func setTextView() {
        
        textViewThoughts.text = "Conte seus pensamentos"
        textViewThoughts.textColor = .lightGray
        textViewThoughts.returnKeyType = .done
    }
    
    //  MARK: PlacehoulderTextView
    //  Apaga o placeholder e altera a cor da letra quando identificar digitação
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Conte seus pensamentos" {
            textView.text = nil
            textView.textColor = .black
        }
    }
    // Não sei o que faz
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    // Reescreve o placeholder caso não haja nada escrito na textView
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Conte seus pensamentos"
            textView.textColor = UIColor.lightGray
        }
    }
}
