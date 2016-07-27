//
//  GameOverState.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/18/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameOverState: GKState {    
    unowned let scene: GameScene
    let gameoverOverlay = FinishScreen()
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.physicsWorld.removeAllJoints()
        scene.hero.physicsBody!.velocity.dx = 0
        
        self.gameoverOverlay.percentageCompleteLabel.text = scene.distanceTravelledLabel.text
        scene.distanceTravelledLabel.removeFromParent()
        
        if(gameoverOverlay.parent == nil) {
            /* Moves the gameoverOverlay onscreen */
            gameoverOverlay.position.y = 300
            gameoverOverlay.runAction(SKAction.moveToY(50, duration: 0.5))
            scene.camera!.addChild(gameoverOverlay)
        }
    }
    
}
