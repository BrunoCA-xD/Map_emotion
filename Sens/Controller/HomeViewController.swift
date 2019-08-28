//
//  HomeViewController.swift
//  Sens
//
//  Created by Rodrigo Takumi on 22/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class HomeViewController: UIViewController, CLLocationManagerDelegate, HandleMapSearch {
    
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        //
    }
    

    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    let user = User()
    let emotionPin = EmotionPin()

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    var a = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Cofiguração map
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
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
        
        db.collection("pins").getDocuments() { (snapshot,error) in
            if let error = error {
                print("Error getting documents: \(error)")
            }else{
                for document in snapshot!.documents {
                    if let coords = document.get("location") {
                        let point = coords as! GeoPoint
                        self.emotionPin.location.latitude = point.latitude
                        self.emotionPin.location.longitude = point.longitude
                    }
                    self.emotionPin.testimonial = document.get("testimonial") as! String
                    self.emotionPin.color = document.get("color") as! String
                    self.emotionPin.user = document.get("user") as! String
                    self.emotionPin.tags = document.get("tags") as! [String]
//                    self.emotionPin.location = document.data()["location"] as! GeoPoint
                    
                    
                    //Por que não funciona????????
//                    if let testimonial = document.data()["testimonial"] {
//                         if let color = document.data()["color"] as? String {
//                            print("Location: \(testimonial); \(color)")
//                        }
//                    }
                    let annotation = MKPointAnnotation()

                    annotation.coordinate = self.emotionPin.location
                    annotation.title = self.emotionPin.color
                    annotation.subtitle = self.emotionPin.user
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
        
        //SearchBar + search result's tableView
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors " + error.localizedDescription)
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
}
