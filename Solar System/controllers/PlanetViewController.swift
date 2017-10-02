//
//  PlanetViewController.swift
//  Solar System
//
//  Created by Aditya Emani on 9/21/17.
//  Copyright © 2017 Aditya Emani. All rights reserved.
//

import UIKit
import SceneKit

class PlanetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet weak var planetTableView: UITableView!
    var planetName:String = ""
    var planet:[String:Any] = [:]
    var planetKeys = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if planetName == ""{
            
        }else{
            self.title = planetName
            loadPlanetScene()
            planet = planetInfo[planetName] as! [String : Any]
            planetKeys = Array(planet.keys)
        }
    }
    
    func loadPlanetScene(){
        
        // create a new scene
        let scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        let node = createANode(radius: 8, image:UIImage(named: planetName)!, x: 0, y: 0, z: -5,name: "EARTH")
        node.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 5)))
        scene.rootNode.addChildNode(node)
        
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return planetKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planetViewCell", for: indexPath)
        cell.textLabel?.text = planet[planetKeys[indexPath.section]] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return planetKeys[section]
    }
    
    func createANode(radius:CGFloat,image:UIImage,x:Float,y:Float,z:Float,name:String) -> SCNNode {
        let node = SCNNode()
        node.position = SCNVector3Make(x,y,z)
        node.geometry = createSphere(radius: radius, image: image)
        node.name = name
        return node
    }
    
    func createSphere(radius: CGFloat,image:UIImage) -> SCNSphere {
        let sphere = SCNSphere(radius: radius)
        let material = SCNMaterial()
        material.diffuse.contents = image
        sphere.materials = [material]
        return sphere
    }
}
