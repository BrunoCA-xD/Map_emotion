//
//  DetailPin.swift
//  Sens
//
//  Created by Rodrigo Takumi on 28/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit
import MapKit

class DetailPinViewController: UIViewController {

    //MARK:IBOutlet
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
    
    //MARK: Variable
    var detailPin: EmotionPin?
    let geoCoder: CLGeocoder = CLGeocoder()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ViewUtilities.setupBorderShadow(inViews: [colorView,emojiView])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titlePin.text = (detailPin?.userName.capitalized)!
        emojiPin.image = detailPin?.icon.image(sizeSquare: 50)
        colorPin.backgroundColor = Utilities.hexStringToUIColor(hex: (detailPin?.color) ?? "ffffff")
        colorHexPin.text = detailPin?.color != nil ? "HEX: " + (detailPin?.color)! : NSLocalizedString("emotionColorNotSelected", comment: "")
        observacoesPin.text = detailPin?.testimonial
        Utilities.recoveryAddress(locationCoordinate: (detailPin?.location)!, completion:
            {(address,err) in
                if(err == nil){
                    self.adressPin.text = address
                }
        })
    }

}


extension DetailPinViewController: UICollectionViewDataSource {
    
    func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (detailPin?.tags.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cellTag = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmotionTagCollectionViewCell
            cellTag.index = indexPath.item
            cellTag.labelEmotionCell.textColor = Utilities.hexStringToUIColor(hex: "8247FF")
            cellTag.labelEmotionCell.text = detailPin?.tags[indexPath.item].capitalized
            cellTag.layer.borderColor = Utilities.hexStringToUIColor(hex: "8247FF").cgColor
            cellTag.layer.cornerRadius = 4
            cellTag.layer.borderWidth = 1
            return cellTag
    }
}
