//
//  GenericDAO.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 20/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

class GenericDAO {
    
    func genericPost(with jsonData:Data, to urlReceived:String? , completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ()){
        guard let urlUnwrapped = urlReceived,
            let url = URL(string: urlUnwrapped) else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        
        execRequest(request: request, completion: completion)
    }
    
    func genericGet(to urlReceived:String? , completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ()){
        guard let urlUnwrapped = urlReceived,
            let url = URL(string: urlUnwrapped) else {return}
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        execRequest(request: request, completion: completion)
    }
    
    
    func execRequest(request: URLRequest, completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ()) {
        var requesting = request
        requesting.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: requesting) {
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
