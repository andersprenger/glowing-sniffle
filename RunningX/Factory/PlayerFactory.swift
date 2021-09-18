//
//  PlayerFactory.swift
//  RunningX
//
//  Created by Anderson Renan Paniz Sprenger on 17/09/21.
//

import Foundation
import SceneKit

struct PlayerFactory {
    static let ballRadius : Float = 0.3
    static let name : String = "ball"
    
    func createBall() -> SCNNode {
        let ball = SCNNode(geometry: SCNSphere(radius: 0.3))
        ball.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        ball.geometry?.firstMaterial?.emission.contents = UIColor.red
        ball.position = SCNVector3(x: .zero, y:1 , z: -3)
        ball.name = PlayerFactory.name
        
//        let physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: SCNSphere(radius: CGFloat(PlayerFactory.ballRadius)), options: nil))
//        physicsBody.categoryBitMask = 00000001
//        physicsBody.contactTestBitMask = 00000011
//        ball.physicsBody = physicsBody
        
        return ball
    }
}
