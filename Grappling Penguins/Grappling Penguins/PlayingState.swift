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
        /* The camera follows the penguin */
        scene.camera!.position = CGPoint(x: scene.hero.position.x + 237, y: scene.camera!.position.y)
        
        if let _ = scene.grapplingHook {
            /* Draws a line from the hero to the grappling hook */
            let startPoint = scene.convertPoint(scene.hero.position, toNode: scene.grapplingHook!)
            let endPoint = scene.convertPoint(scene.grapplingHook!.position, toNode: scene.grapplingHook!)
            scene.grapplingHook!.animateGrapplingHook(startPoint, endPoint: endPoint)
            
            /* Limits the length of the grappling hook */
            if(startPoint.distance(endPoint) > scene.grapplingHook!.GRAPPLING_HOOK_MAX_LENGTH) {
                scene.grapplingHook!.removeFromParent()
            }
        }
    }
    
}