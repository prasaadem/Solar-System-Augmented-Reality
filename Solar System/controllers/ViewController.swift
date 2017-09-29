//
//  ViewController.swift
//  Solar System
//
//  Created by Aditya Emani on 9/20/17.
//  Copyright © 2017 Aditya Emani. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Toast_Swift

class ViewController: UIViewController, ARSCNViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ARSessionDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var button1: UIButton!
    
    var sun:BasePlanetNode = BasePlanetNode()
    var mercury:BasePlanetNode = BasePlanetNode()
    var venus:BasePlanetNode = BasePlanetNode()
    var earth:BasePlanetNode = BasePlanetNode()
    var mars:BasePlanetNode = BasePlanetNode()
    var jupiter:BasePlanetNode = BasePlanetNode()
    var saturn:BasePlanetNode = BasePlanetNode()
    var uranus:BasePlanetNode = BasePlanetNode()
    var neptune:BasePlanetNode = BasePlanetNode()
    
    var moon:BasePlanetNode = BasePlanetNode()
    
    var isRotating:Bool = false
    var isRevolving:Bool = false
    var planetName:String = ""
    var isExpanded:Bool = false
    
    let xPosition:Float = -50
    let yPosition:Float = -50
    let zPosition:Float = -400.0
    
    let planets = Array(solarSystem.keys)
    let functions = ["Capture","Animation","Rotation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPlanetView(x: xPosition, y: yPosition, z: zPosition)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.delegate = self
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - Node Creation and Rotation
    
    func createPlanetView(x:Float,y:Float,z:Float){
        let scene = SCNScene()
        
        sun.createANode(radius: 100, image: #imageLiteral(resourceName: "sun"), x: x, y: y, z: z,name: "sun")
        sun.addLight()
        sun.addPath(radius: 136) //Mercury
        sun.addPath(radius: 168) //Venus
        sun.addPath(radius: 193) //Earth
        sun.addPath(radius: 241) //Mars
        sun.addPath(radius: 300) //Jupiter
        sun.addPath(radius: 380) //Saturn
        sun.addPath(radius: 440) //Uranus
        sun.addPath(radius: 480) //Neptune
        
        
        
        mercury.createANode(radius: 3, image: #imageLiteral(resourceName: "mercury"), x: 136, y: 0, z: 0, name: "mercury")
        mercury.addChildNodeToParentNode(parentNode: sun, childNode: mercury, duration: 12.0)
        
        venus.createANode(radius: 7, image: #imageLiteral(resourceName: "venus"), x: 168, y: 0, z: 0, name: "venus")
        venus.addChildNodeToParentNode(parentNode: sun, childNode: venus, duration: 12.0)
        
        earth.createANode(radius: 8, image: #imageLiteral(resourceName: "earth"), x: 193.0, y: 0, z: 0,name: "earth")
        earth.addChildNodeToParentNode(parentNode: sun, childNode:earth, duration: 10.0)
        
        mars.createANode(radius: 4, image: #imageLiteral(resourceName: "mars"), x: 241, y: 0, z: 0,name: "mars")
        mars.addChildNodeToParentNode(parentNode: sun, childNode: mars, duration: 12.0)
        
        jupiter.createANode(radius: 30, image: #imageLiteral(resourceName: "jupiter"), x: 300, y: 0, z: 0, name: "jupiter")
        jupiter.addChildNodeToParentNode(parentNode: sun, childNode: jupiter, duration: 12.0)
        
        saturn.createANode(radius: 24, image: #imageLiteral(resourceName: "saturn"), x: 380, y: 0, z: 0, name: "saturn")
        saturn.addChildNodeToParentNode(parentNode: sun, childNode: saturn, duration: 12.0)
        saturn.addRings(innerRadius: 25, outerRadius: 26, height: 1, color: UIColor.darkGray)
        saturn.addRings(innerRadius: 27, outerRadius: 28, height: 1, color: UIColor.darkGray)
        saturn.addRings(innerRadius: 29, outerRadius: 30, height: 1, color: UIColor.darkGray)
        
        uranus.createANode(radius: 12, image: #imageLiteral(resourceName: "uranus"), x: 440, y: 0, z: 0, name: "uranus")
        uranus.addChildNodeToParentNode(parentNode: sun, childNode: uranus, duration: 12.0)
        
        neptune.createANode(radius: 10, image: #imageLiteral(resourceName: "neptune"), x: 480, y: 0, z: 0, name: "neptune")
        neptune.addChildNodeToParentNode(parentNode: sun, childNode: neptune, duration: 12.0)
        
        moon.createANode(radius:1, image: #imageLiteral(resourceName: "moon"), x: 0, y: -15, z:0, name: "moon")
        moon.addChildNodeToParentNode(parentNode: earth, childNode: moon, duration: 1.0)
        
        
//        sceneView.allowsCameraControl = false
//        sceneView.delegate = self
        
        
        scene.rootNode.addChildNode(sun)
        sceneView.scene = scene
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage"{
            let imageViewController:ImageViewController = segue.destination as! ImageViewController
            let image = self.sceneView.snapshot()
            imageViewController.image = image
        }else if segue.identifier == "planetDetails"{
            let planetViewController:PlanetViewController = segue.destination as! PlanetViewController
            planetViewController.planetName = planetName
        }
    }
    
    func resetScene(){
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        createPlanetView(x: xPosition, y: yPosition, z: zPosition)
    }
    
//    func takeATour(){
//        sceneView.makeToast("We will take you for a tour of Solar system...",duration: 2.0, position: .top)
//        var position = mercury.position
//        let action1 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 50) , duration: 5)
//
//        position = venus.position
//        let action2 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 50) , duration: 5)
//
//        position = earth.position
//        let action3 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 50) , duration: 5)
//
//        position = mars.position
//        let action4 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 50) , duration: 5)
//
//        position = jupiter.position
//        let action5 = SCNAction.move(to:SCNVector3Make(-position.x-100, position.y-50, position.z - 300) , duration: 5)
//
//        position = saturn.position
//        let action6 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 200) , duration: 5)
//
//        position = uranus.position
//        let action7 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 100) , duration: 5)
//
//        position = neptune.position
//        let action8 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 100) , duration: 5)
//
//        position = sun.position
//        let action9 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z) , duration: 5)
//
//        let sequence = SCNAction.sequence([action1,action2,action3,action4,action5,action6,action7,action8,action9])
//        sun.runAction(sequence)
//    }
    
    func goToEarth(){
        sun.removeAllActions()
        sun.position = SCNVector3Make(xPosition, yPosition, zPosition)
        sceneView.makeToast("Navigating to Earth",duration: 2.0, position: .top)
        let position = earth.position
        let action1 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 50) , duration: 5)
        sun.runAction(action1)
    }
    
    func goToHome(){
        sceneView.makeToast("Navigating to Home",duration: 1.0, position: .top)
        resetScene()
    }
    
    func captureView(){
        performSegue(withIdentifier: "showImage", sender: self)
    }
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        let location = sender.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        if hitResults.count > 0 {
            let result = hitResults[0]
            let node = result.node
            if node.name != nil{
                planetName = node.name!
                performSegue(withIdentifier: "planetDetails", sender: self)
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return functions.count
        }else{
            return planets.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BottomCollectionViewCell
        if indexPath.section == 0 {
            cell.imageView.image = UIImage(named:functions[indexPath.row])
            cell.planetName.text = functions[indexPath.row]
        }else{
            cell.imageView.image = UIImage(named:planets[indexPath.row] + " small1")
            cell.planetName.text = planets[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0{
            switch indexPath.row{
            case 0:
                performSegue(withIdentifier: "showImage", sender: self)
            case 1:
                if isRevolving{
                    sceneView.makeToast("Stopped Revolving Planets",duration: 1.0, position: .top)
                    stopRevolution()
                }else{
                    sceneView.makeToast("Revolving Planets",duration: 1.0, position: .top)
                    startRevolution()
                }
                isRevolving = !isRevolving
            case 2:
                if isRotating{
                    sceneView.makeToast("Stopped Rotating Planets",duration: 1.0, position: .top)
                    stopRotation()
                }else{
                    sceneView.makeToast("Rotating Planets",duration: 1.0, position: .top)
                    startRotation()
                }
                isRotating = !isRotating
            default:
                print("default")
            }
        }else{
            planetName = planets[indexPath.row]
            performSegue(withIdentifier: "planetDetails", sender: self)
        }
    }
    
    @IBAction func bottomViewPopUp(_ sender: Any) {
        if isExpanded {
            UIView.animate(withDuration: 0.5, animations: {
                self.collectionViewHeightConstraint.constant = 100
                self.view.layoutIfNeeded()
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.collectionViewHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        self.button1.transform = self.button1.transform.rotated(by: .pi)
        isExpanded = !isExpanded
    }
    
    func startRotation(){
        mercury.startRotation()
        venus.startRotation()
        earth.startRotation()
        mars.startRotation()
        jupiter.startRotation()
        saturn.startRotation()
        uranus.startRotation()
        neptune.startRotation()
        moon.startRotation()
    }
    
    func startRevolution(){
        //                    sun.startRotation()
        mercury.startRevolution()
        venus.startRevolution()
        earth.startRevolution()
        mars.startRevolution()
        jupiter.startRevolution()
        saturn.startRevolution()
        uranus.startRevolution()
        neptune.startRevolution()
        moon.startRevolution()
    }
    
    func stopRotation(){
        mercury.stopRotating()
        venus.stopRotating()
        earth.stopRotating()
        mars.stopRotating()
        jupiter.stopRotating()
        saturn.stopRotating()
        uranus.stopRotating()
        neptune.stopRotating()
        moon.stopRotating()
    }
    
    func stopRevolution(){
        sun.stopRevolution()
        mercury.stopRevolution()
        venus.stopRevolution()
        earth.stopRevolution()
        mars.stopRevolution()
        jupiter.stopRevolution()
        saturn.stopRevolution()
        uranus.stopRevolution()
        neptune.stopRevolution()
        moon.stopRevolution()
    }
    
}
