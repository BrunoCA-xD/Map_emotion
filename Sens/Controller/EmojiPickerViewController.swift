//
//  EmojiPickerViewController.swift
//  Sens
//
//  Created by Victoria Andressa S. M. Faria on 27/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit
protocol EmojiPickerViewBackButtonDelegate {
    func backButton(_ emojiCode: String?)
}

class EmojiPickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBAction func backButtonPresed(_ sender: Any) {
        delegateBackButton.backButton(nil)
    }
    @IBOutlet weak var emojiCollection: UICollectionView!
    let reuseIdentifier = "cell"
    var delegateBackButton: EmojiPickerViewBackButtonDelegate!
    var emojis: [[String]] = []
    var emojiList: [[String]] = [
        ["😀","😄","😁","😆","😅"],["😂","🤣","☺️","😊","😇"],["🙂","🙃","😉","😌","😍"],["🥰","😘","😗","😙","😚"],["😋","😛","😝","😜","🤪"],["🤨","🧐","🤓","😎","🤩"],["🥳","😏","😒","😞","😔"],["😟","😕","🙁","☹️","😣"],["😖","😫","😩","🥺","😢"],["😭","😤","😠","🤬","🤯"],["😳","🥵","🥶","😱","😨"],["😰","😥","😓","🤗","🤔"],["🤭","🤫","🤥","😶","😐"],["😑","😬","🙄","😯","😦"],["😧","😮","😲","😴","🤤"],["😪","😵","🤐","🥴","🤢"],["🤮","🤧","😷","🤒","😡"],["🤕","🤑"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchEmojis()
    }
    
//    func fetchEmojis(){
//        let emojiRanges = [
//            0x1F601...0x1F64F
//        ]
//        for range in emojiRanges {
//            var array: [String] = []
//            for i in range {
//                if let unicodeScalar = UnicodeScalar(i){
//                    array.append(String(describing: unicodeScalar))
//                }
//            }
//            emojiList.append(array)
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
        delegateBackButton.backButton(cell?.emojiCode)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EmojiCollectionViewCell
        cell.imageView.image = "\(emojiList[indexPath.section][indexPath.item])\u{fe0e}".image(sizeSquare: 100)
        cell.emojiCode = emojiList[indexPath.section][indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiList[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiList.count
    }
   

} // end Class EmojiPickerViewController

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

