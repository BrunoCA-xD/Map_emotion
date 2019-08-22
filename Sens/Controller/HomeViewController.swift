//
//  HomeViewController.swift
//  Sens
//
//  Created by Rodrigo Takumi on 22/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var ref = Database.database().reference()
        let userId = Auth.auth().currentUser?.uid
        print(userId!)
        
        let db = Firestore.firestore()
        
        db.collection("users").whereField("uid", isEqualTo: userId!).getDocuments(completion: {(snapshot,err) in
            if let err = err {
                print("deu erro nessa merda")
            }else{
                var d = snapshot?.documents.first
                let a = d?.data()
                print(a?.index(forKey: "lastname"))
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
