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
import FirebaseStorage

class UserDAO: GenericFirebase {
    let storage = Storage.storage()
    let auth = Auth.auth()
    let collectionName = "users"
    
    
    var currUserID: String? {
        get {
            return auth.currentUser?.uid
        }
    }
    
    func retriveCurrUser(completion: @escaping (User?, Error?) -> Void)  {
        let user: User = User()
        
        if let currUserID = currUserID{
            user.id = currUserID
        }
        db.collection(collectionName).document(user.id!).getDocument { (snapshot, err) in
            self.handleSingleDocument(snapshot, err, completion: completion)
        }
    }
    //METODO INCOMPLETO
    func profileMarkers(userId: String) -> (Int?,Int,Int){
        var pins: Int? = 0
        db.collection("pins").whereField("user", isEqualTo: userId).getDocuments { (snap, error) in
            if let error = error{
                print("\(error.localizedDescription)")
            } else {
                
                pins = snap?.documents.count
            }
        }
        
        return (pins,1,2)
    }
    
    func signUp(user: User, password: String, completion: @escaping (User?,Error?) ->()){
        auth.createUser(withEmail: user.email, password: password) { (result, err) in
            // Check for errors
            if err != nil {
                // There was an error creating the user
                print("Error creating user")
                completion(nil,err)
            }else {
                user.id = result!.user.uid
                self.db.collection(self.collectionName).document(user.id!).setData(user.representation)
                completion(user,nil)
            }
        }
    }
    
    func signIn(email:String, password: String, completion: @escaping () -> ()){
        auth.signIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print(error.localizedDescription)
                print("Senha incorreta")
            }
            else {
                completion()
            }
        }
    }
    
    
    func find(inField field: UserFields, withValueEqual value: String, completion: @escaping ([User]?,Error?) ->()){
        db.collection(collectionName).whereField(field.rawValue, isEqualTo: value).getDocuments { (snapshot, err) in
            self.handleDocuments(snapshot,err,completion: completion)
        }
    }
    
    
    
    func recoverUserProfileImage(profilePic:String, completion: @escaping (UIImage?,Error?) ->()) {
        
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
