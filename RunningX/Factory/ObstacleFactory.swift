//
//  ObstacleFactory.swift
//  RunningX
//
//  Created by Anderson Renan Paniz Sprenger on 18/09/21.
//

import Foundation
import SceneKit
import GameplayKit

struct ObstacleFactory {
    // obstacles
    static let obstaclesHeight: CGFloat = 4.5
    static let obstacleWidth: CGFloat = 0.1
    static let totalTopObstacleSize: CGFloat = 8.8 + 0.1 // tamanho do chao + obstacle width + um pouco pra fora
    
    private static func randomPercent() -> Float {
        Float(GKRandomSource.sharedRandom().nextInt(upperBound: 100)) / Float(100)
    }
    
    static func randomPosition(width: Float, percent: Float? = nil) -> Float {
        guard let check = percent else {
            return ((Float(ScenaryFactory.groundWidth) - width) * randomPercent() + width / 2) - Float(ScenaryFactory.groundWidth) / 2
        }
        
        return ((Float(ScenaryFactory.groundWidth) - width) * check + width / 2) - Float(ScenaryFactory.groundWidth) / 2
    }
    
    static func createBlackHole() -> SCNNode {
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
        blackHole.position.x = randomPosition(width: 2.9)
        
        return blackHole
    }
    
    static func makeObstacles() -> SCNNode {
        let squareSide: CGFloat =  CGFloat(BallFactory.ballRadius * 4.5)
        let randomGroundPercent = randomPercent()
        let randomPlace = ObstacleFactory.randomPosition(width: Float(squareSide), percent: randomGroundPercent)
        
        
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
        
        let bigRetangle = SCNNode()
        bigRetangle.addChildNode(leftPole)
        bigRetangle.addChildNode(rightPole)
        bigRetangle.addChildNode(topPole)

        // square obstacle

        let topSquareObstaclePole = SCNNode(geometry: SCNBox(width: (squareSide) + obstacleWidth   , height: obstacleWidth , length: 0.05, chamferRadius: 0.0))
        
        let yObstacleTop : Float = BallFactory.ballHeight + Float(ScenaryFactory.groundHeight)/2 + (Float(squareSide) ) - Float(BallFactory.ballRadius)
        
        topSquareObstaclePole.position = SCNVector3(x: randomPlace - Float(obstacleWidth) + Float(squareSide)/2, y: yObstacleTop, z: -10)
        topSquareObstaclePole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "horizontalGreen")
        topSquareObstaclePole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        topSquareObstaclePole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        let leftSquareObstaclePole = SCNNode(geometry: SCNBox(width: obstacleWidth, height: ( squareSide) , length: 0.05, chamferRadius: 0.0))
        let yObstacleLeft : Float = BallFactory.ballHeight + Float(ScenaryFactory.groundHeight)/2 +  Float(squareSide) / 2 - Float(BallFactory.ballRadius)
        let xLeftlitleSquarePosition = randomPlace - Float(obstacleWidth)//-Float(squareSide / 2) + randomPlace
        leftSquareObstaclePole.position = SCNVector3(x: xLeftlitleSquarePosition , y: yObstacleLeft, z: -10)
        leftSquareObstaclePole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
        leftSquareObstaclePole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        leftSquareObstaclePole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        let rightSquareObstaclePole = SCNNode(geometry: SCNBox(width: obstacleWidth, height: ( squareSide) , length: 0.05, chamferRadius: 0.0))
        let yObstacleRight : Float = BallFactory.ballHeight + Float(ScenaryFactory.groundHeight)/2 +  Float(squareSide) / 2 - Float(BallFactory.ballRadius)
  
        rightSquareObstaclePole.position = SCNVector3(x: randomPlace - Float(obstacleWidth) + Float(squareSide), y: yObstacleRight, z: -10)

//        rightSquareObstaclePole.position = SCNVector3(x: Float(squareSide / 2) + randomPlace, y: yObstacleRight, z: -10)
        rightSquareObstaclePole.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "linha3")
        rightSquareObstaclePole.geometry?.firstMaterial?.emission.contents = UIColor(named: "lateralGreen")
        rightSquareObstaclePole.geometry?.firstMaterial?.emission.intensity = 0.5
        
        let squareObstacle = SCNNode()
        squareObstacle.addChildNode(topSquareObstaclePole)
        squareObstacle.addChildNode(leftSquareObstaclePole)
        squareObstacle.addChildNode(rightSquareObstaclePole)
//        squareObstacle.position.x = ObstacleFactory.randomPosition(width: Float((squareSide) + obstacleWidth))
        
        // down poles
        
        let leftDownPoleWidth : CGFloat = CGFloat(ScenaryFactory.groundWidth * randomGroundPercent) - (obstacleWidth) - 0.1
        let leftDownPoleXPosition : Float =   ( -Float(ScenaryFactory.groundWidth)/2 + xLeftlitleSquarePosition) / 2 - Float(obstacleWidth) - 0.1

        let rightDownPoleWidth : CGFloat = CGFloat(ScenaryFactory.groundWidth) - leftDownPoleWidth - 0.35
        let rightDownPoleXPosition : Float = rightSquareObstaclePole.position.x + (Float(rightDownPoleWidth) / 2) - Float(obstacleWidth)/2

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
        node.addChildNode(bigRetangle)
        node.addChildNode(squareObstacle)
        
        node.addChildNode(downLeftPole)
        node.addChildNode(downRightPole)
        
        node.position = SCNVector3(x: 0, y: 0, z: 0)
        
        return node
    }
}
