//
//  LaunchViewController.swift
//  Solar System
//
//  Created by Aditya Emani on 9/26/17.
//  Copyright © 2017 Aditya Emani. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var imageRayView: UIImageView!
    @IBOutlet weak var imageCircleView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 3.0, animations: {
            self.imageRayView.transform = CGAffineTransform(rotationAngle: -.pi)
        }) { (true) in
            self.performSegue(withIdentifier: "mainApp", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
