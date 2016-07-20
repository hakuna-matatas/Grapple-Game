//
//  PlayingState.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/18/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import GameplayKit
import SpriteKit

class PlayingState: GKState {
 
    unowned let scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.camera!.position = CGPoint(x: scene.hero.position.x, y: scene.camera!.position.y)
        scene.camera!.position.x.clamp(283, scene.levelNode.levelWidth)

        
        if(scene.hero.physicsBody?.velocity.dx == 0) {
            scene.hero.texture = scene.NORMAL_TEXTURE
        }
        
        if let _ = scene.grapplingHook {
            let startPoint = scene.convertPoint(scene.hero.position, toNode: scene.grapplingHook!)
            let endPoint = scene.convertPoint(scene.grapplingHook!.position, toNode: scene.grapplingHook!)
            scene.grapplingHook!.animateGrapplingHook(startPoint, endPoint: endPoint)
            
            if(startPoint.distance(endPoint) > scene.grapplingHook!.GRAPPLING_HOOK_MAX_LENGTH) {
                scene.grapplingHook!.removeFromParent()
            }
        }
    }
    
}