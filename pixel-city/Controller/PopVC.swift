//
//  PopVC.swift
//  pixel-city
//
//  Created by Johnny Perdomo on 3/20/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

class PopVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var popImageView: UIImageView!
    
    var passedImage: UIImage! //the image that will be passed
    
    func initData(forImage image: UIImage) { //pass in an image to initialize this VC
        self.passedImage = image//the passed image will be the image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popImageView.image = passedImage //this will make the image of the popVC be the passed image
        addDoubleTap()
    }

    
   func addDoubleTap() {
    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(screenWasDoubleTapped))
    doubleTap.numberOfTapsRequired = 2
    doubleTap.delegate = self
    view.addGestureRecognizer(doubleTap)
    }
    
    @objc func screenWasDoubleTapped() {
        dismiss(animated: true, completion: nil) //to dismiss the view controller
    }
}
