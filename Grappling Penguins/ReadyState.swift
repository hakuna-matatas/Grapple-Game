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
    
    let jumpLabel: SKLabelNode = SKLabelNode()
    let JUMP_LABEL_POSITION: CGPoint!
    let hookLabel: SKLabelNode = SKLabelNode()
    let HOOK_LABEL_POSITION: CGPoint!
    
    
    init(scene: GameScene) {
        self.scene = scene
        
        let QUARTER_SCREEN = scene.size.width/4
        JUMP_LABEL_POSITION = CGPoint(x: scene.camera!.position.x - QUARTER_SCREEN,
                                      y: (scene.size.height / 2))
        HOOK_LABEL_POSITION = CGPoint(x: scene.camera!.position.x + QUARTER_SCREEN,
                                      y: (scene.size.height / 2))
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        jumpLabel.text = "Jump"
        jumpLabel.fontSize = 20
        jumpLabel.fontColor = SKColor.blackColor()
        jumpLabel.position = JUMP_LABEL_POSITION
        scene.addChild(jumpLabel)
        
        hookLabel.text = "Grappling hook"
        hookLabel.fontSize = 20
        hookLabel.fontColor = SKColor.blackColor()
        hookLabel.position = HOOK_LABEL_POSITION
        scene.addChild(hookLabel)
    }
    
    override func willExitWithNextState(nextState: GKState) {
        jumpLabel.removeFromParent()
        hookLabel.removeFromParent()
    }
    
}