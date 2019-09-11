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

    // MARK: Atributes
    var pins = [EmotionPin]()
    var resultSearchController:UISearchController? = nil
    var selectedPlace:MKPlacemark? = nil
    var count = 0
    var infoPin = Pin()
    var emotionPin = EmotionPin()
    var userLocation:CLLocationCoordinate2D! = nil
    
    let placePinIdentifier:String = "placePin"
    let emotionPinIdentifier:String = "emotionPin"
    var user: User! = nil
    let db = Firestore.firestore()
    let locationManager = CLLocationManager()
    
    // MARK: Outlets
    @IBOutlet weak var addPinButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func tapGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began{
            let touchPoint: CGPoint = sender.location(in: mapView)
            let newCoordinate: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
           openAddFeeling(coordinate: newCoordinate)
        }
    }
    @IBAction func AddFeelingPressed(_ sender: Any) {
        openAddFeeling(coordinate: nil)
        
    }
    
    func openAddFeeling( coordinate:CLLocationCoordinate2D? ){
        let addFeelingViewController = storyboard?.instantiateViewController(withIdentifier:
            "addFeelingRootNavController") as? UINavigationController
        let addFeelingView = addFeelingViewController?.viewControllers[0] as? AddFeelingViewController
        addFeelingView?.userLocation = userLocation
        addFeelingView?.user = self.user
        if coordinate != nil {
            addFeelingView?.touchedLocation = coordinate
        }
        
        present(addFeelingViewController!,animated: true)
        
    }
    
    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPlace = placemark
        let annotation = EmotionAnnotation()
        annotation.pin = nil
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        var annotations: [MKAnnotation] = []
        
        mapView.annotations.forEach { (annon) in
            if let emotionAnnotation = annon as? EmotionAnnotation {
                if emotionAnnotation.pin == nil{
                    annotations.append(annon)
                }
            }
        }
        
        mapView.removeAnnotations(annotations)
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: placemark.coordinate, span: mapView.region.span)
        mapView.setRegion(region, animated: true)
        
    }
    
 

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = User()
        addPinButton.layer.borderColor = UIColor(red: 130/255.0, green: 71/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.standard // o que isso faz?
        
        //Cofiguração map
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        if let currUser = Auth.auth().currentUser{
            self.user.id = currUser.uid
            if let email = currUser.email{
                self.user.email = email
            }
        }
        var color = Utilities.hexStringToUIColor(hex: "FFFFFF")
        tabBarController?.tabBar.unselectedItemTintColor = color.withAlphaComponent(0.5)
        
        
        
        db.collection("users").whereField("uid", isEqualTo: self.user.id).getDocuments(completion: {(snapshot,err) in
            if let err = err {
                print("\(err.localizedDescription)")
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
        searchBar.placeholder = "Procure por locais"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
            
            if segue.identifier == "description",
                let child01 = segue.destination as? DetailPinViewController {
                child01.detailPin = emotionPin
            }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationServices()
        db.collection("pins").getDocuments { (snapshot, error) in
            if error != nil{
                print("error \(String(describing: error?.localizedDescription))")
            }else {
                for document in snapshot!.documents {
                    let pin: EmotionPin = EmotionPin()
                    
                    guard
                        let coords = document.get("location") as? GeoPoint,
                        let user = document.get("user") as? String else {return}
                    
                    pin.location.latitude = coords.latitude
                    pin.location.longitude = coords.longitude
                    pin.user = user
                    pin.testimonial = document.get("testimonial") as? String ?? ""
                    pin.color = document.get("color") as? String ?? ""
                    pin.icon = document.get("icon") as? String ?? ""
                    pin.userName = document.get("userName") as? String  ?? ""
                    
                    if let stringEmotionTag = document.get("tags") as? [String] {
                        pin.tags = stringEmotionTag
                    }
                    
                    let annotationToAdd = EmotionAnnotation()
                    annotationToAdd.pin = pin
                    annotationToAdd.coordinate = pin.location
                    annotationToAdd.title = pin.userName.capitalized
                    annotationToAdd.subtitle = pin.tags[0].capitalized
                
                    OperationQueue.main.addOperation {
                        self.mapView.addAnnotation(annotationToAdd)
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
            let alertController = UIAlertController(title: "Permissão de localização", message: "Este aplicativo precisa de acesso à sua localização. Por favor, habilite", preferredStyle: .alert)
            let allowAction = UIAlertAction(title: "Abrir configurações", style: .default, handler: { (alert) in
                if let configsURL = NSURL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(configsURL as URL)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            
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
            break
        @unknown default:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        if annotation is MKUserLocation{
            return nil
        }
        
        var reuseId: String!
        var detailsButtonType: UIButton.ButtonType!
        var pinImage: UIImage!
        guard let emotionAnnotation = annotation as? EmotionAnnotation else { return nil }
        
        
        if let pin = emotionAnnotation.pin{
            reuseId = emotionPinIdentifier
            detailsButtonType = UIButton.ButtonType.infoLight
            pinImage = pin.icon.image(sizeSquare: 20)
        } else {
            reuseId = placePinIdentifier
            detailsButtonType = UIButton.ButtonType.contactAdd
            pinImage = "📍".image(sizeSquare: 20)
        }
        
        let detailsButton = UIButton(type: detailsButtonType)
        detailsButton.tag = emotionAnnotation.hash
        
        let annotationView: EmotiPinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? EmotiPinAnnotationView ?? EmotiPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)

        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = detailsButton
        annotationView.image = pinImage
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let emotionAnnotation = view.annotation as? EmotionAnnotation{
                guard let emotionPin = emotionAnnotation.pin  else {
                    openAddFeeling( coordinate: emotionAnnotation.coordinate)
                    return
                }
                self.emotionPin = emotionPin
                performSegue(withIdentifier: "description", sender: self)
            }
        }
    }
}
