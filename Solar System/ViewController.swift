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

class ViewController: UIViewController, ARSCNViewDelegate,FloatyDelegate {

    @IBOutlet weak var xStepper: UIStepper!
    
    @IBOutlet weak var zStepper: UIStepper!
    @IBOutlet weak var yStepper: UIStepper!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    var sun:SCNNode = SCNNode()
    var floaty = Floaty()
    var animating:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        createPlanetView(x: -400, y: 300, z: -900)
        bottomToolbar.isHidden = true
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
        
        sun = createANode(radius: 200, image: #imageLiteral(resourceName: "sun"), x: x, y: y, z: z,name: "SUN")
        sun.name = "sun"
        let light = SCNLight()
        light.type = .ambient
        light.castsShadow = true
        sun.light = light
        
        sceneView.scene.rootNode.addChildNode(sun)
        let mercury = createANode(radius: 3, image: #imageLiteral(resourceName: "mercury"), x: 236, y: 0, z: 0, name: "MERCURY")
        mercury.name = "mercury"
        addPath(radius: 36)
        addChildNodeToParentNode(parentNode: sun, childNode: mercury, duration: 12.0)
        
        let venus:SCNNode = createANode(radius: 7, image: #imageLiteral(resourceName: "venus"), x: 268, y: 0, z: 0, name: "VENUS")
        addPath(radius: 68)
        addChildNodeToParentNode(parentNode: sun, childNode: venus, duration: 12.0)
        
        let earth:SCNNode = createANode(radius: 8, image: #imageLiteral(resourceName: "earth"), x: 293.0, y: 0, z: 0,name: "EARTH")
        addPath(radius: 93)
        earth.name = "earth"
        addChildNodeToParentNode(parentNode: sun, childNode:earth, duration: 10.0)
        
        let mars = createANode(radius: 4, image: #imageLiteral(resourceName: "mars"), x: 341, y: 0, z: 0,name: "MARS")
        addPath(radius: 341)
        addChildNodeToParentNode(parentNode: sun, childNode: mars, duration: 12.0)
        
        let jupiter = createANode(radius: 88, image: #imageLiteral(resourceName: "jupiter"), x: 500, y: 0, z: 0, name: "JUPITER")
        addPath(radius: 500)
        addChildNodeToParentNode(parentNode: sun, childNode: jupiter, duration: 12.0)
        
        let saturn = createANode(radius: 74, image: #imageLiteral(resourceName: "saturn"), x: 700, y: 0, z: 0, name: "SATURN")
        addPath(radius: 700)
        addChildNodeToParentNode(parentNode: sun, childNode: saturn, duration: 12.0)
        
        let uranus = createANode(radius: 32, image: #imageLiteral(resourceName: "uranus"), x: 850, y: 0, z: 0, name: "URANUS")
        addPath(radius: 850)
        addChildNodeToParentNode(parentNode: sun, childNode: uranus, duration: 12.0)
        
        let neptune = createANode(radius: 30, image: #imageLiteral(resourceName: "neptune"), x: 950, y: 0, z: 0, name: "NEPTUNE")
        addPath(radius: 950)
        addChildNodeToParentNode(parentNode: sun, childNode: neptune, duration: 12.0)
        
        let moon = createANode(radius:1, image: #imageLiteral(resourceName: "moon"), x: 0, y: -15, z:0, name: "MOON")
        addChildNodeToParentNode(parentNode: earth, childNode: moon, duration: 1.0)
        
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
        
        let text = SCNText(string: name, extrusionDepth: 4)
        let textNode:SCNNode = SCNNode()
        textNode.geometry = text
        textNode.position = SCNVector3Make(0 , Float(radius), 0)
        node.addChildNode(textNode)
        text.alignmentMode = kCAAlignmentCenter
        text.font = UIFont(name: "Helvatica", size: 30)
        
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
        if animating {
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
        if animating {
            holdingNode .runAction(revolveNode(x: 0,y: 3,z: 0,duration: duration))
        }
        
        parentNode.addChildNode(holdingNode)
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        print(sceneView.scene.rootNode.childNodes[0].position)
//        stopAnimation()
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
            
        }
    }
    
    @IBAction func animationControl(_ sender: UIBarButtonItem) {
        bottomToolbar.isHidden = false
        animating = !animating
        resetScene()
    }
    
    func resetScene(){
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        createPlanetView(x: 0, y: 0, z: -600)
    }
    func stopAnimation(){
        if animating{
            animating = false
            resetScene()
        }
    }
    
}
