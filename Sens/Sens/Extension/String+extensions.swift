//
//  String+extensions.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 16/11/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func image(sizeSquare: Double) -> UIImage? {
        let size = CGSize(width: sizeSquare, height: sizeSquare)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        UIColor.clear.set()
        
        let stringBounds = (self as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(sizeSquare * 0.75))])
        let originX = (size.width - stringBounds.width)/2
        let originY = (size.height - stringBounds.height)/2
        let rect = CGRect(origin: CGPoint(x: originX, y: originY), size: size)
        UIRectFill(rect)
        
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(sizeSquare * 0.75))])
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
} // end extension String
