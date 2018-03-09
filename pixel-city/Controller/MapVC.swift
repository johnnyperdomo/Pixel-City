//
//  MapVC.swift
//  pixel-city
//
//  Created by Johnny Perdomo on 2/22/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {

    //IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager () //this manages the locations of people
    let authorizationStatus = CLLocationManager.authorizationStatus() //to store the authorization data
    let regionRadius: Double = 1000 //1000 meters; to keep track of the radius
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self //set this vc to be delegate of mapView
        locationManager.delegate = self //set this to be delegate of locationManager
        configureLocationServices() //run this as soon as the app loads 
    }

    //IBactions
    @IBAction func centerMapBtnPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse { //to check to see if we have access to location services
            centerMapOnUserLocation() //call this func
        }
    }
    
}




extension MapVC: MKMapViewDelegate { //conform to mapview delegate; another place to inherit could be through extensions of the class
    func centerMapOnUserLocation() { //center the map on the user's location
        guard let coordinate = locationManager.location?.coordinate else { return } //if we have location, show coordinates, if not, return
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0 , regionRadius * 2.0 ) // we have to multiply the regionradius by 2.0 because it's only one direction but we want 1000 meters in both directions;we're gonna set how wide we want the radius to be
        mapView.setRegion(coordinateRegion, animated: true) //to set it
    }
}

extension MapVC: CLLocationManagerDelegate { //conform to locationManager delegate; another place to inherit could be through extensions of the class
    func configureLocationServices() { //function to make our app work; check to see if app is authorized to use our location, if not, request it.
        
        if authorizationStatus == .notDetermined { //if the AuthStatus is not determined yet. -> next step is to ask for it
            locationManager.requestAlwaysAuthorization() //to request to use location always whether app is open or not
        } else { //if it is determined; can be denied or granted
            return
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) { //this is called when the authorization status is suddenly approved
        centerMapOnUserLocation()
    }
}











