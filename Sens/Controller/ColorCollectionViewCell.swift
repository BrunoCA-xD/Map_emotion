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
        self.backgroundColor = hexStringToUIColor(hex: color)
        self.layer.cornerRadius = 13
        self.layer.borderWidth = 1
        self.layer.borderColor = hexStringToUIColor(hex: "EDEDED").cgColor
        
    }
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                self.layer.borderWidth = 3
                self.layer.borderColor = hexStringToUIColor(hex: "8247FF").cgColor
            }else {
                self.layer.borderWidth = 1
                self.layer.borderColor = hexStringToUIColor(hex: "EDEDED").cgColor
            }
        }
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


