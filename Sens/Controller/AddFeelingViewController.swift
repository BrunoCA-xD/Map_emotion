//
//  AddFeelingViewController.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 25/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

class AddFeelingViewController: UIViewController, EmojiPickerViewBackButtonDelegate, RemoveDelegate{
    
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var textViewThoughts: UITextView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    @IBAction func addEmotionTagPressed(_ sender: Any) {
        if let tagText = tagTextField.text{
            var tag:EmotionTag = EmotionTag()
            tag.tag = tagText
            pin.tags.append(tag)
            tagCollectionView.reloadData()
        }
    }
    @IBAction func selectEmojiPressed(_ sender: Any) {
        openCard()
    }
    
    var cardViewController: EmojiPickerViewController!
    var visualEffectView: UIVisualEffectView!
    var cardHeight: CGFloat = 0
    let cardHandleAreaHeight: CGFloat = 60
    var pin: EmotionPin = EmotionPin()
    var cellTagIds: [String] = []
    let cellIds = ["1cell","2cell","3cell","4cell","5cell","6cell","7cell","8cell","9cell","10cell"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setTextView()
        
        // Do any additional setup after loading the view.
    }
    func removeButtonPressed(_ index: Int) {
        pin.tags.remove(at: index)
        tagCollectionView.reloadData()
    }
    func backButton(_ emojiCode: String?) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.cardViewController.view.frame.origin.y = self.view.frame.height
            self.visualEffectView.effect = nil
        }, completion: {(bool) in
            self.cardViewController.removeFromParent()
            self.cardViewController.view.removeFromSuperview()
            self.visualEffectView.removeFromSuperview()
        })
        if let emojiCode = emojiCode{
            print("fechou e o codigo é \(emojiCode)")
        }
    }
    
    func openCard() {
        cardHeight = self.view.frame.height * 0.9
        let cardY = self.view.frame.height - cardHeight
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        cardViewController = storyboard?.instantiateViewController(withIdentifier:"emojiPickerViewController") as? EmojiPickerViewController
        cardViewController.delegateBackButton = self
        self.addChild(cardViewController)
        
        self.view.addSubview(cardViewController.view)
        cardViewController.view.frame = CGRect(x: 0, y: cardY, width: self.view.bounds.width, height: cardHeight)
        
        cardViewController.view.clipsToBounds = true
        visualEffectView.effect = UIBlurEffect(style: .dark)
        cardViewController.view.layer.cornerRadius = 30
    }
    
    
} // end Class AddFeelingViewController


extension AddFeelingViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("User tapped on \(cellIds[indexPath.row])")
           
        }
    
} // end extension AddFeelingViewController

extension AddFeelingViewController: UICollectionViewDataSource {
        
        func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == self.colorCollectionView {
                return cellIds.count
            } else {
                return pin.tags.count
            }
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == self.colorCollectionView {
                let cellColor = collectionView.dequeueReusableCell(withReuseIdentifier: cellIds[indexPath.item], for: indexPath)
                
                return cellColor
            } else {
                let cellTag = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
                cellTag.removeDelegate = self
                cellTag.index = indexPath.item
                cellTag.labelEmotionCell.text = pin.tags[indexPath.item].tag
                cellTag.layer.borderColor = UIColor.red.cgColor
                cellTag.layer.borderWidth = 1
                return cellTag
            }
        }
    
} // end extension AddFeelingViewController
    

extension AddFeelingViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            
            return 5
            
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == self.colorCollectionView {
                let cellSizes = Array( repeatElement(CGSize(width:(collectionView.bounds.width - 45)/10, height:(collectionView.bounds.width - 45)/10), count: 10))
                return cellSizes[indexPath.item]
            } else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
                var size:CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//                size.height += 10
//                size.width += 15
                print("\(size)")
                return size
            }
        }
    
} // end extension AddFeelingViewController


extension AddFeelingViewController: UITextViewDelegate {
    
    func setTextView() {
        
        textViewThoughts.text = "Conte seus pensamentos"
        textViewThoughts.textColor = .lightGray
        textViewThoughts.returnKeyType = .done
    }
    
    //  MARK: PlacehoulderTextView
    //  Apaga o placeholder e altera a cor da letra quando identificar digitação
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Conte seus pensamentos" {
            textView.text = nil
            textView.textColor = .black
        }
    }
    // Não sei o que faz
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    // Reescreve o placeholder caso não haja nada escrito na textView
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Conte seus pensamentos"
            textView.textColor = UIColor.lightGray
        }
    }
    
} // end extension AddFeelingViewController



