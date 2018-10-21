//
//  FirstViewController.swift
//  fire-reporting
//
//  Created by Wilson on 20/10/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Mapbox

class FirstViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    var reportArray = [Report]()
    var db:Firestore!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        loadData()
        
        
        mapView.logoView.isHidden = true
        mapView.attributionButton.isHidden = true
        
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 51.454514, longitude: -2.58791), animated: false)
        mapView.zoomLevel = 10.5
        
    }
    
    func loadData() {
        db.collection("reports")
            .getDocuments() {
                querySnapshot, error in
                if let error = error {
                    print("\(error.localizedDescription)")
                }else{
                    self.reportArray = querySnapshot!.documents.compactMap({Report(dictionary: $0.data())})
                    DispatchQueue.main.async {
                        
                        for (report) in self.reportArray {
                            print("kind: \(report.geoLocation)")
                            
//                            let hello = MGLPointAnnotation()
//                            hello.coordinate = CLLocationCoordinate2D(latitude: report.lat, longitude: report.lon)
//                            hello.title = "Hello world!"
//                            hello.subtitle = report.description
//
//                            // Add marker `hello` to the map.
//                            self.MGLMapView.addAnnotation(hello)
                            
                            
                            
        
                            
                            let annotation = MGLPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(latitude: report.lat, longitude: report.lon)
                            annotation.title = report.eventID
                            annotation.subtitle = "Hello World"
                            
                            
                       
                            
                            self.mapView.addAnnotation(annotation)
                            
                            // Pop-up the callout view.
//                            self.mapView.selectAnnotation(annotation, animated: true)
                            
                            self.mapView.delegate = self

                            
                            
                            
                            
                        }
                        

                    }
                }
        }
    }
    
    
   
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        if (annotation.title! == annotation.description) {
            // Callout height is fixed; width expands to fit its content.
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
            label.textAlignment = .right
            label.textColor = UIColor(red: 0.81, green: 0.71, blue: 0.23, alpha: 1)
            label.text = "金閣寺"
            
            return label
        }
        
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .detailDisclosure)
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        mapView.deselectAnnotation(annotation, animated: false)
        
        
        
    }
    
    


}

