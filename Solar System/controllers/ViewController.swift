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
import Floaty
import Toast_Swift

class ViewController: UIViewController, ARSCNViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var xStepper: UIStepper!
    @IBOutlet weak var zStepper: UIStepper!
    @IBOutlet weak var yStepper: UIStepper!
    @IBOutlet var sceneView: ARSCNView!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currentXPosition: UILabel!
    @IBOutlet weak var currentZPosition: UILabel!
    @IBOutlet weak var currentYPosition: UILabel!
    @IBOutlet weak var axisView: UIStackView!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomButton: UIButton!
    
    var sun:SCNNode = SCNNode()
    var mercury:SCNNode = SCNNode()
    var venus:SCNNode = SCNNode()
    var earth:SCNNode = SCNNode()
    var mars:SCNNode = SCNNode()
    var jupiter:SCNNode = SCNNode()
    var saturn:SCNNode = SCNNode()
    var uranus:SCNNode = SCNNode()
    var neptune:SCNNode = SCNNode()
    
    var rotating:Bool = true
    var revolving:Bool = true
    var planetName:String = ""
    var isExpanded:Bool = false
    
    let xPosition:Float = -100.0
    let yPosition:Float = 0.0
    let zPosition:Float = -800.0
    
    let planets = Array(solarSystem.keys)
    let functions = ["Capture","Tour","Home","Animation","Rotation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        createPlanetView(x: xPosition, y: yPosition, z: zPosition)
//        addButtons()
//        takeATour()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - Node Creation and Rotation
    
    func createPlanetView(x:Float,y:Float,z:Float){
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3Make(0.0, 0.0, 0.0)
        sceneView.scene.rootNode.addChildNode(cameraNode)
        
        sun = createANode(radius: 200, image: #imageLiteral(resourceName: "sun"), x: x, y: y, z: z,name: "sun")
        let light = SCNLight()
        light.type = .ambient
        light.spotInnerAngle = 30.0
        light.spotOuterAngle = 80.0
        light.castsShadow = true
        sun.light = light
            
        sceneView.scene.rootNode.addChildNode(sun)
        mercury = createANode(radius: 3, image: #imageLiteral(resourceName: "mercury"), x: 236, y: 0, z: 0, name: "mercury")
        mercury.name = "mercury"
        addPath(radius: 236)
        addChildNodeToParentNode(parentNode: sun, childNode: mercury, duration: 12.0)
        
        venus = createANode(radius: 7, image: #imageLiteral(resourceName: "venus"), x: 268, y: 0, z: 0, name: "venus")
        addPath(radius: 268)
        addChildNodeToParentNode(parentNode: sun, childNode: venus, duration: 12.0)
        
        earth = createANode(radius: 8, image: #imageLiteral(resourceName: "earth"), x: 293.0, y: 0, z: 0,name: "earth")
        addPath(radius: 293)
        addChildNodeToParentNode(parentNode: sun, childNode:earth, duration: 10.0)
        
        mars = createANode(radius: 4, image: #imageLiteral(resourceName: "mars"), x: 341, y: 0, z: 0,name: "mars")
        addPath(radius: 341)
        addChildNodeToParentNode(parentNode: sun, childNode: mars, duration: 12.0)
        
        jupiter = createANode(radius: 88, image: #imageLiteral(resourceName: "jupiter"), x: 500, y: 0, z: 0, name: "jupiter")
        addPath(radius: 500)
        addChildNodeToParentNode(parentNode: sun, childNode: jupiter, duration: 12.0)
        
        saturn = createANode(radius: 74, image: #imageLiteral(resourceName: "saturn"), x: 700, y: 0, z: 0, name: "saturn")
        addPath(radius: 700)
        addChildNodeToParentNode(parentNode: sun, childNode: saturn, duration: 12.0)
        
        uranus = createANode(radius: 32, image: #imageLiteral(resourceName: "uranus"), x: 850, y: 0, z: 0, name: "uranus")
        addPath(radius: 850)
        addChildNodeToParentNode(parentNode: sun, childNode: uranus, duration: 12.0)
        
        neptune = createANode(radius: 30, image: #imageLiteral(resourceName: "neptune"), x: 950, y: 0, z: 0, name: "neptune")
        addPath(radius: 950)
        addChildNodeToParentNode(parentNode: sun, childNode: neptune, duration: 12.0)
        
        let moon = createANode(radius:1, image: #imageLiteral(resourceName: "moon"), x: 0, y: -15, z:0, name: "moon")
        addChildNodeToParentNode(parentNode: earth, childNode: moon, duration: 1.0)
        
        let ringMaterial = SCNMaterial()
        ringMaterial.diffuse.contents = UIColor.gray
        
        var rings = SCNTube(innerRadius: 80, outerRadius: 82, height: 1)
        rings.materials = [ringMaterial]
        
        var ringsNode = SCNNode(geometry: rings)
        ringsNode.position = SCNVector3Make(0, 0, 0)
        saturn.addChildNode(ringsNode)
        
        rings = SCNTube(innerRadius: 85, outerRadius: 87, height: 1)
        rings.materials = [ringMaterial]
        
        ringsNode = SCNNode(geometry: rings)
        ringsNode.position = SCNVector3Make(0, 0, 0)
        saturn.addChildNode(ringsNode)
        
        rings = SCNTube(innerRadius: 89, outerRadius: 95, height: 1)
        rings.materials = [ringMaterial]
        
        ringsNode = SCNNode(geometry: rings)
        ringsNode.position = SCNVector3Make(0, 0, 0)
        saturn.addChildNode(ringsNode)
        
        
        sceneView.allowsCameraControl = false
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene.rootNode.camera?.automaticallyAdjustsZRange = true
    }
    
    func createSphere(radius: CGFloat,image:UIImage) -> SCNSphere {
        let sphere = SCNSphere(radius: radius)
        let material = SCNMaterial()
        material.diffuse.contents = image
        sphere.materials = [material]
        return sphere
    }
    
    func createANode(radius:CGFloat,image:UIImage,x:Float,y:Float,z:Float,name:String) -> SCNNode {
        let node = SCNNode()
        node.position = SCNVector3Make(x,y,z)
        node.geometry = createSphere(radius: radius, image: image)
        node.name = name
        return node
    }
    
    func revolveNode(x:CGFloat,y:CGFloat,z:CGFloat,duration:Double) -> SCNAction {
        let rotation = SCNAction .rotateBy(x: x, y: y, z: z, duration: duration)
        let infiniteRotation = SCNAction .repeatForever(rotation)
        return infiniteRotation
    }
    
    func addPath(radius:CGFloat){
        let torus = SCNTorus(ringRadius: radius, pipeRadius: 0.1)
        let orbit = SCNNode(geometry: torus)
        sun.addChildNode(orbit)
    }
    
    func addChildNodeToParentNode(parentNode: SCNNode,childNode:SCNNode,duration:Double){
        if rotating {
            childNode.pivot = SCNMatrix4MakeRotation(Float(CGFloat(Double.pi/2)), 1, 0, 0)
            let spin = CABasicAnimation(keyPath: "rotation")
            spin.fromValue = NSValue(scnVector4: SCNVector4(x: 1, y: 1, z: 0, w: 0))
            spin.toValue = NSValue(scnVector4: SCNVector4(x: 1, y: 1, z: 0, w: Float(CGFloat(2 * Double.pi))))
            spin.duration = 3
            spin.repeatCount = .infinity
            childNode.addAnimation(spin, forKey: "spin around")
        }
        
        let holdingNode = SCNNode()
        holdingNode.position = SCNVector3Make(0,0,0)
        holdingNode.addChildNode(childNode)
        if revolving {
            holdingNode .runAction(revolveNode(x: 0,y: -3,z: 0,duration: duration))
        }
        
        parentNode.addChildNode(holdingNode)
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        let value:Float = Float(100*sender.value)
        switch sender.tag {
        case 0:
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            sceneView.scene.rootNode.childNodes[1].position.x -= value
            SCNTransaction.commit()
            xStepper.value = 0
        case 1:
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            sceneView.scene.rootNode.childNodes[1].position.y -= value
            SCNTransaction.commit()
            yStepper.value = 0
        case 2:
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            sceneView.scene.rootNode.childNodes[1].position.z += value
            SCNTransaction.commit()
            zStepper.value = 0
        default:
            break
        }
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
    
    func animation(){
        sceneView.makeToast("Animating Solar System",duration: 2.0, position: .top)
        revolving = !revolving
        resetScene()
    }
    
    func takeATour(){
        sceneView.makeToast("We will take you for a tour of Solar system...",duration: 2.0, position: .top)
        
        var position = mercury.position
        let action1 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 50) , duration: 5)

        position = venus.position
        let action2 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 50) , duration: 5)

        position = earth.position
        let action3 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 50) , duration: 5)

        position = mars.position
        let action4 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 50) , duration: 5)

        position = jupiter.position
        let action5 = SCNAction.move(to:SCNVector3Make(-position.x-100, position.y-50, position.z - 300) , duration: 5)

        position = saturn.position
        let action6 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 200) , duration: 5)

        position = uranus.position
        let action7 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 100) , duration: 5)

        position = neptune.position
        let action8 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 100) , duration: 5)
        
        position = sun.position
        let action9 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z) , duration: 5)

        let sequence = SCNAction.sequence([action1,action2,action3,action4,action5,action6,action7,action8,action9])
        sun.runAction(sequence)
    }
    
    func goToEarth(){
        sun.removeAllActions()
        sun.position = SCNVector3Make(xPosition, yPosition, zPosition)
        sceneView.makeToast("Navigating to Earth",duration: 2.0, position: .top)
        let position = earth.position
        let action1 = SCNAction.move(to:SCNVector3Make(-position.x, position.y, position.z - 50) , duration: 5)
        sun.runAction(action1)
    }
    
    func goToHome(){
        sun.removeAllActions()
        sun.position = SCNVector3Make(xPosition, yPosition, zPosition)
        sceneView.makeToast("Navigating to Home",duration: 2.0, position: .top)
        let action = SCNAction.move(to:SCNVector3Make(xPosition,yPosition,zPosition) , duration: 5)
        sun.runAction(action)
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
        self.bottomButton.transform = self.bottomButton.transform.rotated(by: .pi)
        isExpanded = !isExpanded
    }
}
