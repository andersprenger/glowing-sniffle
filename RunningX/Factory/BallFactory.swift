//
//  BallFactory.swift
//  RunningX
//
//  Created by Anderson Renan Paniz Sprenger on 18/09/21.
//

import Foundation
import SceneKit

struct BallFactory {
    static let name: String = "ball"
    static let ballRadius: Float = 0.3

    static func createBall(completionHandler: (_ ball: SCNNode) -> ()) {
        let ball = SCNNode(geometry: SCNSphere(radius: CGFloat(ballRadius)))

        ball.name = name
        ball.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        ball.geometry?.firstMaterial?.emission.contents = UIColor.red

        completionHandler(ball)
    }
}
