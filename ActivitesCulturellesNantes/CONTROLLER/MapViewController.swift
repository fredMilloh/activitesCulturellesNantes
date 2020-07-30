//
//  MapViewController.swift
//  ActivitesCulturellesNantes
//
//  Created by fred on 28/07/2020.
//  Copyright © 2020 fred. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var mapNom = ""
    var mapLocation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
print(mapLocation)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(mapLocation) { (placemarks, error) in
            if let error = error { print(error)
                return
            }
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                
                let annotation = MKPointAnnotation()
                annotation.title = self.mapNom
                
                if let loaction = placemark.location {
                    annotation.coordinate = loaction.coordinate
                    
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
