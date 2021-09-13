//
//  GameViewController.swift
//  RunningX
//
//  Created by Anderson Sprenger on 09/09/21.
//

import UIKit
import QuartzCore
import SceneKit
import CoreMotion

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    
    private var ball = SCNNode(geometry: SCNSphere(radius: 0.30))
    private var t: Float = 0
    let nodeLength: CGFloat = 20
    let howManyNodes : Int = 7
    var motionManager = CMMotionManager()
    var updateRate : Double = 1/60
//    var force : SCNVector3 = SCNVector3(x: 0, y: 0, z: 0)
    var yaw : Double = 0
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
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 0)
        cameraNode.eulerAngles.x = -1/2
        
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
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        scene.background.contents = UIImage(named: "bgGame3")
        scene.background.wrapS = .repeat
        scene.background.wrapT = .repeat
        
        // set itself as delegate
        scnView.delegate = self
        
        // init functions
        createScenary()
        
        createBall()
        userCommand()
        
        
        makeObstacles()
        
    }
    
    // MARK: -- Update
    
    func userCommand(){
        
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = updateRate
            motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: .main){
                (data, error) in
                guard let validData = data else{return}
                
                self.yaw = validData.attitude.pitch*58
                            
            }
            
        }
        
        
        
    }
    func randomPercent() -> Double {
      return Double(arc4random() % 1000) / 10.0;
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        moveScenrary()
        
        
//        ball.physicsBody?.applyForce(force, asImpulse: false)
        self.t += 0.1
        ball.position = SCNVector3(x: Float(yaw) * -0.1, y:1 , z: -3)
        
        

        let randomNumber = randomPercent()
        switch(randomNumber) {
        case 95..<97.5:
            makeObstacles()
            print("ASHDUIAHDIUHASIUSDHAUIS")
        default:
          print("500% better to 2000% better then current item level")
        }
        
    }
    
    // MARK: -- Functions
    
    
    
    
    func makeObstacles(){
        
        
        let leftPole = SCNNode(geometry: SCNBox(width: 0.2, height: 10, length: 0.2, chamferRadius: 0.0))
        leftPole.position = SCNVector3(x: -4.4, y: 5, z: -10)
        leftPole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
        leftPole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        leftPole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        let rightPole = SCNNode(geometry: SCNBox(width: 0.2, height: 10, length: 0.2, chamferRadius: 0.0))
        rightPole.position = SCNVector3(x: +4.4, y: 5, z: -10)
        rightPole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
        rightPole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        rightPole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        let node = SCNNode()
        node.name = "obstacle"
        node.addChildNode(leftPole)
        node.addChildNode(rightPole)
        node.position = SCNVector3(x: 0, y: 0, z: Float(5) * -1 * Float(nodeLength))
        
        
        
        let scnView = self.view as! SCNView
        scnView.scene?.rootNode.addChildNode(node)
        
        
        
    }
    
    func createScenary() {
         
        for i in 0..<howManyNodes { //7
            let ground = SCNNode(geometry: SCNBox(width: 8, height: 0.2, length: nodeLength, chamferRadius: 0.0))
            ground.position = SCNVector3(x: 0, y: 0, z: 0)
            ground.geometry?.firstMaterial?.diffuse.contents = UIColor(named: "floorColor")
            
            let leftGreen = SCNNode(geometry: SCNBox(width: 0.2, height: 0.2, length: nodeLength, chamferRadius: 0.0))
            leftGreen.position = SCNVector3(x: -4.4, y: 0, z: 0)
            leftGreen.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
            leftGreen.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
            leftGreen.geometry?.firstMaterial?.emission.intensity = 0.5
            
            let leftPurple = SCNNode(geometry: SCNBox(width: 2, height: 0.2, length: nodeLength, chamferRadius: 0.0))
            leftPurple.position = SCNVector3(x: -6, y: 0, z: 0)
            leftPurple.geometry?.firstMaterial?.diffuse.contents = UIColor(named: "lateralPurple")

            let rightGreen = SCNNode(geometry: SCNBox(width: 0.2, height: 0.2, length: nodeLength, chamferRadius: 0.0))
            rightGreen.position = SCNVector3(x: 4.4, y: 0, z: 0)
            rightGreen.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
            rightGreen.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
            rightGreen.geometry?.firstMaterial?.emission.intensity = 0.5
            
            let rightPurple = SCNNode(geometry: SCNBox(width: 2, height: 0.2, length: nodeLength, chamferRadius: 0.0))
            rightPurple.position = SCNVector3(x: 6, y: 0, z: 0)
            rightPurple.geometry?.firstMaterial?.diffuse.contents = UIColor(named: "lateralPurple")
            
            let node = SCNNode()
            node.name = "ground"
            
            
            node.addChildNode(ground)
            node.addChildNode(leftGreen)
            node.addChildNode(leftPurple)
            node.addChildNode(rightGreen)
            node.addChildNode(rightPurple)
            node.position = SCNVector3(x: 0, y: 0, z: Float(i) * -1 * Float(nodeLength))

//            let filter = CIFilter(name: "CIGaussianBlur")
//            filter!.setValue(1, forKey: kCIInputRadiusKey)
//            left.filters = [filter!]
//            right.filters = [filter!]
            
//            let omniLight = SCNLight()
//            omniLight.type = .omni
//            omniLight.color = UIColor(named: "lateralBase")
//            left.light = omniLight
//            right.light = omniLight

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

                if node.position.z > Float(self.nodeLength) {
                    node.position.z -= Float(self.howManyNodes)*Float(self.nodeLength)
                }
            }
            
            let nodesObsta = scnView.scene?.rootNode.childNodes.filter { node in
                node.name == "obstacle"
            }
            
            for node in nodesObsta! {
                node.position.z += 0.2
                
                if node.position.z > Float(self.nodeLength) {
                    node.removeFromParentNode()
                }
                
            }
            
            
        }
    }
    
    func createBall() {
        
        ball.name = "ball"
        ball.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        
        ball.geometry?.firstMaterial?.emission.contents = UIColor.red
        //ball.geometry?.firstMaterial?.emission.intensity = 0.5
        
        let scnView = self.view as! SCNView
        ball.position = SCNVector3(x: Float(0), y:1 , z: -3)
        
        scnView.scene?.rootNode.addChildNode(ball)
        
        
//        let omniLight = SCNLight()
//        omniLight.type = .omni
//        omniLight.color = UIColor.red
//        ball.light = omniLight
    }
    
    // MARK: -- Configurations
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .all
        }
    }
}
