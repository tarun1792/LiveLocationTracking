//
//  LocationShareViewController.swift
//  mapUpdate
//
//  Created by Tarun Kaushik on 05/06/19.
//  Copyright © 2019 Tarun Kaushik. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase


class LocationShareViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager!
    var location:CLLocation!
    var marker:MKPointAnnotation!
    var locationReference:DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLocationManager()
        locationReference = Database.database().reference().child("location").child("EventID").child("Host")
    }
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5.0
        locationManager.requestWhenInUseAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = true
    }

}

extension LocationShareViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count != 0 else{return}
        if mapView.annotations.count == 0{
            addAnnotationOnLocation(location: locations.last?.coordinate)
        }else{
            updateAnnotationWithLocation(location: locations.last?.coordinate)
        }
        
    }
    
    func addAnnotationOnLocation(location:CLLocationCoordinate2D?){
        guard location != nil else{return}
        
        marker = MKPointAnnotation()
        marker.coordinate = location!
        marker.title = "Tarun"
        marker.subtitle = "I am comming"
        mapView.addAnnotation(marker)
        
        mapView.setRegion(MKCoordinateRegion(center: location!, latitudinalMeters: 100, longitudinalMeters: 100), animated: true)
        
        updateLocationOnFirebase(location: location!)
    }
    
    func updateAnnotationWithLocation(location:CLLocationCoordinate2D?){
        guard location != nil else{return}
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        marker.coordinate = location!
        CATransaction.commit()
        
        updateLocationOnFirebase(location: location!)
        
        mapView.setRegion(MKCoordinateRegion(center: location!, latitudinalMeters: 100, longitudinalMeters: 100), animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func updateLocationOnFirebase(location:CLLocationCoordinate2D){
        let lat = location.latitude
        let long = location.longitude
        
        let value = ["lat":lat,"long":long]
        
        locationReference.setValue(value) { (error, reference) in
            if error == nil {
                print("location successfully updated")
            }
        }
    }
    
}
