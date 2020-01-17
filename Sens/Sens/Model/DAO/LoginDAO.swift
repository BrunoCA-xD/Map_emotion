//
//  LoginDAO.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 17/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation


class LoginDAO {
    
    func signIn(jsonData:Data, completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ()){
        
        guard let url = URL(string: apiURL.signIn) else {return}
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            let httpResponse = response as? HTTPURLResponse
            if error == nil {
                completion(data,httpResponse,nil)
            }else {
                completion(nil,httpResponse,error)
            }
        }.resume()
    }
    
    func signUp(jsonData:Data, completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ()){
        guard let url = URL(string: apiURL.signUp) else {return}
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            let httpResponse = response as? HTTPURLResponse
            
            if error == nil {
                completion(data,httpResponse,nil)
            }else {
                completion(nil,httpResponse,error)
            }
        }.resume()
        
        
    }
}
