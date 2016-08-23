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
    var hero: SKSpriteNode!
    var camera : SKCameraNode!
    
    var distanceTravelled: Int = 0 {
        didSet {
            updateDifficulty()
            
            scoreNode.removeAllChildren()
            Numbers.createNumberSprite(&scoreNode, score: distanceTravelled, isMainScore: false, spaceFromFirstNum: 0)
        }
    }
    var scoreNode = SKNode()
    
    init(scene: GameScene) {
        self.scene = scene
        
        self.hero = scene.hero
        self.camera = scene.camera!
        
        self.camera.addChild(scoreNode)
        scoreNode.zPosition = 5
        scoreNode.position = CGPoint(x: -310, y: 160)
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        if(self.hero.physicsBody?.velocity.dx == 0) {
            self.hero.texture = scene.STATIONARY_TEXTURE
            hero.removeAllActions()
        }
        
        distanceTravelled = Int(self.hero.position.x)/100
        
        if let _ = scene.grapplingHook {
            /* Draws a line from the hero to the grappling hook */
            let startPoint = scene.convertPoint(self.hero.position, toNode: scene.grapplingHook!)
            let endPoint = scene.convertPoint(scene.grapplingHook!.position, toNode: scene.grapplingHook!)
            scene.grapplingHook!.animateGrapplingHook(startPoint, endPoint: endPoint)
            
            /* Limits the length of the grappling hook */
            if(startPoint.distance(endPoint) > scene.grapplingHook!.GRAPPLING_HOOK_MAX_LENGTH &&
               !scene.grapplingHook.isConnected) {
                scene.grapplingHook!.removeFromParent()
            }
        }
        
        /* Hero dies if he falls below screen. -10 is just to give a small buffer */
        if self.hero.position.y < -10 {
            scene.gameState.enterState(GameOverState)
        }
        
        /* Prevents the hero from going over the screen, or backwards */
        if(self.hero.position.y >= 355) {
            self.hero.physicsBody!.velocity.dy = -100
        }
        if(self.hero.position.x <= (self.camera!.position.x - 333.5)) {
            self.hero.physicsBody!.applyImpulse(CGVector(dx: 5, dy: 0))
        }
    }
    
    func updateDifficulty() {
        switch self.distanceTravelled {
        case 8:
            scene.distanceBwClouds = 125
        default:
            break
        }
    }
}