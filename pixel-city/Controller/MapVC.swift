//
//  MapVC.swift
//  pixel-city
//
//  Created by Johnny Perdomo on 2/22/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    //IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self //set this vc to be delegate of mapView
    }

    //IBactions
    @IBAction func centerMapBtnPressed(_ sender: Any) {
        
    }
    
}

extension MapVC: MKMapViewDelegate { //conform to mapview delegate; another place to inherit could be through extensions of the class
    
}
