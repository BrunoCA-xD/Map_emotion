//
//  HomeViewController.swift
//  Sens
//
//  Created by Rodrigo Takumi on 22/08/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class HomeViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    // MARK: Variables
    var resultSearchController:UISearchController? = nil
    var selectedPlace: MKPlacemark? = nil
    var selectedEmotionPin: EmotionPin? = nil
    var userLocation:CLLocationCoordinate2D! = nil
    var user: User! = nil
    var region: MKCoordinateRegion! = nil
    
    let placePinIdentifier:String = "placePin"
    let emotionPinIdentifier:String = "emotionPin"
    let locationManager = CLLocationManager()
    let userDAO = UserDAO()
    let pinDAO = EmotionPinDAO()
    
    // MARK: Outlets
    @IBOutlet weak var addPinButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tutorialView: UIView!
    
    // MARK: IBActions
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
    @IBAction func tutorialClosePressed(_ sender: Any) {
        tutorialView.removeFromSuperview()
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addPinButton.layer.borderColor = UIColor(red: 130/255.0, green: 71/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        setupLocationSearch()
        
        user = User()
        
        userDAO.retriveCurrUser { (user, err) in
            if let err = err {
                print(err.localizedDescription)
            }else {
                if let user = user {
                    self.user = user
                }
            }
        }
        listPins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLocationServices()
        if region != nil{
            mapView.region = region
        }
        listPins()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        region = mapView.region
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "description",
            let destinationVC = segue.destination as? DetailPinViewController {
            destinationVC.detailPin = selectedEmotionPin
        }
    }
    
    
    fileprivate func setupLocationManager(){
        self.mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func listPins() {
        pinDAO.listAll { (pins, err) in
            if let err = err {
                print(err.localizedDescription)
            }else if let pins = pins {
                pins.forEach { (pin) in
                    let annotationToAdd = EmotionAnnotation(pin: pin)
                    OperationQueue.main.addOperation {
                        self.mapView.addAnnotation(annotationToAdd)
                    }
                }
            }
        }
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
        addFeelingView?.selectCompletion = { self.listPins() }
        present(addFeelingViewController!,animated: true)
        
    }
    
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }
    }
    
}

extension HomeViewController: HandleMapSearch{
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPlace = placemark
        let annotation = EmotionAnnotation()
        annotation.pin = nil
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        removeOtherSearchPins()
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: placemark.coordinate, span: mapView.region.span)
        mapView.setRegion(region, animated: true)
        
    }
    
    fileprivate func removeOtherSearchPins(){
        let annotationList = mapView.annotations.compactMap { (annotation) -> MKAnnotation? in
            if let emotionAnnotation = annotation as? EmotionAnnotation {
                if emotionAnnotation.pin == nil{
                    return annotation
                }
            }
            return nil
        }
        mapView.removeAnnotations(annotationList)
    }
    
    fileprivate func setupLocationSearch() {
        //SearchBar + search result's tableView
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = NSLocalizedString("searchForPlace", comment: "")
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
}

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let emotionAnnotation = view.annotation as? EmotionAnnotation{
                guard let emotionPin = emotionAnnotation.pin  else {
                    openAddFeeling( coordinate: emotionAnnotation.coordinate)
                    return
                }
                self.selectedEmotionPin = emotionPin
                performSegue(withIdentifier: "description", sender: self)
            }
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
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {return}
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        userLocation = center
        
        let region = self.region ?? MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors " + error.localizedDescription)
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // do Map stuff
            mapView.showsUserLocation = true
            //            centerViewOnUserLocation()
            break
        case .denied:
            let alertController = UIAlertController(title: NSLocalizedString("locationPermissionTitle", comment: ""), message: NSLocalizedString("locationPermissionMessage", comment: ""), preferredStyle: .alert)
            let allowAction = UIAlertAction(title: NSLocalizedString("openConfig", comment: ""), style: .default, handler: { (alert) in
                if let configsURL = NSURL(string: UIApplication.openSettingsURLString){
                    UIApplication.shared.open(configsURL as URL)
                }
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
            
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
    
    
}
