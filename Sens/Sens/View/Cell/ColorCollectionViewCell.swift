//
//  ColorCollectionViewCell.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 28/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
   var color:String = ""
    
    func configCell(color: String){
        self.color = color
        self.backgroundColor = try? Utilities.hexStringToUIColor(hex: color)
        self.layer.cornerRadius = 13
        self.layer.borderWidth = 1
        self.layer.borderColor = try? Utilities.hexStringToUIColor(hex: "EDEDED").cgColor
        
    }
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                self.layer.borderWidth = 3
                self.layer.borderColor = try? Utilities.hexStringToUIColor(hex: "8247FF").cgColor
            }else {
                self.layer.borderWidth = 1
                self.layer.borderColor = try? Utilities.hexStringToUIColor(hex: "EDEDED").cgColor
            }
        }
    }
    
}


