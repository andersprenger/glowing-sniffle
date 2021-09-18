//
//  ObstaclesFactory.swift
//  RunningX
//
//  Created by Anderson Renan Paniz Sprenger on 17/09/21.
//

import Foundation
import SceneKit
import GameplayKit

struct ObstaclesFactory {
    let blackHoleName = "blackHole"
    let obstacleName = "obstacle"
    let obstaclesHeight : CGFloat = 4.5
    let obstacleWidth : CGFloat = 0.1
    let totalTopObstacleSize : CGFloat = 8.8 + 0.1 // tamanho do chao + obstacle width + um pouco pra fora
    let obstaclesCategory : Int = 1 << 1
    let squareSide: Float =  2
    let ballLevel: Float = Float(ScenaryFactory.groundHeight) / 2 + Float(PlayerFactory.ballRadius)
    
    func createBlackHole(position: Float = .zero) -> SCNNode {
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
        blackHole.name = blackHoleName
        blackHole.position.x = position
        
        return blackHole
    }
    
    func makeObstacles() -> SCNNode {
//        var percent: Float  = Float(GKRandomSource.sharedRandom().nextInt() / 100)
//        let randomPlace = percent * Float(ScenaryFactory.groundWidth - squareSide) + Float(squareSide) / 2
//        
        // MARK: -- big rectangle
        
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
        
        // MARK: -- litle square obstacle

//        let topSquareObstaclePole = SCNNode(geometry: SCNBox(width: (squareSide) + obstacleWidth, height: obstacleWidth , length: 0.05, chamferRadius: 0.0))
        
//        let yObstacleTop : Float = ballLevel + Float(ScenaryFactory.groundHeight)/2 + (Float(squareSide) ) - Float(PlayerFactory.ballRadius)
//
//        topSquareObstaclePole.position = SCNVector3(x: 0 + randomPlace , y: yObstacleTop, z: -10)
//        topSquareObstaclePole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "horizontalGreen")
//        topSquareObstaclePole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
//        topSquareObstaclePole.geometry?.firstMaterial?.emission.intensity = 0.5
//
//        let leftSquareObstaclePole = SCNNode(geometry: SCNBox(width: obstacleWidth, height: ( squareSide) , length: 0.05, chamferRadius: 0.0))
//        let yObstacleLeft = ballLevel + Float(Float(ScenaryFactory.groundHeight)/2) +  Float(ScenaryFactory.squareSide) / 2 - Float(PlayerFactory.ballRadius)
//        let xLeftlitleSquarePosition = -Float(squareSide / 2) + randomPlace
//        leftSquareObstaclePole.position = SCNVector3(x: xLeftlitleSquarePosition , y: yObstacleLeft, z: -10)
//        leftSquareObstaclePole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
//        leftSquareObstaclePole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
//        leftSquareObstaclePole.geometry?.firstMaterial?.emission.intensity = 0.5
//
//        let rightSquareObstaclePole = SCNNode(geometry: SCNBox(width: obstacleWidth, height: ( squareSide) , length: 0.05, chamferRadius: 0.0))
//        let yObstacleRight : Float = ballLevel + ScenaryFactory.groundHeight/2 +  ScenaryFactory.squareSide / 2 - PlayerFactory.ballRadius
//
//        rightSquareObstaclePole.position = SCNVector3(x: Float(squareSide / 2) + randomPlace, y: yObstacleRight, z: -10)
//        rightSquareObstaclePole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
//        rightSquareObstaclePole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
//        rightSquareObstaclePole.geometry?.firstMaterial?.emission.intensity = 0.5
//
//        let leftDownPoleWidth : CGFloat = ScenaryFactory.groundWidth * CGFloat(percent)/100 - (ObstaclesFactory.obstacleWidth) - 0.1
//        let leftDownPoleXPosition : Float =   ( -Float(ScenaryFactory.groundWidth)/2 + xLeftlitleSquarePosition) / 2 - Float(ScenaryFactory.obstacleWidth) - 0.1
//        let rightDownPoleWidth : CGFloat = ScenaryFactory.groundWidth - leftDownPoleWidth - 0.35
//        let rightDownPoleXPosition : Float = rightSquareObstaclePole.position.x + (Float(rightDownPoleWidth) / 2) - Float(obstacleWidth)/2
        
        // MARK: -- down poles
        
//        let downLeftPole = SCNNode(geometry: SCNBox(width:  leftDownPoleWidth , height: 0.2, length: 0.2, chamferRadius: 0.0))
//        downLeftPole.position = SCNVector3(x: leftDownPoleXPosition , y:  yObstacleRight - ( Float(squareSide) / 2 ) , z: -10)
//        downLeftPole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "horizontalGreen")
//        downLeftPole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
//        downLeftPole.geometry?.firstMaterial?.emission.intensity = 0.5
//        downLeftPole.name = "baixo"
//
//        let downLeftPoleBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: SCNBox(width:  leftDownPoleWidth , height: 0.2, length: 0.2, chamferRadius: 0.0), options: nil))
//        downLeftPoleBody.categoryBitMask = 00000010
//
//        downLeftPole.physicsBody = downLeftPoleBody
//
//        let downRightPole = SCNNode(geometry: SCNBox(width: rightDownPoleWidth , height: obstacleWidth , length: 0.2, chamferRadius: 0.0))
//        downRightPole.position = SCNVector3(x: rightDownPoleXPosition, y: yObstacleRight - ( Float(squareSide) / 2 ) , z: -10)
//        downRightPole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "horizontalGreen")
//        downRightPole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
//        downRightPole.geometry?.firstMaterial?.emission.intensity = 0.5
//        downRightPole.name = "baixo"
//
//        let downRightPoleBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: SCNBox(width: rightDownPoleWidth , height: obstacleWidth , length: 0.2, chamferRadius: 0.0), options: nil))
//        downRightPoleBody.categoryBitMask = 00000010
//
//        downRightPole.physicsBody = downRightPoleBody

        let node = SCNNode()
        node.name = "obstacle"
        node.addChildNode(leftPole)
        node.addChildNode(rightPole)
        node.addChildNode(topPole)
//        node.addChildNode(topSquareObstaclePole)
//        node.addChildNode(leftSquareObstaclePole)
//        node.addChildNode(rightSquareObstaclePole)
        
//        node.addChildNode(downLeftPole)
//        node.addChildNode(downRightPole)
        node.position = SCNVector3(x: 0, y: 0, z: 0)
        
        return node
    }
}
