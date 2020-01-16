//
//  AddFeelingViewController.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 25/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CoreLocation

class AddFeelingViewController: UIViewController, UITextFieldDelegate{
    //MARK: Variables
    var tagText = false
    var cardViewController: EmojiPickerViewController!
    var visualEffectView: UIVisualEffectView!
    var cardHeight: CGFloat = 0
    let cardHandleAreaHeight: CGFloat = 60
    var pin: EmotionPin = EmotionPin()
    var cellTagIds: [String] = []
    var touchedLocation: CLLocationCoordinate2D! = nil
    var userLocation: CLLocationCoordinate2D! = nil
    var user: User! = nil
    let colors = ["#000000","#FFFFFF","#FF0000","0085FF","FFE600","21E510","FF8A00","DB00FF","AE6027"]
    let emotionPinDAO = EmotionPinDAO()
    
    var selectCompletion: (() -> Void)? = nil
    
    //MARK: IBOutlet
    @IBOutlet weak var addTagButton: UIButton!
    @IBOutlet weak var addEmojiButton: UIButton!
    @IBOutlet weak var saveButtonArea: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var anonSwitch: UISwitch!
    @IBOutlet weak var scrollHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tappedLocationRadioButton: RadioButton!
    @IBOutlet weak var tappedLocationlabel: UILabel!
    @IBOutlet weak var userLocationRadioButton: RadioButton!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var textViewThoughts: UITextView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var emojiSelectedImageView: UIImageView!
    @IBOutlet weak var testimonialTextView: UITextView!
    
    //MARK: IBAction
    @IBAction func addEmotionTagPressed(_ sender: Any) {
        if let tagText = tagTextField.text{
            if tagText.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
                pin.tags.append(tagText)
                tagCollectionView.reloadData()
                tagTextField.text = ""
            }
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectEmojiPressed(_ sender: Any) {
        openCard()
    }
    
    @IBAction func clearSelectedColor(_ sender: Any) {
        guard let selectedItems = colorCollectionView.indexPathsForSelectedItems else { return }
        for index in selectedItems{
            colorCollectionView.deselectItem(at: index, animated: true)
        }
        pin.color = nil
    }
    
    @IBAction func saveEmotionPressed(_ sender: Any) {
        //color, icon and tags are managed by events
        
        if let testimonialText = testimonialTextView.text {
            pin.testimonial = testimonialText
        }
        pin.user = user.id!
        
        pin.userName = anonSwitch.isOn ? "Anonimo" : user.name
        
        if tappedLocationRadioButton.isOn{
            pin.location = touchedLocation
        }else if userLocationRadioButton.isOn{
            pin.location = userLocation
        }
        
        emotionPinDAO.save(emotionPin: pin)
        
        self.dismiss(animated: true, completion: selectCompletion)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewUtilities.setupBorderShadow(inView: saveButtonArea)
//        saveButtonArea.layer.borderColor = UIColor.red.cgColor
//        saveButtonArea.layer.borderWidth = 2.0
        saveButtonArea.layer.cornerRadius = 16.0
        saveButtonArea.layer.backgroundColor = try? Utilities.hexStringToUIColor(hex: "EDEDED").cgColor
        
        addTagButton.layer.borderColor = UIColor(red: 130/255.0, green: 71/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        addEmojiButton.layer.borderColor = UIColor(red: 130/255.0, green: 71/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        
        hideKeyboardWhenTappedAround()
        setTextView()
        colorCollectionView.allowsMultipleSelection = false
        tappedLocationRadioButton.alternateButton = [userLocationRadioButton]
        userLocationRadioButton.alternateButton = [tappedLocationRadioButton]
        
        tagTextField.delegate = self
        if touchedLocation == nil{
            userLocationRadioButton.isOn = true
            tappedLocationRadioButton.isOn = false
            tappedLocationlabel.superview?.isHidden = true
            scrollHightConstraint.constant = 950
        }else {
            scrollHightConstraint.constant = 1020
            tappedLocationRadioButton.isOn = true
            tappedLocationlabel.superview?.isHidden = false
            Utilities.recoveryAddress(locationCoordinate: touchedLocation,completion:{(address,err) in
                if (err == nil){
                    self.tappedLocationlabel.text = address
                }
            })
        }
        Utilities.recoveryAddress(locationCoordinate: userLocation,completion:{(address,err) in
            if (err == nil){
                self.userLocationLabel.text = address
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && self.tagText == false {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0  {
            self.view.frame.origin.y = 0
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.tagText = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.tagText = false
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
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: cardHeight)
        
        cardViewController.view.clipsToBounds = true
        
        UIView.animate(withDuration: 0.6, animations: {
            self.cardViewController.view.frame.origin.y = cardY
            self.visualEffectView.effect = UIBlurEffect(style: .dark)
            self.cardViewController.view.layer.cornerRadius = 30
        }, completion: nil)
//        visualEffectView.effect = UIBlurEffect(style: .dark)
//        cardViewController.view.layer.cornerRadius = 30
    }
    
} // end Class AddFeelingViewController

extension AddFeelingViewController: EmojiPickerViewBackButtonDelegate {
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
            emojiSelectedImageView.image = emojiCode.image(sizeSquare: 100)
            pin.icon = emojiCode // seta o icon do pin
        }
    }
}

extension AddFeelingViewController: RemoveDelegate {
    func removeButtonPressed(_ index: Int) {
        pin.tags.remove(at: index)
        tagCollectionView.reloadData()
    }
}

extension AddFeelingViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            //Selecionar a cor
            if collectionView == self.colorCollectionView{
                let cellColor = collectionView.cellForItem(at: indexPath) as! ColorCollectionViewCell
                pin.color = cellColor.color
            }
        }
} // end extension AddFeelingViewController

extension AddFeelingViewController: UICollectionViewDataSource {
        
        func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == self.colorCollectionView {
                return colors.count
            } else {
                return pin.tags.count
            }
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == self.colorCollectionView {
                let cellColor = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
                
                    cellColor.configCell(color: colors[indexPath.item])
                
                return cellColor
            } else {
                let cellTag = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmotionTagCollectionViewCell
                cellTag.removeDelegate = self
                cellTag.index = indexPath.item
                cellTag.labelEmotionCell.textColor = try? Utilities.hexStringToUIColor(hex: "8247FF")
                cellTag.labelEmotionCell.text = pin.tags[indexPath.item].capitalized
                cellTag.layer.borderColor = try? Utilities.hexStringToUIColor(hex: "8247FF").cgColor
                cellTag.layer.cornerRadius = 4
                cellTag.layer.borderWidth = 1
                return cellTag
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



