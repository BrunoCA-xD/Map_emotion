//
//  UserDAO.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 13/09/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class UserDAO {
    
    let db = Firestore.firestore()

    func retriveCurrUser(completion: @escaping (User?, Error?) -> Void)  {
        let user: User = User()
        
        if let currUser = Auth.auth().currentUser{
            user.id = currUser.uid
            if let email = currUser.email{
                user.email = email
            }
        }
        
        db.collection("users").whereField("uid", isEqualTo: user.id).getDocuments(completion: {(snapshot,err) in
            if let err = err {
                print("\(err.localizedDescription)")
                completion(nil, err)
            } else{
                
                var dic = snapshot?.documents.first?.data()
                user.name = dic?["firstname"] as! String
                user.lastName = dic?["lastname"] as! String
                let timestamp: Timestamp = dic?["birthDate"] as! Timestamp
                user.birthDate = timestamp.dateValue()
                
                completion(user,nil)
            }
        })
        
       // return user;
    }
    
    func profileMarkers(userId: String) -> (Int?,Int,Int){
        var pins: Int? = 0
        db.collection("pins").whereField("user", isEqualTo: userId).getDocuments { (snap, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            } else {
                for s in snap!.documents{
                    s
                }
               pins = snap?.documents.count
            }
        }
        
        return (pins,1,2)
    }
}
