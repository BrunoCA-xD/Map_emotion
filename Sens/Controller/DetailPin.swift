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
    
    @IBOutlet weak var observacoesPin: UITextView!
    
//    var titlePintext: String?
//    var observacoesPintext: String?
//    var corPintext: String?
    var detailPin: Pin?
    let geoCoder: CLGeocoder = CLGeocoder()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = detailPin?.emotionPin.user
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titlePin.text = "Duas vezes? " + (detailPin?.emotionPin.user)!
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
