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
import Mapbox

class FirstViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var MGLMapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the map’s center coordinate and zoom level.
        MGLMapView.setCenter(CLLocationCoordinate2D(latitude: 51.454514, longitude: -2.58791), animated: false)
        MGLMapView.zoomLevel = 10.5
        
        
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

