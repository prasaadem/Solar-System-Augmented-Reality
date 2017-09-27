//
//  PlanetViewController.swift
//  Solar System
//
//  Created by Aditya Emani on 9/21/17.
//  Copyright © 2017 Aditya Emani. All rights reserved.
//

import UIKit
import WebKit

class PlanetViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var planetName:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        
        let url = NSURL(string:"https://en.wikipedia.org/wiki/Special:Search/"+planetName)
        let request = NSURLRequest(url:url! as URL)
        webView.load(request as URLRequest)
        
        self.title = planetName
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alertController:UIAlertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }

}
