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
import AVFoundation

public let label = UILabel()

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    //media
    var mediaPlayer: MediaPlayer = MediaPlayer()

    // ball
    var ball: SCNNode!
    var ballHeight: Float = 0.2 / 2 + 0.3
    
    // timer
    public var somaTimer = 0
    
    // general vars
    private var t: Float = 0
    var motionManager = CMMotionManager()
    var updateRate: Double = 1/60
    var yaw: Double = 0
    
    // ground
    let nodeLength: CGFloat = 20
    let howManyNodes: Int = 7
    let groundHeight: CGFloat = 0.2
    let groundWidth: CGFloat = 8
    // obstacles
    let obstaclesHeight: CGFloat = 4.5
    let obstacleWidth: CGFloat = 0.1
    let totalTopObstacleSize: CGFloat = 8.8 + 0.1 // tamanho do chao + obstacle width + um pouco pra fora
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 2, z: 0)
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
        
        // init media stuff
        mediaPlayer.playMusic()
        mediaPlayer.playVideo()
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        scene.background.contents = mediaPlayer.videoPlayer
        scene.background.wrapS = .repeat
        scene.background.wrapT = .repeat
        
        // set itself as delegate
        scnView.delegate = self
        
        BallFactory.createBall { ball in
            self.ball = ball
            scnView.scene?.rootNode.addChildNode(ball)
        }
        
        // init functions
        ScenaryFactory.createScenary { node in
            scnView.scene?.rootNode.addChildNode(node)
        }
        
        createTimer()
        startControl()
        //playMusic()
    }
    
    // MARK: -- Update
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        moveScenrary()
        
        self.t += 0.1
        ball.position = SCNVector3(x: Float(yaw) * 0.1, y: ballHeight , z: -3)
    }
    
    // MARK: -- Functions
    
    func startControl(){
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = updateRate
            motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: .main){ (data, error) in
                guard let validData = data else{return}
                
                self.yaw = validData.attitude.pitch*58
            }
        }
    }
    
    @objc func runTimer() -> Int {
        somaTimer += 1
        label.text = "Score: \(self.somaTimer)"
        return somaTimer
    }
    
    func randomPercent() -> Double {
        return Double(arc4random() % 1000) / 10.0;
    }
    
    func makeObstacles() -> SCNNode {
        
        var randomGroundPercent : Double  = randomPercent()
        let squareSide : CGFloat =  CGFloat(BallFactory.ballRadius * 4.5)
        
        while CGFloat(randomGroundPercent) >= 100 - (squareSide) / groundWidth {
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
        topPole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "horizontalGreen")
        topPole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        topPole.geometry?.firstMaterial?.emission.intensity = 0.5

        // litleSquareObstacle

        let topSquareObstaclePole = SCNNode(geometry: SCNBox(width: (squareSide) + obstacleWidth   , height: obstacleWidth , length: 0.05, chamferRadius: 0.0))
        
        let yObstacleTop : Float = ballHeight + Float(groundHeight)/2 + (Float(squareSide) ) - Float(BallFactory.ballRadius)
        
        topSquareObstaclePole.position = SCNVector3(x: 0 + randomPlace , y: yObstacleTop, z: -10)
        topSquareObstaclePole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "horizontalGreen")
        topSquareObstaclePole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        topSquareObstaclePole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        let leftSquareObstaclePole = SCNNode(geometry: SCNBox(width: obstacleWidth, height: ( squareSide) , length: 0.05, chamferRadius: 0.0))
        let yObstacleLeft : Float = ballHeight + Float(groundHeight)/2 +  Float(squareSide) / 2 - Float(BallFactory.ballRadius)
        let xLeftlitleSquarePosition = -Float(squareSide / 2) + randomPlace
        leftSquareObstaclePole.position = SCNVector3(x: xLeftlitleSquarePosition , y: yObstacleLeft, z: -10)
        leftSquareObstaclePole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
        leftSquareObstaclePole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        leftSquareObstaclePole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        let rightSquareObstaclePole = SCNNode(geometry: SCNBox(width: obstacleWidth, height: ( squareSide) , length: 0.05, chamferRadius: 0.0))
        let yObstacleRight : Float = ballHeight + Float(groundHeight)/2 +  Float(squareSide) / 2 - Float(BallFactory.ballRadius)
        
        rightSquareObstaclePole.position = SCNVector3(x: Float(squareSide / 2) + randomPlace, y: yObstacleRight, z: -10)
        rightSquareObstaclePole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
        rightSquareObstaclePole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        rightSquareObstaclePole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        let leftDownPoleWidth : CGFloat = groundWidth * CGFloat(randomGroundPercent)/100 - (obstacleWidth) - 0.1
        let leftDownPoleXPosition : Float =   ( -Float(groundWidth)/2 + xLeftlitleSquarePosition) / 2 - Float(obstacleWidth) - 0.1
                
        let rightDownPoleWidth : CGFloat = groundWidth - leftDownPoleWidth - 0.35
        let rightDownPoleXPosition : Float = rightSquareObstaclePole.position.x + (Float(rightDownPoleWidth) / 2) - Float(obstacleWidth)/2
        
        
        // down poles
        
        let downLeftPole = SCNNode(geometry: SCNBox(width:  leftDownPoleWidth, height: 0.2, length: 0.2, chamferRadius: 0.0))
        downLeftPole.position = SCNVector3(x: leftDownPoleXPosition , y:  yObstacleRight - ( Float(squareSide) / 2 ) , z: -10)
        downLeftPole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "horizontalGreen")
        downLeftPole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        downLeftPole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        
        let downRightPole = SCNNode(geometry: SCNBox(width: rightDownPoleWidth , height: obstacleWidth , length: 0.2, chamferRadius: 0.0))
        downRightPole.position = SCNVector3(x: rightDownPoleXPosition, y: yObstacleRight - ( Float(squareSide) / 2 ) , z: -10)
        downRightPole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "horizontalGreen")
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
        
        node.addChildNode(downLeftPole)
        node.addChildNode(downRightPole)
        node.position = SCNVector3(x: 0, y: 0, z: 0)
        
        return node
    }
    
    
    
    func randomPosition() -> Float {
        var randomGroundPercent : Double  = randomPercent()
        let squareSide : CGFloat =  CGFloat(BallFactory.ballRadius * 4.5)
        
        while CGFloat(randomGroundPercent) >= 100 - (squareSide) / groundWidth {
            randomGroundPercent  = randomPercent()
            
        }
        
        return Float(randomGroundPercent/100) * Float(groundWidth) - Float(groundWidth)/2
    }
    
    func createBlackHole() -> SCNNode {
        let bhheight: Float = 0.08
        
        let blackHoleImage = SCNNode(geometry: SCNCylinder(radius: 1.0, height: 0.2))
        blackHoleImage.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blsckholebg2")
        blackHoleImage.position = SCNVector3(0, 0.001, 0)
        
        let blackHoleRing1 = SCNNode(geometry: SCNTorus(ringRadius: 1.1, pipeRadius: 0.025))
        blackHoleRing1.geometry?.firstMaterial?.diffuse.contents = UIColor(named: "blackHoleRing1Color")
        blackHoleRing1.geometry?.firstMaterial?.emission.contents = UIColor(named: "blackHoleRing1Color")
        blackHoleRing1.geometry?.firstMaterial?.emission.intensity = 0.5
        blackHoleRing1.position = SCNVector3(0, bhheight, 0)
        
        let blackHoleRing2 = SCNNode(geometry: SCNTorus(ringRadius: 1.25, pipeRadius: 0.025))
        blackHoleRing2.geometry?.firstMaterial?.diffuse.contents = UIColor(named: "blackHoleRing2Color")
        blackHoleRing2.geometry?.firstMaterial?.emission.contents = UIColor(named: "blackHoleRing2Color")
        blackHoleRing2.geometry?.firstMaterial?.emission.intensity = 0.5
        blackHoleRing2.position = SCNVector3(0, bhheight, 0)
        
        let blackHoleRing3 = SCNNode(geometry: SCNTorus(ringRadius: 1.45, pipeRadius: 0.1))
        blackHoleRing3.geometry?.firstMaterial?.diffuse.contents = UIColor(named: "blackHoleRing3Color")
        blackHoleRing3.geometry?.firstMaterial?.emission.contents = UIColor(named: "blackHoleRing3Color")
        blackHoleRing3.geometry?.firstMaterial?.emission.intensity = 0.5
        blackHoleRing3.position = SCNVector3(0, bhheight, 0)
        
        let blackHole = SCNNode()
        blackHole.addChildNode(blackHoleImage)
        blackHole.addChildNode(blackHoleRing1)
        blackHole.addChildNode(blackHoleRing2)
        blackHole.addChildNode(blackHoleRing3)
        blackHole.name = "blackHole"
        blackHole.position.x = randomPosition()
        
        return blackHole
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
                    
                    let isNodeWithoutObstacle = node.childNodes.filter { node in
                        node.name == "obstacle"
                    }.isEmpty
                    
                    if isNodeWithoutObstacle {
                        node.addChildNode(self.makeObstacles())
                        node.addChildNode(self.createBlackHole())
                    } else {
                        let blackHoles = node.childNodes.filter { node in
                            node.name == "blackHole"
                        }
                        
                        for blackHole in blackHoles {
                            blackHole.position.x = self.randomPosition()
                        }
                    }
                }
            }
        }
    }
    
    func createTimer(){
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
        
        label.textColor = .white
        label.font = UIFont(name: "Arial", size: 30)
        label.text = "Score: \(self.somaTimer)"
        label.frame = CGRect(x: 40, y: 20, width: 250, height: 50)
        
        let scnView = self.view as! SCNView
        scnView.addSubview(label)
    }
    
    // MARK: -- Settings
    
    override var shouldAutorotate: Bool {
        true
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }
}
