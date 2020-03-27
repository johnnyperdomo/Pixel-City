# Pixel-City
iOS app that shows images based on location with Mapkit written in Swift 4

## Preview
![Alt Text](https://media.giphy.com/media/W0WHNUEJYpLd1du0MK/giphy.gif) 

**Built with**
- Ios 11
- Xcode 9 

## Features
- **Drop a pin on a certain location by double tapping on map using ```UITapGestureRecognizer```** 
- **Track current location using ```CLLocationManager()```**
- **Get images by location with [Flickr](https://www.flickr.com/)**
- **Download images using ```AlamofireImage``` and place them in ```UICollectionView```**
- **Tap ```CollectionViewCell``` to see full image**
- **See a sneak peak of full image with peek and pop using ```3D Touch```**

## Requirements
```swift
import MapKit
import CoreLocation
import Alamofire
import AlamofireImage 
```

**_Pod Files_**
```swift
 pod 'Alamofire', '~> 4.7'
 pod 'AlamofireImage', '~> 3.3' 
```

## Project Configuration
You'll have to configure your Xcode project in order to track user Location with ```Map Kit```.

_Your Xcode project should contain an ```Info.plist``` file._

1. In Info.plist, open Information Property List. 

2. Hover your cursor over the up-down arrows, or click on any item in the list,   
to display the + and – symbols, then click the + symbol to create a new item. 

3. Scroll down to select Privacy – Location When In Use Usage Description, then set its Value to something like: 
> To show you cool things nearby

_You need a flickr apiKey to get images by location_

1. Create an account at [The App Garden on Flickr](https://www.flickr.com/services/apps/create/)

2. Request an API key

## License
Standard MIT [License](https://github.com/johnnyperdomo/pixel-city/blob/master/LICENSE)
