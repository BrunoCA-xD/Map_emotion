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

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, HandleMapSearch, UIPopoverPresentationControllerDelegate {
    
    @IBAction func tapGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began{
            let touchPoint: CGPoint = sender.location(in: mapView)
            let newCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let addFeelingViewController = storyboard?.instantiateViewController(withIdentifier:
                "addFeelingRootNavController") as? UINavigationController
            let addFeelingView = addFeelingViewController?.viewControllers[0] as? AddFeelingViewController
            addFeelingView?.userLocation = userLocation
            addFeelingView?.touchedLocation = newCoordinate
            
            present(addFeelingViewController!,animated: true)
        }
    }
    @IBAction func AddFeelingPressed(_ sender: Any) {
        
        
        let addFeelingViewController = storyboard?.instantiateViewController(withIdentifier:
            "addFeelingRootNavController") as? UINavigationController
        let addFeelingView = addFeelingViewController?.viewControllers[0] as? AddFeelingViewController
        addFeelingView?.touchedLocation = nil
        addFeelingView?.userLocation = userLocation
        
        present(addFeelingViewController!,animated: true)
        
    }
    func dropPinZoomIn(placemark: MKPlacemark) {
        //
    }
    

//    var annotations: [MKPointAnnotation] = []
//    var emojis: [EmotionPin] = []
    var pins = [Pin]()
    
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    
    let user = User()
    var count = 0
    var infoPin = Pin()
    let emotionPin = EmotionPin()
    var userLocation:CLLocationCoordinate2D! = nil

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.standard // o que isso faz?
        
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
                    let emotionPin = EmotionPin()
                    
                    if let coords = document.get("location") {
                        let point = coords as! GeoPoint
                        emotionPin.location.latitude = point.latitude
                        emotionPin.location.longitude = point.longitude
                    }
                    emotionPin.testimonial = document.get("testimonial") as! String
                    emotionPin.color = document.get("color") as! String
                    emotionPin.user = document.get("user") as! String
                    emotionPin.icon = document.get("icon") as! String
                    
                    let stringEmotionTag = document.get("tags") as! [String]
                    
                    for tag in stringEmotionTag {
                        emotionPin.tags.append(EmotionTag(tag: tag))
                    }
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = emotionPin.location
                    annotation.title = emotionPin.color
                    annotation.subtitle = emotionPin.user
                    
//                    self.pins.emotionPin.append(self.emotionPin)
                    self.pins.append(Pin(emotionPin: emotionPin, infoAnnotation: annotation))
//                    self.annotations.append(annotation)
//                    self.emojis.append(emotionPin)
                    
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
    
//    private func registerAnnotationViewClasses() {
//        mapView.register(CustomAnnotation.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        userLocation = center
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors " + error.localizedDescription)
    }
    
//    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        print(#function)
//    }
    
    // Called when the annotation was added
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "image"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            for i in self.pins {
                if i.infoAnnotation.title == annotation.title {
                    pinView?.image = i.emotionPin.icon.image()
                }
            }
            
            
            let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = rightButton as? UIView
        }
        else {
            pinView?.annotation = annotation
        }
        count += 1
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let capital = view.annotation
        
        for i in pins {
            if i.infoAnnotation.title == capital?.title {
                self.infoPin = i as! Pin
//                self.infoTitle = i.title as! String
//                self.infoColor = i.subtitle as! String
            }
        }
        
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "description", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
            
            if segue.identifier == "description",
                let child01 = segue.destination as? DetailPin {
//                child01.titlePintext = self.infoTitle
//                child01.observacoesPintext = self.infoColor
                child01.detailPin = self.infoPin
            }
        
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
