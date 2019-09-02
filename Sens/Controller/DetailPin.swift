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

    @IBOutlet weak var tagsCollectionView: UICollectionView!
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
        titlePin.text = (detailPin?.emotionPin.userName.capitalized)!
        emojiPin.image = detailPin?.emotionPin.icon.image(sizeSquare: 50)
        colorPin.backgroundColor = Utilities.hexStringToUIColor(hex: (detailPin?.emotionPin.color) ?? "ffffff")
        colorHexPin.text = "HEX: " + (detailPin?.emotionPin.color)!
        observacoesPin.text = detailPin?.emotionPin.testimonial
        recoveryAddress(locationCoordinate: (detailPin?.emotionPin.location)!)

    }
    
    func recoveryAddress(locationCoordinate:CLLocationCoordinate2D) {
        let location:CLLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        var address = ""
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(locationDetais, error) in
            if error == nil{
                if let locationData = locationDetais?.first {
                    
                    var thoroughfare = ""// rua
                    if let thoroughfareValue = locationData.thoroughfare{
                        thoroughfare = thoroughfareValue
                    }
                    
                    var subThoroughfare = "" //numero
                    if let subThoroughfareValue = locationData.subThoroughfare{
                        subThoroughfare = subThoroughfareValue
                    }
                    
                    var locality = "" //cidade
                    if let localityValue = locationData.locality{
                        locality = localityValue
                    }
                    
                    var subLocality = ""// bairro
                    if let subLocalityValue = locationData.subLocality{
                        subLocality = subLocalityValue
                    }
                    
                    var postalCode = "" // cep
                    if let postalCodeValue = locationData.postalCode{
                        postalCode = postalCodeValue
                    }
                    
                    var country = ""
                    if let countryValue = locationData.country{
                        country = countryValue
                    }
                    
                    var administrativeArea = "" //(UF)
                    if let administrativeAreaValue = locationData.administrativeArea{
                        administrativeArea = administrativeAreaValue
                    }
                    
                    var subAdministrativeArea = ""
                    if let subAdministrativeAreaValue = locationData.subAdministrativeArea{
                        subAdministrativeArea = subAdministrativeAreaValue
                    }
                    address = thoroughfare + ", "
                        + subThoroughfare + " - "
                        + subLocality + " - "
                        + locality + " - "
                        + administrativeArea + " - "
                        + country
                    
                    self.adressPin.text = address
                }else{
                    print("deu erro nessa porra")
                }
            }
        })
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


extension DetailPin: UICollectionViewDataSource {
    
    func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (detailPin?.emotionPin.tags.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cellTag = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmotionTagCollectionViewCell
            cellTag.index = indexPath.item
            cellTag.labelEmotionCell.textColor = Utilities.hexStringToUIColor(hex: "8247FF")
            cellTag.labelEmotionCell.text = detailPin?.emotionPin.tags[indexPath.item].capitalized
            cellTag.layer.borderColor = Utilities.hexStringToUIColor(hex: "8247FF").cgColor
            cellTag.layer.cornerRadius = 4
            cellTag.layer.borderWidth = 1
            return cellTag
    }
}
