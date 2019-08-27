//
//  AddFeelingViewController.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 25/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

class AddFeelingViewController: UIViewController {

    @IBOutlet weak var textViewThoughts: UITextView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    var cellTagIds: [String] = []
    let cellIds = ["1cell","2cell","3cell","4cell","5cell","6cell","7cell","8cell","9cell","10cell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setTextView()
        // Do any additional setup after loading the view.
    }
}
    extension AddFeelingViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("User tapped on \(cellIds[indexPath.row])")
        }
    }
    
    extension AddFeelingViewController: UICollectionViewDataSource {
        
        func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == self.colorCollectionView {
                return cellIds.count
            } else {
                return cellTagIds.count
            }
        }
        
        //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        //        return collectionView.dequeueReusableCell( withReuseIdentifier: cellIds[indexPath.item], for: indexPath)
        //    }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == self.colorCollectionView {
                let cellColor = collectionView.dequeueReusableCell(withReuseIdentifier: cellIds[indexPath.item], for: indexPath)
                
                return cellColor
            } else {
                let cellTag = collectionView.dequeueReusableCell(withReuseIdentifier: "tagsCollectionView", for: indexPath)
                let title = UILabel(frame: CGRect(x: 0, y: 0, width: cellTag.bounds.size.width, height: 40))
                title.textColor = UIColor.black
                title.textAlignment = .center
                title.text = "T"
                cellTag.contentView.addSubview(title)
                return cellTag
            }
        }
    }
    
    
    extension AddFeelingViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            
            let cellSizes = Array( repeatElement(CGSize(width:(collectionView.bounds.width - 45)/10, height:(collectionView.bounds.width - 45)/10), count: 10))
            return cellSizes[indexPath.item]
        }
    }



