//
//  Scroll.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/21/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class Scroll {
    
    static func scrollWater(camera: SKCameraNode, scrollNode: SKNode) {
        let waterScrollSpeed = CGFloat(3)
        
        scrollNode.position.x -= waterScrollSpeed
        
        for water in scrollNode.children as! [SKSpriteNode] {
            let waterPosition = scrollNode.convertPoint(water.position, toNode: camera)
            
            if(waterPosition.x <= -water.size.width) {
                /* In the case that waterPosition.x < -water.size.width, there will be a slight
                 gap between the two water sprites. difference accounts for this gap */
                let difference = waterPosition.x - (-water.size.width)
                let newPosition = CGPoint(x: water.size.width + difference, y: waterPosition.y)
                water.position = camera.convertPoint(newPosition, toNode: scrollNode)
            }
        }
    }

    static func scrollIceberg(iceberg: SKSpriteNode, cameraDisplacement: CGFloat) {
        iceberg.position.x -= cameraDisplacement * 0.1
        
        let icebergPosition = iceberg.position
        
        if(icebergPosition.x < -iceberg.size.width) {
            let newPosition = CGPoint(x: iceberg.size.width + 25, y: icebergPosition.y)
            iceberg.position = newPosition
        }
    }
}
