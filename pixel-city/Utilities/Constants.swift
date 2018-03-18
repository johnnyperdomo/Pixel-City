//
//  Constants.swift
//  pixel-city
//
//  Created by Johnny Perdomo on 3/17/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import Foundation


let apiKey = "fd9f5023c132a7854308b4b05c26a680" //api key for flickr app(images downloader)

func flickrUrl(forApiKey key: String, withAnnotation annotation: DroppablePin, andNumberOfPhotos number: Int) -> String { //func to give us a flickr URL, in a string format
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"
}


