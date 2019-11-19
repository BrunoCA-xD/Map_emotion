//
//  EmotionPinDAO.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 15/11/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation
import FirebaseFirestore

class EmotionPinDAO: GenericFirebase {
    
    let collectionName = "pins"
    
    
    func save(emotionPin: EmotionPin) {
        if let pinID = emotionPin.id{
            db.collection(collectionName).document(pinID).setData(emotionPin.representation)
        }else {
            let doc = db.collection(collectionName).document()
            emotionPin.id = doc.documentID
            doc.setData(emotionPin.representation)
        }
    }
    
    func listAll(completion:@escaping ([EmotionPin]?,Error?) -> ()){
        db.collection(collectionName).getDocuments { (querySnapshot, error) in
            self.handleDocuments(querySnapshot, error, completion: completion)
            
        }
    }
    
    func list(ByField field: EmotionPinFields, withValueEqual value: String, completion:@escaping ([EmotionPin]?,Error?) -> ()){
        db.collection(collectionName).whereField(field.rawValue, isEqualTo: value).getDocuments { (querySnapshot, error) in
            self.handleDocuments(querySnapshot, error, completion: completion)
        }
        
    }
}
