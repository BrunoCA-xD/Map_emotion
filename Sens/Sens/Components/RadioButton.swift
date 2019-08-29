//
//  RadioButton.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 29/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

@IBDesignable
class RadioButton: UIButton {
    
    @IBInspectable
    var gap:CGFloat = 8 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var btnColor: UIColor = UIColor.green{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var isOn: Bool = true{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.contentMode = .scaleAspectFill
        drawCircles(rect: rect)
    }
    
    
    //MARK:- Draw inner and outer circles
    func drawCircles(rect: CGRect){
        var path = UIBezierPath()
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = path.cgPath
        circleLayer.lineWidth = 3
        circleLayer.strokeColor = btnColor.cgColor
        circleLayer.fillColor = UIColor.white.cgColor
        layer.addSublayer(circleLayer)
        
        if isOn {
            let innerCircleLayer = CAShapeLayer()
            let rectForInnerCircle = CGRect(x: gap, y: gap, width: rect.width - 2 * gap, height: rect.height - 2 * gap)
            innerCircleLayer.path = UIBezierPath(ovalIn: rectForInnerCircle).cgPath
            innerCircleLayer.fillColor = btnColor.cgColor
            layer.addSublayer(innerCircleLayer)
        }
        self.layer.shouldRasterize =  true
        self.layer.rasterizationScale = UIScreen.main.nativeScale
    }
    
    /*
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     isOn = !isOn
     self.setNeedsDisplay()
     }
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        isOn = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isOn = !isOn
            setNeedsDisplay()
        }
    }
}
