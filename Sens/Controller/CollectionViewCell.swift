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

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelEmotionCell: UILabel!
    
    weak var textFieldDelegate: CollectionCellTextFieldDelegate?
}
