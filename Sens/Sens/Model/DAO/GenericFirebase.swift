//
//  GenericFirebase.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 18/11/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation
import FirebaseFirestore



class GenericFirebase {
    let db = Firestore.firestore()
    
    func handleDocuments<T: DictionaryInterpreter>(_ querySnapshot: QuerySnapshot?, _ error: Error?, completion:@escaping ([T]?,Error?) -> ())  {
        if let err = error {
            completion(nil,err)
        }else if let snapshot = querySnapshot {
            let result = snapshot.documents.compactMap { (child) -> T? in
                if let converted = T.interpret(data: child.data() as NSDictionary) {
                    return converted
                }
                return nil
            }
            completion(result,nil)
        }else {
            completion(nil,nil)
        }
    }
    
    func handleSingleDocument<T: DictionaryInterpreter>(_ querySnapshot: DocumentSnapshot?, _ error: Error?, completion:@escaping (T?,Error?) -> ())  {
        if let err = error {
            completion(nil,err)
        }else if
            let snapshot = querySnapshot,
            let converted = T.interpret(data: snapshot.data()! as NSDictionary) {
            completion(converted,nil)
        }else{
            completion(nil,nil)
        }
    }
}
