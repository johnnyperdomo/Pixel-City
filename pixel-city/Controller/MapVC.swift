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
import Alamofire
import AlamofireImage

class MapVC: UIViewController, UIGestureRecognizerDelegate { //inherit the delegate

    //IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pullUpView: UIView!
    @IBOutlet weak var pullupViewHeightConstraint: NSLayoutConstraint!
    
    var locationManager = CLLocationManager () //this manages the locations of people
    let authorizationStatus = CLLocationManager.authorizationStatus() //to store the authorization data
    let regionRadius: Double = 1000 //1000 meters; to keep track of the radius
    
    var screensize = UIScreen.main.bounds //size of the screen; use it to center the spinner later on using this variable
    
    var spinner: UIActivityIndicatorView? //spinner to let user know downloading imgs in progress
    var progressLabel: UILabel? //progress label
    
    var flowLayout = UICollectionViewFlowLayout() //if we make a collection view programmatically, we need to make a flowLayout for it.
    var collectionView: UICollectionView? //collection view programmatically
    
    var imageUrlArray = [String]() //array to hold all the img URLS
    var imageArray = [UIImage]() //array to hold Images
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self //set this vc to be delegate of mapView
        locationManager.delegate = self //set this to be delegate of locationManager
        configureLocationServices() //run this as soon as the app loads
        addDoubleTap() //call it
        
        
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout) //instantiate
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell") //to use it as a cell class, use .self at the end
        collectionView?.delegate = self //delegate
        collectionView?.dataSource = self //datasource, then conform to them to make it work.
        collectionView?.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        pullUpView.addSubview(collectionView!) //to add collectionview in the pullupView
    }

    
    func addDoubleTap() { //func to add a pin when you double tap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2 //two taps
        doubleTap.delegate = self //delegate
        mapView.addGestureRecognizer(doubleTap) //add it to map
    }
    
    func addSwipe() { //take note of swipe gesture
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down //allows to swipe down
        pullUpView.addGestureRecognizer(swipe)
    }
    
    
    func animateViewUp() { //animate bottom view up, when we drop a pin.
        cancelAllSessions() //call the function to cancel our download sections if we are downloading
        pullupViewHeightConstraint.constant = 300 //view is now up on screen
        UIView.animate(withDuration: 0.3) { //animates it, not just instant
        self.view.layoutIfNeeded() //redraw everything and show what has changed
        }
    }
    
  @objc  func animateViewDown() { //to pull the view down if we swipe
        pullupViewHeightConstraint.constant = 0 //view is now hidden
        UIView.animate(withDuration: 0.3) { //animates
            self.view.layoutIfNeeded() //redraw everything and show what has changed
        }
    }
    
    func addSpinner() { //spinner to let user know downloading imgs in progress
        spinner = UIActivityIndicatorView() //instantiate
        spinner?.center = CGPoint(x: (screensize.width / 2) - ((spinner?.frame.width)! / 2), y: 150) // divide by the width to be center ; 300 tall, divide by 2 to be centered vertically
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        spinner?.startAnimating() //start animating
        collectionView?.addSubview(spinner!) //add it to view
    }
    
    func removeSpinner() { //to remove spinner
        if spinner != nil { //if yes spinner, remove
            spinner?.removeFromSuperview()
        }
    }
    
    func addProgressLabel() { //progress label to track activity progress
        progressLabel = UILabel() //instantiate
        progressLabel?.frame = CGRect(x: (screensize.width / 2) - 100, y: 175, width: 200, height: 40) // gotta divide width by 2, and by the length of the rectangle to center it
        progressLabel?.font = UIFont(name: "Avenir Next", size: 14)
        progressLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        progressLabel?.textAlignment = .center
        collectionView?.addSubview(progressLabel!) //add it
    }
    
    func removeProgressLabel() { //to remove prgLabel
        if progressLabel != nil { //if yes prgLabel, remove
            progressLabel?.removeFromSuperview()
        }
    }
    //IBactions
    @IBAction func centerMapBtnPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse { //to check to see if we have access to location services
            centerMapOnUserLocation() //call this func
        }
    }
    
}

extension MapVC: MKMapViewDelegate { //conform to mapview delegate; another place to inherit could be through extensions of the class
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { //to customize pin drop(annotation); in our case, the color, and animation
        
        if annotation is MKUserLocation { //if the annotation is our location, it won't set a pin or change the color to our location annotation
            return nil
        }
        
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1) //pick a color
        pinAnnotation.animatesDrop = true //animate when we place a pin
        return pinAnnotation
    }
    
    
    func centerMapOnUserLocation() { //center the map on the user's location
        guard let coordinate = locationManager.location?.coordinate else { return } //if we have location, show coordinates, if not, return
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0 , regionRadius * 2.0 ) // we have to multiply the regionradius by 2.0 because it's only one direction but we want 1000 meters in both directions;we're gonna set how wide we want the radius to be around the center location
        mapView.setRegion(coordinateRegion, animated: true) //to set it
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer) { //func to add pin, use this to set up tapgesture
        removePin() //remove pin before we add a new one
        removeSpinner()  //to remove spinner everytime we drop a new pin
        removeProgressLabel() //to remove progressLabel everytime we drop a new pin
        cancelAllSessions() //remove download sessions when we drop a pin
        
        animateViewUp() //call animate view, when we drop a pin.
        addSwipe() // add swipe to hide the photo view down
        addSpinner() //add spinner once we drop pin
        addProgressLabel() //add label once we drop pin
    
        
        let touchPoint = sender.location(in: mapView)   //TouchPoint-where we touch on the map, something will happen in that exact location
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin") //instance of pindrop
        mapView.addAnnotation(annotation) //add annotation
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(touchCoordinate, regionRadius * 2.0 , regionRadius * 2.0) //when we drop a pin, center it.
        mapView.setRegion(coordinateRegion, animated: true)
        
        retrieveURLS(forAnnotation: annotation) { (finished) in //to call this func when we drop a pin, to retrieve urls for imgs
            if finished { //to check whether we're done downloading images
                self.retrieveImages(completion: { (finished) in
                    if finished {
                        self.removeSpinner() //once we're done downloading, hide
                        self.removeProgressLabel()
                        //reload collectionView
                    }
                })
            }
        }
    }
    
    func removePin() { //to remove pins before we drop a new one
        for annotion in mapView.annotations {
            mapView.removeAnnotation(annotion)
        }
    }
    
    
    func retrieveURLS(forAnnotation annotation: DroppablePin, completion: @escaping (_ status: Bool) -> ()) { //to retrieve urls of the imgs for the location
        imageUrlArray = [] //to make the array empty, if we drop new pin to start fresh
        
        Alamofire.request(flickrUrl(forApiKey: apiKey, withAnnotation: annotation, andNumberOfPhotos: 40)).responseJSON { (response) in //to request our url, using alamofire
            
            //Json parsing
            guard let json = response.result.value as? Dictionary<String, AnyObject> else { return } //getting the value of url request, and making a dictionary
            let photosDict = json["photos"] as! Dictionary<String, AnyObject> //access the photos dictionary using 'json'
            let photosDictArray = photosDict["photo"] as! [Dictionary<String, AnyObject>] //pull out the "photo" dictionary; getting deeping into the dictionary
            
            for photo in photosDictArray { //cycle through the data in the dictionary to create a url
                let postURL = "https://farm\(photo["farm"]!).staticflickr.com/\(photo["server"]!)/\(photo["id"]!)_\(photo["secret"]!)_h_d.jpg" //create a post URL. pull out data by diving into the dictionary using \()
                self.imageUrlArray.append(postURL) //now we append the postUrl to the imageUrlArray
            }
            completion(true) //escape, to notify us the img urls downloaded.
        }
    }
    
    func retrieveImages(completion: @escaping (_ status: Bool) -> ()) { //func to retrieve the images of the URLs
        imageArray = [] //clear old images
        
        for url in imageUrlArray { //parse through the urls to get images
            Alamofire.request(url).responseImage(completionHandler: { (response) in //to request images, using alamofire image
                guard let image = response.result.value else { return } //returns the image value from the response
                self.imageArray.append(image) //append the image to imageArray
                self.progressLabel?.text = "\(self.imageArray.count)/40 Images Downloaded" //shows how many images has been downloaded so far, in progress label
                
                if self.imageArray.count == self.imageUrlArray.count { //to check whether we have the same number of images as urls, if yes, then we're done.
                    completion(true)
                }
                
            })
            
        }
    }
    
    func cancelAllSessions() { //to cancel the downloading session if user swipes the collectionview down.
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in //three different types of sessions
            sessionDataTask.forEach({ $0.cancel() }) // $0 is like a single line for loop, makes a temporary task name for each instance of the SessionDataTask, then we cancel it with .cancel
            downloadData.forEach({ $0.cancel() }) //cancels sessions we don't want.
        }
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

extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource { //conform to these protocols to make collection view work
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // number of items in array
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell //gotta add an identifier so it knows what you're talking about
            return cell!
    }
    
}












