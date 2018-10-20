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

    @IBOutlet weak var MGLMapView: MGLMapView!
    var reportArray = [Report]()
    var db:Firestore!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        loadData()
        
        
        // Set the map’s center coordinate and zoom level.
        MGLMapView.setCenter(CLLocationCoordinate2D(latitude: 51.454514, longitude: -2.58791), animated: false)
        MGLMapView.zoomLevel = 10.5
        
        // Declare the marker `hello` and set its coordinates, title, and subtitle.
        let hello = MGLPointAnnotation()
        hello.coordinate = CLLocationCoordinate2D(latitude: 40.7326808, longitude: -73.9843407)
        hello.title = "Hello world!"
        hello.subtitle = "Welcome to my marker"
        
        // Add marker `hello` to the map.
        MGLMapView.addAnnotation(hello)
        
        
    }
    
    func loadData() {
        let user = Auth.auth().currentUser
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
                            
                            let hello = MGLPointAnnotation()
                            hello.coordinate = CLLocationCoordinate2D(latitude: report.lat, longitude: report.lon)
                            hello.title = "Hello world!"
                            hello.subtitle = report.description
                            
                            // Add marker `hello` to the map.
                            self.MGLMapView.addAnnotation(hello)
                            
                        }
                        

                    }
                }
        }
    }
    


}

class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = bounds.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? bounds.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
    

    
    
}

