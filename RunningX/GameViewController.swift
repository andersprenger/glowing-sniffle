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
   
    // ball
    private let ballRadius : CGFloat = 0.3
    var ball : SCNNode  = SCNNode()
    var ballLevel : Float = 0.2 / 2 + 0.3
    
    // general vars
    private var t: Float = 0
    var motionManager = CMMotionManager()
    var updateRate : Double = 1/60
    var yaw : Double = 0
    
    
    // ground
    let nodeLength: CGFloat = 20
    let howManyNodes : Int = 7
    let groundHeight : CGFloat = 0.2
    let groundWidth : CGFloat = 8
    // obstacles
    let obstaclesHeight : CGFloat = 2.5
    let obstacleWidth : CGFloat = 0.1
    let totalTopObstacleSize : CGFloat = 8.8 + 0.1 // tamanho do chao + obstacle width + um pouco pra fora
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ball = SCNNode(geometry: SCNSphere(radius: ballRadius))
        ballLevel = Float(groundHeight) / 2 + Float(ballRadius)
        // create a new scene
        let scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: Float(ballRadius) * 5 + ballLevel , z: 0)
        cameraNode.eulerAngles.x = -1/6
        
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
        scene.background.contents = UIImage(named: "fundoTeste")
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
        ball.position = SCNVector3(x: Float(yaw) * 0.1, y: ballLevel , z: -3)
        
        

        let randomNumber = randomPercent()
        switch(randomNumber) {
        case 95..<97.5:
            makeObstacles()
            
        default:
          break
        }
        
    }
    

    
    
    
    
    func makeObstacles(){
        
        var randomGroundPercent : Double  = randomPercent()
        while CGFloat(randomGroundPercent) >= 100 - (ballRadius*3) / groundWidth {
            randomGroundPercent  = randomPercent()
           
        }
        
        let randomPlace = Float(randomGroundPercent/100) * Float(groundWidth) - Float(groundWidth)/2
        
        
        // big rectangle
        
        let leftPole = SCNNode(geometry: SCNBox(width: obstacleWidth, height: obstaclesHeight, length: 0.2, chamferRadius: 0.0))
        leftPole.position = SCNVector3(x: -4.4, y: Float(obstaclesHeight)/2, z: -10)
        leftPole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
        leftPole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        leftPole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        let rightPole = SCNNode(geometry: SCNBox(width: obstacleWidth, height: obstaclesHeight, length: 0.2, chamferRadius: 0.0))
        rightPole.position = SCNVector3(x: +4.4, y: Float(obstaclesHeight)/2, z: -10)
        rightPole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
        rightPole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        rightPole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        
        let topPole = SCNNode(geometry: SCNBox(width: totalTopObstacleSize , height: 0.2, length: 0.2, chamferRadius: 0.0))
        topPole.position = SCNVector3(x: 0, y: Float(obstaclesHeight), z: -10)
        topPole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
        topPole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        topPole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        
        
        // litleSquareObstacle
        
        let squareSide : CGFloat =  ballRadius * 4
        
        let topSquareObstaclePole = SCNNode(geometry: SCNBox(width: (squareSide) + obstacleWidth   , height: obstacleWidth , length: 0.05, chamferRadius: 0.0))
        
        let yObstacleTop : Float = ballLevel + Float(groundHeight)/2 + (Float(ballRadius) * 4 ) - Float(ballRadius)
        
        topSquareObstaclePole.position = SCNVector3(x: 0 + randomPlace , y: yObstacleTop, z: -10)
        topSquareObstaclePole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
        topSquareObstaclePole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        topSquareObstaclePole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        let leftSquareObstaclePole = SCNNode(geometry: SCNBox(width: obstacleWidth, height: ( squareSide) , length: 0.05, chamferRadius: 0.0))
        let yObstacleLeft : Float = ballLevel + Float(groundHeight)/2 + ( Float(ballRadius) * 4) / 2 - Float(ballRadius)
        let xLeftlitleSquarePosition = -Float(squareSide / 2) + randomPlace
        leftSquareObstaclePole.position = SCNVector3(x: xLeftlitleSquarePosition , y: yObstacleLeft, z: -10)
        leftSquareObstaclePole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
        leftSquareObstaclePole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        leftSquareObstaclePole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        let rightSquareObstaclePole = SCNNode(geometry: SCNBox(width: obstacleWidth, height: ( squareSide) , length: 0.05, chamferRadius: 0.0))
        let yObstacleRight : Float = ballLevel + Float(groundHeight)/2 +  Float(squareSide) / 2 - Float(ballRadius)
                                                                           
        rightSquareObstaclePole.position = SCNVector3(x: Float(squareSide / 2) + randomPlace, y: yObstacleRight, z: -10)
        rightSquareObstaclePole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
        rightSquareObstaclePole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        rightSquareObstaclePole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        
        
        
        let leftDownPoleXPosition : Float =   ( -Float(groundWidth)/2 + xLeftlitleSquarePosition) / 2 - 0.2 + 0.05
//        let rightDownPoleXPosition : Float = (Float(groundWidth)/2 - (xLeftlitleSquarePosition + Float(squareSide))  ) / 2
        
        
        
        let leftDownPoleWidth : CGFloat = groundWidth * CGFloat(randomGroundPercent)/100 - 0.2
        
        
        let rightDownPoleWidth : CGFloat = groundWidth - leftDownPoleWidth - 0.2
        let rightDownPoleXPosition : Float = rightSquareObstaclePole.position.x + (Float(rightDownPoleWidth) / 2) - Float(obstacleWidth)/2
        
        // down poles
        
        let downLeftPole = SCNNode(geometry: SCNBox(width:  leftDownPoleWidth, height: 0.2, length: 0.2, chamferRadius: 0.0))
        downLeftPole.position = SCNVector3(x: leftDownPoleXPosition , y:  yObstacleRight - ( Float(squareSide) / 2 ) , z: -10)
        downLeftPole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
        downLeftPole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        downLeftPole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        
        let downRightPole = SCNNode(geometry: SCNBox(width: rightDownPoleWidth , height: obstacleWidth , length: 0.2, chamferRadius: 0.0))
        downRightPole.position = SCNVector3(x: rightDownPoleXPosition, y: yObstacleRight - ( Float(squareSide) / 2 ) , z: -10)
        downRightPole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
        downRightPole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        downRightPole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        
        let node = SCNNode()
        node.name = "obstacle"
        node.addChildNode(leftPole)
        node.addChildNode(rightPole)
        node.addChildNode(topPole)
        node.addChildNode(topSquareObstaclePole)
        node.addChildNode(leftSquareObstaclePole)
        node.addChildNode(rightSquareObstaclePole)
        
        //node.addChildNode(downLeftPole)
        node.addChildNode(downRightPole)
        node.position = SCNVector3(x: 0, y: 0, z: Float(5) * -1 * Float(nodeLength))
        
        
        
        let scnView = self.view as! SCNView
        scnView.scene?.rootNode.addChildNode(node)
        
        
        
    }
    
    func createScenary() {
         
        for i in 0..<howManyNodes { //7
            let ground = SCNNode(geometry: SCNBox(width: groundWidth , height: groundHeight, length: nodeLength, chamferRadius: 0.0))
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
