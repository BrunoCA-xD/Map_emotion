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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell
        delegateBackButton.backButton(cell?.emojiCode)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EmojiCollectionViewCell
        let emoji = "\(emojiList[indexPath.section][indexPath.item])\u{fe0e}"
        cell.imageView.image = emoji.image(sizeSquare: 100)
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



