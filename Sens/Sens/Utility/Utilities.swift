//
//  Utilities.swift
//  Sens
//
//  Created by Rodrigo Takumi on 22/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public class Utilities {
    
    func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$")
        return passwordTest.evaluate(with: password)
    }
    
    static func hexStringToUIColor (hex:String) throws -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6 && (cString.count) != 3) {
            throw ColorConversionError.hexCodeInvalid
        }
        var hexString = ""
        if ((cString.count) == 3) {
            cString.forEach { (c) in
                hexString.append(c)
                hexString.append(c)
            }
            
        }else {
            hexString = cString
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func recoveryAddress(locationCoordinate:CLLocationCoordinate2D, completion: @escaping (String?, Error?) -> Void) {
        let location:CLLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        var address = ""
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(locationDetais, error) in
            if error == nil{
                if let locationData = locationDetais?.first {
                    
                    var thoroughfare = ""// rua
                    if let thoroughfareValue = locationData.thoroughfare{
                        thoroughfare = thoroughfareValue
                    }
                    
                    var subThoroughfare = "" //numero
                    if let subThoroughfareValue = locationData.subThoroughfare{
                        subThoroughfare = subThoroughfareValue
                    }
                    
                    var locality = "" //cidade
                    if let localityValue = locationData.locality{
                        locality = localityValue
                    }
                    
                    var subLocality = ""// bairro
                    if let subLocalityValue = locationData.subLocality{
                        subLocality = subLocalityValue
                    }
                    
                    var country = ""
                    if let countryValue = locationData.country{
                        country = countryValue
                    }
                    
                    var administrativeArea = "" //(UF)
                    if let administrativeAreaValue = locationData.administrativeArea{
                        administrativeArea = administrativeAreaValue
                    }
                    
                    address = thoroughfare + ", "
                        + subThoroughfare + " - "
                        + subLocality + " - "
                        + locality + " - "
                        + administrativeArea + " - "
                        + country
                    
                    completion(address,nil)
                }else{
                    print("deu erro nessa porra")
                    completion(nil,error)
                }
            }
        })
    }
}
