//
//  EmotionService.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 20/01/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation

class EmotionService: GenericService {
    let emotionDAO = EmotionPinDAO()
    
    
    func save(pin: EmotionPin, completion: @escaping (EmotionPin?, PinError.id?) -> ()) {
        
        let jsonData = try! encoder.encode(pin)
        
        emotionDAO.save(jsonData: jsonData) { (data, response, error) in
            if error == nil {
                guard let data = data else {return}
                if(response?.statusCode == 201) {
                    let pin = try! self.decoder.decode(EmotionPin.self, from: data)
                    completion(pin,nil)
                }else if (response?.statusCode == 400) {
                    let error = try! self.decoder.decode(PinError.self, from: data)
                    let errorCode = error.errorCode
                    switch errorCode {
                    case 1:
                        completion(pin,.missingTags)
                        break
                    case 2:
                        completion(pin,.missingUser)
                        break
                    case 3:
                        completion(pin,.missingLocation)
                        break
                    case 4:
                        completion(pin,.missingRepresentation)
                        break
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func listAll(completion: @escaping ([EmotionPin]?, Error?) -> ()) {
    
        emotionDAO.listAll { (data, response, error) in
            if error == nil {
                if response?.statusCode == 200 {
                    guard let data = data else {
                        completion(nil, nil)
                        return
                    }
                    guard let pins = try? JSONDecoder().decode([EmotionPin].self, from: data) else {return}
                    
                    completion(pins,nil)
                }
            }
        }
    }
}
