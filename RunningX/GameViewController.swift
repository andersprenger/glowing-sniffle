//
//  GameViewController.swift
//  RunningX
//
//  Created by Anderson Renan Paniz Sprenger on 09/09/21.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    
    // MARK: -- Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 15)
        
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
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = false
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.systemBlue
        
        scnView.delegate = self
        
        createScenary()
    }
    
    // MARK: -- Update
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        moveScenrary()
    }
    
    // MARK: -- Functions
    
    func createScenary() {
        let nodeLength: CGFloat = 20
        
        for i in 0..<7 {
            let ground = SCNNode(geometry: SCNBox(width: 20, height: 1, length: nodeLength, chamferRadius: 0.0))
            ground.position = SCNVector3(x: 0, y: 0, z: 0)
            ground.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "grass")
            
            let left = SCNNode(geometry: SCNBox(width: 5, height: 10, length: nodeLength, chamferRadius: 0.0))
            left.position = SCNVector3(x: -10, y: 5, z: 0)
            left.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "florest")
            
            let right = SCNNode(geometry: SCNBox(width: 5, height: 10, length: nodeLength, chamferRadius: 0.0))
            right.position = SCNVector3(x: 10, y: 5, z: 0)
            right.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "florest")
            
            let node = SCNNode()
            node.name = "ground"
            node.addChildNode(ground)
            node.addChildNode(left)
            node.addChildNode(right)
            node.position = SCNVector3(x: 0, y: 0, z: Float(i) * -20)
            
            let scnView = self.view as! SCNView
            scnView.scene?.rootNode.addChildNode(node)
        }
    }
    
    func moveScenrary() {
        DispatchQueue.main.async {
            let scnView = self.view as! SCNView
            
            let nodes = scnView.scene?.rootNode.childNodes.filter { node in
                node.name == "ground"
            }
            
            for node in nodes! {
                node.position.z += 0.2
                
                if node.position.z > 20 {
                    node.position.z -= 120
                }
            }
        }
    }
    
    // MARK: -- Configs
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
}
