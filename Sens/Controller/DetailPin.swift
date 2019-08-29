//
//  DetailPin.swift
//  Sens
//
//  Created by Rodrigo Takumi on 28/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit
import MapKit

class DetailPin: UIViewController {

    @IBOutlet weak var titlePin: UILabel!
    @IBOutlet weak var adressPin: UILabel!
    @IBOutlet weak var emojiPin: UIImageView!
    @IBOutlet weak var colorPin: UIView!
    @IBOutlet weak var colorHexPin: UILabel!
    @IBOutlet weak var observacoesPin: UILabel!
    
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var emojiView: UIView!
    @IBOutlet weak var experienceView: UIView!
    
    
    //    var titlePintext: String?
//    var observacoesPintext: String?
//    var corPintext: String?
    var detailPin: Pin?
    let geoCoder: CLGeocoder = CLGeocoder()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = detailPin?.emotionPin.user
        
        // color View Shadow
        colorView.layer.shadowColor = UIColor.black.cgColor
        colorView.layer.shadowOpacity = 0.1
        colorView.layer.shadowOffset = .zero
        colorView.layer.shadowRadius = 20
        
        colorView.layer.shadowPath = UIBezierPath(rect: colorView.bounds).cgPath
        colorView.layer.shouldRasterize = true
        colorView.layer.rasterizationScale = UIScreen.main.scale
        
        // emoji View Shadow
        emojiView.layer.shadowColor = UIColor.black.cgColor
        emojiView.layer.shadowOpacity = 0.1
        emojiView.layer.shadowOffset = .zero
        emojiView.layer.shadowRadius = 20
        
        emojiView.layer.shadowPath = UIBezierPath(rect: emojiView.bounds).cgPath
        emojiView.layer.shouldRasterize = true
        emojiView.layer.rasterizationScale = UIScreen.main.scale
        
        
        // color View Shadow
        emojiView.layer.shadowColor = UIColor.black.cgColor
        emojiView.layer.shadowOpacity = 0.1
        emojiView.layer.shadowOffset = .zero
        emojiView.layer.shadowRadius = 20
        
        emojiView.layer.shadowPath = UIBezierPath(rect: emojiView.bounds).cgPath
        emojiView.layer.shouldRasterize = true
        emojiView.layer.rasterizationScale = UIScreen.main.scale
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titlePin.text = (detailPin?.emotionPin.user.capitalized)!
        emojiPin.image = detailPin?.emotionPin.icon.image(sizeSquare: 50)
        colorPin.backgroundColor = Utilities.hexStringToUIColor(hex: (detailPin?.emotionPin.color) ?? "ffffff")
        colorHexPin.text = "HEX: #" + (detailPin?.emotionPin.color)!
        observacoesPin.text = detailPin?.emotionPin.testimonial
        
//        let loc: CLLocation = CLLocation(latitude: (detailPin?.infoAnnotation.coordinate.latitude)!,
//                                         longitude: (detailPin?.infoAnnotation.coordinate.longitude)!)
//        geoCoder.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
//            var placeMark: CLPlacemark!
//            placeMark = placemarks?[0]
            
//            // Location name
//            if let locationName = placeMark.location {
//                print(locationName)
//            }
//            // Street address
//            if let street = placeMark.thoroughfare {
//                print(street)
//            }
//            // City
//            if let city = placeMark.subAdministrativeArea {
//                print(city)
//            }
//            // Zip code
//            if let zip = placeMark.isoCountryCode {
//                print(zip)
//            }
//            // Country
//            if let country = placeMark.country {
//                print(country)
//            }
//
//
//
//        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
