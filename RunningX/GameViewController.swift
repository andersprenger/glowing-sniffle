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

class GameViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    // bg player
    var videoURL : URL! = nil
    var videoPlayer : AVPlayer! = nil
    
    //music
    let musicHelper =  MusicHelper()
    
    var ball : SCNNode! = nil
    
    // timer
    public var somaTimer = 0
    @objc func runTimer() -> Int {
        somaTimer += 1
        label.text = "Score: \(self.somaTimer)"
        return somaTimer
    }
    
    // general vars
    private var t: Float = 0
    var motionManager = CMMotionManager()
    var updateRate : Double = 1/60
    var yaw : Double = 0
    
    
    
    // ground
    
    
    // obstacles
    let obstaclesHeight : CGFloat = 4.5
    let obstacleWidth : CGFloat = 0.1
    let totalTopObstacleSize : CGFloat = 8.8 + 0.1 // tamanho do chao + obstacle width + um pouco pra fora
    let obstaclesCategory : Int = 1 << 1
    
    let scenaryFactory = ScenaryFactory()
    let playerFactory = PlayerFactory()
    let obstaclesFactory = ObstaclesFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 5 , z: 0)
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
        scnView.debugOptions = .showPhysicsShapes
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // init bg player
        self.videoURL = Bundle.main.url(forResource: "sky_animation_2", withExtension: "mov")!
        self.videoPlayer = AVPlayer(url: videoURL)
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        scene.background.contents = videoPlayer
        scene.background.wrapS = .repeat
        scene.background.wrapT = .repeat
        
        videoPlayer.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer.currentItem, queue: .main) { [weak self] _ in
            self?.videoPlayer?.seek(to: CMTime.zero)
            self?.videoPlayer?.play()
        }
        
        // set itself as delegate
        scnView.delegate = self
        scnView.scene?.physicsWorld.contactDelegate = self
        
        // init functions
        ball = playerFactory.createBall()
        scnView.scene?.rootNode.addChildNode(ball)
        
        scenaryFactory.createScenary(in: scnView.scene!)
        musicHelper.playMusic()
        createTimer()
        startInput()
    }
    
    // MARK: -- Update
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        moveScenrary()
        
        self.t += 0.1
        ball.position = SCNVector3(x: Float(yaw) * 0.1, y: 0 , z: -3)
    }
    
    func startInput(){
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = 0.01
            motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: .main){ (data, error) in
                guard let validData = data else{return}
                
                self.yaw = validData.attitude.pitch * 58
            }
        }
    }
    
    
    // MARK: -- Functions
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        // TODO: handle game over
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
            
            physicsNodes?.forEach{ node in
                node.physicsBody?.resetTransform()
            }
            
            for node in nodes! {
                node.position.z += 0.2
                
                if node.position.z > Float(20) {
                    node.position.z -= 6 * 120
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
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}
