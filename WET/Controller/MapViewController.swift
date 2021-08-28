//
//  MapViewController.swift
//  WET
//
//  Created by isaac k lee on 2021/04/29.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController:UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var myLocation:CLLocationCoordinate2D?
    var image:Restaurant? = nil
    
    //initial setting and annotation
    override func viewDidLoad() {
        super.viewDidLoad()
        caseLocationAuth()
        
        let annotation = MKPointAnnotation()
        annotation.title = image?.name
        annotation.coordinate = CLLocationCoordinate2D(latitude: (image?.coordinates.latitude)!, longitude: (image?.coordinates.longitude)!)
        mapView.addAnnotation(annotation)
    }

    //Show the cases for user authorization.
    //Only availble when authorized
    func caseLocationAuth(){
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        }else if status == .authorizedAlways{
            mapView.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }else if status == .authorizedWhenInUse{
            mapView.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    //zoom in to the location set to 10000 meter
    func focusLocation(with coordinate:CLLocationCoordinate2D){
        let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let region = MKCoordinateRegion.init(center:center,latitudinalMeters: 10000,longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
        
    }
    
}
//Update as user moves & Annotate user location
extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //check if lastLocation is not nil
        guard let lastLocation = locations.first else{return }
        
        if myLocation == nil {
            focusLocation(with:lastLocation.coordinate)
        }
        myLocation = lastLocation.coordinate
    }
    //Check when the authorization is changed
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        caseLocationAuth()
    }
    //show anotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}

