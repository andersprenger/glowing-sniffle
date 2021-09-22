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

public let label = UILabel()

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    //media
    var mediaPlayer: MediaPlayer = MediaPlayer()

    // ball
    var ball: SCNNode!
    
    // timer
    public var sumTimer: Int = 0
    
    // imput helper vars
    var motionManager = CMMotionManager()
    var updateRate: Double = 1/60
    var yaw: Double = 0
    
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
    }
    
    // MARK: -- Update
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        moveScenrary()
        
        ball.position = SCNVector3(x: Float(yaw) * 0.1, y: BallFactory.ballHeight , z: -3)
    }
    
    // MARK: -- Functions
    
    func startControl() {
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = updateRate
            motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: .main){ (data, error) in
                guard let validData = data else{return}
                
                self.yaw = validData.attitude.pitch*58
            }
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
                
                if node.position.z > ScenaryFactory.nodeLength {
                    node.position.z -= ScenaryFactory.nodeLength * Float(ScenaryFactory.howManyNodes)
                    
                    let isNodeWithoutObstacle = node.childNodes.filter { node in
                        node.name == "obstacle"
                    }.isEmpty
                    
                    if isNodeWithoutObstacle {
                        node.addChildNode(ObstacleFactory.makeObstacles())
                        node.addChildNode(ObstacleFactory.createBlackHole())
                    } else {
                        let blackHoles = node.childNodes.filter { node in
                            node.name == "blackHole"
                        }
                        
                        for blackHole in blackHoles {
                            blackHole.position.x = ObstacleFactory.randomPosition(width: 2.9)
                        }
                    }
                }
            }
        }
    }
    
    func createTimer() {
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
        
        label.textColor = .white
        label.font = UIFont(name: "Arial", size: 30)
        label.text = "Score: \(self.sumTimer)"
        label.frame = CGRect(x: 40, y: 20, width: 250, height: 50)
        
        let scnView = self.view as! SCNView
        scnView.addSubview(label)
    }
    
    @objc func runTimer() -> Int {
        sumTimer += 1
        label.text = "Score: \(self.sumTimer)"
        return sumTimer
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
