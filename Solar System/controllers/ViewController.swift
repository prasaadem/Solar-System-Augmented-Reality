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
import PMAlertController

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
    
    var isRotating:Bool = true
    var isRevolving:Bool = true
    
    var planetName:String = ""
    var isExpanded:Bool = false
    
    let xPosition:Float = -1.0
    let yPosition:Float = -1.0
    let zPosition:Float = -4.0
    
    let planets = Array(planetInfo.keys)
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
        sun.createANode(radius: 1, image: #imageLiteral(resourceName: "sun"), x: x, y: y, z: z,name: "sun")
        sun.addLight()
        //        sun.glow(duration: 5.0)
        sun.addPath(radius: 1.36) //Mercury
        sun.addPath(radius: 1.68) //Venus
        sun.addPath(radius: 1.93) //Earth
        sun.addPath(radius: 2.41) //Mars
        sun.addPath(radius: 3.00) //Jupiter
        sun.addPath(radius: 3.80) //Saturn
        sun.addPath(radius: 4.40) //Uranus
        sun.addPath(radius: 4.80) //Neptune

        mercury.createANode(radius: 0.03, image: #imageLiteral(resourceName: "mercury"), x: 0, y: 0, z: 0, name: "mercury")
        mercury.addChildNodeToParentNode(parentNode: sun, childNode: mercury, duration: 3.0)
        mercury.animateAfterLoading(x: 1.36, y: 0, z: 0, duration: 1)

        venus.createANode(radius: 0.07, image: #imageLiteral(resourceName: "venus"), x: 0, y: 0, z: 0, name: "venus")
        venus.addChildNodeToParentNode(parentNode: sun, childNode: venus, duration: 4.0)
        venus.animateAfterLoading(x: 1.68, y: 0, z: 0, duration: 2)

        earth.createANode(radius: 0.08, image: #imageLiteral(resourceName: "earth"), x: 0, y: 0, z: 0,name: "earth")
        earth.addChildNodeToParentNode(parentNode: sun, childNode:earth, duration: 5.0)
        earth.animateAfterLoading(x: 1.93, y: 0, z: 0, duration: 3)

        mars.createANode(radius: 0.04, image: #imageLiteral(resourceName: "mars"), x: 0, y: 0, z: 0,name: "mars")
        mars.addChildNodeToParentNode(parentNode: sun, childNode: mars, duration: 6.0)
        mars.animateAfterLoading(x: 2.41, y: 0, z: 0, duration: 4)

        jupiter.createANode(radius: 0.30, image: #imageLiteral(resourceName: "jupiter"), x: 0, y: 0, z: 0, name: "jupiter")
        jupiter.addChildNodeToParentNode(parentNode: sun, childNode: jupiter, duration: 12.0)
        jupiter.animateAfterLoading(x: 3.00, y: 0, z: 0, duration: 5)

        saturn.createANode(radius: 0.24, image: #imageLiteral(resourceName: "saturn"), x: 0, y: 0, z: 0, name: "saturn")
        saturn.addChildNodeToParentNode(parentNode: sun, childNode: saturn, duration: 10.0)
        saturn.addRings(innerRadius: 0.25, outerRadius: 0.26, height: 0.01, color: UIColor.darkGray)
        saturn.addRings(innerRadius: 0.27, outerRadius: 0.28, height: 0.01, color: UIColor.darkGray)
        saturn.addRings(innerRadius: 0.29, outerRadius: 0.30, height: 0.01, color: UIColor.darkGray)
        saturn.animateAfterLoading(x: 3.80, y: 0, z: 0, duration: 6)

        uranus.createANode(radius: 0.12, image: #imageLiteral(resourceName: "uranus"), x: 0, y: 0, z: 0, name: "uranus")
        uranus.addChildNodeToParentNode(parentNode: sun, childNode: uranus, duration: 11.0)
        uranus.animateAfterLoading(x: 4.40, y: 0, z: 0, duration: 7)

        neptune.createANode(radius: 0.10, image: #imageLiteral(resourceName: "neptune"), x: 0, y: 0, z: 0, name: "neptune")
        neptune.addChildNodeToParentNode(parentNode: sun, childNode: neptune, duration: 18.0)
        neptune.animateAfterLoading(x: 4.80, y: 0, z: 0, duration: 8)

        moon.createANode(radius:0.01, image: #imageLiteral(resourceName: "moon"), x: 0, y: 0, z:0, name: "moon")
        moon.addChildNodeToParentNode(parentNode: earth, childNode: moon, duration: 0.5)
        moon.animateAfterLoading(x: 0, y: -0.15, z: 0, duration: 1)

        startRotation()
        startRevolution()
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(sun)
        sceneView.scene = scene
        sceneView.delegate = self
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
                showAlert(planetName: planetName)
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
                self.collectionViewHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.collectionViewHeightConstraint.constant = 100
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
    
    func showAlert(planetName:String){
        let alertVC = PMAlertController(title: planetName + " is close", description: "Do you want to know more about it?", image: UIImage(named:planetName + " small1"), style: .alert)

        alertVC.addAction(PMAlertAction(title: "No", style: .cancel, action: { () -> Void in
        }))

        alertVC.addAction(PMAlertAction(title: "Yes", style: .default, action: { () in
            self.performSegue(withIdentifier: "planetDetails", sender: self)
        }))

        self.present(alertVC, animated: true, completion: nil)
    }
    
}
