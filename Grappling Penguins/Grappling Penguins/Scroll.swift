//
//  Scroll.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/21/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class Scroll {
    
    static func scrollWater(scene: GameScene) {
        let waterScrollSpeed = CGFloat(3)
        
        scene.waterScrollNode.position.x -= waterScrollSpeed
        
        for water in scene.waterScrollNode.children as! [SKSpriteNode] {
            let waterPosition = scene.waterScrollNode.convertPoint(water.position, toNode: scene.camera!)
            
            if(waterPosition.x <= -scene.frame.width) {
                /* In the case that waterPosition.x < -water.size.width, there will be a slight
                 gap between the two water sprites. difference accounts for this gap */
                let difference = waterPosition.x - (-water.size.width)
                let newPosition = CGPoint(x: water.size.width + difference, y: waterPosition.y)
                water.position = scene.camera!.convertPoint(newPosition, toNode: scene.waterScrollNode)
            }
        }
    }

    static func scrollIceberg(scene: GameScene, oldCameraPositionRelativeToScene: CGPoint) {
        let currentCameraPosition = scene.camera!.convertPoint(scene.camera!.position, toNode: scene)
        let cameraDistanceMoved = currentCameraPosition.x - oldCameraPositionRelativeToScene.x
        
        scene.iceberg.position.x -= cameraDistanceMoved * 0.05
        
        let icebergPosition = scene.iceberg.position
        
        if(icebergPosition.x < -546.5) {
            let newPosition = CGPoint(x: 546.5, y: icebergPosition.y)
            scene.iceberg.position = newPosition
        }
    }
}
