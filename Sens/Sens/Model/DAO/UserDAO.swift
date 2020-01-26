//
//  NewUserDAO.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 17/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

class UserDAO: GenericDAO {
    
    
    func retrieveUser(id:Int64, completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ()) {
        self.genericGet(to: "\(apiURL.getUsers)/\(id)", completion: completion)
    }
    
    
       //METODO INCOMPLETO importado de quando trabalhabamos com firebase
    //    func profileMarkers(userId: String) -> (Int?,Int,Int){
    //        var pins: Int? = 0
    //        db.collection("pins").whereField("user", isEqualTo: userId).getDocuments { (snap, error) in
    //            if let error = error{
    //                print("\(error.localizedDescription)")
    //            } else {
    //
    //                pins = snap?.documents.count
    //            }
    //        }
    //
    //        return (pins,1,2)
    //    }
}


