//
//  ViewController.swift
//  mapUpdate
//
//  Created by Tarun Kaushik on 05/06/19.
//  Copyright © 2019 Tarun Kaushik. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var locationReference:DatabaseReference!
    var marker:MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationReference = Database.database().reference().child("location").child("EventID").child("Host")
        addLocationUpdateObserver()
    }

    
    func addLocationUpdateObserver(){
        locationReference.observe(.value) {[weak self] (snapShot) in
            guard let self = self else{return}
            
            if let value = snapShot.value as? NSDictionary{
                guard let lat = value["lat"] ,let long = value["long"] else{return}
                
                let location = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
                
                if self.mapView.annotations.count == 0{
                    self.addAnnotationOnLocation(location: location)
                }else{
                    self.updateAnnotationWithLocation(location: location)
                }

                print("location latitude is \(lat) and longitute is \(long)")
            }
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
    }
    
    func updateAnnotationWithLocation(location:CLLocationCoordinate2D?){
        guard location != nil else{return}
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        marker.coordinate = location!
        CATransaction.commit()
        mapView.setRegion(MKCoordinateRegion(center: location!, latitudinalMeters: 100, longitudinalMeters: 100), animated: true)
    }

}

