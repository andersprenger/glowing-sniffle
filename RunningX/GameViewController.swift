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

class GameViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    // game scene
    var gameScene: SCNScene!
    
    // media
    var mediaPlayer: MediaPlayer = MediaPlayer()
    
    // ball
    var ball: SCNNode!
    
    // timer
    private var timer: Timer? = nil
    public var score: Int = 0
    
    // speed
    var speed: Float = 0.2
    
    // imput helper vars
    var motionManager = CMMotionManager()
    var updateRate: Double = 1/60
    var yaw: Double = 0
    
    // segues identifiers
    let gameOverSegueID = "game-gameover-segue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        gameScene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        gameScene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 2, z: 0)
        cameraNode.eulerAngles.x = -1/6
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        gameScene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        gameScene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = gameScene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
//        scnView.showsStatistics = true
//        scnView.debugOptions = .showPhysicsFields
        
        // init media stuff
        mediaPlayer.playMusic()
        mediaPlayer.playVideo()
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        gameScene.background.contents = mediaPlayer.videoPlayer
        gameScene.background.wrapS = .repeat
        gameScene.background.wrapT = .repeat
        
        // set itself as delegate
        scnView.delegate = self
        scnView.scene?.physicsWorld.contactDelegate = self
        
        // init functions
        BallFactory.createBall { ball in
            self.ball = ball
            scnView.scene?.rootNode.addChildNode(ball)
        }
        
        ScenaryFactory.createScenary { node in
            scnView.scene?.rootNode.addChildNode(node)
        }
        
        createTimer()
        startControl()
    }
    
    // MARK: -- handle collisions
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        speed = 0
        timer?.invalidate()
        
        self.gameScene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        self.gameScene.rootNode.removeFromParentNode()
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: self.gameOverSegueID, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameOverView = segue.destination as? GameOverViewController {
            gameOverView.score = score
        }
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
            
            let physicsNodes =  scnView.scene?.rootNode.childNodes { node, _ in
                node.physicsBody != nil
            }
            
            physicsNodes?.forEach { node in
                node.physicsBody?.resetTransform()
            }
            
            for node in nodes! {
                node.position.z += self.speed
                
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
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
        
        label.textColor = .white
        label.font = UIFont(name: "Arial", size: 30)
        label.text = "Score: \(self.score)"
        label.frame = CGRect(x: 40, y: 20, width: 250, height: 50)
        
        let scnView = self.view as! SCNView
        scnView.addSubview(label)
    }
    
    @objc func runTimer() -> Int {
        score += 1
        label.text = "Score: \(self.score)"
        return score
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
