//
//  ImageViewController.swift
//  Solar System
//
//  Created by Aditya Emani on 9/21/17.
//  Copyright © 2017 Aditya Emani. All rights reserved.
//

import UIKit
import Photos

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image:UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = image
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveImage))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func saveImage(sender:UIBarButtonItem){
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
        savedImageAlert()
    }
    func savedImageAlert()
    {
        let alertController:UIAlertController = UIAlertController(title: "Saved!", message: "Your picture was saved to Photos Album", preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
