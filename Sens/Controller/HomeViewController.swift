//
//  HomeViewController.swift
//  Sens
//
//  Created by Rodrigo Takumi on 22/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    let user = User()
    @IBOutlet weak var mapView: MKMapView!
     let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.user.id = Auth.auth().currentUser!.uid
        self.user.email = Auth.auth().currentUser!.email!
        
        let db = Firestore.firestore()
        
        db.collection("users").whereField("uid", isEqualTo: self.user.id).getDocuments(completion: {(snapshot,err) in
            if let err = err {
                print("deu erro nessa merda")
            }else{
                
                var dic = snapshot?.documents.first?.data()
                self.user.name = dic?["firstname"] as! String
                self.user.lastName = dic?["lastname"] as! String
                let timestamp: Timestamp = dic?["birthDate"] as! Timestamp
                self.user.birthDate = timestamp.dateValue()
                
            }
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServices()
    }
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            print("asd")
            checkLocationAuthorization()
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // do Map stuff
            mapView.showsUserLocation = true
//            centerViewOnUserLocation()
            break
        case .denied:
            let alertController = UIAlertController(title: "Location permission", message: "This app needs permission to access your location. Please, turn on", preferredStyle: .alert)
            let allowAction = UIAlertAction(title: "Open settings", style: .default, handler: { (alert) in
                if let configsURL = NSURL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(configsURL as URL)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(allowAction)
            alertController.addAction(cancelAction)
            
            present(alertController,animated: true)
            break
        case .notDetermined:
            //
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            //
            break
        @unknown default:
            break
        }
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
