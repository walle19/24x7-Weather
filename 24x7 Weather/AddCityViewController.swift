//
//  AddCityViewController.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 22/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddCityViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    
    var city: City!
    
    private var customAnnotation: CustomPointAnnotation!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var searchController:UISearchController!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
  
    private struct Constants {
        static let PinImageName = "pin"
        static let PinTitle = "Click Save!"
        
        static let AnnotationViewIdentifier = "pin"
    }
    
    // MARK: View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // Types of map
        mapView.mapType = .hybrid
        /*
         mapView.mapType = .hybridFlyover
         mapView.mapType = .satellite
         mapView.mapType = .satelliteFlyover
         mapView.mapType = .standard
         */
        
        // Add long gesture to add pins
        addLongPressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set custom back button
        self.navigationItem.hidesBackButton = true
        let backImage = #imageLiteral(resourceName: "back_icon")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButton))
    }
    
    func backButton() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Map methods
    
    fileprivate func addLongPressGesture(){
        let longPressRecogniser:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self , action:#selector(handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    func handleLongPress(_ gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state != .began{
            return
        }
        
        if (mapView.annotations.count > 0) {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        let touchPoint:CGPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate:CLLocationCoordinate2D =
            mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        customAnnotation = CustomPointAnnotation()
        customAnnotation.coordinate = touchMapCoordinate
        customAnnotation.title = Constants.PinTitle
        customAnnotation.pinCustomImageName = Constants.PinImageName
        
        mapView.addAnnotation(customAnnotation)
        centerMap(touchMapCoordinate)
    }
    
    // Bring the mapView to center
    fileprivate func centerMap(_ center:CLLocationCoordinate2D){
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let newRegion = MKCoordinateRegion(center:center , span:span)
        mapView.setRegion(newRegion, animated: true)
    }
    
    // MARK: MapView Delegate method
    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        if (annotation is MKUserLocation) {
            return nil
        }
        
        // Custom pin
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.AnnotationViewIdentifier)
        
        if annotationView != nil {
            annotationView?.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewIdentifier)
            annotationView?.canShowCallout = true
        }
        
        let customPointAnnotation = annotation as! CustomPointAnnotation
        annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
        annotationView?.isDraggable = true
        annotationView?.rightCalloutAccessoryView = UIButton(type: .contactAdd)
        
        return annotationView
    }
    
    /*
     Called when annotation view selected
     */
    internal func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pinLocation = CLLocation(latitude: view.annotation!.coordinate.latitude, longitude: view.annotation!.coordinate.longitude)

        // Get city/state info
        Helper.getAddressFor(location: pinLocation, completionHandler: {(city) -> Void in
            self.customAnnotation.title = city
        })
    }
    
    /*
     Called when annotation view is dragged
     */
    internal func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == MKAnnotationViewDragState.ending {
            
            let coordinate: CLLocationCoordinate2D = view.annotation!.coordinate
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            // Get city/state info
            Helper.getAddressFor(location: location, completionHandler: {(city) -> Void in
                self.customAnnotation.title = city
            })
        }
    }
    
    /*
     Called when accessory control tapped
     */
    internal func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("accessory called")
        
        if customAnnotation.title != "City" {
            city = City(name: customAnnotation.title!)
            if City.saveCity(city: city) {
                self.performSegue(withIdentifier: "unwindToCities", sender: self)
            }
        }
    }
    
    // MARK: Search
    
    @IBAction func showSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0 {
            self.mapView.removeAnnotations(self.mapView.annotations)
        }

        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }

            self.customAnnotation = CustomPointAnnotation()
            self.customAnnotation.title = searchBar.text
            self.customAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            let annotationView = MKAnnotationView(annotation: self.customAnnotation, reuseIdentifier: Constants.AnnotationViewIdentifier)
            self.customAnnotation.pinCustomImageName = Constants.PinImageName

            self.mapView.centerCoordinate = self.customAnnotation.coordinate
            self.mapView.addAnnotation(annotationView.annotation!)
            
            self.centerMap(self.customAnnotation.coordinate)
        }
    }
}
