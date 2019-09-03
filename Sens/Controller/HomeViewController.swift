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
    
    var customPointAnnotation: [CustomPointAnnotation] = []  //Pós entrega
    var infoCustomPointAnnptation : CustomPointAnnotation = CustomPointAnnotation()
    
    @IBOutlet weak var addPinButton: UIButton!
    
    @IBAction func tapGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began{
            let touchPoint: CGPoint = sender.location(in: mapView)
            let newCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let addFeelingViewController = storyboard?.instantiateViewController(withIdentifier:
                "addFeelingRootNavController") as? UINavigationController
            let addFeelingView = addFeelingViewController?.viewControllers[0] as? AddFeelingViewController
            addFeelingView?.userLocation = userLocation
            addFeelingView?.touchedLocation = newCoordinate
            addFeelingView?.user = self.user
            
            present(addFeelingViewController!,animated: true)
        }
    }
    @IBAction func AddFeelingPressed(_ sender: Any) {
        
        
        let addFeelingViewController = storyboard?.instantiateViewController(withIdentifier:
            "addFeelingRootNavController") as? UINavigationController
        let addFeelingView = addFeelingViewController?.viewControllers[0] as? AddFeelingViewController
        addFeelingView?.touchedLocation = nil
        addFeelingView?.userLocation = userLocation
        addFeelingView?.user = self.user
        present(addFeelingViewController!,animated: true)
        
    }
    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: placemark.coordinate, span: mapView.region.span)
        mapView.setRegion(region, animated: true)
        
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
    let db = Firestore.firestore()

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addPinButton.layer.borderColor = UIColor(red: 130/255.0, green: 71/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.standard // o que isso faz?
        
        //Cofiguração map
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.user.id = Auth.auth().currentUser!.uid
        self.user.email = Auth.auth().currentUser!.email!
        
        
        
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
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            return nil
//        }
////        let p = annotation is CustomAnnotation
//
//        let reuseId = "image"
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
//        if pinView == nil {
//            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView?.canShowCallout = true
//            for i in self.customAnnotation {
//                if i.infoAnnotation.title == annotation.title {
//                    if i.infoAnnotation.subtitle == annotation.subtitle {
//                        if i.infoAnnotation.coordinate.latitude == annotation.coordinate.latitude {
//                            if i.infoAnnotation.coordinate.longitude == annotation.coordinate.longitude {
//                                pinView?.image = i.emotionPin.icon.image(sizeSquare: 30)
//                            }
//                        }
//                    }
//                }
//            }
//
//            let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
//            pinView?.rightCalloutAccessoryView = rightButton as? UIView
//        }
//        else {
//            pinView?.annotation = annotation
//        }
//        count += 1
//        return pinView
//    }
    //pós entrega
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

         let reuseIdentifier = "pin"
        //let p = annotation is CustomPointAnnotation
        if let customPointAnnotation = annotation as? CustomPointAnnotation {


            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            
                let rightButton = UIButton(type: .infoLight)
                rightButton.tag = customPointAnnotation.hash
            
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = rightButton
                
                for i in self.customPointAnnotation {
                    if i.pinId == customPointAnnotation.pinId{
                        annotationView?.image = i.icon.image(sizeSquare: 20)
                    }
                }
            } else {
                annotationView?.annotation = annotation
            }

            print("Colocando \(annotationView) \(annotation.coordinate)")

            return annotationView
        }

        print("Oops \(annotation)")
        return  MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)

    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        let capital = view.annotation as? CustomPointAnnotation
        
        for i in self.customPointAnnotation {
//            if i.infoAnnotation.title == capital?.title {
//                if i.infoAnnotation.subtitle == capital?.subtitle {
//                    if i.infoAnnotation.coordinate.latitude == capital?.coordinate.latitude {
//                        if i.infoAnnotation.coordinate.longitude == capital?.coordinate.longitude {
//                            self.infoPin = i as! Pin
//                        }
//                    }
//                }
//            }
            if i.pinId == capital?.pinId{
                self.infoCustomPointAnnptation = i
            }
//            if i.infoAnnotation.title == capital?.title {
//                self.infoPin = i as! Pin
////                self.infoTitle = i.title as! String
////                self.infoColor = i.subtitle as! String
//            }
        }
//        for i in self.customPointAnnotation {
//            if i.pinId == capital?.pinId{
//                self.infoPin = i as! Pin
//            }
//        }
        
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "description", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
            
            if segue.identifier == "description",
                let child01 = segue.destination as? DetailPin {
//                child01.titlePintext = self.infoTitle
//                child01.observacoesPintext = self.infoColor
                child01.detailPin = self.infoCustomPointAnnptation
            }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServices()
        
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
                    emotionPin.userName = document.get("userName") as! String
                    
                    print(emotionPin.icon)
                    
                    if let stringEmotionTag = document.get("tags") as? [String] {
                        emotionPin.tags = stringEmotionTag
                        
                    }
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = emotionPin.location
                    annotation.title = emotionPin.userName.capitalized
                    annotation.subtitle = emotionPin.tags[0]
                    
                    //                    self.pins.emotionPin.append(self.emotionPin)
                    self.pins.append(Pin(emotionPin: emotionPin, infoAnnotation: annotation))
                    //                    self.annotations.append(annotation)
                    //                    self.emojis.append(emotionPin)
                    
                    //Pós entrega
                    
                    let customAnnotation = CustomPointAnnotation()
                    customAnnotation.color = emotionPin.color
                    customAnnotation.icon = emotionPin.icon
                    customAnnotation.tags = emotionPin.tags
                    customAnnotation.pinId = document.documentID
                    customAnnotation.title = emotionPin.userName.capitalized
                    customAnnotation.subtitle = emotionPin.tags[0]
                    customAnnotation.coordinate = emotionPin.location
                    
                    self.customPointAnnotation.append(customAnnotation)
                    
                    OperationQueue.main.addOperation {
                        print("Adicionando pin")
                        self.mapView.addAnnotation(customAnnotation)
                    }
                   
                }
            }
        }
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
