//
//  SettingsTableViewController.swift
//  Solar System
//
//  Created by Aditya Emani on 9/27/17.
//  Copyright © 2017 Aditya Emani. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    let dataArray:NSArray = ["Visit Us","Acknowledgements","Share us"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "LogoView", bundle: nil), forHeaderFooterViewReuseIdentifier: "LogoView")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = dataArray.object(at: indexPath.row) as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            self.performSegue(withIdentifier: "ack", sender: self)
        case 0:
            self.performSegue(withIdentifier: "website", sender: self)
        case 2:
            actionPressed()
        default:
            print("default")
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! LogoTableViewCell
        rotateView(targetView: cell.raysImageView, duration: 1.0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    private func rotateView(targetView: UIView, duration: Double = 3.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by:.pi)
        }) { finished in
            self.rotateView(targetView: targetView, duration: duration)
        }
    }

    func actionPressed(){
        let textToShare = "Hey checkout this app on AppStore!"
        
        if let myWebsite = NSURL(string: "https://prasaadem.github.io") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
//            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
