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
        mapView.delegate = self
        // ajout échelle
        mapView.showsScale = true
        // ajout boussole
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        mapView.showsBuildings = true
        
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
}

extension MapViewController: MKMapViewDelegate {
    // personnalisation de l'épingle mapview
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyStramp"
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        // réutilisation de l'annotation si possible
        var annotationView : MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.glyphText = "🧐"
        annotationView?.markerTintColor = .green
        
        return annotationView
    }
}
