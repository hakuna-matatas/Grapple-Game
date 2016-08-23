//
//  ReadyState.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/18/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import GameplayKit
import SpriteKit

class ReadyState: GKState {
    
    unowned let scene: GameScene
    
    let instructions: SKSpriteNode!
    
    
    init(scene: GameScene) {
        self.scene = scene
        
        instructions = SKSpriteNode(imageNamed: "Instructions")
        scene.hero.texture = scene.STATIONARY_TEXTURE
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        instructions.position = CGPoint(x: scene.frame.width/2, y: scene.frame.height/2)
        instructions.zPosition = 10
        scene.addChild(instructions)
    }
    
    override func willExitWithNextState(nextState: GKState) {
        instructions.removeFromParent()
    }
    
}