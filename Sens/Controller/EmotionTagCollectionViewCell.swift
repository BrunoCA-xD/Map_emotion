//
//  CollectionViewCell.swift
//  Sens
//
//  Created by Rodrigo Takumi on 26/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

protocol CollectionCellTextFieldDelegate: class {
    func textDidChanged(_ textField: UITextField)
}

protocol RemoveDelegate {
    func removeButtonPressed(_ index:Int)
}

class EmotionTagCollectionViewCell: UICollectionViewCell {
    var index:Int = -1
    @IBAction func removeButtonPressed(_ sender: Any) {
        if index > -1{
            removeDelegate.removeButtonPressed(index)
        }
    }
    @IBOutlet weak var labelEmotionCell: UILabel!
    
    weak var textFieldDelegate: CollectionCellTextFieldDelegate?
    var removeDelegate: RemoveDelegate!
}
