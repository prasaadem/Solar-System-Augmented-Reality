//
//  BasePlanetNode.swift
//  Solar System
//
//  Created by Aditya Emani on 9/29/17.
//  Copyright © 2017 Aditya Emani. All rights reserved.
//

import UIKit
import SceneKit

class BasePlanetNode: SCNNode {
    // MARK: - Node Creation and Rotation
    let holdingNode = SCNNode()
    var duration:Double = 2.0
    
    func createANode(radius:CGFloat,image:UIImage,x:Float,y:Float,z:Float,name:String){
        self.position = SCNVector3Make(x,y,z)
        self.geometry = createSphere(radius: radius, image: image)
        self.name = name
        self.physicsBody?.type = .dynamic
    }
    
    func createSphere(radius: CGFloat,image:UIImage) -> SCNSphere {
        let sphere = SCNSphere(radius: radius)
        let material = SCNMaterial()
        material.diffuse.contents = image
        sphere.materials = [material]
        return sphere
    }
    
    func revolveNode(x:CGFloat,y:CGFloat,z:CGFloat) -> SCNAction {
        let revolve = SCNAction .rotateBy(x: x, y: y, z: z, duration: duration)
        let infiniteRevolution = SCNAction .repeatForever(revolve)
        return infiniteRevolution
    }
    
    func addPath(radius:CGFloat){
        let torus = SCNTorus(ringRadius: radius, pipeRadius: 0.001)
        let orbit = SCNNode(geometry: torus)
        self.addChildNode(orbit)
    }
    
    func addChildNodeToParentNode(parentNode: SCNNode,childNode:SCNNode,duration:Double){
        holdingNode.position = SCNVector3Make(0,0,0)
        holdingNode.addChildNode(self)
        self.duration = duration
        parentNode.addChildNode(holdingNode)
    }
    
    func addLight(){
        let light = SCNLight()
        light.type = .ambient
        light.spotInnerAngle = 30.0
        light.spotOuterAngle = 80.0
        light.castsShadow = true
        self.light = light
    }
    
    func addRings(innerRadius: CGFloat, outerRadius: CGFloat, height: CGFloat, color:UIColor){
        let ringMaterial = SCNMaterial()
        ringMaterial.diffuse.contents = color
        
        let rings = SCNTube(innerRadius: innerRadius, outerRadius: outerRadius, height: height)
        rings.materials = [ringMaterial]
    
        let ringsNode = SCNNode(geometry: rings)
        ringsNode.position = SCNVector3Make(0, 0, 0)
        self.addChildNode(ringsNode)
    }
    
    func startRotation(){
        self.pivot = SCNMatrix4MakeRotation(Float(CGFloat(Double.pi/2)), 0.01, 0, 0)
        let spin = CABasicAnimation(keyPath: "rotation")
        spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0.01, y: 0.01, z: 0, w: 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(x: 0.01, y: 0.01, z: 0, w: Float(CGFloat(2 * Double.pi))))
        spin.duration = 3
        spin.repeatCount = .infinity
        self.addAnimation(spin, forKey: "spin around")
    }
    
    func stopRotating(){
        self.removeAllAnimations()
    }
    
    func startRevolution(){
        holdingNode.runAction(revolveNode(x: 0,y: -3,z: 0), forKey: "revolve")
    }
    
    func stopRevolution(){
        holdingNode.removeAction(forKey: "revolve")
    }
    
    func animateAfterLoading(x:Float,y:Float,z:Float,duration:Double){
        let action1 = SCNAction.move(to:SCNVector3Make(x,y,z) , duration: 5)
        self.runAction(action1)
    }
}
