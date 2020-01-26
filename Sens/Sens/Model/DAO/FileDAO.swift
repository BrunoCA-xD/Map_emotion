//
//  FileDAO.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 20/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation
import FirebaseStorage

class FileDAO {
    let storage = Storage.storage()
    
    func recoverProfileImage(profilePic:String, completion: @escaping (UIImage?,Error?) ->()) {
        
        storage.reference().child("profile/\(profilePic)").downloadURL { (url, err) in
            if let err = err {
                print(err.localizedDescription)
                completion(nil,err)
            }else {
                do {
                    let image = try UIImage(data: Data(contentsOf: url!))
                    completion(image,nil)
                } catch {
                    print("erro na imagem")
                }
            }
        }
    }
}
