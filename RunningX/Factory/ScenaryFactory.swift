//
//  ScenaryFactory.swift
//  RunningX
//
//  Created by Anderson Renan Paniz Sprenger on 17/09/21.
//

import Foundation
import SceneKit

struct ScenaryFactory {
    static let stretchLength : Float = 20
    static let groundHeight : Float = 0.2
    static let groundWidth : Float = 8
    static let groundName : String = "ground"
    
    func createScenary(in scene: SCNScene){
        for i in 0 ..< 7 {
            
            let ground = SCNNode(geometry: SCNBox(width: CGFloat(ScenaryFactory.groundWidth), height: CGFloat(ScenaryFactory.groundHeight), length: CGFloat(ScenaryFactory.stretchLength), chamferRadius: .zero))
            ground.position = SCNVector3(x: 0, y: 0, z: 0)
            ground.geometry?.firstMaterial?.diffuse.contents = UIColor(named: "floorColor")
            
            let leftGreen = SCNNode(geometry: SCNBox(width: 0.2, height: CGFloat(ScenaryFactory.groundHeight), length: CGFloat(ScenaryFactory.stretchLength), chamferRadius: .zero))
            leftGreen.position = SCNVector3(x: -4.4, y: 0, z: 0)
            leftGreen.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
            leftGreen.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
            leftGreen.geometry?.firstMaterial?.emission.intensity = 0.5
            
            let leftPurple = SCNNode(geometry: SCNBox(width: 2, height: CGFloat(ScenaryFactory.groundHeight), length: CGFloat(ScenaryFactory.stretchLength), chamferRadius: .zero))
            leftPurple.position = SCNVector3(x: -6, y: 0, z: 0)
            leftPurple.geometry?.firstMaterial?.diffuse.contents = UIColor(named: "lateralPurple")
            
            let rightGreen = SCNNode(geometry: SCNBox(width: 0.2, height: CGFloat(ScenaryFactory.groundHeight), length: CGFloat(ScenaryFactory.stretchLength), chamferRadius: .zero))
            rightGreen.position = SCNVector3(x: 4.4, y: 0, z: 0)
            rightGreen.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
            rightGreen.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
            rightGreen.geometry?.firstMaterial?.emission.intensity = 0.5
            
            let rightPurple = SCNNode(geometry: SCNBox(width: 2, height: CGFloat(ScenaryFactory.groundHeight), length: CGFloat(ScenaryFactory.stretchLength), chamferRadius: .zero))
            rightPurple.position = SCNVector3(x: 6, y: 0, z: 0)
            rightPurple.geometry?.firstMaterial?.diffuse.contents = UIColor(named: "lateralPurple")
            
            let node = SCNNode()
            node.name = ScenaryFactory.groundName
            
            node.addChildNode(ground)
            node.addChildNode(leftGreen)
            node.addChildNode(leftPurple)
            node.addChildNode(rightGreen)
            node.addChildNode(rightPurple)
            
            node.position = SCNVector3(x: 0, y: 0, z: Float(i) * -1 * Float(ScenaryFactory.stretchLength))
            
            scene.rootNode.addChildNode(node)
        }
    }
}


